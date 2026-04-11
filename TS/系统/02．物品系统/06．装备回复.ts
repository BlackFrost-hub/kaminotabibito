/**
 * 装备回复：使用物品时解析 hot/abilList，按段通过 **STES「物品治疗事件」** 分发（与 JASS `Trig_HealItemEffectActions` 同语义）。
 *
 * **父（本文件 `fireItemHealEvent`）** 每轮子触发：
 * `YDLocalExecuteTrigger` → `saveParentIndex` →
 * `YDLocal5Set(unit,"ItemHealUnit")` / `real,"ItemHealHP"|"ItemHealMP"` / `item,"Item"` / `string,"物品技能标识"` → `YDTriggerExecuteTrigger(false)`。
 *
 * **子（本文件注册的 Lua Action）** 内：`YDLocalExecuteTrigger(GetTriggeringTrigger())` 后 `YDLocal5Get`，
 * 对治疗单位加减生命/魔法，再 **`YDLocal7Set` 写回父可读**（与 JASS `YDLocal1Get` 同名）：
 * - `real` **ItemHealHP** / **ItemHealMP**
 * - `item` **物品**（供父 `GetItemName(YDLocal1Get(item,"物品"))`）
 * - `unit` **ItemHealUnit**
 *
 * 不再使用 `udg_TempReal` / `gg_trg_物品治疗触发` 等旧全局。
 *
 * 规则：equip-heal-hot-format.md / equip-heal-use-item.md
 */

const jass = require("jass.common") as any;

const { STES_Register, STES_GetTable } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_Register: (t: any, name: string) => void;
  STES_GetTable: () => any;
};

const {
  YDLocal5Get,
  YDLocal5Set,
  YDLocal7Set,
  getG_SIndex,
  setG_SIndex,
  setG_LIndex,
  _indexStack,
} = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
  YDLocal5Get: (ty: string, name: string) => any;
  YDLocal5Set: (ty: string, name: string, value: any) => void;
  YDLocal7Set: (ty: string, name: string, value: any) => void;
  getG_SIndex: () => number;
  setG_SIndex: (v: number) => void;
  setG_LIndex: (v: number) => void;
  _indexStack: number[];
};

const {
  ydlStes_syncTriggerStep,
  ydlStes_finishChildCleanup,
  ydlStes_readString5,
  ydlStes_readReal5,
  ydlStes_skeyIndex,
  ydlStes_registerAfterGetTable,
} = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具") as {
  ydlStes_syncTriggerStep: (self: any) => void;
  ydlStes_finishChildCleanup: (self: any) => void;
  ydlStes_readString5: (self: any, name: string) => string;
  ydlStes_readReal5: (self: any, name: string) => number;
  ydlStes_skeyIndex: (self: any) => number;
  ydlStes_registerAfterGetTable: (self: any, trig: any, eventName: string) => void;
};

const { YDLocalExecuteTrigger, YDTriggerExecuteTrigger, saveParentIndex } = require("lib.扩展函数.YDWE函数.04．YDWE_trigger") as {
  YDLocalExecuteTrigger: (trg: any) => void;
  YDTriggerExecuteTrigger: (trg: any, flag: boolean) => void;
  saveParentIndex: (trg: any) => void;
};

const itemsData = (require("系统.02．物品系统.01．装备数据") as { default: Record<string, { hot?: string; abilList?: string }> }).default;
const { fourCCToString, isSpecialUnit, withTimer } = require("系统.00．核心系统.01．封装函数") as {
  fourCCToString: (four: number) => string;
  isSpecialUnit: (unit: any) => boolean;
  withTimer: (delaySec: number, callback: () => void) => void;
};

/** 与地图 STES / JASS `StringHash` 一致 */
export const ITEM_HEAL_STES_EVENT = "物品治疗事件";

/** YDLocal5 入参名（与 JASS `YDLocal5Set` 一致） */
const YL5_UNIT = "ItemHealUnit";
const YL5_HP = "ItemHealHP";
const YL5_MP = "ItemHealMP";
const YL5_ITEM = "Item";
const YL5_ABIL = "物品技能标识";

/** YDLocal7 写回父侧 `YDLocal1Get` 的键 */
const YL7_HP = "ItemHealHP";
const YL7_MP = "ItemHealMP";
const YL7_ITEM = "物品";
const YL7_UNIT = "ItemHealUnit";

