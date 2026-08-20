/** @noSelfInFile */

/**
 * 铃仙 - Q：幻觉冲击波（A0GK，源 ReisenQ）
 *
 * 源 JASS：`铃仙.j` 的 ReisenQ 分支（入口 1380-1418，主流程 Func001Func012T、
 * 推进 Func001Func012Func014T、分身模仿 Func001Func012Func002A）。
 *
 * 逻辑：
 * - 施法：播放 gg_snd_LX_Q2 + gg_snd_LX_q 音效；每个存活分身模仿（面向施法方向、
 *   0.35s 施法硬直后恢复动作 2、pinkredlaser 特效）。
 * - 本体 pinkredlaser 特效（缩放 0.3、Z 200、绕 Z 旋转施法方向、3 倍速、1 秒销毁）。
 * - 底层用 TS 原生弹幕（无模型隐形单位壳）作为伤害发射器，
 *   沿施法方向飞行 950 码（每 tick 50 码×19 tick），165 码命中半径穿透前进。
 * - 命中：减速 20% 持续 2 秒；英雄伤害 = 总伤害、非英雄 = 总伤害 × 1.5，魔法伤害 attack=true。
 * - 总伤害 = 攻击力 × 1.85 × (1 + 0.20 × 分身数)。
 * - 飞行结束后若命中过英雄则给施法者添加 Agho 隐身 0.6 秒。
 */

import { 铃仙单位技能配置 } from "./00．配置";
import { 铃仙BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/12．铃仙";
import { 播放铃仙全局音效, 播放铃仙单位绑定音效 } from "./00A．表现工具";
import { 是铃仙本体, 是铃仙分身, 铃仙分身数量, 获取铃仙分身组, 移除铃仙分身, 是有效敌对目标 } from "./00B．分身与状态管理";

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
const { 创建原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index") as {
  创建原生弹幕: (this: void, 参数: any) => any;
};
const { 施加减速 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加减速: (this: void, 来源: any, 目标: any, 降低比例: number, 持续时间: number, 效果来源名称?: string, 效果来源类型?: "装备" | "技能") => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
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
    动画速度?: number;
    持续秒?: number;
  }) => any;
};
const { 读取单位攻击力, 单位存活, 两点角度, 取单位ID } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  取单位ID: (this: void, unit: any) => number;
};
const { 秒转毫秒 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.24．整数与时间换算") as {
  秒转毫秒: (this: void, seconds: number) => number;
};

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;

const Q技能ID = stringToFourCCSafe(铃仙单位技能配置.Q技能ID);
const Agho隐身能力ID = stringToFourCCSafe("Agho");

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;

//=============================================================================
// 一、分身模仿（源 JASS：Func001Func012Func002A）
//=============================================================================

interface 分身模仿参数 {
  分身: any;
}

interface Q隐身到期参数 {
  施法者: any;
  代次: number;
}

/** Q 隐身代次表：重复命中/重复施法时旧回调不得移除新一轮仍有效的隐身能力 */
const Q隐身代次表: Record<number, number | undefined> = {};

function 铃仙Q分身模仿恢复(this: void, variable?: any): void {
  const 参数 = variable as 分身模仿参数 | undefined;
  if (参数 == null) return;
  const 分身 = 参数.分身;
  // 句柄可能被复用：仅当仍是存活铃仙分身时才恢复动作与解除暂停
  if (分身 == null || 分身 === 0 || !单位存活(分身) || !是铃仙分身(分身)) return;
  SetUnitAnimationByIndex(分身, 2);
  移除单位暂停(分身, "铃仙Q分身模仿");
}

function 铃仙Q隐身到期(this: void, variable?: any): void {
  const 参数 = variable as Q隐身到期参数 | undefined;
  if (参数 == null) return;
  const 施法者 = 参数.施法者;
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) return;
  // 旧回调代次落后于当前代次 → 新一轮隐身仍有效，不移除
  if (Q隐身代次表[取单位ID(施法者)] !== 参数.代次) return;
  UnitRemoveAbility(施法者, Agho隐身能力ID);
}

function 铃仙Q分身模仿(this: void, 施法者: any, 分身: any, 方向角: number): void {
  if (分身 == null || 分身 === 0) return;
  const cfg = 铃仙单位技能配置.Q;
  // 分身死亡则从分身组移除（源 JASS：else 分支 GroupRemoveUnit）
  if (!单位存活(分身)) {
    移除铃仙分身(施法者, 分身);
    return;
  }

  // 面向施法方向 + 0.35s 施法硬直（源 JASS：SetUnitFacing + YDWEUnitAddStun）
  SetUnitFacing(分身, 方向角);
  添加单位暂停(分身, "铃仙Q分身模仿");

  // 分身 pinkredlaser 特效：缩放 0.3、Z 175、绕 Z 旋转施法方向、3 倍速、1 秒销毁
  创建点特效({
    模型路径: cfg.命中特效模型,
    X: GetUnitX(分身),
    Y: GetUnitY(分身),
    Z: cfg.分身特效Z,
    缩放: cfg.分身特效缩放,
    Z轴角度: 方向角,
    动画速度: 3,
    持续秒: cfg.分身特效时长,
  });

  // 0.35s 后恢复动作 2 并解除硬直（源 JASS：SetUnitAnimationByIndex(2) + YDWEUnitRemoveStun）
  addDelayedCallback(350, 铃仙Q分身模仿恢复, { 分身 } as 分身模仿参数);

  // 恢复倍速（源 JASS 78 行 SetUnitTimeScale 1.00）
  SetUnitTimeScale(分身, 1.0);
}

