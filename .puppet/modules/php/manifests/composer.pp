class php::composer {

    require ::php::dev

    file { '/tmp/composer.installer':
        source => 'puppet:///modules/php/installer',
        mode   => 0755,
    }

    exec { 'php::composer::install':
        command => 'php /tmp/composer.installer --install-dir=/usr/local/bin --filename=composer',
        creates => '/usr/local/bin/composer',
        require => File['/tmp/composer.installer'],
    }

}
