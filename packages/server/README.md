# `contained` server

This is the server for `contained`, the blog that's made of containers! This image is built for `linux/arm64`.

This "main" container, which runs the server, uses the Docker-out-of-Docker pattern. It connects to the Docker socket on the host machine and spawns sibling containers users can connect to.

## Contributing

Install dependencies using `yarn`.

You're able to run this project using scripts in `package.json`.

- `yarn dev:build`: builds and tags a container for local development.
- `yarn dev:start`: launches the local development container on port 3000, with supports hot-reloading of local code
- `yarn prod:build`: builds the container for the `linux/amd64` and tags it for release on GHCR
- `yarn prod:push`: pushes the built container to GHCR

Although the `prod` commands are useful, the release cycle should be handled by GitHub Actions.
