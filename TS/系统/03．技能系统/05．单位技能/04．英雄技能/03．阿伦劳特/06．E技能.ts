/** @noSelfInFile */

/**
 * 阿伦劳特 - E：光之裁决/裁决吸引（A0D4）
 *
 * 源 JASS：JASS\部分地图编辑器GUI的英雄jass代码\阿劳伦特\主要技能.j 的 A0D4 分支
 * （入口 1218-1284；光形态 451-522 + 359-449 + 300-357；暗形态 198-240 + 174-196 + 127-168）。
 *
 * 光形态（H00F）光之裁决：
 * - 目标为敌人时触发：0.05s 周期冲锋，每 tick 向目标移动 60 码，同时生成 e060 残影（0.35s，顶点色 100/100/100/80，光动作 6 或天堂审判动作 3）。
 * - 到达目标（自身攻击范围×2 内或 20 tick 上限）后：恢复飞行高度；非天堂审判延迟 0.27s 结算，天堂审判立即结算。
 * - 结算：非天堂审判主目标 攻击力×300% 魔法伤害 + 300 范围溅射 150%；天堂审判（B018）主目标必定暴击 攻击力×200% + 溅射 200% 且击退 300 码、眩晕 1s。
 * - 无论结局都恢复本体暂停/路径/时间缩放。
 *
 * 暗形态（H00G）裁决吸引：
 * - 消耗 10% 魔法：收集目标 450 范围合法单位，0.04s 周期最多 75 tick（3s）。
 * - 敌人每 tick 向施法者靠近 12 码、友军 24 码（关闭路径）；敌人每 tick 吸取 自身每秒生命恢复 × 0.04。
 * - 单位进入施法者攻击范围后从吸引组移除：敌人受到 攻击力×150% + 自身当前生命×15% 暗魔法伤害并减速 50%/2s；友军加速 50%/2s。
 * - 结束恢复全部单位路径。
 *
 * 说明：源 JASS 用 e00D 马甲（A0D9/A0DA）施加减速/加速，TS 统一用 施加减速/移动速度调整 封装。
 */

import { 阿伦劳特单位技能配置 } from "./00．配置";
import {
  是阿伦劳特英雄,
  是光形态,
  是暗形态,
  是有效目标,
  拥有天堂呼唤,
  两点角度,
  两点距离,
} from "./00B．形态与状态管理";

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, 施法单位: any, 技能ID: number) => void) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { addPeriodicCallback, removePeriodicCallback, addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => number;
};
const { 施加减速, 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加减速: (this: void, 来源: any, 目标: any, 降低比例: number, 持续时间: number, 效果来源名称?: string, 效果来源类型?: "装备" | "技能") => void;
  施加眩晕: (this: void, 来源: any, 目标: any, 持续时间: number, 效果来源名称?: string, 效果来源类型?: "装备" | "技能") => void;
};
const { 开始击退 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统") as {
  开始击退: (this: void, target: any, 参数: any) => boolean;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 读取单位攻击力, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { YDUserDataGetSafe, YDUserDataSetSafe, getObjectPropertyRealSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  getObjectPropertyRealSafe: (this: void, objectType: number, objectId: number | string, property: string) => number;
};
const { 创建点特效, createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: {
    模型路径: string;
    X: number;
    Y: number;
    Z?: number;
    面向角度?: number;
    持续秒?: number;
    缩放?: number;
    动画速度?: number;
  }) => any;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};
const { SOS_GetUnitSpeed, SOS_SetUnitSpeed, SOS_UnSetUnitSpeed } = require("lib.扩展函数.Star扩展函数.Star扩展库.05．移动速度突破系统") as {
  SOS_GetUnitSpeed: (this: void, unit: any) => number;
  SOS_SetUnitSpeed: (this: void, unit: any, speed: number, duration?: number) => void;
  SOS_UnSetUnitSpeed: (this: void, unit: any) => void;
};

const jass = require("jass.common") as any;
const jassGlobals = require("jass.globals") as any;

const { PlaySoundOnUnitBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundOnUnitBJ: (this: void, soundHandle: any, volumePercent: number, whichUnit: any) => void;
};

