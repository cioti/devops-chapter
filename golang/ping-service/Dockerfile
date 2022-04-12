FROM golang:1.18-alpine as build

WORKDIR /app

# file context should be root of repository
COPY golang/go.mod ./
COPY golang/go.sum ./
RUN go mod download

COPY golang/ping-service/ ./

RUN go build -o ping-service

FROM alpine:latest
WORKDIR /svc

COPY --from=build /app .

CMD [ "./ping-service" ]
EXPOSE 8080