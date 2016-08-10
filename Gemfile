source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails', '~> 4.2.7'
gem 'pg', '~> 0.18.1'
gem 'foundation-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'underscore-rails'
gem 'uglifier', '>= 1.3.0'
gem 'sass-rails', '~> 4.0.3'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'httparty'
gem 'paper_trail', '~> 4.0.0'
gem 'paranoia', '~> 2.0'
gem 'ransack', git: 'https://github.com/activerecord-hackery/ransack.git'
gem 'kaminari', '~> 0.15.1'
gem 'devise'
gem 'devise_security_extension', git: 'https://github.com/phatworx/devise_security_extension.git'
gem 'nested_form', '~> 0.3.2'
gem 'slim-rails'
gem 'simple_form'
gem 'virtus'
gem 'hashdiff'
gem 'enumerize'
gem 'validates_timeliness'
gem 'pundit'
gem 'font-awesome-rails' # See icons here: https://fortawesome.github.io/Font-Awesome/icons/
gem 'jbuilder'
gem 'active_type'
gem 'dumb_delegator'
gem 'ruby-hl7', '~> 1.1.0'
gem 'delayed_job_active_record'
gem 'wisper', '2.0.0.rc1'
gem 'cocoon'
gem 'email_validator'
gem 'nokogiri', '~> 1.6.8'
gem 'activemodel-associations'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

source 'https://rails-assets.org' do
  # https://github.com/najlepsiwebdesigner/foundation-datepicker
  gem 'rails-assets-foundation-datepicker'
  gem 'rails-assets-clockpicker'
  gem 'rails-assets-select2'
end

group :development do
  gem 'guard-rspec', require: false
  gem 'guard-cucumber', require: false
end

group :development, :test do
  gem 'bundler-audit', require: false
  gem 'capybara'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker'
  gem 'foreman'
  gem 'launchy'
  gem 'poltergeist'
  gem 'pry-byebug'
  gem 'quiet_assets'
  gem 'rspec-rails', '~> 3.5.1'
  gem 'rspec-html-matchers'
  gem 'shoulda-matchers'
  gem 'spring'
  gem 'spring-commands-cucumber'
  gem 'spring-commands-rspec'
  gem 'rubocop', require: false
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'simplecov', require: false
  gem 'webmock'
end

group :staging do
  gem 'rails_12factor'
  gem 'unicorn'
  gem 'faker'
  gem "wkhtmltopdf-heroku"
end