/** 预定义全局音效句柄（源 JASS gg_snd_LifeDrain，与项目其他英雄的 jassGlobals.gg_snd_* 用法一致） */
const gg_snd_LifeDrain = jassGlobals.gg_snd_LifeDrain;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const GetUnitDefaultFlyHeight = jass.GetUnitDefaultFlyHeight as (this: void, unit: any) => number;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const SetUnitPathing = jass.SetUnitPathing as (this: void, unit: any, enabled: boolean) => void;
const PauseUnit = jass.PauseUnit as (this: void, unit: any, flag: boolean) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const SetUnitVertexColor = jass.SetUnitVertexColor as (this: void, unit: any, r: number, g: number, b: number, a: number) => void;
const CreateUnit = jass.CreateUnit as (this: void, player: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const RemoveUnit = jass.RemoveUnit as (this: void, unit: any) => void;
const UnitApplyTimedLife = jass.UnitApplyTimedLife as (this: void, unit: any, buffId: number, duration: number) => void;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const AddLightning = jass.AddLightning as (this: void, codeName: string, checkVisibility: boolean, x1: number, y1: number, x2: number, y2: number) => any;
const DestroyLightning = jass.DestroyLightning as (this: void, whichLightning: any) => boolean;

const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const YDWE_OBJECT_TYPE_UNIT = 2;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_ATTACK = jass.ConvertUnitState(0x15) as any;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const R2I = jass.R2I as (this: void, value: number) => number;

const E技能ID = stringToFourCCSafe(阿伦劳特单位技能配置.E技能ID);
const 残影单位ID = stringToFourCCSafe(阿伦劳特单位技能配置.E.残影单位ID);
const 限时生命BuffID = stringToFourCCSafe("BHwe");

/** 攻击范围（rangeN1，源用 YDWEGetObjectPropertyReal） */
function 读取单位攻击范围(this: void, unit: any): number {
  const 范围 = getObjectPropertyRealSafe(YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId(unit), "rangeN1");
  return 范围 > 0 ? 范围 : 128;
}

function 取四舍五入整数(this: void, value: number): number {
  return R2I(value + 0.5);
}

function 取较大值(this: void, a: number, b: number): number {
  return a > b ? a : b;
}

function 取较小值(this: void, a: number, b: number): number {
  return a < b ? a : b;
}

const 角度转弧度 = 0.017453292519943295;

function 单位当前飞行高度(this: void, unit: any): number {
  const h = GetUnitFlyHeight(unit);
  return h > 0 ? h : 0;
}

/** 暗形态汲取音效：全局句柄 gg_snd_LifeDrain（源 JASS 用 gg_snd_LifeDrain，与其他英雄全局音效用法一致） */
function 播放LifeDrain音效(this: void, 单位: any): void {
  if (gg_snd_LifeDrain == null || gg_snd_LifeDrain === 0 || 单位 == null || 单位 === 0) return;
  PlaySoundOnUnitBJ(gg_snd_LifeDrain, 100, 单位);
}

function 造成W伤害(this: void, 施法者: any, 目标: any, 倍率: number, 伤害类型: any, 是否攻击效果: boolean): void {
  const 攻击力 = 读取单位攻击力(施法者);
  if (攻击力 <= 0) return;
  造成技能伤害({
    来源: 施法者,
    目标: 目标,
    伤害: 攻击力 * 倍率,
    伤害类型: 伤害类型,
    attack: 是否攻击效果,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: E技能ID,
    标签: "阿伦劳特-E",
    参与技能伤害加成: true,
  });
}

/** 光形态冲锋上下文 */
interface 光冲锋上下文 {
  施法者: any;
  目标: any;
  循环实数: number;
  次数: number;
  倍数: number;
  天堂审判开启: boolean;
  周期ID: number;
  结算延迟ID: number;
  结算中: boolean;
  已结束: boolean;
}

function 光冲锋周期回调(this: void, variable?: any): void {
  const ctx = variable as 光冲锋上下文;
  if (ctx == null) return;
  光冲锋周期(ctx);
}

function 光冲锋结算回调(this: void, variable?: any): void {
  const ctx = variable as 光冲锋上下文;
  if (ctx == null) return;
  ctx.结算延迟ID = 0;
  if (ctx.已结束) return;
  光结算伤害(ctx);
  结束光冲锋(ctx);
}

/** 光形态：开始冲锋 */
function 光形态施放(this: void, 施法者: any, 目标: any): void {
  const E配置 = 阿伦劳特单位技能配置.E;
  const ctx: 光冲锋上下文 = {
    施法者,
    目标,
    循环实数: 0,
    次数: 1,
    倍数: 1,
    天堂审判开启: false,
    周期ID: 0,
    结算延迟ID: 0,
    结算中: false,
    已结束: false,
  };

  const 距离 = 两点距离(GetUnitX(施法者), GetUnitY(施法者), GetUnitX(目标), GetUnitY(目标));
  ctx.次数 = 取较大值(1, 距离 / E配置.冲锋每tick距离);
  ctx.倍数 = 1 / ctx.次数;
  // 距离小于自身攻击范围则直接结算
  if (距离 < 读取单位攻击范围(施法者)) {
    ctx.循环实数 = E配置.光冲锋次数上限;
  }

  // 暂停本体、关闭路径
  PauseUnit(施法者, true);
  SetUnitPathing(施法者, false);
  // 天堂呼唤（B018）决定动作/倍速
  ctx.天堂审判开启 = 拥有天堂呼唤(施法者);
  if (!ctx.天堂审判开启) {
    SetUnitAnimationByIndex(施法者, 6);
    SetUnitTimeScale(施法者, 2.1);
  } else {
    SetUnitAnimationByIndex(施法者, 3);
    SetUnitTimeScale(施法者, 1.0);
  }

  ctx.周期ID = addPeriodicCallback(取四舍五入整数(E配置.冲锋周期秒 * 1000), 光冲锋周期回调, ctx);
}

/** 光形态：冲锋周期 tick */
function 光冲锋周期(this: void, ctx: 光冲锋上下文): void {
  if (ctx.已结束) return;
  const E配置 = 阿伦劳特单位技能配置.E;
  const 施法者 = ctx.施法者;
  const 目标 = ctx.目标;
  if (!单位存活(施法者) || !单位存活(目标)) {
    结束光冲锋(ctx);
    return;
  }
  const 攻击范围 = 读取单位攻击范围(施法者);

  // 源 JASS：到达自身真实攻击范围，或达到 20 tick 上限。
  const 到达 = (两点距离(GetUnitX(施法者), GetUnitY(施法者), GetUnitX(目标), GetUnitY(目标)) <= 攻击范围 * E配置.光到达范围倍数)
    || ctx.循环实数 >= E配置.光冲锋次数上限;
  if (到达) {
    // 恢复飞行高度为默认值（源 JASS 367：恢复"默认飞行高度"）
    SetUnitFlyHeight(施法者, GetUnitDefaultFlyHeight(施法者), 0);
    光冲锋结算(ctx);
    return;
  }

  // 未到达：生成残影 + 向目标移动 60 码
  ctx.循环实数 += 1;
  const 角度 = 两点角度(GetUnitX(施法者), GetUnitY(施法者), GetUnitX(目标), GetUnitY(目标));
  // 残影
  const 分身 = CreateUnit(GetOwningPlayer(施法者), 残影单位ID, GetUnitX(施法者), GetUnitY(施法者), GetUnitFacing(施法者));
  UnitApplyTimedLife(分身, 限时生命BuffID, E配置.残影持续秒);
  SetUnitVertexColor(分身, E配置.残影红, E配置.残影绿, E配置.残影蓝, E配置.残影透明);
  SetUnitTimeScale(分身, 1 + ctx.循环实数 * ctx.倍数);
  if (!ctx.天堂审判开启) {
    SetUnitAnimationByIndex(分身, 6);
    SetUnitFlyHeight(分身, 单位当前飞行高度(施法者), 0);
  } else {
    SetUnitAnimationByIndex(分身, 3);
    // 天堂审判下本体跳跃
    const 跳跃高 = ctx.循环实数 >= ctx.次数 * 0.5 ? -40 : 40;
    SetUnitFlyHeight(施法者, 单位当前飞行高度(施法者) + 跳跃高, 0);
    SetUnitFlyHeight(分身, 单位当前飞行高度(施法者), 0);
  }
  // 移动
  const nx = GetUnitX(施法者) + Cos(角度 * 角度转弧度) * E配置.冲锋每tick距离;
  const ny = GetUnitY(施法者) + Sin(角度 * 角度转弧度) * E配置.冲锋每tick距离;
  SetUnitPosition(施法者, nx, ny);
}

/** 光形态：到达后结算 */
function 光冲锋结算(this: void, ctx: 光冲锋上下文): void {
  if (ctx.已结束 || ctx.结算中) return;
  ctx.结算中 = true;
  if (ctx.周期ID !== 0) {
    removePeriodicCallback(ctx.周期ID);
    ctx.周期ID = 0;
  }
  const E配置 = 阿伦劳特单位技能配置.E;
  const 施法者 = ctx.施法者;
  const 目标 = ctx.目标;
  // 结算前的表现延迟：非天堂审判 0.27s，天堂审判立即。
  const 延迟 = ctx.天堂审判开启 ? 0 : E配置.光结算延迟秒;
  // 源 JASS 的动作 3 是到达后的跳劈；两种光状态都显式重播一次，避免冲锋动作覆盖它。
  SetUnitAnimationByIndex(施法者, 3);
  SetUnitTimeScale(施法者, 1.0);
  ctx.结算延迟ID = addDelayedCallback(取四舍五入整数(延迟 * 1000), 光冲锋结算回调, ctx);
}

/** 光形态：结算伤害 */
function 光结算伤害(this: void, ctx: 光冲锋上下文): void {
  const E配置 = 阿伦劳特单位技能配置.E;
  const 施法者 = ctx.施法者;
  const 目标 = ctx.目标;
  if (!单位存活(施法者) || !单位存活(目标)) return;
  const tx = GetUnitX(目标);
  const ty = GetUnitY(目标);
  const 目标飞行高度 = 单位当前飞行高度(目标);

  // 结算特效 Judgement_impact_chest.mdx 缩放 2.0，Z=目标飞行高度+50，2s（源 JASS 379-382）
  创建点特效({
    模型路径: E配置.光结算特效,
    X: tx,
    Y: ty,
    Z: 目标飞行高度 + E配置.光结算特效Z偏移,
    缩放: E配置.光结算特效缩放,
    持续秒: E配置.光结算特效持续秒,
  });
  // 雷击特效 ThunderClapCaster.mdl 在目标位置，2s（源 JASS 307）
  创建点特效({
    模型路径: E配置.光雷击特效,
    X: tx,
    Y: ty,
    Z: 目标飞行高度,
    持续秒: E配置.光雷击特效持续秒,
  });

  // 300 范围其他敌人（排除主目标）
  const 溅射目标 = getUnitsInRange(tx, ty, 300);
  if (ctx.天堂审判开启) {
    // 天堂审判：主目标必定暴击（临时 +100% 暴击率），溅射 200% + 击退 300 + 眩晕 1s
    造成W伤害(施法者, 目标, E配置.光天堂审判主目标倍率, DAMAGE_TYPE_MAGIC, true);
    for (let i = 0; i < 溅射目标.length; i++) {
      const t = 溅射目标[i];
      if (t === 目标) continue;
      if (!是有效目标(t)) continue;
      if (!IsUnitEnemy(t, GetOwningPlayer(施法者))) continue;
      造成W伤害(施法者, t, E配置.光天堂审判溅射倍率, DAMAGE_TYPE_MAGIC, true);
      // 溅射命中特效 CritterBloodAlbatross.mdl 挂 chest，1s（源 JASS 251）
      createTimedUnitEffect(t, "chest", E配置.光溅射命中特效, E配置.光溅射命中特效持续秒);
      开始击退(t, {
        来源单位: 施法者,
        距离: E配置.光天堂审判溅射击退距离,
        持续时间: 0.3,
        检查地形: true,
        暂停单位: false,
        禁用碰撞: true,
        主单位死亡时中断: false,
      });
      施加眩晕(施法者, t, E配置.光天堂审判溅射眩晕秒, "阿伦劳特-E-裁决审判", "技能");
    }
  } else {
    // 非天堂审判：主目标 300%，溅射 150%
    造成W伤害(施法者, 目标, E配置.光主目标倍率, DAMAGE_TYPE_MAGIC, false);
    for (let i = 0; i < 溅射目标.length; i++) {
      const t = 溅射目标[i];
      if (t === 目标) continue;
      if (!是有效目标(t)) continue;
      if (!IsUnitEnemy(t, GetOwningPlayer(施法者))) continue;
      造成W伤害(施法者, t, E配置.光溅射倍率, DAMAGE_TYPE_MAGIC, false);
      // 溅射命中特效 CritterBloodAlbatross.mdl 挂 chest，1s（源 JASS 256）
      createTimedUnitEffect(t, "chest", E配置.光溅射命中特效, E配置.光溅射命中特效持续秒);
    }
  }
}

/** 光形态：结束恢复本体状态 */
function 结束光冲锋(this: void, ctx: 光冲锋上下文): void {
  if (ctx.已结束) return;
  ctx.已结束 = true;
  if (ctx.周期ID !== 0) removePeriodicCallback(ctx.周期ID);
  if (ctx.结算延迟ID !== 0) removeDelayedCallback(ctx.结算延迟ID);
  const 施法者 = ctx.施法者;
  if (施法者 != null && 施法者 !== 0) {
    SetUnitPathing(施法者, true);
    SetUnitTimeScale(施法者, 1.0);
    PauseUnit(施法者, false);
  }
}

/** 暗形态吸引上下文 */
interface 暗吸引上下文 {
  施法者: any;
  目标: any;
  吸引组: any[];
  每秒吸取值: number;
  循环实数: number;
  周期ID: number;
  已结束: boolean;
}

function 暗吸引周期回调(this: void, variable?: any): void {
  const ctx = variable as 暗吸引上下文;
  if (ctx == null) return;
  暗吸引周期(ctx);
}

function 销毁暗形态汲取闪电(this: void, variable?: any): void {
  const lightning = variable;
  if (lightning != null && lightning !== 0) DestroyLightning(lightning);
}

/** 暗形态：开始吸引 */
function 暗形态施放(this: void, 施法者: any, 目标: any): void {
  const E配置 = 阿伦劳特单位技能配置.E;
  // 收集目标 450 范围合法单位（非古树/机械、存活、非中立被动、非施法者）
  const 吸引组 = getUnitsInRange(GetUnitX(目标), GetUnitY(目标), E配置.暗收集范围).filter((u: any) => {
    if (!是有效目标(u)) return false;
    if (u === 施法者) return false;
    return true;
  });
  if (吸引组.length === 0) return;
  // 每秒吸取值 = 玩家总生命恢复
  const 玩家 = GetOwningPlayer(施法者);
  const 每秒吸取值 = (YDUserDataGetSafe("player", 玩家, "总生命恢复", "real") as number) || 0;

  const ctx: 暗吸引上下文 = {
    施法者,
    目标,
    吸引组,
    每秒吸取值,
    循环实数: 0,
    周期ID: 0,
    已结束: false,
  };
  ctx.周期ID = addPeriodicCallback(取四舍五入整数(E配置.暗周期秒 * 1000), 暗吸引周期回调, ctx);
}

/** 暗形态：吸引周期 tick */
function 暗吸引周期(this: void, ctx: 暗吸引上下文): void {
  if (ctx.已结束) return;
  const E配置 = 阿伦劳特单位技能配置.E;
  ctx.循环实数 += 1;
  if (ctx.循环实数 >= E配置.暗最大tick) {
    // 结束：恢复全部单位路径
    for (let i = 0; i < ctx.吸引组.length; i++) {
      const u = ctx.吸引组[i];
      if (u != null && u !== 0) SetUnitPathing(u, true);
    }
    ctx.已结束 = true;
    removePeriodicCallback(ctx.周期ID);
    return;
  }
  // 从后向前遍历（可能移除）
  for (let i = ctx.吸引组.length - 1; i >= 0; i--) {
    const 单位 = ctx.吸引组[i];
    if (单位 == null || 单位 === 0) {
      ctx.吸引组.splice(i, 1);
      continue;
    }
    if (!单位存活(单位)) {
      SetUnitPathing(单位, true);
      ctx.吸引组.splice(i, 1);
      continue;
    }
    暗吸引单单位(ctx, 单位, i);
  }
}

/** 暗形态：单单位吸引 tick */
function 暗吸引单单位(this: void, ctx: 暗吸引上下文, 单位: any, 索引: number): void {
  const E配置 = 阿伦劳特单位技能配置.E;
  const 施法者 = ctx.施法者;
  const 是敌人 = IsUnitEnemy(单位, GetOwningPlayer(施法者));
  // 每 tick：生命汲取音效（源 JASS 129，复用句柄从头播，不叠加）
  播放LifeDrain音效(单位);
  // 关闭路径并朝施法者移动
  SetUnitPathing(单位, false);

  // 每 tick：DRAB 生命汲取闪电连接 目标↔施法者，0.03s 后销毁（源 JASS 130）
  const 汲取闪电 = AddLightning(E配置.暗汲取闪电代码, false, GetUnitX(单位), GetUnitY(单位), GetUnitX(施法者), GetUnitY(施法者));
  if (汲取闪电 != null && 汲取闪电 !== 0) {
    const 该闪电 = 汲取闪电;
    addDelayedCallback(取四舍五入整数(E配置.暗汲取闪电持续秒 * 1000), 销毁暗形态汲取闪电, 该闪电);
  }

  const 角度 = 两点角度(GetUnitX(单位), GetUnitY(单位), GetUnitX(施法者), GetUnitY(施法者));
  const 移动距离 = 是敌人 ? E配置.暗敌人靠近距离 : E配置.暗友军靠近距离;
  const nx = GetUnitX(单位) + Cos(角度 * 角度转弧度) * 移动距离;
  const ny = GetUnitY(单位) + Sin(角度 * 角度转弧度) * 移动距离;
  SetUnitPosition(单位, nx, ny);

  // 吸取敌人生命
  if (是敌人 && ctx.每秒吸取值 > 0) {
    const 吸取 = ctx.每秒吸取值 * E配置.暗吸取tick比例;
    const 当前生命 = GetUnitState(单位, UNIT_STATE_LIFE);
      const 实际吸取 = 取较小值(当前生命, 吸取);
    if (实际吸取 > 0) {
      SetUnitState(单位, UNIT_STATE_LIFE, 当前生命 - 实际吸取);
      SetUnitState(施法者, UNIT_STATE_LIFE, GetUnitState(施法者, UNIT_STATE_LIFE) + 实际吸取);
    }
  }

  // 进入攻击范围：移除并结算
  const 攻击范围 = 读取单位攻击范围(施法者);
  if (两点距离(GetUnitX(施法者), GetUnitY(施法者), GetUnitX(单位), GetUnitY(单位)) <= 攻击范围) {
    ctx.吸引组.splice(索引, 1);
    SetUnitPathing(单位, true);
    if (是敌人) {
      // 命中特效 UndeadDissipate.mdl：缩放=目标模型缩放，Z=目标飞行高度，1s（源 JASS 158-160）
      创建点特效({
        模型路径: E配置.暗敌人命中特效,
        X: GetUnitX(单位),
        Y: GetUnitY(单位),
        Z: 单位当前飞行高度(单位),
        缩放: getObjectPropertyRealSafe(YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId(单位), "modelScale") || 1,
        持续秒: E配置.暗敌人命中特效持续秒,
      });
      // 敌人：攻击力×150% + 当前生命×15% 暗魔法伤害 + 减速 50%/2s
      造成W伤害(施法者, 单位, E配置.暗敌人伤害倍率, DAMAGE_TYPE_SHADOW_STRIKE, false);
      const 当前生命2 = GetUnitState(单位, UNIT_STATE_LIFE);
      if (当前生命2 > 0) {
        造成技能伤害({
          来源: 施法者,
          目标: 单位,
          伤害: 当前生命2 * E配置.暗敌人当前生命比例,
          伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
          attack: false,
          ranged: false,
          attackType: ATTACK_TYPE_NORMAL,
          weaponType: WEAPON_TYPE_WHOKNOWS,
          来源类型: "单位技能",
          技能ID: E技能ID,
          标签: "阿伦劳特-E-裁决吸引",
          参与技能伤害加成: true,
        });
      }
      施加减速(施法者, 单位, E配置.暗减速比例, E配置.暗减速持续秒, "阿伦劳特-E-裁决吸引", "技能");
    } else {
      // 友军：加速 50%/2s
      const 当前速度 = SOS_GetUnitSpeed(单位);
      if (当前速度 > 0) {
        SOS_SetUnitSpeed(单位, 当前速度 * (1 + E配置.暗加速比例), E配置.暗加速持续秒);
      }
    }
  }
}

/** 入口：A0D4 施放触发（物编 E 键 = 光之裁决/裁决吸引） */
export function on阿伦劳特E(this: void, 施法单位: any, abilityId: number): void {
  if (abilityId !== E技能ID) return;
  if (!是阿伦劳特英雄(施法单位)) return;
  const 目标单位 = jass.GetSpellTargetUnit();
  if (目标单位 == null || 目标单位 === 0 || !单位存活(目标单位)) return;
  if (是光形态(施法单位)) {
    // 光之裁决：只对敌人发动
    if (IsUnitEnemy(目标单位, GetOwningPlayer(施法单位))) {
      光形态施放(施法单位, 目标单位);
    }
    return;
  }
  if (是暗形态(施法单位)) {
    // 裁决吸引：扣 10% 魔法（项目统一魔耗处理，此处不重复扣百分比）
    暗形态施放(施法单位, 目标单位);
  }
}

registerSpellEffectListener(on阿伦劳特E);

export {};
