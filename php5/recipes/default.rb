#
# Cookbook Name:: php5
# Recipe:: php
#
# Copyright 2012, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"

package "php5" do
  action :install
end

package "php-pear" do
  action :install
end
