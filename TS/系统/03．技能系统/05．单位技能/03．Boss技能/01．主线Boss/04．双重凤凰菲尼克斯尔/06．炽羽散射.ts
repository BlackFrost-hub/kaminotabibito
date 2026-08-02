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
  取菲尼克斯尔技能强度倍率,
  添加元素层数,
  极坐标X,
  极坐标Y,
} from "./19．公共工具";
import type { 菲尼克斯尔伤害上下文参数 } from "./19．公共工具";
import { 创建二阶贝塞尔XYZ轨迹, 创建原生弹幕 } from "../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (unit: any) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, animationIndex: number) => void;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const bj_RADTODEG = (jass.bj_RADTODEG ?? 57.29577951308232) as number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 菲尼克斯尔单位类型ID = stringToFourCC(菲尼克斯尔单位技能配置.单位ID);
const 炽羽散射技能ID = stringToFourCC(菲尼克斯尔单位技能配置.技能壳.炽羽散射);
let 炽羽散射已注册 = false;

export function 创建菲尼克斯尔燃烧区(this: void, context: 菲尼克斯尔运行时上下文, x: number, y: number, 伤害上下文: 菲尼克斯尔伤害上下文参数): void {
  const config = 菲尼克斯尔数值与表现配置.炽羽散射;
  播放点特效(菲尼克斯尔数值与表现配置.特效.燃烧区, x, y, config.燃烧区持续秒 * 1000);
  let elapsed = 0;
  const tick = 周期(config.燃烧Tick秒 * 1000, function 菲尼克斯尔燃烧区Tick(this: void): void {
    elapsed += config.燃烧Tick秒;
    const enemies = 范围敌人(context.Boss, x, y, config.燃烧区半径);
    for (let i = 0; i < enemies.length; i++) {
      const u = enemies[i];
      if (单位存活(context.Boss) && 单位存活(u)) {
        执行BossAOE技能伤害({
          技能ID: 伤害上下文?.技能ID,
          技能实例ID: 伤害上下文?.技能实例ID,
          标签: 伤害上下文?.标签,
          来源: context.Boss,
          目标: u,
          伤害公式: {
            目标最大生命比例: config.燃烧Tick目标最大生命比例,
            总倍率: 取菲尼克斯尔技能强度倍率(context.Boss),
          },
          ranged: true,
          attackType: ATTACK_TYPE_NORMAL,
          伤害类型: DAMAGE_TYPE_FIRE,
          weaponType: WEAPON_TYPE_WHOKNOWS,
        });
      }
      添加元素层数(u, "火", config.火印层数);
    }
    if (elapsed >= config.燃烧区持续秒) 停止周期(tick);
  });
  context.清理.登记周期回调("菲尼克斯尔燃烧区", tick);
}

function 取坐标朝向角(this: void, fromX: number, fromY: number, toX: number, toY: number): number {
  return (Atan2(toY - fromY, toX - fromX) as number) * bj_RADTODEG;
}

function 结算菲尼克斯尔炽羽落点(this: void, context: 菲尼克斯尔运行时上下文, boss: any, x: number, y: number, 伤害上下文: 菲尼克斯尔伤害上下文参数): void {
  if (!单位存活(boss)) return;
  const config = 菲尼克斯尔数值与表现配置.炽羽散射;
  播放点特效(菲尼克斯尔数值与表现配置.特效.羽毛命中, x, y, config.羽毛命中特效持续秒 * 1000);
  const enemies = 范围敌人(boss, x, y, config.落点半径);
  for (let i = 0; i < enemies.length; i++) {
    const u = enemies[i];
    if (单位存活(boss) && 单位存活(u)) {
      执行BossAOE技能伤害({
        技能ID: 伤害上下文?.技能ID,
        技能实例ID: 伤害上下文?.技能实例ID,
        标签: 伤害上下文?.标签,
        来源: boss,
        目标: u,
        伤害公式: {
          来源攻击力比例: config.羽毛伤害Boss攻击力比例,
          目标最大生命比例: config.羽毛伤害目标最大生命比例,
          总倍率: 取菲尼克斯尔技能强度倍率(boss),
        },
        ranged: true,
        attackType: ATTACK_TYPE_NORMAL,
        伤害类型: DAMAGE_TYPE_FIRE,
        weaponType: WEAPON_TYPE_WHOKNOWS,
      });
    }
    添加元素层数(u, "火", config.火印层数);
  }
  创建菲尼克斯尔燃烧区(context, x, y, 伤害上下文);
}

