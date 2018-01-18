#!/bin/bash

# Init
SCRIPT_PATH=$(pwd)
BASENAME_CMD="basename ${SCRIPT_PATH}"
SCRIPT_BASE_PATH=`eval ${BASENAME_CMD}`

if [ $SCRIPT_BASE_PATH = "test_run_scripts" ]; then
  cd ../../../
fi

# Work-around for RE-5005
export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem

export pe_dist_dir="http://enterprise.delivery.puppetlabs.net/2016.2/ci-ready"
export GEM_SOURCE=https://artifactory.delivery.puppetlabs.net/artifactory/api/gems/rubygems/

bundle install --without build development test --path .bundle/gems

bundle exec beaker \
  --preserve-host \
  --host spec/acceptance/nodesets/ubuntu-1604-64mda \
  --debug \
  --pre-suite tests/beaker/pre-suite \
  --tests tests/beaker/tests \
  --keyfile ~/.ssh/id_rsa-acceptance \
  --load-path  tests/beaker/lib
