# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.4.4

# --- Build stage ---
FROM ruby:${RUBY_VERSION}-slim-bookworm AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      cargo \
      git \
      libpq-dev \
      libyaml-dev \
      node-gyp \
      pkg-config \
      python-is-python3 \
      rustc && \
    rm -rf /var/lib/apt/lists/*

# Install Node for asset compilation
ARG NODE_VERSION=22
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /rails

# Install gems
COPY Gemfile Gemfile.lock .ruby-version ./
RUN gem install -N bundler:2.7.2 && \
    bundle config set --local deployment true && \
    bundle config set --local without "development test" && \
    bundle install --jobs 4 && \
    rm -rf ~/.bundle/cache vendor/bundle/ruby/*/cache

# Precompile assets
COPY . .
RUN RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 \
    AWS_BUCKET=dummy AWS_ACCESS_KEY_ID=dummy AWS_SECRET_ACCESS_KEY=dummy \
    bundle exec rake assets:precompile

# --- Runtime stage ---
FROM ruby:${RUBY_VERSION}-slim-bookworm

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libatomic1 \
      libjemalloc2 \
      libpq5 \
      libyaml-0-2 && \
    rm -rf /var/lib/apt/lists/*

# Use jemalloc for better memory allocation
RUN JEMALLOC=$(find /usr/lib -name 'libjemalloc.so.2' -print -quit) && \
    ln -sf "$JEMALLOC" /usr/lib/libjemalloc.so.2
ENV LD_PRELOAD=/usr/lib/libjemalloc.so.2
ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=1 \
    RAILS_SERVE_STATIC_FILES=1 \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_WITHOUT="development:test"

RUN groupadd --system rails && \
    useradd rails --system --gid rails --home /rails

WORKDIR /rails

# Copy built artifacts from build stage
COPY --from=build --chown=rails:rails /usr/local/bundle /usr/local/bundle
COPY --from=build --chown=rails:rails /rails /rails

USER rails

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
