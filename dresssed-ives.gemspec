$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dresssed/ives/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dresssed-ives"
  s.version     = Dresssed::Ives::VERSION
  s.authors     = ["Dresssed"]
  s.email       = ["dresssed@kantan.io"]
  s.homepage    = "http://dresssed.com/themes/ives"
  s.summary     =
  s.description = "Dresssed Ives theme"

  s.files = Dir["{app,config,db,lib,psd}/**/*"] +
            Dir["*.gemspec"] +
            ["CHANGELOG", "LICENSE", "Rakefile", "README.rdoc"]

  s.add_runtime_dependency 'rails', '>= 3.1'
  s.add_runtime_dependency 'jquery-rails'

  s.add_development_dependency "sqlite3"

  s.post_install_message = <<-DOC

    SIMPLE FORM USERS:
    You will need to use a specific version of simple_form with this Theme in order
    to get the proper support for Bootstrap 3. Make sure to use this in your Gemfile:

    gem 'simple_form', '~> 3.1.0.rc1', github: 'plataformatec/simple_form', branch: 'master', tag: 'v3.1.0.rc1'

    Any questions? Email dresssed@kantan.io

  DOC
end
