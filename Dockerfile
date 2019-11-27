FROM golang:1.11.5 as builder
WORKDIR $GOPATH/src/github.com/box/kube-iptables-tailer
COPY . $GOPATH/src/github.com/box/kube-iptables-tailer
RUN apt-get update && apt-get install libsystemd-dev -y
RUN make build-cgo

FROM alpine:3.9.3
LABEL maintainer="Saifuding Diliyaer <sdiliyaer@box.com>"
WORKDIR /root/
COPY --from=builder /go/src/github.com/box/kube-iptables-tailer/kube-iptables-tailer /kube-iptables-tailer
