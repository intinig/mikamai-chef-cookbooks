include_recipe "msttcorefonts::debian"


#---------------
# install improved local.conf
#---------------
# from https://wiki.ubuntu.com/Fonts
#cookbook_file "/etc/fonts/local.conf" do
#  source "localfonts.conf"
#  mode 0644
#end

#---------------
# regenerate font cache
#---------------
execute "regenerate fontcache" do
  command "fc-cache -fv >/dev/null"
  action :nothing
end
