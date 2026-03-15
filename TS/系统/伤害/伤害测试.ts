/**
 * 伤害事件测试：任意单位受到伤害时发送「XX单位受到了XX伤害」
 * 若 JASS 里 YDWEIsEventDamageType(COLD) 将 udg_TempInteger[1] 置为 1，伤害事件在 JASS 后立即读出并传入 tempInteger，此处置 0 并发送 111。
 */
const jass = require("jass.common") as Record<string, unknown>;
const g = require("jass.globals") as Record<string, unknown>;
const damageEvent = require("系统.伤害.伤害事件") as {
  registerDamageCallback: (cb: (unit: any, damage: number, damageType: number, isFirstInBatch: boolean, isLastInBatch: boolean) => void, interval?: number) => void;
  hasBit: (v: number, bit: number) => boolean;
};

function sendMsg(msg: string): void {
  if (typeof (jass as any).DisplayTextToPlayer !== "function") return;
  for (let i = 0; i <= 15; i++) {
    const p = (jass as any).Player(i);
    if (p != null) (jass as any).DisplayTextToPlayer(p, 0, 0, msg);
  }
}

function onDamage(unit: any, damage: number, damageType: number, isFirstInBatch: boolean, isLastInBatch: boolean): void {
  if (!unit) return;
  const hb = damageEvent.hasBit;
  const name = typeof (jass as any).GetUnitName === "function" ? (jass as any).GetUnitName(unit) : "单位";
  const damageStr = typeof (jass as any).R2S === "function" ? (jass as any).R2S(damage) : tostring(damage);

  const isSkill   = hb(damageType, 2048);
  const isPhysical = hb(damageType, 4096);
  const isAttack  = hb(damageType, 8192);
  const isRanged  = hb(damageType, 16384);

  let msg: string;
  if (isSkill) {
    const attrNames: [number, string][] = [[1, "普通"], [2, "强化"], [4, "火属性"], [8, "冰属性"], [16, "雷属性"], [32, "金属性"], [64, "光属性"], [128, "魔法"], [256, "精神"], [512, "风属性"], [1024, "暗属性"]];
    let detail = "";
    for (let a = 0; a < attrNames.length; a++) {
      if (hb(damageType, attrNames[a][0])) { detail = "（" + attrNames[a][1] + "）"; break; }
    }
    if ((isAttack || isRanged) && (isFirstInBatch || isLastInBatch)) {
      msg = name + "受到了" + damageStr + "点技能攻击伤害" + detail;
    } else {
      msg = name + "受到了" + damageStr + "点技能伤害" + detail;
    }
  } else if (isRanged) {
    msg = name + "受到了" + damageStr + "点远程普攻" + (isPhysical ? "（物理）" : "");
  } else if (isAttack) {
    msg = name + "受到了" + damageStr + "点普攻伤害" + (isPhysical ? "（物理）" : "");
  } else {
    msg = name + "受到了" + damageStr + "点伤害";
  }
  const j = jass as any;
  const source = j.udg_TempUnit != null && j.udg_TempUnit[6] != null ? j.udg_TempUnit[6] : null;
  if (source != null && typeof (jass as any).GetUnitName === "function") {
    const sourceName = (jass as any).GetUnitName(source);
    if (sourceName != null && sourceName !== "") msg = msg + " 伤害来源：" + sourceName;
  }
  sendMsg(msg + " [类型:" + damageType + "]");
}

damageEvent.registerDamageCallback(onDamage, 60);
export {};
