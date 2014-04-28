package "bacula-client" do
    action :install
end

service "bacula-fd" do
    action [:start, :enable]
end

template "/etc/bacula/bacula-fd.conf" do
    source "bacula-fd.conf.erb"
    mode "0644"
    owner "root"
    group "root"
    notifies :restart, "service[bacula-fd]", :immediately
end