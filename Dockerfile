# syntax=docker/dockerfile:1

FROM golang:1.26 AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o /agent ./cmd/agent


FROM gcr.io/distroless/static-debian12:nonroot

WORKDIR /

COPY --from=builder /agent /agent

USER nonroot:nonroot

ENTRYPOINT ["/agent"]