# = Define: zurmo
#
#   Installs zurmo CRM.
#
# == Parameters:
#
#   $approot::
#     The folder where zurmo will be installed.
#     /var/www/zurmo (default)
#
#   $provider::
#     tgz (default) 
#
#   $version::
#     bleeding-2.5.5.73047729c660
#     stable-2.5.5.73047729c660 (default)
#     ...
#
define zurmo::crm($approot = '/var/www/zurmo', $provider = 'tgz', $version = 'stable-2.5.5.73047729c660', $timezone='America/Toronto') {
	include apache
	include memcached

    zurmo::database::mysql { $name: }

	$zipfile = "${approot}/zurmo-${version}.tar.gz"

	package {[ 'php', 'php-mysql', 'php-pdo', 'php-gd', 'php-pecl-apc', 'php-soap', 'php-mcrypt', 'php-pear', 'php-imap', 'php-mbstring', 'php-ldap', 'php-pecl-memcache', 'php-xml' ]:
		ensure => latest,
		provider => yum,
	} ->
    augeas { "/etc/php.ini":
        changes => [
            "set date.timezone ${timezone}",
            "set memory_limit 256M",
            "set file_uploads On",
            "set upload_max_filesize 20M",
            "set post_max_size 20M",
            "set max_execution_time 300",
        ],
        context => "/files/etc/php.ini/PHP",
    } ->
	file { $approot:
		ensure => directory,
	} ->
	exec { "Wget ${version} zip file":
		command => "wget http://dev2.zurmo.com/downloads/zurmo-${version}.tar.gz -O $zipfile",
		creates => $zipfile,
	} ~>
	exec { "Untar ${version} zip file":
		command => "tar xvzf ${zipfile} --strip-components=1",
		cwd => $approot,
		refreshonly => true,
	} ~>
	exec { "Chown ${approot}":
		command => "chown -R apache:apache ${approot}",
		refreshonly => true,
    } ->
    firewall { "100 http":
        proto => "tcp",
        dport => "80",
        action => accept,
        state => "NEW",
    }
}
