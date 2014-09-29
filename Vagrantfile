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
  config.vm.provision "shell", inline: "curl -sSL https://get.rvm.io | bash -s -- 2.1.30 --autolibs=read-fail --ruby"
  config.vm.provision "shell", inline: "gem install thin sinatra bundler"
  config.vm.provision "shell", inline: "thin install"
  config.vm.provision "shell", inline: "ln -s /etc/rc.d/thin /etc/init.d/"
  config.vm.provision "shell", inline: "/sbin/chkconfig --level 345 thin on"
  # Bajamos la aplicacion
  config.vm.provision "shell", inline: "git clone https://github.com/cultome/cedek.git", privileged: false
  config.vm.provision "shell", inline: "bundle install --gemfile=/home/vagrant/cedek/Gemfile", privileged: false
  config.vm.provision "shell", inline: "rvm alias create cedek ruby-2.1.3@cedek"
  config.vm.provision "shell", inline: "cp /vagrant/provisions/cedek.yml /etc/thin/cedek.yml"
  config.vm.provision "file", source: "provisions/config.ru", destination: "~/cedek/config.ru"
  # Configuraciones
  config.vm.provision "file", source: "provisions/bowerrc", destination: "~/.bowerrc"

  # REMOVER
  config.vm.provision "shell", inline: "npm config set proxy http://proxy-latin.network.fedex.com:3128", privileged: false
  config.vm.provision "shell", inline: "npm config set https-proxy http://proxy-latin.network.fedex.com:3128", privileged: false
  config.vm.provision "shell", inline: "npm config set registry http://registry.npmjs.org/", privileged: false

  config.vm.provision "shell", inline: "cd cedek && rake init", privileged: false
  config.vm.provision "shell", inline: "systemctl start mariadb"
  config.vm.provision "shell", inline: "mysql -uroot < /vagrant/provisions/mysql.sql"
  config.vm.provision "shell", inline: "systemctl restart thin"

  config.vm.provision "shell", inline: "cd cedek && ./node_modules/grunt-cli/bin/grunt", privileged: false
end