/** 对生命/魔法做加法并封顶（不写技能表现，技能可由地图另挂 STES 或 GUI） */
function applyHpMpToUnit(this: void, unit: any, hp: number, mp: number): void {
  if (unit == null || unit === 0) return;
  if (typeof jass.GetUnitState !== "function" || typeof jass.SetUnitState !== "function") return;

  if (hp > 0 && jass.UNIT_STATE_LIFE != null && jass.UNIT_STATE_MAX_LIFE != null) {
    const cur = jass.GetUnitState(unit, jass.UNIT_STATE_LIFE) as number;
    const maxL = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE) as number;
    jass.SetUnitState(unit, jass.UNIT_STATE_LIFE, Math.min(maxL, cur + hp));
  }
  if (mp > 0 && jass.UNIT_STATE_MANA != null && jass.UNIT_STATE_MAX_MANA != null) {
    const curM = jass.GetUnitState(unit, jass.UNIT_STATE_MANA) as number;
    const maxM = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA) as number;
    jass.SetUnitState(unit, jass.UNIT_STATE_MANA, Math.min(maxM, curM + mp));
  }
}

/**
 * 与 JASS 遍历 `物品治疗事件` 等价：对每张注册的子触发器写入 YDLocal5 后 Execute。
 */
function fireItemHealEvent(this: void, unit: any, item: any, hp: number, mp: number, abilId: string): void {
  const stesHT = STES_GetTable();
  if (stesHT == null || stesHT === 0) return;
  if (typeof jass.StringHash !== "function" || typeof jass.LoadInteger !== "function") return;
  if (typeof jass.LoadTriggerHandle !== "function") return;

  const hash = jass.StringHash(ITEM_HEAL_STES_EVENT);
  const loopIndex = jass.LoadInteger(stesHT, hash, ydlStes_skeyIndex(undefined));

  _indexStack.push(getG_SIndex());

  for (let i = 0; i < loopIndex; i++) {
    const trg = jass.LoadTriggerHandle(stesHT, hash, i);
    if (trg == null || trg === 0) continue;
    YDLocalExecuteTrigger(trg);
    saveParentIndex(trg);
    YDLocal5Set("unit", YL5_UNIT, unit);
    YDLocal5Set("real", YL5_HP, hp);
    YDLocal5Set("real", YL5_MP, mp);
    YDLocal5Set("item", YL5_ITEM, item);
    YDLocal5Set("string", YL5_ABIL, abilId);
    YDTriggerExecuteTrigger(trg, false);
  }

  const prev = _indexStack.length > 0 ? _indexStack.pop()! : 0;
  setG_SIndex(prev);
  setG_LIndex(prev);
}

/** STES 子触发：读参 → 治疗 → 四路 YDLocal7 写回父 */
function onItemHealStesChild(this: void): void {
  try {
    ydlStes_syncTriggerStep(undefined);

    const unit = YDLocal5Get("unit", YL5_UNIT);
    const hp = ydlStes_readReal5(undefined, YL5_HP);
    const mp = ydlStes_readReal5(undefined, YL5_MP);
    const item = YDLocal5Get("item", YL5_ITEM);
    void ydlStes_readString5(undefined, YL5_ABIL);

    applyHpMpToUnit(unit, hp, mp);

    YDLocal7Set("real", YL7_HP, hp);
    YDLocal7Set("real", YL7_MP, mp);
    YDLocal7Set("item", YL7_ITEM, item);
    YDLocal7Set("unit", YL7_UNIT, unit);
  } finally {
    ydlStes_finishChildCleanup(undefined);
  }
}

interface SegmentInfo {
  tokens: string[];
  abilId: string;
  waitSec: number;
}

function parseSegments(hotStr: string, abilList: string): SegmentInfo[] {
  const segments = hotStr.split("+");
  const abilIds = abilList.split(",").map((x) => x.trim());
  const result: SegmentInfo[] = [];
  for (let i = 0; i < segments.length; i++) {
    const seg = segments[i].trim();
    if (seg === "") continue;
    const tokens = seg.split(";").map((x) => x.trim()).filter((x) => x !== "");
    let waitSec = 0;
    for (const t of tokens) {
      const waitIdx = t.indexOf(":wait");
      if (waitIdx >= 0) {
        const w = parseFloat(t.substring(waitIdx + 5)) || 0;
        if (w > waitSec) waitSec = w;
      }
    }
    result.push({ tokens, abilId: abilIds[i] ?? "", waitSec });
  }
  return result;
}

