FROM golang:1.26-alpine AS builder

WORKDIR /app

COPY go.mod ./
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o server ./cmd/app

# Create a non-root user on a temporary file
RUN echo "appuser:x:65534:65534:appuser:/:" > /etc_passwd

FROM scratch

# Copy the passwd file to create a non-root user
COPY --from=builder /etc_passwd /etc/passwd

# Set the user to use when running the image
USER appuser

WORKDIR /app
COPY --chown=appuser:appuser --from=builder /app/server .
EXPOSE 8080
CMD ["./server"]