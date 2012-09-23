require File.expand_path('spec_helper', File.dirname(__FILE__))
require File.expand_path('test_app.rb', ENV['SINATRA_ROOT'])

describe "Sinatra Application Request Lifecycle" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before(:each) do
    Sunspot::Sinatra.configuration = @configuration = Sunspot::Sinatra::Configuration.new
  end

  after(:each) do
    Sunspot::Sinatra.configuration = nil
  end

  it 'should automatically commit after each action if specified' do
    @configuration.user_configuration = { 'auto_commit_after_request' => true }
    Sunspot.should_receive(:commit_if_dirty)
    post :create, :post => { :title => 'Test 1' }
  end
  
  it 'should not commit, if configuration is set to false' do
    @configuration.user_configuration = { 'auto_commit_after_request' => false }
    Sunspot.should_not_receive(:commit_if_dirty)
    post :create, :post => { :title => 'Test 1' }
  end

  it 'should commit if configuration is not specified' do
    @configuration.user_configuration = {}
    Sunspot.should_receive(:commit_if_dirty)
    post :create, :post => { :title => 'Test 1' }
  end
  
  ### auto_commit_if_delete_dirty
  
  it 'should automatically commit after each delete if specified' do
    @configuration.user_configuration = { 'auto_commit_after_request' => false,
                                          'auto_commit_after_delete_request' => true }
    Sunspot.should_receive(:commit_if_delete_dirty)
    post :create, :post => { :title => 'Test 1' }
  end
  
  it 'should not automatically commit on delete if configuration is set to false' do
    @configuration.user_configuration = { 'auto_commit_after_request' => false,
                                          'auto_commit_after_delete_request' => false }
    Sunspot.should_not_receive(:commit_if_delete_dirty)
    post :create, :post => { :title => 'Test 1' }
  end

  it 'should not automatically commit on delete if configuration is not specified' do
    @configuration.user_configuration = { 'auto_commit_after_request' => false }
    Sunspot.should_not_receive(:commit_if_delete_dirty)
    post :create, :post => { :title => 'Test 1' }
  end
end
