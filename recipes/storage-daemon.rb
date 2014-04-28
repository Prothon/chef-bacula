include_recipe 'chef-bacula::agent'

package "bacula-storage-mysql" do
    action :install
end

directory node['bacula']['sd']['path'] do
    owner 'bacula'
    group 'bacula'
    action :create
end

service "bacula-sd" do
    action [:start, :enable]
end

template "/etc/bacula/bacula-sd.conf" do
    source "bacula-sd.conf.erb"
    mode "0644"
    owner "root"
    group "root"
    notifies :restart, "service[bacula-sd]", :immediately
end