//=============================================================================
// 二、Q 施法主流程（源 JASS：入口 + Func001Func012T + Func001Func012Func014T）
//=============================================================================

function on铃仙Q(this: void, 施法者: any, 技能ID数值: number): void {
  if (技能ID数值 !== Q技能ID) return;
  if (!是铃仙本体(施法者)) return;

  const cfg = 铃仙单位技能配置.Q;
  const 起点X = GetUnitX(施法者);
  const 起点Y = GetUnitY(施法者);
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 方向角 = 两点角度(起点X, 起点Y, 目标X, 目标Y);

  // 1. 施法音效（源 JASS 1387-1388：PlaySoundOnUnitBJ(gg_snd_LX_Q2, 100, unit) + PlaySoundOnUnitBJ(gg_snd_LX_q, 100, unit)）
  播放铃仙单位绑定音效(施法者, "gg_snd_LX_Q2", 100);
  播放铃仙单位绑定音效(施法者, "gg_snd_LX_q", 100);

  // 2. 分身模仿（源 JASS Func012T：ForGroupBJ 分身单位组 → Func002A）
  const 分身组 = 获取铃仙分身组(施法者);
  for (let i = 0; i < 分身组.length; i++) {
    铃仙Q分身模仿(施法者, 分身组[i], 方向角);
  }

  // 3. 本体 pinkredlaser 特效（源 JASS 209-226）
  创建点特效({
    模型路径: cfg.命中特效模型,
    X: 起点X,
    Y: 起点Y,
    Z: cfg.命中特效Z,
    缩放: cfg.命中特效缩放,
    Z轴角度: 方向角,
    动画速度: 3,
    持续秒: cfg.命中特效时长,
  });

  // 4. 总伤害 = 攻击力 × 1.85 × (1 + 0.20 × 分身数)
  const 分身数量 = 铃仙分身数量(施法者);
  const 总伤害 = 读取单位攻击力(施法者) * cfg.攻击力倍率 * (1 + cfg.每分身伤害加成 * 分身数量);

  // 5. 底层：TS 原生弹幕（无模型隐形单位壳）作为伤害发射器。
  //    沿施法方向飞行 950 码（50 码/tick × 19 tick），165 命中半径穿透前进。
  //    pinkredlaser 特效已在上面作为纯表现层播放，弹幕本体不可见。
  let 命中英雄 = false;
  let 命中单位数 = 0;
  创建原生弹幕({
    所有者: 施法者,
    X: 起点X,
    Y: 起点Y,
    方向角,
    速度: cfg.弹幕速度,
    最大距离: cfg.弹幕最大步数 * cfg.弹幕每tick距离, // 19 × 50 = 950
    生命周期: cfg.弹幕最大步数 * cfg.弹幕tick秒, // 19 × 0.03 ≈ 0.57，兜底结束
    命中半径: cfg.弹幕命中半径,
    影响目标: "敌方",
    碰撞消失: false, // 穿透直线
    每单位最大命中次数: 1,
    最大总命中次数: 0,
    模型: "", // 无模型隐形单位壳，只做伤害发射器
    来源类型: "单位技能",
    技能ID: Q技能ID,
    技能标签: "铃仙-幻觉冲击波",
    伤害形态: "单体",
    参与技能伤害加成: true,
    on命中: (目标: any) => {
      // 减速 20% 持续 2 秒（源 JASS 111-117：e00D 马甲 slow 108=0.20 / 102,103=2.00）
      施加减速(施法者, 目标, cfg.减速比例, cfg.减速持续秒, 铃仙BuffID.Q减速, "技能");
      // 伤害：英雄 ×1 / 非英雄 ×1.5，魔法伤害 attack=true（源 JASS 118-122）
      const 是英雄 = IsUnitType(目标, UNIT_TYPE_HERO);
      if (是英雄) 命中英雄 = true;
      命中单位数 += 1;
      造成技能伤害({
        来源: 施法者,
        目标,
        伤害: 是英雄 ? 总伤害 : 总伤害 * cfg.非英雄伤害倍率,
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
    },
    on结束: (原因: any) => {
      // 命中过英雄 → 给施法者添加 Agho 隐身 0.6 秒（源 JASS 143-161：0.60 定时器移除）
      if (命中英雄) {
        const 施法者ID = 取单位ID(施法者);
        const 代次 = (Q隐身代次表[施法者ID] ?? 0) + 1;
        Q隐身代次表[施法者ID] = 代次;
        UnitAddAbility(施法者, Agho隐身能力ID);
        registerManualBuff(施法者, 铃仙BuffID.Q隐身, cfg.隐身持续秒, 0);
        addDelayedCallback(秒转毫秒(cfg.隐身持续秒), 铃仙Q隐身到期, { 施法者, 代次 } as Q隐身到期参数);
      }
    },
  });
}

registerSpellEffectListener(on铃仙Q);

export {};
