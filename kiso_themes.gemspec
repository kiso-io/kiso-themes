$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'kiso_themes/version'

Gem::Specification.new do |s|
  s.name        = 'kiso_themes'
  s.version     = KisoThemes::VERSION
  s.authors     = ['John McDowall']
  s.email       = ['support@kiso.io']
  s.homepage    = 'https://kiso.io/ui/themes'
  s.summary     =
  s.description = 'KISO Themes'

  s.files = Dir['{app,config,db,lib,support}/**/*'] +
            Dir['*.gemspec'] +
            ['VERSION', 'CHANGELOG', 'LICENSE', 'Rakefile', 'README.rdoc']

  s.add_runtime_dependency 'jquery-rails'
  s.add_runtime_dependency 'rails', '>= 3.1'
  s.add_runtime_dependency 'sass-rails'

  s.add_development_dependency 'aws-sdk'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'version_bumper'

  s.post_install_message = <<-DOC
    All done!

    Any questions? Log into your account at https://kiso.io 
    and submit an issue via the support area.

    Need help? Check out the Documentation first:
    https://kiso.io/docs

  DOC
end
