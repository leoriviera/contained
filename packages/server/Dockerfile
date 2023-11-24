FROM node:20

ARG SSH_IMAGE=ghcr.io/leoriviera/contained-server:latest
ENV SSH_IMAGE=$SSH_IMAGE

# Download and install the Docker daemon
RUN apt-get -yqq update && apt-get -yqq install docker.io

RUN usermod -aG docker node

# Set the working directory
WORKDIR /usr/src/app

# Copy source code
COPY --chown=node:node package.json ./
COPY --chown=node:node yarn.lock ./

# Running yarn install
RUN yarn install --production

# Copy the rest of your app's source code from your host to your image filesystem.
COPY --chown=node:node . .

# Build the app
RUN yarn build

# Switch to 'node' user
# Fix with https://stackoverflow.com/a/41574919
# USER node

# Open the mapped port
EXPOSE 3000

CMD ["node", "build/index.js"]
