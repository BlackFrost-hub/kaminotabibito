/** @noSelfInFile */

/**
 * 佐佐木小次郎 - Q 前斩（A0GS 本体 / A0GT 二段，共享充能 4 秒互切）
 *
 * 源 JASS：`主要技能.j` 触发 zzm-Q 的 A0GS/A0GT 分支。
 * 流程（施法生效起）：
 * - t=0：刷新瞬移就绪、黑闪特效
 * - t≈10ms：自身施法眩晕 0.6 秒、随机挥砍动作（7/8）、蓄力特效（CharmTarget @4.25 倍速）
 * - t≈210ms：在原地创建分身（瞬移前先创建分身，见 00B）
 * - t≈310ms：挥砍音效（DK27/DK26）、沿 40 码步长做地形检查后瞬移到目标点，
 *   对落点 270° 扇形（500 码）敌人造成 攻击力×1.7 技能伤害 + 0.3 秒硬直；
 *   若处于「瞬移后」窗口（1 秒内右键换位过），额外发射一道剑气弹幕
 *   （速度 1732.5 码/秒、最大 1386 码、飞行 350 码后起伤、半径 175、攻击力×1.7 攻击效果伤害）
 * - t≈610ms：共享充能切换（本体施放 → 显示二段 A0GT 并 4 秒后切回；二段施放 → 切回本体）
 */

import { 佐佐木单位技能配置 } from "./00．配置";
import { 播放佐佐木坐标音效, 播放佐佐木配置动作 } from "./00A．表现工具";
import {
  是佐佐木本体,
  佐佐木扇形伤害,
  创建佐佐木分身,
  刷新瞬移就绪,
  消耗瞬移后标记,
} from "./00B．分身与状态管理";

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
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 读取单位攻击力, 单位存活, 距离XY, 两点角度, 极坐标X, 极坐标Y } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  距离XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  极坐标X: (this: void, x: number, angleDeg: number, distance: number) => number;
  极坐标Y: (this: void, y: number, angleDeg: number, distance: number) => number;
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
    缩放?: number;
    持续秒?: number;
    动画速度?: number;
  }) => any;
};
const { YDWESetUnitAbilityStateSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWESetUnitAbilityStateSafe: (this: void, unit: any, abilityId: number, stateType: number, value: number) => boolean;
};

const Q本体技能ID = stringToFourCCSafe(佐佐木单位技能配置.Q技能ID);
const Q二段技能ID数值 = stringToFourCCSafe(佐佐木单位技能配置.Q二段技能ID);
const 随机整数 = jass.GetRandomInt as (this: void, low: number, high: number) => number;

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

/** 地形可通行判定（不可通行 = 阻挡） */
function 地形可通行(this: void, x: number, y: number): boolean {
  if (typeof jass.IsTerrainPathable !== "function") return true;
  return !jass.IsTerrainPathable(x, y, jass.PATHING_TYPE_WALKABILITY as any);
}

/**
 * 沿施法方向做 40 码步长地形检查，返回最终落点（阻挡时停在最后一个可通行点）。
 * 源 JASS：Trig_zzm_QFunc001Func018Func007Func009Func005T 的循环判定。
 */
function 计算瞬移落点(this: void, 起点X: number, 起点Y: number, 角度: number, 距离: number): [number, number] {
  let 落点X = 起点X;
  let 落点Y = 起点Y;
  const 步数 = jass.R2I(距离 / 40);
  for (let i = 1; i <= 步数; i++) {
    const 候选X = 极坐标X(起点X, 角度, 40 * i);
    const 候选Y = 极坐标Y(起点Y, 角度, 40 * i);
    if (!地形可通行(候选X, 候选Y)) break;
    落点X = 候选X;
    落点Y = 候选Y;
  }
  return [落点X, 落点Y];
}

/** 共享充能切换（t≈610ms；源 JASS：Trig_zzm_QFunc001Func018Func007Func009Func008T） */
function 切换Q技能(this: void, 英雄: any, 施放技能ID: number): void {
  const owner = GetOwningPlayer(英雄);
  if (施放技能ID === Q本体技能ID) {
    // 本体施放：隐藏本体，显示二段（冷却归零），4 秒后切回
    SetPlayerAbilityAvailable(owner, Q本体技能ID, false);
    SetPlayerAbilityAvailable(owner, Q二段技能ID数值, true);
    YDWESetUnitAbilityStateSafe(英雄, Q二段技能ID数值, 1, 0.01);
    addDelayedCallback(佐佐木单位技能配置.Q.二段窗口秒 * 1000, () => {
      if (!单位存活(英雄)) return;
      SetPlayerAbilityAvailable(owner, Q本体技能ID, true);
      SetPlayerAbilityAvailable(owner, Q二段技能ID数值, false);
    });
  } else {
    // 二段施放：隐藏二段，切回本体
    SetPlayerAbilityAvailable(owner, Q二段技能ID数值, false);
    SetPlayerAbilityAvailable(owner, Q本体技能ID, true);
  }
}

