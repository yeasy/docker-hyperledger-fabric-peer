# Dockerfile for Hyperledger peer image. This actually follow yeasy/hyperledger-fabric
# image and add default start cmd.
# Data is stored under /var/hyperledger/db and /var/hyperledger/production

FROM yeasy/hyperledger-fabric-base:0.6-dp
MAINTAINER Baohua Yang <yeasy.github.com>

# install hyperledger peer and membersrvc
RUN cd $GOPATH/src/github.com/hyperledger/fabric/peer \
         && CGO_CFLAGS=" " CGO_LDFLAGS="-lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy" go install \
         && cp $GOPATH/src/github.com/hyperledger/fabric/peer/core.yaml $GOPATH/bin \
         && go clean

CMD ["peer","node","start"]
