# Dockerfile for Hyperledger peer image. This actually follow yeasy/hyperledger-fabric
# image and add default start cmd.
# Data is stored under /var/hyperledger/db and /var/hyperledger/production

FROM yeasy/hyperledger-fabric-base:0.6-dp
MAINTAINER Baohua Yang <yeasy.github.com>

# install hyperledger peer and membersrvc
RUN mkdir -p $GOPATH/src/github.com/hyperledger \
        && cd $GOPATH/src/github.com/hyperledger \
        && git clone --single-branch -b v0.6 --depth 1 http://gerrit.hyperledger.org/r/fabric \
        && cd $GOPATH/src/github.com/hyperledger/fabric/peer \
        && CGO_CFLAGS=" " CGO_LDFLAGS="-lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy" go install \
        && cp $GOPATH/src/github.com/hyperledger/fabric/peer/core.yaml $GOPATH/bin \
        && go clean \
        && cd $GOPATH/src/github.com/hyperledger/fabric/membersrvc \
        && CGO_CFLAGS=" " CGO_LDFLAGS="-lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy" go install \
        && cp $GOPATH/src/github.com/hyperledger/fabric/membersrvc/membersrvc.yaml $GOPATH/bin \
        && go clean \
        && cp $GOPATH/src/github.com/hyperledger/fabric/devenv/limits.conf /etc/security/limits.conf

# this is to keep compatible
# RUN PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:$PATH

WORKDIR $GOPATH/src/github.com/hyperledger/fabric

CMD ["peer","node","start"]
