# init.pp --- Class resolv_conf
#
# @summary Manage the DNS resolver configuration file /etc/resolv.conf
#
# @example Create resolver config file using default parameters
#
#   class { resolv_conf': }
#
# @example Create resolver config file with specific nameservers
#
#   class { resolv_conf':
#     nameservers => [ '8.8.8.8', '8.8.4.4', ],
#   }
#
# @example Create resolver config file with specific nameservers & options
#
#   class { resolv_conf':
#     nameservers => [ '8.8.8.8', '8.8.4.4', ],
#     options     => [ 'rotate', 'timeout:2, ],
#   }
#
# @example Create resolver config file where a local nameserver is prefered
#
#   class { resolv_conf':
#     nameservers              => [ '8.8.8.8', '8.8.4.4', ],
#     prepend_local_nameserver => true,
#   }
#
# @param nameservers
#   An array of nameservers that the resolver should query for hostname
#   lookups. A maximum number of three nameservers can be specified. The
#   default value is a single element array containing '127.0.0.1'.
#
# @param domainname
#   A string that is the primary domain of the host. Unqualified lookups will
#   append this string to the query host. This parameter cannot be used
#   together with 'searchlist'.
#
# @param searchlist
#   An array of domains that the resolver will search. A maximum of 6 domains
#   can be specified. This parameter cannot be used together with
#   'domainname'.
#
# @param sortlist
#   An array of up to 10 IP/netmask items. These are used by the resolver to
#   sort the result in case multiple addresses are returned.
#
# @param options
#   An array of option settings for the resolver. Each array element must be
#   the option to include in the configuration. The following options are
#   recognized: 'ndots:n', 'timeout:n', 'attempts:n', 'debug', 'edns0',
#   'inet6', 'ip6-bytestring', 'ip6-dotint', 'no-ip6-dotint',
#   'no-check-names', 'rotate', 'single-request', 'single-request-reopen'.
#   The first three options are expected to use a numeric value for 'n' after
#   the colon. Check the man page 'resolv.conf(5)' for details.
#
# @param prepend_local_nameserver
#   A boolean value that determines if a local DNS server should be used
#   first. Setting this parameter to 'true' will add '127.0.0.1' before the
#   servers given as 'nameservers'. The last nameserver is silently ignored
#   if this would create a configuration with more than three servers. The
#   default value is 'false'.
#
# @param resolv_conf_file
#   The absolute path of the file to manage. The default is
#   '/etc/resolv.conf'. In general it does not make sense to change this
#   parameter.
#
# @param owner
#   The owner of the file '/etc/resolv.conf'. The default is 'root'.
#
# @param group
#   The group of the file '/etc/resolv.conf'. The default is 'root' on Linux
#   and 'wheel' on FreeBSD.
#
# @param mode
#   The file mode of the file '/etc/resolv.conf'. The default is '0644'.
#
class resolv_conf(
  Array[String,0,3]          $nameservers,
  Stdlib::Absolutepath       $resolv_conf_file,
  Array[String,0,6]          $searchlist               = [],
  Array[String,0,10]         $sortlist                 = [],
  Array[String]              $options                  = [],
  Boolean                    $prepend_local_nameserver = false,
  Optional[String]           $domainname               = undef,
  Optional[String]           $owner                    = undef,
  Optional[String]           $group                    = undef,
  Optional[Stdlib::Filemode] $mode                     = undef,
) {

  #
  # The domain and search keywords are mutually exclusive. If more than one
  # instance of these keywords is present, the last instance wins.
  #
  if !empty($domainname) and !empty($searchlist) {
    fail('The searchlist and domain settings are mutually exclusive.')
  }

  #
  # Prepend a local nameserver if requested. In this case use only up to two
  # nameservers from the provided list of servers.
  #
  $_nameservers = $prepend_local_nameserver ? {
    true    => concat([ '127.0.0.1' ], $nameservers[0,2]),
    default => $nameservers,
  }

  #
  # Validate options.
  #
  $options.each |$option| {
    case $option {
      /^ndots:[0-9]+$/, /^timeout:[0-9]+$/, /^attempts:[1-5]$/,
      /^reload-period:[0-9]+$/,
      'debug', 'edns0', 'inet6', 'ip6-bytestring', 'ip6-dotint',
      'no-ip6-dotint', 'no-check-names', 'no_tld_query', 'rotate',
      'single-request', 'single-request-reopen': { }
      default: {
        fail("Invalid option: ${option}")
      }
    }
  }

  #
  # Manage resolv.conf
  #
  file { $resolv_conf_file:
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => epp('resolv_conf/resolv.conf.epp', {
      nameservers => $_nameservers,
      sortlist    => $sortlist,
      searchlist  => $searchlist,
      domainname  => $domainname,
      options     => $options,
    }),
  }
}
