/** @noSelfInFile */

export * from "./00．配置";
import "./01．技能显示初始化";
import { 注册塞莉亚被动效果 } from "./02．被动效果";
import { 注册塞莉亚Q } from "./03．Q技能";
import { 注册塞莉亚W } from "./04．W技能";
import { 注册塞莉亚E } from "./05．E技能";
import { 注册塞莉亚R } from "./06．R技能";
import { 注册塞莉亚D } from "./07．D技能";

// 唯一监听注册入口：被动 + 全部技能壳监听在模块加载时挂接。
注册塞莉亚被动效果();
注册塞莉亚Q();
注册塞莉亚W();
注册塞莉亚E();
注册塞莉亚R();
注册塞莉亚D();

export * from "./02．被动效果";
export * from "./03．Q技能";
export * from "./04．W技能";
export * from "./05．E技能";
export * from "./06．R技能";
export * from "./07．D技能";
