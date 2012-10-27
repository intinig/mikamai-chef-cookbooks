#
# Cookbook Name:: basic-conf
# Recipe:: default
#
# Copyright 2012, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apt"

execute "dpkg-reconfigure grub-pc" do
  environment "DEBIAN_FRONTEND"  => "noninteractive"
  creates "/etc/chef/grub-reconfigured.semaphore"
end

execute "apt-get upgrade -y"

%w(intinig).each do |u|
  user u do
    action :create
    home "/home/#{u}"
    shell "/bin/bash"
    supports :manage_home => true
  end

  template "/etc/sudoers.d/#{u}" do
    source "sudoer.erb"
    mode 0440
    variables :user => u
  end

  directory "/home/#{u}/.ssh" do
    action :create
    owner u
    group u
    mode 0740
  end

  cookbook_file "/home/#{u}/.ssh/authorized_keys" do
    source "#{u}.pub"
    mode 0640
    owner u
    group u
  end
end

user "deploy" do
  action :create
  home "/var/apps"
  shell "/bin/bash"
  supports :manage_home => true
end

directory "/var/apps" do
  mode 0755
end

directory "/var/apps/.ssh" do
  action :create
  owner "deploy"
  group "deploy"
  mode 0740
end

execute 'ssh-keygen -t dsa -f /var/apps/.ssh/id_dsa -N ""' do
  user "deploy"
  creates "/var/apps/.ssh/id_dsa"
end

package "build-essential" do
  action :install
end

package "libxslt-dev" do
  action :install
end

package "libxml2-dev" do
  action :install
end

gem_package "github-key-upload" do
  action :install
  options("--no-ri --no-rdoc")
end

github_creds = Chef::EncryptedDataBagItem.load("passwords", "github")
github_command_string = "github-key-upload -k /var/apps/.ssh/id_dsa.pub -u #{github_creds["user"]} -P #{github_creds["password"]} -t #{node.ec2.instance_id}"

execute github_command_string do
  not_if github_command_string + " -C"
end

# directory "/var/chef/handlers" do
#   recursive true
# end

# execute "shutdown -r +1" do
#   only_if "test -f /var/run/reboot-required"
# end
