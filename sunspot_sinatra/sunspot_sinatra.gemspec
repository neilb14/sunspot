# -*- encoding: utf-8 -*-
lib = File.expand_path('../../sunspot/lib/', __FILE__)

$:.unshift(lib) unless $:.include?(lib)

require 'sunspot/version'

Gem::Specification.new do |s|
  s.name        = "sunspot_sinatra"
  s.version     = Sunspot::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Mat Brown', 'Peer Allan', 'Dmitriy Dzema', 'Benjamin Krause', 'Marcel de Graaf', 'Brandon Keepers', 'Peter Berkenbosch',
                  'Brian Atkinson', 'Tom Coleman', 'Matt Mitchell', 'Nathan Beyer', 'Kieran Topping', 'Nicolas Braem', 'Jeremy Ashkenas',
                  'Dylan Vaughn', 'Brian Durand', 'Sam Granieri', 'Nick Zadrozny', 'Jason Ronallo', 'Neil Bourgeois']
  s.email       = ["neil.bourgeois@gmail.com"]
  s.homepage = 'http://github.com/neilb14/sunspot/tree/master/sunspot_sinatra'
  s.summary     = 'Sinatra integration for the Sunspot Solr search library'
  s.description = <<-TEXT
    Sunspot::Sinatra is an extension to the Sunspot library for Solr search.
    Sunspot::Sinatra adds integration between Sunspot and ActiveRecord, including
    defining search and indexing related methods on ActiveRecord models themselves,
    running a Sunspot-compatible Solr instance for development and test
    environments, and automatically commit Solr index changes at the end of each
    Rails request.
  TEXT

  s.rubyforge_project = "sunspot-sinatra"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'sunspot', Sunspot::VERSION
  s.add_dependency 'nokogiri'

  s.add_development_dependency 'rspec', '~> 1.2'

  s.rdoc_options << '--webcvs=http://github.com/neilb14/sunspot/tree/master/%s' <<
                  '--title' << 'Sunspot-Sinatra - Sinatra integration for the Sunspot Solr search library - API Documentation' <<
                  '--main' << 'README.rdoc'
end
