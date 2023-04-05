#!/usr/bin/env bash
# Installs Nginx Listens on port 80.
# Returns a page containing "Hello World!".
# contains a custom HTTP header named X-Served-By.
# set to the hostname of the running server.

!/usr/bin/env bash
#Install and configure an Nginx server using Puppet

$doc_root = '/etc/nginx/html'
$str = "server {
    listen 80 default_server;
    listen [::]:80 default_server;
    add_header X-Served-By '${HOSTNAME}';
    root   /var/www/html;
    index  index.html index.htm;
    location /redirect_me {
        return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
    }
    error_page 404 /404.html;
    location /404 {
      root /var/www/html;
      internal;
    }
}"

exec { 'apt-get update':
  command => '/usr/bin/apt-get update'
}

package { 'nginx':
  ensure  => 'installed',
  require => Exec['apt-get update']
}

file { $doc_root:
  ensure => 'directory',
  owner  => 'www-data',
  group  => 'www-data',
  mode   => '0644'
}
file { "${doc_root}/index.html":
  ensure  => 'present',
  content => 'Hello world!',
  require => File[$doc_root]
}

file { "${doc_root}/404.html":
  ensure  => 'present',
  content => "Ceci n'est pas une page",
  require => File[$doc_root]
}

file { '/etc/nginx/sites-available/default':
  ensure  => 'present',
  content => $str,
  notify  => Service['nginx'],
  require => Package['nginx']
}

service { 'nginx':
  ensure => running,
  enable => true
}
