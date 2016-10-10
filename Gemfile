source "https://rubygems.org"

ruby "2.3.1"

gem "rails", "~> 5.0.0", ">= 5.0.0.1"
gem "pg", "~> 0.18"
gem "puma", "~> 3.0"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

gem "jquery-rails"
gem "turbolinks", "~> 5"

# See https://github.com/icoretech/omniauth-spotify/issues/10#issuecomment-223718565
gem "omniauth-oauth2", "~> 1.3.1"
gem "omniauth-spotify"
gem "omniauth-github"
gem "octokit", "~> 4.0"
gem 'faraday-http-cache'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 3.0"

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug", platform: :mri
  gem "dotenv-rails"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console"
  gem "listen", "~> 3.0.5"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
