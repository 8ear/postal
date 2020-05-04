FROM ruby:2.6

# Set Up static configuration
RUN set -eu \
  ;useradd -r -d /opt/postal -m -s /bin/bash -u 999 postal \
  ;mkdir -p /opt/postal/app /opt/postal/config \
  ;apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 \
  ;add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirrors.coreix.net/mariadb/repo/10.1/ubuntu xenial main' \
  ;curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  ;

# Setup an application
USER postal
WORKDIR /opt/postal/app

# Add dynamic packages
RUN set -eu \
# Setup additional repositories
  ;apt-get update \
# Install main dependencies
  ;apt-get install -y \
    software-properties-common \
    build-essential  \
    curl \
    libmariadbclient-dev \
    nano \
    nodejs
  ; rm -rf /var/lib/apt/lists/* \


# Install bundler
RUN set -eu \
  ;gem install bundler --no-doc \
  ;bundle config frozen 1 \
  ;bundle config build.sassc --disable-march-tune-native \
  
# Install the latest and active gem dependencies and re-run
# the appropriate commands to handle installs.
COPY Gemfile Gemfile.lock ./
RUN bundle install -j 4

# Copy the application (and set permissions)
COPY --chown=postal . .

# Copy temporary configuration file which can be used for
# running the asset precompilation.
COPY --chown=postal config/postal.defaults.yml /opt/postal/config/postal.yml

# Precompile assets
RUN set -eu \
  ;POSTAL_SKIP_CONFIG_CHECK=1 RAILS_GROUPS=assets bundle exec rake assets:precompile \
  ;touch /opt/postal/app/public/assets/.prebuilt \
  ;

# Set the CMD
CMD ["bundle", "exec"]
