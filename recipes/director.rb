include_recipe 'chef-bacula::agent'

node['bacula']['dir']['packages'].each do |baculapkg|
    package baculapkg
end

service "mysqld" do
    action [:start, :enable]
end

service "bacula-dir" do
    action [:start, :enable]
end

############################### This next part sets up the database and mysql ################################
execute "set_root_password" do
    command "mysqladmin -u root password #{node['bacula']['mysql']['password']}"
    notifies :create, "ruby_block[flag_root_password]", :immediately
    not_if { node.attribute?("root_password")}
end

ruby_block "flag_root_password" do
    block do
        node.set['root_password'] = true
        node.save
    end
    action :nothing
end

execute "set-privileges" do
    command "/usr/libexec/bacula/grant_mysql_privileges -u root -p#{node['bacula']['mysql']['password']}"
    notifies :create, "ruby_block[flag_set_privileges]", :immediately
    not_if { node.attribute?("privileges_set") }
end

ruby_block "flag_set_privileges" do
  block do
    node.set['privileges_set'] = true
    node.save
  end
  action :nothing
end

execute "build-db" do
    command "/usr/libexec/bacula/create_mysql_database -u root -p#{node['bacula']['mysql']['password']}"
    notifies :create, "ruby_block[flag_build_db]", :immediately
    not_if { node.attribute?("built_db") }
end

ruby_block "flag_build_db" do
  block do
    node.set['built_db'] = true
    node.save
  end
  action :nothing
end

execute "make_mysql_tables" do
    command "/usr/libexec/bacula/make_mysql_tables -u root -p#{node['bacula']['mysql']['password']}"
    notifies :create, "ruby_block[flag_make_mysql_tables]", :immediately
    not_if { node.attribute?("tables_made") }
end

ruby_block "flag_make_mysql_tables" do
  block do
    node.set['tables_made'] = true
    node.save
  end
  action :nothing
end

execute "set_bacula_privileges" do
    command "/usr/libexec/bacula/grant_bacula_privileges -u root -p#{node['bacula']['mysql']['password']}"
    notifies :create, "ruby_block[flag_set_bacula_privileges]", :immediately
    not_if { node.attribute?("bacula_privileges") }
end

ruby_block "flag_set_bacula_privileges" do
  block do
    node.set['bacula_privileges'] = true
    node.save
  end
  action :nothing
end

execute "change-bacula-password" do
    command "mysql -h 127.0.0.1 -u root -p#{node['bacula']['mysql']['password']} -e \"SET PASSWORD FOR 'bacula'@'localhost' = PASSWORD('#{node['bacula']['mysql']['password']}');\""
    notifies :create, "ruby_block[flag_change_bacula_password]", :immediately
    not_if { node.attribute?("password_changed")}
end

ruby_block "flag_change_bacula_password" do
    block do
        node.set['password_changed'] = true
        node.save
    end
    action :nothing
end

template "/etc/bacula/bacula-dir.conf" do
    source "bacula-dir.conf.erb"
    mode "0644"
    owner "root"
    group "root"
    notifies :restart, "service[bacula-dir]", :immediately
end

template "/etc/bacula/bconsole.conf" do
    source "bconsole.conf.erb"
    mode "0644"
    owner "root"
    group "root"
end