#!/bin/bash

puppet apply --modulepath site:\$basemodulepath --hiera_config /local-test/hiera.yaml $@