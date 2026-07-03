/** @noSelfInFile */

import type { 菲尼克斯尔运行时上下文 } from "./03．运行时上下文";
import { 获取或创建菲尼克斯尔上下文 } from "./03．运行时上下文";
import { 菲尼克斯尔单位技能配置 } from "./00．配置";
import { 菲尼克斯尔数值与表现配置 } from "./02．数值与表现配置";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import {
  stringToFourCC,
  单位存活,
  取单位X,
  取单位Y,
  取目标或随机玩家,
  面向单位,
  设置单位动画,
  显示常规读条,
  开始施法硬直,
  延迟,
  周期,
  停止周期,
  创建预警圆,
  播放点特效,
  范围敌人,
  计算攻击最大生命伤害,
  造成火焰伤害,
  添加元素层数,
  极坐标X,
  极坐标Y,
} from "./19．公共工具";
import { 注册Boss技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．Boss技能壳监听注册器";

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;

const 菲尼克斯尔单位类型ID = stringToFourCC(菲尼克斯尔单位技能配置.单位ID);
const 炽羽散射技能ID = stringToFourCC(菲尼克斯尔单位技能配置.技能壳.炽羽散射);
let 炽羽散射已注册 = false;

function 创建菲尼克斯尔燃烧区(this: void, context: 菲尼克斯尔运行时上下文, x: number, y: number): void {
  const config = 菲尼克斯尔数值与表现配置.炽羽散射;
  播放点特效(菲尼克斯尔数值与表现配置.特效.燃烧区, x, y, config.燃烧区持续秒 * 1000);
  let elapsed = 0;
  const tick = 周期(config.燃烧Tick秒 * 1000, function 菲尼克斯尔燃烧区Tick(this: void): void {
    elapsed += config.燃烧Tick秒;
    const enemies = 范围敌人(context.Boss, x, y, config.燃烧区半径);
    for (let i = 0; i < enemies.length; i++) {
      const u = enemies[i];
      造成火焰伤害(context.Boss, u, 计算攻击最大生命伤害(context.Boss, u, 0, config.燃烧Tick目标最大生命比例));
      添加元素层数(u, "火", config.火印层数);
    }
    if (elapsed >= config.燃烧区持续秒) 停止周期(tick);
  });
  context.清理.登记周期回调("菲尼克斯尔燃烧区", tick);
}

export function 释放菲尼克斯尔炽羽散射(this: void, context: 菲尼克斯尔运行时上下文, target?: any): void {
  if (context.当前形态 !== "第一形态" || !单位存活(context.Boss)) return;
  const boss = context.Boss;
  const realTarget = 取目标或随机玩家(boss, target);
  if (!单位存活(realTarget)) return;
  const config = 菲尼克斯尔数值与表现配置.炽羽散射;
  面向单位(boss, realTarget);
  播放菲尼克斯尔台词(boss, "炽羽散射");
  开始施法硬直(boss, config.读条秒);
  设置单位动画(boss, 菲尼克斯尔数值与表现配置.动画.第一形态.振翅.编号, 菲尼克斯尔数值与表现配置.动画.第一形态.振翅.倍速);
  显示常规读条(config.读条秒, config.吟唱条颜色ID, config.吟唱条标题文本, config.吟唱条提示文本);
  const centerX = 取单位X(realTarget);
  const centerY = 取单位Y(realTarget);
  for (let i = 0; i < config.羽毛数量; i++) {
    const angle = GetRandomReal(0, 360);
    const dist = GetRandomReal(80, config.扩散半径);
    const x = 极坐标X(centerX, dist, angle);
    const y = 极坐标Y(centerY, dist, angle);
    创建预警圆(x, y, config.落点半径, config.读条秒);
    延迟(config.读条秒 * 1000, function 菲尼克斯尔炽羽落点(this: void): void {
      播放点特效(菲尼克斯尔数值与表现配置.特效.羽毛弹体, x, y, 900);
      const enemies = 范围敌人(boss, x, y, config.落点半径);
      for (let j = 0; j < enemies.length; j++) {
        const u = enemies[j];
        造成火焰伤害(boss, u, 计算攻击最大生命伤害(boss, u, config.羽毛伤害Boss攻击力比例, config.羽毛伤害目标最大生命比例));
        添加元素层数(u, "火", config.火印层数);
      }
      创建菲尼克斯尔燃烧区(context, x, y);
    });
  }
}

function on菲尼克斯尔炽羽散射生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 炽羽散射技能ID) return;
  if (!单位存活(castingUnit) || GetUnitTypeId(castingUnit) !== 菲尼克斯尔单位类型ID) return;
  const context = 获取或创建菲尼克斯尔上下文(castingUnit);
  if (context != null) 释放菲尼克斯尔炽羽散射(context);
}

export function 注册菲尼克斯尔炽羽散射(this: void): void {
  if (炽羽散射已注册) return;
  炽羽散射已注册 = true;
  注册Boss技能壳监听({
    名称: "菲尼克斯尔炽羽散射",
    Boss单位类型ID: 菲尼克斯尔单位类型ID,
    技能ID: 炽羽散射技能ID,
    获取或创建上下文: 获取或创建菲尼克斯尔上下文,
    释放技能: function Boss技能壳监听释放(this: void, _context: 菲尼克斯尔运行时上下文, boss: any): void {
      on菲尼克斯尔炽羽散射生效(boss, 炽羽散射技能ID);
    },
  });
}

