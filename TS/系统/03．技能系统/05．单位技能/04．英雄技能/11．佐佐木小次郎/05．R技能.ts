/** @noSelfInFile */

/**
 * 佐佐木小次郎 - R 燕返（A0GP）
 *
 * 源 JASS：`主要技能.j` 触发 zzm-Q 的 A0GP 分支
 * （Trig_zzm_QFunc003Func002T / Func005T / Func005Func001Func011T）。
 * 流程：
 * - 施放：播放 ZZMR1、动作 6、自身硬直（防御姿态），开启 0.68 秒受击窗口
 * - 窗口内受到任意伤害 → 标记「平行次元反击」；0.70 秒时结算：
 *   - 未触发：恢复动作与时间缩放（硬直自然到期）
 *   - 触发燕返：无敌 + 0.55 倍速 + ZZMR2，依次发射三道燕返刀光弹幕
 *     （0.4 秒间隔；前两击角度 ±40°、速度 1732.5、半径 200、硬直 0.65 秒；
 *      第三击 0°、速度 2310、半径 275、硬直 1 秒、缩放 2.5），
 *     每击造成 攻击力×1.5 技能伤害并附加硬直
 *   - 结束后恢复无敌/动作/时间缩放
 */

import { 佐佐木单位技能配置 } from "./00．配置";
import { 播放佐佐木坐标音效, 播放佐佐木配置动作, 播放佐佐木全局音效 } from "./00A．表现工具";
import { 是佐佐木本体 } from "./00B．分身与状态管理";
import { 佐佐木小次郎BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/11．佐佐木小次郎";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { registerDamageCallback } = require("系统.04．伤害系统.01．伤害事件") as {
  registerDamageCallback: (this: void, cb: (this: void, unit: any, damage: number, damageType: number, fromDotTickBatch?: boolean, source?: any, isNormalAttack?: boolean) => void, intervalSeconds?: number) => void;
};
const { SFB_施加通用Buff } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_施加通用Buff: (this: void, 来源单位: any, 目标单位: any, Buff类型: number, 持续时间: number) => void;
};
const { 创建原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, 参数: any) => any;
};
const { 读取单位攻击力, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, u: any, 来源: string) => boolean;
  移除单位暂停: (this: void, u: any, 来源: string) => boolean;
};

const R技能ID数值 = stringToFourCCSafe(佐佐木单位技能配置.R技能ID);

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, unit: any, flag: boolean) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, name: string) => void;

//=============================================================================
// 一、受击窗口状态（防御窗口内首次受伤 → 标记反击）
//=============================================================================

/** 防御窗口开启中（0.68 秒内为 true） */
const R防御窗口表: Record<number, boolean | undefined> = {};
/** 窗口内已受击（燕返触发标记，0.70 秒结算时消耗） */
const R反击标记表: Record<number, boolean | undefined> = {};

registerDamageCallback((unit: any) => {
  if (unit == null || unit === 0) return;
  const id = GetHandleId(unit);
  if (R防御窗口表[id] !== true) return;
  R防御窗口表[id] = false;
  R反击标记表[id] = true;
});

//=============================================================================
// 二、燕返三击
//=============================================================================

/** 发射一道燕返刀光弹幕（源 e07V/e07U 刀光对 → TS 原生弹幕） */
function 发射燕返刀光(this: void, 英雄: any, 起点X: number, 起点Y: number, 角度: number, 击序: number): void {
  const cfg = 佐佐木单位技能配置.R;
  const 击 = cfg.三击[击序];

  // 音效：前两击 DK6，最后一击 DK52（源在英雄位置播放）
  播放佐佐木坐标音效(击.音效路径, GetUnitX(英雄), GetUnitY(英雄), cfg.三击音效裁断);

  const 弹幕参数 = {
    所有者: 英雄,
    X: 起点X,
    Y: 起点Y,
    方向角: 角度 + 击.角度偏移,
    速度: 击.速度,
    最大距离: 击.最大飞行距离,
    命中半径: 击.命中半径,
    影响目标: "敌方",
    每单位最大命中次数: 1,
    不可阻挡: true,
    伤害值: 读取单位攻击力(英雄) * cfg.攻击力倍率,
    attack: true,
    攻击类型: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: R技能ID数值,
    标签: "佐佐木小次郎-燕返",
    伤害形态: "单体",
    参与技能伤害加成: true,
    // 源 e07V「蓝色刀光（冰）」主模型 + e07U「剑气」伴随（最后一击缩放 2.5）
    模型: cfg.刀光特效模型,
    缩放: 1.5, // 源 e07V modelScale 1.5
    // 注：不设飞行高度——eaaa 马甲物编移动类型不支持飞行高度（见菲尼克斯尔复盘），设了会被拖回地面
    附加特效1: {
      模型: cfg.剑气伴随模型,
      缩放: 击.缩放, // 源 e07U：基础 1.5 / 最后一击 SetUnitScale 2.5
      跟随主弹幕参数: true,
    },
    // 命中硬直（源控制效果 0.65 / 0.65 / 1.00）
    on命中: (目标单位: any) => {
      SFB_施加通用Buff(英雄, 目标单位, 21, 击.硬直秒);
    },
  } as const;
  创建原生弹幕(弹幕参数);
}

