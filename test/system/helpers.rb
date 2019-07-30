## Creating the app & views

def create_app
  stop_server
  test_dir = '/tmp/kiso_themes-install-test'
  rm_rf test_dir
  mkdir_p test_dir
  cd test_dir
  sh 'rails new testapp --quiet --no-rc'
  cd 'testapp'
  sh 'rake db:drop db:create'
end

def install_theme
  add_gem 'kiso_themes', :path => File.expand_path("../../..", __FILE__)
  sh 'bundle install --quiet -j4'
  sh 'spring stop'
  sh 'bin/rails generate kiso_themes:install -f'
end

def generate_views
  sh 'rails generate scaffold contact name:string phone:string email:string'
  sh 'rake db:migrate'
  rm_rf 'public/index.html'
  sh 'rails generate kiso_themes:landing_pages home index --variant=1'
  sh 'rails generate kiso_themes:pricing_pages pricing index --variant=1'
  sh 'rails generate kiso_themes:dashboard_pages dashboard index'
  add_route "get '/pricing' => 'pricing#index'"
  add_route "get '/dashboard' => 'dashboard#index'"
  add_route "root :to => 'home#index'"
end


## Modifying the app

def add_gem(name, options=nil)
  puts "Adding GEM: #{name}"
  line = %Q{gem "#{name}"}
  if options
    line += %Q{, #{options.inject('') { |o, (k, v)| k.inspect + ' => ' + v.inspect }}}
  end
  sh "echo '#{line}' >> Gemfile"
end

def add_route(route)
  path = "config/routes.rb"
  content = File.read(path)
  content.sub!(/\nend$/m, "\n  #{route}\nend")
  puts "Adding `#{route}` to #{path}"
  File.write(path, content)
end


## Server

$PORT = 3111

def curl(path)
  puts "cURLing #{path}"
  path = "http://localhost:#{$PORT}#{path}"
  `curl -s -o /dev/null -I -w "%{http_code}" #{path}` == 200
end

def server_running?
  File.file?('tmp/pids/server.pid')
end

def start_server(stop_at_exit=true)
  sh "bin/rails s -d -p#{$PORT} "
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

def restart_server
  stop_server
  start_server(!:stop_at_exit)
end
