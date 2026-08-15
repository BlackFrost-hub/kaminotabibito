/** @noSelfInFile */

/**
 * 铃仙 - Q：幻觉冲击波（A0GK）
 *
 * 源 JASS：`铃仙.j` 的 ReisenQ 分支。
 *
 * 逻辑：
 * - 施法后本体沿施法方向发射精神波（TS 原生弹幕，直线飞行、命中半径 165）。
 * - 伤害 = 攻击力 × 1.85，每个分身使伤害提高 15%。
 * - 命中目标减速 20% 持续 2 秒；命中英雄额外施加隐身 1 秒。
 * - 非英雄目标伤害 ×1.5；所有伤害为魔法伤害且 attack=true（攻击效果）。
 * - 每个目标整次 Q 只命中一次（命中记录表去重）。
 * - 分身模仿：播放动作 2 @1.8 倍速、施加眩晕 0.35 秒锁身（对应源 JASS YDWEUnitAddStun，到时自动解除）、
 *   在分身位置创建 pinkredlaser 特效。
 * - 命中时在弹幕当前坐标创建 pinkredlaser 特效（缩放 0.3、Z 200、1 秒后消失）。
 */

import { 铃仙单位技能配置 } from "./00．配置";
import { 铃仙BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/12．铃仙";
import { 播放铃仙配置动作 } from "./00A．表现工具";
import { 是铃仙本体, 铃仙分身数量, 获取铃仙分身组, 是有效敌对目标 } from "./00B．分身与状态管理";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { 施加减速, 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加减速: (this: void, 来源: any, 目标: any, 降低比例: number, 持续时间: number, 效果来源名称?: string, 效果来源类型?: "装备" | "技能") => void;
  施加眩晕: (this: void, 来源: any, 目标: any, 持续时间: number, 效果来源名称?: string, 效果来源类型?: "装备" | "技能") => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
};
const { 施加隐身 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.15．隐身.index") as {
  施加隐身: (this: void, 单位: any, 参数: {
    持续时间: number;
    来源单位?: any;
    破隐固定额外伤害?: number;
    破隐伤害倍率?: number;
    破隐额外暗属性伤害倍率?: number;
    技能伤害标记?: any;
  }) => number;
};
const { 创建原生弹幕, 获取原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, 参数: any) => any;
  获取原生弹幕: (this: void, 弹幕ID: number) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: {
    模型路径: string;
    X: number;
    Y: number;
    Z?: number;
    面向角度?: number;
    Z轴角度?: number;
    缩放?: number;
    持续秒?: number;
  }) => any;
};
const { 读取单位攻击力, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;

const Q技能ID = stringToFourCCSafe(铃仙单位技能配置.Q技能ID);

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;

function 两点角度(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return Math.atan2(y2 - y1, x2 - x1) * 180 / Math.PI;
}

//=============================================================================
// 一、分身模仿（源 JASS：Trig_L______ResenFunc001Func012Func002A）
//=============================================================================

function 铃仙Q分身模仿(this: void, 施法者: any, 分身: any): void {
  if (分身 == null || 分身 === 0 || !单位存活(分身)) return;
  const cfg = 铃仙单位技能配置.Q;

  // 播放分身模仿动作（动作 2、倍速 1.8）
  播放铃仙配置动作(分身, 2, 1.8);

  // 分身施法硬直：施加眩晕 0.35 秒锁身（对应源 JASS YDWEUnitAddStun，0.35 秒后到期自动解除）
  施加眩晕(施法者, 分身, 0.35, "铃仙Q分身模仿", "技能");

  // 分身特效：pinkredlaser
  创建点特效({
    模型路径: cfg.命中特效模型,
    X: GetUnitX(分身),
    Y: GetUnitY(分身),
    Z: cfg.分身特效Z,
    缩放: cfg.分身特效缩放,
    持续秒: cfg.分身特效时长,
  });
}

//=============================================================================
// 二、Q 施法主流程
//=============================================================================

function 铃仙Q命中特效(this: void, 弹幕ID: number, 目标: any): void {
  const cfg = 铃仙单位技能配置.Q;
  const 实例 = 获取原生弹幕(弹幕ID);
  let 特效X: number;
  let 特效Y: number;
  if (实例 != null) {
    特效X = 实例.当前X;
    特效Y = 实例.当前Y;
  } else if (目标 != null && 目标 !== 0) {
    特效X = GetUnitX(目标);
    特效Y = GetUnitY(目标);
  } else {
    return;
  }
  创建点特效({
    模型路径: cfg.命中特效模型,
    X: 特效X,
    Y: 特效Y,
    Z: cfg.命中特效Z,
    缩放: cfg.命中特效缩放,
    持续秒: cfg.命中特效时长,
  });
}

function on铃仙Q(this: void, 施法者: any, 技能ID数值: number): void {
  if (技能ID数值 !== Q技能ID) return;
  if (!是铃仙本体(施法者)) return;

  const cfg = 铃仙单位技能配置.Q;
  const 起点X = GetUnitX(施法者);
  const 起点Y = GetUnitY(施法者);
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 方向角 = 两点角度(起点X, 起点Y, 目标X, 目标Y);

  // 伤害 = 攻击力 × 1.85；每个分身使伤害提高 15%
  const 分身数量 = 铃仙分身数量(施法者);
  const 基础伤害 = 读取单位攻击力(施法者) * cfg.攻击力倍率 * (1 + cfg.每分身伤害加成 * 分身数量);

  // 分身模仿（每个存活分身播放动作 + 施法硬直 + 特效）
  const 分身组 = 获取铃仙分身组(施法者);
  for (let i = 0; i < 分身组.length; i++) {
    铃仙Q分身模仿(施法者, 分身组[i]);
  }

  // 创建 TS 原生弹幕：沿施法方向直线飞行
  创建原生弹幕({
    所有者: 施法者,
    X: 起点X,
    Y: 起点Y,
    方向角,
    速度: cfg.弹幕速度,
    最大距离: cfg.弹幕每tick距离 * cfg.弹幕最大步数,
    命中半径: cfg.弹幕命中半径,
    影响目标: "敌方",
    每单位最大命中次数: 1,
    碰撞消失: false,
    模型: cfg.弹幕模型,
    目标筛选: (目标单位: any) => 是有效敌对目标(施法者, 目标单位),
    on命中: (目标单位: any, 弹幕ID: number) => {
      if (目标单位 == null || 目标单位 === 0) return;

      // 减速 20% 持续 2 秒
      施加减速(施法者, 目标单位, cfg.减速比例, cfg.减速持续秒, 铃仙BuffID.Q减速, "技能");

      const 是英雄 = IsUnitType(目标单位, UNIT_TYPE_HERO);

      // 命中英雄：铃仙自身短暂隐身 1 秒（源 JASS：命中英雄时 UnitAddAbility(铃仙, 'Agho')）
      if (是英雄) {
        施加隐身(施法者, { 持续时间: cfg.隐身持续秒, 来源单位: 施法者 });
        // Q 隐身 Buff：命中英雄时登记隐身状态图标
        registerManualBuff(施法者, 铃仙BuffID.Q隐身, cfg.隐身持续秒, 0);
        // Q 反隐干扰：命中英雄时干扰附近反隐效果（源 JASS 对命中英雄加 Agho 干扰反隐，此处用隐身持续秒）
        registerManualBuff(目标单位, 铃仙BuffID.Q反隐干扰, cfg.隐身持续秒, 0);
      }

      // 伤害：非英雄目标 ×1.5；魔法伤害 + attack=true（攻击效果）
      造成技能伤害({
        来源: 施法者,
        目标: 目标单位,
        伤害: 是英雄 ? 基础伤害 : 基础伤害 * cfg.非英雄伤害倍率,
        伤害类型: DAMAGE_TYPE_MAGIC,
        attack: true,
        ranged: false,
        attackType: ATTACK_TYPE_NORMAL,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: "单位技能",
        技能ID: Q技能ID,
        标签: "铃仙-幻觉冲击波",
        伤害形态: "单体",
        参与技能伤害加成: true,
      });

      // 命中特效：弹幕当前坐标创建 pinkredlaser
      铃仙Q命中特效(弹幕ID, 目标单位);
    },
  });
}

registerSpellEffectListener(on铃仙Q);

export {};