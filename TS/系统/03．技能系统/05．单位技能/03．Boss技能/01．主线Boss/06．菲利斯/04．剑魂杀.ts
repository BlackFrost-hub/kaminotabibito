/** @noSelfInFile */

import { 菲利斯单位技能配置 } from "./00．配置";
import { 登记菲利斯剑魂狼, 获取或创建菲利斯上下文, 获取菲利斯剑魂狼记录, 注销菲利斯剑魂狼, 菲利斯运行时上下文 } from "./01．运行时上下文";
import { 菲利斯数值与表现配置, 菲利斯音效配置 } from "./02．数值与表现配置";
import { 播放菲利斯台词 } from "./08．台词播放";
import { 单位有效, stringToFourCC, 取单位间角度, 极坐标X, 极坐标Y } from "./11．公共工具";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 执行BossAOE技能伤害, 执行Boss单体技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
import { 创建原生弹幕, 创建直线定点轨迹 } from "../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;
const SetUnitMoveSpeed = jass.SetUnitMoveSpeed as (unit: any, speed: number) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建固定受击次数机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.03．固定受击次数机制单位") as {
  创建固定受击次数机制单位: (this: void, 参数: any) => any;
};
const { 登记召唤物攻击恢复主人, 注销召唤物攻击恢复主人 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.index") as {
  登记召唤物攻击恢复主人: (this: void, 参数: any) => void;
  注销召唤物攻击恢复主人: (this: void, 召唤单位: any) => void;
};
const { 获取Boss技能最近敌对英雄Ex, 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能最近敌对英雄Ex: (this: void, boss: any, centerUnit?: any, radius?: number) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 菲利斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.05．菲利斯") as {
  菲利斯BuffID: { 剑魂狼印: string };
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};

const 菲利斯单位类型ID = stringToFourCC(菲利斯单位技能配置.单位ID);
const 剑魂杀技能ID = stringToFourCC(菲利斯数值与表现配置.剑魂杀.技能槽位);
let 剑魂杀已注册 = false;
let 剑魂狼攻击监听已注册 = false;

interface 剑魂路径 {
  起点X: number;
  起点Y: number;
  终点X: number;
  终点Y: number;
  朝向: number;
}

function 增加Boss魔法充能(this: void, context: 菲利斯运行时上下文, amount: number): void {
  context.当前魔法充能 += amount;
  if (context.当前魔法充能 > 菲利斯数值与表现配置.异形化.魔法阈值) {
    context.当前魔法充能 = 菲利斯数值与表现配置.异形化.魔法阈值;
  }
}

function 取目标(this: void, boss: any): any {
  const spellTarget = GetSpellTargetUnit();
  if (单位有效(spellTarget)) return spellTarget;
  return 获取Boss技能最近敌对英雄Ex(boss, boss, 菲利斯数值与表现配置.剑魂杀.路径距离 + 400);
}

function 创建路径(this: void, boss: any, target: any): 剑魂路径[] {
  const cfg = 菲利斯数值与表现配置.剑魂杀;
  const targetAngle = 取单位间角度(boss, target);
  const halfDistance = cfg.路径距离 * 0.5;
  // 路径以菲利斯为起点向正面展开，不再以被选目标坐标为交叉中心。
  const centerX = 极坐标X(GetUnitX(boss), targetAngle, halfDistance);
  const centerY = 极坐标Y(GetUnitY(boss), targetAngle, halfDistance);
  const paths: 剑魂路径[] = [];
  for (let i = 0; i < cfg.剑气数量; i++) {
    const side = (i === 0 ? 1 : -1) * cfg.路径交叉角度 * 0.5;
    const pathAngle = targetAngle + side;
    const sx = 极坐标X(centerX, pathAngle + 180, halfDistance);
    const sy = 极坐标Y(centerY, pathAngle + 180, halfDistance);
    paths.push({
      起点X: sx,
      起点Y: sy,
      终点X: 极坐标X(centerX, pathAngle, halfDistance),
      终点Y: 极坐标Y(centerY, pathAngle, halfDistance),
      朝向: pathAngle,
    });
    创建技能提示圈({
      类型: "矩形",
      X: sx,
      Y: sy,
      宽度: cfg.路径宽度,
      长度: cfg.路径距离,
      朝向: pathAngle,
      持续时间: cfg.前摇秒,
      来源单位: boss,
    });
  }
  return paths;
}

