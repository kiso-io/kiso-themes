#!/usr/bin/env rake
$: << "support"

## Bundler

begin
  require 'bundler'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks


## Doc

begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Dresssed'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


## Tests

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task :default => :test

namespace :test do
  desc "Run system tests"
  task :system do
    # Run in another sell to get a clean env
    FileList["test/system/*.rake"].each do |file|
      ruby "#{$0} -f #{file}"
    end
  end
end

task :test => 'test:system'


## Packaging

desc "Compile assets for packaging as a gem"
task :compile_assets do
  require "css_rewriter"

  cd "test/dummy" do
    sh "rake assets:clobber"
    sh "rake assets:precompile"
    sh "rake non_digested"
  end

  mkdir_p "app/assets/stylesheets/dresssed"

  puts "Processing CSS files to app/assets/stylesheets/dresssed"
  puts "Looking for files in: #{"test/dummy/public/assets/styles/{#{Dresssed::Ives::STYLES * ','}}.css"}"
  css_files = FileList["test/dummy/public/assets/styles/{#{Dresssed::Ives::STYLES * ','}}.css"]
  css_files.each do |file|
    puts "Processing #{file}"
    CssRewriter.compile(file, "app/assets/stylesheets/dresssed")
  end

  cd "test/dummy" do
    sh "rake assets:clobber"
  end
end

task :deploy_demo do
  sh "git push heroku `git subtree split --prefix test/dummy master`:master --force"
end

task :build => :compile_assets
