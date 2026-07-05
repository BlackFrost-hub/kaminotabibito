/** @noSelfInFile */

import { 莫尔特斯单位技能配置 } from "./00．配置";
import { 获取或创建莫尔特斯上下文, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置 } from "./02．数值与表现配置";
import { 应用莫尔特斯腐败值 } from "./03．腐败值与根须领域";
import { 播放莫尔特斯台词 } from "./13．台词播放";
import { 单位有效, stringToFourCC } from "./16．公共工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
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

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
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

interface 根须穿刺延迟变量 {
  context: 莫尔特斯运行时上下文;
  cell: any;
}

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
      造成AOE技能伤害({
        技能ID: 腐朽根须穿刺技能ID,
        来源: boss,
        目标: unit,
        伤害: damage,
        attack: false,
        ranged: false,
        attackType: ATTACK_TYPE_NORMAL,
        伤害类型: DAMAGE_TYPE_PLANT,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: "Boss技能",
      });
      应用莫尔特斯腐败值(context, unit, cfg.腐败值);
    }
    unit = FirstOfGroup(group);
  }
  DestroyGroup(group);
}

function 莫尔特斯根须穿刺延迟结算(this: void, variable?: any): void {
  const data = variable as 根须穿刺延迟变量 | undefined;
  if (data == null) return;
  结算单格根须穿刺(data.context, data.cell);
}

export function 释放莫尔特斯腐朽根须穿刺(this: void, context: 莫尔特斯运行时上下文): void {
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
    const id = addDelayedCallback(cfg.预警秒 * 1000, 莫尔特斯根须穿刺延迟结算, { context, cell } as 根须穿刺延迟变量);
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
  注册单位技能壳监听({
    名称: "04．腐朽根须穿刺",
    单位类型ID: 莫尔特斯单位类型ID,
    技能ID: 腐朽根须穿刺技能ID,
    获取或创建上下文: 获取或创建莫尔特斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 莫尔特斯运行时上下文, boss: any): void {
      on莫尔特斯腐朽根须穿刺施法(boss, 腐朽根须穿刺技能ID);
    },
  });
}
