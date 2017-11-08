control 'redis-1-installation' do
  title 'Redis Server: Installation from source'
  desc  ''

  describe directory('/opt/redis/redis-4.0.2') do
    it { should exist }
    it { should be_owned_by 'root' }
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

  # describe bash('cd /opt/redis/redis-4.0.2 && make test') do
  #   its('exit_status') { should eq 0 }
  #   its(:stdout) { should match '\o/ All tests passed without errors!' }
  # end
end
