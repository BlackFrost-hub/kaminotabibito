/** @noSelfInFile */

import { 逆回十六夜单位技能配置 } from "./00．配置";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { YDWETimerDestroyUnit } = require("lib.扩展函数.YDWE函数.07．YDWETimerDestroyUnit") as {
  YDWETimerDestroyUnit: (this: void, duration: number, unit: any) => void;
};
const { 沿角度步进直到地形阻挡 } = require("lib.扩展函数.封装函数.01．通用工具.11．地形步进") as {
  沿角度步进直到地形阻挡: (this: void, params: any) => {
    最终X: number;
    最终Y: number;
    实际步数: number;
    是否提前停止: boolean;
  };
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 造成单体技能伤害, 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
  造成批量AOE技能伤害: (this: void, params: any) => number;
};
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 读取单位攻击力, 单位存活, 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};

const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const W技能类型ID = stringToFourCCSafe(逆回十六夜单位技能配置.W技能ID);
const W暂停来源 = "逆回十六夜-重拳击飞";

interface W上下文 { unit: any; }
interface W施法记录 {
  unit: any;
  target: any;
  active: boolean;
  angle: number;
  initialFlyHeight: number;
  attack: number;
  skillInstanceId?: number;
  阶段回调ID: number;
  阶段: "第一段目标移动" | "第二段自身移动" | "第二段AOE";
  循环计数: number;
  第二段AOE回调ID: number;
  第二段循环计数: number;
  已命中目标: Record<number, boolean>;
  已撞墙目标: Record<number, boolean>;
  第二段目标列表: any[];
}

const W当前施法表: Record<number, W施法记录 | undefined> = {};

function 获取W上下文(this: void, unit: any): W上下文 {
  return { unit };
}

function 播放W全局音效(this: void, unit: any, soundKey: string): void {
  const soundHandle = jglobals[soundKey];
  if (unit == null || unit === 0 || soundHandle == null || soundHandle === 0) return;
  jass.AttachSoundToUnit(soundHandle, unit);
  jass.SetSoundVolume(soundHandle, 127);
  jass.StartSound(soundHandle);
}

function 创建W表现单位(this: void, owner: any, typeId: string, x: number, y: number, facing: number): any {
  const 表现单位 = 创建单位并登记排泄安全(owner, stringToFourCCSafe(typeId), x, y, facing);
  if (表现单位 != null && 表现单位 !== 0) {
    YDWETimerDestroyUnit(逆回十六夜单位技能配置.W.表现单位持续秒, 表现单位);
  }
  return 表现单位;
}

function 结束W施法(this: void, record: W施法记录): void {
  if (!record.active) return;
  record.active = false;
  if (record.阶段回调ID > 0) {
    removePeriodicCallback(record.阶段回调ID);
    record.阶段回调ID = 0;
  }
  if (record.第二段AOE回调ID > 0) {
    removePeriodicCallback(record.第二段AOE回调ID);
    record.第二段AOE回调ID = 0;
  }
  const unitId = record.unit != null && record.unit !== 0 ? GetHandleId(record.unit) : 0;
  if (unitId > 0 && W当前施法表[unitId] === record) delete W当前施法表[unitId];
  if (单位存活(record.unit)) {
    移除单位暂停(record.unit, W暂停来源);
    SetUnitFlyHeight(record.unit, record.initialFlyHeight, 0);
    SetUnitTimeScale(record.unit, 1);
  }
}

function 处理W第二段目标(this: void, target: any, _index: number, variable?: any): any {
  const record = variable as W施法记录 | undefined;
  if (record == null || !record.active || !单位存活(target)) return undefined;
  const targetId = GetHandleId(target);
  if (record.已命中目标[targetId] || record.已撞墙目标[targetId]) return undefined;
  record.已命中目标[targetId] = true;
  record.第二段目标列表.push(target);
  施加眩晕(record.unit, target, 逆回十六夜单位技能配置.W.第二段眩晕秒, "重拳击飞-第二段", "技能");
  return {};
}

function 移动W第二段目标(this: void, record: W施法记录): void {
  const cfg = 逆回十六夜单位技能配置.W;
  for (let i = 0; i < record.第二段目标列表.length; i++) {
    const target = record.第二段目标列表[i];
    if (!单位存活(target)) continue;
    const targetId = GetHandleId(target);
    if (record.已撞墙目标[targetId]) continue;
    const result = 沿角度步进直到地形阻挡({
      起点X: GetUnitX(target), 起点Y: GetUnitY(target), 角度度: record.angle,
      单步距离: cfg.第二段每次移动距离, 步数: 1, 检测单位: target,
    });
    if (result.是否提前停止) {
      record.已撞墙目标[targetId] = true;
      施加眩晕(record.unit, target, cfg.撞墙眩晕秒, "重拳击飞-撞墙", "技能");
      continue;
    }
    SetUnitFacing(target, record.angle);
    SetUnitX(target, result.最终X);
    SetUnitY(target, result.最终Y);
  }
}

