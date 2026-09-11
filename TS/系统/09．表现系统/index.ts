/** @noSelfInFile */
/**
 * 表现系统 - main 初始化入口
 *
 * main 只依赖 init。这里不做 export * 聚合，避免加载期把 UI 工具、
 * 对话框、仇恨面板、广播提示、手册等模块卷进同一条导出链。
 */

const 原生UI = require("系统.09．表现系统.00．初始化UI") as {
  initNativeUI: (this: void) => void;
};
const UI属性系统 = require("系统.09．表现系统.03．UI属性系统.03．系统入口") as {
  initUiAttributeSystem: (this: void) => void;
};
const 广播提示消息系统 = require("系统.09．表现系统.06．广播提示消息.index") as {
  初始化广播提示消息系统: (this: void) => void;
};
const 游戏说明手册 = require("系统.09．表现系统.07．游戏说明手册.index") as {
  init: (this: void) => void;
};
// const 英雄语音系统 = require("系统.09．表现系统.10．英雄语音.index") as {
//   init: (this: void) => void;
// };
const 物品提示模拟 = require("系统.09．表现系统.12．物品提示模拟.index") as {
  init: (this: void) => void;
};
const 单位头顶血条 = require("系统.09．表现系统.13．单位头顶血条.index") as {
  init: (this: void) => void;
};
const 镜头高度控制 = require("系统.09．表现系统.14．镜头高度控制.index") as {
  init: (this: void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

let 表现系统已初始化 = false;
const UI_STARTUP_LOG_MODULE = "表现系统/UI错峰初始化";

function 初始化原生UI(this: void): void {
  debugLogForce(UI_STARTUP_LOG_MODULE, "启动原生UI", "delayMs=", 750);
  原生UI.initNativeUI();
}

function 初始化单位头顶血条(this: void): void {
  debugLogForce(UI_STARTUP_LOG_MODULE, "启动单位头顶血条", "delayMs=", 1250);
  单位头顶血条.init();
}

function 初始化游戏说明手册(this: void): void {
  debugLogForce(UI_STARTUP_LOG_MODULE, "启动游戏说明手册", "delayMs=", 2000);
  游戏说明手册.init();
}

function 初始化物品提示模拟(this: void): void {
  debugLogForce(UI_STARTUP_LOG_MODULE, "启动物品提示模拟", "delayMs=", 2250);
  物品提示模拟.init();
}

export function init(this: void): void {
  if (表现系统已初始化) return;
  表现系统已初始化 = true;

  UI属性系统.initUiAttributeSystem();
  // 英雄语音系统.init();
  debugLogForce(UI_STARTUP_LOG_MODULE, "准备加载对话框系统");
  require("系统.09．表现系统.02．对话框系统.index");
  debugLogForce(UI_STARTUP_LOG_MODULE, "对话框系统加载完成");
  debugLogForce(UI_STARTUP_LOG_MODULE, "准备加载吟唱条系统");
  require("系统.09．表现系统.08．吟唱条.index");
  debugLogForce(UI_STARTUP_LOG_MODULE, "吟唱条系统加载完成");
  debugLogForce(UI_STARTUP_LOG_MODULE, "准备加载背景框系统");
  require("系统.09．表现系统.11．背景框.index");
  debugLogForce(UI_STARTUP_LOG_MODULE, "背景框系统加载完成");
  debugLogForce(UI_STARTUP_LOG_MODULE, "准备初始化镜头高度控制");
  镜头高度控制.init();
  debugLogForce(UI_STARTUP_LOG_MODULE, "镜头高度控制初始化完成");
  debugLogForce(UI_STARTUP_LOG_MODULE, "准备初始化广播提示消息系统");
  广播提示消息系统.初始化广播提示消息系统();
  debugLogForce(UI_STARTUP_LOG_MODULE, "广播提示消息系统初始化完成");

  debugLogForce(UI_STARTUP_LOG_MODULE, "已安排UI错峰初始化");
  if (typeof 原生UI.initNativeUI === "function") {
    debugLogForce(UI_STARTUP_LOG_MODULE, "准备注册原生UI延迟任务");
    addDelayedCallback(750, 初始化原生UI);
    debugLogForce(UI_STARTUP_LOG_MODULE, "原生UI延迟任务注册完成");
  }
  debugLogForce(UI_STARTUP_LOG_MODULE, "准备注册血条延迟任务");
  addDelayedCallback(1250, 初始化单位头顶血条);
  debugLogForce(UI_STARTUP_LOG_MODULE, "血条延迟任务注册完成");
  debugLogForce(UI_STARTUP_LOG_MODULE, "准备注册手册延迟任务");
  addDelayedCallback(2000, 初始化游戏说明手册);
  debugLogForce(UI_STARTUP_LOG_MODULE, "手册延迟任务注册完成");
  debugLogForce(UI_STARTUP_LOG_MODULE, "准备注册物品提示延迟任务");
  addDelayedCallback(2250, 初始化物品提示模拟);
  debugLogForce(UI_STARTUP_LOG_MODULE, "物品提示延迟任务注册完成");
}

export {};
