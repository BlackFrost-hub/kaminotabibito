/** @noSelfInFile */

import { 单位持有第三章主线Boss战利品, 是技能伤害快照, 第三章主线Boss战利品冷却中, 第三章主线Boss战利品装备名, 取第三章主线Boss战利品冷却键, 设置第三章主线Boss战利品冷却 } from "./143．第三章主线Boss战利品公共";
import { 单位有效存活, 造成伤害事件伤害, 伤害事件伤害类型 } from "../04．伤害事件/00．公共/01．伤害事件工具";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

const 永恒轮回法典冷却秒数 = 2;
const 永恒轮回法典附加伤害 = 320;

function on永恒轮回法典最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0)) return;
  if (!是技能伤害快照(snapshot)) return;
  if (!单位有效存活(attacker) || !单位有效存活(target)) return;
  if (!单位持有第三章主线Boss战利品(attacker, 第三章主线Boss战利品装备名.永恒轮回法典)) return;
  const key = 取第三章主线Boss战利品冷却键(attacker, "永恒轮回法典:轮回火印");
  if (第三章主线Boss战利品冷却中(key)) return;
  设置第三章主线Boss战利品冷却(key, 永恒轮回法典冷却秒数);
  造成伤害事件伤害(attacker, target, 永恒轮回法典附加伤害, 伤害事件伤害类型.火焰);
}

registerAppliedFinalDamageListener(on永恒轮回法典最终伤害);

export {};
