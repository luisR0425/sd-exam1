service 'httpd' do
  action [ :enable, :start]
end 

template '/var/www/html/index.html' do
  source 'index.erb'
  owner 'vagrant'
  group 'vagrant'
  mode 0644
  action :create
  variables(
			servidor: node[:servidor],
			ip: node[:ip]
	)
end

template '/var/www/html/welcome.html' do
	source 'welcome.erb'
	owner 'vagrant'
	group 'vagrant'
	mode 0644
	variables(
			servidor: node[:servidor],
			ip: node[:ip]
	)
end