#
# Cookbook Name:: drupal
# Recipe:: default
#
# Copyright 2012, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#

node.apache2.vhosts.each do |h|
  cron "crupal cron" do
    minute "0"
    command "wget -O - -q -t 1 http://#{h["domain"]}/cron.php"
  end
end
