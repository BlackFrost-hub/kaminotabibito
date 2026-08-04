/** @noSelfInFile */

import { 逆回十六夜单位技能配置 } from "./00．配置";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { 开始线性升降 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.03．线性升降系统") as {
  开始线性升降: (this: void, unit: any, params: any) => number;
};
const { 开始击退, 开始冲锋 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始击退: (this: void, unit: any, params: any) => number;
  开始冲锋: (this: void, unit: any, params: any) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
};
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 读取单位攻击力, 单位存活, 两点角度, 极坐标X, 极坐标Y, 点到线段距离平方 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  极坐标X: (this: void, x: number, angle: number, distance: number) => number;
  极坐标Y: (this: void, y: number, angle: number, distance: number) => number;
  点到线段距离平方: (this: void, px: number, py: number, ax: number, ay: number, bx: number, by: number) => number;
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
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const E技能类型ID = stringToFourCCSafe(逆回十六夜单位技能配置.E技能ID);
const E暂停来源 = "逆回十六夜E技能";

function 播放跳跃一踢音效(this: void, unit: any, soundKey: string): void {
  const soundHandle = jglobals[soundKey];
  if (unit == null || unit === 0 || soundHandle == null || soundHandle === 0) return;
  jass.AttachSoundToUnit(soundHandle, unit);
  jass.SetSoundVolume(soundHandle, 127);
  jass.StartSound(soundHandle);
}

interface E上下文 { unit: any; }
interface E命中处理变量 {
  施法者: any;
  起点X: number;
  起点Y: number;
  终点X: number;
  终点Y: number;
  路径命中半径平方: number;
  角度: number;
  配置: typeof 逆回十六夜单位技能配置.E;
}
function 获取E上下文(this: void, unit: any): E上下文 { return { unit }; }

function 准备逆回十六夜E目标伤害(this: void, target: any, _index: number, variable?: any): any {
  const 变量 = variable as E命中处理变量 | undefined;
  if (变量 == null) return undefined;
  if (点到线段距离平方(
    GetUnitX(target), GetUnitY(target),
    变量.起点X, 变量.起点Y, 变量.终点X, 变量.终点Y,
  ) > 变量.路径命中半径平方) return undefined;
  return {};
}

function 处理逆回十六夜E目标结算后(this: void, target: any, _index: number, _成功: boolean, variable?: any): void {
  const 变量 = variable as E命中处理变量 | undefined;
  if (变量 == null) return;
  施加眩晕(变量.施法者, target, 变量.配置.眩晕秒, "跳跃一踢", "技能");
  创建点特效({ 模型路径: 变量.配置.命中特效, X: GetUnitX(target), Y: GetUnitY(target), 持续秒: 1 });
  开始击退(target, {
    角度: 变量.角度, 距离: 变量.配置.击退距离, 持续时间: 变量.配置.击退持续秒,
    主单位: 变量.施法者, 检查地形: true, 暂停单位: false, 禁用碰撞: true,
  });
}

function 释放跳跃一踢(this: void, _context: E上下文, unit: any, 技能实例ID?: number): void {
  const cfg = 逆回十六夜单位技能配置.E;
  const startX = GetUnitX(unit);
  const startY = GetUnitY(unit);
  const initialFlyHeight = GetUnitFlyHeight(unit);
  const angle = 两点角度(startX, startY, GetSpellTargetX(), GetSpellTargetY());
  const endX = 极坐标X(startX, angle, cfg.实际飞行距离);
  const endY = 极坐标Y(startY, angle, cfg.实际飞行距离);
  const damage = 读取单位攻击力(unit) * cfg.攻击力倍率;
  添加单位暂停(unit, E暂停来源);
  SetUnitAnimationByIndex(unit, cfg.动作编号);
  SetUnitTimeScale(unit, cfg.动作速度);
  播放跳跃一踢音效(unit, cfg.全局音效键);
  Sound3DII_UnitPlayReuse(cfg.附加音效路径, unit, cfg.附加音效裁断距离);
  创建点特效({ 模型路径: cfg.路径特效, X: startX, Y: startY, Z轴角度: angle, 缩放: 2, 持续秒: 1.2 });

  function on跳跃一踢结束(this: void, caster: any, reason: string): void {
    if (!单位存活(caster)) return;
    移除单位暂停(caster, E暂停来源);
    if (reason !== "完成" && reason !== "撞墙") return;
    SetUnitFlyHeight(caster, initialFlyHeight, 0);
    SetUnitTimeScale(caster, 1);
    const midX = (startX + endX) * 0.5;
    const midY = (startY + endY) * 0.5;
    const targets = getEnemyUnitsInRange(caster, midX, midY, cfg.实际飞行距离 * 0.5 + cfg.路径命中半径);
    const radiusSquared = cfg.路径命中半径 * cfg.路径命中半径;
    造成批量AOE技能伤害({
      来源: caster, 目标列表: targets, 伤害: damage, 伤害类型: DAMAGE_TYPE_ENHANCED,
      来源类型: "单位技能", 技能ID: E技能类型ID,
      技能实例ID, 参与技能伤害加成: true, 标签: "逆回十六夜-跳跃一踢",
      每目标处理器: 准备逆回十六夜E目标伤害,
      每目标结算后处理器: 处理逆回十六夜E目标结算后,
      变量: {
        施法者: caster, 起点X: startX, 起点Y: startY, 终点X: endX, 终点Y: endY,
        路径命中半径平方: radiusSquared, 角度: angle, 配置: cfg,
      },
    });
  }

  function on升空结束(this: void, caster: any, reason: string): void {
    if (!单位存活(caster)) {
      移除单位暂停(caster, E暂停来源);
      return;
    }
    if (reason !== "完成") {
      移除单位暂停(caster, E暂停来源);
      SetUnitFlyHeight(caster, initialFlyHeight, 0);
      SetUnitTimeScale(caster, 1);
      return;
    }
    开始线性升降(caster, {
      持续时间: cfg.飞行持续秒,
      高度变化: -cfg.跳跃高度,
      暂停单位: false,
    });
    移除单位暂停(caster, E暂停来源);
    开始冲锋(caster, {
      目标X: endX, 目标Y: endY, 距离: cfg.实际飞行距离,
      持续时间: cfg.飞行持续秒,
      动画序号: cfg.动作编号,
      检查地形: true,
      暂停单位: true,
      禁用碰撞: true,
      朝向跟随位移: true,
      结束回调: on跳跃一踢结束,
    });
  }

  开始线性升降(unit, {
    持续时间: cfg.升空持续秒,
    高度变化: cfg.跳跃高度,
    暂停单位: true,
    结束回调: on升空结束,
  });
}

export function 注册逆回十六夜E(this: void): void {
  注册单位技能壳监听({
    名称: "逆回十六夜-跳跃一踢", 单位类型ID: 逆回十六夜单位技能配置.单位类型ID,
    技能ID: 逆回十六夜单位技能配置.E技能ID, 获取或创建上下文: 获取E上下文,
    释放技能: 释放跳跃一踢, 创建独立技能实例: true, 独立技能来源类型: "单位技能",
  });
}

注册逆回十六夜E();
