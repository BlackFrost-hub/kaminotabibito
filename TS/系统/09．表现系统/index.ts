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

let 表现系统已初始化 = false;

export function init(this: void): void {
  if (表现系统已初始化) return;
  表现系统已初始化 = true;

  if (typeof 原生UI.initNativeUI === "function") {
    原生UI.initNativeUI();
  }

  UI属性系统.initUiAttributeSystem();
  // 英雄语音系统.init();
  require("系统.09．表现系统.02．对话框系统.index");
  require("系统.09．表现系统.08．吟唱条.index");
  require("系统.09．表现系统.11．背景框.index");
  单位头顶血条.init();
  镜头高度控制.init();
  物品提示模拟.init();
  广播提示消息系统.初始化广播提示消息系统();
  游戏说明手册.init();
}

export {};
