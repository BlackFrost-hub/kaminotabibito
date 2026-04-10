/**
 * 全局桥接入口
 * - 统一把项目内常用函数挂到 globalThis
 * - 供配置表达式 / 旧JASS风格调用直接使用
 * - 各模块的桥接逻辑已分散到各自文件夹的 index.ts 中
 */

const jass = require("jass.common") as any;

const bjBridge = require("lib.扩展函数.BJ函数.index") as { registerBridge?: () => void };
const ydweBridge = require("lib.扩展函数.YDWE函数.index") as { registerBridge?: () => void };
const starBridge = require("lib.扩展函数.Star扩展函数.index") as { registerBridge?: () => void };
const kkBridge = require("lib.扩展函数.KK扩展API.index") as { registerBridge?: () => void };

function bridgeFromJass(name: string): void {
  const g = globalThis as any;
  if (typeof g[name] === "function") return;
  if (jass && typeof jass[name] === "function") {
    g[name] = jass[name];
  }
}

bridgeFromJass("GetHandleId");

if (typeof bjBridge.registerBridge === "function") bjBridge.registerBridge();
if (typeof ydweBridge.registerBridge === "function") ydweBridge.registerBridge();
if (typeof starBridge.registerBridge === "function") starBridge.registerBridge();
if (typeof kkBridge.registerBridge === "function") kkBridge.registerBridge();

export {};
