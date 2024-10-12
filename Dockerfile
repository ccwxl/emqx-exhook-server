FROM golang:1.23.2-alpine3.20 as builder
WORKDIR /build
ENV GOPROXY="https://goproxy.io,direct"
ENV GO111MODULE=on
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -ldflags="-w -s" -o emqx-exhook-server main.go

FROM alpine:3.20.3
WORKDIR /app
COPY --from=builder /build/emqx-exhook-server /app/
ENV TZ=Asia/Shanghai
ENV server_port=:9000
CMD ["/app/emqx-exhook-server"]
