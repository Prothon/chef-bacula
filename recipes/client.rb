package "bacula-console" do
	action :install
end

template "/etc/bacula/bconsole.conf" do
    source "bconsole.conf.erb"
    mode "0644"
    owner "root"
    group "root"
end