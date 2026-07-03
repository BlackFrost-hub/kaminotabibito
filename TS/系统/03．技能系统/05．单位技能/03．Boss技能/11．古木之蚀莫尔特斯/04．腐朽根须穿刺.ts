/** @noSelfInFile */

import { 莫尔特斯单位技能配置 } from "./00．配置";
import { 获取或创建莫尔特斯上下文, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置 } from "./02．数值与表现配置";
import { 应用莫尔特斯腐败值 } from "./03．腐败值与根须领域";
import { 播放莫尔特斯台词 } from "./13．台词播放";
import { 单位有效, stringToFourCC } from "./16．公共工具";

const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const IsUnitEnemy = jass.IsUnitEnemy as (unit: any, player: any) => boolean;
const CreateGroup = jass.CreateGroup as () => any;
const DestroyGroup = jass.DestroyGroup as (group: any) => void;
const GroupEnumUnitsInRect = jass.GroupEnumUnitsInRect as (group: any, rect: any, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (group: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (group: any, unit: any) => void;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};

const 莫尔特斯单位类型ID = stringToFourCC(莫尔特斯单位技能配置.单位ID);
const 腐朽根须穿刺技能ID = stringToFourCC(莫尔特斯数值与表现配置.腐朽根须穿刺.技能槽位);
let 已注册 = false;

function 选择根须穿刺格子(this: void, context: 莫尔特斯运行时上下文): any[] {
  const grid = context.根须宫格;
  const result: any[] = [];
  if (grid == null) return result;
  const pool: any[] = [];
  for (let i = 0; i < grid.格子列表.length; i++) pool.push(grid.格子列表[i]);
  const count = 莫尔特斯数值与表现配置.腐朽根须穿刺.区域数量;
  for (let i = 0; i < count && pool.length > 0; i++) {
    const index = GetRandomInt(0, pool.length - 1);
    result.push(pool[index]);
    pool.splice(index, 1);
  }
  return result;
}

function 结算单格根须穿刺(this: void, context: 莫尔特斯运行时上下文, cell: any): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 莫尔特斯数值与表现配置.腐朽根须穿刺;
  AddSpecialEffect(cfg.穿刺特效路径, cell.中心X, cell.中心Y);
  创建可攻击机制单位({
    清理: context.清理,
    名称: "莫尔特斯-残留根须",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: cfg.障碍单位类型,
    模型路径: cfg.根须模型路径,
    X: cell.中心X,
    Y: cell.中心Y,
    最大生命: cfg.障碍生命值,
    缩放: cfg.障碍缩放,
    持续时间: cfg.根须停留秒,
  });
  const group = CreateGroup();
  GroupEnumUnitsInRect(group, cell.矩形, null);
  let unit = FirstOfGroup(group);
  const damage = 读取单位攻击力(boss) * cfg.Boss攻击力比例;
  while (unit != null && unit !== 0) {
    GroupRemoveUnit(group, unit);
    if (单位有效(unit) && IsUnitEnemy(unit, GetOwningPlayer(boss)) === true) {
      UnitDamageTarget(boss, unit, damage, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS);
      应用莫尔特斯腐败值(context, unit, cfg.腐败值);
    }
    unit = FirstOfGroup(group);
  }
  DestroyGroup(group);
}

function 释放莫尔特斯腐朽根须穿刺(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  const cfg = 莫尔特斯数值与表现配置.腐朽根须穿刺;
  if (!单位有效(boss)) return;
  播放莫尔特斯台词(boss, "腐朽根须穿刺");
  const cells = 选择根须穿刺格子(context);
  for (let i = 0; i < cells.length; i++) {
    const cell = cells[i];
    创建技能提示圈({
      类型: "矩形",
      X: cell.中心X,
      Y: cell.中心Y,
      宽度: 莫尔特斯数值与表现配置.根须领域.单格边长,
      长度: 莫尔特斯数值与表现配置.根须领域.单格边长,
      朝向: 0,
      持续时间: cfg.预警秒,
    });
    const id = addDelayedCallback(cfg.预警秒 * 1000, function 莫尔特斯根须穿刺延迟结算(this: void): void {
      结算单格根须穿刺(context, cell);
    });
    context.清理.登记延迟回调("莫尔特斯-腐朽根须穿刺", id);
  }
}

function on莫尔特斯腐朽根须穿刺施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 腐朽根须穿刺技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 莫尔特斯单位类型ID) return;
  const context = 获取或创建莫尔特斯上下文(castingUnit);
  if (context == null) return;
  释放莫尔特斯腐朽根须穿刺(context);
}

export function 注册莫尔特斯腐朽根须穿刺(this: void): void {
  if (已注册) return;
  已注册 = true;
  registerSpellEffectListener(on莫尔特斯腐朽根须穿刺施法);
}
