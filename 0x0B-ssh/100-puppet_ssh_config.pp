#!/usr/bin/env bash
#Using Puppet, configure ssh configuration file

file_line { 'Declare_identity_file':
  path    => '/etc/ssh/ssh_config',
  line    => 'IdentityFile ~/.ssh/school',
}

file_line { 'Turn_off_passwd_auth':
  path    => '/etc/ssh/ssh_config',
  line    => 'PasswordAuthentication no',
}
