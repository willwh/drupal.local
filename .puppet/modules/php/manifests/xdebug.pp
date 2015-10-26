class php::xdebug (
    $max_nesting_level = 100,
) {

    if !defined(Package['php5-xdebug']) { package { 'php5-xdebug': require => Package['php5-cli'] } }

    file { '/etc/php5/mods-available/xdebug.ini':
        content => template('php/etc/php5/mods-available/xdebug.ini.erb'),
        require => Package['php5-xdebug'],
        notify  => Exec['php::restart'],
    }

    exec { 'php::xdebug::enable':
        provider => 'shell',
        command  => 'php5enmod -s ALL xdebug',
        onlyif   => 'for x in `php5query -S`; do if [ ! -f /etc/php5/$x/conf.d/20-xdebug.ini ]; then echo "onlyif"; fi; done | grep onlyif',
        require  => File['/etc/php5/mods-available/xdebug.ini'],
        notify   => Exec['php::restart'],
    }

}
