default_action :create

# property :port, Integer, required: true, name_property: true # REDISPORT
property :version, String, required: true, name_property: true # Redis version to install
property :checksum, String, required: true # sha256 checksum of download
property :install_dir, String, default: '/opt/redis'
property :download_url, String, default: 'http://download.redis.io/releases'

action :create do
  build_essential 'install_packages'

  directory new_resource.install_dir do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end

  remote_file "#{new_resource.install_dir}/redis-#{new_resource.version}.tar.gz" do
    source "#{new_resource.download_url}/redis-#{new_resource.version}.tar.gz"
    owner 'root'
    group 'root'
    checksum new_resource.checksum
    # notifies :run, 'execute[extract-redis]', :immediately
    action :create
  end

  execute 'extract-redis' do
    command "tar -xvzf redis-#{new_resource.version}.tar.gz"
    cwd new_resource.install_dir
    # notifies :run, 'execute[make-redis]', :immediately
    creates "#{new_resource.install_dir}/redis-#{new_resource.version}"
    action :run
  end

  execute 'make-redis' do
    command 'make'
    cwd "#{new_resource.install_dir}/redis-#{new_resource.version}"
    creates "#{new_resource.install_dir}/redis-#{new_resource.version}/src/redis-server"
    # notifies :run, 'execute[make-test-redis]', :immediately
    action :run
  end
end

action :remove do
  directory new_resource.install_dir do
    recursive true
    action :delete
  end
end
