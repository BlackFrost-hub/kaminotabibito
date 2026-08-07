/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "../03．运行时上下文";
import { 塞拉公共 } from "./00．公共";
import { 执行BossAOE技能伤害 } from "../../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
import { 巴尔扎罗斯音效配置 } from "../02．数值与表现配置";
import { 播放Boss坐标音效 } from "../../../00．公共/00．Boss音效播放";
const {  巴尔扎罗斯技能数值配置,
  播放塞拉台词,
  施加巴尔扎罗斯灼热,
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
  GetUnitFlyHeight,
  SquareRoot,
  DAMAGE_TYPE_FIRE,
  DAMAGE_TYPE_COLD,
  ATTACK_TYPE_NORMAL,
  WEAPON_TYPE_WHOKNOWS,
  单位有效,
  取方向角,
  取形态技能倍率,
  创建塞拉点特效,
  造成塞拉Boss技能伤害,
  弱追踪弹体状态表,
} = 塞拉公共;

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
      执行BossAOE技能伤害({
        来源: sera,
        目标: unit,
        伤害公式: {
          来源攻击力比例: config.冰球伤害攻击力比例,
          目标最大生命比例: config.冰球伤害目标最大生命比例,
          总倍率: config.冰球伤害总倍率 * 取形态技能倍率(context, "冰霜"),
        },
        attack: false,
        ranged: true,
        attackType: ATTACK_TYPE_NORMAL,
        伤害类型: DAMAGE_TYPE_COLD,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        标签: "塞拉-冰焰双星-冰霜",
      });
      施加快速减速Buff(sera, unit, config.冰球减速比例, config.冰球减速比例, config.冰球减速持续秒);
    } else {
      执行BossAOE技能伤害({
        来源: sera,
        目标: unit,
        伤害公式: {
          来源攻击力比例: config.火球伤害攻击力比例,
          目标最大生命比例: config.火球伤害目标最大生命比例,
          总倍率: config.火球伤害总倍率 * 取形态技能倍率(context, "火焰"),
        },
        attack: false,
        ranged: true,
        attackType: ATTACK_TYPE_NORMAL,
        伤害类型: DAMAGE_TYPE_FIRE,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        标签: "塞拉-冰焰双星-火焰",
      });
      施加巴尔扎罗斯灼热(context, unit, config.火球灼热层数);
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
      const desiredX = x01 + (x12 - x01) * t;
      const desiredY = y01 + (y12 - y01) * t;
      // 贝塞尔采样点按时间推进会绕过弹体速度；限制单 Tick 位移，确保弱追踪阶段也遵守配置速度。
      const dx = desiredX - 实例.当前X;
      const dy = desiredY - 实例.当前Y;
      const distance = SquareRoot(dx * dx + dy * dy);
      const maxStep = 实例.当前速度 * delta;
      const stepScale = distance > 0 && maxStep > 0 && distance > maxStep ? maxStep / distance : 1;
      const x = 实例.当前X + dx * stepScale;
      const y = 实例.当前Y + dy * stepScale;
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
  const 弹幕 = 创建原生弹幕({
    所有者: sera,
    载体模式: 类型 === "火焰" ? "特效" : "单位",
    X: startX,
    Y: startY,
    方向角: angle,
    速度: config.飞行速度,
    轨迹采样器: 创建冰焰弱追踪曲线轨迹(startX, startY, startZ, controlX, controlY, target),
    命中半径: config.弹体命中半径,
    生命周期: config.生命周期秒,
    碰撞消失: true,
    最大距离: config.最大飞行距离,
    模型: 类型 === "冰霜" ? config.冰球模型路径 : "",
    附加特效1: 类型 === "火焰" ? {
      模型: config.火球模型路径,
      动画索引: 0,
      跟随主弹幕参数: true,
      跟随轨迹俯仰: true,
    } : undefined,
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

export function 释放冰焰双星(this: void, context: 巴尔扎罗斯运行时上下文, target: any, 测试类型: "双星" | "火焰" | "冰霜" = "双星"): void {
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
    恢复动画编号: config.恢复动画编号,
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
      if (测试类型 !== "火焰") 发射冰焰弹体(context, target, "冰霜", 1);
      if (测试类型 !== "冰霜") 发射冰焰弹体(context, target, "火焰", -1);
    },
  });
}
