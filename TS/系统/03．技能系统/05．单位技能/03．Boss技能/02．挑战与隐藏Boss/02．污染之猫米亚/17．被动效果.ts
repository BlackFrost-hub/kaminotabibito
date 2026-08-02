/** @noSelfInFile */

import { 米亚单位技能配置 } from "./00．配置";
import { 获取或创建米亚上下文, 注册米亚运行时 } from "./03．运行时上下文";
import { 注册米亚技能结构 } from "./16．技能入口";
import { stringToFourCC } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const { 注册Boss自动技能启动监听 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表") as {
  注册Boss自动技能启动监听: (this: void, 参数: any) => number;
};

const 米亚单位类型ID = stringToFourCC(米亚单位技能配置.单位ID);
let 米亚启动监听已注册 = false;

function on米亚Boss启动(this: void, context: any): void {
  获取或创建米亚上下文(context.Boss单位);
}

export function 注册米亚被动效果(this: void): void {
  if (米亚启动监听已注册) return;
  米亚启动监听已注册 = true;
  注册米亚运行时();
  注册米亚技能结构();
  注册Boss自动技能启动监听({
    名称: "米亚运行时上下文绑定",
    单位类型ID: 米亚单位类型ID,
    on启动: on米亚Boss启动,
  });
}

注册米亚被动效果();
