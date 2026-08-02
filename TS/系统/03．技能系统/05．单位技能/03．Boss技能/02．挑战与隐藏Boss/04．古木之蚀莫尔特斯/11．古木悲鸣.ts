/** @noSelfInFile */

import { 莫尔特斯单位技能配置 } from "./00．配置";
import { 获取或创建莫尔特斯上下文, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置, 莫尔特斯音效配置 } from "./02．数值与表现配置";
import { 应用莫尔特斯腐败值, 确保莫尔特斯根须宫格 } from "./03．腐败值与根须领域";
import { 播放莫尔特斯台词 } from "./13．台词播放";
import {
  单位有效,
  取单位ID,
  stringToFourCC,
  点是否处于方向障碍物后方,
  取坐标角度,
} from "./16．公共工具";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../../00．公共/00．Boss音效播放";
import { 创建原生弹幕, 销毁原生弹幕 } from "../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
const { 设置特效缩放, 创建Dz绑定单位特效, 获取Dz绑定单位特效, 销毁Dz绑定单位特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  设置特效缩放: (this: void, 特效: any, 缩放: number) => void;
  创建Dz绑定单位特效: (this: void, 单位: any, 挂接点: string, 模型路径: string, 特效键?: string, 缩放?: number) => any;
  获取Dz绑定单位特效: (this: void, 单位: any, 特效键?: string) => any;
  销毁Dz绑定单位特效: (this: void, 单位: any, 特效键?: string) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 特效显示_隐藏 } = require("平台扩展API动作") as {
  特效显示_隐藏: (this: void, 特效: any, 是否显示: boolean) => void;
};
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetUnitStateJapi = (require("jass.japi") as any).GetUnitState as (this: void, unit: any, state: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { 施加恐惧 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加恐惧: (this: void, source: any, target: any, params: any) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};

const 莫尔特斯单位类型ID = stringToFourCC(莫尔特斯单位技能配置.单位ID);
const 古木悲鸣技能ID = stringToFourCC(莫尔特斯数值与表现配置.古木悲鸣.技能槽位);
let 已注册 = false;

interface 古木悲鸣弹幕状态 {
  context: 莫尔特斯运行时上下文;
  中心X: number;
  中心Y: number;
  方向角: number;
  蘑菇坐标列表: Array<{ X: number; Y: number }>;
  已命中目标: Record<number, boolean>;
  安全区状态: 古木悲鸣安全区状态;
}

interface 古木悲鸣安全护盾记录 {
  单位: any;
  特效: any;
}

interface 古木悲鸣安全区状态 {
  context: 莫尔特斯运行时上下文;
  安全护盾目标: Record<number, boolean>;
  安全护盾记录列表: 古木悲鸣安全护盾记录[];
  已登记清理: boolean;
}

interface 古木悲鸣蘑菇格子 {
  行: number;
  列: number;
  X: number;
  Y: number;
  通道键列表: string[];
}

interface 古木悲鸣蘑菇表现状态 {
  特效列表: any[];
  格子列表: 古木悲鸣蘑菇格子[];
  已清理: boolean;
}

const 古木悲鸣弹幕状态表: Record<number, 古木悲鸣弹幕状态 | undefined> = {};
const 古木悲鸣安全护盾特效键 = "莫尔特斯-古木悲鸣安全区护盾";

function 销毁古木悲鸣安全护盾记录(this: void, 记录: 古木悲鸣安全护盾记录): void {
  if (记录 == null || 记录.单位 == null || 记录.单位 === 0) return;
  const current = 获取Dz绑定单位特效(记录.单位, 古木悲鸣安全护盾特效键);
  if (current === 记录.特效) 销毁Dz绑定单位特效(记录.单位, 古木悲鸣安全护盾特效键);
}

function 清理古木悲鸣安全区护盾(this: void, state: 古木悲鸣安全区状态): void {
  if (state == null) return;
  for (let i = 0; i < state.安全护盾记录列表.length; i++) {
    销毁古木悲鸣安全护盾记录(state.安全护盾记录列表[i]);
  }
  state.安全护盾记录列表 = [];
}

function 延迟清理古木悲鸣安全区护盾(this: void, variable?: any): void {
  销毁古木悲鸣安全护盾记录(variable as 古木悲鸣安全护盾记录);
}

function 绑定古木悲鸣安全区护盾(this: void, state: 古木悲鸣安全区状态, target: any): void {
  const targetId = 取单位ID(target);
  if (targetId === 0 || state.安全护盾目标[targetId] === true) return;
  const cfg = 莫尔特斯数值与表现配置.古木悲鸣;
  const effect = 创建Dz绑定单位特效(
    target,
    "origin",
    cfg.安全区护盾特效路径,
    古木悲鸣安全护盾特效键,
    cfg.安全区护盾特效缩放,
  );
  if (effect == null || effect === 0) return;
  state.安全护盾目标[targetId] = true;
  const record: 古木悲鸣安全护盾记录 = { 单位: target, 特效: effect };
  state.安全护盾记录列表.push(record);
  if (!state.已登记清理) {
    state.已登记清理 = true;
    state.context.清理.登记清理("莫尔特斯-古木悲鸣安全区护盾", 清理古木悲鸣安全区护盾, state);
  }
  const delayedId = addDelayedCallback(cfg.安全区护盾持续秒 * 1000, 延迟清理古木悲鸣安全区护盾, record);
  state.context.清理.登记延迟回调("莫尔特斯-古木悲鸣安全区护盾到期", delayedId);
}

function 清理古木悲鸣蘑菇表现(this: void, state: 古木悲鸣蘑菇表现状态): void {
  if (state == null || state.已清理) return;
  for (let i = 0; i < state.特效列表.length; i++) {
    const effect = state.特效列表[i];
    if (effect != null && effect !== 0) {
      特效显示_隐藏(effect, false);
      DestroyEffect(effect);
    }
  }
  state.特效列表 = [];
  state.格子列表 = [];
  state.已清理 = true;
}

function 延迟清理古木悲鸣蘑菇表现(this: void, variable?: any): void {
  清理古木悲鸣蘑菇表现(variable as 古木悲鸣蘑菇表现状态);
}

function 读取古木悲鸣中心(this: void, context: 莫尔特斯运行时上下文): { X: number; Y: number } {
  if (context.根须领域中心X != null && context.根须领域中心Y != null) {
    return { X: context.根须领域中心X, Y: context.根须领域中心Y };
  }
  const grid = context.根须宫格;
  const 首格 = grid != null ? grid.获取格子(0, 0) : undefined;
  const 末格 = grid != null ? grid.获取格子(2, 2) : undefined;
  if (首格 != null && 末格 != null) {
    return { X: (首格.左 + 末格.右) / 2, Y: (首格.下 + 末格.上) / 2 };
  }
  const boss = context.Boss单位;
  return { X: GetUnitX(boss), Y: GetUnitY(boss) };
}

// 角格同时属于相邻两条边界路径，选择时分别计入两条路径的上限。
function 获取蘑菇路径通道(this: void, 行: number, 列: number): string[] {
  const result: string[] = [];
  if (行 === 0) result.push("下侧通道");
  if (行 === 2) result.push("上侧通道");
  if (列 === 0) result.push("左侧通道");
  if (列 === 2) result.push("右侧通道");
  return result;
}

function 构造悲鸣蘑菇候选格子(this: void, grid: any): 古木悲鸣蘑菇格子[] {
  const result: 古木悲鸣蘑菇格子[] = [];
  for (let 行 = 0; 行 < 3; 行++) {
    for (let 列 = 0; 列 < 3; 列++) {
      if (行 === 1 && 列 === 1) continue;
      const cell = grid.获取格子(行, 列);
      if (cell == null) continue;
      result.push({
        行,
        列,
        X: cell.中心X,
        Y: cell.中心Y,
        通道键列表: 获取蘑菇路径通道(行, 列),
      });
    }
  }
  return result;
}

function 选择悲鸣蘑菇格子(this: void, grid: any): 古木悲鸣蘑菇格子[] {
  const cfg = 莫尔特斯数值与表现配置.古木悲鸣;
  const pool = 构造悲鸣蘑菇候选格子(grid);
  const result: 古木悲鸣蘑菇格子[] = [];
  const 通道数量: Record<string, number> = {};
  for (let i = 0; i < cfg.蘑菇数量; i++) {
    const 可选格子: 古木悲鸣蘑菇格子[] = [];
    for (let j = 0; j < pool.length; j++) {
      const candidate = pool[j];
      let 超过通道上限 = false;
      for (let k = 0; k < candidate.通道键列表.length; k++) {
        const 通道键 = candidate.通道键列表[k];
        if ((通道数量[通道键] ?? 0) >= cfg.蘑菇同通道上限) {
          超过通道上限 = true;
          break;
        }
      }
      if (!超过通道上限) 可选格子.push(candidate);
    }
    if (可选格子.length <= 0) break;
    const selected = 可选格子[GetRandomInt(0, 可选格子.length - 1)];
    result.push(selected);
    for (let j = 0; j < selected.通道键列表.length; j++) {
      const 通道键 = selected.通道键列表[j];
      通道数量[通道键] = (通道数量[通道键] ?? 0) + 1;
    }
    const poolIndex = pool.indexOf(selected);
    if (poolIndex >= 0) pool.splice(poolIndex, 1);
  }
  return result;
}

function 获取悲鸣蘑菇坐标(this: void, context: 莫尔特斯运行时上下文): Array<{ X: number; Y: number }> {
  const state = (context as any).__moltesAncientMushroomState as 古木悲鸣蘑菇表现状态 | undefined;
  const result: Array<{ X: number; Y: number }> = [];
  if (state == null || state.格子列表 == null) return result;
  for (let i = 0; i < state.格子列表.length; i++) {
    const cell = state.格子列表[i];
    result.push({ X: cell.X, Y: cell.Y });
  }
  return result;
}

function 古木悲鸣目标被蘑菇遮挡(this: void, state: 古木悲鸣弹幕状态, target: any): boolean {
  const cfg = 莫尔特斯数值与表现配置.古木悲鸣;
  const targetX = GetUnitX(target);
  const targetY = GetUnitY(target);
  for (let i = 0; i < state.蘑菇坐标列表.length; i++) {
    const mushroom = state.蘑菇坐标列表[i];
    if (点是否处于方向障碍物后方(
      state.中心X,
      state.中心Y,
      state.方向角,
      mushroom.X,
      mushroom.Y,
      targetX,
      targetY,
      cfg.蘑菇遮挡半径,
    )) return true;
  }
  return false;
}

function 古木悲鸣目标筛选(this: void, target: any, projectileId: number): boolean {
  const state = 古木悲鸣弹幕状态表[projectileId];
  if (state == null || !单位有效(target)) return false;
  const targetId = 取单位ID(target);
  if (targetId === 0 || state.已命中目标[targetId] === true) return false;
  if (古木悲鸣目标被蘑菇遮挡(state, target)) {
    绑定古木悲鸣安全区护盾(state.安全区状态, target);
    return false;
  }
  state.已命中目标[targetId] = true;
  return true;
}

function 古木悲鸣弹幕命中(this: void, target: any, projectileId: number): void {
  const state = 古木悲鸣弹幕状态表[projectileId];
  if (state == null || !单位有效(target)) return;
  const cfg = 莫尔特斯数值与表现配置.古木悲鸣;
  const maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE);
  if (!(maxLife > 0)) return;
  执行BossAOE技能伤害({
    技能ID: 古木悲鸣技能ID,
    来源: state.context.Boss单位,
    目标: target,
    伤害公式: { 目标最大生命比例: cfg.目标最大生命比例 },
    attack: false,
    ranged: true,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_PLANT,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: "莫尔特斯·古木悲鸣",
  });
  const after = 应用莫尔特斯腐败值(state.context, target, cfg.腐败值);
  if (after >= cfg.恐惧阈值) {
    施加恐惧(state.context.Boss单位, target, {
      持续时间: cfg.恐惧秒,
      模式: "随机乱跑",
      随机半径: 450,
      移动速度: 50,
    });
  }
}

