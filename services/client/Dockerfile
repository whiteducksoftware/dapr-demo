# Build
FROM golang:1.16-buster as build-env
WORKDIR /build
COPY . .
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Run
FROM debian:buster-slim
# Connect the container image with the github repository
LABEL org.opencontainers.image.source https://github.com/whiteducksoftware/dapr-demo
RUN adduser \
  --disabled-password \
  --home /app \
  --gecos '' app \
  && chown -R app /app
USER app
WORKDIR /app
COPY --from=build-env /build/main .

ENTRYPOINT ["/app/main"]
