/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "../03．运行时上下文";
import { 塞拉公共 } from "./00．公共";
import { 巴尔扎罗斯音效配置 } from "../02．数值与表现配置";
import { 播放Boss坐标音效 } from "../../../00．公共/00．Boss音效播放";
const {  巴尔扎罗斯技能数值配置,
  播放塞拉台词,
  施加巴尔扎罗斯灼热,
  读取单位攻击力,
  启动基础施法时间线,
  创建技能提示圈,
  施加快速减速Buff,
  创建原生弹幕,
  getUnitsInRange,
  isUnitEnemy,
  CosBJ,
  SinBJ,
  GetUnitX,
  GetUnitY,
  GetUnitState,
  GetUnitFlyHeight,
  SquareRoot,
  UNIT_STATE_MAX_LIFE,
  DAMAGE_TYPE_FIRE,
  DAMAGE_TYPE_COLD,
  单位有效,
  取方向角,
  取形态技能倍率,
  创建塞拉点特效,
  造成塞拉Boss技能伤害,
  弱追踪弹体状态表,
} = 塞拉公共;

function 计算冰球伤害(this: void, context: 巴尔扎罗斯运行时上下文, target: any): number {
  const config = 巴尔扎罗斯技能数值配置.冰焰双星;
  const sera = context.塞拉;
  return (读取单位攻击力(sera) * config.冰球伤害攻击力比例
    + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config.冰球伤害目标最大生命比例)
    * config.冰球伤害总倍率
    * 取形态技能倍率(context, "冰霜");
}

function 计算火球伤害(this: void, context: 巴尔扎罗斯运行时上下文, target: any): number {
  const config = 巴尔扎罗斯技能数值配置.冰焰双星;
  const sera = context.塞拉;
  return (读取单位攻击力(sera) * config.火球伤害攻击力比例
    + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config.火球伤害目标最大生命比例)
    * config.火球伤害总倍率
    * 取形态技能倍率(context, "火焰");
}

function 结算冰焰AOE(this: void, context: 巴尔扎罗斯运行时上下文, hitUnit: any, 类型: "冰霜" | "火焰"): void {
  const sera = context.塞拉;
  if (!单位有效(sera) || !单位有效(hitUnit)) return;
  const config = 巴尔扎罗斯技能数值配置.冰焰双星;
  const x = GetUnitX(hitUnit);
  const y = GetUnitY(hitUnit);
  if (类型 === "冰霜") {
    创建塞拉点特效(config.冰球命中特效路径, x, y, config.冰球命中特效高度, config.冰球命中特效缩放, 1.2);
  } else {
    创建塞拉点特效(config.火球命中特效路径, x, y, config.火球命中特效高度, config.火球命中特效缩放, 1.2);
  }
  const targets = getUnitsInRange(x, y, config.命中AOE半径);
  for (let i = 0; i < targets.length; i++) {
    const unit = targets[i];
    if (!单位有效(unit) || !isUnitEnemy(unit, sera)) continue;
    if (类型 === "冰霜") {
      造成塞拉Boss技能伤害(sera, unit, 计算冰球伤害(context, unit), DAMAGE_TYPE_COLD, "AOE");
      施加快速减速Buff(sera, unit, config.冰球减速比例, config.冰球减速比例, config.冰球减速持续秒);
    } else {
      造成塞拉Boss技能伤害(sera, unit, 计算火球伤害(context, unit), DAMAGE_TYPE_FIRE, "AOE");
      施加巴尔扎罗斯灼热(unit, config.火球灼热层数);
    }
  }
}

function 创建冰焰弱追踪曲线轨迹(
  this: void,
  startX: number,
  startY: number,
  startZ: number,
  controlX: number,
  controlY: number,
  target: any,
): any {
  const config = 巴尔扎罗斯技能数值配置.冰焰双星;
  return function 塞拉冰焰弱追踪轨迹(this: void, 实例: any, delta: number): any {
    let 状态 = 弱追踪弹体状态表[实例.id];
    if (状态 == null) {
      状态 = { 锁定: false, 锁定角: 实例.当前方向角 };
      弱追踪弹体状态表[实例.id] = 状态;
    }
    if (!状态.锁定 && 实例.已运行时间 <= config.弱追踪秒 && 单位有效(target)) {
      const t = 实例.已运行时间 / config.弱追踪秒;
      const endX = GetUnitX(target);
      const endY = GetUnitY(target);
      const x01 = startX + (controlX - startX) * t;
      const y01 = startY + (controlY - startY) * t;
      const x12 = controlX + (endX - controlX) * t;
      const y12 = controlY + (endY - controlY) * t;
      const x = x01 + (x12 - x01) * t;
      const y = y01 + (y12 - y01) * t;
      return { X: x, Y: y, Z: startZ, 方向角: 取方向角(实例.当前X, 实例.当前Y, x, y), 完成: false };
    }
    if (!状态.锁定) {
      状态.锁定 = true;
      if (单位有效(target)) {
        状态.锁定角 = 取方向角(实例.当前X, 实例.当前Y, GetUnitX(target), GetUnitY(target));
      }
    }
    return {
      X: 实例.当前X + CosBJ(状态.锁定角) * 实例.当前速度 * delta,
      Y: 实例.当前Y + SinBJ(状态.锁定角) * 实例.当前速度 * delta,
      Z: startZ,
      方向角: 状态.锁定角,
      完成: false,
    };
  };
}

