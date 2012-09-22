require 'sunspot'
require File.join(File.dirname(__FILE__), 'sinatra', 'configuration')
require File.join(File.dirname(__FILE__), 'sinatra', 'adapters')
require File.join(File.dirname(__FILE__), 'sinatra', 'request_lifecycle')
require File.join(File.dirname(__FILE__), 'sinatra', 'searchable')

module Sunspot #:nodoc:
  module Sinatra #:nodoc:
    autoload :SolrInstrumentation, File.join(File.dirname(__FILE__), 'sinatra', 'solr_instrumentation')
    autoload :StubSessionProxy, File.join(File.dirname(__FILE__), 'sinatra', 'stub_session_proxy')
    begin
      require 'sunspot_solr'
      autoload :Server, File.join(File.dirname(__FILE__), 'sinatra', 'server')
    rescue LoadError => e
      # We're fine
    end

    class <<self
      attr_writer :configuration

      def configuration
        @configuration ||= Sunspot::Sinatra::Configuration.new
      end

      def reset
        @configuration = nil
      end

      def build_session(configuration = self.configuration)
        if configuration.disabled?
          StubSessionProxy.new(Sunspot.session)
        elsif configuration.has_master?
          SessionProxy::MasterSlaveSessionProxy.new(
            SessionProxy::ThreadLocalSessionProxy.new(master_config(configuration)),
            SessionProxy::ThreadLocalSessionProxy.new(slave_config(configuration))
          )
        else
          SessionProxy::ThreadLocalSessionProxy.new(slave_config(configuration))
        end
      end

      private

      def master_config(sunspot_sinatra_configuration)
        config = Sunspot::Configuration.build
        config.solr.url = URI::HTTP.build(
          :host => sunspot_sinatra_configuration.master_hostname,
          :port => sunspot_sinatra_configuration.master_port,
          :path => sunspot_sinatra_configuration.master_path
        ).to_s
        config
      end

      def slave_config(sunspot_sinatra_configuration)
        config = Sunspot::Configuration.build
        config.solr.url = URI::HTTP.build(
          :host => sunspot_sinatra_configuration.hostname,
          :port => sunspot_sinatra_configuration.port,
          :path => sunspot_sinatra_configuration.path
        ).to_s
        config
      end
    end
  end
end
