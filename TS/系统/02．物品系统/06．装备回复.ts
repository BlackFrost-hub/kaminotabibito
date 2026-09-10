/** @noSelfInFile */
/**
 * 装备回复：使用物品时解析 hot/abilList，直接调用 TS 回复逻辑。
 * 立即段直接执行，延迟段交给本地计时检查；回复量统一由治疗系统结算。
 */

const jass = require("jass.common") as any;
const GetItemTypeId = jass.GetItemTypeId as (this: void, item: any) => number;
const { onItemUse } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemUse: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const { 临时玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行") as {
  临时玩家属性: (this: void, unit: any, attr: string, delta: number, duration: number) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
// 灼热（食用）：烤熔岩灵鱼专属使用增益，数值暂定 30 秒火属性伤害 +30%
const 灼热使用BuffID = "C075";
const 灼热使用持续秒 = 30;
const 灼热使用火伤加成 = 0.3;
const { doHealItemEffectById } = require("系统.04．伤害系统.02．治疗系统.05．物品治疗效果") as {
  doHealItemEffectById: (this: void, abilId: string, target: any, healHP: number, healMP: number, hotDuration?: number) => void;
};

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

const itemsData = (require("系统.02．物品系统.01．装备数据") as { default: Record<string, { hot?: string; hotDuration?: number; abilList?: string }> }).default;
const { fourCCToString, isSpecialUnit } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  fourCCToString: (this: void, four: number) => string;
  isSpecialUnit: (unit: any) => boolean;
};

const {
  parseEquipHealSegments,
  calcEquipHealHpMp,
} = require("系统.02．物品系统.06．装备回复_hot") as {
  parseEquipHealSegments: (hot: string, abil: string) => { tokens: string[]; abilId: string; waitSec: number }[];
  calcEquipHealHpMp: (tokens: string[], unit: any) => { hp: number; mp: number };
};

/** 直接执行物品治疗效果，不再经过 STES / YDLocal */
function applyItemHeal(this: void, unit: any, hp: number, mp: number, abilId: string, hotDuration?: number): void {
  doHealItemEffectById(abilId, unit, hp, mp, hotDuration);
}

function executeSegment(
  unit: any,
  seg: { tokens: string[]; abilId: string; waitSec: number },
  hotDuration?: number,
): void {
  const { hp, mp } = calcEquipHealHpMp(seg.tokens, unit);
  applyItemHeal(unit, hp, mp, seg.abilId, hotDuration);
}

const 装备回复计时检查间隔毫秒 = 10;
const 装备回复防抖键列表: string[] = [];
const 装备回复防抖到期毫秒列表: number[] = [];
const 装备回复延迟单位列表: any[] = [];
const 装备回复延迟段列表: { tokens: string[]; abilId: string; waitSec: number }[] = [];
const 装备回复延迟持续时间列表: (number | undefined)[] = [];
const 装备回复延迟到期毫秒列表: number[] = [];
let 装备回复计时检查回调ID = 0;

function 停止装备回复计时检查(this: void): void {
  if (装备回复计时检查回调ID <= 0) return;
  removePeriodicCallback(装备回复计时检查回调ID);
  装备回复计时检查回调ID = 0;
}

function 确保装备回复计时检查(this: void): void {
  if (装备回复计时检查回调ID > 0) return;
  装备回复计时检查回调ID = addPeriodicCallback(装备回复计时检查间隔毫秒, on装备回复计时检查);
}

function 安排装备回复防抖清理(this: void, key: string, delaySec: number): void {
  装备回复防抖键列表.push(key);
  装备回复防抖到期毫秒列表.push(getServerTime() + delaySec * 1000);
  确保装备回复计时检查();
}

function 安排装备回复延迟段(this: void, unit: any, seg: { tokens: string[]; abilId: string; waitSec: number }, hotDuration?: number): void {
  装备回复延迟单位列表.push(unit);
  装备回复延迟段列表.push(seg);
  装备回复延迟持续时间列表.push(hotDuration);
  装备回复延迟到期毫秒列表.push(getServerTime() + seg.waitSec * 1000);
  确保装备回复计时检查();
}

