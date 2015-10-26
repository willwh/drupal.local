define drush::instance (
    $version = $title,
    $installdir = '/usr/local/share',
) {

    require ::git
    require ::php::composer
    require ::wget

    if !defined(Package['php-console-table']) { package { 'php-console-table': } }

    if !defined(Exec["drush::download::${version}"]) {
        exec { "drush::download::${version}":
            command => "wget -q -O - https://github.com/drush-ops/drush/archive/${version}.tar.gz | tar -C ${installdir} -zxf -",
            creates => "${installdir}/drush-${version}",
            require => Package['php-console-table'],
        }
    }

    if !defined(Exec["drush::install::${version}"]) {
        exec { "drush::install::${version}":
            command     => 'composer install',
            cwd         => "${installdir}/drush-${version}",
            creates     => "${installdir}/drush-${version}/vendor",
            require     => Exec["drush::download::${version}"],
            environment =>  'HOME=/root',
        }
    }

}
