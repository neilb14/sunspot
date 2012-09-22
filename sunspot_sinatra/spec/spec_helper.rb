ENV['SINATRA_ENV'] = 'test'
if rsolr_version = ENV['RSOLR_GEM_VERSION']
  STDERR.puts("Forcing RSolr version #{rsolr_version}")
  gem "rsolr", rsolr_version
end

require File.expand_path('config/environment', ENV['SINATRA_ROOT'])

begin
  require 'rspec'
  require 'rspec/sinatra'
rescue LoadError => e
  require 'spec'
  require 'spec/sinatra'
end
require 'rake'
require File.join('sunspot', 'sinatra', 'solr_logging')

def load_schema
  stdout = $stdout
  $stdout = StringIO.new # suppress output while building the schema
  load File.join(ENV['SINATRA_ROOT'], 'db', 'schema.rb')
  $stdout = stdout
end

def silence_stderr(&block)
  stderr = $stderr
  $stderr = StringIO.new
  yield
  $stderr = stderr
end

rspec =
  begin
    RSpec
  rescue NameError, ArgumentError
    Spec::Runner
  end

# Load all shared examples
Dir[File.expand_path("shared_examples/*.rb", File.dirname(__FILE__))].each {|f| require f}

rspec.configure do |config|
  config.before(:each) do
    load_schema
    Sunspot.remove_all!
  end
end
