################################
# STEP 1 build executable binary
################################
FROM registry.access.redhat.com/hi/go:latest-fips-builder AS builder

USER 0

WORKDIR /workspace

# Cache deps before copying source so that we do not need to re-download for every build
COPY go.mod go.sum ./

# Fetch dependencies
RUN go mod download

# Copy source files
COPY . .

# Build binary
RUN CGO_ENABLED=1 go build -ldflags "-w -s" -o frontend-config

############################
# STEP 2 build a small image
############################
FROM registry.access.redhat.com/hi/go:latest-fips

WORKDIR /

# Setup permissions to allow RDSCA to be written from clowder to container
# https://docs.openshift.com/container-platform/4.11/openshift_images/create-images.html#images-create-guide-openshift_create-images
RUN mkdir -p /app && \
    chgrp -R 0 /app && \
    chmod -R g=u /app

COPY --from=builder /workspace/frontend-config /app/frontend-config

USER 1001

EXPOSE 8000
CMD ["/app/frontend-config"]
