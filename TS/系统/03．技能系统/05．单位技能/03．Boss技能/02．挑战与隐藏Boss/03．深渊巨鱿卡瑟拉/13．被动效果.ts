/** @noSelfInFile */

import { 注册卡瑟拉技能结构 } from "./12．技能入口";

import { 获取或创建卡瑟拉上下文 } from "./01．运行时上下文";
import { 卡瑟拉单位技能配置 } from "./00．配置";
import { stringToFourCC } from "./14．公共工具";

const { 注册Boss自动技能启动监听 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表") as {
  注册Boss自动技能启动监听: (this: void, 参数: any) => number;
};

const 卡瑟拉单位类型ID = stringToFourCC(卡瑟拉单位技能配置.单位ID);
let 卡瑟拉被动已注册 = false;

function on卡瑟拉Boss启动(this: void, 启动上下文: any): void {
  获取或创建卡瑟拉上下文(启动上下文.Boss单位);
}

export function 注册卡瑟拉被动效果(this: void): void {
  if (卡瑟拉被动已注册) return;
  卡瑟拉被动已注册 = true;
  注册卡瑟拉技能结构();
  注册Boss自动技能启动监听({
    名称: "卡瑟拉运行时上下文绑定",
    单位类型ID: 卡瑟拉单位类型ID,
    on启动: on卡瑟拉Boss启动,
  });
}

注册卡瑟拉被动效果();
