/** @noSelfInFile */

import type { 菲尼克斯尔运行时上下文 } from "./03．运行时上下文";
import { 菲尼克斯尔数值与表现配置, 菲尼克斯尔音效配置 } from "./02．数值与表现配置";
import { 切换菲尼克斯尔第二形态 } from "./04．双形态转换";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import {
  延迟,
  单位存活,
  播放点特效,
  取单位X,
  取单位Y,
  设置单位动画,
  显示大招读条,
  开始施法硬直,
} from "./19．公共工具";
import { 初始化菲尼克斯尔骸骨弹幕节点 } from "./11．骸骨弹幕";
import { 初始化菲尼克斯尔怨火链接节点 } from "./12．怨火链接";
import { 初始化菲尼克斯尔凤凰挽歌节点 } from "./13．凤凰挽歌";
import { 初始化菲尼克斯尔元素爆发节点 } from "./14．元素爆发";
import { 初始化菲尼克斯尔怨火核心暴露节点 } from "./15．怨火核心暴露";
import { 初始化菲尼克斯尔永恒轮回节点 } from "./16．永恒轮回";

function 初始化菲尼克斯尔第二形态机制(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.P2机制已初始化) return;
  context.P2机制已初始化 = true;
  初始化菲尼克斯尔骸骨弹幕节点(context);
  初始化菲尼克斯尔怨火链接节点(context);
  初始化菲尼克斯尔凤凰挽歌节点(context);
  初始化菲尼克斯尔元素爆发节点(context);
  初始化菲尼克斯尔怨火核心暴露节点(context);
  初始化菲尼克斯尔永恒轮回节点(context);
}

export function 触发菲尼克斯尔P1转场(this: void, context: 菲尼克斯尔运行时上下文): void {
  const boss = context.Boss;
  if (!单位存活(boss) || context.当前形态 !== "第一形态") return;
  const duration = 5;
  播放菲尼克斯尔台词(boss, "浴火重生准备");
  开始施法硬直(boss, duration);
  设置单位动画(boss, 菲尼克斯尔数值与表现配置.动画.第一形态.重生死亡.编号, 菲尼克斯尔数值与表现配置.动画.第一形态.重生死亡.倍速);
  显示大招读条(duration, 3, "菲尼克斯尔正在浴火重生！", "摧毁导管后的封印正在崩解");
  播放点特效(菲尼克斯尔数值与表现配置.特效.冰核破碎A, 取单位X(boss), 取单位Y(boss), 3500);
  播放点特效(菲尼克斯尔数值与表现配置.特效.冰核破碎B, 取单位X(boss), 取单位Y(boss), 3500);
  播放Boss坐标音效(菲尼克斯尔音效配置.转第二形态.冰核破碎重生, 取单位X(boss), 取单位Y(boss), 菲尼克斯尔音效配置.默认裁断距离);
  延迟(duration * 1000, function 菲尼克斯尔P1转场完成(this: void): void {
    切换菲尼克斯尔第二形态(context);
    初始化菲尼克斯尔第二形态机制(context);
  });
}

export function 注册菲尼克斯尔浴火重生准备(this: void): void {
  // 第一形态转场机制由导管全部破坏后触发。
}
