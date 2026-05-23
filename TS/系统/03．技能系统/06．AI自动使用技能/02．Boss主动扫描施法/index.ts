export * from "./01．Boss主动扫描驱动";

export function init(this: void): void {
  const { initBoss主动扫描施法 } = require("./01．Boss主动扫描驱动") as {
    initBoss主动扫描施法: (this: void) => void;
  };
  initBoss主动扫描施法();
}
