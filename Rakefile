#!/usr/bin/env rake
$: << "support"

## Bundler

begin
  require 'bundler'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks

require 'version_bumper'

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
    sh "DRESSSED_BUILD=true rake assets:clobber"
    sh "DRESSSED_BUILD=true bundle exec rake assets:precompile"
    sh "DRESSSED_BUILD=true rake non_digested"
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
    sh "DRESSSED_BUILD=true rake assets:clobber"
  end
end

task :deploy_demo do
  cd "test/dummy" do
    sh "RAILS_ENV=production bundle update dresssed-ives"
  end
  sh "git add . && git commit -m 'Update Ives in demo site' && git push"
  sh "git push heroku `git subtree split --prefix test/dummy master`:master --force"
end

task :release_version do
  sh "rake bump:revision"
  cd "pkg" do
    sh "rm -rf *"
  end
  Rake::Task["build"].invoke
  latest_version = File.read('./VERSION')
  cd "../dresssed.com" do
    sh "bundle exec rake gems:push gem=../dresssed-ives/pkg/dresssed-ives-#{latest_version}.gem"

    puts system('test -z "$(git ls-files --others)"')

    sh "git add . && git commit -m 'Ives #{latest_version}' && git push"
    sh "bundle exec cap production deploy"
  end

  sh "git add . && git commit -m 'Ives #{latest_version}' && git push"
end

task :make_demo do
  sh "rm -rf demo/"
  cd "test/dummy" do
    start_server
    sh "wget --mirror -nv -p --html-extension --page-requisites --no-use-server-timestamps --convert-links -P ../../demo http://localhost:4000; true"
    stop_server
  end

  cd "demo/localhost:4000" do
    Dresssed::Ives::STYLES.each do |style|
      sh "cp -R preview #{style.downcase}_preview"
      cd "#{style.downcase}_preview" do
        sh "perl -i -pe 's/black.self/#{style.downcase}.self/g' ./* "
      end
      sh "cp ../../app/assets/stylesheets/dresssed/#{style}.css.erb assets/styles/#{style}.self.css?body=1.css"
      cd "assets/styles" do
        sh "perl -i -pe 's,<%=\s?asset_path \",../,g' ./* "
        sh "perl -i -pe 's,\" %>,,g' ./* "
      end
    end
    sh "rm -rf preview"
  end

  cd "demo/localhost:4000/assets/ionicons" do
    sh 'for file in *.*\?*; do mv "$file" "${file%%\?*}"; done '
  end

  cd "demo/localhost:4000/assets/bootstrap" do
    sh 'for file in *.*\?*; do mv "$file" "${file%%\?*}"; done '
  end
end

task :release_demo do
  uploader = S3FolderUpload.new('demo/localhost:4000', 'kantan-dresssed-demos/demos/ives', ENV['DRESSSED_AWS_ACCESS_KEY_ID'], ENV['DRESSSED_AWS_SECRET_ACCESS_KEY'])
  uploader.upload!()
end

def server_running?
  File.file?('tmp/pids/server.pid')
end

def start_server(stop_at_exit=true)
  sh "DRESSSED_BUILD=true bundle exec rails server thin -d -p 4000"
  sleep 0.1 until server_running?
  at_exit { stop_server(!:wait) } if stop_at_exit
end

def stop_server(wait=true)
  return unless server_running?
  # Make sure process never exit w/ error code.
  sh 'kill -INT `cat tmp/pids/server.pid 2> /dev/null` 2> /dev/null || echo'
  sh 'spring stop'
  sleep 0.1 while server_running? if wait
end

task :build => :compile_assets

require 'aws-sdk'
class S3FolderUpload
  attr_reader :folder_path, :total_files, :s3_bucket
  attr_accessor :files

  # Initialize the upload class
  #
  # folder_path - path to the folder that you want to upload
  # bucket - The bucket you want to upload to
  # aws_key - Your key generated by AWS defaults to the environemt setting AWS_KEY_ID
  # aws_secret - The secret generated by AWS
  #
  # Examples
  #   => uploader = S3FolderUpload.new("some_route/test_folder", 'your_bucket_name')
  #
  def initialize(folder_path, bucket, aws_key, aws_secret)
    puts "Connecting with AWS_KEY=#{aws_key} AWS_SECRET=#{aws_secret}"

    @folder_path       = folder_path
    @files             = Dir.glob("#{folder_path}/**/*")
    @total_files       = files.length
    @connection        = Aws::S3::Resource.new({
      region: 'us-east-1',
      credentials: Aws::Credentials.new(aws_key, aws_secret),
    })
    @s3_bucket         = @connection.bucket(bucket)
  end

  def upload!(thread_count = 5)
    file_number = 0
    mutex       = Mutex.new
    threads     = []

    thread_count.times do |i|
      threads[i] = Thread.new {
        until files.empty?
          mutex.synchronize do
            file_number += 1
            Thread.current["file_number"] = file_number
          end
          file = files.pop rescue nil
          next unless file

          path = file

          puts "[#{Thread.current["file_number"]}/#{total_files}] uploading..."

          if File.directory?(path)
            next
          else
            puts "...Uploading to: #{path.gsub('demo/localhost:4000/', '')}"
            @s3_bucket.object(path.gsub('demo/localhost:4000/', '')).upload_file(path, acl:'public-read')
          end
        end
      }
    end
    threads.each { |t| t.join }
  rescue Aws::S3::Errors::AccessDenied => e
    puts e.message
  end
end
