/** @noSelfInFile */

import type { 封印守卫战敌人记录 } from "../../../01．杂鱼技能/03．第三章/00．封印守卫战公共/00．类型";
import { 金鳞执刑官配置 } from "./00．配置";
import {
  单位处于硬控制,
  命令攻击目标,
  取两点方向角,
  取单位X,
  取单位Y,
  读取单位攻击力,
  取单位距离平方,
  读取单位生命,
  读取单位最大生命,
  读取封印守卫战敌人记录,
  读取封印守卫战玩家英雄列表,
  封印守卫战单位存活,
  是封印守卫战玩家英雄,
  创建封印守卫战点特效,
  创建封印守卫战单位常驻特效,
  销毁封印守卫战单位常驻特效,
} from "../../../01．杂鱼技能/03．第三章/00．封印守卫战公共/01．共享";

const { 开始充能, 停止单位充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, unit: any, params: any) => number;
  停止单位充能: (this: void, unit: any) => boolean;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, config: any) => any;
};
const { 开始冲锋, 开始击退, 停止单位位移 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, unit: any, params: any) => number;
  开始击退: (this: void, unit: any, params: any) => number;
  停止单位位移: (this: void, unit: any, reason?: string) => boolean;
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, propertyId: number, value: number) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const jass = require("jass.common") as any;
const GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed as (this: void, unit: any) => number;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const 重鳞护体BuffID = "SGW8";
const 移动速度属性ID = 9;
const 护盾特效键 = "第三章-金鳞执刑官-重鳞护体";

function 获取护体状态(this: void, record: 封印守卫战敌人记录): Record<string, any> {
  if (record.附加状态 == null) record.附加状态 = {};
  return record.附加状态;
}

function 清除重鳞护体(this: void, record: 封印守卫战敌人记录, 播放破裂特效: boolean): void {
  const state = record.附加状态?.重鳞护体;
  if (state == null) return;
  if (封印守卫战单位存活(record.单位) && state.移速减少 !== 0) SGSS_SetState(record.单位, 移动速度属性ID, state.移速减少);
  if (封印守卫战单位存活(record.单位)) 移除单位指定Buff(record.单位, 重鳞护体BuffID);
  销毁封印守卫战单位常驻特效(record.单位, 护盾特效键);
  if (播放破裂特效 && 封印守卫战单位存活(record.单位)) 创建封印守卫战点特效({ 模型路径: 金鳞执刑官配置.命中特效, X: 取单位X(record.单位), Y: 取单位Y(record.单位), Z: 0, 缩放: 0.9, 持续秒: 1.2 });
  if (record.附加状态 != null) delete record.附加状态.重鳞护体;
}

function 尝试触发重鳞护体(this: void, record: 封印守卫战敌人记录): void {
  const state = record.附加状态?.重鳞护体;
  if (state != null || record.附加状态?.重鳞护体已触发 === true) return;
  const maxLife = 读取单位最大生命(record.单位);
  if (!(maxLife > 0) || 读取单位生命(record.单位) > maxLife * 金鳞执刑官配置.护体触发生命比例) return;
  const moveLoss = GetUnitDefaultMoveSpeed(record.单位) * 金鳞执刑官配置.护体减速比例;
  获取护体状态(record).重鳞护体已触发 = true;
  获取护体状态(record).重鳞护体 = { 结束毫秒: getServerTime() + 金鳞执刑官配置.护体持续秒 * 1000, 移速减少: moveLoss };
  SGSS_SetState(record.单位, 移动速度属性ID, -moveLoss);
  创建封印守卫战单位常驻特效(record.单位, 金鳞执刑官配置.护盾特效, 护盾特效键);
  registerManualBuff(record.单位, 重鳞护体BuffID, 金鳞执刑官配置.护体持续秒, 金鳞执刑官配置.护体减伤比例, { sourceUnit: record.单位, effectSourceName: "金鳞执刑官-重鳞护体", effectSourceType: "技能" });
}

export function 修正重鳞护体减伤(this: void, context: any): number {
  const record = 读取封印守卫战敌人记录(context?.target);
  if (record == null || record.类型 !== "金鳞执刑官") return context.currentDamage;
  const state = record.附加状态?.重鳞护体;
  if (state == null || getServerTime() >= state.结束毫秒) return context.currentDamage;
  return context.currentDamage * (1 - 金鳞执刑官配置.护体减伤比例);
}

function 金鳞冲阵命中过滤(this: void, _unit: any, target: any, _moveId: number): boolean {
  return 是封印守卫战玩家英雄(target);
}

function 金鳞冲阵命中(this: void, unit: any, target: any, _moveId: number): void {
  if (!封印守卫战单位存活(target)) return;
  创建封印守卫战点特效({ 模型路径: 金鳞执刑官配置.命中特效, X: 取单位X(target), Y: 取单位Y(target), Z: 0, 缩放: 0.75, 持续秒: 1.2 });
  开始击退(target, { 来源单位: unit, 主单位: unit, 距离: 金鳞执刑官配置.冲阵击退距离, 持续时间: 0.35, 检查地形: true, 禁用碰撞: true });
}

