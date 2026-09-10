/** @noSelfInFile */
import "./01．技能显示初始化";
import "./01A．动作表现";
import { 注册芙莉莲被动 } from "./02．被动效果";
import { 注册芙莉莲Q } from "./03．Q技能";
import { 注册芙莉莲W } from "./04．W技能";
import { 注册芙莉莲E } from "./05．E技能";
import { 注册芙莉莲R } from "./06．R技能";
import { 注册芙莉莲D } from "./07．D技能";

// 被动/技能为全局懒注册（幂等），模块加载即接入
注册芙莉莲被动();
注册芙莉莲Q();
注册芙莉莲W();
注册芙莉莲E();
注册芙莉莲R();
注册芙莉莲D();

export * from "./00．配置";
export * from "./01A．动作表现";
export * from "./02．被动效果";
export * from "./03．Q技能";
export * from "./04．W技能";
export * from "./05．E技能";
export * from "./06．R技能";
export * from "./07．D技能";
