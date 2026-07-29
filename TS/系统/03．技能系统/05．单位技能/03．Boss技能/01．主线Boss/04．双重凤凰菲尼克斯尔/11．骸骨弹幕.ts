/** @noSelfInFile */

import type { 菲尼克斯尔运行时上下文 } from "./03．运行时上下文";
import { 菲尼克斯尔数值与表现配置, 菲尼克斯尔音效配置 } from "./02．数值与表现配置";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import { 播放Boss坐标音效, 延迟播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import {
  周期,
  延迟,
  单位存活,
  取单位X,
  取单位Y,
  取随机玩家英雄,
  播放点特效,
  计算攻击最大生命伤害,
  造成暗火伤害,
  创建菲尼克斯尔独立伤害上下文,
  添加元素层数,
  设置单位动画,
  显示常规读条,
  开始施法硬直,
  极坐标X,
  极坐标Y,
} from "./19．公共工具";
import type { 菲尼克斯尔伤害上下文参数 } from "./19．公共工具";
import { 创建二阶贝塞尔XYZ轨迹, 创建原生弹幕 } from "../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕";
import { 创建技能提示圈 } from "../../../../00．技能模板+函数/02．通用函数/16．技能提示圈工厂";

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (unit: any) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const bj_RADTODEG = (jass.bj_RADTODEG ?? 57.29577951308232) as number;

function 取坐标朝向角(this: void, fromX: number, fromY: number, toX: number, toY: number): number {
  return (Atan2(toY - fromY, toX - fromX) as number) * bj_RADTODEG;
}

function 发射菲尼克斯尔骸骨弹幕波次(this: void, context: 菲尼克斯尔运行时上下文, 伤害上下文: 菲尼克斯尔伤害上下文参数): void {
  const boss = context.Boss;
  if (!单位存活(boss)) return;
  const config = 菲尼克斯尔数值与表现配置.骸骨弹幕;
  const bossX = 取单位X(boss);
  const bossY = 取单位Y(boss);
  const safeTarget = 取随机玩家英雄(boss);
  const safeAngle = 单位存活(safeTarget)
    ? 取坐标朝向角(bossX, bossY, 取单位X(safeTarget), 取单位Y(safeTarget))
    : GetRandomReal(0, 360);
  const slotCount = config.每波数量 + 1;
  const angleStep = 360 / slotCount;
  const waveHitCount: Record<number, number> = {};
  const angles: number[] = [];

  // 空出朝向一名玩家的槽位，其余骨矛均匀铺开；弹体发射后不再追踪。
  for (let i = 0; i < config.每波数量; i++) {
    const angle = safeAngle + (i + 1) * angleStep;
    angles.push(angle);
    创建技能提示圈({
      类型: "方向直线",
      X: bossX,
      Y: bossY,
      宽度: config.弹体命中半径 * 2,
      长度: config.半径,
      朝向: angle,
      持续时间: config.读条秒,
      来源单位: boss,
    });
  }

  延迟(config.读条秒 * 1000, function 菲尼克斯尔骸骨弹幕齐射(this: void): void {
    if (!单位存活(boss)) return;
    const startZ = GetUnitFlyHeight(boss);
    const travelDistance = config.半径 - config.发射前移;
    const travelSeconds = travelDistance / config.弹体速度;
    for (let i = 0; i < angles.length; i++) {
      const angle = angles[i];
      const startX = 极坐标X(bossX, config.发射前移, angle);
      const startY = 极坐标Y(bossY, config.发射前移, angle);
      const endX = 极坐标X(bossX, config.半径, angle);
      const endY = 极坐标Y(bossY, config.半径, angle);
      const controlX = (startX + endX) * 0.5;
      const controlY = (startY + endY) * 0.5;
      创建原生弹幕({
        所有者: boss,
        X: startX,
        Y: startY,
        方向角: angle,
        速度: config.弹体速度,
        生命周期: travelSeconds,
        命中半径: config.弹体命中半径,
        影响目标: "敌方",
        碰撞消失: true,
        每单位最大命中次数: 1,
        最大总命中次数: 1,
        禁用碰撞: true,
        不可阻挡: true,
        显式改向后锁定方向: true,
        模型: 菲尼克斯尔数值与表现配置.特效.骨羽,
        附加特效1: {
          模型: 菲尼克斯尔数值与表现配置.特效.骨羽叠加,
          附着点: "origin",
          跟随主弹幕参数: true,
          跟随轨迹俯仰: true,
          缩放: config.骨矛叠加缩放,
        },
        缩放: config.弹体缩放,
        飞行高度: startZ,
        轨迹采样器: 创建二阶贝塞尔XYZ轨迹(
          startX, startY, startZ,
          controlX, controlY, startZ,
          endX, endY, 0,
        ),
        on命中: function 菲尼克斯尔骸骨弹幕命中(this: void, target: any): void {
          const targetId = GetHandleId(target);
          const hitCount = waveHitCount[targetId] ?? 0;
          const repeatScale = hitCount > 0 ? 0.5 : 1;
          waveHitCount[targetId] = hitCount + 1;
          播放点特效(菲尼克斯尔数值与表现配置.特效.骨羽命中, 取单位X(target), 取单位Y(target), config.命中特效持续秒 * 1000);
          造成暗火伤害(boss, target, 计算攻击最大生命伤害(boss, target, config.伤害Boss攻击力比例, config.伤害目标最大生命比例) * repeatScale, "AOE", 伤害上下文);
          添加元素层数(target, "暗", config.怨火层数);
        },
      });
    }
  });
}

export function 释放菲尼克斯尔骸骨弹幕(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.当前形态 !== "第二形态" || !单位存活(context.Boss)) return;
  const config = 菲尼克斯尔数值与表现配置.骸骨弹幕;
  const 伤害上下文 = 创建菲尼克斯尔独立伤害上下文("菲尼克斯尔骸骨弹幕", config.读条秒 + config.波次数 * config.波次间隔秒 + 2);
  播放菲尼克斯尔台词(context.Boss, "骸骨弹幕");
  开始施法硬直(context.Boss, config.读条秒 + config.波次间隔秒 * (config.波次数 - 1));
  设置单位动画(context.Boss, 菲尼克斯尔数值与表现配置.动画.第二形态.弹幕攻击.编号, 菲尼克斯尔数值与表现配置.动画.第二形态.弹幕攻击.倍速);
  显示常规读条(config.读条秒, config.吟唱条颜色ID, config.吟唱条标题文本, config.吟唱条提示文本);
  延迟(0, function 菲尼克斯尔骸骨弹幕开始(this: void): void {
    播放Boss坐标音效(菲尼克斯尔音效配置.骸骨弹幕.起手层, 取单位X(context.Boss), 取单位Y(context.Boss), 菲尼克斯尔音效配置.默认裁断距离);
    延迟播放Boss坐标音效(菲尼克斯尔音效配置.骸骨弹幕.飞射层, 取单位X(context.Boss), 取单位Y(context.Boss), 菲尼克斯尔音效配置.骸骨弹幕.飞射层延迟Ms, 菲尼克斯尔音效配置.默认裁断距离);
    for (let wave = 0; wave < config.波次数; wave++) {
      延迟(wave * config.波次间隔秒 * 1000, function 菲尼克斯尔骸骨弹幕波次(this: void): void {
        发射菲尼克斯尔骸骨弹幕波次(context, 伤害上下文);
      });
    }
  });
}

export function 初始化菲尼克斯尔骸骨弹幕节点(this: void, context: 菲尼克斯尔运行时上下文): void {
  const timerId = 周期(14000, function 菲尼克斯尔骸骨弹幕周期(this: void): void {
    释放菲尼克斯尔骸骨弹幕(context);
  });
  context.清理.登记周期回调("菲尼克斯尔-骸骨弹幕", timerId);
}

export function 注册菲尼克斯尔骸骨弹幕(this: void): void {
  // 第二形态周期机制，由转阶段时初始化。
}