function 金鳞冲阵充能周期(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "金鳞执刑官" || record.充能ID !== chargeId) return;
  if (单位处于硬控制(unit)) 停止单位充能(unit);
}

function 金鳞冲阵结束(this: void, unit: any, reason: string, _moveId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "金鳞执刑官") return;
  if (reason === "中断" || reason === "死亡" || reason === "主单位死亡") record.下次技能毫秒 = getServerTime() + 金鳞执刑官配置.技能冷却毫秒;
}

function 金鳞冲阵充能完成(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "金鳞执刑官" || record.充能ID !== chargeId) return;
  record.充能ID = 0;
  const target = record.当前目标;
  record.当前目标 = undefined;
  if (!封印守卫战单位存活(target)) return;
  const angle = 取两点方向角(取单位X(unit), 取单位Y(unit), 取单位X(target), 取单位Y(target));
  开始冲锋(unit, { 角度: angle, 距离: 金鳞执刑官配置.冲阵距离, 持续时间: 金鳞执刑官配置.冲阵持续秒, 检查地形: true, 朝向跟随位移: true, 暂停单位: true, 禁用碰撞: true, 位移特效: 金鳞执刑官配置.冲锋特效, 命中半径: 金鳞执刑官配置.冲阵命中范围, 只命中敌人: true, 允许重复命中: false, 命中伤害: 读取单位攻击力(unit) * 金鳞执刑官配置.冲阵伤害攻击力比例, 伤害来源: unit, 攻击类型: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_NORMAL, 武器类型: WEAPON_TYPE_WHOKNOWS, 技能伤害标记: { 来源类型: "单位技能", 伤害形态: "AOE", 标签: "第三章-金鳞执刑官-金鳞冲阵", 参与技能伤害加成: false }, 命中过滤: 金鳞冲阵命中过滤, 命中回调: 金鳞冲阵命中, 结束回调: 金鳞冲阵结束 });
  record.下次技能毫秒 = getServerTime() + 金鳞执刑官配置.技能冷却毫秒;
}

function 金鳞冲阵充能结束(this: void, unit: any, reason: string, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "金鳞执刑官") return;
  if (record.充能ID === chargeId) record.充能ID = 0;
  record.当前目标 = undefined;
  if (reason !== "完成") record.下次技能毫秒 = getServerTime() + 金鳞执刑官配置.技能冷却毫秒;
}

export function 尝试释放金鳞冲阵(this: void, record: 封印守卫战敌人记录): boolean {
  if (record.充能ID !== 0 || 单位处于硬控制(record.单位)) return false;
  const heroes = 读取封印守卫战玩家英雄列表();
  let target: any = null;
  let distance = 999999999;
  for (let i = 0; i < heroes.length; i++) {
    if (!封印守卫战单位存活(heroes[i])) continue;
    const current = 取单位距离平方(record.单位, heroes[i]);
    if (current < distance) {
      distance = current;
      target = heroes[i];
    }
  }
  if (!封印守卫战单位存活(target)) return false;
  record.当前目标 = target;
  const angle = 取两点方向角(取单位X(record.单位), 取单位Y(record.单位), 取单位X(target), 取单位Y(target));
  创建技能提示圈({ 类型: "方向直线", X: 取单位X(record.单位), Y: 取单位Y(record.单位), 宽度: 金鳞执刑官配置.预警宽度, 长度: 金鳞执刑官配置.预警长度, 朝向: angle, 持续时间: 金鳞执刑官配置.预警秒, 来源单位: record.单位 });
  const id = 开始充能(record.单位, { 持续时间: 金鳞执刑官配置.预警秒, 强制硬直: true, 显示进度条特效: true, 周期回调间隔: 0.1, 周期回调: 金鳞冲阵充能周期, 充能完成回调: 金鳞冲阵充能完成, 结束回调: 金鳞冲阵充能结束 });
  record.充能ID = id;
  return id > 0;
}

export function 刷新金鳞执刑官AI(this: void, record: 封印守卫战敌人记录, 当前毫秒: number): void {
  尝试触发重鳞护体(record);
  const state = record.附加状态?.重鳞护体;
  if (state != null && 当前毫秒 >= state.结束毫秒) 清除重鳞护体(record, true);
  if (record.充能ID !== 0 || 当前毫秒 < record.下次AI毫秒) return;
  record.下次AI毫秒 = 当前毫秒 + 金鳞执刑官配置.AI刷新毫秒;
  if (当前毫秒 >= record.下次技能毫秒 && 尝试释放金鳞冲阵(record)) return;
  const target = 读取封印守卫战玩家英雄列表()[0];
  if (封印守卫战单位存活(target)) {
    record.当前目标 = target;
    命令攻击目标(record.单位, target);
  }
}

export function 清理金鳞执刑官机制(this: void, record: 封印守卫战敌人记录): void {
  if (record.充能ID !== 0 && 封印守卫战单位存活(record.单位)) 停止单位充能(record.单位);
  if (封印守卫战单位存活(record.单位)) 停止单位位移(record.单位, "中断");
  record.充能ID = 0;
  清除重鳞护体(record, false);
  record.当前目标 = undefined;
}
