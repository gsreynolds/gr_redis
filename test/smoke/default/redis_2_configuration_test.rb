# FIXME: DRY instance examples
control 'redis-2-configuration' do
  title 'Redis Server: Default configuration for port 6379'
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

  describe file('/etc/systemd/system/redis-6379.service') do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
  end

  describe file('/etc/redis/redis-6379.env') do
    it { should_not exist }
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
