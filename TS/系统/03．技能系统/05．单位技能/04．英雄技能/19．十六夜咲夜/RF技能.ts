/** @noSelfInFile */

import { 十六夜咲夜基础技能配置 as 配置 } from "./00．配置";
import { 两点角度, 创建直线飞刀, 创建咲夜单位壳, 安全移除单位壳, 极坐标X, 极坐标Y, 单位存活, 播放咲夜单位音效, type 直线飞刀状态 } from "./01．飞刀与时间工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 创建单位与特效环绕, type 单位与特效环绕实例 } from "../../../00．技能模板+函数/01．技能函数/01．弹幕/05．单位与特效环绕/01．单位与特效环绕";

const jass = require("jass.common") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { registerSyncHardwareKey } = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心") as {
  registerSyncHardwareKey: (this: void, key: number, status: number, callback: (this: void, event: { player: any }) => void) => any;
};
const { KEY, KEY_STATE } = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义") as {
  KEY: { F: number };
  KEY_STATE: { DOWN: number };
};
const { 造成单体技能伤害, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, duration: number, effect: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 十六夜咲夜BuffID } = require("系统.05．Buff系统.03．Buff表.02．英雄.19．十六夜咲夜") as {
  十六夜咲夜BuffID: { 光速跃迁锁定: string };
};

interface RF监听上下文 { 占位: boolean; }
interface RF环绕上下文 {
  施法者: any;
  目标: any;
  技能实例ID?: number;
  环绕实例: 单位与特效环绕实例 | null;
  可提前贯穿: boolean;
  已结束: boolean;
}

const RF活动表: Record<number, RF环绕上下文 | undefined> = {};

function 获取RF监听上下文(this: void, _caster: any): RF监听上下文 { return { 占位: true }; }

function 标准化角差(this: void, value: number): number {
  let result = value % 360;
  if (result > 180) result -= 360;
  else if (result < -180) result += 360;
  return result;
}

function RF计算伤害倍率(this: void, knife: any, target: any): { 倍率: number; 正中心: boolean } {
  const knifeFacing = 两点角度(jass.GetUnitX(knife), jass.GetUnitY(knife), jass.GetUnitX(target), jass.GetUnitY(target));
  const difference = Math.abs(标准化角差(jass.GetUnitFacing(target) - knifeFacing));
  if (difference > 配置.RF.背刺边界角度) return { 倍率: 配置.RF.中心伤害攻击力倍率, 正中心: false };
  const ratio = difference / 配置.RF.背刺边界角度;
  return {
    倍率: 配置.RF.中心伤害攻击力倍率 - (配置.RF.中心伤害攻击力倍率 - 配置.RF.边缘伤害攻击力倍率) * ratio,
    正中心: difference <= 配置.RF.正中心背刺角度,
  };
}

function RF贯穿命中(this: void, target: any, state: 直线飞刀状态): "继续" {
  const data = state.自定义数据 as { 伤害: number; 技能实例ID?: number };
  造成单体技能伤害({
    来源: state.参数.施法者,
    目标: target,
    伤害: data.伤害,
    伤害类型: jass.DAMAGE_TYPE_ENHANCED,
    attack: true,
    ranged: true,
    attackType: jass.ATTACK_TYPE_NORMAL,
    weaponType: jass.WEAPON_TYPE_METAL_HEAVY_SLICE,
    来源类型: "单位技能",
    标签: "十六夜咲夜-RF-光速跃迁",
    技能ID: 配置.技能.RF.类型ID,
    技能实例ID: data.技能实例ID,
  });
  return "继续";
}

function 结束RF上下文(this: void, context: RF环绕上下文): void {
  if (context.已结束) return;
  context.已结束 = true;
  const ownerId = jass.GetPlayerId(jass.GetOwningPlayer(context.施法者)) as number;
  if (RF活动表[ownerId] === context) delete RF活动表[ownerId];
  if (context.环绕实例 != null && !context.环绕实例.已结束) context.环绕实例.结束("手动");
  if (context.目标 != null && context.目标 !== 0) 移除单位指定Buff(context.目标, 十六夜咲夜BuffID.光速跃迁锁定);
}

function RF执行贯穿(this: void, variable?: any): void {
  const context = variable as RF环绕上下文 | undefined;
  if (context == null || context.已结束 || context.环绕实例 == null || context.环绕实例.已结束) return;
  const orbitNode = context.环绕实例.节点[0];
  if (orbitNode == null || orbitNode.句柄 == null || orbitNode.句柄 === 0 || !单位存活(context.目标)) {
    结束RF上下文(context);
    结束独立技能伤害实例(context.技能实例ID);
    return;
  }
  const knife = orbitNode.句柄;
  const startX = jass.GetUnitX(knife) as number;
  const startY = jass.GetUnitY(knife) as number;
  const angle = 两点角度(startX, startY, jass.GetUnitX(context.目标), jass.GetUnitY(context.目标));
  const damage = 读取单位攻击力(context.施法者) * RF计算伤害倍率(knife, context.目标).倍率;
  结束RF上下文(context);
  const state = 创建直线飞刀({
    施法者: context.施法者,
    单位类型ID: 配置.单位壳.光速红刀,
    X: startX,
    Y: startY,
    角度: angle,
    周期毫秒: 配置.RF.贯穿周期毫秒,
    每Tick位移: 配置.RF.贯穿每Tick位移,
    最大距离: 配置.RF.贯穿每Tick位移 * 配置.RF.贯穿Tick,
    命中半径: 配置.RF.贯穿命中半径,
    命中去重: true,
    命中回调: RF贯穿命中,
    结束回调: function RF贯穿结束(this: void): void { 结束独立技能伤害实例(context.技能实例ID); },
  });
  if (state == null) 结束独立技能伤害实例(context.技能实例ID);
  else state.自定义数据 = { 伤害: damage, 技能实例ID: context.技能实例ID };
  播放咲夜单位音效("gg_snd_IzayoiSakuya_RF", context.施法者);
}

