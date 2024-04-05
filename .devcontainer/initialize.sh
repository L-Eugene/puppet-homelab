#!/bin/bash

for file in manifests site Puppetfile
do
    ln -s "/workspaces/puppet-homelab/${file}" "/local-test/${file}"
done

ln -s "/workspaces/puppet-homelab/test-data/common.yaml" "/local-test/hieradata/external.yaml"

cd /local-test/
r10k puppetfile install