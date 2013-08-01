class composer($hostname) {
	exec { "curl -sS https://getcomposer.org/installer | php":
		cwd     => "/var/www/${hostname}",
        require => Package['curl']
    }
}