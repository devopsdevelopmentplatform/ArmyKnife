ARG IMAGE=golang:1.22.1-alpine3.18
FROM $IMAGE as builder

LABEL maintainer="fatporkrinds[at]gmail.com"

RUN apk --no-cache --update add \
    bash \
    git \
    build-base \
    openssh-client \
    make \
    curl 

# Set the current working directory inside the container
WORKDIR /app

RUN rm -f go.mod go.sum

RUN go mod init gitlab.prod.chaoscarnival.ai/kubespray/multiarch-docker-build

# Copy the source code into the container
COPY . .

# Download dependencies
RUN go mod download

# Build the Go app
RUN go build -o mygoapp .

FROM scratch

# Copy the Pre-built binary file from the previous stage

COPY --from=builder /app/mygoapp /app/mygoapp

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["./mygoapp"]

