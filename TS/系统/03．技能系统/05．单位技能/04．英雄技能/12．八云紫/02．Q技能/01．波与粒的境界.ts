/** @noSelfInFile */

import { 八云紫单位技能配置 } from "../00．配置";
import {
  八云紫单位存活,
  是八云紫,
  是八云紫合法敌人,
  查找八云紫裂隙,
  获取范围内八云紫裂隙,
  注册八云紫裂隙扩散发射器,
  触发八云紫裂隙扩散,
  创建八云紫点特效,
  type 八云紫裂隙记录,
} from "../07．公共与单位壳/01．裂隙系统";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 播放八云紫单位音效, 播放八云紫随机单位音效 } from "../00A．表现工具";

const jass = require("jass.common") as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 极坐标X, 极坐标Y } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  极坐标X: (this: void, x: number, angleDeg: number, distance: number) => number;
  极坐标Y: (this: void, y: number, angleDeg: number, distance: number) => number;
};
const { 创建原生弹幕, 获取原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, params: any) => any;
  获取原生弹幕: (this: void, projectileId: number) => any;
};
const { 读取单位攻击力, 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};

const 配置 = 八云紫单位技能配置;
const Q暂停来源 = "八云紫-Q-波与粒的境界";
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

export interface 八云紫弹幕选项 {
  施法者: any;
  X: number;
  Y: number;
  方向角: number;
  速度: number;
  高度: number;
  缩放: number;
  命中半径: number;
  伤害攻击力比例: number;
  技能ID: number;
  技能实例ID?: number;
  普通弹幕: boolean;
  最短飞行距离?: number;
  最大距离?: number;
}

interface 弹幕上下文 {
  施法者: any;
  普通弹幕: boolean;
  最终命中半径: number;
  最短飞行距离: number;
  已触发裂隙: Record<number, boolean | undefined>;
  已记录追踪: boolean;
}

const 弹幕上下文表: Record<number, 弹幕上下文 | undefined> = {};

function 弹幕结束(this: void, _reason: any, projectileId: number): void {
  delete 弹幕上下文表[projectileId];
}

function 弹幕目标筛选(this: void, target: any, projectileId: number): boolean {
  const context = 弹幕上下文表[projectileId];
  return context != null && 是八云紫合法敌人(context.施法者, target);
}

function 弹幕Tick(this: void, instance: any, _delta: number): void {
  const context = 弹幕上下文表[instance.id];
  if (context == null) return;
  if (instance.已飞行距离 >= context.最短飞行距离 && instance.参数.命中半径 !== context.最终命中半径) {
    instance.参数.命中半径 = context.最终命中半径;
  }
  if (!context.普通弹幕) return;

  const nearby = 获取范围内八云紫裂隙(instance.当前X, instance.当前Y, 配置.Q.自动追踪裂隙范围, context.施法者);
  if (nearby.length > 0) {
    const targetGap = nearby[0];
    if (!context.已记录追踪) {
      context.已记录追踪 = true;
    }
    instance.当前方向角 = 两点角度(
      instance.当前X,
      instance.当前Y,
      jass.GetUnitX(targetGap.单位),
      jass.GetUnitY(targetGap.单位),
    );
  }

  const touched = 查找八云紫裂隙(instance.当前X, instance.当前Y, 配置.裂隙.扩散触发半径, context.施法者);
  if (touched == null) return;
  const gapId = jass.GetHandleId(touched.单位);
  if (context.已触发裂隙[gapId] === true) return;
  context.已触发裂隙[gapId] = true;
  播放八云紫单位音效(context.施法者, 配置.Q.裂隙触发音效键);
  触发八云紫裂隙扩散(context.施法者, touched);
}

export function 发射八云紫弹幕(this: void, options: 八云紫弹幕选项): number {
  const minDistance = options.最短飞行距离 ?? 0;
  const instance = 创建原生弹幕({
    所有者: options.施法者,
    X: options.X,
    Y: options.Y,
    方向角: options.方向角,
    速度: options.速度,
    最大距离: options.最大距离 ?? 配置.Q.飞行距离,
    生命周期: 配置.Q.生命周期秒,
    命中半径: minDistance > 0 ? 0 : options.命中半径,
    影响目标: "敌方",
    碰撞消失: false,
    每单位最大命中次数: 1,
    伤害值: 读取单位攻击力(options.施法者) * options.伤害攻击力比例,
    伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: options.技能ID,
    技能实例ID: options.技能实例ID,
    技能标签: options.普通弹幕 ? "八云紫-普通弹幕" : "八云紫-强化弹幕",
    伤害形态: "AOE",
    参与技能伤害加成: true,
    模型: 配置.Q.模型,
    缩放: options.缩放,
    飞行高度: options.高度,
    显式改向后锁定方向: true,
    目标筛选: 弹幕目标筛选,
    onTick: 弹幕Tick,
    on结束: 弹幕结束,
  });
  if (instance == null) return 0;
  弹幕上下文表[instance.弹幕ID] = {
    施法者: options.施法者,
    普通弹幕: options.普通弹幕,
    最终命中半径: options.命中半径,
    最短飞行距离: minDistance,
    已触发裂隙: {},
    已记录追踪: false,
  };
  return instance.弹幕ID;
}

