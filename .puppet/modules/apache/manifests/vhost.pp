define apache::vhost (
    $priority = 200,
    $template = undef,

    $http_port = 80,

    $https = false,
    $https_port = 443,
    $hsts = 15552000,
    $sslcertificatefile = undef,
    $sslcertificatekeyfile = undef,
    $sslcertificatechainfile = undef, 
    $sslusestapling = 'On',

    $backend = false,
    $backend_port = 8888,

    $app = undef,

    $servername = $title,
    $serveralias = undef,
    $normalize = true,

    $customlog = undef,
    $errorlog = undef,

    $documentroot = undef,
    $virtualdocumentroot = false,
    $options = 'FollowSymLinks',
    $allowoverride = 'All',
    $directoryindex = 'index.html index.cgi index.pl index.php index.xhtml index.htm',

    $htpasswd = false,
    $authz_require = undef,
    $authbasicprovider = 'file',
    $authldapurl = undef,
    $authldapbinddn = undef,
    $authldapbindpassword = undef,
    $authldapbindauthoritative = undef,

    $limit = undef,
    $limitexcept = undef,

    $php_value = undef,
    $php_flag = undef,

    $rewrite = undef,
    $custom = undef,

    $allowencodedslashes = undef,
    $proxyaddheaders = 'On',
) {

    # Required modules
    include ::apache::mod::rewrite

    if $backend or $app {
        include ::apache::mod::proxy_http
    }

    if $app {
        include ::apache::mod::proxy_wstunnel
    }

    if $https {
        include ::apache::mod::headers
        include ::apache::mod::ssl
    }

    if $virtualdocumentroot {
        include ::apache::mod::vhost_alias
    }

    $docroot = $documentroot ? {
        undef   => "/var/www/${servername}/docroot",
        default => $documentroot,
    }

    $site = $priority ? {
        undef   => "${servername}",
        default => "${priority}-${title}",
    }

    $_customlog = $customlog ? {
        undef   => "\${APACHE_LOG_DIR}/${servername}_access.log vhost_combined",
        default => $customlog
    }

    $_errorlog = $errorlog ? {
        undef   => "\${APACHE_LOG_DIR}/${servername}_error.log",
        default => $errorlog
    }

    $_backend = $backend ? {
        true    => "http://localhost:${backend_port}/",
        default => $backend,
    }

    $_https = $https ? {
        true    => '
            # Force HTTPS
            RewriteRule .* https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]',
        default => $https,
    }

    $template_file = $template ? {
        undef   => 'apache/etc/apache2/sites-available/default.conf.erb',
        default => $template,
    }

    file { "/etc/apache2/sites-available/${site}.conf":
        content => template($template_file),
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

    file { "/etc/apache2/sites-enabled/${site}.conf":
        ensure  => link,
        require => Exec["apache::vhost::a2ensite::${title}"],
    }

    exec { "apache::vhost::a2ensite::${title}":
        command => "a2ensite ${site}",
        creates => "/etc/apache2/sites-enabled/${site}.conf",
        require => File["/etc/apache2/sites-available/${site}.conf"],
        notify  => Service['apache2'],
    }

    if $htpasswd {
        if !defined(File['/etc/apache2/htpasswd']) {
            file { '/etc/apache2/htpasswd':
                ensure  => directory,
                require => Package['apache2'],
            }
        }

        file { "/etc/apache2/htpasswd/${servername}":
            ensure  => present,
            require => File['/etc/apache2/htpasswd'],
        }
    }

}
