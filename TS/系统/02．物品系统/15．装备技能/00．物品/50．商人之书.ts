/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 英雄主属性是智力, 增加英雄经验与智力 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 创建单位永久标记 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/22．单位永久标记";

const 商人之书已参悟 = 创建单位永久标记("商人之书已参悟");

export function 处理商人之书使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.商人之书)) return;
  const unit = ctx.施法单位;
  if (!英雄主属性是智力(unit)) return;
  if (!商人之书已参悟.标记若不存在(unit)) return;
  const cfg = 物品使用数值配置.商人之书;
  增加英雄经验与智力(unit, cfg.经验次数, cfg.每次经验, cfg.智力增加);
}

export {};
