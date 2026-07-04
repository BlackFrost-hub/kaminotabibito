/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 取句柄ID } from "../05．物品使用/00．公共/02．物品使用工具";
import { 施加临时属性效果, type 临时属性效果实例 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const 激活表: Record<number, 临时属性效果实例 | undefined> = {};

function 清除焰混能量体(this: void, unit: any): void {
  const id = 取句柄ID(unit);
  if (id === 0) return;
  const 实例 = 激活表[id];
  if (实例 == null) return;
  delete 激活表[id];
  实例.清除();
}

export function 处理焰混能量体使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.焰混能量体)) return;
  const unit = ctx.施法单位;
  const id = 取句柄ID(unit);
  if (id === 0) return;
  清除焰混能量体(unit);
  const cfg = 物品使用数值配置.焰混能量体;
  const 实例 = 施加临时属性效果(unit, cfg.持续毫秒, [{ 类型: "攻速", 数值: cfg.攻速 }], {
    次数: cfg.普攻次数,
    on清除: function on焰混能量体清除(this: void): void {
      delete 激活表[id];
    },
  });
  if (实例.是否激活()) 激活表[id] = 实例;
}

export function 处理焰混能量体伤害(this: void, _target: any, attacker: any, _applied: number, snapshot: any): void {
  if (snapshot == null || snapshot.isNormalAttack !== true) return;
  const id = 取句柄ID(attacker);
  if (id === 0) return;
  const 实例 = 激活表[id];
  if (实例 == null || !实例.是否激活()) return;
  实例.消耗次数(1);
}

export {};
