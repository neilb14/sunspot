require 'fileutils'

namespace :spec do
  def sinatra_app_path
    File.join(File.dirname(__FILE__), "..", "tmp", "sinatra_app")
  end

  def gemfile_path
    File.join(File.dirname(__FILE__), "..", "Gemfile")
  end

  def vendor_path
    File.expand_path("vendor/bundle", sinatra_app_path)
  end

  def sinatra_template_path
    File.join(File.dirname(__FILE__), "..", "spec", "sinatra_template")
  end

  task :run_with_sinatra => [:set_gemfile, :generate_sinatra_app, :run]

  task :set_gemfile do
    ENV['BUNDLE_PATH']    = vendor_path
    ENV['BUNDLE_GEMFILE'] = gemfile_path
    unless File.exist?(ENV['BUNDLE_PATH'])
      puts "Installing gems for Sinatra (this will only be done once)..."
      system("bundle install #{ENV['BUNDLE_ARGS']}") || exit(1)
    end
  end

  task :generate_sinatra_app do
    unless File.exist?(File.expand_path("app.rb", sinatra_app_path))
      puts "Generating Sinatra application..."
      FileUtils.cp_r File.join(sinatra_template_path, "."), sinatra_app_path
    end
  end

  task :run do
    ENV['BUNDLE_GEMFILE'] = gemfile_path
    ENV['SINATRA_ROOT']   = sinatra_app_path
    spec_command = "bundle exec rspec #{ENV['SPEC'] || 'spec/*_spec.rb'} --color"
    puts "== Running #{spec_command}"
    system(spec_command)
  end
end

def reenable_spec_tasks
  Rake::Task.tasks.each do |task|
    if task.name =~ /spec:/
      task.reenable
    end
  end
end

desc 'Run spec suite in all Sinatra versions'
task :spec do
  puts "Running specs against Sinatra..."
  reenable_spec_tasks
  Rake::Task['spec:run_with_sinatra'].invoke
end
