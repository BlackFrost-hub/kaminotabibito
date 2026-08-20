/** @noSelfInFile */

/**
 * 铃仙（月兔） - E 幻爆"近眼花火"（A0GH）
 *
 * 源 JASS：`JASS/部分地图编辑器GUI的英雄jass代码/铃仙/铃仙.j` ReisenE 分支
 * （Trig_L______ResenFunc003Func002T 等）。
 *
 * 逻辑（简化马甲方案）：
 * 1. 施法时播放音效 gg_snd_LX_E、动作 "spell five"、GS_Suspend 0.4 秒
 * 2. 开启 0.3 秒无敌窗口（SetUnitInvulnerable）
 * 3. 跳跃：0.02 秒周期，每 tick 飞行高度 +30 直到 ≥300，然后 -30 直到 ≤ 默认高度
 * 4. 弹幕系统：
 *    - 每 0.05 秒发射 1 波（共 6 波），每波 8 发 e07O 马甲（Bullet.mdl 缩放 2 高度 115）
 *    - 每发角度 = 面朝方向 + 45°×1~8
 *    - 每 0.02 秒推进所有弹幕（每 tick 40 码），超过最大距离（125×波次）时移入爆炸组
 *    - 6 波全部发射完毕（over=true）后，延迟 0.2 秒爆炸
 * 5. 爆炸：遍历爆炸组，每位置创建 sq.mdl 特效，170 码内敌人造成 敏捷×2.5 雷属性伤害并眩晕 1 秒
 * 6. 清理弹幕、恢复飞行高度
 */

import { 铃仙单位技能配置 } from "./00．配置";
import { 铃仙BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/12．铃仙";
import { 播放铃仙全局音效, 播放铃仙单位绑定音效, 播放铃仙配置动作 } from "./00A．表现工具";
import { 是铃仙本体, 是有效敌对目标 } from "./00B．分身与状态管理";

const jass = require("jass.common") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { registerSpellEffectListener, registerSpellEndcastListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
  registerSpellEndcastListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: {
    来源: any;
    目标: any;
    伤害: number;
    伤害类型: any;
    attack?: boolean;
    ranged?: boolean;
    attackType?: any;
    weaponType?: any;
    来源类型?: string;
    技能ID?: number;
    标签?: string;
    伤害形态?: "单体" | "AOE" | "未知";
    参与技能伤害加成?: boolean;
  }) => boolean;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: {
    模型路径: string;
    X: number;
    Y: number;
    Z?: number;
    动画速度?: number;
    持续秒?: number;
    缩放?: number;
  }) => any;
};
const { 极坐标X, 极坐标Y } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  极坐标X: (this: void, x: number, angleDeg: number, distance: number) => number;
  极坐标Y: (this: void, y: number, angleDeg: number, distance: number) => number;
};
const { 秒转毫秒 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.24．整数与时间换算") as {
  秒转毫秒: (this: void, seconds: number) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, 来源: any, 目标: any, 持续时间: number, 效果来源名称?: string, 效果来源类型?: "装备" | "技能") => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 读取单位敏捷, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位敏捷: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { SU_SetUnitFlyHeight } = require("lib.扩展函数.Star扩展函数.Star扩展库.09．单位基础与生命周期函数") as {
  SU_SetUnitFlyHeight: (this: void, whichUnit: any, newHeight: number, rate: number) => void;
};
const { SFB_施加通用Buff } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_施加通用Buff: (this: void, 来源单位: any, 目标单位: any, Buff类型: number, 持续时间: number) => void;
};
const { registerDamageModifier, unregisterDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
  unregisterDamageModifier: (this: void, id: number) => boolean;
};

