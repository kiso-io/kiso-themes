require_relative "helpers"

TEMPLATE_ENGINES = %w( erb haml )

def setup_app(template_engine)
  create_app
  add_gem 'haml-rails' if template_engine == 'haml'
  yield if block_given?
  install_theme
  generate_views
  start_server
end

def assert_file_includes(file, pattern)
  abort "#{file} does not include #{pattern}" unless File.read(file) =~ pattern
end

TEMPLATE_ENGINES.each do |template_engine|
  namespace template_engine do
    desc "Test SimpleForm integration"
    task :simple_form do
      setup_app template_engine do
        add_gem 'simple_form'
        sh "rails generate simple_form:install --bootstrap"
      end

      assert_file_includes "app/views/contacts/_form.html.#{template_engine}", /simple_form_for/

      curl "/contacts/new"
    end

    desc "Test WillPaginate integration"
    task :will_paginate do
      setup_app template_engine do
        add_gem 'will_paginate'
      end

      assert_file_includes "app/views/contacts/index.html.#{template_engine}", /will_paginate @contacts/

      curl "/contacts"
    end

    desc "Test Kaminari integration"
    task :kaminari do
      setup_app template_engine do
        add_gem 'kaminari'
      end

      unless File.read("app/views/contacts/index.html.#{template_engine}") =~ /paginate @contacts/
        abort "Not using WillPaginate in index scaffold with #{template_engine}"
      end

      curl "/contacts"
    end

    desc "Test Devise integration"
    task :devise do
      setup_app template_engine do
        add_gem 'devise'
        sh 'rails generate devise:install -f'
        sh 'rails generate devise user -f'
        sh 'rake db:migrate'
        sh 'rake db:migrate RAILS_ENV=test'
      end

      curl "/users/sign_in"
      curl "/users/sign_up"
      curl "/users/password/new"
    end
  end
  task template_engine => [:simple_form, :will_paginate, :kaminari, :devise].map { |t| "#{template_engine}:#{t}" }
end

task :default => TEMPLATE_ENGINES
