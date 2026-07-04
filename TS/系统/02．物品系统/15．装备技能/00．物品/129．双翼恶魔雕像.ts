/** @noSelfInFile */

const { registerDodgeAppliedFinalDamageListener } = require("系统.04．伤害系统.05．闪避系统.01．闪避核心") as {
  registerDodgeAppliedFinalDamageListener: (this: void, callback: (this: void, record: any, applied: number, snapshot: any) => void) => void;
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
import { 施加临时属性效果 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const 双翼恶魔雕像物品ID = stringToFourCCSafe(resolveItemIdByName("双翼恶魔雕像"));

function 添加闪避之福敏捷(this: void, unit: any, value: number, durationMs: number): void {
  施加临时属性效果(unit, durationMs, [{ 类型: "状态ID", 属性ID: 4, 数值: value }]);
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
