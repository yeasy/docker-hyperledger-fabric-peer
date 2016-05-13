# Dockerfile for Hyperledger peer image with consensus noops. This follows hyperledger
# image and copy related consensus config file.
# Data is stored under /var/hyperledger/db and /var/hyperledger/production

FROM yeasy/hyperledger:latest
MAINTAINER Baohua Yang

RUN cp $GOPATH/src/github.com/hyperledger/fabric/consensus/noops/config.yaml $GOPATH/bin

CMD ["peer","node","start"]