const cfg = 铃仙单位技能配置;
const E技能ID数值 = stringToFourCCSafe(cfg.E技能ID); // A0GH
const 弹幕马甲ID = stringToFourCCSafe("e07O"); // Bullet.mdl 马甲
const 蝗虫技能ID = stringToFourCCSafe("Aloc");
const 限时生命BuffID = stringToFourCCSafe("BHwe");

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const GetUnitDefaultFlyHeight = jass.GetUnitDefaultFlyHeight as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, animation: string) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const UnitApplyTimedLife = jass.UnitApplyTimedLife as (this: void, unit: any, buffId: number, duration: number) => void;

//=============================================================================
// 一、弹幕上下文
//=============================================================================

interface 弹幕记录 {
  单位: any;
  /** 飞行方向角度 */
  角度: number;
  /** 已飞行距离 */
  已飞行距离: number;
  /** 最远飞行距离 = 125 × 波次 */
  最远距离: number;
  /** 当前 X */
  X: number;
  /** 当前 Y */
  Y: number;
}

interface E上下文 {
  施法者: any;
  /** 跳跃上升周期回调 ID */
  上升回调ID: number;
  /** 跳跃下降周期回调 ID */
  下降回调ID: number;
  /** 弹幕发射周期回调 ID（0.05 秒发射波次） */
  发射回调ID: number;
  /** 弹幕推进周期回调 ID（0.02 秒推进所有弹幕） */
  推进回调ID: number;
  /** 已发射波次（1~6） */
  波次: number;
  /** 全部发射标记 */
  over: boolean;
  /** 飞行中的弹幕列表 */
  子弹列表: 弹幕记录[];
  /** 超过最远距离、等待爆炸的弹幕列表 */
  爆炸列表: 弹幕记录[];
  /** 是否已爆炸 */
  已爆炸: boolean;
  /** 是否已结束 */
  已结束: boolean;
}

/** 单英雄活动 E 实例表（按英雄 handleId 索引，重复释放先收尾旧实例再建新实例） */
const E上下文表: { [handleId: number]: E上下文 } = {};

function 创建E上下文(this: void, 施法者: any): E上下文 {
  return {
    施法者,
    上升回调ID: 0,
    下降回调ID: 0,
    发射回调ID: 0,
    推进回调ID: 0,
    波次: 0,
    over: false,
    子弹列表: [],
    爆炸列表: [],
    已爆炸: false,
    已结束: false,
  };
}

function 清理E上下文(this: void, ctx: E上下文): void {
  if (ctx.已结束) return;
  ctx.已结束 = true;
  if (ctx.上升回调ID !== 0) { removePeriodicCallback(ctx.上升回调ID); ctx.上升回调ID = 0; }
  if (ctx.下降回调ID !== 0) { removePeriodicCallback(ctx.下降回调ID); ctx.下降回调ID = 0; }
  if (ctx.发射回调ID !== 0) { removePeriodicCallback(ctx.发射回调ID); ctx.发射回调ID = 0; }
  if (ctx.推进回调ID !== 0) { removePeriodicCallback(ctx.推进回调ID); ctx.推进回调ID = 0; }
  // 清理所有弹幕马甲
  for (let i = 0; i < ctx.子弹列表.length; i++) {
    const b = ctx.子弹列表[i];
    if (b != null && b.单位 != null && b.单位 !== 0) 立即移除单位并取消排泄登记(b.单位);
  }
  ctx.子弹列表 = [];
  for (let i = 0; i < ctx.爆炸列表.length; i++) {
    const b = ctx.爆炸列表[i];
    if (b != null && b.单位 != null && b.单位 !== 0) 立即移除单位并取消排泄登记(b.单位);
  }
  ctx.爆炸列表 = [];
  // 恢复飞行高度
  const 施法者 = ctx.施法者;
  if (施法者 != null && 施法者 !== 0 && 单位存活(施法者)) {
    SU_SetUnitFlyHeight(施法者, GetUnitDefaultFlyHeight(施法者), 0);
  }
  // 从实例表摘除（仅当表中仍是本实例，防止旧清理误删新实例）
  if (施法者 != null && 施法者 !== 0 && E上下文表[GetHandleId(施法者)] === ctx) {
    delete E上下文表[GetHandleId(施法者)];
  }
}

