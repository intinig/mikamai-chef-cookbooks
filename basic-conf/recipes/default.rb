#
# Cookbook Name:: basic-conf
# Recipe:: default
#
# Copyright 2012, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#

%w(intinig pilu racco fauno).each do |u|
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
