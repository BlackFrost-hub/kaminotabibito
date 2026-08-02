/** @noSelfInFile */

import { 逆回十六夜单位技能配置 } from "./00．配置";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { 开始击退, 开始冲锋 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始击退: (this: void, unit: any, params: any) => number;
  开始冲锋: (this: void, unit: any, params: any) => number;
};
const { 造成单体技能伤害, 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
  造成AOE技能伤害: (this: void, params: any) => boolean;
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

const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const W技能类型ID = stringToFourCCSafe(逆回十六夜单位技能配置.W技能ID);

interface W上下文 { unit: any; }
function 获取W上下文(this: void, unit: any): W上下文 { return { unit }; }

function 播放W全局音效(this: void, unit: any, soundKey: string): void {
  const soundHandle = jglobals[soundKey];
  if (unit == null || unit === 0 || soundHandle == null || soundHandle === 0) return;
  jass.AttachSoundToUnit(soundHandle, unit);
  jass.SetSoundVolume(soundHandle, 127);
  jass.StartSound(soundHandle);
}

function 释放重拳击飞(this: void, _context: W上下文, unit: any, 技能实例ID?: number): void {
  const target = GetSpellTargetUnit();
  if (!单位存活(target)) return;
  const cfg = 逆回十六夜单位技能配置.W;
  const angle = 两点角度(GetUnitX(unit), GetUnitY(unit), GetUnitX(target), GetUnitY(target));
  const attack = 读取单位攻击力(unit);
  const startAnimationIndex = cfg.起手动作编号[GetRandomInt(0, cfg.起手动作编号.length - 1)];
  SetUnitAnimationByIndex(unit, startAnimationIndex);
  SetUnitTimeScale(unit, cfg.动作速度);
  播放W全局音效(unit, cfg.全局音效键);
  Sound3DII_UnitPlayReuse(cfg.附加音效路径, unit, cfg.附加音效裁断距离);

  造成单体技能伤害({
    来源: unit, 目标: target, 伤害: attack * cfg.第一段攻击力倍率,
    伤害类型: DAMAGE_TYPE_NORMAL, attack: true, 来源类型: "单位技能",
    技能ID: W技能类型ID, 技能实例ID,
    参与技能伤害加成: true, 标签: "逆回十六夜-重拳击飞-第一段",
  });
  施加眩晕(unit, target, cfg.短暂眩晕秒, "重拳击飞", "技能");

  function on第一段结束(this: void): void {
    if (!单位存活(unit) || !单位存活(target)) return;
    function on贴近结束(this: void): void {
      if (!单位存活(unit) || !单位存活(target)) return;
      SetUnitAnimationByIndex(unit, cfg.第二段动作编号);
      Sound3DII_UnitPlayReuse(cfg.第二段音效路径, unit, cfg.第二段音效裁断距离);
      const targets = getEnemyUnitsInRange(unit, GetUnitX(target), GetUnitY(target), cfg.第二段搜索半径);
      for (let i = 0; i < targets.length; i++) {
        const enemy = targets[i];
        造成AOE技能伤害({
          来源: unit, 目标: enemy, 伤害: attack * cfg.第二段攻击力倍率,
          伤害类型: DAMAGE_TYPE_NORMAL, attack: true, 来源类型: "单位技能",
          技能ID: W技能类型ID, 技能实例ID,
          参与技能伤害加成: true, 标签: "逆回十六夜-重拳击飞-第二段",
        });
        function on撞墙(this: void): void {
          if (单位存活(enemy)) 施加眩晕(unit, enemy, cfg.撞墙眩晕秒, "重拳击飞-撞墙", "技能");
        }
        开始击退(enemy, {
          角度: angle, 距离: cfg.第二段击退距离, 持续时间: cfg.第二段击退持续秒,
          主单位: unit, 主单位死亡时中断: false, 检查地形: true,
          暂停单位: false, 禁用碰撞: true, 撞墙回调: on撞墙,
        });
      }
    }
    开始冲锋(unit, {
      目标X: GetUnitX(target), 目标Y: GetUnitY(target), 距离: cfg.第一段击退距离,
      持续时间: cfg.贴近持续秒, 检查地形: true,
      暂停单位: true, 禁用碰撞: true, 朝向跟随位移: true,
      结束回调: on贴近结束,
    });
  }

  开始击退(target, {
    角度: angle, 距离: cfg.第一段击退距离, 持续时间: cfg.第一段击退持续秒,
    主单位: unit, 检查地形: true, 暂停单位: false, 禁用碰撞: true,
    结束回调: on第一段结束,
  });
  function onW动作恢复(this: void): void {
    if (unit != null && unit !== 0) SetUnitTimeScale(unit, 1);
  }
  addDelayedCallback((cfg.第一段击退持续秒 + cfg.贴近持续秒 + cfg.第二段击退持续秒) * 1000, onW动作恢复);
}

export function 注册逆回十六夜W(this: void): void {
  注册单位技能壳监听({
    名称: "逆回十六夜-重拳击飞", 单位类型ID: 逆回十六夜单位技能配置.单位类型ID,
    技能ID: 逆回十六夜单位技能配置.W技能ID, 获取或创建上下文: 获取W上下文,
    释放技能: 释放重拳击飞, 创建独立技能实例: true, 独立技能来源类型: "单位技能",
  });
}

注册逆回十六夜W();
