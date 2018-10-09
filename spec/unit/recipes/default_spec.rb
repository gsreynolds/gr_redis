#
# Cookbook:: gr_redis
# Spec:: default
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

require 'spec_helper'

describe 'gr_redis::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu',
                                          version: '16.04',
                                          step_into: %w(gr_redis_source_installation
                                                        gr_redis_instance)
                                         )
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates gr redis source installation' do
      expect(chef_run).to create_gr_redis_source_installation('4.0.11')
    end

    it 'creates gr redis configuration' do
      expect(chef_run).to create_gr_redis_instance('6379')
    end
  end
end
