FROM ubuntu:focal-20230412 as builder
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y golang make git libsystemd-dev
ENV GOPATH /root/go

WORKDIR $GOPATH/src/github.com/box/kube-iptables-tailer
COPY . $GOPATH/src/github.com/box/kube-iptables-tailer
RUN make build-cgo

FROM ubuntu:focal-20220404
LABEL maintainer="Saifuding Diliyaer <sdiliyaer@box.com>"
WORKDIR /root/
COPY --from=builder /root/go/src/github.com/box/kube-iptables-tailer/kube-iptables-tailer /kube-iptables-tailer
