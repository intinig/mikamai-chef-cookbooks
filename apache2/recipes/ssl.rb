include_recipe "ssl"

link "/etc/apache2/mods-enabled/ssl.load" do
  to "/etc/apache2/mods-available/ssl.load"
  notifies :restart, "service[apache2]"
end
