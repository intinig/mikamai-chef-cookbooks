#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2012, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#
require 'openssl'

def secure_password
  pw = String.new

  while pw.length < 20
    pw << ::OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
  end

  pw
end

password = secure_password

node.set_unless["mysql"]["password"] = password

package "mysql-server" do
  action :install
end

execute "assign-root-password" do
  command "mysqladmin -u root password \"#{node['mysql']['password']}\""
  action :run
  only_if "mysql -u root -e 'show databases;'"
end

service "mysql" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