function 发射六向强化弹幕(this: void, hero: any, gap: 八云紫裂隙记录): void {
  const x = jass.GetUnitX(gap.单位);
  const y = jass.GetUnitY(gap.单位);
  创建八云紫点特效("war3mapImported\\ancientexplodeblue.mdx", x, y, 2, 1);
  for (let i = 0; i < 6; i++) {
    发射八云紫弹幕({
      施法者: hero,
      X: x,
      Y: y,
      方向角: 60 * (i + 1),
      速度: 配置.Q.强化速度,
      高度: 配置.Q.普通高度,
      缩放: 配置.Q.强化缩放,
      命中半径: 配置.Q.强化半径,
      伤害攻击力比例: 配置.Q.基础伤害攻击力比例 * 配置.Q.裂隙扩散倍率,
      技能ID: 配置.技能.Q.类型ID,
      普通弹幕: false,
      最短飞行距离: 配置.Q.强化最短飞行距离,
    });
  }
}

interface 裂隙波参数 {
  英雄: any;
  裂隙: 八云紫裂隙记录;
  技能实例ID?: number;
}

function 发射指定裂隙波(this: void, variable?: any): void {
  const data = variable as 裂隙波参数 | undefined;
  if (data == null || !八云紫单位存活(data.英雄) || data.裂隙.已结束) return;
  const x = jass.GetUnitX(data.裂隙.单位);
  const y = jass.GetUnitY(data.裂隙.单位);
  播放八云紫单位音效(data.英雄, 配置.Q.裂隙爆发音效键, true);
  创建八云紫点特效("war3mapImported\\ancientexplodeblue.mdx", x, y, 2, 1);
  for (let i = 0; i < 6; i++) {
    发射八云紫弹幕({
      施法者: data.英雄,
      X: x,
      Y: y,
      方向角: 60 * (i + 1),
      速度: 配置.Q.强化速度,
      高度: 配置.Q.强化高度,
      缩放: 配置.Q.强化缩放,
      命中半径: 配置.Q.指定裂隙强化半径,
      伤害攻击力比例: 配置.Q.基础伤害攻击力比例 * 配置.Q.指定裂隙倍率,
      技能ID: 配置.技能.Q.类型ID,
      技能实例ID: data.技能实例ID,
      普通弹幕: false,
      最短飞行距离: 配置.Q.强化最短飞行距离,
    });
  }
}

function 解除Q硬直(this: void, variable?: any): void {
  const hero = variable as any;
  if (hero != null && hero !== 0) 移除单位暂停(hero, Q暂停来源);
}

function 获取Q上下文(this: void, hero: any): { 英雄: any } | undefined {
  return 是八云紫(hero) ? { 英雄: hero } : undefined;
}

function 释放Q(this: void, _context: { 英雄: any }, hero: any, skillInstanceId?: number): void {
  const heroX = jass.GetUnitX(hero);
  const heroY = jass.GetUnitY(hero);
  const targetX = jass.GetSpellTargetX();
  const targetY = jass.GetSpellTargetY();
  const targetGap = 查找八云紫裂隙(targetX, targetY, 100, hero);

  添加单位暂停(hero, Q暂停来源);
  jass.SetUnitAnimation(hero, "attack,2");
  addDelayedCallback(配置.Q.硬直秒 * 1000, 解除Q硬直, hero);

  if (targetGap != null) {
    播放八云紫随机单位音效(hero, 配置.Q.指定裂隙语音键);
    for (let i = 1; i <= 配置.Q.指定裂隙波数; i++) {
      addDelayedCallback(i * 配置.Q.指定裂隙波间隔秒 * 1000, 发射指定裂隙波, {
        英雄: hero,
        裂隙: targetGap,
        技能实例ID: skillInstanceId,
      } as 裂隙波参数);
    }
    return;
  }

  播放八云紫单位音效(hero, 配置.Q.普通起手音效键);
  播放八云紫随机单位音效(hero, 配置.Q.普通语音键);
  const baseAngle = 两点角度(heroX, heroY, targetX, targetY);
  for (let i = 0; i < 配置.Q.普通弹幕数量; i++) {
    const angle = baseAngle + 配置.Q.普通角度偏移[i];
    const distance = 配置.Q.普通创建距离[i];
    发射八云紫弹幕({
      施法者: hero,
      X: 极坐标X(heroX, angle, distance),
      Y: 极坐标Y(heroY, angle, distance),
      方向角: angle,
      速度: 配置.Q.普通速度,
      高度: 配置.Q.普通高度,
      缩放: 配置.Q.普通缩放,
      命中半径: 配置.Q.普通半径,
      伤害攻击力比例: 配置.Q.基础伤害攻击力比例,
      技能ID: 配置.技能.Q.类型ID,
      技能实例ID: skillInstanceId,
      普通弹幕: true,
    });
  }
}

注册八云紫裂隙扩散发射器(发射六向强化弹幕);
注册单位技能壳监听({
  名称: "八云紫-波与粒的境界（Q）",
  单位类型ID: 配置.单位.英雄类型ID,
  技能ID: 配置.技能.Q.类型ID,
  获取或创建上下文: 获取Q上下文,
  释放技能: 释放Q,
  创建独立技能实例: true,
  独立技能来源类型: "单位技能",
  技能实例持续时间秒: 5,
});

export {};
