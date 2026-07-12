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
  取当前生命,
  取最大生命,
  设置当前生命,
  取单位X,
  取单位Y,
  创建菲尼克斯尔机制单位,
  播放点特效,
  显示致命读条,
  开始施法硬直,
  设置单位动画,
  取菲尼克斯尔玩家英雄列表,
  计算攻击最大生命伤害,
  造成暗火伤害,
  创建菲尼克斯尔独立伤害上下文,
} from "./19．公共工具";

const jass = require("jass.common") as any;
const KillUnit = jass.KillUnit as (whichUnit: any) => void;
const RemoveUnit = jass.RemoveUnit as (whichUnit: any) => void;

function 清理菲尼克斯尔凤凰蛋(this: void, context: 菲尼克斯尔运行时上下文): void {
  for (let i = 0; i < context.凤凰蛋列表.length; i++) {
    const item = context.凤凰蛋列表[i];
    const egg = item.单位;
    if (egg != null && egg !== 0) {
      if (!item.已摧毁) 播放点特效(菲尼克斯尔数值与表现配置.特效.永恒轮回星屑残留, 取单位X(egg), 取单位Y(egg), 1200);
      RemoveUnit(egg);
    }
  }
  context.凤凰蛋列表 = [];
}

function on菲尼克斯尔凤凰蛋死亡(this: void, context: 菲尼克斯尔运行时上下文, unit: any): void {
  for (let i = 0; i < context.凤凰蛋列表.length; i++) {
    const item = context.凤凰蛋列表[i];
    if (item.单位 !== unit) continue;
    if (item.已摧毁) return;
    item.已摧毁 = true;
    播放点特效(菲尼克斯尔数值与表现配置.特效.永恒轮回星屑残留, 取单位X(unit), 取单位Y(unit), 1200);
    播放Boss坐标音效(菲尼克斯尔音效配置.永恒轮回.凤凰蛋摧毁, 取单位X(unit), 取单位Y(unit), 菲尼克斯尔音效配置.默认裁断距离);
    return;
  }
}

function 创建凤凰蛋死亡回调(this: void, context: 菲尼克斯尔运行时上下文): (this: void, unit: any, killer: any) => void {
  return function 菲尼克斯尔凤凰蛋死亡(this: void, unit: any): void {
    on菲尼克斯尔凤凰蛋死亡(context, unit);
  };
}

export function 触发菲尼克斯尔永恒轮回(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.永恒轮回已触发 || context.当前形态 !== "第二形态" || !单位存活(context.Boss)) return;
  context.永恒轮回已触发 = true;
  context.当前形态 = "永恒轮回";
  const config = 菲尼克斯尔数值与表现配置.机制;
  const 伤害上下文 = 创建菲尼克斯尔独立伤害上下文("菲尼克斯尔永恒轮回", config.永恒轮回引导秒 + 2);
  播放菲尼克斯尔台词(context.Boss, "永恒轮回");
  开始施法硬直(context.Boss, config.永恒轮回引导秒);
  设置单位动画(context.Boss, 菲尼克斯尔数值与表现配置.动画.第二形态.轮回死亡.编号, 菲尼克斯尔数值与表现配置.动画.第二形态.轮回死亡.倍速);
  显示致命读条(config.永恒轮回引导秒, 3, "永恒轮回倒计时", "摧毁凤凰之卵，否则菲尼克斯尔将恢复生命");
  播放Boss坐标音效(菲尼克斯尔音效配置.永恒轮回.开始, 取单位X(context.Boss), 取单位Y(context.Boss), 菲尼克斯尔音效配置.默认裁断距离);
  const points = 菲尼克斯尔场地配置.导管点位;
  for (let i = 0; i < points.length; i++) {
    const p = points[i];
    const egg = 创建菲尼克斯尔机制单位(
      context,
      菲尼克斯尔单位技能配置.机制单位ID.凤凰之卵,
      "凤凰之卵",
      菲尼克斯尔单位技能配置.模型.凤凰之卵,
      p.x,
      p.y,
      取最大生命(context.Boss) * config.凤凰蛋生命Boss最大生命比例,
      创建凤凰蛋死亡回调(context)
    );
    context.凤凰蛋列表.push({ 单位: egg, 已摧毁: false });
    播放点特效(菲尼克斯尔数值与表现配置.特效.永恒轮回能量上升, p.x, p.y, 2500);
  }
  延迟(config.永恒轮回引导秒 * 1000, function 菲尼克斯尔永恒轮回结算(this: void): void {
    let aliveEggs = 0;
    for (let i = 0; i < context.凤凰蛋列表.length; i++) {
      if (单位存活(context.凤凰蛋列表[i].单位)) aliveEggs += 1;
    }
    if (aliveEggs > 0) {
      播放Boss坐标音效(菲尼克斯尔音效配置.永恒轮回.失败结算, 取单位X(context.Boss), 取单位Y(context.Boss), 菲尼克斯尔音效配置.默认裁断距离);
      const heal = 取最大生命(context.Boss) * config.每枚存活凤凰蛋回血Boss最大生命比例 * aliveEggs;
      let nextLife = 取当前生命(context.Boss) + heal;
      if (nextLife > 取最大生命(context.Boss)) nextLife = 取最大生命(context.Boss);
      设置当前生命(context.Boss, nextLife);
      const heroes = 取菲尼克斯尔玩家英雄列表();
      for (let i = 0; i < heroes.length; i++) {
        造成暗火伤害(context.Boss, heroes[i], 计算攻击最大生命伤害(context.Boss, heroes[i], config.轮回失败全场伤害Boss攻击力比例, config.轮回失败全场伤害目标最大生命比例), "AOE", 伤害上下文);
      }
      清理菲尼克斯尔凤凰蛋(context);
      context.当前形态 = "第二形态";
      context.永恒轮回已触发 = false;
    } else {
      清理菲尼克斯尔凤凰蛋(context);
      KillUnit(context.Boss);
    }
    播放点特效(菲尼克斯尔数值与表现配置.特效.永恒轮回收拢, 取单位X(context.Boss), 取单位Y(context.Boss), 2000);
  });
}

export function 初始化菲尼克斯尔永恒轮回节点(this: void, context: 菲尼克斯尔运行时上下文): void {
  const timerId = 周期(500, function 菲尼克斯尔永恒轮回检测(this: void): void {
    if (!单位存活(context.Boss)) {
      停止周期(timerId);
      return;
    }
    if (取当前生命(context.Boss) <= 取最大生命(context.Boss) * 菲尼克斯尔数值与表现配置.机制.永恒轮回触发生命比例) {
      触发菲尼克斯尔永恒轮回(context);
    }
  });
  context.清理.登记周期回调("菲尼克斯尔-永恒轮回检测", timerId);
}

export function 注册菲尼克斯尔永恒轮回(this: void): void {
  // 第二形态低生命机制，由转阶段时初始化。
}

