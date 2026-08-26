/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "../03．运行时上下文";
import { 立即设置单位朝向 } from "../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待";
import { 执行BossAOE技能伤害 } from "../../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
import { 单位间角度, 角度差绝对值 } from "../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
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
  CosBJ,
  SinBJ,
  ATTACK_TYPE_NORMAL,
  DAMAGE_TYPE_FIRE,
  WEAPON_TYPE_WHOKNOWS,
  快速控制_击晕,
  单位有效,
  点到单位距离平方,
  造成格鲁姆Boss技能伤害,
  播放点特效,
} = 格鲁姆公共;

function 目标在重锤扇形内(this: void, grum: any, target: any, facing: number): boolean {
  const config = 巴尔扎罗斯技能数值配置.熔岩重锤;
  if (!单位有效(grum) || !单位有效(target)) return false;
  if (点到单位距离平方(target, GetUnitX(grum), GetUnitY(grum)) > config.扇形半径 * config.扇形半径) return false;
  const angle = 单位间角度(grum, target);
  return 角度差绝对值(angle, facing) <= config.扇形角度 * 0.5;
}

function 创建重锤提示(this: void, grum: any, angle: number): void {
  const config = 巴尔扎罗斯技能数值配置.熔岩重锤;
  创建技能提示圈({
    类型: "红色扇形",
    X: GetUnitX(grum),
    Y: GetUnitY(grum),
    朝向: angle,
    扇形角度: config.扇形角度,
    扇形模型尺寸: config.扇形半径 / 512,
    持续时间: config.施法硬直秒,
  });
}

function 结算重锤(this: void, context: 巴尔扎罗斯运行时上下文, angle: number): void {
  const grum = context.格鲁姆;
  if (!单位有效(grum)) return;
  const config = 巴尔扎罗斯技能数值配置.熔岩重锤;
  const 爆炸X = GetUnitX(grum) + CosBJ(angle) * config.扇形半径 * 0.5;
  const 爆炸Y = GetUnitY(grum) + SinBJ(angle) * config.扇形半径 * 0.5;
  播放点特效(config.冲击波特效路径, GetUnitX(grum), GetUnitY(grum), config.冲击波特效高度, config.冲击波特效缩放, config.特效持续秒, angle);
  播放点特效(config.爆炸特效路径, 爆炸X, 爆炸Y, config.爆炸特效高度, config.爆炸特效缩放, config.特效持续秒, angle);
  播放点特效(config.爆炸叠加特效路径, 爆炸X, 爆炸Y, config.爆炸特效高度, config.爆炸叠加特效缩放, config.特效持续秒, angle);
  const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!目标在重锤扇形内(grum, hero, angle)) continue;
    执行BossAOE技能伤害({
      来源: grum,
      目标: hero,
      伤害公式: {
        来源攻击力比例: config.伤害攻击力比例,
        目标最大生命比例: config.伤害目标最大生命比例,
        总倍率: config.伤害总倍率,
      },
      attack: false,
      ranged: true,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_FIRE,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      标签: "格鲁姆-熔岩重锤",
    });
    施加快速控制Buff(grum, hero, 快速控制_击晕, config.眩晕秒);
    施加巴尔扎罗斯灼热(context, hero, config.灼热层数);
  }
}

export function 释放格鲁姆重锤(this: void, context: 巴尔扎罗斯运行时上下文, target: any): void {
  const grum = context.格鲁姆;
  if (!单位有效(grum) || !单位有效(target)) return;
  const config = 巴尔扎罗斯技能数值配置.熔岩重锤;
  const angle = 单位间角度(grum, target);
  // 预警、命中扇形和格鲁姆本体必须共享同一帧的朝向快照。
  立即设置单位朝向(grum, angle);
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
