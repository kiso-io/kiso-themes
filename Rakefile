#!/usr/bin/env rake
$: << "support"

begin
  require 'bundler'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks name: 'dresssed'

def setup_bundler
  begin
    require 'bundler'
  rescue LoadError
    puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
  end
end

require 'version_bumper'
require 'page_rewriter'

task :check_dressseddotcom_on_master do
  cd "../dresssed.com", verbose: false do
    branch_name = `git rev-parse --abbrev-ref HEAD`.chomp
    if branch_name != 'master'
      puts "🚨  CANNOT RELEASE: dresssed.com is not on master"
      exit
    end
  end
end

## Packaging
task :build => :compile_assets

desc "Compile assets for packaging as a gem"
task :compile_assets do
  require "css_rewriter"

  cd "test/dummy", verbose: false do
    setup_bundler
    puts "💥  Clobbering the old assets..."
    sh "DRESSSED_BUILD=true bundle exec rake assets:clobber"
    puts "👷  Precompiling assets..."
    sh "DRESSSED_BUILD=true bundle exec rake assets:precompile"
    sh "DRESSSED_BUILD=true bundle exec rake non_digested"
  end

  mkdir_p "app/assets/stylesheets/dresssed"

  puts "Processing CSS files to app/assets/stylesheets/dresssed"

  themes = Dresssed::THEMES

  themes.each do |theme|
    styles = Kernel.const_get("Dresssed::#{theme.capitalize}::COLORS")
    css_files = FileList["test/dummy/public/assets/styles/#{theme.downcase}/{#{styles * ','}}.css"]
    puts "🔎  Looking for files in: #{"test/dummy/public/assets/styles/#{theme.downcase}/{#{styles * ','}}.css"}"
    css_files.each do |file|
      puts "👷  Processing #{file}"
      CssRewriter.compile(file, "app/assets/stylesheets/dresssed/#{theme.downcase}")
    end
  end

  cd "test/dummy", verbose: false do
    sh "DRESSSED_BUILD=true bundle exec rake assets:clobber"
  end

end

task :release_version do

  puts "🚦  Checking if repo dresssed.com is on master..."
  Rake::Task["check_dressseddotcom_on_master"].invoke

  puts "👷  Cleaning out pkg directory"
  cd "pkg", verbose: false do
    sh "rm -rf *"
  end

  puts "🚧  Building release..."
  Rake::Task["build"].invoke

  puts "🎉  Bumping version number..."
  sh "rake bump:revision"

  latest_version = File.read('./VERSION')

  puts "📖  Generating changelog..."
  sh "git changelog"
  sh "cp VERSION ../dresssed.com/db/themes/ives/ && cp CHANGELOG ../dresssed.com/db/themes/ives/"

  puts "🚚  Pushing release to dresssed.com"
  cd "../dresssed.com", verbose: false do
    sh "bundle exec rake gems:push gem=../dresssed-ives/pkg/dresssed-ives-#{latest_version}.gem"

    puts system('test -z "$(git ls-files --others)"')

    sh "git add . && git commit -m 'Ives #{latest_version}' && git push"
    sh "bundle exec cap production deploy"
  end

  puts "🐱  Tagging and pushing latest version"
  sh "git add . && git commit -m 'Ives #{latest_version}' && git tag #{latest_version} && git push"
end

task :deploy_demo do
  sh "rsync -cavtX --delete ./demo/localhost:4000/ deploy@192.241.204.175:/home/deploy/apps/dressseddotcom_production/shared/public/demos/ives/;"
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

require 'fileutils'

