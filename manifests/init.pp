# == Class: zabbix
#
# Full description of class zabbix here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { zabbix:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class zabbix (
	$version	= 'latest',
	$environment	= 'production',
	$server		= '127.0.0.1',
	$status		= 'running',
	$myname		= 'john_doe',
	) {
		include apt
 		apt::source { 'zabbix':
                	location => 'http://repo.zabbix.com/zabbix/2.0/debian',
                	release  => 'wheezy',
                	repos    => 'main',
                	key      => '79EA5ED4',
                	key_source => 'http://repo.zabbix.com/zabbix-official-repo.key',
                }->package { 'zabbix-agent':
                 	ensure => $version,
			notify => Service['zabbix-agent']
                }

		service { 'zabbix-agent':
			ensure => $status,
			require => Package['zabbix-agent'],
		}
		file { '/etc/zabbix/zabbix_agentd.conf':
			ensure => file,
			content => template('zabbix/zabbix_agentd.conf.erb'),
			owner => root,
			group => root,
			mode =>	0644,
			force => true,
			require => Package['zabbix-agent'],
			notify => Service['zabbix-agent'],
		}
}




