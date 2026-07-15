/** @noSelfInFile */

const { 计算组合技能伤害 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害") as {
  计算组合技能伤害: (this: void, 来源: any, 目标: any, 参数: any) => number;
};

import type { 巴尔扎罗斯运行时上下文 } from "../03．运行时上下文";
import { 格鲁姆公共 } from "./00．公共";
const {  巴尔扎罗斯技能数值配置,
  播放格鲁姆台词,
  施加巴尔扎罗斯灼热,
  启动基础施法时间线,
  创建技能提示圈,
  获取Boss技能敌对英雄列表,
  施加快速控制Buff,
  GetUnitX,
  GetUnitY,
  快速控制_击晕,
  单位有效,
  点到单位距离平方,
  取方向角,
  角度差绝对值,
  造成格鲁姆Boss技能伤害,
  播放点特效,
} = 格鲁姆公共;

function 目标在重锤扇形内(this: void, grum: any, target: any, facing: number): boolean {
  const config = 巴尔扎罗斯技能数值配置.熔岩重锤;
  if (!单位有效(grum) || !单位有效(target)) return false;
  if (点到单位距离平方(target, GetUnitX(grum), GetUnitY(grum)) > config.扇形半径 * config.扇形半径) return false;
  const angle = 取方向角(grum, target);
  return 角度差绝对值(angle, facing) <= config.扇形角度 * 0.5;
}

function 计算重锤伤害(this: void, grum: any, target: any): number {
  const config = 巴尔扎罗斯技能数值配置.熔岩重锤;
  return 计算组合技能伤害(grum, target, {
    来源攻击力比例: config.伤害攻击力比例,
    目标最大生命比例: config.伤害目标最大生命比例,
    总倍率: config.伤害总倍率,
  });
}

function 创建重锤提示(this: void, grum: any, angle: number): void {
  const config = 巴尔扎罗斯技能数值配置.熔岩重锤;
  创建技能提示圈({
    类型: "红色扇形",
    X: GetUnitX(grum),
    Y: GetUnitY(grum),
    朝向: angle,
    扇形模型尺寸: config.扇形半径 / 512,
    持续时间: config.施法硬直秒,
  });
}

function 结算重锤(this: void, context: 巴尔扎罗斯运行时上下文, angle: number): void {
  const grum = context.格鲁姆;
  if (!单位有效(grum)) return;
  const config = 巴尔扎罗斯技能数值配置.熔岩重锤;
  播放点特效(config.冲击波特效路径, GetUnitX(grum), GetUnitY(grum), config.冲击波特效高度, config.冲击波特效缩放, config.特效持续秒, angle);
  播放点特效(config.爆炸特效路径, GetUnitX(grum), GetUnitY(grum), config.爆炸特效高度, config.爆炸特效缩放, config.特效持续秒, angle);
  const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!目标在重锤扇形内(grum, hero, angle)) continue;
    造成格鲁姆Boss技能伤害(grum, hero, 计算重锤伤害(grum, hero), "AOE");
    施加快速控制Buff(grum, hero, 快速控制_击晕, config.眩晕秒);
    施加巴尔扎罗斯灼热(hero, config.灼热层数);
  }
}

export function 释放格鲁姆重锤(this: void, context: 巴尔扎罗斯运行时上下文, target: any): void {
  const grum = context.格鲁姆;
  if (!单位有效(grum) || !单位有效(target)) return;
  const config = 巴尔扎罗斯技能数值配置.熔岩重锤;
  const angle = 取方向角(grum, target);
  创建重锤提示(grum, angle);
  启动基础施法时间线({
    施法者: grum,
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
    播放台词: function 格鲁姆重锤台词(this: void): void {
      播放格鲁姆台词(grum, "熔岩重锤");
    },
    on生效: function 格鲁姆重锤生效(this: void): void {
      结算重锤(context, angle);
    },
  });
}
