/** @noSelfInFile */
/**
 * Buff系统 - 初始化入口
 *
 * 不在这里做 export * 聚合，避免加载期把 BuffUI / Buff表 / 控制抗性
 * 卷入同一条导出链，触发运行时 critical dependency。
 */

const buffPoolCore = require("系统.05．Buff系统.00．Buff系统") as {
  initBuffSystem: (this: void) => void;
};
const buffUIMod = require("系统.05．Buff系统.02．BuffUI") as {
  init: (this: void) => void;
};
const controlResistMod = require("系统.05．Buff系统.01．控制抗性.index") as {
  initControlResist: (this: void) => void;
};
const sleepMod = require("系统.05．Buff系统.07．睡眠系统") as {
  初始化睡眠系统: (this: void) => void;
};

let Buff系统已初始化 = false;

export function init(this: void): void {
  if (Buff系统已初始化) return;
  Buff系统已初始化 = true;

  buffPoolCore.initBuffSystem();
  require("系统.05．Buff系统.01．Buff表");
  buffUIMod.init();
  require("系统.05．Buff系统.03．BuffJASS桥接");
  require("系统.05．Buff系统.05．Buff清除函数");
  controlResistMod.initControlResist();
  sleepMod.初始化睡眠系统();
}

export {};
