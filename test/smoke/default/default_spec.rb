describe port(6379) do
  it { should be_listening }
  its('processes') {should include 'redis-server'}
end

describe command("hab pkg exec core/redis redis-cli ping") do
  its('exit_status') { should eq 0 }
  its(:stdout) { should match 'PONG' }
end
