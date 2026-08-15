/** @noSelfInFile */

/**
 * 佐佐木小次郎 - W 后撤斩（A0GQ 本体 / A0GR 二段，共享充能 4 秒互切）
 *
 * 源 JASS：`主要技能.j` 触发 zzm-Q 的 A0GQ/A0GR 分支。
 * - 施法生效：黑闪特效、后撤音效 DJ11、刷新瞬移就绪、共享充能切换
 * - 瞬间免疫伤害 0.25 秒并驱散负面 Buff
 * - 在原位置创建分身（W落地行为）：分身落地后对原位置面前 270° 扇形（425 码）
 *   敌人造成 攻击力×1.7 技能伤害（无硬直，源 JASS 无 Buff 21）
 * - 自身以 4250 码/秒向背后冲锋 425 码（0.1 秒，地形阻挡即停）
 */

import { 佐佐木单位技能配置 } from "./00．配置";
import { 播放佐佐木坐标音效 } from "./00A．表现工具";
import { 是佐佐木本体, 创建佐佐木分身, 刷新瞬移就绪 } from "./00B．分身与状态管理";

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
const { 开始冲锋 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, unit: any, params: any) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: {
    模型路径: string;
    X: number;
    Y: number;
    Z?: number;
    面向角度?: number;
    缩放?: number;
    持续秒?: number;
  }) => any;
};
const { YDWESetUnitAbilityStateSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWESetUnitAbilityStateSafe: (this: void, unit: any, abilityId: number, stateType: number, value: number) => boolean;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { 移除单位负面Buff } = require("系统.05．Buff系统.05．Buff清除函数") as {
  移除单位负面Buff: (this: void, unit: any, onlyPurgable?: boolean) => number;
};

const W本体技能ID = stringToFourCCSafe(佐佐木单位技能配置.W技能ID);
const W二段技能ID数值 = stringToFourCCSafe(佐佐木单位技能配置.W二段技能ID);

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;

/** 共享充能切换（源 JASS：施放入口 + Trig_zzm_QFunc002Func004Func007T） */
function 切换W技能(this: void, 英雄: any, 施放技能ID: number): void {
  const owner = GetOwningPlayer(英雄);
  if (施放技能ID === W本体技能ID) {
    // 本体施放：隐藏本体，显示二段（冷却归零），4 秒后切回
    SetPlayerAbilityAvailable(owner, W本体技能ID, false);
    SetPlayerAbilityAvailable(owner, W二段技能ID数值, true);
    YDWESetUnitAbilityStateSafe(英雄, W二段技能ID数值, 1, 0.01);
    addDelayedCallback(佐佐木单位技能配置.W.二段窗口秒 * 1000, () => {
      SetPlayerAbilityAvailable(owner, W本体技能ID, true);
      SetPlayerAbilityAvailable(owner, W二段技能ID数值, false);
    });
  } else {
    // 二段施放：隐藏二段，切回本体
    SetPlayerAbilityAvailable(owner, W二段技能ID数值, false);
    SetPlayerAbilityAvailable(owner, W本体技能ID, true);
  }
}

function on佐佐木W生效(this: void, 施法单位: any, 技能ID数值: number): void {
  if (!是佐佐木本体(施法单位)) return;
  if (技能ID数值 !== W本体技能ID && 技能ID数值 !== W二段技能ID数值) return;

  const cfg = 佐佐木单位技能配置.W;
  const 原点X = GetUnitX(施法单位);
  const 原点Y = GetUnitY(施法单位);
  const 面向 = GetUnitFacing(施法单位);
  const 后撤角度 = 面向 + 180;

  // 黑闪特效 + 共享充能切换 + 音效 + 刷新瞬移就绪
  创建点特效({
    模型路径: cfg.起手特效模型,
    X: 原点X,
    Y: 原点Y,
    缩放: cfg.起手特效缩放,
    持续秒: 1,
  });
  切换W技能(施法单位, 技能ID数值);
  播放佐佐木坐标音效(cfg.施法音效路径, 原点X, 原点Y, cfg.施法音效裁断);
  刷新瞬移就绪(施法单位);

  // 瞬间免疫伤害 + 驱散负面效果（0.25 秒后解除免疫）
  YDUserDataSetSafe("unit", 施法单位, "免疫伤害", "boolean", true);
  移除单位负面Buff(施法单位);
  addDelayedCallback(cfg.免伤秒 * 1000, () => {
    if (施法单位 == null || 施法单位 === 0) return;
    YDUserDataSetSafe("unit", 施法单位, "免疫伤害", "boolean", false);
  });

  // 在原位置创建分身（落地后结算原位置扇形伤害）
  创建佐佐木分身(施法单位, 原点X, 原点Y, 面向, "W落地", 技能ID数值);

  // 向背后冲锋 425 码（4250 码/秒，地形阻挡即停）
  开始冲锋(施法单位, {
    距离: cfg.后撤距离,
    每秒速度: cfg.后撤每秒速度,
    角度: 后撤角度,
    检查地形: true,
  });

  // 冲锋结束（425 / 4250 = 0.1 秒）后黑闪特效收尾
  addDelayedCallback(120, () => {
    if (施法单位 == null || 施法单位 === 0) return;
    创建点特效({
      模型路径: cfg.起手特效模型,
      X: GetUnitX(施法单位),
      Y: GetUnitY(施法单位),
      缩放: cfg.起手特效缩放,
      持续秒: 1,
    });
  });
}

registerSpellEffectListener(on佐佐木W生效);

export {};
