FROM ruby:3.1.0-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    postgresql-client \
    git \
    nodejs \
    sqlite3 \
    libsqlite3-dev \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /usr/src/app

RUN gem install rails