function 逆回十六夜W第二段AOETick(this: void, variable?: any): void {
  const record = variable as W施法记录 | undefined;
  if (record == null || !record.active) return;
  const cfg = 逆回十六夜单位技能配置.W;
  if (!单位存活(record.unit) || !单位存活(record.target)) {
    结束W施法(record);
    return;
  }
  if (record.第二段循环计数 >= cfg.第二段循环次数) {
    结束W施法(record);
    return;
  }
  record.第二段循环计数 += 1;
  const targets = getEnemyUnitsInRange(record.unit, GetUnitX(record.target), GetUnitY(record.target), cfg.第二段搜索半径);
  造成批量AOE技能伤害({
    来源: record.unit, 目标列表: targets, 伤害: record.attack * cfg.第二段攻击力倍率,
    伤害类型: DAMAGE_TYPE_ENHANCED, attack: false, 来源类型: "单位技能",
    技能ID: W技能类型ID, 技能实例ID: record.skillInstanceId,
    参与技能伤害加成: true, 标签: "逆回十六夜-重拳击飞-第二段",
    每目标处理器: 处理W第二段目标, 变量: record,
  });
  移动W第二段目标(record);
}

function 进入W第二段(this: void, record: W施法记录): void {
  if (!record.active || !单位存活(record.unit) || !单位存活(record.target)) {
    结束W施法(record);
    return;
  }
  const cfg = 逆回十六夜单位技能配置.W;
  const owner = GetOwningPlayer(record.unit);
  创建W表现单位(owner, cfg.第二段起始特效单位类型ID, GetUnitX(record.target), GetUnitY(record.target), record.angle + 90);
  const 飞踢特效 = 创建W表现单位(owner, cfg.飞踢特效单位类型ID, GetUnitX(record.unit), GetUnitY(record.unit), record.angle + 90);
  if (飞踢特效 != null && 飞踢特效 !== 0) {
    SetUnitTimeScale(飞踢特效, cfg.飞踢特效动作速度);
    SetUnitFlyHeight(飞踢特效, record.initialFlyHeight, 0);
  }
  record.阶段 = "第二段自身移动";
  record.循环计数 = 0;
  record.阶段回调ID = addPeriodicCallback(cfg.第一段循环间隔秒 * 1000, 逆回十六夜W第二段自身移动Tick, record);
}

function 逆回十六夜W第二段自身移动Tick(this: void, variable?: any): void {
  const record = variable as W施法记录 | undefined;
  if (record == null || !record.active) return;
  const cfg = 逆回十六夜单位技能配置.W;
  if (!单位存活(record.unit) || !单位存活(record.target)) {
    结束W施法(record);
    return;
  }
  if (record.循环计数 >= cfg.贴近循环次数) {
    if (record.阶段回调ID > 0) removePeriodicCallback(record.阶段回调ID);
    record.阶段回调ID = 0;
    移除单位暂停(record.unit, W暂停来源);
    SetUnitTimeScale(record.unit, 1);
    record.阶段 = "第二段AOE";
    record.循环计数 = 0;
    record.第二段AOE回调ID = addPeriodicCallback(cfg.第二段循环间隔秒 * 1000, 逆回十六夜W第二段AOETick, record);
    return;
  }
  record.循环计数 += 1;
  const result = 沿角度步进直到地形阻挡({
    起点X: GetUnitX(record.unit), 起点Y: GetUnitY(record.unit), 角度度: record.angle,
    单步距离: cfg.贴近每次移动距离, 步数: 1, 检测单位: record.unit,
  });
  if (result.是否提前停止) {
    record.循环计数 = cfg.贴近循环次数;
    SetUnitTimeScale(record.unit, 1);
    return;
  }
  SetUnitFacing(record.unit, record.angle);
  SetUnitX(record.unit, result.最终X);
  SetUnitY(record.unit, result.最终Y);
}

function 逆回十六夜W第一段命中(this: void, record: W施法记录): void {
  if (record == null || !record.active) return;
  if (!单位存活(record.unit) || !单位存活(record.target)) {
    结束W施法(record);
    return;
  }
  const cfg = 逆回十六夜单位技能配置.W;
  创建W表现单位(GetOwningPlayer(record.unit), cfg.第一段命中特效单位类型ID, GetUnitX(record.unit), GetUnitY(record.unit), record.angle + 90);
  造成单体技能伤害({
    来源: record.unit, 目标: record.target, 伤害: record.attack * cfg.第一段攻击力倍率,
    伤害类型: DAMAGE_TYPE_NORMAL, attack: true, 来源类型: "单位技能",
    技能ID: W技能类型ID, 技能实例ID: record.skillInstanceId,
    参与技能伤害加成: true, 标签: "逆回十六夜-重拳击飞-第一段",
  });
  SetUnitAnimationByIndex(record.unit, cfg.第二段动作编号);
  Sound3DII_UnitPlayReuse(cfg.第二段音效路径, record.unit, cfg.第二段音效裁断距离);
  addDelayedCallback(cfg.第二段前延迟秒 * 1000, 进入W第二段, record);
}