//=============================================================================
// 二、跳跃（上升 + 下降）
//=============================================================================

function 推进E上升(this: void, variable?: any): void {
  const ctx = variable as E上下文;
  if (ctx.已结束) return;
  const 施法者 = ctx.施法者;
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) {
    清理E上下文(ctx);
    return;
  }
  const 当前高度 = GetUnitFlyHeight(施法者);
  if (当前高度 >= cfg.E.最大飞行高度) {
    // 达到最大高度 → 转为下降
    removePeriodicCallback(ctx.上升回调ID);
    ctx.上升回调ID = 0;
    开始跳跃下降(ctx);
    return;
  }
  SU_SetUnitFlyHeight(施法者, 当前高度 + cfg.E.飞行高度变化, 0);
}

function 开始跳跃上升(this: void, ctx: E上下文): void {
  if (ctx.上升回调ID !== 0) return;
  ctx.上升回调ID = addPeriodicCallback(20, 推进E上升, ctx);
}

function 推进E下降(this: void, variable?: any): void {
  const ctx = variable as E上下文;
  if (ctx.已结束) return;
  const 施法者 = ctx.施法者;
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) {
    清理E上下文(ctx);
    return;
  }
  const 当前高度 = GetUnitFlyHeight(施法者);
  const 默认高度 = GetUnitDefaultFlyHeight(施法者);
  if (当前高度 <= 默认高度) {
    removePeriodicCallback(ctx.下降回调ID);
    ctx.下降回调ID = 0;
    SU_SetUnitFlyHeight(施法者, 默认高度, 0);
    return;
  }
  SU_SetUnitFlyHeight(施法者, 当前高度 - cfg.E.飞行高度变化, 0);
}

function 开始跳跃下降(this: void, ctx: E上下文): void {
  if (ctx.下降回调ID !== 0) return;
  ctx.下降回调ID = addPeriodicCallback(20, 推进E下降, ctx);
}

//=============================================================================
// 三、弹幕发射（每 0.05 秒 1 波，共 6 波，每波 8 发）
//=============================================================================

function 发射一波弹幕(this: void, ctx: E上下文): void {
  const 施法者 = ctx.施法者;
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) {
    清理E上下文(ctx);
    return;
  }
  ctx.波次 += 1;
  const 波次 = ctx.波次;
  const 中心X = GetUnitX(施法者);
  const 中心Y = GetUnitY(施法者);
  const 面朝 = GetUnitFacing(施法者);
  const 玩家 = GetOwningPlayer(施法者);
  const 最远距离 = cfg.E.弹幕单位距离 * 波次; // 125 × 波次

  for (let i = 1; i <= cfg.E.每波弹幕数; i++) {
    const 角度 = 面朝 + cfg.E.弹幕角度间隔 * i;
    const 弹幕单位 = 创建单位并登记排泄安全(玩家, 弹幕马甲ID, 中心X, 中心Y, 角度);
    if (弹幕单位 == null || 弹幕单位 === 0) continue;
    // 添加蝗虫技能 + 限时生命周期（兜底清理）
    UnitAddAbility(弹幕单位, 蝗虫技能ID);
    UnitApplyTimedLife(弹幕单位, 限时生命BuffID, 5);
    const 记录: 弹幕记录 = {
      单位: 弹幕单位,
      角度,
      已飞行距离: 0,
      最远距离,
      X: 中心X,
      Y: 中心Y,
    };
    ctx.子弹列表.push(记录);
  }
}

//=============================================================================
// 四、弹幕推进（每 0.02 秒，每 tick 40 码）
//=============================================================================

