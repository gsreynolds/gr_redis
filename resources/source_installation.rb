default_action :create

# property :port, Integer, required: true, name_property: true # REDISPORT
# property :version, String # Redis version to install
# property :checksum, String # sha256 checksum of download

action :create do
  # https://redis.io/topics/quickstart
  # wget http://download.redis.io/redis-stable.tar.gz
  # tar xvzf redis-stable.tar.gz
  # cd redis-stable
  # make

  build_essential 'install_packages'

  directory '/opt/redis' do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end

  remote_file '/opt/redis/redis-4.0.2.tar.gz' do
    source 'http://download.redis.io/releases/redis-4.0.2.tar.gz'
    owner 'root'
    group 'root'
    checksum 'b1a0915dbc91b979d06df1977fe594c3fa9b189f1f3d38743a2948c9f7634813'
    # notifies :run, 'execute[extract-redis]', :immediately
    action :create
  end

  execute 'extract-redis' do
    command 'tar -xvzf redis-4.0.2.tar.gz'
    cwd '/opt/redis'
    # notifies :run, 'execute[make-redis]', :immediately
    creates '/opt/redis/redis-4.0.2'
    action :run
  end

  execute 'make-redis' do
    command 'make'
    cwd '/opt/redis/redis-4.0.2'
    creates '/opt/redis/redis-4.0.2/src/redis-server'
    # notifies :run, 'execute[make-test-redis]', :immediately
    action :run
  end
end

action :remove do
  directory '/opt/redis' do
    recursive true
    action :delete
  end
end
