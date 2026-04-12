/**
 * 装备回复：使用物品时解析 hot/abilList，按段 **STES「物品治疗事件」** 分发。
 *
 * 逆天约定（传参与返回值**同时支持**，不互斥）：
 * - **传参 `YDLocal5Set` → 子 `YDLocal5Get`**（父在 `YDLocalExecuteTrigger` 之后写入 `ydl_triggerstep`）：
 *   `unit` **ItemHealUnit**，`real` **ItemHealHP** / **ItemHealMP**，`item` **Item**，`string` **物品技能标识**。
 * - **返回值 子 `YDLocal7Set` → 父 `YDLocal1Get`**（须先 `SaveInteger(YDHT,子,SKey_PIndex,父页)`，与 STES_Fire / `fireItemHealEvent` 一致）：
 *   键名与上列对应：**ItemHealHP**、**ItemHealMP**、**Item**、**ItemHealUnit**。
 *   HP/MP：父传参 **非全 0** 时 7 为**实际加上的量**；**双 0** 且能从使用物品事件 + 装备表推算时 7 为**推算总量**（便于父 `QuestMessage`）。**Item/Unit** 先读 5，缺则回退 `GetManipulatedItem` / `GetManipulatingUnit`（`GetTriggerUnit`）再写回 7。
 *
 * 父遍历子触发须：`YDLocalExecuteTrigger` → `saveParentIndex` → `YDLocal5Set…` → `YDTriggerExecuteTrigger(false)`。
 *
 * 不再使用 `udg_TempReal` / `gg_trg_物品治疗触发` 等旧全局。
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

const {
  parseEquipHealSegments,
  calcEquipHealHpMp,
  sumHealFromItemData,
} = require("系统.02．物品系统.06．装备回复_hot") as {
  parseEquipHealSegments: (hot: string, abil: string) => { tokens: string[]; abilId: string; waitSec: number }[];
  calcEquipHealHpMp: (tokens: string[], unit: any) => { hp: number; mp: number };
  sumHealFromItemData: (
    unit: any,
    item: any,
    data: Record<string, { hot?: string; abilList?: string }>,
    fourCC: (n: number) => string,
  ) => { hp: number; mp: number; ok: boolean };
};

/** 与地图 STES / JASS `StringHash` 一致 */
export const ITEM_HEAL_STES_EVENT = "物品治疗事件";

/** YDLocal5 / YDLocal7 同名键（5=传参，7=返回值） */
const YL_UNIT = "ItemHealUnit";
const YL_HP = "ItemHealHP";
const YL_MP = "ItemHealMP";
const YL_ITEM = "Item";
const YL_ABIL = "物品技能标识";

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

/** 治疗前后差值，供 YDLocal7 与父 `YDLocal1Get(real,…)` 对齐手写 JASS 子触发的「有效回复量」语义 */
function applyHpMpToUnitAndGetApplied(this: void, unit: any, hp: number, mp: number): { hpApplied: number; mpApplied: number } {
  if (unit == null || unit === 0) return { hpApplied: 0, mpApplied: 0 };
  if (typeof jass.GetUnitState !== "function") return { hpApplied: 0, mpApplied: 0 };

  let lifeBefore = 0;
  let manaBefore = 0;
  if (jass.UNIT_STATE_LIFE != null) lifeBefore = jass.GetUnitState(unit, jass.UNIT_STATE_LIFE) as number;
  if (jass.UNIT_STATE_MANA != null) manaBefore = jass.GetUnitState(unit, jass.UNIT_STATE_MANA) as number;

  applyHpMpToUnit(unit, hp, mp);

  let lifeAfter = lifeBefore;
  let manaAfter = manaBefore;
  if (jass.UNIT_STATE_LIFE != null) lifeAfter = jass.GetUnitState(unit, jass.UNIT_STATE_LIFE) as number;
  if (jass.UNIT_STATE_MANA != null) manaAfter = jass.GetUnitState(unit, jass.UNIT_STATE_MANA) as number;

  return {
    hpApplied: Math.max(0, lifeAfter - lifeBefore),
    mpApplied: Math.max(0, manaAfter - manaBefore),
  };
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
    YDLocal5Set("unit", YL_UNIT, unit);
    YDLocal5Set("real", YL_HP, hp);
    YDLocal5Set("real", YL_MP, mp);
    YDLocal5Set("item", YL_ITEM, item);
    YDLocal5Set("string", YL_ABIL, abilId);
    YDTriggerExecuteTrigger(trg, false);
  }

  const prev = _indexStack.length > 0 ? _indexStack.pop()! : 0;
  setG_SIndex(prev);
  setG_LIndex(prev);
}

/** STES 子触发：读参 →（缺参则从使用物品事件 / 装备表补全）→ 治疗 → 四路 YDLocal7 写回父 */
function onItemHealStesChild(this: void): void {
  try {
    ydlStes_syncTriggerStep(undefined);

    const rawHp = ydlStes_readReal5(undefined, YL_HP);
    const rawMp = ydlStes_readReal5(undefined, YL_MP);
    let unit: any = YDLocal5Get("unit", YL_UNIT);
    let item: any = YDLocal5Get("item", YL_ITEM);
    void ydlStes_readString5(undefined, YL_ABIL);

    if (unit == null || unit === 0) {
      if (typeof jass.GetManipulatingUnit === "function") unit = jass.GetManipulatingUnit();
      if ((unit == null || unit === 0) && typeof jass.GetTriggerUnit === "function") unit = jass.GetTriggerUnit();
    }
    if (item == null || item === 0) {
      if (typeof jass.GetManipulatedItem === "function") item = jass.GetManipulatedItem();
    }

    let hp = rawHp;
    let mp = rawMp;
    let filledFromItemData = false;
    if (rawHp === 0 && rawMp === 0 && !isSpecialUnit(unit)) {
      const inf = sumHealFromItemData(unit, item, itemsData as Record<string, { hot?: string; abilList?: string }>, fourCCToString);
      if (inf.ok) {
        hp = inf.hp;
        mp = inf.mp;
        filledFromItemData = true;
      }
    }

    const { hpApplied, mpApplied } = applyHpMpToUnitAndGetApplied(unit, hp, mp);

    const hp7 = filledFromItemData ? hp : hpApplied;
    const mp7 = filledFromItemData ? mp : mpApplied;
    YDLocal7Set("real", YL_HP, hp7);
    YDLocal7Set("real", YL_MP, mp7);
    YDLocal7Set("item", YL_ITEM, item);
    YDLocal7Set("unit", YL_UNIT, unit);
  } finally {
    ydlStes_finishChildCleanup(undefined);
  }
}

function executeSegment(
  unit: any,
  item: any,
  seg: { tokens: string[]; abilId: string; waitSec: number },
): void {
  const { hp, mp } = calcEquipHealHpMp(seg.tokens, unit);
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

  const segments = parseEquipHealSegments(entry.hot, entry.abilList);
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
