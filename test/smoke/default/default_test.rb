# # encoding: utf-8

# Inspec test for recipe gr_redis::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

control 'redis-installation' do
  title 'Redis Server: Installation'
  desc  ''

  describe directory('/opt/redis/redis-4.0.2') do
    it { should exist }
    it { should be_owned_by 'root' }
    # FIXME: permission tests
  end

  %w(redis-server redis-cli).each do |bin|
    describe file("/opt/redis/redis-4.0.2/src/#{bin}") do
      it { should exist }
      it { should be_executable }
    end

    describe file("/usr/local/bin/#{bin}") do
      it { should exist }
      it { should be_symlink }
    end
  end

  # make test requires tcl package
  # "\o/ All tests passed without errors!"
  # describe bash('cd /opt/redis/redis-4.0.2 && make test') do
  #   its('exit_status') { should eq 0 }
  # end
end

# FIXME: DRY port examples
control 'redis-configuration' do
  title 'Redis Server: Configuration for port 6379'
  desc  ''

  describe directory('/etc/redis') do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'redis' }
    its('mode') { should cmp '0750' }
  end

  %w(/var/lib/redis/redis-6379 /var/log/redis).each do |dir|
    describe directory(dir) do
      it { should exist }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'redis' }
      its('mode') { should cmp '0770' }
    end
  end

  describe file('/etc/redis/redis-6379.conf') do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_readable.by_user 'redis' }
    its('mode') { should cmp '0640' }
  end

  describe service('redis-6379') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe command('/usr/local/bin/redis-cli ping') do
    its('exit_status') { should eq 0 }
    its(:stdout) { should match 'PONG' }
  end

  describe command('/usr/local/bin/redis-cli save') do
    its('exit_status') { should eq 0 }
    its(:stdout) { should match 'OK' }
  end

  describe file('/var/log/redis/redis-6379.log') do
    it { should exist }
  end

  describe file('/var/lib/redis/redis-6379/dump.rdb') do
    it { should exist }
  end
end

control 'redis-configuration2' do
  title 'Redis Server: Configuration for port 6380 with requirepass'
  desc  ''

  describe directory('/etc/redis') do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'redis' }
    its('mode') { should cmp '0750' }
  end

  %w(/var/lib/redis/redis-6380 /var/log/redis).each do |dir|
    describe directory(dir) do
      it { should exist }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'redis' }
      its('mode') { should cmp '0770' }
    end
  end

  describe file('/etc/redis/redis-6380.conf') do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_readable.by_user 'redis' }
    its('mode') { should cmp '0640' }
  end

  describe service('redis-6380') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe command('/usr/local/bin/redis-cli -p 6380 -a iloverandompasswordsbutthiswilldo ping') do
    its('exit_status') { should eq 0 }
    its(:stdout) { should match 'PONG' }
  end

  describe command('/usr/local/bin/redis-cli -p 6380 -a iloverandompasswordsbutthiswilldo save') do
    its('exit_status') { should eq 0 }
    its(:stdout) { should match 'OK' }
  end

  describe file('/var/log/redis/redis-6380.log') do
    it { should exist }
  end

  describe file('/var/lib/redis/redis-6380/dump.rdb') do
    it { should exist }
  end
end