function calcHpMp(tokens: string[], unit: any): { hp: number; mp: number } {
  let hp = 0;
  let mp = 0;
  const maxHp: number =
    typeof jass.GetUnitState === "function" ? (jass.GetUnitState(unit, jass.ConvertUnitState(1)) as number) : 0;
  const curHp: number = typeof jass.GetWidgetLife === "function" ? (jass.GetWidgetLife(unit) as number) : 0;
  const maxMp: number =
    typeof jass.GetUnitState === "function" ? (jass.GetUnitState(unit, jass.ConvertUnitState(3)) as number) : 0;
  const lostHp = maxHp - curHp;

  for (const rawToken of tokens) {
    const waitIdx = rawToken.indexOf(":wait");
    const t = (waitIdx >= 0 ? rawToken.substring(0, waitIdx) : rawToken).trim();
    const tl = t.toLowerCase();
    if (tl.endsWith("hplost")) {
      const prefix = t.substring(0, t.length - 6);
      if (prefix.endsWith("%")) {
        const pct = parseFloat(prefix.substring(0, prefix.length - 1)) / 100;
        hp += lostHp * pct;
      } else {
        hp += parseFloat(prefix) || 0;
      }
    } else if (tl.endsWith("hp")) {
      const prefix = t.substring(0, t.length - 2);
      if (prefix.endsWith("%")) {
        const pct = parseFloat(prefix.substring(0, prefix.length - 1)) / 100;
        hp += maxHp * pct;
      } else {
        hp += parseFloat(prefix) || 0;
      }
    } else if (tl.endsWith("mp")) {
      const prefix = t.substring(0, t.length - 2);
      if (prefix.endsWith("%")) {
        const pct = parseFloat(prefix.substring(0, prefix.length - 1)) / 100;
        mp += maxMp * pct;
      } else {
        mp += parseFloat(prefix) || 0;
      }
    }
  }
  return { hp, mp };
}

function executeSegment(unit: any, item: any, seg: SegmentInfo): void {
  const { hp, mp } = calcHpMp(seg.tokens, unit);
  fireItemHealEvent(unit, item, hp, mp, seg.abilId);
}

function onUseItem(this: void): void {
  let unit: any = undefined;
  if (typeof jass.GetManipulatingUnit === "function") unit = jass.GetManipulatingUnit();
  if (unit == null && typeof jass.GetTriggerUnit === "function") unit = jass.GetTriggerUnit();
  let item: any = undefined;
  if (typeof jass.GetManipulatedItem === "function") item = jass.GetManipulatedItem();
  if (!unit || !item) return;
  if (isSpecialUnit(unit)) return;
  const itemId = typeof jass.GetItemTypeId === "function" ? jass.GetItemTypeId(item) : 0;
  const idStr = fourCCToString(itemId);
  const entry = (itemsData as Record<string, { hot?: string; abilList?: string }>)[idStr];
  if (!entry || !entry.hot || !entry.abilList) return;

  const glob = globalThis as any;
  const key = tostring(unit) + "_" + idStr;
  if (glob.__EquipHealExecutedKey === key) return;
  glob.__EquipHealExecutedKey = key;
  withTimer(0.5, () => {
    glob.__EquipHealExecutedKey = undefined;
  });

  const segments = parseSegments(entry.hot, entry.abilList);
  for (const seg of segments) {
    if (seg.abilId === "") continue;
    if (seg.waitSec <= 0) {
      executeSegment(unit, item, seg);
    } else {
      const capturedSeg = seg;
      const capturedUnit = unit;
      const capturedItem = item;
      withTimer(seg.waitSec, () => {
        executeSegment(capturedUnit, capturedItem, capturedSeg);
      });
    }
  }
}

const INIT_KEY = "__EquipHealInited";
const STES_REG_KEY = "__EquipHealStesRegistered";

function init(this: void): void {
  const glob = globalThis as any;
  if (glob[INIT_KEY]) return;
  glob[INIT_KEY] = true;

  if (typeof jass.CreateTrigger !== "function" || typeof jass.TriggerAddAction !== "function") {
    return;
  }

  if (!glob[STES_REG_KEY] && STES_Register != null) {
    const stesTrig = jass.CreateTrigger();
    jass.TriggerAddAction(stesTrig, () => {
      onItemHealStesChild();
    });
    ydlStes_registerAfterGetTable(undefined, stesTrig, ITEM_HEAL_STES_EVENT);
    glob[STES_REG_KEY] = true;
  }

  const useItemEv = jass.EVENT_PLAYER_UNIT_USE_ITEM ?? 35;
  const trig = jass.CreateTrigger();
  for (let i = 0; i <= 6; i++) jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), useItemEv, undefined!);
  if (typeof jass.Player === "function") {
    const p13 = jass.Player(13);
    if (p13 != null) jass.TriggerRegisterPlayerUnitEvent(trig, p13, useItemEv, undefined!);
  }
  jass.TriggerAddAction(trig, () => {
    onUseItem();
  });
}

init();
