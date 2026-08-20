/** @noSelfInFile */

import { 八云紫单位技能配置 } from "../00．配置";
import { 八云紫单位存活, 是八云紫, 是八云紫合法敌人, 创建八云紫临时裂隙, 创建八云紫点特效 } from "../07．公共与单位壳/01．裂隙系统";
import { 发射八云紫弹幕 } from "../02．Q技能/01．波与粒的境界";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 播放八云紫随机单位音效 } from "../00A．表现工具";

const jass = require("jass.common") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 读取单位攻击力, 两点角度, 极坐标X, 极坐标Y } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  极坐标X: (this: void, x: number, angleDeg: number, distance: number) => number;
  极坐标Y: (this: void, y: number, angleDeg: number, distance: number) => number;
};
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};

const 配置 = 八云紫单位技能配置;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

interface W上下文 {
  英雄: any;
  裂隙: any[];
  目标单位: any;
  目标X: number;
  目标Y: number;
  技能实例ID?: number;
}

interface W发射参数 {
  上下文: W上下文;
  波次: number;
}

function 获取W上下文(this: void, hero: any): { 英雄: any } | undefined {
  return 是八云紫(hero) ? { 英雄: hero } : undefined;
}

function 发射W一波(this: void, variable?: any): void {
  const data = variable as W发射参数 | undefined;
  if (data == null || !八云紫单位存活(data.上下文.英雄)) return;
  const context = data.上下文;
  for (let i = 0; i < context.裂隙.length; i++) {
    const gap = context.裂隙[i];
    if (!八云紫单位存活(gap)) continue;
    const x = jass.GetUnitX(gap);
    const y = jass.GetUnitY(gap);
    const hasTarget = 八云紫单位存活(context.目标单位);
    const targetX = hasTarget ? jass.GetUnitX(context.目标单位) : context.目标X;
    const targetY = hasTarget ? jass.GetUnitY(context.目标单位) : context.目标Y;
    发射八云紫弹幕({
      施法者: context.英雄,
      X: x,
      Y: y,
      方向角: 两点角度(x, y, targetX, targetY),
      速度: 配置.Q.普通速度,
      高度: hasTarget ? 配置.Q.强化高度 : 配置.Q.普通高度,
      缩放: hasTarget ? 配置.Q.强化缩放 : 配置.Q.普通缩放,
      命中半径: hasTarget ? 配置.Q.强化半径 : 配置.Q.普通半径,
      伤害攻击力比例: 配置.W.普通伤害攻击力比例,
      技能ID: 配置.技能.W.类型ID,
      技能实例ID: context.技能实例ID,
      普通弹幕: !hasTarget,
      最短飞行距离: hasTarget ? 配置.Q.强化最短飞行距离 : 0,
    });
  }
}

function 结算W指定目标(this: void, variable?: any): void {
  const context = variable as W上下文 | undefined;
  if (context == null || !八云紫单位存活(context.英雄) || !八云紫单位存活(context.目标单位)) return;
  const target = context.目标单位;
  const targetX = jass.GetUnitX(target);
  const targetY = jass.GetUnitY(target);
  const 缺失生命 = jass.GetUnitState(target, UNIT_STATE_MAX_LIFE) - jass.GetUnitState(target, UNIT_STATE_LIFE);
  const missingLife = 缺失生命 > 0 ? 缺失生命 : 0;
  造成单体技能伤害({
    来源: context.英雄,
    目标: target,
    伤害: missingLife * 配置.W.指定目标已损失生命比例,
    伤害类型: DAMAGE_TYPE_MIND,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 配置.技能.W.类型ID,
    技能实例ID: context.技能实例ID,
    标签: "八云紫-W-指定目标精神伤害",
  });
  const enemies = getEnemyUnitsInRange(context.英雄, targetX, targetY, 配置.W.周围伤害范围);
  const damage = 读取单位攻击力(context.英雄) * 配置.W.周围伤害攻击力比例;
  for (let i = 0; i < enemies.length; i++) {
    const enemy = enemies[i];
    if (enemy === target || !是八云紫合法敌人(context.英雄, enemy)) continue;
    造成单体技能伤害({
      来源: context.英雄,
      目标: enemy,
      伤害: damage,
      伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: 配置.技能.W.类型ID,
      技能实例ID: context.技能实例ID,
      标签: "八云紫-W-周围暗魔法伤害",
      参与技能伤害加成: true,
    });
  }
  创建八云紫点特效(配置.W.结算特效, targetX, targetY, 1.5, 1, 配置.W.结算特效高度);
}

