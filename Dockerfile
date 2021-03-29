FROM golang:1.14-stretch AS builder

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GO111MODULE=on

RUN mkdir -p /go/src/github.com/jrasell/nomad-toast
ADD . /go/src/github.com/jrasell/nomad-toast

WORKDIR /go/src/github.com/jrasell/nomad-toast/

# RUN go test -mod vendor  -v ./...
RUN go build -o /bin/nomad-toast ./cmd/nomad-toast -version local -pkg "github.com/jrasell/nomad-toast/pkg/buildconsts"


FROM alpine:3.10

RUN apk --no-cache add ca-certificates

WORKDIR /bin
COPY --from=builder /bin/nomad-toast  /bin/nomad-toast

CMD ["nomad-toast", "--help"]