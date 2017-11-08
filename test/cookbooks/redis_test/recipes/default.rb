#
# Cookbook:: redis_test
# Recipe:: default
#
# Copyright:: 2017, Gavin Reynolds
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Update apt, no-op on non-debian family
apt_update 'apt_update' do
  frequency 86400
  action :periodic
end

gr_redis_source_installation '4.0.2' do
  checksum 'b1a0915dbc91b979d06df1977fe594c3fa9b189f1f3d38743a2948c9f7634813'
  action :create
end

gr_redis_configuration '6379' do
  requirepass 'iloverandompasswordsbutthiswilldo'
  action :create
end

gr_redis_configuration '6380' do
  requirepass 'test'
  data_dir '/var/redis-2'
  action :create
end

# make test requires tcl package
package 'tcl'
