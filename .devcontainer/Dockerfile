FROM mcr.microsoft.com/devcontainers/base:jammy

# Install Puppet
RUN apt-get update && apt-get install -y puppet

# Install and setup Puppet local testing script
# https://code.stanford.edu/puppetpublic/puppet-local-testing
RUN wget https://code.stanford.edu/puppetpublic/puppet-local-testing/raw/master/setup-puppet-local.sh && \
    chmod a+x setup-puppet-local.sh && \
    ./setup-puppet-local.sh local-test