function 古木悲鸣弹幕结束(this: void, _reason: any, projectileId: number): void {
  delete 古木悲鸣弹幕状态表[projectileId];
}

function 清理古木悲鸣弹幕(this: void, projectileId?: any): void {
  if (typeof projectileId !== "number") return;
  delete 古木悲鸣弹幕状态表[projectileId];
  销毁原生弹幕(projectileId, "手动销毁");
}

function 发射古木悲鸣弹幕(this: void, context: 莫尔特斯运行时上下文, centerX: number, centerY: number, direction: number, mushrooms: Array<{ X: number; Y: number }>, hitRecord: Record<number, boolean>, 安全区状态: 古木悲鸣安全区状态): void {
  const cfg = 莫尔特斯数值与表现配置.古木悲鸣;
  const projectile = 创建原生弹幕({
    所有者: context.Boss单位,
    载体模式: "单位",
    模型: cfg.悲鸣特效路径,
    缩放: cfg.悲鸣特效缩放,
    X: centerX,
    Y: centerY,
    方向角: direction,
    速度: cfg.弹幕速度,
    生命周期: cfg.弹幕生命周期秒,
    最大距离: cfg.弹幕最大距离,
    命中半径: cfg.弹幕命中半径,
    影响目标: "敌方",
    每单位最大命中次数: 1,
    碰撞消失: false,
    禁用碰撞: true,
    不可阻挡: true,
    目标筛选: 古木悲鸣目标筛选,
    on命中: 古木悲鸣弹幕命中,
    on结束: 古木悲鸣弹幕结束,
  });
  const projectileId = projectile.弹幕ID;
  古木悲鸣弹幕状态表[projectileId] = {
    context,
    中心X: centerX,
    中心Y: centerY,
    方向角: direction,
    蘑菇坐标列表: mushrooms,
    已命中目标: hitRecord,
    安全区状态,
  };
  context.清理.登记清理("莫尔特斯-古木悲鸣弹幕", 清理古木悲鸣弹幕, projectileId);
}

