# contained-ssh

This Docker container allows users to view and interact with my blog. It is a simple container that exposes SSH on port 22, so a server can forward a user to it.

This container includes the [Starship shell](https://starship.rs).

Files in `etc/` are copy-merged into `etc` on the host device. Files in `home/` are copied into the user's home directory.

The contained SSH server runs for a maximum of 3600 seconds (1 hour).

When this container fires up, it download the content of my blog (at [https://github.com/leoriviera/blog](https://github.com/leoriviera/blog)) to the `blog` folder, so users can read it with `cat`.

You're able to run this project using scripts in `package.json`.

- `yarn dev:build`: builds and tags a container for local development
- `yarn prod:build`: builds the container for the `linux/amd64` and tags it for release on GHCR
- `yarn prod:push`: pushes the built container to GHCR

Although the `prod` commands are useful, the release cycle should be handled by GitHub Actions.
