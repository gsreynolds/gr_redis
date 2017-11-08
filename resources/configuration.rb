default_action :create

property :port, String, required: true, name_property: true # REDISPORT
property :bind, String, default: '127.0.0.1'
property :config_dir, String, default: '/etc/redis'
property :data_dir, String, default: '/var/redis'
property :redis_user, String, default: 'redis'
property :redis_group, String, default: 'redis'

action :create do
  group new_resource.redis_group do
    system true
  end

  user new_resource.redis_user do
    group new_resource.redis_group
    # home new_resource.home
    system true
  end

  directory new_resource.config_dir do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end

  directory new_resource.data_dir do
    owner new_resource.redis_user
    group new_resource.redis_group
    mode '0755'
    recursive true
    action :create
  end

  redis_conf = "/etc/redis/#{new_resource.port}.conf"
  template redis_conf do
    cookbook 'gr_redis'
    source 'redis.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(port: new_resource.port, bind: new_resource.bind)
  end

  # example redis systemd unit file from https://gist.github.com/hackedunit/14690b6174708d3e83593ce1cdfb4ed8
  template "/etc/systemd/system/redis-#{new_resource.port}.service" do
    cookbook 'gr_redis'
    source 'redis.service.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately
    variables(redis_conf: redis_conf, user: new_resource.redis_user, group: new_resource.redis_group)
  end

  execute 'systemctl-daemon-reload' do
    command '/bin/systemctl --system daemon-reload'
    action :nothing
  end

  service "redis-#{new_resource.port}" do
    supports status: true
    action [:enable, :start]
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