/** 发射剑气（瞬移后窗口内附加；源 JASS 刀光2 e07U 弹幕 → TS 原生弹幕） */
function 发射佐佐木剑气(this: void, 英雄: any, 起点X: number, 起点Y: number, 角度: number, 技能ID: number): void {
  const cfg = 佐佐木单位技能配置.Q.剑气;
  创建原生弹幕({
    所有者: 英雄,
    X: 起点X,
    Y: 起点Y,
    方向角: 角度,
    速度: cfg.速度,
    最大距离: cfg.最大飞行距离,
    命中半径: cfg.命中半径,
    影响目标: "敌方",
    每单位最大命中次数: 1,
    不可阻挡: true,
    伤害值: 读取单位攻击力(英雄) * cfg.攻击力倍率,
    attack: true,
    攻击类型: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID,
    标签: "佐佐木小次郎-剑气",
    伤害形态: "单体",
    参与技能伤害加成: true,
    模型: cfg.模型,
    缩放: 1,
    // 飞行 350 码后才开始造成伤害
    目标筛选: (目标单位: any, 弹幕ID: number) => {
      const 实例 = 获取原生弹幕(弹幕ID);
      if (实例 == null) return true;
      return 实例.已飞行距离 >= cfg.起伤距离;
    },
  });
}

function on佐佐木Q生效(this: void, 施法单位: any, 技能ID数值: number): void {
  if (!是佐佐木本体(施法单位)) return;
  if (技能ID数值 !== Q本体技能ID && 技能ID数值 !== Q二段技能ID数值) return;

  const cfg = 佐佐木单位技能配置.Q;
  const 起点X = GetUnitX(施法单位);
  const 起点Y = GetUnitY(施法单位);
  const 目标X = jass.GetSpellTargetX() as number;
  const 目标Y = jass.GetSpellTargetY() as number;
  const 角度 = 两点角度(起点X, 起点Y, 目标X, 目标Y);
  const 距离 = 距离XY(起点X, 起点Y, 目标X, 目标Y);

  // 刷新瞬移技能间隔 + 黑闪特效
  刷新瞬移就绪(施法单位);
  创建点特效({
    模型路径: 佐佐木单位技能配置.D.换位特效模型,
    X: 起点X,
    Y: 起点Y,
    缩放: 佐佐木单位技能配置.D.换位特效缩放,
    持续秒: 1,
  });

  // t≈10ms：施法眩晕 + 挥砍动作 + 蓄力特效
  addDelayedCallback(10, () => {
    if (!单位存活(施法单位)) return;
    施加眩晕(施法单位, 施法单位, 0.6, "佐佐木前斩", "技能");
    播放佐佐木配置动作(施法单位, 随机整数(0, 1) === 0 ? 8 : 7, 0);
    创建点特效({
      模型路径: cfg.蓄力特效模型,
      X: GetUnitX(施法单位),
      Y: GetUnitY(施法单位),
      动画速度: cfg.蓄力特效速度,
      持续秒: cfg.蓄力特效持续秒,
    });
  });

  // t≈210ms：瞬移前先创建分身（原地行为：留在起点）
  addDelayedCallback(210, () => {
    if (!单位存活(施法单位)) return;
    创建佐佐木分身(施法单位, 起点X, 起点Y, 角度, "原地", 技能ID数值);
  });

  // t≈310ms：挥砍音效 → 地形检查瞬移 → 落点扇形伤害 → 瞬移后窗口附加剑气
  addDelayedCallback(310, () => {
    if (!单位存活(施法单位)) return;
    if (随机整数(0, 1) === 0) {
      播放佐佐木坐标音效(cfg.挥砍音效路径1, GetUnitX(施法单位), GetUnitY(施法单位), cfg.挥砍音效裁断);
    } else {
      播放佐佐木坐标音效(cfg.挥砍音效路径2, GetUnitX(施法单位), GetUnitY(施法单位), cfg.挥砍音效裁断);
    }

    const 落点坐标 = 计算瞬移落点(起点X, 起点Y, 角度, 距离);
    const 落点X = 落点坐标[0];
    const 落点Y = 落点坐标[1];
    创建点特效({
      模型路径: 佐佐木单位技能配置.D.换位特效模型,
      X: 落点X,
      Y: 落点Y,
      缩放: 佐佐木单位技能配置.D.换位特效缩放,
      持续秒: 1,
    });
    SetUnitX(施法单位, 落点X);
    SetUnitY(施法单位, 落点Y);

    佐佐木扇形伤害(
      施法单位,
      落点X,
      落点Y,
      角度,
      cfg.命中范围,
      cfg.扇形半角,
      cfg.攻击力倍率,
      技能ID数值,
      "佐佐木小次郎-前斩",
      cfg.命中特效模型,
      cfg.命中特效缩放,
      cfg.硬直秒,
    );

    if (消耗瞬移后标记(施法单位)) {
      发射佐佐木剑气(施法单位, 落点X, 落点Y, 角度, 技能ID数值);
    }
  });

  // t≈610ms：共享充能切换
  addDelayedCallback(610, () => {
    if (!单位存活(施法单位)) return;
    切换Q技能(施法单位, 技能ID数值);
  });
}

registerSpellEffectListener(on佐佐木Q生效);

export {};
