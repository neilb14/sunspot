require 'sinatra/base'

module Sinatra #:nodoc:
  module SunspotExtension #:nodoc:
    # 
    # This module adds an after filter to Sinatra::Base that commits
    # the Sunspot session if any documents have been added, changed, or removed
    # in the course of the request.
    #
    def self.registered(app)
      app.after do
        if Sunspot::Sinatra.configuration.auto_commit_after_request?
          Sunspot.commit_if_dirty
        elsif Sunspot::Sinatra.configuration.auto_commit_after_delete_request?
          Sunspot.commit_if_delete_dirty
        end
      end
    end
  end

  register SunspotExtension
end
