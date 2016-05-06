# Dockerfile for Hyperledger peer image. This actually follow hyperledger
# image but to make sure the config is done.
# Data is stored under /var/hyperledger/db and /var/hyperledger/production

FROM yeasy/hyperledger:latest
MAINTAINER Baohua Yang

RUN cp $GOPATH/src/github.com/hyperledger/fabric/consensus/obcpbft/config.yaml $GOPATH/bin
