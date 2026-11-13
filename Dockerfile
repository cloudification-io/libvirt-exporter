FROM golang:1.27.4-alpine3.24 AS build

ARG VERSION
ENV VERSION=${VERSION:-development}

ENV LIBVIRT_EXPORTER_PATH=/libvirt-exporter

RUN apk add ca-certificates gcc musl-dev libvirt-dev && \
    mkdir -p $LIBVIRT_EXPORTER_PATH
WORKDIR $LIBVIRT_EXPORTER_PATH
COPY . .

RUN go build -ldflags="-X 'main.Version=${VERSION}'" -mod vendor

FROM alpine:3.24
RUN apk add ca-certificates libvirt
COPY --from=build /libvirt-exporter/libvirt-exporter /
EXPOSE 9177

ENTRYPOINT [ "/libvirt-exporter" ]
