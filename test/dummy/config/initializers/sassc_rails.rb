# config/initializers/sassc_rails.rb

Rails.application.config.assets.configure do |env|
  env.register_mime_type 'text/css', extensions: ['.scss'], charset: :css
  env.register_mime_type 'text/css', extensions: ['.css.scss'], charset: :css
  env.register_preprocessor 'text/css', SassC::Rails::ScssTemplate
end