task :bake_app_pages do
  app_page_targets = [
    '007_app_pages@ti-layout/',
  ]

  app_page_target_path = 'test/dummy/app/views/preview/elements'
  app_page_destination_path = 'lib/generators/dresssed/templates/views/app_pages'

  sh "rm -rf #{app_page_destination_path}"

  app_page_targets.each do |target|
    source_path = File.join( Dir.pwd, app_page_target_path, target, '/*' )
    files = Dir.glob(source_path).select { |f| f != '.' && f != '..' && f != '.DS_Store' && !File.directory?(f) }

    files.each do |raw_path|
      file = raw_path.gsub(/\$/, "\\$")

      destination = raw_path.gsub(/\d{1,3}_/, '').gsub(/\$minimal|\$app_nav/, '').gsub(/#{File.join(Dir.pwd, app_page_target_path)}/, '').gsub(/@[\w-]*/, '')
      destination = File.join(Dir.pwd, app_page_destination_path, destination)

      sh "mkdir -p #{File.dirname(destination)}"
      sh "cp #{file} #{destination}"
    end

    directories = Dir.glob(source_path).select { |f| f != '.' && f != '..' && f != '.DS_Store' && File.directory?(f) }
    directories.each do |raw_dir_path|

      # Calculate what the destination directory is based on the parent folder name
      destination_dir = File.join(Dir.pwd, app_page_destination_path, raw_dir_path.split('/').reverse[0])

      # Create the destination diretory
      sh "mkdir -p #{File.dirname(destination_dir)}"

      # Now list all of the files in the target path
      files = Dir.glob(File.join(raw_dir_path, '/**/*')).select { |f| f != '.' && f != '..' && f != '.DS_Store' }

      files.each do |raw_path|
        page_type = File.dirname(raw_path).split('/').reverse[0]

        if File.directory?(raw_path)
          sh "cp -R #{raw_path} #{File.join(destination_dir, raw_path.split('/').reverse[0])}"
        else
          file = raw_path.gsub(/\$/, "\\$")

          destination_file = raw_path.gsub(/\d{1,3}_/, '')
            .gsub(/\$minimal|\$app_nav/, '')
            .gsub(/#{File.join(Dir.pwd, app_page_target_path)}\/app_pages/, '')
            .gsub(/@[\w-]*/, '')
            .gsub(/#{page_type}_/, '')

          destination_file = File.join(Dir.pwd, app_page_destination_path, destination_file)

          sh "mkdir -p #{destination_dir}"
          sh "cp #{file} #{destination_file}"
          PageRewriter.compile(destination_file, /preview\/elements\/007_app_pages@ti-layout\/#{page_type}\//, '')
        end
      end
    end
  end
end

task :bake_generatable_views do
  Rake::Task["bake_app_pages"].invoke
  Rake::Task["bake_pages"].invoke
  Rake::Task["bake_content_blocks"].invoke
  Rake::Task["bake_layouts"].invoke
end

task :bake_pages do
  require 'content_block_rewriter'

  page_targets = [
    '001_dashboards@ti-dashboard',
    '002_analytics@ti-pulse',
    '008_frontend_pages@ti-home/001_landing_pages',
    '008_frontend_pages@ti-home/002_pricing_pages',
    '008_frontend_pages@ti-home/008_faq_pages',
    '008_frontend_pages@ti-home/009_legal_pages',
    '008_frontend_pages@ti-home/010_blog_pages',
    '008_frontend_pages@ti-home/010_error_pages',
  ]

  base_target_path = 'test/dummy/app/views/preview/elements'
  base_destination_path = 'lib/generators/dresssed/templates/views'

  page_targets.each do |target|
    path = File.join(Dir.pwd, base_target_path, target, '/**/*')
    files = Dir.glob(path).select { |f| f != '.' && f != '..' && f != '.DS_Store' && !File.directory?(f) }

    files.each do |raw_path|
      file = raw_path.gsub(/\$/, "\\$")

      destination = raw_path.gsub(/\d{1,3}_/, '').gsub(/\$minimal|\$app_nav/, '').gsub(/#{File.join(Dir.pwd, base_target_path)}/, '').gsub(/@[\w-]*/, '')
      destination = File.join(Dir.pwd, base_destination_path, destination)

      sh "mkdir -p #{File.dirname(destination)}"
      sh "cp #{file} #{destination}"
      PageRewriter.compile(destination, /preview.+\/_content_block_(.+)\/(\d+)/, 'content_blocks/\1/\2')
    end
  end
end

task :bake_layouts do
  layout_destination_path = File.join(Dir.pwd, 'lib/generators/dresssed/templates/layouts')
  layout_path = File.join(Dir.pwd, 'test/dummy/app/views/layouts/*')
  layout_files = Dir.glob(layout_path).select { |f| f != '.' && f != '..' && f != '.DS_Store' && !File.directory?(f) }

  layout_files.each do |raw_path|
    sh "mkdir -p #{File.dirname(raw_path)}"
    sh "cp #{raw_path} #{layout_destination_path}"
    PageRewriter.compile(File.join(layout_destination_path, File.basename(raw_path)), /styles\/\#{current_theme.downcase}\/\#{current_style}/, 'application')
  end
end

task :bake_content_blocks do
  content_block_targets = [
    '006_content_blocks@ti-view-list/_content_block_app_navs',
    '006_content_blocks@ti-view-list/_content_block_basic',
    '006_content_blocks@ti-view-list/_content_block_general',
    '006_content_blocks@ti-view-list/_content_block_headers',
    '006_content_blocks@ti-view-list/_content_block_landing_navs',
  ]

  base_target_path = 'test/dummy/app/views/preview/elements'

  content_block_destination_path = File.join(Dir.pwd, 'app/views/content_blocks')

  content_block_targets.each do |target|
    path = File.join(Dir.pwd, base_target_path, target, '/**/*')
    files = Dir.glob(path).select { |f| f != '.' && f != '..' && f != '.DS_Store' && !File.directory?(f) }

    content_block_type_name = target.gsub(/006_content_blocks@ti-view-list\/_content_block_/, '')

    files.each do |raw_path|
      destination_file_name = raw_path
      destination = File.join(content_block_destination_path, content_block_type_name, File.basename(raw_path))

      sh "mkdir -p #{File.dirname(destination)}"
      sh "cp #{raw_path} #{destination}"
    end
  end

end
