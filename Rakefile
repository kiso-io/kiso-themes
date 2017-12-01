#!/usr/bin/env rake
$: << "support"

begin
  require 'bundler'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks name: 'rrt'

def setup_bundler
  begin
    require 'bundler'
  rescue LoadError
    puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
  end
end

require 'page_rewriter'

task :check_rrtdotcom_on_master do
  cd "../rrtdotcom", verbose: false do
    branch_name = `git rev-parse --abbrev-ref HEAD`.chomp
    if branch_name != 'master'
      puts "🚨  CANNOT RELEASE: rrtdotcom is not on master"
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
    sh "bundle exec rake assets:clobber"
    puts "👷  Precompiling assets..."
    sh "bundle exec rake assets:precompile"
    sh "bundle exec rake non_digested"
  end

  mkdir_p "app/assets/stylesheets/rrt"

  puts "Processing CSS files to app/assets/stylesheets/rrt"

  themes = RRT::THEMES

  themes.each do |theme|
    styles = Kernel.const_get("RRT::#{theme.capitalize}::COLORS")
    css_files = FileList["test/dummy/public/assets/styles/#{theme.downcase}/{#{styles * ','}}.css"]
    puts "🔎  Looking for files in: #{"test/dummy/public/assets/styles/#{theme.downcase}/{#{styles * ','}}.css"}"
    css_files.each do |file|
      puts "👷  Processing #{file}"
      CssRewriter.compile(file, "app/assets/stylesheets/rrt/#{theme.downcase}")
    end
  end

  cd "test/dummy", verbose: false do
    sh "DRESSSED_BUILD=true bundle exec rake assets:clobber"
  end

end

task :release_version do
  require 'version_bumper'

  puts "🚦  Checking if repo rrt.com is on master..."
  Rake::Task["check_rrtdotcom_on_master"].invoke

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
  sh "cp VERSION ../rrt.com/db/themes/ives/ && cp CHANGELOG ../rrt.com/db/themes/ives/"

  puts "🚚  Pushing release to rrt.com"
  cd "../rrt.com", verbose: false do
    sh "bundle exec rake gems:push gem=../rrt-ives/pkg/rrt-ives-#{latest_version}.gem"

    puts system('test -z "$(git ls-files --others)"')

    sh "git add . && git commit -m 'Ives #{latest_version}' && git push"
    sh "bundle exec cap production deploy"
  end

  puts "🐱  Tagging and pushing latest version"
  sh "git add . && git commit -m 'Ives #{latest_version}' && git tag #{latest_version} && git push"
end

task :deploy_demo do
  sh "rsync -cavtX --delete ./demo deployer@rapidrailsthemes.com:/home/deployer/apps/rrtdotcom/shared/public/demos;"
end

task :bake_product_shots do
  cd "test/dummy/product_shots" do
    sh "rm -rf shots/"
    sh "node build_product_shots.js"
  end
end

task :fix_stylesheets do
  RRT::THEMES.each do |theme|
    styles = Kernel.const_get("RRT::#{theme.capitalize}::COLORS")

    styles.each do |style|
      cd "demo/#{theme.downcase}/#{style.downcase}/assets/styles/#{theme.downcase}" do
        sh "mv #{style.downcase}.self* #{style.downcase}.self.css"

        # Remove the protocol scheme
        # sh "export LC_ALL=C; find . -type f -print0 | xargs -0 sed -i '' 's/http\:\\/\\//\\/\\//g'"
      end
      cd "demo/#{theme.downcase}/#{style.downcase}/preview" do
        sh "export LC_ALL=C; find . -type f -iregex '.*[css|html]' -print0 | xargs -0 sed -i '' 's/#{style.downcase}\.self\-.*\"/#{style.downcase}.self.css\"/g'"
      end
    end
  end
end

task :clean_demo do
  RRT::THEMES.each do |theme|
    styles = Kernel.const_get("RRT::#{theme.capitalize}::COLORS")

    styles.each do |style|
      cd "demo/#{theme.downcase}/#{style.downcase}/preview" do
        # Remove the protocol scheme
        #sh "export LC_ALL=C; find . -type f -print0 | xargs -0 sed -i '' 's/http\:\\/\\//\\/\\//g'"

        sh "export LC_ALL=C; find . -type f -iregex '.*[css|html]' -print0 | xargs -0 sed -i '' 's/data-image-src=\"\\/assets/data-image-src=\"\\/demos\\/#{theme.downcase}\\/#{style.downcase}\\/assets/g'"
      end

      cd "demo/#{theme.downcase}/#{style.downcase}/assets/styles/#{theme.downcase}" do
        sh "mv #{style.downcase}.self* #{style.downcase}.self.css"
      end
    end
  end

  cd "demo" do
    sh "for i in `find . -type f`; do mv $i `echo $i | cut -d? -f1`; done"
    sh "export LC_ALL=C; find . -type f -iregex '.*[css|html]' -print0 | xargs -0 sed -i '' 's/\%3Fbody=1//g'"
    sh "export LC_ALL=C; find . -type f -iregex '.*[css|html]' -print0 | xargs -0 sed -i '' 's/\.css\.css\"/\.css\"/g'"
    sh "export LC_ALL=C; find . -type f -iregex '.*[css|html]' -print0 | xargs -0 sed -i '' 's/\%3F.+$//g'"
    sh "export LC_ALL=C; find . -type f -iregex '.*[css|html]' -print0 | xargs -0 sed -i '' 's/\%3F-fvbane//g'"
    sh "export LC_ALL=C; find . -type f -iregex '.*[css|html]' -print0 | xargs -0 sed -i '' 's/\%3Fv=4.7.0.html//g'"
    sh "export LC_ALL=C; find . -type f -iregex '.*[css|html]' -print0 | xargs -0 sed -i '' 's/\?v=4.7.0//g'"
    sh "export LC_ALL=C; find . -type f -iregex '.*[css|html]' -print0 | xargs -0 sed -i '' 's/\?-fvbane//g'"
    sh "export LC_ALL=C; find . -type f -iregex '.*[css|html]' -print0 | xargs -0 sed -i '' 's/\%3Fv=4.7.0//g'"
    sh "export LC_ALL=C; find . -type f -iregex '.*[css|html]' -print0 | xargs -0 sed -i '' 's/\%3Fv=2.0.0//g'"
  end
