# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = false
    config.vm.define :Webserver1 do |node2|
    node2.vm.box = "centos7_GA.box"
    node2.vm.network :private_network, ip: "192.168.33.11"
    node2.vm.provider :virtualbox do |vb2|
      vb2.customize ["modifyvm", :id, "--memory", "500","--cpus", "1", "--name", "Webserver1" ]
    end
    config.vm.provision "chef_solo" do |chef|
       chef.cookbooks_path = "cookbooks"
       chef.add_recipe "httpd"
       chef.json = {
		     "servidor" => "Servidor 1",
	       "ip" => "192.168.33.11"
		   }
    end
  end

 config.vm.define :Webserver2 do |node3|
    node3.vm.box = "centos7_GA.box"
    node3.vm.network :private_network, ip: "192.168.33.12"
    node3.vm.provider :virtualbox do |vb3|
      vb3.customize ["modifyvm", :id, "--memory", "500","--cpus", "1", "--name", "Webserver2" ]
    end
    config.vm.provision "chef_solo" do |chef|
       chef.cookbooks_path = "cookbooks"
       chef.add_recipe "httpd"
       chef.json = {
         "servidor" => "Servidor 2",
         "ip" => "192.168.33.12"
       }
    end
  end

  config.vm.define :LoadBalancer do |node1|
    node1.vm.box = "centos7_GA.box"
    node1.vm.network :private_network, ip: "192.168.33.10"
    node1.vm.provider :virtualbox do |vb1|
      vb1.customize ["modifyvm", :id, "--memory", "500","--cpus", "1", "--name", "LoadBalancer" ]
    end
    config.vm.provision "chef_solo" do |chef|
       chef.cookbooks_path = "cookbooks"
       chef.add_recipe "loadbalancer"
       chef.json = {
        "web_servers" => [
          {"ip":"192.168.33.11"},
          {"ip":"192.168.33.12"}
         ]
       }
    end
  end
end
