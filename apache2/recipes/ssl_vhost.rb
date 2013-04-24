#
# Cookbook Name:: apache2
# Recipe:: ssl_vhost
#
# Copyright 2012, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#

link "/etc/apache2/mods-enabled/rewrite.load" do
  to "/etc/apache2/mods-available/rewrite.load"
  notifies :restart, "service[apache2]"
end

link "/etc/apache2/sites-enabled/default-ssl" do
  to "/etc/apache2/sites-available/default-ssl"
  notifies :restart, "service[apache2]"
end

node.apache2.ssl_redirects.each do |h|
#  ipaddress = (node["cloud"] ? node["cloud"]["public_ipv4"] : node['ipaddress'])
  ipaddress = node['ipaddress']
  template "/etc/apache2/sites-available/#{h["domain"]}_ssl" do
    source "ssl_redirect.erb"
    variables :ipaddress => ipaddress, :n => h
  end
end

node.apache2.ssl_vhosts.each do |h|
  appname = (h["domain"] =~ /^www./) ? h["domain"].split(".")[1..-1].join(".") : h["domain"]
  docroot = "/var/apps/#{appname}/current"
  docroot += "/public" if h["rails"]

  ipaddress = (node["cloud"] ? node["cloud"]["public_ipv4"] : node['ipaddress'])

  template "/etc/apache2/sites-available/#{h["domain"]}_ssl" do
    source "ssl_vhost.erb"
    variables :ipaddress => ipaddress, :n => h, :docroot => docroot, :appname => appname
  end
end

(node.apache2.ssl_redirects + node.apache2.ssl_vhosts).each do |h|
  logrotate_app h["domain"] do
    cookbook "logrotate"
    path "/var/apps/#{h["domain"]}*ssl*.log"
    frequency "weekly"
    rotate 52
    create "644 root adm"
  end

  link "/etc/apache2/sites-enabled/#{h["domain"]}_ssl" do
    to "/etc/apache2/sites-available/#{h["domain"]}_ssl"
    notifies :restart, "service[apache2]"
    only_if {h["enabled"]}
  end

  link "/etc/apache2/sites-enabled/#{h["domain"]}_ssl remove" do
    target_file "/etc/apache2/sites-enabled/#{h["domain"]}_ssl"
    to "/etc/apache2/sites-available/#{h["domain"]}_ssl"
    notifies :restart, "service[apache2]"
    not_if {h["enabled"]}
    only_if "test -f /etc/apache2/sites-enabled/#{h["domain"]}_ssl"
    action :delete
  end
end
