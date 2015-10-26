class puppet (
    $cron = true,
    $service = false,
) {

    cron { 'puppet':
        ensure  => $cron ? {
            true  => 'present',
            false => 'absent',
        },
        command => '/usr/bin/puppet agent --onetime --no-daemonize --logdest syslog > /dev/null 2>&1',
        user    => 'root',
        minute  => fqdn_rand(60),
    }

    service { 'puppet':
        ensure  => $service ? {
            true  => 'running',
            false => 'stopped',
        },
        enable  => $service,
    }

}
