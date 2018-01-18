redis_instances = attribute('instances', default: [], description: 'An array of redis instance port and passwords')

redis_instances.each do |instance|
  control "redis-2-instance-#{instance['port']}" do
    title "Redis Server: Default instance configuration for port #{instance['port']}"
    desc  ''

    describe directory('/etc/redis') do
      it { should exist }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'redis' }
      its('mode') { should cmp '0750' }
    end

    ["/var/lib/redis/redis-#{instance['port']}", '/var/log/redis'].each do |dir|
      describe directory(dir) do
        it { should exist }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'redis' }
        its('mode') { should cmp '0770' }
      end
    end

    describe file("/etc/redis/redis-#{instance['port']}.conf") do
      it { should exist }
      it { should be_owned_by 'root' }
      it { should be_readable.by_user 'redis' }
      its('mode') { should cmp '0640' }
    end

    describe file("/etc/systemd/system/redis-#{instance['port']}.service") do
      it { should exist }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its('mode') { should cmp '0644' }
    end

    if instance['password'].empty?
      describe file("/etc/redis/redis-#{instance['port']}.env") do
        it { should_not exist }
      end
    else
      describe file("/etc/redis/redis-#{instance['port']}.env") do
        it { should exist }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        its('mode') { should cmp '0600' }
      end
    end

    describe service("redis-#{instance['port']}") do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end

    authpass = instance['password'].empty? ? '' : " -a #{instance['password']}"
    describe command("/usr/local/bin/redis-cli -p #{instance['port']}#{authpass} ping") do
      its('exit_status') { should eq 0 }
      its(:stdout) { should match 'PONG' }
    end

    describe command("/usr/local/bin/redis-cli -p #{instance['port']}#{authpass} save") do
      its('exit_status') { should eq 0 }
      its(:stdout) { should match 'OK' }
    end

    describe file("/var/log/redis/redis-#{instance['port']}.log") do
      it { should exist }
    end

    describe file("/var/lib/redis/redis-#{instance['port']}/dump.rdb") do
      it { should exist }
    end
  end
end
