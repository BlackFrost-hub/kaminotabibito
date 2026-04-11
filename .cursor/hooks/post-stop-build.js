#!/usr/bin/env node
/**
 * Cursor `stop` hook：代理回合结束后执行 `npm run build`（项目根目录）
 * 禁用：编辑 .cursor/hooks.json 移除本 hook
 */
const { execSync } = require("child_process");
const path = require("path");

const root = path.resolve(__dirname, "..", "..");

try {
  execSync("npm run build", {
    cwd: root,
    stdio: "inherit",
    shell: true,
    windowsHide: true,
  });
} catch (_e) {
  process.exitCode = 0;
}

process.stdout.write("{}");
