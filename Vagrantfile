# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "chef/centos-7.0"
  config.vm.network "forwarded_port", guest: 415, host: 2000

  config.vm.provision "file", source: "provisions/bashrc", destination: "~/.bashrc"
  config.vm.provision "shell", inline: "cp /vagrant/provisions/bashrc /root/.bashrc"
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
  config.vm.provision "shell", inline: "bundle install --gemfile=/home/vagrant/cedek/Gemfile"
  config.vm.provision "shell", inline: "rvm alias create cedek ruby-2.1.3@cedek"
  config.vm.provision "shell", inline: "cp /vagrant/provisions/cedek.yml /etc/thin/cedek.yml"
  config.vm.provision "file", source: "provisions/config.ru", destination: "~/cedek/config.ru"
  # Configuraciones
  config.vm.provision "file", source: "provisions/bowerrc", destination: "~/.bowerrc"

  config.vm.provision "shell", inline: "systemctl enable mariadb"
  config.vm.provision "shell", inline: "systemctl start mariadb"
  config.vm.provision "shell", inline: "mysql -uroot < /vagrant/provisions/mysql.sql"
  config.vm.provision "shell", inline: "cd cedek && rake reset", privileged: false
  #config.vm.provision "shell", inline: "systemctl enable thin"
  #config.vm.provision "shell", inline: "systemctl start thin"

  config.vm.provision "shell", inline: "npm install grunt-cli -g"
  config.vm.provision "shell", inline: "cd cedek && rake init", privileged: false
  config.vm.provision "shell", inline: "cd /home/vagrant/cedek && grunt"
  # instalamos y configuramos el nginx
  config.vm.provision "shell", inline: "gem install passenger"
  config.vm.provision "shell", inline: "passenger-install-nginx-module --auto --auto-download --languages ruby --prefix=/home/vagrant/nginx"
  config.vm.provision "shell", inline: "cp -fr /vagrant/provisions/ssl /home/vagrant/nginx/ssl"
  config.vm.provision "shell", inline: "cp /vagrant/provisions/proxy.conf /home/vagrant/nginx/conf/proxy.conf"
  config.vm.provision "shell", inline: "cp /vagrant/provisions/nginx.conf /home/vagrant/nginx/conf/nginx.conf"
  config.vm.provision "shell", inline: "chmod 755 /home/vagrant"
  config.vm.provision "shell", inline: "/home/vagrant/nginx/sbin/nginx", run: "always"
  config.vm.provision "shell", inline: "cd cedek && rackup -p 8080 --daemonize", run: "always"
end