/** 触发燕返：无敌 + 0.55 倍速 + 三连刀光（源 Trig_zzm_QFunc003Func002Func005T） */
function 触发燕返(this: void, 英雄: any): void {
  const cfg = 佐佐木单位技能配置.R;

  SetUnitInvulnerable(英雄, true);
  // 源 JASS 依靠永久硬直保持动作 6；项目暂停下需在反击成功时显式重播，否则会回到 stand。
  播放佐佐木配置动作(英雄, cfg.反击动作索引, cfg.反击动作速度);
  // 源 JASS：燕返期间不重复眩晕，沿用入口「添加单位暂停」（结算时仍处于硬直中），结束清理时统一「移除单位暂停」
  播放佐佐木全局音效(cfg.燕返触发音效键);

  // 刀光起点：本体位置 + 25 码（面朝+90°方向）再 +50 码（面朝方向）
  // 源 JASS: PolarProjectionBJ(saber位置, 25.00, 角度+90) → 结果再 PolarProjectionBJ(50, 角度+0)
  const 角度 = GetUnitFacing(英雄);
  const 弧度_角度 = 角度 * Math.PI / 180;
  const 弧度_角度加90 = (角度 + 90) * Math.PI / 180;
  const 起点X = GetUnitX(英雄) + Math.cos(弧度_角度加90) * 25 + Math.cos(弧度_角度) * 50;
  const 起点Y = GetUnitY(英雄) + Math.sin(弧度_角度加90) * 25 + Math.sin(弧度_角度) * 50;

  for (let 击序 = 0; 击序 < cfg.三击.length; 击序++) {
    // 通过 variable 参数按迭代捕获击序，避免 Lua 闭包捕获共享循环变量导致越界
    addDelayedCallback(Math.round((击序 + 1) * cfg.三击间隔秒 * 1000), (当前击序: any) => {
      if (!单位存活(英雄)) return;
      发射燕返刀光(英雄, 起点X, 起点Y, 角度, 当前击序 as number);
    }, 击序);
  }

  // 三击结束后恢复（源 0.40×4 时长后清理，即最后一击后再过一个间隔）
  addDelayedCallback(Math.round((cfg.三击.length + 1) * cfg.三击间隔秒 * 1000), () => {
    if (英雄 == null || 英雄 === 0 || !单位存活(英雄)) return;
    SetUnitInvulnerable(英雄, false);
    SetUnitTimeScale(英雄, 1.0);
    SetUnitAnimation(英雄, "stand");
    移除单位暂停(英雄, "佐佐木R燕返防御"); // 源 JASS: YDWEUnitRemoveStun 解除防御姿态硬直
  });
}

//=============================================================================
// 三、施放入口
//=============================================================================

function on佐佐木R生效(this: void, 施法单位: any, 技能ID数值: number): void {
  if (!是佐佐木本体(施法单位)) return;
  if (技能ID数值 !== R技能ID数值) return;

  const cfg = 佐佐木单位技能配置.R;
  const id = GetHandleId(施法单位);

  // 防御姿态：ZZMR1 + 动作 6 + 自身暂停（硬直），开启 0.68 秒受击窗口
  // 源 JASS: YDWEUnitAddStun 永久硬直 → TS 走项目暂停系统（添加单位暂停），
  // 0.70s 未触发或燕返结束后用「移除单位暂停」统一解除（对应 YDWEUnitRemoveStun）
  播放佐佐木全局音效(cfg.防御姿态音效键);
  播放佐佐木配置动作(施法单位, cfg.防御动作索引, 0);
  添加单位暂停(施法单位, "佐佐木R燕返防御");
  R防御窗口表[id] = true;
  R反击标记表[id] = false;
  registerManualBuff(施法单位, 佐佐木小次郎BuffID.燕返守卫, cfg.防御窗口秒, 0);
  addDelayedCallback(Math.round(cfg.防御窗口秒 * 1000), () => {
    R防御窗口表[id] = false;
  });

  // 0.70 秒后结算：受击 → 燕返；未受击 → 恢复
  addDelayedCallback(700, () => {
    R防御窗口表[id] = false;
    移除单位指定Buff(施法单位, 佐佐木小次郎BuffID.燕返守卫);
    if (!单位存活(施法单位)) return;
    if (R反击标记表[id] === true) {
      R反击标记表[id] = false;
      触发燕返(施法单位);
    } else {
      // 源 JASS 未触发分支：重置动作 + 时间缩放 + YDWEUnitRemoveStun（→ 移除单位暂停）解除硬直
      SetUnitTimeScale(施法单位, 1.0);
      SetUnitAnimation(施法单位, "stand");
      移除单位暂停(施法单位, "佐佐木R燕返防御");
    }
  });
}

registerSpellEffectListener(on佐佐木R生效);

export {};