function 推进所有弹幕(this: void, ctx: E上下文): void {
  if (ctx.已结束) return;
  const 施法者 = ctx.施法者;
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) {
    清理E上下文(ctx);
    return;
  }

  const 每tick距离 = cfg.E.弹幕每tick距离;
  // 倒序遍历子弹列表，将超距离的移入爆炸列表
  for (let i = ctx.子弹列表.length - 1; i >= 0; i--) {
    const 子弹 = ctx.子弹列表[i];
    if (子弹 == null) {
      ctx.子弹列表.splice(i, 1);
      continue;
    }
    const 弹幕单位 = 子弹.单位;
    if (弹幕单位 == null || 弹幕单位 === 0) {
      ctx.子弹列表.splice(i, 1);
      continue;
    }
    // 推进
    子弹.已飞行距离 += 每tick距离;
    子弹.X = 极坐标X(子弹.X, 子弹.角度, 每tick距离);
    子弹.Y = 极坐标Y(子弹.Y, 子弹.角度, 每tick距离);
    SetUnitPosition(弹幕单位, 子弹.X, 子弹.Y);

    // 超过最远距离 → 移入爆炸组
    if (子弹.已飞行距离 >= 子弹.最远距离) {
      ctx.子弹列表.splice(i, 1);
      ctx.爆炸列表.push(子弹);
    }
  }
}

//=============================================================================
// 五、爆炸阶段
//=============================================================================

function 移除E无敌修正(this: void, variable?: any): void {
  const 修正ID = variable as number;
  if (修正ID !== 0) unregisterDamageModifier(修正ID);
}

function 执行爆炸(this: void, ctx: E上下文): void {
  if (ctx.已爆炸) return;
  ctx.已爆炸 = true;
  const 施法者 = ctx.施法者;
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) {
    清理E上下文(ctx);
    return;
  }
  // 全部发射完毕：把仍处于飞行状态的弹幕一并纳入爆炸组（对应 JASS over=true 时整体爆炸）
  for (let i = 0; i < ctx.子弹列表.length; i++) {
    ctx.爆炸列表.push(ctx.子弹列表[i]);
  }
  ctx.子弹列表 = [];

  const 敏捷 = 读取单位敏捷(施法者);
  const 伤害值 = 敏捷 * cfg.E.敏捷倍率;
  const E配置 = cfg.E;

  for (let i = 0; i < ctx.爆炸列表.length; i++) {
    const 子弹 = ctx.爆炸列表[i];
    if (子弹 == null) continue;
    const 弹幕单位 = 子弹.单位;
    const 爆X = 子弹.X;
    const 爆Y = 子弹.Y;

    // 创建 sq.mdl 红圈爆炸特效（Death 动画，0.5 秒后自动移除）
    创建点特效({
      模型路径: E配置.爆炸模型,
      X: 爆X,
      Y: 爆Y,
      Z: E配置.爆炸高度,
      缩放: E配置.爆炸缩放,
      持续秒: E配置.爆炸寿命秒,
    });

    // 170 码内敌人：敏捷×2.5 雷属性伤害 + 眩晕 1 秒
    const 单位列表 = getUnitsInRange(爆X, 爆Y, E配置.爆炸半径);
    for (let j = 0; j < 单位列表.length; j++) {
      const 目标 = 单位列表[j];
      if (!是有效敌对目标(施法者, 目标)) continue;
      if (!(伤害值 > 0)) continue;
      造成技能伤害({
        来源: 施法者,
        目标,
        伤害: 伤害值,
        伤害类型: DAMAGE_TYPE_LIGHTNING,
        attack: true,
        attackType: ATTACK_TYPE_NORMAL,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: "单位技能",
        技能ID: E技能ID数值,
        标签: "铃仙-E-幻爆近眼花火",
        伤害形态: "AOE",
        参与技能伤害加成: true,
      });
      施加眩晕(施法者, 目标, E配置.眩晕秒, 铃仙BuffID.E爆炸眩晕, "技能");
    }

    // 移除弹幕马甲
    if (弹幕单位 != null && 弹幕单位 !== 0) 立即移除单位并取消排泄登记(弹幕单位);
  }
  ctx.爆炸列表 = [];

  // 爆炸后清理上下文
  清理E上下文(ctx);
}

