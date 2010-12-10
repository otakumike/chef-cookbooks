define :nginx_site, :action => :enable do
  case params[:action]
  when :enable
    
    include_recipe "nginx::base"
  
    raise "Please provide the config template to use." unless params[:template]
  
    template "/etc/nginx/sites-available/#{params[:name]}" do
      source params[:template]
      owner "root"
      group "root"
      mode "0644"
      notifies :restart, resources(:service => "nginx")
    end
  
    link "/etc/nginx/sites-enabled/#{params[:name]}" do
      to "/etc/nginx/sites-available/#{params[:name]}"
      notifies :restart, resources(:service => "nginx")
    end
  
  when :disable
    
    include_recipe "nginx::base"
    
    link "/etc/nginx/sites-enabled/#{params[:name]}" do
      action :delete
      only_if "test -f /etc/nginx/sites-enabled/#{params[:name]}"
      notifies :restart, resources(:service => "nginx")
    end
    
  end
end
