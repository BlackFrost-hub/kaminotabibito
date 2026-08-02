/** @noSelfInFile */

import { 安斯艾尔单位技能配置 } from "./00．配置";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 开始击退 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始击退: (this: void, unit: any, params: any) => number;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 施加减速 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加减速: (this: void, source: any, target: any, ratio: number, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 读取单位攻击力, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC as any;
const W技能类型ID = stringToFourCCSafe(安斯艾尔单位技能配置.W技能ID);

interface W上下文 { unit: any; }

function 获取W上下文(this: void, unit: any): W上下文 {
  return { unit };
}

function 播放W配置表现(this: void, unit: any): void {
  const cfg = 安斯艾尔单位技能配置.W;
  if (cfg.动作编号 >= 0) {
    SetUnitTimeScale(unit, cfg.动作速度);
    SetUnitAnimationByIndex(unit, cfg.动作编号);
  }
  if (cfg.全局音效键 === "") return;
  const sound = jglobals[cfg.全局音效键];
  if (sound == null || sound === 0) return;
  jass.AttachSoundToUnit(sound, unit);
  jass.SetSoundVolume(sound, 127);
  jass.StartSound(sound);
}

function 播放长枪裁决连续特效(this: void, target: any): void {
  const cfg = 安斯艾尔单位技能配置.W;
  let count = 0;
  let callbackId = 0;
  function on连续特效Tick(this: void): void {
    count += 1;
    if (target != null && target !== 0) {
      创建点特效({
        模型路径: cfg.连续特效模型,
        X: GetUnitX(target),
        Y: GetUnitY(target),
        Z: cfg.连续特效Z,
        Z轴角度: cfg.连续特效Z轴角度,
        缩放: cfg.连续特效缩放,
        动画速度: cfg.连续特效动画速度,
        持续秒: cfg.连续特效持续秒,
      });
    }
    if (count >= cfg.连续特效次数) removePeriodicCallback(callbackId);
  }
  callbackId = addPeriodicCallback(cfg.连续特效间隔毫秒, on连续特效Tick);
}

function 释放长枪裁决(this: void, _context: W上下文, unit: any, 技能实例ID?: number): void {
  const target = GetSpellTargetUnit();
  if (!单位存活(target)) return;
  const cfg = 安斯艾尔单位技能配置.W;
  const level = GetUnitAbilityLevel(unit, W技能类型ID);
  const damage = 读取单位攻击力(unit) * (cfg.基础攻击力倍率 + cfg.每级攻击力倍率 * level);
  播放W配置表现(unit);

  function on击退结束(this: void): void {
    if (单位存活(target)) 施加减速(unit, target, cfg.减速比例, cfg.减速持续秒, "长枪裁决", "技能");
  }
  开始击退(target, {
    来源单位: unit,
    距离: cfg.击退距离,
    持续时间: cfg.击退持续秒,
    检查地形: true,
    暂停单位: false,
    禁用碰撞: true,
    结束回调: on击退结束,
  });
  造成单体技能伤害({
    来源: unit,
    目标: target,
    伤害: damage,
    伤害类型: DAMAGE_TYPE_NORMAL,
    attack: true,
    ranged: false,
    attackType: ATTACK_TYPE_MAGIC,
    来源类型: "单位技能",
    技能ID: W技能类型ID,
    技能实例ID,
    参与技能伤害加成: true,
    标签: "安斯艾尔-长枪裁决",
  });
  播放长枪裁决连续特效(target);
}

export function 注册安斯艾尔W(this: void): void {
  注册单位技能壳监听({
    名称: "安斯艾尔-长枪裁决",
    单位类型ID: 安斯艾尔单位技能配置.单位类型ID,
    技能ID: 安斯艾尔单位技能配置.W技能ID,
    获取或创建上下文: 获取W上下文,
    释放技能: 释放长枪裁决,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
  });
}

注册安斯艾尔W();
