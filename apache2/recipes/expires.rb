link "/etc/apache2/mods-enabled/expires.load" do
  to "/etc/apache2/mods-available/expires.load"
  notifies :restart, "service[apache2]"
end
