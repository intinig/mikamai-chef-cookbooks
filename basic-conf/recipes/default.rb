#
# Cookbook Name:: basic-conf
# Recipe:: default
#
# Copyright 2012, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#

include_recipe "ubuntu"
include_recipe "apt"
include_recipe "reboot-handler"
include_recipe "build-essential"
include_recipe "xml"

# warning: not idempotent, but not one dies if you run it more than once
# we should drop this for future versions of ubuntu
execute "dpkg-reconfigure grub-pc" do
  environment "DEBIAN_FRONTEND"  => "noninteractive"
end

# warning: not idempotent but ideally we want to run on the latest versions of
# everything
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

template "/etc/sudoers.d/deploy" do
  source "deploy.erb"
  mode 0440
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

directory "/var/apps/log" do
  action :create
  owner "deploy"
  group "deploy"
  mode 0770
end

group "deploy" do
  action :modify
  members "www-data"
  append true
end

cookbook_file "/var/apps/.ssh/authorized_keys" do
  action :create
  owner "deploy"
  group "deploy"
  mode 0640
end

cookbook_file "/var/apps/.ssh/known_hosts" do
  action :create
  source "github-known-hosts"
  owner "deploy"
  group "deploy"
  mode 0640
end

execute 'ssh-keygen -t dsa -f /var/apps/.ssh/id_dsa -N ""' do
  user "deploy"
  creates "/var/apps/.ssh/id_dsa"
end

package "git-core" do
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

ruby_block "check_restart" do
  block do
    node.run_state['reboot'] = true
    node.save
  end
  only_if "test -f /var/run/reboot-required"
end
