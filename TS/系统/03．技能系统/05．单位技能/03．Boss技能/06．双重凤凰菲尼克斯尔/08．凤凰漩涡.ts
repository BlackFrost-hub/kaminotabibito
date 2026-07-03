/** @noSelfInFile */

import { 获取或创建菲尼克斯尔上下文 } from "./03．运行时上下文";
import type { 菲尼克斯尔运行时上下文 } from "./03．运行时上下文";
import { 菲尼克斯尔单位技能配置 } from "./00．配置";
import { 菲尼克斯尔数值与表现配置 } from "./02．数值与表现配置";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import {
  stringToFourCC,
  单位存活,
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
  计算攻击已损失伤害,
  造成火焰伤害,
  添加元素层数,
  取单位X,
  取单位Y,
  两点距离,
  极坐标X,
  极坐标Y,
  移动单位到,
} from "./19．公共工具";
import { 注册Boss技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．Boss技能壳监听注册器";

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;

const RAD_TO_DEG = 57.29577951308232;
const 菲尼克斯尔单位类型ID = stringToFourCC(菲尼克斯尔单位技能配置.单位ID);
const 凤凰漩涡技能ID = stringToFourCC(菲尼克斯尔单位技能配置.技能壳.凤凰漩涡);
let 凤凰漩涡已注册 = false;

export function 释放菲尼克斯尔凤凰漩涡(this: void, context: 菲尼克斯尔运行时上下文, target?: any): void {
  if (context.当前形态 !== "第一形态" || !单位存活(context.Boss)) return;
  const boss = context.Boss;
  const realTarget = 取目标或随机玩家(boss, target);
  if (!单位存活(realTarget)) return;
  const config = 菲尼克斯尔数值与表现配置.凤凰漩涡;
  const x = 取单位X(realTarget);
  const y = 取单位Y(realTarget);
  面向单位(boss, realTarget);
  播放菲尼克斯尔台词(boss, "凤凰漩涡");
  开始施法硬直(boss, config.预警秒);
  设置单位动画(boss, 菲尼克斯尔数值与表现配置.动画.第一形态.漩涡施法.编号, 菲尼克斯尔数值与表现配置.动画.第一形态.漩涡施法.倍速);
  显示常规读条(config.预警秒, config.吟唱条颜色ID, config.吟唱条标题文本, config.吟唱条提示文本);
  创建预警圆(x, y, config.半径, config.预警秒);
  延迟(config.预警秒 * 1000, function 菲尼克斯尔凤凰漩涡开始(this: void): void {
    播放点特效(菲尼克斯尔数值与表现配置.特效.漩涡, x, y, config.持续秒 * 1000);
    let elapsed = 0;
    const tick = 周期(config.Tick秒 * 1000, function 菲尼克斯尔凤凰漩涡Tick(this: void): void {
      elapsed += config.Tick秒;
      const enemies = 范围敌人(boss, x, y, config.半径);
      for (let i = 0; i < enemies.length; i++) {
        const u = enemies[i];
        造成火焰伤害(boss, u, 计算攻击已损失伤害(boss, u, config.伤害Boss攻击力比例, config.伤害目标已损失生命比例));
        添加元素层数(u, "火", config.火印层数);
        const d = 两点距离(取单位X(u), 取单位Y(u), x, y);
        if (d > config.中心半径) {
          const angle = Atan2(y - 取单位Y(u), x - 取单位X(u)) * RAD_TO_DEG;
          移动单位到(u, 极坐标X(取单位X(u), config.牵引距离, angle), 极坐标Y(取单位Y(u), config.牵引距离, angle));
        }
      }
      if (elapsed >= config.持续秒) 停止周期(tick);
    });
    context.清理.登记周期回调("菲尼克斯尔凤凰漩涡Tick", tick);
  });
}

function on菲尼克斯尔凤凰漩涡生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 凤凰漩涡技能ID) return;
  if (!单位存活(castingUnit) || GetUnitTypeId(castingUnit) !== 菲尼克斯尔单位类型ID) return;
  const context = 获取或创建菲尼克斯尔上下文(castingUnit);
  if (context != null) 释放菲尼克斯尔凤凰漩涡(context);
}

export function 注册菲尼克斯尔凤凰漩涡(this: void): void {
  if (凤凰漩涡已注册) return;
  凤凰漩涡已注册 = true;
  注册Boss技能壳监听({
    名称: "菲尼克斯尔凤凰漩涡",
    Boss单位类型ID: 菲尼克斯尔单位类型ID,
    技能ID: 凤凰漩涡技能ID,
    获取或创建上下文: 获取或创建菲尼克斯尔上下文,
    释放技能: function Boss技能壳监听释放(this: void, _context: 菲尼克斯尔运行时上下文, boss: any): void {
      on菲尼克斯尔凤凰漩涡生效(boss, 凤凰漩涡技能ID);
    },
  });
}

