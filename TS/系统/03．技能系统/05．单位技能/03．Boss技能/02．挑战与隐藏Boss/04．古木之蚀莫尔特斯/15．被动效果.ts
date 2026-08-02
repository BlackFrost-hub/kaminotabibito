/** @noSelfInFile */

import { 莫尔特斯单位技能配置 } from "./00．配置";
import { 获取或创建莫尔特斯上下文, 注册莫尔特斯运行时 } from "./01．运行时上下文";
import { 注册莫尔特斯技能结构 } from "./14．技能入口";
import { stringToFourCC } from "./16．公共工具";

const { 注册Boss自动技能启动监听 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表") as {
  注册Boss自动技能启动监听: (this: void, 参数: any) => number;
};

let 莫尔特斯被动已注册 = false;
const 莫尔特斯单位类型ID = stringToFourCC(莫尔特斯单位技能配置.单位ID);

function on莫尔特斯Boss启动(this: void, context: any): void {
  获取或创建莫尔特斯上下文(context.Boss单位);
}

export function 注册莫尔特斯被动效果(this: void): void {
  if (莫尔特斯被动已注册) return;
  莫尔特斯被动已注册 = true;
  注册莫尔特斯运行时();
  注册莫尔特斯技能结构();
  注册Boss自动技能启动监听({
    名称: "莫尔特斯运行时上下文绑定",
    单位类型ID: 莫尔特斯单位类型ID,
    on启动: on莫尔特斯Boss启动,
  });
}

注册莫尔特斯被动效果();
