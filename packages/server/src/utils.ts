import { exec } from "child_process";

// Simple function to execute a promise and return the result
export const execPromise = (command: string) =>
  new Promise<string>((res, rej) =>
    exec(command, (err, stdout) => {
      if (err) {
        rej(err);
      }

      res(stdout.trimEnd());
    })
  );
