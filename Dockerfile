FROM ubuntu:noble-20240605 AS builder
ENV DEBIAN_FRONTEND=noninteractive
ARG TARGETPLATFORM
ARG GOARCH
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y golang make git libsystemd-dev gcc-aarch64-linux-gnu gcc-x86-64-linux-gnu
ENV GOPATH /root/go

WORKDIR $GOPATH/src/github.com/box/kube-iptables-tailer
COPY . $GOPATH/src/github.com/box/kube-iptables-tailer
# Set GOARCH based on TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        export GOARCH=amd64 ; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        export GOARCH=arm64 ; \
    fi && \
    make build-cgo GOARCH=$GOARCH

FROM --platform=$TARGETPLATFORM ubuntu:noble-20240605
LABEL maintainer="Saifuding Diliyaer <sdiliyaer@box.com>"
WORKDIR /root/
COPY --from=builder /root/go/src/github.com/box/kube-iptables-tailer/kube-iptables-tailer /kube-iptables-tailer
