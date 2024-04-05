#!/bin/bash

puppet apply --modulepath site:modules:\$basemodulepath --hiera_config /local-test/hiera.yaml $@