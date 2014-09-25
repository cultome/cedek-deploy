# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "chef/centos-7.0"
  config.vm.network "forwarded_port", guest: 8080, host: 1234

  # Configuraciones temporales!!!!!
  proxy = "http_proxy=http://proxy-latin.network.fedex.com:3128 https_proxy=http://proxy-latin.network.fedex.com:3128"
  # librerias para desarrollo y compilacion
  config.vm.provision "shell", inline: "#{proxy} yum -y install gcc gcc-c++ curl-devel openssl-devel zlib-devel ruby ruby-devel mariadb mariadb-server mysql-devel sqlite-devel"
  config.vm.provision "shell", inline: "#{proxy} wget http://nodejs.org/dist/v0.11.13/node-v0.11.13-linux-x64.tar.gz", privileged: false
  config.vm.provision "shell", inline: "#{proxy} tar --strip-components 1 -xzvf node-v0.11.13-linux-x64.tar.gz -C /usr/local"

  # Herramientas de desarrollo
  config.vm.provision "shell", inline: "#{proxy} yum -y install vim vim-enhanced git"

  # Nginx and ruby module
  config.vm.provision "shell", inline: "#{proxy} gem install passenger -v '=4.0.52'", privileged: false
  config.vm.provision "shell", inline: "#{proxy} gem install thin sinatra bundler", privileged: false
  config.vm.provision "shell", inline: "#{proxy} passenger-install-nginx-module --auto --auto-download --languages ruby --prefix=/home/vagrant/nginx", privileged: false

  # Bajamos la aplicacion
  config.vm.provision "shell", inline: "#{proxy} git clone https://github.com/cultome/cedek.git", privileged: false
  # Configuraciones
  config.vm.provision "file", source: "provisions/proxy.conf", destination: "~/nginx/conf/proxy.conf"
  config.vm.provision "file", source: "provisions/nginx.conf", destination: "~/nginx/conf/nginx.conf"
  config.vm.provision "file", source: "provisions/.bowerrc", destination: "~/.bowerrc"
  config.vm.provision "shell", inline: "#{proxy} bundle install --gemfile=/home/vagrant/cedek/Gemfile", privileged: false

  # REMOVER
  #config.vm.provision "shell", inline: "npm config set proxy http://proxy-latin.network.fedex.com:3128", privileged: false
  #config.vm.provision "shell", inline: "npm config set https-proxy http://proxy-latin.network.fedex.com:3128", privileged: false
  config.vm.provision "shell", inline: "npm config set registry http://registry.npmjs.org/", privileged: false

  config.vm.provision "shell", inline: "cd cedek && #{proxy} rake init", privileged: false
  config.vm.provision "shell", inline: "/home/vagrant/nginx/sbin/nginx", privileged: false
  config.vm.provision "shell", inline: "systemctl start mariadb"
  config.vm.provision "shell", inline: "mysql -uroot < /vagrant/provisions/mysql.sql", privileged: false

  config.vm.provision "shell", inline: "cd cedek && /usr/local/bin/npm install", privileged: false
  config.vm.provision "shell", inline: "cd cedek && ./node_modules/grunt-cli/bin/grunt", privileged: false
  config.vm.provision "shell", inline: "rake --rakefile=/home/vagrant/cedek/Rakefile -I/home/vagrant/cedek/lib run &", privileged: false

end
