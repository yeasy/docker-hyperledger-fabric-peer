# Dockerfile for Hyperledger peer image. This actually follow yeasy/hyperledger-fabric
# image and add default start cmd.
# Data is stored under /var/hyperledger/db and /var/hyperledger/production

FROM yeasy/hyperledger-fabric-base:latest
MAINTAINER Baohua Yang <yeasy.github.com>

#EXPOSE 7050

ENV PEER_CFG_PATH /etc/hyperledger/fabric
ENV CORE_PEER_MSPCONFIGPATH $PEER_CFG_PATH/msp/sampleconfig

RUN mkdir -p $PEER_CFG_PATH

# install fabric peer and configs
RUN cd $GOPATH/src/github.com/hyperledger/fabric/peer \
#&& CGO_CFLAGS=" " CGO_LDFLAGS="-lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy" go install -ldflags "-X github.com/hyperledger/fabric/common/metadata.Version=1.0.0-preview" \
    && CGO_CFLAGS=" " go install -ldflags "-X github.com/hyperledger/fabric/common/metadata.Version=1.0.0-snapshot-preview -linkmode external -extldflags '-static -lpthread'" \
    && go clean \
    && cp $GOPATH/src/github.com/hyperledger/fabric/peer/core.yaml $PEER_CFG_PATH \
    && mkdir -p $PEER_CFG_PATH/msp/sampleconfig \
    && cp -r $GOPATH/src/github.com/hyperledger/fabric/msp/sampleconfig/* $PEER_CFG_PATH/msp/sampleconfig \
    && mkdir -p $PEER_CFG_PATH/common/configtx/test \
    && cp $GOPATH/src/github.com/hyperledger/fabric/common/configtx/test/orderer.template $PEER_CFG_PATH/common/configtx/test

CMD ["peer","node","start"]
