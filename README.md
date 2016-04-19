Docker-Hyperledger-Peer
===
Docker images for [Hyperledger](https://www.hyperledger.org) fabric peer.

# Supported tags and respective Dockerfile links

* [`0.1, latest` (latest/Dockerfile)](https://github.com/yeasy/docker-hyperledger-peer/blob/master/Dockerfile)

For more information about this image and its history, please see the relevant manifest file in the [`yeasy/docker-hyperledger-peer` GitHub repo](https://github.com/yeasy/docker-hyperledger-peer).

If you want to quickly deploy a local cluster without any configuration and vagrant, please refer to [hyperledger-compose-files](https://github.com/yeasy/docker-compose-files/hyperledger).

# What is docker-hyperledger-peer?
Docker image with hyperledger fabric peer deployed. 

# How to use this image?
The docker image is auto built at [https://registry.hub.docker.com/u/yeasy/hyperledger-peer/](https://registry.hub.docker.com/u/yeasy/hyperledger-peer/).

## In Dockerfile
```sh
FROM yeasy/hyperledger-peer:latest
```

## Local Run
The fabric command is already there, add your sub command and flags at the end.

E.g., see the supported sub commands with the `help` command.
```sh
$ docker run --rm -it yeasy/hyperledger-peer fabric help
06:08:01.446 [crypto] main -> INFO 001 Log level recognized 'info', set to INFO


Usage:
  peer [command]

Available Commands:
  peer        Runs the peer.
  status      Returns status of the peer.
  stop        Stops the running peer.
  login       Logs in a user on CLI.
  network     Lists all network peers.
  chaincode   chaincode specific commands.
  help        Help about any command

Flags:
      --logging-level="": Default logging level and overrides, see core.yaml for full syntax


Use "fabric [command] --help" for more information about a command.
```

Hyperledger relies on a `core.yaml` file, you can mount your local one by
```sh
$ docker run -v your_local_core.yaml:/go/src/github.com/hyperledger/fabric/core.yaml -d yeasy/hyperledger-peer fabric help
```

The storage will be under `/var/hyperledger/`, which should be mounted from host for persistent requirement.

Your can also mapping the port outside using the `-p` options. 

* 5000: REST service listening port (Recommened to open at non-validating node)
* 30303: Peer service listening port
* 30304: CLI process use it for callbacks from chain code
* 31315: Event service on validating node

## Local Run with chaincode testing

Start your docker daemon with 
```sh
$ sudo docker daemon -D --api-cors-header="*" -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock
```

Pull necessary images, notice the default config require a local built `openblockchain/baseimage`. We can just use the `yeasy/hyperledger` image instead.
```sh
$ docker pull yeasy/hyperledger
$ docker pull yeasy/hyperledger-peer
$ docker tag yeasy/hyperledger openblockchain/baseimage
```

Check the `docker0` bridge ip, normally it should be `172.17.0.1`. This ip will be used as the `CORE_VM_ENDPOINT=http://172.17.0.1:4243`.
```sh
$  ip addr show dev docker0
4: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:f2:90:57:cf brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 scope global docker0
    valid_lft forever preferred_lft forever
    inet6 fe80::42:f2ff:fe90:57cf/64 scope link
    valid_lft forever preferred_lft forever
```

Start a validating node.

```sh
$ docker run --name=vp0 \
                    --restart=unless-stopped \
                    -it \
                    -p 5000:5000 \
                    -p 30303:30303 \
                    -e CORE_PEER_ID=vp0 \
                    -e CORE_VM_ENDPOINT=http://172.17.0.1:4243 \
                    -e CORE_PEER_ADDRESSAUTODETECT=true \
                    yeasy/hyperledger-peer fabric peer
```

Notice the port mapping is useful when you want to access the validating node api from outside. Here you can also ignore that.

Then, enter into the container
```sh
$ docker exec -it vp0 bash
```
    
Inside the container, deploy a chaincode using

```sh
$ fabric chaincode deploy -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02 -c '{"Function":"init", "Args": ["a","100", "b", "200"]}'
13:16:35.643 [crypto] main -> INFO 001 Log level recognized 'info', set to INFO
5844bc142dcc9e788785e026e22c855957b2c754c912702c58d997dedbc9a042f05d152f6db0fbd7810d95c1b880c210566c9de3093aae0ab76ad2d90e9cfaa5
```

Query `a`'s current value, which is 100.
```sh
$ fabric chaincode query -n 5844bc142dcc9e788785e026e22c855957b2c754c912702c58d997dedbc9a042f05d152f6db0fbd7810d95c1b880c210566c9de3093aae0ab76ad2d90e9cfaa5 -c '{"Function": "query", "Args": ["a"]}'
13:20:07.952 [crypto] main -> INFO 001 Log level recognized 'info', set to INFO
100
```

Invoke a transaction of 10 from `a` to `b`.
```sh
$ fabric chaincode invoke -n 5844bc142dcc9e788785e026e22c855957b2c754c912702c58d997dedbc9a042f05d152f6db0fbd7810d95c1b880c210566c9de3093aae0ab76ad2d90e9cfaa5 -c '{"Function": "invoke", "Args": ["a", "b", "10"]}'
13:20:31.028 [crypto] main -> INFO 001 Log level recognized 'info', set to INFO
ec3c675b-a2fe-4429-ab44-7f389e454657
```
Query `a` 's value now.
```sh
$ fabric chaincode query -n 5844bc142dcc9e788785e026e22c855957b2c754c912702c58d997dedbc9a042f05d152f6db0fbd7810d95c1b880c210566c9de3093aae0ab76ad2d90e9cfaa5 -c '{"Function": "query", "Args": ["a"]}'
13:20:35.725 [crypto] main -> INFO 001 Log level recognized 'info', set to INFO
90
```

More examples, please refer to [hyperledger-compose-files](https://github.com/yeasy/docker-compose-files/hyperledger).

# Which image is based on?
The image is built based on [hyperledger](https://hub.docker.com/r/yeasy/hyperledger) base image.

# What has been changed?
## install dependencies
Install required  libsnappy-dev, zlib1g-dev, libbz2-dev.

## install rocksdb
Install required  rocksdb 4.1.

## install hyperledger
Install hyperledger and build the fabric as peer 

# Supported Docker versions

This image is officially supported on Docker version 1.7.0.

Support for older versions (down to 1.0) is provided on a best-effort basis.

# Known Issues
* N/A.

# User Feedback
## Documentation
Be sure to familiarize yourself with the [repository's `README.md`](https://github.com/yeasy/docker-hyperledger-peer/blob/master/README.md) file before attempting a pull request.

## Issues
If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/yeasy/docker-hyperledger-peer/issues).

You can also reach many of the official image maintainers via the email.

## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/yeasy/docker-hyperledger-peer/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.