function 结算莫尔特斯古木悲鸣(this: void, variable?: any): void {
  const context = variable as 莫尔特斯运行时上下文 | undefined;
  if (context == null) return;
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const center = 读取古木悲鸣中心(context);
  const mushrooms = 获取悲鸣蘑菇坐标(context);
  const hitRecord: Record<number, boolean> = {};
  const 安全区状态: 古木悲鸣安全区状态 = {
    context,
    安全护盾目标: {},
    安全护盾记录列表: [],
    已登记清理: false,
  };
  const directions = [0, 90, 180, 270];
  for (let i = 0; i < directions.length; i++) {
    发射古木悲鸣弹幕(context, center.X, center.Y, directions[i], mushrooms, hitRecord, 安全区状态);
  }
  const mushroomState = (context as any).__moltesAncientMushroomState as 古木悲鸣蘑菇表现状态 | undefined;
  if (mushroomState != null && !mushroomState.已清理) {
    const mushroomCleanupId = addDelayedCallback(
      莫尔特斯数值与表现配置.古木悲鸣.技能结束后蘑菇延迟删除秒 * 1000,
      延迟清理古木悲鸣蘑菇表现,
      mushroomState,
    );
    context.清理.登记延迟回调("莫尔特斯-古木悲鸣蘑菇延迟删除", mushroomCleanupId);
  }
  播放Boss坐标音效(莫尔特斯音效配置.古木悲鸣.悲鸣波, center.X, center.Y, 莫尔特斯音效配置.默认裁断距离);
  尝试播放Boss拟声池({
    标识: 莫尔特斯音效配置.怪物拟声.标识,
    音效路径列表: 莫尔特斯音效配置.怪物拟声.音效路径列表,
    X: center.X,
    Y: center.Y,
    裁断距离: 莫尔特斯音效配置.默认裁断距离,
    冷却Ms: 莫尔特斯音效配置.怪物拟声.冷却Ms,
    触发概率百分比: 莫尔特斯音效配置.怪物拟声.关键机制触发概率百分比,
  });
}

