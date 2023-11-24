import fastify from "fastify";
import fSocket from "fastify-socket.io";
import { hostname } from "os";
import { Socket, Server } from "socket.io";
import { Client } from "ssh2";

import { execPromise } from "./utils";

const { SSH_IMAGE, NODE_ENV } = process.env;

const server = fastify({
  logger: true,
});
server.register(fSocket);

server.get("/", async () => {
  return {
    status: "ok",
  };
});

server.listen({
  host: "0.0.0.0",
  port: 3000,
});

const spawnServer = async () => {
  const host = hostname();
  const parentContainerInfo = await getContainerInfo(host);
  const networkName = parentContainerInfo[0].HostConfig.NetworkMode;

  const containerId = await execPromise(
    // Specify network as, if parent container is started with `docker compose`,
    // sibling containers will join the default bridge network instead of
    // the sibling container's network
    NODE_ENV === "development"
      ? `docker run --network ${networkName} -d contained-ssh:dev`
      : `docker run --network ${networkName} --pull always -d ${SSH_IMAGE}`
  );

  return containerId;
};

const getContainerInfo = async (containerId: string) => {
  const inspectInfo = await execPromise(`docker inspect ${containerId}`);
  return JSON.parse(inspectInfo);
};

const stopServer = async (containerId: string) => {
  await execPromise(`docker rm -f -v ${containerId}`);
};

const connections: Record<
  string,
  {
    containerId: string;
    host: string;
    alive: boolean;
  }
> = {};

server.ready().then(async () => {
  // Check for dead connections every 20 seconds
  setInterval(async () => {
    // @ts-ignore
    const sockets = await (server.io as Server).fetchSockets();

    sockets.forEach((socket) => {
      if (connections[socket.id]?.alive === false) {
        console.log("killing dead connection", socket.id);
        socket.disconnect(true);
      }

      if (!connections[socket.id]) {
        return;
      }

      connections[socket.id].alive = false;
      socket.emit("ping");
    });
  }, 20000);

  // @ts-ignore
  (server.io as Server).on("connection", async (socket: Socket) => {
    console.log("new connection", socket.id);

    if (!connections[socket.id]) {
      const containerId = await spawnServer();
      const info = await getContainerInfo(containerId);
      const host = (
        Object.values(info[0].NetworkSettings.Networks)[0] as {
          IPAddress: string;
        }
      ).IPAddress;

      connections[socket.id] = {
        containerId,
        host,
        alive: true,
      };
    }

    // Spawn a new Docker container
    const ssh = new Client();

    socket.on("pong", () => {
      connections[socket.id].alive = true;
    });

    socket.on("disconnect", () => {
      ssh.end();
    });

    ssh
      .on("ready", () => {
        ssh.shell((err, stream) => {
          if (err) {
            return socket.emit(
              "data",
              "\r\n*** SSH SHELL ERROR: " + err.message + " ***\r\n"
            );
          }

          socket.on("data", (data) => {
            stream.write(data);
          });

          stream
            .on("data", (d: Buffer) => {
              socket.emit("data", d.toString("utf-8"));
            })
            .stderr.on("data", (d: Buffer) => {
              socket.emit("data", d.toString("utf-8"));
            })
            .on("close", () => {
              ssh.end();
            });
        });
      })
      .on("close", async () => {
        socket.emit("data", "\r\n*** SSH CONNECTION CLOSED ***\r\n");
        await stopServer(connections[socket.id].containerId);
      })
      .on("error", async (error) => {
        console.log(error);
        socket.emit(
          "data",
          "\r\n*** SSH CONNECTION ERROR: " + error.message + " ***\r\n"
        );
        socket.disconnect(true);
      })
      .connect({
        username: "user",
        host: connections[socket.id].host,
        port: 22,
      });
  });
});
