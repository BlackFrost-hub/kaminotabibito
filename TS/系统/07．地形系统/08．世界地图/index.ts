/** @noSelfInFile */

export * from "./00．类型定义";
export * from "./01．世界地图地点配置";
export * from "./02．世界地图界面";
export * from "./03．世界地图交互";
export * from "./04．世界地图解锁";
export * from "./05．世界地图传送";

const 界面模块 = require("系统.07．地形系统.08．世界地图.02．世界地图界面") as {
  初始化世界地图界面: (this: void) => void;
};
const 交互模块 = require("系统.07．地形系统.08．世界地图.03．世界地图交互") as {
  初始化世界地图交互: (this: void) => void;
};
const 解锁模块 = require("系统.07．地形系统.08．世界地图.04．世界地图解锁") as {
  初始化世界地图解锁: (this: void) => void;
};
let 世界地图已初始化 = false;

export function 初始化世界地图(this: void): void {
  if (世界地图已初始化) return;
  世界地图已初始化 = true;
  界面模块.初始化世界地图界面();
  交互模块.初始化世界地图交互();
  解锁模块.初始化世界地图解锁();
}
