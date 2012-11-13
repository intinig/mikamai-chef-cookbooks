#
# Author::  Giovanni Intini (<giovanni@mikamai.com>)
# Cookbook Name:: php
# Recipe:: module_ioncube
#
# Copyright 2009-2012, MIKAMAI
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
arch = (node.kernel.machine == "x86_64") ? "-64" : ""

execute "download ioncube" do
  command "wget http://downloads2.ioncube.com/loader_downloads/ioncube_loaders_lin_x86#{arch}.tar.gz"
  cwd "/tmp"
  not_if "test -f /etc/php5/apache2/conf.d/20ioncube.ini"
end

execute "tar xfz ioncube_loaders_lin_x86#{arch}.tar.gz" do
  cwd "/tmp"
  not_if "test -f /etc/php5/apache2/conf.d/20ioncube.ini"
end

directory "/usr/lib/php5/ioncube" do
  action :create
end

execute "put ioncube in the right place" do
  command "mv ioncube/* /usr/lib/php5/ioncube"
  cwd "/tmp"
  not_if "test -f /etc/php5/apache2/conf.d/20ioncube.ini"
end

cookbook_file "/etc/php5/apache2/conf.d/20ioncube.ini" do
  source "20ioncube.ini"
  notifies :restart, "service[apache2]"
end
