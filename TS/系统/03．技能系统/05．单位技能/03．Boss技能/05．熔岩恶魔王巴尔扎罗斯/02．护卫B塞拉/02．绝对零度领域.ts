/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "../03．运行时上下文";
import { 塞拉公共 } from "./00．公共";
const {  巴尔扎罗斯技能数值配置,
  播放巴尔扎罗斯台词,
  减少巴尔扎罗斯灼热层数,
  启动基础施法时间线,
  创建技能提示圈,
  获取Boss技能敌对英雄列表,
  创建循环点特效,
  停止循环点特效,
  addPeriodicCallback,
  removePeriodicCallback,
  getServerTime,
  GetUnitX,
  GetUnitY,
  单位有效,
  取单位ID,
  点在圆内,
  计算冰焰目标位置,
  零度领域减伤到期Ms表,
  绝对零度领域状态表,
} = 塞拉公共;

function 创建绝对零度领域(this: void, context: 巴尔扎罗斯运行时上下文, x: number, y: number): void {
  const sera = context.塞拉;
  if (!单位有效(sera)) return;
  const config = 巴尔扎罗斯技能数值配置.绝对零度领域;
  const seraId = 取单位ID(sera);
  const endMs = getServerTime() + config.持续秒 * 1000;
  绝对零度领域状态表[seraId] = { X: x, Y: y, 结束Ms: endMs };
  const effectHandle = 创建循环点特效({
    模型路径: config.特效路径,
    X: x,
    Y: y,
    Z: config.特效高度,
    缩放: config.特效缩放,
    重建间隔秒: config.特效重建间隔秒,
    总持续秒: config.持续秒,
    存活条件: function 塞拉绝对零度特效存活(this: void): boolean {
      return 单位有效(sera);
    },
  });
  context.清理.登记清理("塞拉-绝对零度领域特效", function 塞拉绝对零度领域特效清理(this: void): void {
    停止循环点特效(effectHandle);
  });

  const nextClear: Record<number, number | undefined> = {};
  const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (单位有效(hero) && 点在圆内(GetUnitX(hero), GetUnitY(hero), x, y, config.半径)) {
      减少巴尔扎罗斯灼热层数(hero, config.生成清除灼热层数);
    }
  }

  const tickId = addPeriodicCallback(config.Tick毫秒, function 塞拉绝对零度领域Tick(this: void): void {
    const now = getServerTime();
    if (now >= endMs || !单位有效(sera)) {
      removePeriodicCallback(tickId);
      delete 绝对零度领域状态表[seraId];
      return;
    }
    const list = 获取Boss技能敌对英雄列表(context.Boss单位);
    for (let i = 0; i < list.length; i++) {
      const hero = list[i];
      if (!单位有效(hero)) continue;
      if (!点在圆内(GetUnitX(hero), GetUnitY(hero), x, y, config.半径)) continue;
      const heroId = 取单位ID(hero);
      零度领域减伤到期Ms表[heroId] = now + config.离开后减伤持续秒 * 1000;
      if (now >= (nextClear[heroId] ?? 0)) {
        减少巴尔扎罗斯灼热层数(hero, config.周期清除灼热层数);
        nextClear[heroId] = now + config.清层周期秒 * 1000;
      }
    }
  });
  context.清理.登记周期回调("塞拉-绝对零度领域Tick", tickId);
}

export function 释放绝对零度领域(this: void, context: 巴尔扎罗斯运行时上下文, target: any): void {
  const sera = context.塞拉;
  if (!单位有效(sera)) return;
  const config = 巴尔扎罗斯技能数值配置.绝对零度领域;
  const center = 计算冰焰目标位置(context, target);
  创建技能提示圈({
    类型: "白色安全圆",
    X: center.X,
    Y: center.Y,
    半径: config.半径,
    持续时间: config.施法硬直秒,
  });
  启动基础施法时间线({
    施法者: sera,
    目标X: center.X,
    目标Y: center.Y,
    硬直秒: config.施法硬直秒,
    动画编号: config.动画编号,
    动画速度: config.动画速度,
    吟唱条: {
      通道: "场地常驻AOE",
      总时长: config.施法硬直秒,
      颜色ID: config.吟唱条颜色ID,
      标题文本: config.吟唱条标题文本,
      提示文本: config.吟唱条提示文本,
    },
    播放台词: function 塞拉绝对零度领域台词(this: void): void {
      播放巴尔扎罗斯台词(context.Boss单位, "绝对零度领域");
    },
    on生效: function 塞拉绝对零度领域生效(this: void): void {
      创建绝对零度领域(context, center.X, center.Y);
    },
  });
}

