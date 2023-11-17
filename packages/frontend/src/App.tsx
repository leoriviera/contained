import { MutableRefObject, useEffect, useMemo, useRef } from "react";
import { Terminal } from "xterm";
import { FitAddon } from "xterm-addon-fit";
import { Socket, io } from "socket.io-client";
import { LinkProvider } from "xterm-link-provider";

import "./App.css";
import "xterm/css/xterm.css";

function App() {
  const terminalElement = useRef<HTMLDivElement>(null);
  const socket: MutableRefObject<Socket | null> = useRef<Socket>(null);

  const terminal = useMemo(
    () =>
      new Terminal({
        cursorStyle: "bar",
        cursorBlink: true,
        fontFamily: "'Fira Code', monospace",
      }),
    []
  );

  // Update terminal on resize with
  // https://unix.stackexchange.com/a/106655

  useEffect(() => {
    socket.current = io(
      process.env.NODE_ENV === "development"
        ? "http://localhost:3000"
        : process.env.REACT_APP_SERVER_DOMAIN ?? "",
      {
        transports: ["websocket"],
      }
    );

    socket.current.on("connect", () => {
      terminal.write("*** CONNECTION ESTABLISHED. ***\r\n\r\n");

      terminal.onData((data) => {
        socket.current?.emit("data", data);
      });

      socket.current?.on("data", (data) => {
        terminal.write(data);
      });

      socket.current?.on("ping", () => {
        socket.current?.emit("pong");
      });

      socket.current?.on("disconnect", () => {
        terminal.write("\r\n*** CONNECTION TERMINATED. ***\r\n\r\n");
        socket.current?.off("connect");
      });

      socket.current?.on("error", (err) => {
        console.log(err);
      });
    });

    // Clean up socket and socket listener when component unmounts,
    // as useEffect hooks will fire twice in development mode, creating two
    // socket connections (one of which immediately closes) and spawning
    // two containers
    return () => {
      socket.current?.off("connect");
      socket.current?.disconnect();
    };
  }, [socket, terminal]);

  useEffect(() => {
    if (!socket.current) {
      return;
    }

    if (!terminal.element) {
      const fitAddon = new FitAddon();

      terminal.loadAddon(fitAddon);

      terminal.open(terminalElement.current!);

      // Resize terminal on window resize
      window.addEventListener("resize", () => {
        fitAddon.fit();

        const { cols, rows } = terminal;

        console.log(socket.current);

        socket.current?.emit("resize", {
          cols,
          rows,
        });
      });

      // Fix spacing issue with xterm
      window.dispatchEvent(new Event("resize"));

      const bracketRegex = /\[(.*?)\]/g;

      terminal.registerLinkProvider(
        new LinkProvider(terminal, bracketRegex, (_, text) => {
          socket.current?.emit("data", text + "\n");
        })
      );
    }
  }, [socket, terminal]);

  return <div id="terminal" ref={terminalElement}></div>;
}

export default App;
