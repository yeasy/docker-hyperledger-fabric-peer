# https://github.com/yeasy/docker-hyperledger-fabric-peer
#
# Dockerfile for Hyperledger peer image. This actually follow yeasy/hyperledger-fabric
# image and add default start cmd.
# Data is stored under /var/hyperledger/production

FROM yeasy/hyperledger-fabric-base:latest
LABEL maintainer "Baohua Yang <yeasy.github.io>"

# Peer
EXPOSE 7051

# ENV CORE_PEER_MSPCONFIGPATH $FABRIC_CFG_PATH/msp

# Install fabric peer
RUN CGO_CFLAGS=" " go install -tags "" -ldflags "$LD_FLAGS" github.com/hyperledger/fabric/cmd/peer \
        && go clean

# First need to manually create a chain with `peer channel create -c test_chain`, then join with `peer channel join -b test_chain.block`.
CMD ["peer","node","start"]
