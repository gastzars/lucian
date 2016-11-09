FROM ruby:2.3.1

RUN apt-get update

# Prepare work directory
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile

# Bundle install rails's gem bundle
RUN bundle install

# Add application directory
ADD . /app

ENV LUCIAN_DOCKER=true

CMD tail -f /dev/null
