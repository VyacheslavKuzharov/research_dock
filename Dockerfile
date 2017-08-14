FROM ruby:2.3.3

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    build-essential libpq-dev libxml2-dev libxslt1-dev libqt4-webkit libqt4-dev xvfb nodejs \
    && rm -rf /var/lib/apt/lists

ENV APP_HOME /usr/src/research_dock

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME