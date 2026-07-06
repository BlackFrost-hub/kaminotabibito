/** @noSelfInFile */

import { 施加临时属性效果, 单位存活, 单位是英雄, 播放单位特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};
const { onItemPickup } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetWidgetLife = jass.GetWidgetLife as (widget: any) => number;
const UnitRemoveItem = jass.UnitRemoveItem as (unit: any, item: any) => boolean;
const RemoveItem = jass.RemoveItem as (item: any) => void;

const 盗贼神符护甲ID = stringToFourCCSafe("I0FK");
const 盗贼神符魔抗ID = stringToFourCCSafe("I0FL");
const 盗贼神符持续毫秒 = 10000;
const 盗贼神符生效特效 = "Abilities\\Spells\\Items\\AItb\\AItbTarget.mdl";

function 施加盗贼神符护甲(this: void, unit: any): void {
  施加临时属性效果(unit, 盗贼神符持续毫秒, [{ 类型: "护甲", 数值: 15 }]);
}

function 施加盗贼神符魔抗(this: void, unit: any): void {
  if (单位是英雄(unit)) {
    施加临时属性效果(unit, 盗贼神符持续毫秒, [{ 类型: "玩家属性", 属性名: "魔抗", 数值: 0.2 }]);
  } else {
    施加临时属性效果(unit, 盗贼神符持续毫秒, [{ 类型: "单位属性", 属性名: "魔抗", 数值: 0.2 }]);
  }
}

function 强制生效盗贼神符(this: void, unit: any, item: any, itemTypeId: number): void {
  UnitRemoveItem(unit, item);
  RemoveItem(item);
  播放单位特效(盗贼神符生效特效, unit, "origin", 1);
  if (itemTypeId === 盗贼神符护甲ID) {
    施加盗贼神符护甲(unit);
  } else {
    施加盗贼神符魔抗(unit);
  }
}

function on盗贼神符实际拾取(this: void, unit: any, item: any): void {
  if (item == null || item === 0) return;
  const itemTypeId = GetItemTypeId(item);
  if (unit == null || unit === 0 || GetWidgetLife(unit) <= 0.405) return;
  if (itemTypeId !== 盗贼神符护甲ID && itemTypeId !== 盗贼神符魔抗ID) return;
  强制生效盗贼神符(unit, item, itemTypeId);
}

onItemPickup(on盗贼神符实际拾取);

export {};
