cookbook_file '/etc/yum.repos.d/nginx.repo' do
  source 'nginx.repo'
  owner 'vagrant'
  group 'vagrant'
  mode '0755'
  action :create
end

execute 'sudo su'
execute 'yum update -y'

package 'nginx' do
  action :install
end

service 'nginx' do
  supports status: true, restart: true, reload: true
  action :enable
end