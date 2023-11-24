# `contained`

To run this locally, you'll need to

1. Install dependencies for each `packages/*` directory with `yarn`
2. In `packages/ssh/`, build the development SSH container with `yarn dev:build`
3. In `packages/server/`, build the development server container with `yarn dev:build`
4. In `packages/server/`, run the development server container with `yarn dev:run`
5. In `packages/frontend`, run `yarn start` to spin up the frontend and connect to the development server
