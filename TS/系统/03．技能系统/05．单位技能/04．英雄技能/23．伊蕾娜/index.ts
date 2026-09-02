/** @noSelfInFile */

export * from "./00．配置";
export * from "./01A．动作表现";
import "./01．技能显示初始化";
import { 注册伊蕾娜被动效果 } from "./02．被动效果";
import { 注册伊蕾娜Q } from "./03．Q技能";
import { 注册伊蕾娜W } from "./04．W技能";
import { 注册伊蕾娜E } from "./05．E技能";
import { 注册伊蕾娜R } from "./06．R技能";
import { 注册伊蕾娜D } from "./07．D技能";

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

// 唯一注册入口：被动 + 全部技能壳监听在模块加载时挂接。
debugLogForce("伊蕾娜-index", "模块加载");
注册伊蕾娜被动效果();
注册伊蕾娜Q();
注册伊蕾娜W();
注册伊蕾娜E();
注册伊蕾娜R();
注册伊蕾娜D();

export * from "./02．被动效果";
export * from "./03．Q技能";
export * from "./04．W技能";
export * from "./05．E技能";
export * from "./06．R技能";
export * from "./07．D技能";
