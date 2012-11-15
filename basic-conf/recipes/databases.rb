#
# Cookbook Name:: basic-conf
# Recipe:: dbc
#
# Copyright 2012, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#

mysql_password = node['mysql']['server_root_password'] || node['mysql']['password']
mysql_connection_info = {:host => "localhost", :username => "root", :password => mysql_password}

node.mysql.databases.each do |db|
  mysql_database db["name"] do
    connection mysql_connection_info
    action :create
  end

  mysql_database_user db["user"] do
    connection mysql_connection_info
    password db["password"]
    database_name db["name"]
    action :grant
  end
end
