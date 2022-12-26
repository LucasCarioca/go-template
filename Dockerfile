FROM golang:latest as builder

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY ./ ./
RUN go build -o /app


FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=builder /app /app
COPY --from=builder /app/config.* /

ENV PORT=80
ENV GIN_MODE=release

ENTRYPOINT ["/app"]
