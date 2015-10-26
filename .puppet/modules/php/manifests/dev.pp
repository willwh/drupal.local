class php::dev {

    include ::php

    if !defined(Package['php5-dev']) { package { 'php5-dev': } }

}