function RF开放提前贯穿(this: void, variable?: any): void {
  const context = variable as RF环绕上下文 | undefined;
  if (context != null && !context.已结束) context.可提前贯穿 = true;
}

function RF初始命中(this: void, target: any, state: 直线飞刀状态): "结束" {
  (state.自定义数据 as { 技能实例ID?: number; 已锁定: boolean }).已锁定 = true;
  const context: RF环绕上下文 = {
    施法者: state.参数.施法者,
    目标: target,
    技能实例ID: (state.自定义数据 as { 技能实例ID?: number }).技能实例ID,
    环绕实例: null,
    可提前贯穿: false,
    已结束: false,
  };
  const shell = 创建咲夜单位壳(context.施法者, 配置.单位壳.光速红刀, jass.GetUnitX(target) + 配置.RF.环绕半径, jass.GetUnitY(target), 90);
  if (shell == null || shell === 0) {
    结束独立技能伤害实例(context.技能实例ID);
    return "结束";
  }
  context.环绕实例 = 创建单位与特效环绕({
    中心单位: target,
    节点: [{ 类型: "单位", 单位: shell, 半径: 配置.RF.环绕半径, 朝向模式: "沿切线", 自动销毁: true }],
    半径: 配置.RF.环绕半径,
    角速度: 配置.RF.环绕角速度,
    周期毫秒: 配置.RF.初始周期毫秒,
    持续秒: 配置.RF.自动贯穿秒 + 0.2,
  });
  if (context.环绕实例 == null) {
    安全移除单位壳(shell);
    结束独立技能伤害实例(context.技能实例ID);
    return "结束";
  }
  RF活动表[jass.GetPlayerId(jass.GetOwningPlayer(context.施法者)) as number] = context;
  registerManualBuff(target, 十六夜咲夜BuffID.光速跃迁锁定, 配置.RF.自动贯穿秒, 0, { sourceUnit: context.施法者 });
  addDelayedCallback(配置.RF.可提前贯穿秒 * 1000, RF开放提前贯穿, context);
  addDelayedCallback(配置.RF.自动贯穿秒 * 1000, RF执行贯穿, context);
  播放咲夜单位音效("gg_snd_IzayoiSakuya_RF2", context.施法者);
  return "结束";
}

function onRF同步F键(this: void, event: { player: any }): void {
  if (event.player == null || event.player === 0) return;
  const context = RF活动表[jass.GetPlayerId(event.player) as number];
  if (context != null && context.可提前贯穿 && jass.GetOwningPlayer(context.施法者) === event.player) RF执行贯穿(context);
}

function 释放十六夜咲夜RF(this: void, _listener: RF监听上下文, caster: any, 技能实例ID?: number): void {
  const x = jass.GetUnitX(caster) as number;
  const y = jass.GetUnitY(caster) as number;
  const angle = 两点角度(x, y, jass.GetSpellTargetX(), jass.GetSpellTargetY());
  const state = 创建直线飞刀({
    施法者: caster,
    单位类型ID: 配置.单位壳.光速红刀,
    X: 极坐标X(x, 配置.RF.初始创建距离, angle),
    Y: 极坐标Y(y, 配置.RF.初始创建距离, angle),
    角度: angle,
    周期毫秒: 配置.RF.初始周期毫秒,
    每Tick位移: 配置.RF.初始每Tick位移,
    最大距离: 配置.RF.初始最大距离,
    命中半径: 配置.RF.命中半径,
    命中去重: true,
    命中回调: RF初始命中,
    结束回调: function RF未锁定结束(this: void, ended: 直线飞刀状态): void {
      if (ended.自定义数据 != null && ended.自定义数据.已锁定 !== true) 结束独立技能伤害实例(技能实例ID);
    },
  });
  if (state == null) {
    结束独立技能伤害实例(技能实例ID);
    return;
  }
  state.自定义数据 = { 技能实例ID, 已锁定: false };
  播放咲夜单位音效("gg_snd_feidaoYX", caster);
}

export function 注册十六夜咲夜RF(this: void): void {
  registerSyncHardwareKey(KEY.F, KEY_STATE.DOWN, onRF同步F键);
  注册单位技能壳监听({ 名称: "十六夜咲夜-光速跃迁（RF）", 单位类型ID: 配置.英雄单位类型ID, 技能ID: 配置.技能.RF.类型ID, 获取或创建上下文: 获取RF监听上下文, 释放技能: 释放十六夜咲夜RF, 创建独立技能实例: true, 独立技能来源类型: "单位技能", 技能实例持续时间秒: 9 });
}

注册十六夜咲夜RF();

export {};
