link "/etc/apache2/mods-enabled/headers.load" do
  to "/etc/apache2/mods-available/headers.load"
  notifies :restart, "service[apache2]"
end
