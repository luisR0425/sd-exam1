template '/etc/nginx/conf.d/load-balancer.conf' do
  source 'load-balancer.erb'
  mode 0644
  owner 'root'
  group 'wheel'
  variables(
  		  :web_servers => node[:web_servers]
  )
end

bash 'rename' do
code <<-EOH
  mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.disabled
  EOH
end

service 'nginx' do
  action :restart
end