#
# Cookbook Name:: basic-conf
# Recipe:: s3-backup
#
# Copyright 2012, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#

package "ec2-ami-tools" do
  action :install
end

template "/root/backup.py" do
  mode 0755
end

cookbook_file "/mnt/pk-I7IU5NIF7DQEN7SKFB74RMKHVOW5YGZH.pem" do
  source "pk-I7IU5NIF7DQEN7SKFB74RMKHVOW5YGZH.pem"
end

cookbook_file "/mnt/cert-I7IU5NIF7DQEN7SKFB74RMKHVOW5YGZH.pem" do
  source "cert-I7IU5NIF7DQEN7SKFB74RMKHVOW5YGZH.pem"
end

cron "backup" do
  hour "3"
  minute "0"
  command "/root/backup.py"
end
