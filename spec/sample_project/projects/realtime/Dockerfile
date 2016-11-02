#############################################################################
# This image is made by Tanapat sainak and Suppachai chobjit for Sumrab.com #
#############################################################################

# Set the base image to Ruby version 2.3.1
FROM ruby:2.3.1-alpine

# File Author / Maintainer
MAINTAINER Tanapat Sainak <tanapat@sumrab.com>

RUN apk add --update --upgrade \
  build-base nodejs git\
  libxml2-dev zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev \
  && rm -rf /var/cache/apk/*

# Prepare work directory
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

# Bundle install rails's gem bundle
RUN bundle install

# Add application directory
ADD . /app
