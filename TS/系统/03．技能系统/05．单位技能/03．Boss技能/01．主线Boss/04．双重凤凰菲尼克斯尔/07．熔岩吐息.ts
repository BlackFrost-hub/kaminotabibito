/** @noSelfInFile */

import { 获取或创建菲尼克斯尔上下文 } from "./03．运行时上下文";
import type { 菲尼克斯尔运行时上下文 } from "./03．运行时上下文";
import { 菲尼克斯尔单位技能配置 } from "./00．配置";
import { 菲尼克斯尔数值与表现配置, 菲尼克斯尔音效配置 } from "./02．数值与表现配置";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import { 播放Boss坐标音效, 延迟播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
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
  创建预警扇形,
  单位在扇形内,
  范围敌人,
  计算攻击最大生命伤害,
  造成火焰伤害,
  添加元素层数,
  施加减速,
  取单位X,
  取单位Y,
  极坐标X,
  极坐标Y,
} from "./19．公共工具";
import type { 菲尼克斯尔伤害上下文参数 } from "./19．公共工具";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (unit: any) => number;
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};

const 菲尼克斯尔单位类型ID = stringToFourCC(菲尼克斯尔单位技能配置.单位ID);
const 熔岩吐息技能ID = stringToFourCC(菲尼克斯尔单位技能配置.技能壳.熔岩吐息);
let 熔岩吐息已注册 = false;

function 播放菲尼克斯尔熔岩吐息特效(this: void, boss: any): void {
  const config = 菲尼克斯尔数值与表现配置.熔岩吐息;
  const facing = GetUnitFacing(boss);
  创建点特效({
    模型路径: 菲尼克斯尔数值与表现配置.特效.吐息,
    X: 极坐标X(取单位X(boss), config.吐息特效前移, facing),
    Y: 极坐标Y(取单位Y(boss), config.吐息特效前移, facing),
    Z: GetUnitFlyHeight(boss) + config.吐息特效高度偏移,
    缩放: config.吐息特效缩放,
    Z轴角度: facing + config.吐息特效朝向修正角度,
    持续秒: config.吐息特效持续秒,
  });
}

export function 释放菲尼克斯尔熔岩吐息(this: void, context: 菲尼克斯尔运行时上下文, target?: any, 技能实例ID?: number): void {
  if (context.当前形态 !== "第一形态" || !单位存活(context.Boss)) return;
  const boss = context.Boss;
  const realTarget = 取目标或随机玩家(boss, target);
  if (!单位存活(realTarget)) return;
  const config = 菲尼克斯尔数值与表现配置.熔岩吐息;
  const 伤害上下文: 菲尼克斯尔伤害上下文参数 = { 技能ID: 熔岩吐息技能ID, 技能实例ID, 标签: "菲尼克斯尔熔岩吐息" };
  const hitCount: Record<number, number> = {};
  const 命中累计秒: Record<number, number> = {};
  面向单位(boss, realTarget);
  播放菲尼克斯尔台词(boss, "熔岩吐息");
  开始施法硬直(boss, config.预警秒 + config.持续秒);
  设置单位动画(boss, 菲尼克斯尔数值与表现配置.动画.第一形态.施法弯身.编号, 菲尼克斯尔数值与表现配置.动画.第一形态.施法弯身.倍速);
  显示常规读条(config.预警秒, config.吟唱条颜色ID, config.吟唱条标题文本, config.吟唱条提示文本);
  创建预警扇形(boss, config.半径, config.预警秒);
  播放Boss坐标音效(菲尼克斯尔音效配置.熔岩吐息.张口蓄力, 取单位X(boss), 取单位Y(boss), 菲尼克斯尔音效配置.默认裁断距离);
  延迟播放Boss坐标音效(菲尼克斯尔音效配置.熔岩吐息.持续喷吐, 取单位X(boss), 取单位Y(boss), 菲尼克斯尔音效配置.熔岩吐息.持续喷吐延迟Ms, 菲尼克斯尔音效配置.默认裁断距离);
  延迟(config.预警秒 * 1000, function 菲尼克斯尔熔岩吐息开始(this: void): void {
    let 经过秒 = 0;
    function 执行菲尼克斯尔熔岩吐息Tick(this: void): boolean {
      if (!单位存活(boss) || 经过秒 >= config.持续秒) return false;
      const 剩余秒 = config.持续秒 - 经过秒;
      const 本次覆盖秒 = 剩余秒 < config.Tick秒 ? 剩余秒 : config.Tick秒;
      经过秒 += 本次覆盖秒;
      if (单位存活(realTarget)) 面向单位(boss, realTarget);
      播放菲尼克斯尔熔岩吐息特效(boss);
      const 伤害倍率 = 本次覆盖秒 / config.伤害基准Tick秒;
      const enemies = 范围敌人(boss, 取单位X(boss), 取单位Y(boss), config.半径);
      for (let i = 0; i < enemies.length; i++) {
        const enemy = enemies[i];
        if (!单位在扇形内(boss, enemy, config.半径, config.角度)) continue;
        造成火焰伤害(boss, enemy, 计算攻击最大生命伤害(boss, enemy, config.伤害Boss攻击力比例, config.伤害目标最大生命比例) * 伤害倍率, "AOE", 伤害上下文);
        const id = GetHandleId(enemy) || 0;
        let 累计秒 = (命中累计秒[id] ?? 0) + 本次覆盖秒;
        while (累计秒 + 0.0001 >= config.伤害基准Tick秒) {
          累计秒 -= config.伤害基准Tick秒;
          添加元素层数(enemy, "火", config.火印层数);
          hitCount[id] = (hitCount[id] ?? 0) + 1;
          if (hitCount[id] >= config.减速命中次数) 施加减速(boss, enemy, config.减速比例, config.减速持续秒);
        }
        命中累计秒[id] = 累计秒;
      }
      return 经过秒 + 0.0001 < config.持续秒;
    }

    if (!执行菲尼克斯尔熔岩吐息Tick()) return;
    const tick = 周期(config.Tick秒 * 1000, function 菲尼克斯尔熔岩吐息Tick(this: void): void {
      if (!执行菲尼克斯尔熔岩吐息Tick()) 停止周期(tick);
    });
    context.清理.登记周期回调("菲尼克斯尔熔岩吐息Tick", tick);
  });
}

function on菲尼克斯尔熔岩吐息生效(this: void, castingUnit: any, spellAbilityId: number, 技能实例ID?: number): void {
  if (spellAbilityId !== 熔岩吐息技能ID) return;
  if (!单位存活(castingUnit) || GetUnitTypeId(castingUnit) !== 菲尼克斯尔单位类型ID) return;
  const context = 获取或创建菲尼克斯尔上下文(castingUnit);
  if (context != null) 释放菲尼克斯尔熔岩吐息(context, undefined, 技能实例ID);
}

export function 注册菲尼克斯尔熔岩吐息(this: void): void {
  if (熔岩吐息已注册) return;
  熔岩吐息已注册 = true;
  注册单位技能壳监听({
    名称: "菲尼克斯尔熔岩吐息",
    单位类型ID: 菲尼克斯尔单位类型ID,
    技能ID: 熔岩吐息技能ID,
    获取或创建上下文: 获取或创建菲尼克斯尔上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 菲尼克斯尔运行时上下文, boss: any, 技能实例ID?: number): void {
      on菲尼克斯尔熔岩吐息生效(boss, 熔岩吐息技能ID, 技能实例ID);
    },
  });
}

