# frozen_string_literal: true

source "https://rubygems.org"

gem "bcrypt"
gem "bootsnap", require: false
gem "doorkeeper"
gem "dry-monads"
gem "dry-validation"
gem "pagy_cursor"
gem "pg"
gem "pry"
gem "pry-byebug"
gem "pry-rails"
gem "puma"
gem "rails"

group :development do
  gem "active_record_query_trace"
  gem "annotate"
  gem "rails-erd"
  gem "relaxed-rubocop"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :development, :test do
  gem "factory_bot"
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec_api_documentation"
  gem "rswag-specs"
end

group :test do
  gem "database_cleaner"
  gem "database_cleaner-active_record"
  gem "rspec_junit_formatter"
  gem "rspec-rails"
  gem "simplecov", require: false
  gem "simplecov-cobertura", require: false
end
