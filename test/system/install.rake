require_relative "helpers"

## Test cases
## ----------

task :erb do
  create_app
  install_theme
  generate_views
  start_server

  curl "/"
  curl "/pricing"
  curl "/contacts"
  curl "/contacts/new"
  curl "/dashboard"
  curl "/assets/kiso_themes.css"
  curl "/assets/kiso_themes.js"
end

task :customize => :erb do
  sh 'bin/rails generate kiso_themes:customize -f --theme-name=orion --style-name=blue'
  rm 'app/assets/stylesheets/kiso_themes.css'
  sh 'bundle install'
  restart_server

  curl "/assets/kiso_themes.css"
end

task :haml do
  create_app
  add_gem 'haml-rails'
  install_theme
  generate_views

  abort "Not using HAML views when haml-rails is installed" unless File.file?("app/views/layouts/_base.html.haml") && File.file?("app/views/contacts/new.html.haml")

  start_server

  curl "/"
  curl "/pricing"
  curl "/contacts"
  curl "/contacts/new"
end

task :default => [:erb, :customize, :haml]
