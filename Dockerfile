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
RUN cd $FABRIC_HOME/peer \
#&& CGO_CFLAGS=" " CGO_LDFLAGS="-lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy" go install -ldflags "-X github.com/hyperledger/fabric/common/metadata.Version=1.0.0-preview" \
    && CGO_CFLAGS=" " go install -ldflags "-X github.com/hyperledger/fabric/common/metadata.Version=1.0.0-snapshot-preview -linkmode external -extldflags '-static -lpthread'" \
    && go clean \
    && cp $FABRIC_HOME/peer/core.yaml $PEER_CFG_PATH \
    && mkdir -p $PEER_CFG_PATH/msp/sampleconfig \
    && cp -r $FABRIC_HOME/msp/sampleconfig/* $PEER_CFG_PATH/msp/sampleconfig \
    && mkdir -p $PEER_CFG_PATH/common/configtx/tool \
    && cp $FABRIC_HOME/common/configtx/tool/genesis.yaml $PEER_CFG_PATH/common/configtx/tool/

CMD ["peer","node","start"]
