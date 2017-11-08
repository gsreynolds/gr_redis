default_action :create

property :port, String, required: true, name_property: true
property :bind, String, default: '127.0.0.1'
property :config_dir, String, default: '/etc/redis'
property :data_dir_prefix, String, default: '/var/lib/redis'
property :log_dir, String, default: '/var/log/redis'
property :redis_user, String, default: 'redis'
property :redis_group, String, default: 'redis'
property :requirepass, String, sensitive: true, default: '' # FIXME: type, default & coerce
property :restart_on_conf_change, [true, false], default: true

action :create do
  group new_resource.redis_group do
    system true
  end

  user new_resource.redis_user do
    group new_resource.redis_group
    system true
  end

  directory new_resource.config_dir do
    owner 'root'
    group new_resource.redis_group
    mode '0750'
    recursive true
    action :create
  end

  [instance_data_dir, new_resource.log_dir].each do |dir|
    directory dir do
      owner 'root'
      group new_resource.redis_group
      mode '0770'
      recursive true
      action :create
    end
  end

  template instance_conf do
    cookbook 'gr_redis'
    source 'redis.conf.erb'
    owner 'root'
    group new_resource.redis_group
    mode '0640'
    variables(
      port: new_resource.port,
      bind: new_resource.bind,
      supervised: 'systemd',
      data_dir: instance_data_dir,
      logfile: instance_logfile,
      requirepass: new_resource.requirepass
    )
    sensitive true
    notifies :restart, "service[#{instance_name}]", :delayed if new_resource.restart_on_conf_change
  end

  # Store auth pass in EnvironmentFile loaded in SystemD service unit - used for redis-cli shutdown command.
  # Alternative would be to rely on SIGTERM from SystemD to shutdown and avoid the password entirely.
  file instance_env_file do
    owner 'root'
    group 'root'
    mode '0600'
    content "REQUIREPASS=#{new_resource.requirepass}"
    sensitive true
    action :create unless new_resource.requirepass.empty?
    action :delete if new_resource.requirepass.empty?
  end

  template instance_service_unit do
    cookbook 'gr_redis'
    source 'redis.service.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately
    variables(
      conf: instance_conf,
      redis_user: new_resource.redis_user,
      redis_group: new_resource.redis_group,
      port: new_resource.port,
      env_file: instance_env_file,
      authenabled: !new_resource.requirepass.empty?
    )
    notifies :restart, "service[#{instance_name}]", :delayed if new_resource.restart_on_conf_change
  end

  systemd_daemon_reload

  service instance_name do
    supports status: true
    action [:enable, :start]
  end
end

action :remove do
  # Don't delete data or logs

  service instance_name do
    action [:stop, :disable]
  end

  file instance_service_unit do
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately
    action :delete
  end

  systemd_daemon_reload

  file instance_conf do
    action :delete
  end
end

action_class do
  def instance_name
    "redis-#{new_resource.port}"
  end

  def instance_service_unit
    "/etc/systemd/system/#{instance_name}.service"
  end

  def instance_conf
    ::File.join(new_resource.config_dir, "#{instance_name}.conf")
  end

  def instance_env_file
    ::File.join(new_resource.config_dir, "#{instance_name}.env")
  end

  def instance_data_dir
    ::File.join(new_resource.data_dir_prefix, instance_name)
  end

  def instance_logfile
    ::File.join(new_resource.log_dir, "#{instance_name}.log")
  end

  def systemd_daemon_reload
    execute 'systemctl-daemon-reload' do
      command '/bin/systemctl --system daemon-reload'
      action :nothing
    end
  end
end
