const jass = require("jass.common") as any;

// ========== 虚拟分区：物品判断 ==========
// 判断单位背包中是否存在指定类型物品。
export function UnitHasItemOfTypeBJ(whichUnit: any, itemTypeId: number): boolean {
  if (!whichUnit || typeof jass.UnitItemInSlot !== "function" || typeof jass.GetItemTypeId !== "function") return false;
  for (let slot = 0; slot < 6; slot++) {
    const item = jass.UnitItemInSlot(whichUnit, slot);
    if (item && jass.GetItemTypeId(item) === itemTypeId) return true;
  }
  return false;
}

// 获取单位背包中的第一个指定类型物品句柄。
export function UnitGetItemByTypeId(whichUnit: any, itemTypeId: number): any | null {
  if (!whichUnit || typeof jass.UnitItemInSlot !== "function" || typeof jass.GetItemTypeId !== "function") return null;
  for (let slot = 0; slot < 6; slot++) {
    const item = jass.UnitItemInSlot(whichUnit, slot);
    if (item && jass.GetItemTypeId(item) === itemTypeId) return item;
  }
  return null;
}

// 返回指定类型物品在背包中的 1-based 槽位索引（找不到返回 0）。
export function GetInventoryIndexOfItemTypeBJ(whichUnit: any, itemId: number): number {
  if (!whichUnit || typeof jass.UnitItemInSlot !== "function" || typeof jass.GetItemTypeId !== "function") return 0;
  for (let i = 0; i < 6; i++) {
    const item = jass.UnitItemInSlot(whichUnit, i);
    if (item && jass.GetItemTypeId(item) === itemId) return i + 1; // BJ: 1-based
  }
  return 0;
}

// 按 BJ 语义获取单位背包中的指定类型物品。
export function GetItemOfTypeFromUnitBJ(whichUnit: any, itemId: number): any | null {
  const index = GetInventoryIndexOfItemTypeBJ(whichUnit, itemId);
  if (index === 0) return null;
  return jass.UnitItemInSlot(whichUnit, index - 1);
}

// 统计单位背包中指定类型物品的总“可提交数量”（优先使用 charges）。
export function GetItemTypeTotalCountByChargesBJ(whichUnit: any, itemId: number): number {
  if (!whichUnit || typeof jass.UnitItemInSlot !== "function" || typeof jass.GetItemTypeId !== "function") return 0;
  let total = 0;
  for (let i = 0; i < 6; i++) {
    const item = jass.UnitItemInSlot(whichUnit, i);
    if (!item) continue;
    if (jass.GetItemTypeId(item) !== itemId) continue;
    const ch = typeof jass.GetItemCharges === "function" ? (jass.GetItemCharges(item) as number) : 0;
    total += ch > 0 ? ch : 1;
  }
  return total;
}

// 按次数消耗指定类型物品（充足才扣除，不足直接失败）。
export function ConsumeItemTypeCountByChargesBJ(whichUnit: any, itemId: number, needCount: number): boolean {
  if (!whichUnit || itemId === 0 || needCount <= 0) return false;
  const total = GetItemTypeTotalCountByChargesBJ(whichUnit, itemId);
  if (total < needCount) return false;
  let remain = needCount;
  for (let i = 0; i < 6; i++) {
    if (remain <= 0) break;
    const item = jass.UnitItemInSlot(whichUnit, i);
    if (!item) continue;
    if (jass.GetItemTypeId(item) !== itemId) continue;
    const ch = typeof jass.GetItemCharges === "function" ? (jass.GetItemCharges(item) as number) : 0;
    if (ch > 0) {
      if (ch > remain) {
        if (typeof jass.SetItemCharges === "function") jass.SetItemCharges(item, ch - remain);
        remain = 0;
      } else {
        remain -= ch;
        // 任务提交成功时应消耗物品：直接销毁，不是丢到地上
        if (typeof jass.RemoveItem === "function") jass.RemoveItem(item);
      }
    } else {
      remain -= 1;
      // 无次数物品按 1 个消耗，直接销毁
      if (typeof jass.RemoveItem === "function") jass.RemoveItem(item);
    }
  }
  return remain <= 0;
}

// ========== 虚拟分区：物品回退 ==========
// 尝试把现有物品句柄加入目标单位背包（兼容 true/1 返回值）。
export function TryGiveItemToUnitBJ(targetUnit: any, item: any): boolean {
  if (!targetUnit || !item || typeof jass.UnitAddItem !== "function") return false;
  const ok = jass.UnitAddItem(targetUnit, item);
  return ok === true || ok === 1;
}

// 将物品从来源单位返还给目标单位，目标背包满则掉在目标脚下。
export function ReturnItemToHeroOrDropBJ(item: any, fromUnit: any, hero: any): "added" | "dropped" | "failed" {
  if (!item || !fromUnit || !hero) return "failed";
  if (TryGiveItemToUnitBJ(hero, item)) return "added";
  if (typeof jass.UnitRemoveItem !== "function" || typeof jass.SetItemPosition !== "function") return "failed";
  jass.UnitRemoveItem(fromUnit, item);
  const x = typeof jass.GetUnitX === "function" ? jass.GetUnitX(hero) : 0;
  const y = typeof jass.GetUnitY === "function" ? jass.GetUnitY(hero) : 0;
  jass.SetItemPosition(item, x, y);
  return "dropped";
}

export {};
