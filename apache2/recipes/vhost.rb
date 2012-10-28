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
  notifies :reload, "service[apache2]"
end

node.apache2.vhosts.each do |h|
  template "/etc/apache2/sites-available/#{h["domain"]}" do
    source "vhost.erb"
    appname = (h["domain"] =~ /^www./) ? h["domain"].split(".")[1..-1].join(".") : h["domain"]
    docroot = "/var/apps/#{appname}/current"
    docroot += "/public" if h["rails"]
    variables :n => h, :docroot => docroot, :appname => appname
  end

  link "/etc/apache2/sites-enabled/#{h["domain"]}" do
    to "/etc/apache2/sites-available/#{h["domain"]}"
    notifies :reload, "service[apache2]"
  end
end
