#!/bin/bash

for file in manifests site Puppetfile
do
    ln -s "/workspaces/puppet-homelab/${file}" "/local-test/${file}"
done