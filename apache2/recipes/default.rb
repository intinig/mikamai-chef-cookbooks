#
# Cookbook Name:: apache2
# Recipe:: default
#
# Copyright 2012, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#
package "apache2" do
  action :install
end

service "apache2" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