function 发射冰焰弹体(this: void, context: 巴尔扎罗斯运行时上下文, target: any, 类型: "冰霜" | "火焰", side: number): void {
  const sera = context.塞拉;
  if (!单位有效(sera) || !单位有效(target)) return;
  const config = 巴尔扎罗斯技能数值配置.冰焰双星;
  const angle = 取方向角(GetUnitX(sera), GetUnitY(sera), GetUnitX(target), GetUnitY(target));
  const sideAngle = angle + 90 * side;
  const startX = GetUnitX(sera) + CosBJ(angle) * config.发射前向偏移 + CosBJ(sideAngle) * config.发射侧向偏移;
  const startY = GetUnitY(sera) + SinBJ(angle) * config.发射前向偏移 + SinBJ(sideAngle) * config.发射侧向偏移;
  const controlX = startX + CosBJ(angle) * config.曲线控制前移 + CosBJ(sideAngle) * config.曲线控制侧移;
  const controlY = startY + SinBJ(angle) * config.曲线控制前移 + SinBJ(sideAngle) * config.曲线控制侧移;
  const startZ = GetUnitFlyHeight(sera) + config.飞行高度;
  创建原生弹幕({
    所有者: sera,
    X: startX,
    Y: startY,
    方向角: angle,
    速度: config.飞行速度,
    轨迹采样器: 创建冰焰弱追踪曲线轨迹(startX, startY, startZ, controlX, controlY, target),
    命中半径: config.弹体命中半径,
    生命周期: config.生命周期秒,
    碰撞消失: true,
    最大距离: config.最大飞行距离,
    模型: 类型 === "冰霜" ? config.冰球模型路径 : config.火球模型路径,
    附着特效模型: 类型 === "冰霜" ? config.冰球模型路径 : config.火球模型路径,
    缩放: 类型 === "冰霜" ? config.冰球缩放 : config.火球缩放,
    飞行高度: startZ,
    影响目标: "敌方",
    最大总命中次数: 1,
    每单位最大命中次数: 1,
    伤害值: 0,
    伤害形态: "AOE",
    on命中: function 塞拉冰焰弹体命中(this: void, hitUnit: any): void {
      结算冰焰AOE(context, hitUnit, 类型);
    },
    on结束: function 塞拉冰焰弹体结束(this: void, _原因: string, 弹幕ID: number): void {
      delete 弱追踪弹体状态表[弹幕ID];
    },
  });
}

export function 释放冰焰双星(this: void, context: 巴尔扎罗斯运行时上下文, target: any): void {
  const sera = context.塞拉;
  if (!单位有效(sera) || !单位有效(target)) return;
  const config = 巴尔扎罗斯技能数值配置.冰焰双星;
  创建技能提示圈({
    类型: "圆形",
    X: GetUnitX(target),
    Y: GetUnitY(target),
    半径: config.目标预警半径,
    持续时间: config.施法硬直秒,
  });
  启动基础施法时间线({
    施法者: sera,
    目标单位: target,
    硬直秒: config.施法硬直秒,
    动画编号: config.动画编号,
    动画速度: config.动画速度,
    吟唱条: {
      通道: "常规技能",
      总时长: config.施法硬直秒,
      颜色ID: config.吟唱条颜色ID,
      标题文本: config.吟唱条标题文本,
      提示文本: config.吟唱条提示文本,
    },
    播放台词: function 塞拉冰焰双星台词(this: void): void {
      播放塞拉台词(sera, "冰焰双星");
    },
    on生效: function 塞拉冰焰双星生效(this: void): void {
      播放Boss坐标音效(巴尔扎罗斯音效配置.塞拉.冰焰双星发射, GetUnitX(sera), GetUnitY(sera), 巴尔扎罗斯音效配置.默认裁断距离);
      发射冰焰弹体(context, target, "冰霜", 1);
      发射冰焰弹体(context, target, "火焰", -1);
    },
  });
}
