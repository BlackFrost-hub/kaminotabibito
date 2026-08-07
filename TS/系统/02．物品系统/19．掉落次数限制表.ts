/** @noSelfInFile */

/** 限次物品的整局掉落配置。未配置的物品不限制。 */
export const 掉落次数限制表: Readonly<Record<string, number>> = {
  afac: 1,
  I0CQ: 1,
};

const 物品已掉落次数: Record<string, number> = {};

export function 是否允许限次物品掉落(this: void, itemId: string): boolean {
  const 最大掉落次数 = 掉落次数限制表[itemId];
  if (最大掉落次数 == null) return true;
  return (物品已掉落次数[itemId] ?? 0) < 最大掉落次数;
}

export function 记录限次物品掉落(this: void, itemId: string): void {
  if (掉落次数限制表[itemId] == null) return;
  物品已掉落次数[itemId] = (物品已掉落次数[itemId] ?? 0) + 1;
}
