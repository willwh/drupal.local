class ssh::server (
    $port = 22,
    $permitrootlogin = 'yes',
    $rsaauthentication = 'yes',
    $pubkeyauthentication = 'yes',
    $authorizedkeysfile = '%h/.ssh/authorized_keys',
    $passwordauthentication = 'yes',
    $usedns = 'no',
    $gatewayports = 'no',
) {

    if !defined(Package['openssh-server']) { package { 'openssh-server': } }

    file { '/etc/ssh/sshd_config':
        content => template('ssh/etc/ssh/sshd_config.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        notify  => Service['ssh'],
        require => Package['openssh-server'],
    }

    service { 'ssh':
        ensure  => running,
        enable  => true,
        require => Package['openssh-server'],
    }

}
