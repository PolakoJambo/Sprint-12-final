FROM golang:1.22 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /main .

FROM alpine:latest

WORKDIR /app

COPY --from=builder /main .
COPY --from=builder /app/tracker.db .

CMD ["/main"]