function 释放W(this: void, _entry: { 英雄: any }, hero: any, skillInstanceId?: number): void {
  const target = jass.GetSpellTargetUnit();
  const targetX = jass.GetSpellTargetX();
  const targetY = jass.GetSpellTargetY();
  const context: W上下文 = {
    英雄: hero,
    裂隙: [],
    目标单位: target,
    目标X: targetX,
    目标Y: targetY,
    技能实例ID: skillInstanceId,
  };

  if (target != null && target !== 0 && 是八云紫合法敌人(hero, target)) {
    播放八云紫随机单位音效(hero, 配置.W.指定目标语音键);
    for (let i = 0; i < 配置.W.裂隙数量; i++) {
      const angle = 45 + 90 * (i + 1);
      context.裂隙.push(创建八云紫临时裂隙(
        hero,
        极坐标X(targetX, angle, 配置.W.指定目标裂隙半径),
        极坐标Y(targetY, angle, 配置.W.指定目标裂隙半径),
        配置.W.裂隙持续秒 + 配置.W.裂隙清理宽限秒,
      ));
    }
  } else {
    播放八云紫随机单位音效(hero, 配置.W.无目标语音键);
    const heroX = jass.GetUnitX(hero);
    const heroY = jass.GetUnitY(hero);
    const angle = 两点角度(heroX, heroY, targetX, targetY);
    // 后方点 = 施法方向反向 180 度；横向 = 施法方向侧向 90 度；循环内沿侧向反向递减
    const backX = 极坐标X(heroX, angle + 180, 配置.W.无目标后方距离);
    const backY = 极坐标Y(heroY, angle + 180, 配置.W.无目标后方距离);
    const firstX = 极坐标X(backX, angle + 90, 配置.W.横向起点距离);
    const firstY = 极坐标Y(backY, angle + 90, 配置.W.横向起点距离);
    for (let i = 1; i <= 配置.W.裂隙数量; i++) {
      context.裂隙.push(创建八云紫临时裂隙(
        hero,
        极坐标X(firstX, angle + 90, -(配置.W.横向间距 * i)),
        极坐标Y(firstY, angle + 90, -(配置.W.横向间距 * i)),
        配置.W.裂隙持续秒 + 配置.W.裂隙清理宽限秒,
      ));
    }
  }

  for (let wave = 1; wave <= 配置.W.每裂隙弹幕数; wave++) {
    addDelayedCallback(wave * 配置.W.发射间隔秒 * 1000, 发射W一波, { 上下文: context, 波次: wave } as W发射参数);
  }
  if (target != null && target !== 0 && 是八云紫合法敌人(hero, target)) {
    addDelayedCallback((配置.W.每裂隙弹幕数 + 1) * 配置.W.发射间隔秒 * 1000, 结算W指定目标, context);
  }
}

注册单位技能壳监听({
  名称: "八云紫-飞光虫之巢（W）",
  单位类型ID: 配置.单位.英雄类型ID,
  技能ID: 配置.技能.W.类型ID,
  获取或创建上下文: 获取W上下文,
  释放技能: 释放W,
  创建独立技能实例: true,
  独立技能来源类型: "单位技能",
  技能实例持续时间秒: 5,
});

export {};
