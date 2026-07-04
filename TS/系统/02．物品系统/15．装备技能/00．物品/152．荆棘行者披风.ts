/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 是纯普攻, 造成装备伤害, 第二章后段Boss战利品装备名, 装备伤害类型 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

function on荆棘行者披风受击(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !是纯普攻(snapshot)) return;
  if (!单位持有第二章后段Boss战利品(target, 第二章后段Boss战利品装备名.荆棘行者披风)) return;
  造成装备伤害(target, attacker, 190, 装备伤害类型.自然);
}

registerAppliedFinalDamageListener(on荆棘行者披风受击);

export {};
