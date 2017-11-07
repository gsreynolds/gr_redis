default_action :create

property :port, String, required: true, name_property: true # REDISPORT
property :bind, String, default: '127.0.0.1'
property :config_dir, String, default: '/etc/redis'
property :data_dir, String, default: '/var/redis'

action :create do
  directory new_resource.config_dir do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end

  directory new_resource.data_dir do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end

  template "/etc/redis/#{new_resource.port}.conf" do
    cookbook 'gr_redis'
    source 'redis.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(port: new_resource.port, bind: new_resource.bind)
  end
end

action :remove do
  directory new_resource.config_dir do
    recursive true
    action :delete
  end

  directory new_resource.data_dir do
    recursive true
    action :delete
  end
end