end

task :make_demo do
  sh "rm -rf demo/"

  Rake::Task["compile_assets"].invoke

  cd "test/dummy" do
    setup_bundler
    start_server

    RRT::THEMES.each do |theme|
      styles = Kernel.const_get("RRT::#{theme.capitalize}::COLORS")
      styles.each do |style|
        puts "\nCOMPILING DEMO FOR #{theme.capitalize} - #{style.capitalize}"
        sh "wget --mirror --content-disposition -nv -p -q -nH --html-extension --page-requisites --no-use-server-timestamps --convert-links -P ../../demo/#{theme.downcase}/#{style} 'http://localhost:4000/preview/001_dashboards@ti-dashboard%2F001_dashboard_1?theme=#{theme.downcase}&style=#{style}'; true"
      end
    end

    stop_server
  end

  Rake::Task["clean_demo"].invoke
  Rake::Task["fix_stylesheets"].invoke
end

def server_running?
  File.file?('tmp/pids/server.pid')
end

def start_server(stop_at_exit=true)
  sh "bundle exec rails server thin -d -p 4000"
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
  rdoc.title    = 'RRT'
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

task :bake_generatable_views do
  Rake::Task["bake_app_pages"].invoke
  Rake::Task["bake_pages"].invoke
  Rake::Task["bake_content_blocks"].invoke
  Rake::Task["bake_layouts"].invoke
end

task :bake_app_pages do
  app_page_targets = [
    '007_app_pages@ti-layout/',
  ]

  app_page_target_path = 'test/dummy/app/views/preview/elements'
  app_page_destination_path = 'lib/generators/rrt/templates/views/app_pages'

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
  base_destination_path = 'lib/generators/rrt/templates/views'

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
      PageRewriter.compile(destination, /preview\/elements\/001_dashboards@ti-dashboard/, 'dashboards')
    end
  end
end

task :bake_layouts do
  layout_destination_path = File.join(Dir.pwd, 'lib/generators/rrt/templates/layouts')
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

task :cook_haml do
  target_erb_dirs = [
    'lib/generators/rrt/templates/layouts',
    'app/views/content_blocks/app_navs',
    'app/views/content_blocks/basic',
    'app/views/content_blocks/general',
    'app/views/content_blocks/headers',
    'app/views/content_blocks/landing_navs',
    'lib/generators/rrt/templates/views/analytics',
    'lib/generators/rrt/templates/views/app_pages/user_account',
    'lib/generators/rrt/templates/views/app_pages/user_account/_user_account',
    'lib/generators/rrt/templates/views/dashboards',
    'lib/generators/rrt/templates/views/emails',
    'lib/generators/rrt/templates/views/frontend_pages/blog_pages',
    'lib/generators/rrt/templates/views/frontend_pages/error_pages',
    'lib/generators/rrt/templates/views/frontend_pages/faq_pages',
    'lib/generators/rrt/templates/views/frontend_pages/landing_pages',
    'lib/generators/rrt/templates/views/frontend_pages/legal_pages',
    'lib/generators/rrt/templates/views/frontend_pages/pricing_pages',
  ]

  target_erb_dirs.each do |target_erb_dir|
    cd target_erb_dir do
      sh 'find . -name \'*erb\' | xargs ruby -e \'ARGV.each { |i| puts "html2haml -r #{i} #{i.sub(/erb$/, "haml")}"}\' | bash'
    end
  end
end

task :cook_slim do
  target_erb_dirs = [
    'lib/generators/rrt/templates/layouts',
    'app/views/content_blocks/app_navs',
    'app/views/content_blocks/basic',
    'app/views/content_blocks/general',
    'app/views/content_blocks/headers',
    'app/views/content_blocks/landing_navs',
    'lib/generators/rrt/templates/views/analytics',
    'lib/generators/rrt/templates/views/app_pages/user_account',
    'lib/generators/rrt/templates/views/app_pages/user_account/_user_account',
    'lib/generators/rrt/templates/views/dashboards',
    'lib/generators/rrt/templates/views/emails',
    'lib/generators/rrt/templates/views/frontend_pages/blog_pages',
    'lib/generators/rrt/templates/views/frontend_pages/error_pages',
    'lib/generators/rrt/templates/views/frontend_pages/faq_pages',
    'lib/generators/rrt/templates/views/frontend_pages/landing_pages',
    'lib/generators/rrt/templates/views/frontend_pages/legal_pages',
    'lib/generators/rrt/templates/views/frontend_pages/pricing_pages',
  ]

  target_erb_dirs.each do |target_erb_dir|
    cd target_erb_dir do
      sh 'find . -name \'*haml\' | xargs ruby -e \'ARGV.each { |i| puts "haml2slim #{i} #{i.sub(/haml$/, "slim")}"}\' | bash'
    end
  end
end
