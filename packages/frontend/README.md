# `contained` frontend

This is the React front-end for `contained`, the blog that's made of containers!

This is a terminal which connects via a websocket to a container running on an EC2 instance. It sends and receives data via WebSockets.

## Environment Variables

- `REACT_APP_FRONTEND_DOMAIN`: the domain of the frontend (for example, `sh.cowsay.io`)
- `REACT_APP_SERVER_DOMAIN`: the domain of the `contained` server (for example, `sh-srv.cowsay.io`)

These are normally provided by the GitHub Actions workflow which builds and deploys the frontend.

## Contributing

Install dependencies using `yarn`.

Run `yarn start` in this directory.
