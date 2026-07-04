/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 是技能伤害, 是元素伤害, 取单位ID, 造成装备伤害, 播放单位特效, 第二章后段Boss战利品装备名, 装备伤害类型, 装备小特效 } from "./154．第二章后段Boss战利品公共";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const 湿痕到期表: Record<number, number | undefined> = {};

function on卡瑟拉深渊法典伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !是技能伤害(snapshot)) return;
  if (!单位持有第二章后段Boss战利品(attacker, 第二章后段Boss战利品装备名.卡瑟拉深渊法典)) return;
  const targetId = 取单位ID(target);
  if (targetId === 0) return;
  if (是元素伤害(snapshot, 装备伤害类型.水)) {
    湿痕到期表[targetId] = getServerTime() + 6000;
    播放单位特效(装备小特效.湿痕, target, "origin", 1.2);
    return;
  }
  if (!是元素伤害(snapshot, 装备伤害类型.闪电)) return;
  if ((湿痕到期表[targetId] ?? 0) < getServerTime()) return;
  delete 湿痕到期表[targetId];
  造成装备伤害(attacker, target, applied * 0.22, 装备伤害类型.闪电);
}

registerAppliedFinalDamageListener(on卡瑟拉深渊法典伤害);

export {};
