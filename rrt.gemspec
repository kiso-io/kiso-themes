$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rrt/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rrt"
  s.version     = RRT::VERSION
  s.authors     = ["RRT"]
  s.email       = ["john@rapidrailsthemes.com"]
  s.homepage    = "https://rapidrailsthemes.com/"
  s.summary     =
  s.description = "RRT Themes"

  s.files = Dir["{app,config,db,lib,support}/**/*"] +
            Dir["*.gemspec"] +
            ["CHANGELOG", "LICENSE", "Rakefile", "README.rdoc"]

  s.add_runtime_dependency 'rails', '>= 3.1'
  s.add_runtime_dependency 'jquery-rails'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "version_bumper"
  s.add_development_dependency "aws-sdk"
  s.add_development_dependency "byebug"

  s.post_install_message = <<-DOC
    All done!

    Any questions? Email john@rapidrailsthemes.com

    Need help? Check out the FAQ first: https://rapidrailsthemes.com/faq

    Still need help? Go to your order receipt page and send me the information
    requested on the right hand side and send to john@rapidrailsthemes.com.

  DOC
end