function 处理装备回复防抖到期(this: void, now: number): void {
  let writeIndex = 0;
  for (let i = 0; i < 装备回复防抖键列表.length; i++) {
    if (now >= 装备回复防抖到期毫秒列表[i]) {
      (globalThis as any).__EquipHealExecutedKey = undefined;
    } else {
      装备回复防抖键列表[writeIndex] = 装备回复防抖键列表[i];
      装备回复防抖到期毫秒列表[writeIndex] = 装备回复防抖到期毫秒列表[i];
      writeIndex += 1;
    }
  }
  for (let i = 装备回复防抖键列表.length - 1; i >= writeIndex; i--) {
    装备回复防抖键列表.pop();
    装备回复防抖到期毫秒列表.pop();
  }
}

function 处理装备回复延迟段到期(this: void, now: number): void {
  let writeIndex = 0;
  for (let i = 0; i < 装备回复延迟单位列表.length; i++) {
    if (now >= 装备回复延迟到期毫秒列表[i]) {
      executeSegment(装备回复延迟单位列表[i], 装备回复延迟段列表[i], 装备回复延迟持续时间列表[i]);
    } else {
      装备回复延迟单位列表[writeIndex] = 装备回复延迟单位列表[i];
      装备回复延迟段列表[writeIndex] = 装备回复延迟段列表[i];
      装备回复延迟持续时间列表[writeIndex] = 装备回复延迟持续时间列表[i];
      装备回复延迟到期毫秒列表[writeIndex] = 装备回复延迟到期毫秒列表[i];
      writeIndex += 1;
    }
  }
  for (let i = 装备回复延迟单位列表.length - 1; i >= writeIndex; i--) {
    装备回复延迟单位列表.pop();
    装备回复延迟段列表.pop();
    装备回复延迟持续时间列表.pop();
    装备回复延迟到期毫秒列表.pop();
  }
}

function on装备回复计时检查(this: void): void {
  const now = getServerTime();
  处理装备回复防抖到期(now);
  处理装备回复延迟段到期(now);
  if (装备回复防抖键列表.length <= 0 && 装备回复延迟单位列表.length <= 0) {
    停止装备回复计时检查();
  }
}

function onUseItem(this: void, eventUnit?: any, eventItem?: any): void {
  let unit: any = eventUnit;
  if (unit == null) unit = jass.GetManipulatingUnit();
  if (unit == null) unit = jass.GetTriggerUnit();
  let item: any = eventItem;
  if (item == null) item = jass.GetManipulatedItem();
  if (!unit || !item) return;
  if (isSpecialUnit(unit)) return;
  const itemId = GetItemTypeId(item);
  const idStr = fourCCToString(itemId);
  const entry = (itemsData as Record<string, { hot?: string; hotDuration?: number; abilList?: string; useBuff?: string }>)[idStr];
  if (!entry || !entry.hot || !entry.abilList) return;

  const glob = globalThis as any;
  const key = tostring(unit) + "_" + idStr;
  if (glob.__EquipHealExecutedKey === key) return;
  glob.__EquipHealExecutedKey = key;
  安排装备回复防抖清理(key, 0.5);

  const segments = parseEquipHealSegments(entry.hot, entry.abilList);
  for (const seg of segments) {
    if (seg.abilId === "") continue;
    if (seg.waitSec <= 0) {
      executeSegment(unit, seg, entry.hotDuration);
    } else {
      安排装备回复延迟段(unit, seg, entry.hotDuration);
    }
  }

  // 附加使用增益（如烤熔岩灵鱼的灼热）：临时属性真实生效 + buff 栏图标展示，双轨同时长
  if (entry.useBuff === 灼热使用BuffID) {
    临时玩家属性(unit, "火属性伤害", 灼热使用火伤加成, 灼热使用持续秒);
    registerManualBuff(unit, 灼热使用BuffID, 灼热使用持续秒, 灼热使用火伤加成 * 100, {
      effectSourceName: "烤熔岩灵鱼",
      effectSourceType: "食品",
    });
  }
}

const INIT_KEY = "__EquipHealInited";

function onItemUseEvent(this: void, unit: any, item: any): void {
  onUseItem(unit, item);
}

function init(this: void): void {
  const glob = globalThis as any;
  if (glob[INIT_KEY]) return;
  glob[INIT_KEY] = true;

  // 使用物品事件中心注册，减少触发器数量
  onItemUse(onItemUseEvent);
}

init();

export {};
