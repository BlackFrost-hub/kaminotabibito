/** @noSelfInFile */

import { 获取或创建里科特上下文, 注册里科特运行时 } from "./01．运行时上下文";
import { 注册里科特技能结构 } from "./11．技能入口";
import { 里科特单位技能配置 } from "./00．配置";
import { stringToFourCC } from "./13．公共工具";

const { 注册Boss自动技能启动监听 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表") as {
  注册Boss自动技能启动监听: (this: void, 参数: any) => number;
};

let 里科特被动已注册 = false;
const 里科特单位类型ID = stringToFourCC(里科特单位技能配置.单位ID);

function on里科特Boss启动(this: void, 启动上下文: any): void {
  获取或创建里科特上下文(启动上下文.Boss单位);
}

export function 注册里科特被动效果(this: void): void {
  if (里科特被动已注册) return;
  里科特被动已注册 = true;
  注册里科特运行时();
  注册里科特技能结构();
  注册Boss自动技能启动监听({
    名称: "里科特运行时上下文绑定",
    单位类型ID: 里科特单位类型ID,
    on启动: on里科特Boss启动,
  });
}

注册里科特被动效果();
