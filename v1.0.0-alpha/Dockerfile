# Dockerfile for Hyperledger peer image. This actually follow yeasy/hyperledger-fabric
# image and add default start cmd.
# Data is stored under /var/hyperledger/db and /var/hyperledger/production

FROM yeasy/hyperledger-fabric-base:v1.0.0-alpha
MAINTAINER Baohua Yang <yeasy.github.com>

#EXPOSE 7050

ENV PEER_CFG_PATH /etc/hyperledger/fabric
ENV CORE_PEER_MSPCONFIGPATH $PEER_CFG_PATH/msp/sampleconfig

# ignore handshake, since not using mutual TLS
ENV CORE_PEER_GOSSIP_SKIPHANDSHAKE true

RUN mkdir -p $PEER_CFG_PATH

# install fabric peer and configs
RUN cd $FABRIC_HOME/peer \
    && CGO_CFLAGS=" " go install -ldflags "-X github.com/hyperledger/fabric/common/metadata.Version=${PROJECT_VERSION} -X github.com/hyperledger/fabric/common/metadata.BaseVersion=${BASE_VERSION} -X github.com/hyperledger/fabric/common/metadata.BaseDockerLabel=org.hyperledger.fabric" \
    && go clean \
    && cp $FABRIC_HOME/peer/core.yaml $PEER_CFG_PATH \
    && mkdir -p $PEER_CFG_PATH/msp/sampleconfig \
    && cp -r $FABRIC_HOME/msp/sampleconfig/* $PEER_CFG_PATH/msp/sampleconfig \
    && mkdir -p $PEER_CFG_PATH/common/configtx/tool \
    && cp $FABRIC_HOME/common/configtx/tool/configtx.yaml $PEER_CFG_PATH/

# This will start with joining the default chain "testchainid"
# Use `peer node start --peer-defaultchain=false` will join no channel by default. 
# Then need to manually create a chain with `peer channel create -c test_chain`, then join with `peer channel join -b test_chain.block`.
CMD ["peer","node","start"]
