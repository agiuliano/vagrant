# Main module
class shark ($hostname, $documentroot, $gitUser, $gitEmail) {
    # Set paths
    Exec {
        path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
    }

    include bootstrap

    class { "composer":
        hostname => $hostname
    }

    # file { "/home/vagrant/.ssh/authorized_keys":
    #     ensure => file,
    #     owner => "vagrant",
    #     group => "root",
    #     replace => true,
    #     content => "${pubKey}",
    # }

    # file{ "/home/vagrant/.ssh/id_rsa":
    #     ensure => file,
    #     owner => "vagrant",
    #     group => "root",
    #     mode => 600,
    #     replace => true,
    #     content => "${privKey}",
    # }

    file { $documentroot:
        ensure  => "directory",
        #owner   => "www-data",
        #group   => "www-data",
        #mode    => "0775",
        recurse => true,
    }

    

    class { "apache": }
    class { "apache::mod::php": }
    apache::vhost { "app.local":
        priority   => 000,
        port       => 80,
        docroot    => "${documentroot}/web",
        ssl        => false,
        servername => $documentroot,
        options    => ["FollowSymlinks MultiViews"],
        override   => ["All"],
        ensure     => present,
        require    => File[$documentroot]
    }

    class { "mysql": }
    class { "mysql::php": }
    class {"mysql::server":
        config_hash => {
            "root_password" => "root"
        }
    }

    mysql::db { 'symfony':
        user     => 'symfony',
        password => 'symfony',
        host     => 'localhost',
        grant    => ['all'],
    }

    mysql::db { 'symfony_test':
        user     => 'symfony_test',
        password => 'symfony_test',
        host     => 'localhost',
        grant    => ['all'],
    }
    
    class { "git":
        gitUser => $gitUser,
        gitEmail => $gitEmail
    }

    include zsh
    include vim
}
