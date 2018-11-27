FROM ruby:2.5.1

ENV LANG C.UTF-8
ENV WORKSPACE=/app

# install bundler.
RUN apt-get update -qq && \
    apt-get install -y vim less && \
    apt-get install -y build-essential libpq-dev && \
    gem install bundler

RUN apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  wget \
  nodejs \
  apt-transport-https \
  git \
  libpq-dev \
  libfontconfig1 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*


# create user and group.
RUN groupadd -r --gid 1000 rails && \
    useradd -m -r --uid 1000 --gid 1000 rails

# create directory.
RUN mkdir -p $WORKSPACE $BUNDLE_APP_CONFIG && \
    chown -R rails:rails $WORKSPACE && \
    chown -R rails:rails $BUNDLE_APP_CONFIG

USER rails
WORKDIR $WORKSPACE

# bundle install.
COPY --chown=rails:rails Gemfile $WORKSPACE/Gemfile
RUN bundle install && \
    bundle exec rails new . --force --database=mysql && \
    bundle update
#COPY --chown=rails:rails database.yml /app/config/database.yml

EXPOSE  3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
