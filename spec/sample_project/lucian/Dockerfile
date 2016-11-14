FROM ruby:2.3.1

RUN apt-get update

# Prepare work directory
RUN mkdir /app
RUN mkdir /app/lucian
WORKDIR /app
ADD Gemfile /app/Gemfile

# Bundle install rails's gem bundle
RUN bundle install
RUN touch docker-compose.yml

# Add application directory
ADD . /app/lucian

ENV LUCIAN_DOCKER=true

CMD tail -f /dev/null