export function 释放菲尼克斯尔炽羽散射(this: void, context: 菲尼克斯尔运行时上下文, target?: any, 技能实例ID?: number): void {
  if (context.当前形态 !== "第一形态" || !单位存活(context.Boss)) return;
  const boss = context.Boss;
  const realTarget = 取目标或随机玩家(boss, target);
  if (!单位存活(realTarget)) return;
  const config = 菲尼克斯尔数值与表现配置.炽羽散射;
  const 伤害上下文: 菲尼克斯尔伤害上下文参数 = { 技能ID: 炽羽散射技能ID, 技能实例ID, 标签: "菲尼克斯尔炽羽散射" };
  面向单位(boss, realTarget);
  播放菲尼克斯尔台词(boss, "炽羽散射");
  开始施法硬直(boss, config.读条秒);
  设置单位动画(boss, 菲尼克斯尔数值与表现配置.动画.第一形态.炽羽攻击.编号, 菲尼克斯尔数值与表现配置.动画.第一形态.炽羽攻击.倍速);
  显示常规读条(config.读条秒, config.吟唱条颜色ID, config.吟唱条标题文本, config.吟唱条提示文本);
  const centerX = 取单位X(realTarget);
  const centerY = 取单位Y(realTarget);
  for (let i = 0; i < config.羽毛数量; i++) {
    const angle = GetRandomReal(0, 360);
    const dist = GetRandomReal(80, config.扩散半径);
    const x = 极坐标X(centerX, dist, angle);
    const y = 极坐标Y(centerY, dist, angle);
    创建预警圆(x, y, config.落点半径, config.读条秒);
    延迟(config.读条秒 * 1000, function 菲尼克斯尔炽羽发射(this: void): void {
      if (!单位存活(boss)) return;
      const startX = 取单位X(boss);
      const startY = 取单位Y(boss);
      const startZ = GetUnitFlyHeight(boss);
      const face = 取坐标朝向角(startX, startY, x, y);
      const curveOffset = GetRandomReal(-config.贝塞尔侧弯最大距离, config.贝塞尔侧弯最大距离);
      const controlX = 极坐标X((startX + x) * 0.5, curveOffset, face + 90);
      const controlY = 极坐标Y((startY + y) * 0.5, curveOffset, face + 90);
      const projectile = 创建原生弹幕({
        所有者: boss,
        X: startX,
        Y: startY,
        方向角: face,
        速度: 0,
        生命周期: config.羽毛飞行秒,
        命中半径: 0,
        碰撞消失: false,
        禁用碰撞: true,
        不可阻挡: true,
        模型: 菲尼克斯尔数值与表现配置.特效.羽毛弹体,
        飞行高度: startZ,
        轨迹采样器: 创建二阶贝塞尔XYZ轨迹(
          startX, startY, startZ,
          controlX, controlY, startZ * config.贝塞尔控制高度比例,
          x, y, 0,
        ),
        on到达目标点: function 菲尼克斯尔炽羽到达(this: void, _弹幕ID: number, _原因: "完成" | "距离结束"): void {
          结算菲尼克斯尔炽羽落点(context, boss, x, y, 伤害上下文);
        },
      });
      SetUnitAnimationByIndex(projectile.弹幕单位, 1);
    });
  }
}

function on菲尼克斯尔炽羽散射生效(this: void, castingUnit: any, spellAbilityId: number, 技能实例ID?: number): void {
  if (spellAbilityId !== 炽羽散射技能ID) return;
  if (!单位存活(castingUnit) || GetUnitTypeId(castingUnit) !== 菲尼克斯尔单位类型ID) return;
  const context = 获取或创建菲尼克斯尔上下文(castingUnit);
  if (context != null) 释放菲尼克斯尔炽羽散射(context, undefined, 技能实例ID);
}

export function 注册菲尼克斯尔炽羽散射(this: void): void {
  if (炽羽散射已注册) return;
  炽羽散射已注册 = true;
  注册单位技能壳监听({
    名称: "菲尼克斯尔炽羽散射",
    单位类型ID: 菲尼克斯尔单位类型ID,
    技能ID: 炽羽散射技能ID,
    获取或创建上下文: 获取或创建菲尼克斯尔上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 菲尼克斯尔运行时上下文, boss: any, 技能实例ID?: number): void {
      on菲尼克斯尔炽羽散射生效(boss, 炽羽散射技能ID, 技能实例ID);
    },
  });
}

