FROM public.ecr.aws/docker/library/ruby:3.3.5

# Set timezone
ENV TZ=Asia/Tokyo

# Set rubygems version
ARG RUBYGEMS_VERSION=3.5.23

# Install dependencies
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
RUN set -uex && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      gnupg \
      libpq-dev \
      postgresql-client \
      vim && \
    # Install Node.js
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
      | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    NODE_MAJOR=18 && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" \
      > /etc/apt/sources.list.d/nodesource.list && \
    # Install Yarn
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends nodejs yarn && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /webapp

# Install Ruby dependencies
COPY Gemfile ./
RUN gem update --system ${RUBYGEMS_VERSION}

# Copy Gemfile.lock if it exists, otherwise bundle install will create it
COPY Gemfile.lock* ./
RUN bundle install

# Copy application code
COPY . .

# Install Node dependencies if package.json exists
RUN if [ -f package.json ]; then yarn install; fi

# Add entrypoint script
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Expose port
EXPOSE 3000

# Start the server
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