function 生成剑魂狼(this: void, context: 菲利斯运行时上下文, x: number, y: number, big: boolean): void {
  const boss = context.Boss单位;
  const cfg = 菲利斯数值与表现配置.剑魂杀;
  const hitPoints = big ? cfg.大狼生命点 : cfg.小狼生命点;
  创建点特效({ 模型路径: cfg.召唤爆点特效路径, X: x, Y: y, 持续秒: cfg.召唤爆点持续秒 });
  const wolf = 创建固定受击次数机制单位({
    清理: context.清理,
    名称: big ? "菲利斯-大剑魂狼" : "菲利斯-小剑魂狼",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: big ? cfg.大狼单位类型 : cfg.小狼单位类型,
    X: x,
    Y: y,
    最大生命: 999999,
    受击次数: hitPoints,
    计数模式: "纯普攻或最终伤害阈值",
    最终伤害计数阈值: 1000,
    未计数伤害无效: true,
    同步生命条: true,
    缩放: big ? cfg.大狼缩放 : cfg.小狼缩放,
    持续时间: cfg.狼持续秒,
    on死亡: function 菲利斯剑魂狼死亡(this: void, unit: any): void {
      注销菲利斯剑魂狼(unit);
      注销召唤物攻击恢复主人(unit);
    },
    on销毁: function 菲利斯剑魂狼销毁(this: void, unit: any): void {
      注销菲利斯剑魂狼(unit);
      注销召唤物攻击恢复主人(unit);
    },
  });
  if (wolf == null) return;
  播放Boss坐标音效(
    big ? 菲利斯音效配置.剑魂杀.大狼合并 : 菲利斯音效配置.剑魂杀.小狼成形,
    x,
    y,
    菲利斯音效配置.默认裁断距离,
  );
  登记菲利斯剑魂狼(wolf.单位, {
    Boss单位: boss,
    大狼: big,
    伤害比例: big ? cfg.大狼目标最大生命伤害比例 : cfg.小狼目标最大生命伤害比例,
  });
  登记召唤物攻击恢复主人({
    召唤单位: wolf.单位,
    主人单位: boss,
    要求实际造成伤害: false,
    主人最大生命恢复比例: cfg.异形化狼攻击回血Boss最大生命比例,
    主人最大魔法恢复比例: cfg.狼攻击回魔Boss最大魔法比例,
    显示生命恢复特效: true,
    生命恢复条件: function 菲利斯剑魂狼异形化回血条件(this: void): boolean {
      return context.异形化中;
    },
    on触发: function 菲利斯剑魂狼恢复触发(this: void, result: any): void {
      增加Boss魔法充能(context, result.请求魔法恢复);
    },
  });
  SetUnitMoveSpeed(wolf.单位, cfg.狼移动速度);
  const target = 获取Boss技能最近敌对英雄Ex(boss, wolf.单位, cfg.狼攻击索敌范围);
  if (单位有效(target)) IssueTargetOrder(wolf.单位, "attack", target);
}

function 销毁剑魂路径弹幕(this: void, 弹幕: any): void {
  if (弹幕 != null && 弹幕.销毁 != null) 弹幕.销毁("手动销毁");
}

function 菲利斯剑魂路径目标允许(this: void, boss: any, unit: any): boolean {
  if (!单位有效(unit)) return false;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    if (heroes[i] === unit) return true;
  }
  return false;
}

