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
      'debug', 'edns0', 'inet6', 'ip6-bytestring', 'ip6-dotint',
      'no-ip6-dotint', 'no-check-names', 'rotate',
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
