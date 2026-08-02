/** @noSelfInFile */

import { 莫尔特斯单位技能配置 } from "./00．配置";
import { 获取或创建莫尔特斯上下文, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置, 莫尔特斯音效配置 } from "./02．数值与表现配置";
import { 应用莫尔特斯腐败值, 确保莫尔特斯根须宫格 } from "./03．腐败值与根须领域";
import { 播放莫尔特斯台词 } from "./13．台词播放";
import { 单位有效, stringToFourCC } from "./16．公共工具";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 创建点名预警执行器 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/05．点名预警执行器";
import { 获取矩形区域单位 } from "../../../../00．技能模板+函数/01．技能函数/09．形状区域/矩形区域";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const IsUnitEnemy = jass.IsUnitEnemy as (unit: any, player: any) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 莫尔特斯单位类型ID = stringToFourCC(莫尔特斯单位技能配置.单位ID);
const 腐朽根须穿刺技能ID = stringToFourCC(莫尔特斯数值与表现配置.腐朽根须穿刺.技能槽位);
let 已注册 = false;

function 选择根须穿刺格子(this: void, context: 莫尔特斯运行时上下文): any[] {
  const grid = context.根须宫格;
  const result: any[] = [];
  if (grid == null) return result;
  if (context.根须穿刺测试格子索引 != null) {
    for (let i = 0; i < context.根须穿刺测试格子索引.length; i++) {
      const cell = grid.获取格子By索引(context.根须穿刺测试格子索引[i]);
      if (cell != null) result.push(cell);
    }
    return result;
  }
  const pool: any[] = [];
  const 格子列表 = grid.格子列表 as any[];
  for (let i = 0; i < 格子列表.length; i++) pool.push(格子列表[i]);
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
  创建点特效({
    模型路径: cfg.穿刺特效路径,
    X: cell.中心X,
    Y: cell.中心Y,
    持续秒: cfg.瞬时特效持续秒,
    缩放: cfg.穿刺命中特效缩放,
  });
  播放Boss坐标音效(莫尔特斯音效配置.腐朽根须穿刺.结算, cell.中心X, cell.中心Y, 莫尔特斯音效配置.默认裁断距离);
  创建点特效({
    模型路径: cfg.根须特效路径,
    X: cell.中心X,
    Y: cell.中心Y,
    持续秒: cfg.根须停留秒,
    缩放: cfg.根须特效缩放,
    动画索引: cfg.根须模型动画索引,
  });
  const units = 获取矩形区域单位({
    X: cell.中心X,
    Y: cell.中心Y,
    长度: 莫尔特斯数值与表现配置.根须领域.单格边长,
    宽度: 莫尔特斯数值与表现配置.根须领域.单格边长,
    方向角: 0,
  });
  for (let i = 0; i < units.length; i++) {
    const unit = units[i];
    if (单位有效(unit) && IsUnitEnemy(unit, GetOwningPlayer(boss)) === true) {
      执行BossAOE技能伤害({
        技能ID: 腐朽根须穿刺技能ID,
        来源: boss,
        目标: unit,
        伤害公式: { 来源攻击力比例: cfg.Boss攻击力比例 },
        attack: false,
        ranged: false,
        attackType: ATTACK_TYPE_NORMAL,
        伤害类型: DAMAGE_TYPE_PLANT,
        weaponType: WEAPON_TYPE_WHOKNOWS,
      });
      应用莫尔特斯腐败值(context, unit, cfg.腐败值);
    }
  }
}

function 创建根须穿刺格子预警(this: void, context: 莫尔特斯运行时上下文, cell: any, index: number): void {
  const cfg = 莫尔特斯数值与表现配置.腐朽根须穿刺;
  const cellSize = 莫尔特斯数值与表现配置.根须领域.单格边长;
  创建点名预警执行器({
    清理: context.清理,
    名称: "莫尔特斯-腐朽根须穿刺-" + String(index + 1),
    锁定X: cell.中心X,
    锁定Y: cell.中心Y,
    延迟秒: cfg.预警秒,
    提示圈: {
      类型: "矩形",
      X: cell.中心X - cellSize / 2,
      Y: cell.中心Y,
      宽度: cellSize,
      长度: cellSize,
      朝向: 0,
    },
    on结算: function 莫尔特斯根须穿刺结算(this: void): void {
      结算单格根须穿刺(context, cell);
    },
  });
}

export function 释放莫尔特斯腐朽根须穿刺(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  const cfg = 莫尔特斯数值与表现配置.腐朽根须穿刺;
  if (!单位有效(boss)) return;
  确保莫尔特斯根须宫格(context);
  const cells = 选择根须穿刺格子(context);
  for (let i = 0; i < cells.length; i++) {
    创建根须穿刺格子预警(context, cells[i], i);
  }
  启动基础施法时间线({
    名称: "莫尔特斯-腐朽根须穿刺",
    施法者: boss,
    硬直秒: cfg.预警秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    后续动画编号: 0,
    后续动画速度: 1,
    后续动画延迟毫秒: cfg.动作播放秒 * 1000,
    完成后恢复动作: false,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.预警秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
      提示文本: cfg.吟唱条提示文本,
    },
    清理: context.清理,
    播放台词: function 莫尔特斯腐朽根须穿刺台词(this: void): void {
      播放莫尔特斯台词(boss, "腐朽根须穿刺");
    },
    on生效: function 莫尔特斯腐朽根须穿刺时间线生效(this: void): void {
    },
  });
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
