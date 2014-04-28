default['bacula']['client']['packages'] = 'bacula-client'
default['bacula']['client']['conffile'] = '/etc/bacula/'
default['bacula']['client']['password'] = 'supersecret'

default['bacula']['dir']['packages'] = %w(bacula-director-mysql bacula-console mysql-server mysql-devel)
default['bacula']['dir']['ipaddress'] = '127.0.0.1'
default['bacula']['dir']['password'] = 'supersecret'

default['bacula']['sd']['ipaddress'] = '127.0.0.1'
default['bacula']['sd']['password'] = 'supersecret'
default['bacula']['sd']['path'] = '/backups'

default['bacula']['mysql']['ipaddress'] = '127.0.0.1'
default['bacula']['mysql']['username'] = 'bacula'
default['bacula']['mysql']['password'] = 'supersecret'
default['bacula']['mysql']['dbname'] = 'bacula'