function 逆回十六夜W第一段目标移动Tick(this: void, variable?: any): void {
  const record = variable as W施法记录 | undefined;
  if (record == null || !record.active) return;
  const cfg = 逆回十六夜单位技能配置.W;
  if (!单位存活(record.unit) || !单位存活(record.target)) {
    结束W施法(record);
    return;
  }
  if (record.循环计数 >= cfg.第一段循环次数) {
    if (record.阶段回调ID > 0) removePeriodicCallback(record.阶段回调ID);
    record.阶段回调ID = 0;
    逆回十六夜W第一段命中(record);
    return;
  }
  record.循环计数 += 1;
  const targetX = GetUnitX(record.target);
  const targetY = GetUnitY(record.target);
  const result = 沿角度步进直到地形阻挡({
    起点X: targetX, 起点Y: targetY, 角度度: record.angle,
    单步距离: cfg.第一段每次移动距离, 步数: 1, 检测单位: record.target,
  });
  if (!result.是否提前停止) {
    SetUnitFacing(record.target, record.angle);
    SetUnitX(record.target, result.最终X);
    SetUnitY(record.target, result.最终Y);
  }
}

function 逆回十六夜W启动(this: void, variable?: any): void {
  const record = variable as W施法记录 | undefined;
  if (record == null || !record.active || !单位存活(record.unit) || !单位存活(record.target)) {
    if (record != null) 结束W施法(record);
    return;
  }
  const cfg = 逆回十六夜单位技能配置.W;
  record.initialFlyHeight = GetUnitFlyHeight(record.unit);
  record.angle = 两点角度(GetUnitX(record.unit), GetUnitY(record.unit), GetUnitX(record.target), GetUnitY(record.target));
  record.attack = 读取单位攻击力(record.unit);
  添加单位暂停(record.unit, W暂停来源);
  SetUnitTimeScale(record.unit, cfg.动作速度);
  const actionIndex = cfg.起手动作编号[GetRandomInt(0, cfg.起手动作编号.length - 1)];
  SetUnitAnimationByIndex(record.unit, actionIndex);
  创建W表现单位(GetOwningPlayer(record.unit), cfg.第一段起手特效单位类型ID, GetUnitX(record.target), GetUnitY(record.target), record.angle + 90);
  施加眩晕(record.unit, record.target, cfg.短暂眩晕秒, "重拳击飞", "技能");
  播放W全局音效(record.unit, cfg.全局音效键);
  Sound3DII_UnitPlayReuse(cfg.附加音效路径, record.unit, cfg.附加音效裁断距离);
  record.阶段 = "第一段目标移动";
  record.循环计数 = 0;
  record.阶段回调ID = addPeriodicCallback(cfg.第一段循环间隔秒 * 1000, 逆回十六夜W第一段目标移动Tick, record);
}

function 释放重拳击飞(this: void, _context: W上下文, unit: any, 技能实例ID?: number): void {
  const target = GetSpellTargetUnit();
  if (!单位存活(unit) || !单位存活(target)) return;
  const unitId = GetHandleId(unit);
  const existing = W当前施法表[unitId];
  if (existing != null) 结束W施法(existing);
  const record: W施法记录 = {
    unit, target, active: true, angle: 0, initialFlyHeight: 0, attack: 0, skillInstanceId: 技能实例ID,
    阶段回调ID: 0, 阶段: "第一段目标移动", 循环计数: 0, 第二段AOE回调ID: 0, 第二段循环计数: 0,
    已命中目标: {}, 已撞墙目标: {}, 第二段目标列表: [],
  };
  W当前施法表[unitId] = record;
  addDelayedCallback(逆回十六夜单位技能配置.W.启动延迟秒 * 1000, 逆回十六夜W启动, record);
}

export function 注册逆回十六夜W(this: void): void {
  注册单位技能壳监听({
    名称: "逆回十六夜-重拳击飞", 单位类型ID: 逆回十六夜单位技能配置.单位类型ID,
    技能ID: 逆回十六夜单位技能配置.W技能ID, 获取或创建上下文: 获取W上下文,
    释放技能: 释放重拳击飞, 创建独立技能实例: true, 独立技能来源类型: "单位技能",
  });
}

注册逆回十六夜W();
