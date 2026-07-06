/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 播放点特效, 取单位X, 取单位Y, 造成强化伤害 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 启动计数周期执行 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/10．周期执行模板/00．计数周期执行";
import { 施加临时属性效果 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/19．临时属性效果";
import { registerManualBuff } from "../../../05．Buff系统/00．Buff系统";
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";

function 执行狂暴树枝自伤Tick(this: void, unit: any): void {
  造成强化伤害(unit, unit, 物品使用数值配置.狂暴树枝.自伤);
}

export function 处理狂暴树枝使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.狂暴树枝)) return;
  const cfg = 物品使用数值配置.狂暴树枝;
  const unit = ctx.施法单位;
  播放点特效("Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl", 取单位X(unit), 取单位Y(unit));
  施加临时属性效果(unit, cfg.持续毫秒, [{ 类型: "攻速", 数值: cfg.攻速 }]);
  registerManualBuff(unit, 常规BuffID.狂暴树枝_狂暴, cfg.持续毫秒 / 1000, cfg.攻速显示, {
    sourceName: "狂暴树枝",
    effectValue2: cfg.自伤,
  });
  启动计数周期执行({
    间隔毫秒: cfg.自伤间隔毫秒,
    最大次数: cfg.持续毫秒 / cfg.自伤间隔毫秒,
    on周期: function on狂暴树枝自伤周期(this: void): void {
      执行狂暴树枝自伤Tick(unit);
    },
  });
}

export {};
