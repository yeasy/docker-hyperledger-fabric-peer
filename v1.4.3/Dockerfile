# Dockerfile for Hyperledger peer image. This actually follow yeasy/hyperledger-fabric
# image and add default start cmd.
# Data is stored under /var/hyperledger/db and /var/hyperledger/production

FROM yeasy/hyperledger-fabric-base:1.4.3
LABEL maintainer "Baohua Yang <yeasy.github.io>"

EXPOSE 7051

# ENV CORE_PEER_MSPCONFIGPATH $FABRIC_CFG_PATH/msp

# install fabric peer and copy sampleconfigs
RUN cd $FABRIC_ROOT/peer \
    && CGO_CFLAGS=" " go install -tags "" -ldflags "$LD_FLAGS" \
    && go clean

# This will start with joining the default chain "testchainid"
# Use `peer node start --peer-defaultchain=false` will join no channel by default. 
# Then need to manually create a chain with `peer channel create -c test_chain`, then join with `peer channel join -b test_chain.block`.
CMD ["peer","node","start"]
