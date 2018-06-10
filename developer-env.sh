#!/usr/bin/env bash
docker build -t developer-env . && docker run --privileged -it --rm \
  --mount type=bind,source="$(pwd)",target=/work \
  --volume "$HOME/.ssh:/root/.ssh" \
  --volume "$PWD/puppet/facts:/opt/puppetlabs/facter/facts.d" \
  developer-env