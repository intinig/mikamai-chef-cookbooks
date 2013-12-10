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

cron "abandoned_cart" do
  minute "*/15"
  command "php -f /var/apps/vinodalproduttore.it/current/modules/cartabandonment/send.php 228d7c2a2234ef66cdd8b38179e7a872"
end
