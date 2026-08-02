/** @noSelfInFile */

import { 逆回十六夜单位技能配置 } from "./00．配置";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 开始线性升降, 停止单位线性升降 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.03．线性升降系统") as {
  开始线性升降: (this: void, unit: any, params: any) => number;
  停止单位线性升降: (this: void, unit: any, reason?: string) => boolean;
};
const { 开始冲锋 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, unit: any, params: any) => number;
};
const { 开始无敌帧, 取消无敌帧 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧") as {
  开始无敌帧: (this: void, unit: any, duration: number) => number;
  取消无敌帧: (this: void, id: number) => boolean;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, params: any) => boolean;
};
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 读取单位攻击力, 单位存活, 距离XY } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  距离XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

const GetSpellTargetX = jass.GetSpellTargetX as () => number;
const GetSpellTargetY = jass.GetSpellTargetY as () => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (unit: any) => number;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (unit: any, height: number, rate: number) => void;
const GetHeroStr = jass.GetHeroStr as (unit: any, includeBonuses: boolean) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const ResetUnitAnimation = jass.ResetUnitAnimation as (unit: any) => void;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const R技能类型ID = stringToFourCCSafe(逆回十六夜单位技能配置.R技能ID);
const R暂停来源 = "逆回十六夜-全力飞踢";

function 播放全力飞踢音效(this: void, unit: any, soundKey: string): void {
  const soundHandle = jglobals[soundKey];
  if (unit == null || unit === 0 || soundHandle == null || soundHandle === 0) return;
  jass.AttachSoundToUnit(soundHandle, unit);
  jass.SetSoundVolume(soundHandle, 127);
  jass.StartSound(soundHandle);
}

interface R上下文 { unit: any; }
interface R施法记录 { unit: any; active: boolean; invincibleId: number; targetX: number; targetY: number; initialFlyHeight: number; damage: number; skillInstanceId?: number; }
const R施法表: Record<number, R施法记录 | undefined> = {};

function 获取R上下文(this: void, unit: any): R上下文 { return { unit }; }

function 结束R施法(this: void, record: R施法记录): void {
  if (!record.active) return;
  record.active = false;
  停止单位线性升降(record.unit, "中断");
  移除单位暂停(record.unit, R暂停来源);
  取消无敌帧(record.invincibleId);
  if (record.unit != null && record.unit !== 0) {
    SetUnitFlyHeight(record.unit, record.initialFlyHeight, 0);
    SetUnitTimeScale(record.unit, 1);
    ResetUnitAnimation(record.unit);
  }
  const id = record.unit != null && record.unit !== 0 ? (jass.GetHandleId(record.unit) as number) : 0;
  if (id !== 0 && R施法表[id] === record) delete R施法表[id];
}

