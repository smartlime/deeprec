source 'https://rubygems.org'

gem 'rails', '5.2.4.2'
gem 'pg', '~> 0.15'
gem 'sprockets', '3.6.3'
gem 'sass-rails', '~> 5.0', '>= 5.0.6'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2.2'
gem 'jquery-rails', '>= 4.2.1'
gem 'slim-rails', '>= 3.1.1'
gem 'turbolinks'
gem 'jbuilder', '~> 2.6', '>= 2.6.0'
gem 'sdoc', '~> 1.0.0', group: :doc

gem 'bootstrap-sass', '~> 3.3.6'
gem 'autoprefixer-rails'
gem 'devise', '>= 4.4.2'
gem 'faker'
gem 'carrierwave', '>= 0.11.2'
gem 'remotipart'
gem 'cocoon'
gem 'private_pub'
gem 'skim'
gem 'gon', '>= 6.1.0'
gem 'responders', '>= 2.4.0'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter', '>= 1.3.0'
gem 'pundit', '>= 1.1.0'
gem 'doorkeeper', '>= 4.2.0'
gem 'active_model_serializers', '>= 0.10.2'
gem 'oj'
gem 'oj_mimic_json'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'whenever'
gem 'dotenv'
gem 'dotenv-deployment', require: 'dotenv/deployment'

gem 'mysql2' # Don't worry, it's for Sphinx only!
gem 'thinking-sphinx', '>= 3.2.0'

# gem 'unicorn'
gem 'thin'

group :development, :test do
  gem 'byebug', '~>8.0'
  gem 'rspec-rails', '~> 3.5', '>= 3.5.2'
  gem 'factory_girl_rails', '~> 4.7', '>= 4.7.0'
  gem 'spring-commands-rspec'
  gem 'guard-rspec'

  install_if -> { RUBY_PLATFORM =~ /darwin/ } do
    gem 'rb-fsevent'
  end

  gem 'awesome_print'
  gem 'colorize'
end

group :test do
  gem 'shoulda-matchers', '~> 3.1', '>= 3.1.1'
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'capybara-webkit', '>= 1.11.1'
  gem 'capybara-email'
  gem 'json_spec'
  gem 'test_after_commit', '>= 1.1.0'
end

group :development do
  gem 'web-console', '~> 2.3', '>= 2.3.0'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'better_errors'
  gem 'meta_request', '>= 0.5.0'

  gem 'quiet_assets', '>= 1.1.0'

  gem 'rubocop', require: false
  gem 'rails_best_practices', '>= 1.17.0'

  gem 'spring'

  gem 'letter_opener'

  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :production do
  gem 'rack-handlers'
  gem 'unicorn'
end
