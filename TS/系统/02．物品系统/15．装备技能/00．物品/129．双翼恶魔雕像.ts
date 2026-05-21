/** @noSelfInFile */

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};
const { registerDodgeAppliedFinalDamageListener } = require("系统.04．伤害系统.05．闪避系统.01．闪避核心") as {
  registerDodgeAppliedFinalDamageListener: (this: void, callback: (this: void, record: any, applied: number, snapshot: any) => void) => void;
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, u: any, id: number, v: number) => void;
};
const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};

interface 待移除敏捷记录 {
  unit: any;
  value: number;
}

const 双翼恶魔雕像物品ID = stringToFourCCSafe(resolveItemIdByName("双翼恶魔雕像"));
const 待移除敏捷列表: 待移除敏捷记录[] = [];

function 移除一条闪避之福敏捷(this: void): void {
  const record = 待移除敏捷列表.shift();
  if (record == null) return;
  SGSS_SetState(record.unit, 4, -record.value);
}

function 添加闪避之福敏捷(this: void, unit: any, value: number, durationMs: number): void {
  SGSS_SetState(unit, 4, value);
  待移除敏捷列表.push({ unit, value });
  addDelayedCallback(durationMs, 移除一条闪避之福敏捷);
}

function 双翼恶魔雕像闪避监听(this: void, record: any, _applied: number, _snapshot: any): void {
  if (双翼恶魔雕像物品ID === 0) return;
  if (record.isNormalAttack === true) return;
  if (!UnitHasItemOfTypeBJ(record.target, 双翼恶魔雕像物品ID)) return;
  添加闪避之福敏捷(record.target, 3, 20000);
}

export function init双翼恶魔雕像闪避之福(this: void): void {
  registerDodgeAppliedFinalDamageListener(双翼恶魔雕像闪避监听);
}

init双翼恶魔雕像闪避之福();

export {};
