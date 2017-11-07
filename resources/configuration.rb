default_action :create

property :port, Integer, required: true, name_property: true # REDISPORT
property :config_dir, String, default: '/etc/redis'
property :data_dir, String, default: '/var/redis'

action :create do
end

action :remove do
end
