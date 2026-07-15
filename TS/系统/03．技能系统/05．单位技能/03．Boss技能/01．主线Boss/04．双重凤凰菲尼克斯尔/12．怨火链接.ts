/** @noSelfInFile */

import type { 菲尼克斯尔运行时上下文 } from "./03．运行时上下文";
import { 菲尼克斯尔单位技能配置 } from "./00．配置";
import { 菲尼克斯尔场地配置 } from "./01．场地配置";
import { 菲尼克斯尔数值与表现配置, 菲尼克斯尔音效配置 } from "./02．数值与表现配置";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import {
  周期,
  延迟,
  停止周期,
  单位存活,
  取菲尼克斯尔玩家英雄列表,
  取单位X,
  取单位Y,
  两点距离,
  线段到点距离,
  创建预警圆,
  造成暗火伤害,
  创建菲尼克斯尔独立伤害上下文,
  计算攻击最大生命伤害,
  计算攻击已损失伤害,
  添加元素层数,
  显示常规读条,
  创建菲尼克斯尔机制单位,
  单位有效,
  取最大生命,
  设置单位动画,
} from "./19．公共工具";

const { 创建单位绑定闪电 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电") as {
  创建单位绑定闪电: (this: void, 参数: any) => any;
};
const { 闪电效果代码 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.17．闪电效果代码") as {
  闪电效果代码: any;
};

export function 释放菲尼克斯尔怨火链接(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.当前形态 !== "第二形态" || !单位存活(context.Boss)) return;
  const heroes = 取菲尼克斯尔玩家英雄列表();
  if (heroes.length < 1) return;
  const a = heroes[0];
  let b = heroes.length >= 2 ? heroes[heroes.length - 1] : context.怨火锚点;
  if (!单位有效(b)) {
    const center = 菲尼克斯尔场地配置.中心点;
    b = 创建菲尼克斯尔机制单位(
      context,
      菲尼克斯尔单位技能配置.机制单位ID.怨火核心,
      "怨火锚点",
      菲尼克斯尔单位技能配置.模型.怨火核心,
      center.x,
      center.y,
      取最大生命(context.Boss) * 0.05
    );
    context.怨火锚点 = b;
  }
  if (!单位存活(a) || !单位存活(b) || a === b) return;
  const config = 菲尼克斯尔数值与表现配置.怨火链接;
  const 伤害上下文 = 创建菲尼克斯尔独立伤害上下文("菲尼克斯尔怨火链接", config.预警秒 + config.持续秒 + 2);
  设置单位动画(context.Boss, 菲尼克斯尔数值与表现配置.动画.第二形态.施法.编号, 菲尼克斯尔数值与表现配置.动画.第二形态.施法.倍速);
  播放菲尼克斯尔台词(context.Boss, "怨火链接");
  显示常规读条(config.预警秒, config.吟唱条颜色ID, config.吟唱条标题文本, config.吟唱条提示文本);
  创建预警圆(取单位X(a), 取单位Y(a), 160, config.预警秒);
  创建预警圆(取单位X(b), 取单位Y(b), 160, config.预警秒);
  延迟(config.预警秒 * 1000, function 菲尼克斯尔怨火链接创建(this: void): void {
    if (!单位存活(a) || !单位存活(b)) return;
    const lightning = 创建单位绑定闪电({
      效果代码: 闪电效果代码.红色光束 ?? 闪电效果代码.生命吸取 ?? "DRAL",
      起点单位: a,
      终点单位: b,
      持续时间: config.持续秒,
      起点高度偏移: 80,
      终点高度偏移: 80,
      任一死亡时销毁: true,
    });
    context.清理.登记闪电("菲尼克斯尔怨火链接", lightning);
    播放Boss坐标音效(菲尼克斯尔音效配置.怨火链接.链接生成, (取单位X(a) + 取单位X(b)) * 0.5, (取单位Y(a) + 取单位Y(b)) * 0.5, 菲尼克斯尔音效配置.默认裁断距离);
    const tick = 周期(config.Tick秒 * 1000, function 菲尼克斯尔怨火链接Tick(this: void): void {
      if (!单位存活(a) || !单位存活(b)) return;
      if (两点距离(取单位X(a), 取单位Y(a), 取单位X(b), 取单位Y(b)) > config.断链距离) {
        造成暗火伤害(context.Boss, a, 计算攻击已损失伤害(context.Boss, a, config.断链伤害Boss攻击力比例, config.断链伤害目标已损失生命比例), "AOE", 伤害上下文);
        造成暗火伤害(context.Boss, b, 计算攻击已损失伤害(context.Boss, b, config.断链伤害Boss攻击力比例, config.断链伤害目标已损失生命比例), "AOE", 伤害上下文);
        添加元素层数(a, "暗", config.怨火层数);
        添加元素层数(b, "暗", config.怨火层数);
        停止周期(tick);
        return;
      }
      const all = 取菲尼克斯尔玩家英雄列表();
      for (let i = 0; i < all.length; i++) {
        const u = all[i];
        if (u === a || u === b) continue;
        if (线段到点距离(取单位X(a), 取单位Y(a), 取单位X(b), 取单位Y(b), 取单位X(u), 取单位Y(u)) <= config.线宽) {
          造成暗火伤害(context.Boss, u, 计算攻击最大生命伤害(context.Boss, u, config.穿线伤害Boss攻击力比例, config.穿线伤害目标最大生命比例), "AOE", 伤害上下文);
          添加元素层数(u, "暗", config.怨火层数);
        }
      }
    });
    context.清理.登记周期回调("菲尼克斯尔怨火链接Tick", tick);
    延迟(config.持续秒 * 1000, function 菲尼克斯尔怨火链接结束(this: void): void {
      停止周期(tick);
    });
  });
}

export function 初始化菲尼克斯尔怨火链接节点(this: void, context: 菲尼克斯尔运行时上下文): void {
  const timerId = 周期(19000, function 菲尼克斯尔怨火链接周期(this: void): void {
    释放菲尼克斯尔怨火链接(context);
  });
  context.清理.登记周期回调("菲尼克斯尔-怨火链接", timerId);
}

export function 注册菲尼克斯尔怨火链接(this: void): void {
  // 第二形态周期机制，由转阶段时初始化。
}

