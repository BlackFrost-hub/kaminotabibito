/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 取单位ID, 净化负面, 恢复生命魔法, 取最大生命, 播放单位特效, 第二章后段Boss战利品装备名, 装备小特效 } from "./154．第二章后段Boss战利品公共";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

const 古树之心层数表: Record<number, number | undefined> = {};

function on古树之心护符受伤(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0)) return;
  if (!单位持有第二章后段Boss战利品(target, 第二章后段Boss战利品装备名.古树之心护符)) return;
  const id = 取单位ID(target);
  if (id === 0) return;
  const next = (古树之心层数表[id] ?? 0) + 1;
  if (next < 4) {
    古树之心层数表[id] = next;
    return;
  }
  古树之心层数表[id] = 0;
  净化负面(target);
  恢复生命魔法(target, target, 取最大生命(target) * 0.08);
  播放单位特效(装备小特效.护盾闪光, target, "origin", 0.8);
}

registerAppliedFinalDamageListener(on古树之心护符受伤);

export {};
