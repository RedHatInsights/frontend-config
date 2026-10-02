################################
# STEP 1 build TypeScript source
################################
FROM registry.access.redhat.com/hi/nodejs:latest-builder AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

############################
# STEP 2 build a small image
############################
FROM registry.access.redhat.com/hi/nodejs:latest

WORKDIR /app

# Setup permissions to allow RDSCA to be written from clowder to container
# https://docs.openshift.com/container-platform/4.11/openshift_images/create-images.html#images-create-guide-openshift_create-images
RUN mkdir -p /app && \
    chgrp -R 0 /app && \
    chmod -R g=u /app

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist
RUN npm ci --omit=dev

USER 1001

EXPOSE 8000
CMD ["node", "dist/main.js"]
