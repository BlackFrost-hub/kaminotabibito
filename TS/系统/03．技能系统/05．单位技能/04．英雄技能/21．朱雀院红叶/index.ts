/** @noSelfInFile */

import "./01．技能显示初始化";
import { 注册朱雀院红叶被动 } from "./02．被动效果";
import { 注册朱雀院红叶Q } from "./03．Q技能";
import { 注册朱雀院红叶W } from "./04．W技能";
import { 注册朱雀院红叶E } from "./05．E技能";
import { 注册朱雀院红叶R } from "./06．R技能";
import { 注册朱雀院红叶D } from "./07．D技能";

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

// 被动/技能为全局懒注册（幂等），模块加载即接入
debugLogForce("红叶-index", "模块加载");
注册朱雀院红叶被动();
注册朱雀院红叶Q();
注册朱雀院红叶W();
注册朱雀院红叶E();
注册朱雀院红叶R();
注册朱雀院红叶D();

export * from "./00．配置";
export * from "./02．被动效果";
export * from "./03．Q技能";
export * from "./04．W技能";
export * from "./05．E技能";
export * from "./06．R技能";
export * from "./07．D技能";
