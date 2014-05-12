source 'https://rubygems.org'
source 'https://BnrJb6FZyzspBboNJzYZ@gem.fury.io/govuk/'

gem 'rails', '3.2.18'

gem 'exception_notification', '2.6.1'
gem 'aws-ses', :require => 'aws/ses'
gem 'unicorn'

gem 'mongoid', '2.6'
gem 'bson_ext', '1.7.1'
gem 'mongoid_rails_migrations', '1.0.1'


gem 'plek', '1.2.0'
gem 'gds-sso', '9.2.0'

gem 'formtastic', git: 'https://github.com/justinfrench/formtastic.git', branch: '2.1-stable'
gem 'formtastic-bootstrap', git: 'https://github.com/cgunther/formtastic-bootstrap.git', branch: 'bootstrap-2'

if ENV['CONTENT_MODELS_DEV']
  gem 'govuk_content_models', :path => '../govuk_content_models'
else
  gem "govuk_content_models", "6.1.0"
end

if ENV['API_DEV']
  gem 'gds-api-adapters', :path => '../gds-api-adapters'
else
  gem 'gds-api-adapters', '5.3.0'
end

gem 'therubyracer', '0.12.0'
gem 'jquery-rails', '2.0.2' # TODO: Newer versions break publisher sortable parts. Will need attention.
gem 'less-rails-bootstrap'

gem 'logstasher', '0.4.8'

# Gems used only for assets and not required in production
# environments by default.
group :assets do
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'rspec-rails', '2.12.0'
  gem 'capybara', '1.1'
  gem 'simplecov-rcov', '0.2.3'
  gem 'factory_girl', '3.3.0'
  gem 'factory_girl_rails'
  gem 'ci_reporter'
  gem 'database_cleaner', '0.9.1'
  gem 'poltergeist', '0.7.0'
  gem 'webmock', '1.9.0', :require => false
  gem 'timecop', '0.5.9.2'
end
