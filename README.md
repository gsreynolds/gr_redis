# gr_redis cookbook

[![Build Status](https://travis-ci.org/gsreynolds/gr_redis.svg?branch=master)](https://travis-ci.org/gsreynolds/gr_redis)

This cookbook provides resources to install Redis from source and create instance configurations, based on the [Redis Quick Start](https://redis.io/topics/quickstart) and the [Digital Ocean - How To Install and Configure Redis](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04) guides.

## Requirements

### Platforms

This cookbook is tested on the following platforms:
- Ubuntu 16.04
- CentOS 7

### Chef

- Chef 12.5+

### Cookbooks

- build_essential

## Resources

### gr_redis_source_installation

#### Actions

- `create` - (default) Downloads and installs Redis.
- `remove` - Removes the Redis installation.

#### Properties

- `version` - Redis version to install.
- `checksum` - SHA256 checksum of Redis version tar.gz download.
- `install_root_prefix` - Path to download Redis to and extract into (default: `/opt/redis`).
- `download_source` - URL for Redis release mirror (default: `http://download.redis.io/releases`)

### gr_redis_configuration

#### Actions

- `create` - (default) Creates Redis instance on the specified port.
- `remove` - Removes the Redis instance.

#### Properties

- `port` - Port to create Redis instance configuration for (REDISPORT).
- `bind` - Interface address to bind Redis to (default: `127.0.0.1`).
- `config_dir` - Directory to store instance configuration in (default: `/etc/redis`).
- `data_dir_prefix` - Directory to create database working directory within (default: `/var/lib/redis`).
- `log_dir` - Directory to store instance logs in (default: `/var/log/redis`).
- `redis_user` - User to create and run Redis instance as (default: `redis`).
- `redis_group` - Group to create, add `redis_user` to and run Redis instance as (default: `redis`).
- `requirepass` - Password to require clients to authenticate with using the [AUTH command](https://redis.io/commands/auth) (default: ).
- `restart_on_conf_change` - Control whether Redis should be restarted on configuration changes (default: `true`).

## Testing


## Known Limitations
- The cookbook currently assumes that only one version of Redis will be installed on a node and used for all Redis instances.
- The cookbook currently only has configuration properties for a subset for the available options in `redis.conf`.
- The cookbook currently does not configure [redis-sentinel](https://redis.io/topics/sentinel) or [cluster mode](https://redis.io/topics/cluster-tutorial).

## License & Authors

- Author: Gavin Reynolds (<gsreynolds@gmail.com>)

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
