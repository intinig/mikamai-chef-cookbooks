include_recipe "ssl"

link "/etc/apache2/mods-enabled/ssl.load" do
  to "/etc/apache2/mods-available/ssl.load"
  notifies :restart, "service[apache2]"
end

link "/etc/apache2/mods-enabled/ssl.conf" do
  to "/etc/apache2/mods-available/ssl.conf"
  notifies :restart, "service[apache2]"
end
