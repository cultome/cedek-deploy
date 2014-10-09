# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "chef/centos-7.0"
  config.vm.network "forwarded_port", guest: 8080, host: 1234

  config.vm.provision "file", source: "provisions/bashrc", destination: "~/.bashrc"

  # librerias para desarrollo y compilacion
  config.vm.provision "shell", inline: "yum -y install gcc gcc-c++ curl-devel openssl-devel zlib-devel mariadb mariadb-server mysql-devel sqlite-devel vim vim-enhanced git svn patch libyaml-devel libffi-devel autoconf patch readline-devel automake libtool bison"
  config.vm.provision "shell", inline: "wget http://nodejs.org/dist/v0.11.13/node-v0.11.13-linux-x64.tar.gz"
  config.vm.provision "shell", inline: "tar --strip-components 1 -xzvf node-v0.11.13-linux-x64.tar.gz -C /usr/local"
  config.vm.provision "shell", inline: "curl -sSL https://get.rvm.io | bash -s -- --autolibs=read-fail --ruby"
  config.vm.provision "shell", inline: "gem install thin sinatra bundler"
  config.vm.provision "shell", inline: "thin install"
  config.vm.provision "shell", inline: "cp /vagrant/provisions/thin /etc/init.d/"
  config.vm.provision "shell", inline: "/sbin/chkconfig --level 345 thin on"
  # Bajamos la aplicacion
  config.vm.provision "shell", inline: "git clone https://github.com/cultome/cedek.git", privileged: false
  config.vm.provision "shell", inline: "bundle install --gemfile=/home/vagrant/cedek/Gemfile", privileged: false
  config.vm.provision "shell", inline: "rvm alias create cedek ruby-2.1.3@cedek"
  config.vm.provision "shell", inline: "cp /vagrant/provisions/cedek.yml /etc/thin/cedek.yml"
  config.vm.provision "file", source: "provisions/config.ru", destination: "~/cedek/config.ru"
  # Configuraciones
  config.vm.provision "file", source: "provisions/bowerrc", destination: "~/.bowerrc"

  config.vm.provision "shell", inline: "cd cedek && rake init", privileged: false
  config.vm.provision "shell", inline: "systemctl enable mariadb"
  config.vm.provision "shell", inline: "systemctl start mariadb"
  config.vm.provision "shell", inline: "mysql -uroot < /vagrant/provisions/mysql.sql"
  config.vm.provision "shell", inline: "cd cedek && rake reset", privileged: false
  config.vm.provision "shell", inline: "systemctl start thin"

  config.vm.provision "shell", inline: "cd cedek && ./node_modules/grunt-cli/bin/grunt", privileged: false
  # instalamos y configuramos el nginx
  config.vm.provision "shell", inline: "gem install passenger"
  config.vm.provision "shell", inline: "passenger-install-nginx-module --auto --auto-download --languages ruby,nodejs --prefix=/home/vagrant/nginx"
  config.vm.provision "shell", inline: "cp -fr /vagrant/provisions/ssl /home/vagrant/nginx/ssl"
  config.vm.provision "file", source: "provisions/proxy.conf", destination: "~/nginx/conf/proxy.conf"
  config.vm.provision "file", source: "provisions/nginx.conf", destination: "~/nginx/conf/nginx.conf"
  config.vm.provision "shell", inline: "systemctl enable nginx"
end
