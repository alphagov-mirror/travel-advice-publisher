FROM ruby:2.7.2
RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y build-essential nodejs && apt-get clean
RUN gem install foreman

# This image is only intended to be able to run this app in a production RAILS_ENV
ENV RAILS_ENV production

ENV GOVUK_APP_NAME travel-advice-publisher
ENV MONGODB_URI mongodb://mongo/travel-advice-publisher
ENV PORT 3035

ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
RUN bundle config set deployment 'true'
RUN bundle config set without 'development test'
RUN bundle install --jobs 4
ADD . $APP_HOME

RUN GOVUK_APP_DOMAIN=www.gov.uk \
  GOVUK_WEBSITE_ROOT=www.gov.uk \
  bundle exec rails assets:precompile

HEALTHCHECK CMD curl --silent --fail localhost:$PORT || exit 1

CMD foreman run web
