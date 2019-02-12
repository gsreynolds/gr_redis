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

describe 'gr_redis_source_installation' do
  # Normally ChefSpec skips running resources, but for this test we want to
  # actually run this one custom resource.
  step_into :gr_redis_source_installation
  # Nothing in this test is platform-specific, so use the latest Ubuntu for
  # simulated data.
  platform 'ubuntu'

  # Create an example group for testing the resource defaults.
  context 'with the defaults' do
    # Set the subject of this example group to a snippet of recipe code calling
    # our custom resource.
    recipe do
      gr_redis_source_installation '4.0.11' do
        checksum 'blah'
      end
    end

    # Confirm that the resources created by our custom resource's action are
    # correct. ChefSpec matchers all take the form `action_type(name)`.
    it { is_expected.to create_remote_file('/opt/redis/redis-4.0.11.tar.gz') }
  end

  # # Create a second example group to test a different block of recipe code.
  context 'with a different version and install root' do
    # Set the subject of this example group to a snippet of recipe code calling
    # our custom resource.
    recipe do
      gr_redis_source_installation '4.9.0' do
        checksum 'blah'
        install_root_prefix '/usr/local/redis'
      end
    end

    # Confirm that the resources created by our custom resource's action are
    # correct. ChefSpec matchers all take the form `action_type(name)`.
    it { is_expected.to create_remote_file('/usr/local/redis/redis-4.9.0.tar.gz') }
  end
end
