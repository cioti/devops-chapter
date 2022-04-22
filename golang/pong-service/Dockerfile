FROM golang:1.18-alpine as build

WORKDIR /app

# file context should be root of repository
COPY golang/go.mod ./
COPY golang/go.sum ./
RUN go mod download

COPY golang/pong-service/ ./

RUN go build -o pong-service

FROM alpine:latest
WORKDIR /svc

COPY --from=build /app .

CMD [ "./pong-service" ]
EXPOSE 8080