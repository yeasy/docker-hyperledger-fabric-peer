# Dockerfile for Hyperledger peer image, with everything to go!
# Data is stored under /var/hyperledger/db and /var/hyperledger/production
# Under $GOPATH/bin, there are two config files: core.yaml and config.yaml.

FROM yeasy/hyperledger:latest
MAINTAINER Baohua Yang

WORKDIR "$GOPATH/src/github.com/hyperledger/fabric"
