node['bacula']['client']['packages'].each do |baculapkg|
    package baculapkg
end

template "/etc/bacula/bconsole.conf" do
    source "bconsole.conf.erb"
    mode "0644"
    owner "root"
    group "root"
end

template "/etc/bacula/bacula-fd.conf" do
    source "bacula-fd.conf.erb"
    mode "0644"
    owner "root"
    group "root"
end

service "bacula-fd" do
    action [:start, :enable]
end