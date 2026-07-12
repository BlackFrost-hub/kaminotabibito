/** @noSelfInFile */

import { 莫尔特斯单位技能配置 } from "./00．配置";
import { 获取或创建莫尔特斯上下文, 取玩家腐败值, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置, 莫尔特斯音效配置 } from "./02．数值与表现配置";
import { 应用莫尔特斯腐败值 } from "./03．腐败值与根须领域";
import { 播放莫尔特斯台词 } from "./13．台词播放";
import { 单位有效, 点到线段距离平方, stringToFourCC } from "./16．公共工具";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../../00．公共/00．Boss音效播放";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;

const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 施加恐惧 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加恐惧: (this: void, source: any, target: any, params: any) => number;
};

const 莫尔特斯单位类型ID = stringToFourCC(莫尔特斯单位技能配置.单位ID);
const 古木悲鸣技能ID = stringToFourCC(莫尔特斯数值与表现配置.古木悲鸣.技能槽位);
let 已注册 = false;

function 玩家被蘑菇遮挡(this: void, context: 莫尔特斯运行时上下文, hero: any): boolean {
  const grid = context.根须宫格;
  if (grid == null) return false;
  const cfg = 莫尔特斯数值与表现配置.古木悲鸣;
  const bx = GetUnitX(context.Boss单位);
  const by = GetUnitY(context.Boss单位);
  const hx = GetUnitX(hero);
  const hy = GetUnitY(hero);
  const cells = [
    grid.获取格子(0, 1),
    grid.获取格子(1, 0),
    grid.获取格子(1, 2),
    grid.获取格子(2, 1),
  ];
  for (let i = 0; i < cells.length; i++) {
    const cell = cells[i];
    if (cell == null) continue;
    const dxBoss = cell.中心X - bx;
    const dyBoss = cell.中心Y - by;
    const dxHero = hx - bx;
    const dyHero = hy - by;
    if (dxBoss * dxHero + dyBoss * dyHero <= 0) continue;
    const heroDist2 = dxHero * dxHero + dyHero * dyHero;
    const mushDist2 = dxBoss * dxBoss + dyBoss * dyBoss;
    if (mushDist2 >= heroDist2) continue;
    if (点到线段距离平方(cell.中心X, cell.中心Y, bx, by, hx, hy) <= cfg.蘑菇遮挡半径 * cfg.蘑菇遮挡半径) return true;
  }
  return false;
}

function 确保悲鸣蘑菇表现(this: void, context: 莫尔特斯运行时上下文): void {
  const grid = context.根须宫格;
  if (grid == null) return;
  const cfg = 莫尔特斯数值与表现配置.古木悲鸣;
  const cells = [
    grid.获取格子(0, 1),
    grid.获取格子(1, 0),
    grid.获取格子(1, 2),
    grid.获取格子(2, 1),
  ];
  for (let i = 0; i < cells.length; i++) {
    const cell = cells[i];
    if (cell == null) continue;
    const effect = AddSpecialEffect(cfg.巨型蘑菇模型列表[i], cell.中心X, cell.中心Y);
    context.清理.登记特效("莫尔特斯-古木悲鸣蘑菇", effect);
  }
}

export function 释放莫尔特斯古木悲鸣(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 莫尔特斯数值与表现配置.古木悲鸣;
  播放莫尔特斯台词(boss, "古木悲鸣");
  确保悲鸣蘑菇表现(context);
  AddSpecialEffect(cfg.悲鸣特效路径, GetUnitX(boss), GetUnitY(boss));
  播放Boss坐标音效(莫尔特斯音效配置.古木悲鸣.悲鸣波, GetUnitX(boss), GetUnitY(boss), 莫尔特斯音效配置.默认裁断距离);
  尝试播放Boss拟声池({
    标识: 莫尔特斯音效配置.怪物拟声.标识,
    音效路径列表: 莫尔特斯音效配置.怪物拟声.音效路径列表,
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    裁断距离: 莫尔特斯音效配置.默认裁断距离,
    冷却Ms: 莫尔特斯音效配置.怪物拟声.冷却Ms,
    触发概率百分比: 莫尔特斯音效配置.怪物拟声.关键机制触发概率百分比,
  });
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (玩家被蘑菇遮挡(context, hero)) continue;
    const before = 取玩家腐败值(context, hero);
    应用莫尔特斯腐败值(context, hero, cfg.腐败值);
    if (before >= cfg.恐惧阈值) {
      施加恐惧(boss, hero, {
        持续时间: cfg.恐惧秒,
        模式: "随机乱跑",
        随机半径: 450,
        移动速度: 50,
      });
    }
  }
}

function on莫尔特斯古木悲鸣施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 古木悲鸣技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 莫尔特斯单位类型ID) return;
  const context = 获取或创建莫尔特斯上下文(castingUnit);
  if (context == null) return;
  释放莫尔特斯古木悲鸣(context);
}

export function 注册莫尔特斯古木悲鸣(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "11．古木悲鸣",
    单位类型ID: 莫尔特斯单位类型ID,
    技能ID: 古木悲鸣技能ID,
    获取或创建上下文: 获取或创建莫尔特斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 莫尔特斯运行时上下文, boss: any): void {
      on莫尔特斯古木悲鸣施法(boss, 古木悲鸣技能ID);
    },
  });
}
