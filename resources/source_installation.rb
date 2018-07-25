default_action :create

property :version, String, name_property: true
property :checksum, String, required: true
property :install_root_prefix, String, default: '/opt/redis'
property :download_source, String, default: 'http://download.redis.io/releases'

action :create do
  build_essential 'install_packages'

  directory new_resource.install_root_prefix do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end

  remote_file "#{new_resource.install_root_prefix}/#{download_filename}" do
    source download_url
    owner 'root'
    group 'root'
    checksum new_resource.checksum
    # notifies :run, 'execute[extract-redis]', :immediately
    action :create
  end

  execute 'extract-redis' do
    command "tar -xvzf #{download_filename}"
    cwd new_resource.install_root_prefix
    # notifies :run, 'execute[make-redis]', :immediately
    creates extracted_path
    action :run
  end

  execute 'make-redis' do
    command 'make'
    cwd extracted_path
    creates "#{extracted_path}/src/redis-server"
    # notifies :run, 'execute[make-test-redis]', :immediately
    action :run
  end

  redis_bins.each do |bin|
    link "/usr/local/bin/#{bin}" do
      to "#{extracted_path}/src/#{bin}"
      action :create
    end
  end
end

action :remove do
  directory new_resource.install_root_prefix do
    recursive true
    action :delete
  end

  redis_bins.each do |bin|
    link "/usr/local/bin/#{bin}" do
      only_if { ::File.symlink?("/usr/local/bin/#{bin}") }
      action :delete
    end
  end
end

action_class do
  def version_slug
    "redis-#{new_resource.version}"
  end

  def download_url
    "#{new_resource.download_source}/#{download_filename}"
  end

  def download_filename
    "#{version_slug}.tar.gz"
  end

  def extracted_path
    "#{new_resource.install_root_prefix}/#{version_slug}"
  end

  def redis_bins
    %w(redis-server redis-cli)
  end
end
