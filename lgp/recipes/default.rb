#
# Cookbook Name:: lgp
# Recipe:: default
#
# Copyright 2014, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#

postgresql_connection_info = {
  :host     => 'localhost',
  :port     => node['postgresql']['config']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

postgresql_database 'lgp_production' do
  connection postgresql_connection_info
  action :create
end

postgresql_database_user 'db_manipulator_legacy' do
  connection postgresql_connection_info
  password 'por3t40qq!ausd3'
  action :create
end

postgresql_database_user 'db_manipulator_legacy' do
  connection postgresql_connection_info
  database_name 'lgp_production'
  host 'localhost'
  privileges [:all]
  action :grant
end

%w(openssh-server build-essential libssl-dev libyaml-dev git libtool libxslt-dev libxml2-dev libpq-dev gawk curl pngcrush imagemagick software-properties-common).each do |pkg|
  package pkg do
    action :install
  end
end
