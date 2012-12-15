#
# Cookbook Name:: apache2
# Recipe:: vhost
#
# Copyright 2012, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#

link "/etc/apache2/mods-enabled/rewrite.load" do
  to "/etc/apache2/mods-available/rewrite.load"
  notifies :restart, "service[apache2]"
end

node.apache2.vhosts.each do |h|
  appname = (h["domain"] =~ /^www./) ? h["domain"].split(".")[1..-1].join(".") : h["domain"]
  docroot = "/var/apps/#{appname}/current"
  docroot += "/public" if h["rails"]

  template "/etc/apache2/sites-available/#{h["domain"]}" do
    source "vhost.erb"
    variables :n => h, :docroot => docroot, :appname => appname
  end

  logrotate_app appname do
    cookbook "logrotate"
    path "/var/apps/#{h["domain"]}*.log"
    frequency "weekly"
    rotate 52
    create "644 root adm"
  end

  link "/etc/apache2/sites-enabled/#{h["domain"]}" do
    to "/etc/apache2/sites-available/#{h["domain"]}"
    notifies :restart, "service[apache2]"
    only_if {h["enabled"]}
  end

  link "/etc/apache2/sites-enabled/#{h["domain"]} remove" do
    target_file "/etc/apache2/sites-enabled/#{h["domain"]}"
    to "/etc/apache2/sites-available/#{h["domain"]}"
    notifies :restart, "service[apache2]"
    not_if {h["enabled"]}
    only_if "test -f /etc/apache2/sites-enabled/#{h["domain"]}"
    action :delete
  end
end
