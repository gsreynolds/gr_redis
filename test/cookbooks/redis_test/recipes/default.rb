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

gr_redis_source_installation '4.0.2' do
  action :create
end

# gr_redis_source_installation '4.0.2' do
#   action :remove
# end

# make test requires tcl package
package 'tcl'