function 确保悲鸣蘑菇表现(this: void, context: 莫尔特斯运行时上下文): void {
  const grid = context.根须宫格;
  if (grid == null) return;
  const cfg = 莫尔特斯数值与表现配置.古木悲鸣;
  const center = 读取古木悲鸣中心(context);
  const state = context as any;
  const previous = state.__moltesAncientMushroomState as 古木悲鸣蘑菇表现状态 | undefined;
  if (previous != null) 清理古木悲鸣蘑菇表现(previous);
  const selectedCells = 选择悲鸣蘑菇格子(grid);
  const mushroomState: 古木悲鸣蘑菇表现状态 = { 特效列表: [], 格子列表: selectedCells, 已清理: false };
  state.__moltesAncientMushroomState = mushroomState;
  context.清理.登记清理("莫尔特斯-古木悲鸣蘑菇", 清理古木悲鸣蘑菇表现, mushroomState);
  for (let i = 0; i < selectedCells.length; i++) {
    const cell = selectedCells[i];
    const effect = AddSpecialEffect(cfg.巨型蘑菇模型列表[i], cell.X, cell.Y);
    设置特效缩放(effect, cfg.巨型蘑菇缩放);
    mushroomState.特效列表.push(effect);
    创建技能提示圈({
      类型: "白色安全圆",
      X: cell.X,
      Y: cell.Y,
      半径: cfg.蘑菇遮挡半径,
      持续时间: cfg.动作播放秒,
    });
    创建技能提示圈({
      类型: "白色扇形",
      X: cell.X,
      Y: cell.Y,
      半径: cfg.蘑菇安全扇形半径,
      扇形角度: cfg.蘑菇遮挡角度 * 2,
      朝向: 取坐标角度(center.X, center.Y, cell.X, cell.Y),
      持续时间: cfg.动作播放秒,
    });
  }
}

export function 释放莫尔特斯古木悲鸣(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 莫尔特斯数值与表现配置.古木悲鸣;
  确保莫尔特斯根须宫格(context);
  确保悲鸣蘑菇表现(context);
  启动基础施法时间线({
    名称: "莫尔特斯-古木悲鸣",
    施法者: boss,
    硬直秒: cfg.动作播放秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    吟唱条: {
      通道: "大招",
      总时长: cfg.动作播放秒,
      颜色ID: 3,
      标题文本: "古木悲鸣",
      提示文本: "站到巨型蘑菇背向莫尔特斯的一侧，让蘑菇挡在你与Boss之间",
    },
    清理: context.清理,
    播放台词: function 莫尔特斯古木悲鸣台词(this: void): void {
      播放莫尔特斯台词(boss, "古木悲鸣");
    },
    on生效: function 莫尔特斯古木悲鸣时间线生效(this: void): void {
      结算莫尔特斯古木悲鸣(context);
    },
  });
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