function 释放全力飞踢(this: void, _context: R上下文, unit: any, 技能实例ID?: number): void {
  const cfg = 逆回十六夜单位技能配置.R;
  const unitId = jass.GetHandleId(unit) as number;
  const existing = R施法表[unitId];
  if (existing != null) 结束R施法(existing);
  const startX = GetUnitX(unit);
  const startY = GetUnitY(unit);
  const rawTargetX = GetSpellTargetX();
  const rawTargetY = GetSpellTargetY();
  const distance = 距离XY(startX, startY, rawTargetX, rawTargetY);
  const ratio = distance > cfg.最大位移距离 && distance > 0 ? cfg.最大位移距离 / distance : 1;
  const targetX = startX + (rawTargetX - startX) * ratio;
  const targetY = startY + (rawTargetY - startY) * ratio;
  const record: R施法记录 = {
    unit, active: true, invincibleId: 开始无敌帧(unit, cfg.蓄力秒 + cfg.升空持续秒 + cfg.停空持续秒 + cfg.飞行持续秒 + 1),
    targetX, targetY, initialFlyHeight: GetUnitFlyHeight(unit),
    damage: 读取单位攻击力(unit) * cfg.攻击力倍率 + GetHeroStr(unit, true) * cfg.力量倍率,
    skillInstanceId: 技能实例ID,
  };
  R施法表[unitId] = record;
  播放全力飞踢音效(unit, cfg.全局音效键);
  添加单位暂停(unit, R暂停来源);
  SetUnitTimeScale(unit, cfg.动作速度);
  创建点特效({ 模型路径: cfg.蓄力落点特效, X: targetX, Y: targetY, 持续秒: cfg.蓄力秒 });
  创建点特效({ 模型路径: cfg.起跳特效, X: startX, Y: startY, 持续秒: cfg.蓄力秒 });

  function on全力飞踢前冲(this: void): void {
    if (!record.active || !单位存活(unit)) { 结束R施法(record); return; }
    移除单位暂停(unit, R暂停来源);
    SetUnitAnimationByIndex(unit, cfg.起跳动作编号);
    开始线性升降(unit, {
      持续时间: cfg.飞行持续秒,
      高度变化: -cfg.跳跃高度,
      暂停单位: false,
    });
    function on全力飞踢落地(this: void, caster: any, reason: string): void {
      if (record.active && 单位存活(caster) && (reason === "完成" || reason === "阻挡")) {
        const x = GetUnitX(caster);
        const y = GetUnitY(caster);
        Sound3DII_UnitPlayReuse(cfg.落地音效路径, caster, cfg.落地音效裁断距离);
        创建点特效({ 模型路径: cfg.命中特效A, X: x, Y: y, 持续秒: 1.5 });
        创建点特效({ 模型路径: cfg.命中特效B, X: x, Y: y, 缩放: 2, 持续秒: 1.5 });
        创建点特效({ 模型路径: cfg.命中特效C, X: x, Y: y, 持续秒: 1.5 });
        const targets = getEnemyUnitsInRange(caster, x, y, cfg.落地半径);
        for (let i = 0; i < targets.length; i++) {
          const target = targets[i];
          造成AOE技能伤害({
            来源: caster, 目标: target, 伤害: record.damage, 伤害类型: DAMAGE_TYPE_NORMAL,
            来源类型: "单位技能", 技能ID: R技能类型ID,
            技能实例ID: record.skillInstanceId, 参与技能伤害加成: true, 标签: "逆回十六夜-全力飞踢",
          });
          施加眩晕(caster, target, cfg.眩晕秒, "全力飞踢", "技能");
        }
      }
      结束R施法(record);
    }
    开始冲锋(unit, {
      目标X: record.targetX, 目标Y: record.targetY,
      距离: 距离XY(GetUnitX(unit), GetUnitY(unit), record.targetX, record.targetY),
      持续时间: cfg.飞行持续秒,
      检查地形: true,
      暂停单位: true,
      禁用碰撞: true,
      朝向跟随位移: true,
      结束回调: on全力飞踢落地,
    });
  }

  function on全力飞踢升空结束(this: void, caster: any, reason: string): void {
    if (!record.active || !单位存活(caster) || reason !== "完成") { 结束R施法(record); return; }
    SetUnitAnimationByIndex(caster, cfg.飞踢动作编号);
    添加单位暂停(caster, R暂停来源);
    addDelayedCallback(cfg.停空持续秒 * 1000, on全力飞踢前冲);
  }

  function on全力飞踢蓄力结束(this: void): void {
    if (!record.active || !单位存活(unit)) { 结束R施法(record); return; }
    移除单位暂停(unit, R暂停来源);
    开始线性升降(unit, {
      持续时间: cfg.升空持续秒,
      高度变化: cfg.跳跃高度,
      暂停单位: true,
      结束回调: on全力飞踢升空结束,
    });
  }

  addDelayedCallback(cfg.蓄力秒 * 1000, on全力飞踢蓄力结束);
}

export function 注册逆回十六夜R(this: void): void {
  注册单位技能壳监听({
    名称: "逆回十六夜-全力飞踢", 单位类型ID: 逆回十六夜单位技能配置.单位类型ID,
    技能ID: 逆回十六夜单位技能配置.R技能ID, 获取或创建上下文: 获取R上下文,
    释放技能: 释放全力飞踢, 创建独立技能实例: true, 独立技能来源类型: "单位技能",
    技能实例持续时间秒: 5,
  });
}

注册逆回十六夜R();
