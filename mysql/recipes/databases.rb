#
# Cookbook Name:: mysql
# Recipe:: databases
#
# Copyright 2012, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#
node.mysql.databases.each do |db|
  execute "create db" do
    command "mysqladmin create -u root -p#{node["mysql"]["password"]} #{db["name"]}"
    not_if "mysql -u root -p#{node["mysql"]["password"]} -e 'use #{db["name"]}'"
  end

  execute "set privileges" do
    command "mysql -u root -p#{node["mysql"]["password"]} -e 'grant all on #{db["name"]}.* to #{db["user"]}@localhost identified by \"#{db["password"]}\"'"
    not_if "mysql -u #{db["user"]} -p#{db["password"]} -e 'use #{db["name"]}'"
  end
end
