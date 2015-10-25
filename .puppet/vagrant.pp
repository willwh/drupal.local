# Global Defaults
Exec {
    path      => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    logoutput => on_failure,
    timeout   => 0,
}

Service {
    hasrestart => true,
    hasstatus  => true,
}

Package {
    ensure => present,
}

File {
    ensure => present,
}

node default {
    class { 'puppet':
        cron => false,
    }
    class { 'apache': }
    class { 'apache::mod::deflate': }
    class { 'apache::mod::expires': }
    class { 'apache::mod::headers': }
    class { 'apache::mod::php5': }
    class { 'apache::mod::rewrite': }
    class { 'avahi': }
    class { 'drush': 
        version => '8.0.0-rc2',
    }
    class { 'mutt': }
    class { '::php': }
    class { '::php::curl': }
    class { '::php::gd': }
    class { '::php::imagick': }
    class { '::php::intl': }
    class { '::php::mcrypt': }
    class { '::php::memcached': }
    class { '::php::mysql': }
    class { '::php::mysqli': }
    class { '::php::oauth': }
    class { '::php::opcache': }
    class { '::php::uploadprogress': }
    class { '::php::xdebug':
        max_nesting_level => 256,
    }
    class { '::php::xmlrpc': }
    class { '::php::xsl': }


# MySQL
    class { 'mysql::server':
	   root_password => 'root',
	   max_allowed_packet => '256M',
    }

    file { '/home/vagrant/.my.cnf':
        source  => '/root/.my.cnf',
        require => Exec['mysql::root::my.cnf'],
    }

# Create a database called 'drupal', and a user:pass, 'drupal/drupal' for mysql, unless the database 'drupal' exists on the VM already - so we don't blow away things we're working on
    exec { 'mysql::database::drupal':
	      command => 'mysql --defaults-file=/root/.my.cnf -e "CREATE DATABASE drupal; GRANT ALL ON drupal.* TO drupal IDENTIFIED BY \'drupal\'; FLUSH PRIVILEGES"',
        require => [Service['mysql'], Exec['mysql::root::my.cnf']],
        unless  => 'mysql --defaults-file=/root/.my.cnf -e "SHOW DATABASES LIKE \'drupal\'" | grep drupal',
    }

    exec { 'drupal::install':
            command => "drush site-install -y standard --db-url='mysql://drupal:drupal@localhost/drupal' --account-name=admin --account-pass=admin",
            cwd => '/var/www/drupal.local/docroot',
            require => [Class['drush'], Exec['mysql::database::drupal']],
            creates => '/var/www/drupal.local/docroot/sites/default/settings.php',
    }

    user { 'vagrant':
        groups  => ['www-data'],
        require => Package['apache2'],
    }


    exec { "ApacheUserChange" :
        command => "sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=vagrant/' /etc/apache2/envvars",
        onlyif  => "grep -c 'APACHE_RUN_USER=www-data' /etc/apache2/envvars",
        require => Package["apache2"],
        notify  => Service["apache2"],
    }

    # Change group
    exec { "ApacheGroupChange" :
        command => "sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=vagrant/' /etc/apache2/envvars",
        onlyif  => "grep -c 'APACHE_RUN_GROUP=www-data' /etc/apache2/envvars",
        require => Package["apache2"],
        notify  => Service["apache2"],
    }

    apache::vhost { 'drupal.local':
        errorlog  => '${APACHE_LOG_DIR}/error.log',
        customlog => '${APACHE_LOG_DIR}/access.log combined',
    }


    file { '/home/vagrant/.drush': 
	      ensure => directory, 
	      owner  => 'vagrant',
    }
}

