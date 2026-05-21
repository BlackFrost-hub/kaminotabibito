/** @noSelfInFile */

const { 是可清理吃书残留, 删除物品 } = require("./00．通用物品工具") as {
  是可清理吃书残留: (this: void, 物品: any) => boolean;
  删除物品: (this: void, 物品: any) => void;
};

export function 处理通用物品吃书清理(this: void, _单位: any, 物品: any): void {
  if (!是可清理吃书残留(物品)) return;
  删除物品(物品);
}

export {};
