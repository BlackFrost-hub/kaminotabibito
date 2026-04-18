/**
 * 玩家系统 - 英雄注册联动 - 背包满移交宠物
 *
 * 职责：
 * - 创建并维护「英雄对物品下 smart 命令」监听触发器
 * - 对外暴露 registerPetItemHandoffHero，让英雄注册桥接在拿到英雄时完成事件挂接
 */

const jass = require("jass.common") as any;

const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (tableTypeName: string, tableKey: any, attr: string, valueTypeName: string) => any;
};

const { String2OrderIdBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  String2OrderIdBJ: (orderIdString: string) => number;
};

const { SoHeroHatm, GS_news } = require("lib.扩展函数.Star扩展函数.GS扩展库.index") as {
  SoHeroHatm: (whichUnit: any) => number;
  GS_news: (whichPlayer: any, message: string) => void;
};

const PET_ATTR = "BB";
const SMART_ORDER = "smart";
const MSG_BOTH_FULL = "|cffffff00『系统提示』：|r英雄和|cffffcc99『宠物』|r的物品栏都已满，无法拾取！";
const MSG_MOVED_TO_PET = "|cffffff00『系统提示』：|r由于物品栏已满，已经移交到|cffffcc99『宠物』|r";

let petItemHandoffTrigger: any = null;
let smartOrderId = 0;
const registeredHeroIds: Set<number> = new Set();

function isValidHandle(handle: any): boolean {
  return handle != null && handle !== 0;
}

function getHandleId(handle: any): number {
  if (!isValidHandle(handle) || typeof jass.GetHandleId !== "function") return 0;
  return (jass.GetHandleId(handle) as number) || 0;
}

function ensureSmartOrderId(): number {
  if (smartOrderId !== 0) return smartOrderId;
  smartOrderId = typeof String2OrderIdBJ === "function"
    ? String2OrderIdBJ(SMART_ORDER)
    : (typeof jass.OrderId === "function" ? ((jass.OrderId(SMART_ORDER) as number) || 0) : 0);
  return smartOrderId;
}

function ensurePetItemHandoffTrigger(): any {
  if (petItemHandoffTrigger != null) return petItemHandoffTrigger;
  if (typeof jass.CreateTrigger !== "function" || typeof jass.TriggerAddAction !== "function") return null;

  petItemHandoffTrigger = jass.CreateTrigger();
  jass.TriggerAddAction(petItemHandoffTrigger, onPetItemHandoff);
  return petItemHandoffTrigger;
}

/**
 * 处理“英雄背包已满时，将目标物品转交给宠物”的核心逻辑。
 */
function onPetItemHandoff(): void {
  if (typeof jass.GetTriggerUnit !== "function" || typeof jass.GetOrderTargetItem !== "function") return;
  if (typeof jass.GetIssuedOrderId !== "function" || typeof jass.GetOwningPlayer !== "function") return;
  if (typeof jass.UnitAddItem !== "function") return;

  const targetItem = jass.GetOrderTargetItem();
  if (!isValidHandle(targetItem)) return;

  const issuedOrderId = (jass.GetIssuedOrderId() as number) || 0;
  if (issuedOrderId !== ensureSmartOrderId()) return;

  const hero = jass.GetTriggerUnit();
  if (!isValidHandle(hero) || SoHeroHatm(hero) < 6) return;

  const owner = jass.GetOwningPlayer(hero);
  if (!isValidHandle(owner)) return;

  const pet = YDUserDataGet("player", owner, PET_ATTR, "unit");
  if (!isValidHandle(pet)) return;

  if (SoHeroHatm(pet) >= 6) {
    GS_news(owner, MSG_BOTH_FULL);
    return;
  }

  jass.UnitAddItem(pet, targetItem);
  GS_news(owner, MSG_MOVED_TO_PET);
}

/**
 * 由英雄注册桥接调用。
 * 给指定英雄挂上“smart 目标物品命令”监听，避免重复注册。
 */
export function registerPetItemHandoffHero(whichHero: any): void {
  if (!isValidHandle(whichHero)) return;
  const trigger = ensurePetItemHandoffTrigger();
  if (trigger == null || typeof jass.TriggerRegisterUnitEvent !== "function") return;

  const heroId = getHandleId(whichHero);
  if (heroId === 0 || registeredHeroIds.has(heroId)) return;

  jass.TriggerRegisterUnitEvent(trigger, whichHero, jass.EVENT_UNIT_ISSUED_TARGET_ORDER);
  registeredHeroIds.add(heroId);
}

/**
 * 初始化时只确保触发器存在，真正的英雄注册由桥接模块负责。
 */
export function initPetItemHandoff(): void {
  ensurePetItemHandoffTrigger();
}

export {};
