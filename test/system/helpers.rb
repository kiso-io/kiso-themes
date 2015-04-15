## Creating the app & views

def create_app
  stop_server
  test_dir = '/tmp/dresssed-ives-install-test'
  rm_rf test_dir
  mkdir_p test_dir
  cd test_dir
  sh 'rails new testapp'
  cd 'testapp'
  add_gem 'thin'
end

def install_theme
  add_gem 'dresssed-ives', :path => File.expand_path("../../..", __FILE__)
  sh 'bundle install'
  sh 'spring stop'
  sh 'bin/rails generate dresssed:install -f'
end

def generate_views
  sh 'rails generate scaffold contact name:string phone:string email:string'
  sh 'rake db:migrate'
  rm_rf 'public/index.html'
  sh 'rails generate dresssed:landing1 home index'
  sh 'rails generate dresssed:pricing home pricing'
  add_route "get '/pricing' => 'home#pricing'"
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
  sh "curl -f http://localhost:#{$PORT}#{path}"
end

def server_running?
  File.file?('tmp/pids/server.pid')
end

def start_server(stop_at_exit=true)
  sh "rails server thin -d -p#{$PORT}"
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