#
# Cookbook Name:: vinodalproduttore
# Recipe:: solicitor
#
# Copyright 2012, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#

cron "solicitor" do
  hour "11"
  minute "0"
  command "wget -O - -q -t 1 www.vinodalproduttore.it/it/modules/reviewssolicitor/cron.php"
end
