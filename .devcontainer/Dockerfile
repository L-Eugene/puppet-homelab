FROM mcr.microsoft.com/devcontainers/base:jammy

# Install Puppet
RUN wget https://apt.puppetlabs.com/puppet7-release-jammy.deb && \
  dpkg -i puppet7-release-jammy.deb && rm puppet7-release-jammy.deb && \
  apt-get update && apt-get install -y puppetserver ruby r10k

COPY --chown=vscode local-test/ /local-test/

RUN chown -R vscode:vscode /local-test
