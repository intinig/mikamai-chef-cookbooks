#
# Cookbook Name:: php5
# Recipe:: mcrypt
#
# Copyright 2012, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#

package "php5-mcrypt" do
  action :install
  notifies :restart, "service[apache2]"
end
