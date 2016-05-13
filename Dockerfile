# Dockerfile for Hyperledger peer image with consensus pbft. This follows hyperledger
# image and update the consensus config file.
# Data is stored under /var/hyperledger/db and /var/hyperledger/production

FROM yeasy/hyperledger:latest
MAINTAINER Baohua Yang

RUN cp $GOPATH/src/github.com/hyperledger/fabric/consensus/obcpbft/config.yaml $GOPATH/bin
