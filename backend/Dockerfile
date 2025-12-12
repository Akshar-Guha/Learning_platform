# Build Stage
FROM golang:1.22-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git ca-certificates

# Set working directory
WORKDIR /app

# Copy everything first
COPY . .

# Build the application with module download inline
# Using -mod=mod to allow fetching and GOFLAGS for insecure mode
ENV GOPROXY=https://proxy.golang.org,direct
ENV GOSUMDB=off
ENV CGO_ENABLED=0
RUN go mod tidy
RUN go build -o main ./cmd/server/main.go

# Final Stage
FROM alpine:3.19

# Install certificates for HTTPS (needed for Supabase connection)
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the binary from builder
COPY --from=builder /app/main .

# Expose port
EXPOSE 8080

# Run the binary
CMD ["./main"]
