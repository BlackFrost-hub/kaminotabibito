/** @noSelfInFile */

import { 菲利斯单位技能配置 } from "./00．配置";
import { 获取或创建菲利斯上下文 } from "./01．运行时上下文";
import { 注册菲利斯技能结构 } from "./09．技能入口";
import { stringToFourCC } from "./11．公共工具";
import { 注册菲利斯第二军团随从效果 } from "./12．第二军团随从";
import { 初始化菲利斯异形化充能 } from "./07．异形化";

const { 注册Boss自动技能启动监听 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表") as {
  注册Boss自动技能启动监听: (this: void, 参数: any) => number;
};

const 菲利斯单位类型ID = stringToFourCC(菲利斯单位技能配置.单位ID);
let 菲利斯被动已注册 = false;

function on菲利斯Boss启动(this: void, 启动上下文: any): void {
  const context = 获取或创建菲利斯上下文(启动上下文.Boss单位);
  if (context != null) 初始化菲利斯异形化充能(context);
}

export function 注册菲利斯被动效果(this: void): void {
  if (菲利斯被动已注册) return;
  菲利斯被动已注册 = true;
  注册菲利斯技能结构();
  注册菲利斯第二军团随从效果();
  注册Boss自动技能启动监听({
    名称: "菲利斯运行时上下文绑定",
    单位类型ID: 菲利斯单位类型ID,
    on启动: on菲利斯Boss启动,
  });
}

注册菲利斯被动效果();