function 执行剑魂路径(this: void, context: 菲利斯运行时上下文, paths: 剑魂路径[]): void {
  const boss = context.Boss单位;
  const cfg = 菲利斯数值与表现配置.剑魂杀;
  播放Boss坐标音效(菲利斯音效配置.剑魂杀.路径释放, GetUnitX(boss), GetUnitY(boss), 菲利斯音效配置.默认裁断距离);
  let hitCount = 0;
  let 完成路径数 = 0;
  let 已生成剑魂狼 = false;
  function 处理路径到达(this: void): void {
    if (!单位有效(boss) || context.清理.已清理()) return;
    完成路径数 += 1;
    if (已生成剑魂狼 || 完成路径数 < paths.length) return;
    已生成剑魂狼 = true;
    if (hitCount >= cfg.合并命中次数) {
      const x = (paths[0].终点X + paths[1].终点X) * 0.5;
      const y = (paths[0].终点Y + paths[1].终点Y) * 0.5;
      生成剑魂狼(context, x, y, true);
      return;
    }
    for (let i = 0; i < paths.length; i++) 生成剑魂狼(context, paths[i].终点X, paths[i].终点Y, false);
  }
  for (let i = 0; i < paths.length; i++) {
    const path = paths[i];
    let trailElapsedMs = 0;
    const projectile = 创建原生弹幕({
      所有者: boss,
      载体模式: "特效",
      X: path.起点X,
      Y: path.起点Y,
      方向角: path.朝向,
      速度: cfg.路径距离 / cfg.飞行持续秒,
      生命周期: cfg.飞行持续秒,
      最大距离: cfg.路径距离,
      轨迹采样器: 创建直线定点轨迹(path.起点X, path.起点Y, path.终点X, path.终点Y),
      命中半径: cfg.命中半径,
      影响目标: "敌方",
      每单位最大命中次数: 1,
      碰撞消失: false,
      禁用碰撞: true,
      附加特效1: {
        模型: cfg.小狼奔跑特效路径,
        跟随主弹幕参数: true,
        缩放: cfg.小狼奔跑特效缩放,
        动画名称: cfg.小狼奔跑动画名,
        动画速度: cfg.小狼奔跑动画速度,
      },
      目标筛选: function 菲利斯剑魂路径目标筛选(this: void, unit: any): boolean {
        return 菲利斯剑魂路径目标允许(boss, unit);
      },
      onTick: function 菲利斯剑魂路径表现Tick(this: void, instance: any, delta: number): void {
        if (!单位有效(boss) || context.清理.已清理()) return;
        trailElapsedMs += delta * 1000;
        if (trailElapsedMs < cfg.Tick间隔毫秒) return;
        trailElapsedMs = 0;
        创建点特效({ 模型路径: cfg.狼魂路径特效路径, X: instance.当前X, Y: instance.当前Y, 缩放: cfg.狼魂路径特效缩放, 持续秒: cfg.狼魂路径特效持续秒 });
      },
      on命中: function 菲利斯剑魂路径命中(this: void, hero: any): void {
        if (!单位有效(hero)) return;
        hitCount += 1;
        registerManualBuff(hero, 菲利斯BuffID.剑魂狼印, 4, 1, { sourceName: "菲利斯-剑魂杀" });
        执行BossAOE技能伤害({
          技能ID: 剑魂杀技能ID,
          来源: boss,
          目标: hero,
          伤害公式: { 来源攻击力比例: cfg.路径伤害Boss攻击力比例 },
          attack: false,
          ranged: false,
          attackType: ATTACK_TYPE_NORMAL,
          伤害类型: DAMAGE_TYPE_NORMAL,
          weaponType: WEAPON_TYPE_WHOKNOWS,
        });
      },
      on到达目标点: function 菲利斯剑魂路径到达终点(this: void): void {
        处理路径到达();
      },
    });
    context.清理.登记清理("菲利斯-剑魂杀路径弹幕", 销毁剑魂路径弹幕, projectile);
  }
}

export function 释放菲利斯剑魂杀(this: void, context: 菲利斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const target = 取目标(boss);
  if (!单位有效(target)) return;
  const cfg = 菲利斯数值与表现配置.剑魂杀;
  const paths = 创建路径(boss, target);
  启动基础施法时间线({
    施法者: boss,
    目标单位: target,
    硬直秒: cfg.前摇秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.前摇秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
      提示文本: cfg.吟唱条提示文本,
    },
    播放台词: function 菲利斯剑魂杀台词(this: void): void {
      播放菲利斯台词(boss, "剑魂杀");
    },
    on生效: function 菲利斯剑魂杀生效(this: void): void {
      执行剑魂路径(context, paths);
    },
  });
}

function on剑魂狼最终伤害(this: void, target: any, _attacker: any, _applied: number, snapshot: any): void {
  if (snapshot == null || snapshot.isNormalAttack !== true) return;
  const wolf = snapshot.originalAttacker;
  const record = 获取菲利斯剑魂狼记录(wolf);
  if (record == null || !单位有效(record.Boss单位) || !单位有效(target)) return;
  执行Boss单体技能伤害({
    技能ID: 剑魂杀技能ID,
    来源: record.Boss单位,
    目标: target,
    伤害公式: { 目标最大生命比例: record.伤害比例 },
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: "菲利斯·剑魂狼攻击",
  });
}

export function 注册菲利斯剑魂杀(this: void): void {
  if (!剑魂狼攻击监听已注册) {
    剑魂狼攻击监听已注册 = true;
    registerAppliedFinalDamageListener(on剑魂狼最终伤害);
  }
  if (剑魂杀已注册) return;
  剑魂杀已注册 = true;
  注册单位技能壳监听({
    名称: "04．剑魂杀",
    单位类型ID: 菲利斯单位类型ID,
    技能ID: 剑魂杀技能ID,
    获取或创建上下文: 获取或创建菲利斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 菲利斯运行时上下文, boss: any): void {
      on菲利斯剑魂杀生效(boss, 剑魂杀技能ID);
    },
  });
}

function on菲利斯剑魂杀生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 剑魂杀技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 菲利斯单位类型ID) return;
  const context = 获取或创建菲利斯上下文(castingUnit);
  if (context == null) return;
  释放菲利斯剑魂杀(context);
}
