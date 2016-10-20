#!/usr/bin/env rake
$: << "support"

begin
  require 'bundler'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks name: 'dresssed-ives'

def setup_bundler
  begin
    require 'bundler'
  rescue LoadError
    puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
  end
end

require 'version_bumper'

## Packaging
task :build => :compile_assets

desc "Compile assets for packaging as a gem"
task :compile_assets do
  require "css_rewriter"

  cd "test/dummy" do
    setup_bundler
    sh "DRESSSED_BUILD=true bundle exec rake assets:clobber"
    sh "DRESSSED_BUILD=true bundle exec rake assets:precompile"
    sh "DRESSSED_BUILD=true bundle exec rake non_digested"
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
    sh "DRESSSED_BUILD=true bundle exec rake assets:clobber"
  end
  sh "rake bump:revision"
end

task :deploy_demo do
  sh "rsync -cavtX --delete ./demo/localhost:4000/ deploy@192.241.204.175:/home/deploy/apps/dressseddotcom_production/shared/public/demos/ives/;"
end

task :release_version do
  cd "pkg" do
    sh "rm -rf *"
  end
  Rake::Task["build"].invoke
  latest_version = File.read('./VERSION')
  sh "git changelog"
  sh "cp VERSION ../dresssed.com/db/themes/ives/ && cp CHANGELOG ../dresssed.com/db/themes/ives/"

  cd "../dresssed.com" do
    sh "bundle exec rake gems:push gem=../dresssed-ives/pkg/dresssed-ives-#{latest_version}.gem"

    puts system('test -z "$(git ls-files --others)"')

    sh "git add . && git commit -m 'Ives #{latest_version}' && git push"
    sh "bundle exec cap production deploy"
  end

  sh "git add . && git commit -m 'Ives #{latest_version}' && git tag #{latest_version} && git push"
end

task :make_demo do
  sh "rm -rf demo/"
  cd "test/dummy" do
    setup_bundler
    start_server
    sh "wget --mirror -nv -p --html-extension --page-requisites --no-use-server-timestamps --convert-links -P ../../demo http://localhost:4000; true"
    stop_server
  end

  cd "demo/localhost:4000" do
    Dresssed::Ives::STYLES.each do |style|
      sh "cp -R preview #{style.downcase}_preview"
      cd "#{style.downcase}_preview" do
        sh "perl -i -pe 's/white.self/#{style.downcase}.self/g' ./* "
        sh "perl -i -pe 's{http://}{//}g' ./* "
        sh "cp main.html index.html"
      end
      sh "cp ../../app/assets/stylesheets/dresssed/#{style}.css.erb assets/styles/#{style}.self.css?body=1.css"
      cd "assets/styles" do
        sh "perl -i -pe 's,<%=\s?asset_path \",../,g' ./* "
        sh "perl -i -pe 's,\" %>,,g' ./* "
      end
      sh "mkdir #{style.downcase}_preview/assets"
      sh "cp ../../test/dummy/app/assets/flash/ZeroClipboard.swf #{style.downcase}_preview/assets/"
    end
    sh "rm -rf preview"
  end

  cd "demo/localhost:4000/assets/ionicons" do
    sh 'for file in *.*\?*; do mv "$file" "${file%%\?*}"; done '
  end

  cd "demo/localhost:4000/assets/bootstrap" do
    sh 'for file in *.*\?*; do mv "$file" "${file%%\?*}"; done '
    sh 'mv glyphicons-halflings-regular.woff2.html glyphicons-halflings-regular.woff2'
  end

  cd "demo/localhost:4000/assets/mdiicons" do
    sh 'mv MaterialIcons-Regular.woff2.html MaterialIcons-Regular.woff2'
    sh 'mv MaterialIcons-Regular.eot? MaterialIcons-Regular.eot'
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

namespace :test do
  desc "Run system tests"
  task :system do
    setup_bundler
    # Run in another sell to get a clean env
    FileList["test/system/*.rake"].each do |file|
      ruby "#{$0} -f #{file}"
    end
  end
end

task :test => 'test:system'
