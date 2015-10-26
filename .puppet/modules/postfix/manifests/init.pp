class postfix (
    $smtpd_arguments = undef,
    $mailname = $::fqdn,
    $myhostname = $::fqdn,
    $mydestination = "$::fqdn, localhost",
    $mynetworks = '127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128',
    $canonical_maps = undef,
    $mailbox_command = undef,
    $smtpd_client_restrictions = undef,
    $milter_default_action = undef,
    $milter_protocol = undef,
    $smtpd_milters = undef,
    $non_smtpd_milters = undef,
) {

    File {
        ensure  => present,
        require => Package['postfix'],
        notify  => Service['postfix'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    if !defined(Package['postfix']) {
        package { 'postfix': }
    }

    service { 'postfix':
        ensure  => running,
        enable  => true,
        require => Package['postfix'],
    }

    file { '/etc/postfix/main.cf':
        content => template('postfix/etc/postfix/main.cf.erb'),
    }

    file { '/etc/postfix/master.cf':
        content => template('postfix/etc/postfix/master.cf.erb'),
    }

    file { '/etc/mailname':
        content => "$mailname\n",
    }
}
