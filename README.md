## Universidad Icesi <br />

### Informe Examen 1 <br />

**Nombre:** Luis Fernando Rosales Cadena <br />
**Código:** A00315320 <br />

**URL repositorio:** https://github.com/luisR0425/sd-exam1  <br />

2) Los comandos necesarios para dar el aprovisionamiento de los servicios que se quieren instalar son los siguientes:<br />

Para el balanceador de cargas:<br />

Primero se debe agregar el archivo nginx.repo en /etc/yum.repos.d/ para poder descargar el servicio nginx más reciente.<br />

```
sudo vi /etc/yum.repos.d/nginx.repo
```

Agregamos o copiamos lo siguiente:<br />

```
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=0
enabled=1
```

Luego<br />

```
sudo yum update
sudo yum install nginx
sudo service nginx restart
```

Después se agrega la configuración para el balanceador de cargas en la carpeta conf.d<br />

```
sudo vi /etc/nginx/conf.d/load-balancer.conf

upstream backend {
   server 192.168.33.11;
   server 192.168.33.12;
}

server {
   listen 80;

   location / {
         proxy_pass http://backend;
   }
}
```

Por último le cambiamos el nombre de la configuración que tenía el servicio por defecto para que pueda seleccionar el que hicimos.<br />

```
sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.disabled

sudo service nginx restart
```

3) El archivo Vagrantfile es el siguiente:
```ruby
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
```

4) Los cookbooks necesarios están en el repositorio y son los siguientes:<br />

![](https://i.imgur.com/9n9wmvk.png)

Prueba de funcionalidad.

![](https://i.imgur.com/DttUytB.gif)

7) Alguno problemas fueron más que todo con el aprovisionamiento en chef, porque hay que tener en cuenta que cuando en vagrant aprovisionamos automáticamente las tres máquinas se ejecutan las recetas que se van agregando, es decir cuando se ejecuta la máquina dos aprovisiona o usa la receta de la máquina anterior, la solución fue ejecutarlas una por una con vagran up <máquina>. Una cosa a tener en cuenta es que para aprovisionar sólo utilizando una receta en el caso de los servidores web, se utiliza el chef.json que nos permite mandarle las variables a las recetas para que pueda aprovisionar mejor cada servidor, en este caso se uso para modificar la página html de cada servicio web.<br />

```ruby
chef.json = {
        "web_servers" => [
          {"ip":"192.168.33.11"},
          {"ip":"192.168.33.12"}
         ]
       }
```

Para manejar la Ip que se manda a cada máquina se utilizo el lenguaje ruby en el template load-balancer.erb para asignarla automáticamente.
 
```ruby
 chef.json = {
 "servidor" => "Servidor 1",
 "ip" => "192.168.33.11"
       }
```

```ruby
 chef.json = {
 "servidor" => "Servidor 2",
 "ip" => "192.168.33.12"
       }
```

```ruby
 upstream backend {
<% @web_servers.each_with_index do |web_server, index| %>
    server <%= web_server[:ip]%>;
<% end %>
}
```

### Diagrama de despliegue UML
![](https://lh6.googleusercontent.com/zrQ7Skl2YUb4vq9Pxhuntsn_ODcjpB-7eLPP6dl2PaZ2GT_wL8GHe8j1S0xrmLXZlh0m9ErvXFssfUFFiaP_=w1209-h671)

### Referencias
- https://www.upcloud.com/support/how-to-set-up-load-balancing/
