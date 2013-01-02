#
# Cookbook Name:: passenger
# Recipe:: default
#
# Copyright 2012, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"
include_recipe "build-essential"

%w(libcurl4-openssl-dev libssl-dev apache2-prefork-dev libapr1-dev libaprutil1-dev).each do |pkg|
  package pkg do
    action :install
  end
end

gem_package "passenger" do
  version node[:passenger][:version]
end

execute "passenger_module" do
  command 'passenger-install-apache2-module --auto'
  not_if {node[:passenger][:module_path]}
end

template "/etc/apache2/conf.d/passenger" do
  action :create
  notifies :restart, "service[apache2]"
end
