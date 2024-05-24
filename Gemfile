# frozen_string_literal: true

source "https://rubygems.org"

gem "bootsnap", require: false
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "rails", "~> 7.1.3", ">= 7.1.3.2"
gem "tzinfo-data", platforms: %i[mswin mswin64 mingw x64_mingw jruby]

group :development do
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
  gem "relaxed-rubocop"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :development, :test do
  gem "debug", platforms: %i[mri mswin mswin64 mingw x64_mingw]
end

group :test do
  gem "rspec_junit_formatter"
  gem "rspec-rails"
end
