# Dockerfile for Hyperledger peer image. This actually follow hyperledger
# image and add default start cmd
# Data is stored under /var/hyperledger/db and /var/hyperledger/production

FROM yeasy/hyperledger:0.6-dp
MAINTAINER Baohua Yang

CMD ["peer","node","start"]
