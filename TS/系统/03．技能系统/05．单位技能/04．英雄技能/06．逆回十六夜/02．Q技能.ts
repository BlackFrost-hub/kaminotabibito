/** @noSelfInFile */

import { 逆回十六夜单位技能配置 } from "./00．配置";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 开始跳跃 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.03．对外接口") as {
  开始跳跃: (this: void, unit: any, params: any) => number;
};
const { 开始牵引 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.01．牵引系统.03．对外接口") as {
  开始牵引: (this: void, unit: any, params: any) => number;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
};
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 施加眩晕, 施加减速 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
  施加减速: (this: void, source: any, target: any, ratio: number, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 读取单位攻击力, 单位存活, 距离XY } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  距离XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

const GetSpellTargetX = jass.GetSpellTargetX as () => number;
const GetSpellTargetY = jass.GetSpellTargetY as () => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (unit: any) => number;
const GetHeroStr = jass.GetHeroStr as (unit: any, includeBonuses: boolean) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const Q技能类型ID = stringToFourCCSafe(逆回十六夜单位技能配置.Q技能ID);

function 播放单位全局音效(this: void, unit: any, soundKey: string): void {
  const soundHandle = jglobals[soundKey];
  if (unit == null || unit === 0 || soundHandle == null || soundHandle === 0) return;
  jass.AttachSoundToUnit(soundHandle, unit);
  jass.SetSoundVolume(soundHandle, 127);
  jass.StartSound(soundHandle);
}

interface Q上下文 { unit: any; }
interface Q延迟启动变量 {
  unit: any;
  targetX: number;
  targetY: number;
  技能实例ID?: number;
}
interface Q跳跃记录 {
  unit: any;
  初始飞行高度: number;
  伤害: number;
  技能实例ID?: number;
}
interface Q命中处理变量 {
  施法者: any;
  中心X: number;
  中心Y: number;
  配置: typeof 逆回十六夜单位技能配置.Q;
}

const Q跳跃记录表: Record<number, Q跳跃记录 | undefined> = {};

function 获取Q上下文(this: void, unit: any): Q上下文 {
  return { unit };
}

function 处理逆回十六夜Q目标结算后(this: void, target: any, _index: number, _成功: boolean, variable?: any): void {
  const 变量 = variable as Q命中处理变量 | undefined;
  if (变量 == null) return;
  施加减速(变量.施法者, target, 变量.配置.减速比例, 变量.配置.减速持续秒, "跳跃重击", "技能");
  施加眩晕(变量.施法者, target, 变量.配置.打断眩晕秒, "跳跃重击", "技能");
  开始牵引(target, {
    中心X: 变量.中心X, 中心Y: 变量.中心Y, 主单位: 变量.施法者, 主单位死亡时中断: true,
    持续时间: 变量.配置.牵引持续秒, 每秒速度: 变量.配置.牵引距离 / 变量.配置.牵引持续秒,
    最大牵引距离: 变量.配置.牵引距离, 到达距离: 32, 检查地形: true,
    禁用碰撞: true, 暂停单位: false,
  });
}

function 播放逆回十六夜Q动作(this: void, unit: any, _跳跃ID: number): void {
  const cfg = 逆回十六夜单位技能配置.Q;
  if (!单位存活(unit)) return;
  SetUnitTimeScale(unit, cfg.动作速度);
  SetUnitAnimationByIndex(unit, cfg.动作编号);
}

function 处理逆回十六夜Q跳跃结束(this: void, caster: any, reason: string, jumpId: number): void {
  const record = Q跳跃记录表[jumpId];
  delete Q跳跃记录表[jumpId];
  if (record == null || !单位存活(caster) || (reason !== "完成" && reason !== "阻挡")) return;

  const cfg = 逆回十六夜单位技能配置.Q;
  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  SetUnitTimeScale(caster, 1);
  for (let i = 0; i < cfg.全局音效键.length; i++) 播放单位全局音效(caster, cfg.全局音效键[i]);
  创建点特效({
    模型路径: cfg.落地特效, X: x, Y: y, Z: record.初始飞行高度,
    缩放: cfg.落地特效缩放, 持续秒: cfg.落地特效持续秒,
  });
  const targets = getEnemyUnitsInRange(caster, x, y, cfg.落地半径);
  造成批量AOE技能伤害({
    来源: caster, 目标列表: targets, 伤害: record.伤害, 伤害类型: DAMAGE_TYPE_ENHANCED,
    来源类型: "单位技能", 技能ID: Q技能类型ID,
    技能实例ID: record.技能实例ID, 参与技能伤害加成: true, 标签: "逆回十六夜-跳跃重击",
    每目标结算后处理器: 处理逆回十六夜Q目标结算后,
    变量: { 施法者: caster, 中心X: x, 中心Y: y, 配置: cfg },
  });
}

function 启动逆回十六夜Q跳跃(this: void, variable?: any): void {
  const start = variable as Q延迟启动变量 | undefined;
  if (start == null || !单位存活(start.unit)) return;

  const cfg = 逆回十六夜单位技能配置.Q;
  const startX = GetUnitX(start.unit);
  const startY = GetUnitY(start.unit);
  const distance = 距离XY(startX, startY, start.targetX, start.targetY);
  const actualDistance = distance < cfg.最大位移距离 ? distance : cfg.最大位移距离;
  const record: Q跳跃记录 = {
    unit: start.unit,
    初始飞行高度: GetUnitFlyHeight(start.unit),
    伤害: 读取单位攻击力(start.unit) * cfg.攻击力倍率 + GetHeroStr(start.unit, true) * cfg.力量倍率,
    技能实例ID: start.技能实例ID,
  };

  const jumpId = 开始跳跃(start.unit, {
    目标X: start.targetX, 目标Y: start.targetY, 距离: actualDistance,
    持续时间: cfg.位移持续秒, 跳跃高度: cfg.跳跃高度,
    暂停单位: true, 朝向跟随跳跃: true,
    开始回调: 播放逆回十六夜Q动作,
    结束回调: 处理逆回十六夜Q跳跃结束,
  });
  if (jumpId > 0) Q跳跃记录表[jumpId] = record;
}

function 释放跳跃重击(this: void, _context: Q上下文, unit: any, 技能实例ID?: number): void {
  const cfg = 逆回十六夜单位技能配置.Q;
  const targetX = GetSpellTargetX();
  const targetY = GetSpellTargetY();
  addDelayedCallback(cfg.启动延迟秒 * 1000, 启动逆回十六夜Q跳跃, {
    unit, targetX, targetY, 技能实例ID,
  } as Q延迟启动变量);
}

export function 注册逆回十六夜Q(this: void): void {
  注册单位技能壳监听({
    名称: "逆回十六夜-跳跃重击", 单位类型ID: 逆回十六夜单位技能配置.单位类型ID,
    技能ID: 逆回十六夜单位技能配置.Q技能ID, 获取或创建上下文: 获取Q上下文,
    释放技能: 释放跳跃重击, 创建独立技能实例: true, 独立技能来源类型: "单位技能",
  });
}

注册逆回十六夜Q();
