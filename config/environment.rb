# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.10' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  #Add all sub directories in models to load paths
  Dir.entries("#{Rails.root}/app/models").each do |file|
    next if file.eql?('.') || file.eql?('..')
    full_path = "#{Rails.root}/app/models/#{file}"
    config.load_paths << full_path if File.directory?(full_path)
  end

  config.gem "binarylogic-authlogic", :lib => 'authlogic', :source => "http://gems.github.com"
  config.gem "haml"
  config.gem "mysql"
  config.gem "builder"
  config.gem "mislav-will_paginate", :lib => 'will_paginate', :source => "http://gems.github.com"
  config.gem "mongo_mapper", :version => '0.8.6'
  config.gem "mongo"#, :version => '1.0.9'
  # disabled uploading, not working with mongo_mapper currently
  # config.gem "carrierwave", '0.4.10'
  # config.gem 'aws', '2.3.20'
  config.gem "paypal_adaptive"
  config.gem 'gravatar_image_tag'
  config.gem 'hoptoad_notifier'
  config.gem "recaptcha"
  config.gem 'bitly'  
  
  #config.gem "nokogiri" #will need libxml2-dev and libxslt-dev on ubuntu

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  config.frameworks -= [ :active_resource ]

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  config.action_mailer.default_url_options = { :host => 'nextsprocket.com' }
end
