# Etapa de build
FROM golang:1.22 AS builder
WORKDIR /src
COPY . .
RUN go mod download
# ⬇️ IMPORTANTE: como seu main.go está em cmd/main.go, buildamos a pasta ./cmd
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /out/server ./cmd

# Etapa de execução (mínima e segura)
FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=builder /out/server /app/server
ENV PORT=8080
EXPOSE 8080
USER 65532:65532
ENTRYPOINT ["/app/server"]