//=============================================================================
// 六、施法入口
//=============================================================================

function 推进E发射(this: void, variable?: any): void {
  const ctx = variable as E上下文;
  if (ctx.已结束) return;
  if (ctx.波次 >= cfg.E.波数) {
    // 全部发射完毕 → 标记 over，延迟 0.2 秒后统一爆炸
    removePeriodicCallback(ctx.发射回调ID);
    ctx.发射回调ID = 0;
    ctx.over = true;
    addDelayedCallback(秒转毫秒(cfg.E.爆炸延迟秒), 执行爆炸, ctx);
    return;
  }
  发射一波弹幕(ctx);
}

function on铃仙E生效(this: void, 施法单位: any, 技能ID数值: number): void {
  if (技能ID数值 !== E技能ID数值) return;
  if (!是铃仙本体(施法单位)) return;

  const 英雄 = 施法单位;
  // 重复释放：先收尾旧实例（防飞行高度/弹幕/爆炸清理冲突），再创建新实例
  const 旧ctx = E上下文表[GetHandleId(英雄)];
  if (旧ctx != null && !旧ctx.已结束) {
    清理E上下文(旧ctx);
  }
  const ctx = 创建E上下文(英雄);
  E上下文表[GetHandleId(英雄)] = ctx;

  // 1) 音效 + 动作 + 施法硬直
  // 施法音效（源 JASS：PlaySoundOnUnitBJ(gg_snd_LX_E, 100, 铃仙)）
  播放铃仙单位绑定音效(英雄, "gg_snd_LX_E", 100);
  SetUnitAnimation(英雄, "spell five");
  播放铃仙配置动作(英雄, -1, 1.0); // 确保时间缩放正常
  SFB_施加通用Buff(英雄, 英雄, 21, cfg.E.施法硬直秒); // 施法硬直（暂停类 Buff，等价 GS_Suspend 0.4 秒）

  // 2) 0.3 秒无敌窗口：注册临时伤害修正回调，窗口内受伤时设为 0
  const 无敌修正ID = registerDamageModifier((伤害上下文: any) => {
    if (伤害上下文 != null && 伤害上下文.target === 英雄) return 0;
    return 伤害上下文 != null && typeof 伤害上下文.currentDamage === "number" ? 伤害上下文.currentDamage : 0;
  }, 2000);
  addDelayedCallback(秒转毫秒(cfg.E.无敌秒), 移除E无敌修正, 无敌修正ID);

  // 3) 跳跃上升
  开始跳跃上升(ctx);

  // 4) 弹幕发射周期（0.05 秒发射 1 波，共 6 波）
  ctx.发射回调ID = addPeriodicCallback(50, 推进E发射, ctx);

  // 5) 弹幕推进周期（0.02 秒）
  ctx.推进回调ID = addPeriodicCallback(秒转毫秒(cfg.E.弹幕tick秒), 推进所有弹幕, ctx);
}

registerSpellEffectListener(on铃仙E生效);

/**
 * 施法中断清理（SPELL_ENDCAST 触发，正常爆炸后已结束=true 幂等跳过）。
 * 复用 `清理E上下文`：移除上升/下降/发射/推进全部回调、清理弹幕马甲、恢复飞行高度、
 * 从 E上下文表 摘除（带 === ctx 校验）。旧实例中断后不能创建新阶段/移除新实例单位。
 * 施法硬直（SFB_施加通用Buff）与 0.3 秒无敌修正（registerDamageModifier）均有独立到期路径，不在此触碰。
 */
function 铃仙E中断清理(this: void, 施法单位: any, 技能ID数值: number): void {
  if (技能ID数值 !== E技能ID数值) return;
  const ctx = E上下文表[GetHandleId(施法单位)];
  if (ctx == null || ctx.已结束) return;
  清理E上下文(ctx);
}
registerSpellEndcastListener(铃仙E中断清理);

export {};
