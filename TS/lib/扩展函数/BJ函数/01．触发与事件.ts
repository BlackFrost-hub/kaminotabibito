const jass = require("jass.common") as any;

const MAX_PLAYER_SLOTS = 16;

/**
 * 为指定玩家注册单位事件
 * 对应JASS: TriggerRegisterPlayerUnitEventSimple
 */
export function TriggerRegisterPlayerUnitEventSimple(
  trig: any,
  whichPlayer: any,
  whichEvent: number
): any {
  if (typeof jass.TriggerRegisterPlayerUnitEvent === "function") {
    return jass.TriggerRegisterPlayerUnitEvent(trig, whichPlayer, whichEvent, null);
  }
  return null;
}

/**
 * 为所有玩家注册单位事件
 * 对应JASS: TriggerRegisterAnyUnitEventBJ
 */
export function TriggerRegisterAnyUnitEventBJ(trig: any, whichEvent: number): void {
    for (let index = 0; index < MAX_PLAYER_SLOTS; index++) {
        if (typeof jass.TriggerRegisterPlayerUnitEvent === "function") {
            jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(index), whichEvent, undefined!);
        }
    }
}

/**
 * 为玩家0-7注册单位事件（人类玩家）
 */
export function TriggerRegisterPlayerUnitEventForPlayers(
  trig: any,
  whichEvent: number
): void {
  for (let i = 0; i <= 7; i++) {
    TriggerRegisterPlayerUnitEventSimple(trig, jass.Player(i), whichEvent);
  }
}

export function ConditionalTriggerExecute(trig: any): void {
    if (!trig) return;
    if (typeof jass.TriggerEvaluate !== "function" || typeof jass.TriggerExecute !== "function") return;
    if (jass.TriggerEvaluate(trig)) {
        jass.TriggerExecute(trig);
    }
}

export function TriggerRegisterUnitInRangeSimple(trig: any, range: number, whichUnit: any): any {
    if (typeof jass.TriggerRegisterUnitInRange === "function") {
        return jass.TriggerRegisterUnitInRange(trig, whichUnit, range, null);
    }
    return null;
}

/** 对齐 Blizzard.j：`GetAttackedUnitBJ` → `GetTriggerUnit()` */
export function GetAttackedUnitBJ(): any {
    return jass.GetTriggerUnit();
}

export {};
