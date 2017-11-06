# # encoding: utf-8

# Inspec test for recipe gr_redis::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe directory('/opt/redis/redis-4.0.2') do
  it { should exist }
end

describe file('/opt/redis/redis-4.0.2/src/redis-server') do
  it { should exist }
  it { should be_executable }
end

# make test requires tcl package
# "\o/ All tests passed without errors!"
describe bash('cd /opt/redis/redis-4.0.2 && make test') do
  its('exit_status') { should eq 0 }
end
