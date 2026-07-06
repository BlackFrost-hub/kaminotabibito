/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 获取范围友军, 取单位X, 取单位Y, 取单位攻击, 取句柄ID } from "../05．物品使用/00．公共/02．物品使用工具";
import { 施加临时属性效果 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { 调整状态ID属性 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/16．属性位移与指令";
import { 创建句柄上下文托管器 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/24．句柄上下文托管";
import { registerManualBuff, 移除单位指定Buff } from "../../../05．Buff系统/00．Buff系统";
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";

const { 注册持有型范围光环 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.23．光环.01．范围光环") as {
  注册持有型范围光环: (this: void, params: {
    物品类型ID: number;
    间隔毫秒: number;
    半径: number;
    目标类型: "友军含自己" | "友军不含自己" | "敌人";
    应用目标效果: (this: void, target: any, holder: any, currentCount: number) => void;
    同步目标效果?: (this: void, target: any, holder: any, currentCount: number) => void;
    移除目标效果: (this: void, target: any, holder: any, currentCount: number) => void;
  }) => void;
};

const 攻击属性ID = 1;
const 护甲属性ID = 2;
const 精灵号角光环周期毫秒 = 500;
const 精灵号角Buff持续秒 = 1;

type 精灵号角光环上下文 = {
  层数: number;
  已加攻击: number;
  已加护甲: number;
};

const 精灵号角光环托管器 = 创建句柄上下文托管器<精灵号角光环上下文>("精灵号角光环");

let 已初始化精灵号角光环 = false;

function 计算光环攻击(this: void, target: any, 已加攻击: number, 层数: number): number {
  const baseAttack = 取单位攻击(target) - 已加攻击;
  if (!(baseAttack > 0) || 层数 <= 0) return 0;
  return baseAttack * 物品使用数值配置.号角.精灵号角光环攻击比例 * 层数;
}

function 同步精灵号角光环属性(this: void, target: any, 层数: number): void {
  const old = 精灵号角光环托管器.读取(target);
  const oldAttack = old?.已加攻击 ?? 0;
  const oldArmor = old?.已加护甲 ?? 0;
  const nextAttack = 计算光环攻击(target, oldAttack, 层数);
  const nextArmor = 物品使用数值配置.号角.精灵号角光环护甲 * 层数;
  const deltaAttack = nextAttack - oldAttack;
  const deltaArmor = nextArmor - oldArmor;
  if (deltaAttack !== 0) 调整状态ID属性(target, 攻击属性ID, deltaAttack);
  if (deltaArmor !== 0) 调整状态ID属性(target, 护甲属性ID, deltaArmor);
  精灵号角光环托管器.写入(target, { 层数, 已加攻击: nextAttack, 已加护甲: nextArmor });
}

function 刷新精灵号角光环Buff(this: void, target: any): void {
  const ctx = 精灵号角光环托管器.读取(target);
  if (ctx == null || ctx.层数 <= 0) return;
  registerManualBuff(target, 常规BuffID.精灵号角_号角光环, 精灵号角Buff持续秒, 10 * ctx.层数, {
    sourceName: "精灵号角",
    effectValue2: 物品使用数值配置.号角.精灵号角光环护甲 * ctx.层数,
  });
}

function 应用精灵号角光环(this: void, target: any, _holder: any, currentCount: number): void {
  const count = currentCount <= 0 ? 1 : currentCount;
  const old = 精灵号角光环托管器.读取(target);
  同步精灵号角光环属性(target, (old?.层数 ?? 0) + count);
  刷新精灵号角光环Buff(target);
}

function 同步精灵号角光环(this: void, target: any, _holder: any, _currentCount: number): void {
  const old = 精灵号角光环托管器.读取(target);
  if (old == null || old.层数 <= 0) return;
  同步精灵号角光环属性(target, old.层数);
  刷新精灵号角光环Buff(target);
}

function 移除精灵号角光环(this: void, target: any, _holder: any, currentCount: number): void {
  const count = currentCount <= 0 ? 1 : currentCount;
  const old = 精灵号角光环托管器.读取(target);
  const next = (old?.层数 ?? 0) - count;
  if (next > 0) {
    同步精灵号角光环属性(target, next);
    刷新精灵号角光环Buff(target);
    return;
  }
  if (old != null) {
    if (old.已加攻击 !== 0) 调整状态ID属性(target, 攻击属性ID, -old.已加攻击);
    if (old.已加护甲 !== 0) 调整状态ID属性(target, 护甲属性ID, -old.已加护甲);
  }
  移除单位指定Buff(target, 常规BuffID.精灵号角_号角光环);
  精灵号角光环托管器.清空(target);
}

export function 初始化精灵号角光环(this: void): void {
  if (已初始化精灵号角光环) return;
  已初始化精灵号角光环 = true;
  if (物品使用装备ID.精灵号角 === 0) return;
  注册持有型范围光环({
    物品类型ID: 物品使用装备ID.精灵号角,
    间隔毫秒: 精灵号角光环周期毫秒,
    半径: 物品使用数值配置.号角.半径,
    目标类型: "友军含自己",
    应用目标效果: 应用精灵号角光环,
    同步目标效果: 同步精灵号角光环,
    移除目标效果: 移除精灵号角光环,
  });
}

export function 处理精灵号角使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.精灵号角)) return;
  const cfg = 物品使用数值配置.号角;
  const unit = ctx.施法单位;
  const allies = 获取范围友军(unit, 取单位X(unit), 取单位Y(unit), cfg.半径);
  const count = allies.length;
  if (count <= 0) return;
  const selfExtraAttack = cfg.精灵号角每单位攻击 * count;
  for (let i = 0; i < allies.length; i++) {
    const target = allies[i];
    const activeAttack = 取单位攻击(target) * cfg.精灵号角主动攻击比例;
    const extraAttack = 取句柄ID(target) === 取句柄ID(unit) ? selfExtraAttack : 0;
    施加临时属性效果(target, cfg.持续毫秒, [{ 类型: "攻击", 数值: activeAttack + extraAttack }]);
    registerManualBuff(target, 常规BuffID.精灵号角_王之号角, cfg.持续毫秒 / 1000, 15, {
      sourceName: "精灵号角",
      effectValue2: extraAttack,
    });
  }
}

初始化精灵号角光环();

export {};
