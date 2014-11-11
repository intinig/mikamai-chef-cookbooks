#
# Cookbook Name:: legacy
# Recipe:: cron
#
# Copyright 2014, MIKAMAI
#
# All rights reserved - Do Not Redistribute
#

cron "availabledataclearer" do
  hour "11"
  minute "0"
  command "wget -O - -q -t 1 www.legacydistribution.it/modules/availabledateclearer/cron.php"
end
