# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.4
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl libjemalloc2 libvips postgresql-client imagemagick libmagic-dev libmagickwand-dev \
    parallel nginx && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV RAILS_ENV=${RAILS_ENV} \
    RAILS_MASTER_KEY=${RAILS_MASTER_KEY} \
    APP_HOST=${APP_HOST} \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT=${BUNDLE_WITHOUT}\
    DATABASE_URL=${DATABASE_URL} \
    FRONTEND_HOST=${FRONTEND_HOST} \
    POSTGRES_HOST=${POSTGRES_HOST} \
    POSTGRES_DB=${POSTGRES_DB} \
    POSTGRES_USER=${POSTGRES_USER} \
    POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
    POSTGRES_PORT=${POSTGRES_PORT}

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config parallel nginx && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p /etc/nginx /var/cache/nginx /var/log/nginx /var/lib/nginx /run && \
    chown -R rails:rails db log storage tmp /etc/nginx /var/cache/nginx /var/log/nginx /var/lib/nginx /run

COPY ./config/nginx/nginx.conf /etc/nginx/nginx.conf

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 8080
EXPOSE 3000
CMD ["sh", "-c", "parallel --ungroup --halt now,fail=1 ::: 'nginx -g \"daemon off;\"' 'bundle exec rails s -b 0.0.0.0 -p 3000'"]

