/** @noSelfInFile */

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
const unitSpecificEventCenter = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerUnitEventTrigger: (this: void, trigger: any, unit: any, eventId: any, once?: boolean) => () => void;
};

const 宠物属性 = "BB";
const 智能命令 = "smart";
const 消息_两者满 = "|cffffff00『系统提示』：|r英雄和|cffffcc99『宠物』|r的物品栏都已满，无法拾取！";
const 消息_移交宠物 = "|cffffff00『系统提示』：|r由于物品栏已满，已经移交到|cffffcc99『宠物』|r";

let 宠物移交触发器: any = null;
let 智能命令ID = 0;
const 已注册英雄ID表: Set<number> = new Set();

function 是否有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 取句柄ID(this: void, handle: any): number {
  if (!是否有效(handle)) return 0;
  return (jass.GetHandleId(handle) as number) || 0;
}

function 确保智能命令ID(this: void): number {
  if (智能命令ID !== 0) return 智能命令ID;
  智能命令ID = String2OrderIdBJ(智能命令);
  return 智能命令ID;
}

function 确保宠物移交触发器(this: void): any {
  if (宠物移交触发器 != null) return 宠物移交触发器;

  宠物移交触发器 = jass.CreateTrigger();
  jass.TriggerAddAction(宠物移交触发器, 宠物移交处理器);
  return 宠物移交触发器;
}

function 宠物移交处理器(this: void): void {
  const 目标物品 = jass.GetOrderTargetItem();
  if (!是否有效(目标物品)) return;

  const 下达命令ID = (jass.GetIssuedOrderId() as number) || 0;
  if (下达命令ID !== 确保智能命令ID()) return;

  const 英雄 = jass.GetTriggerUnit();
  if (!是否有效(英雄) || SoHeroHatm(英雄) < 6) return;

  const 主人 = jass.GetOwningPlayer(英雄);
  if (!是否有效(主人)) return;

  const 宠物 = YDUserDataGet("player", 主人, 宠物属性, "unit");
  if (!是否有效(宠物)) return;

  if (SoHeroHatm(宠物) >= 6) {
    GS_news(主人, 消息_两者满);
    return;
  }

  jass.UnitAddItem(宠物, 目标物品);
  GS_news(主人, 消息_移交宠物);
}

export function 注册宠物移交英雄(this: void, whichHero: any): void {
  if (!是否有效(whichHero)) return;
  const trigger = 确保宠物移交触发器();
  if (trigger == null) return;

  const heroId = 取句柄ID(whichHero);
  if (heroId === 0 || 已注册英雄ID表.has(heroId)) return;

  unitSpecificEventCenter.registerUnitEventTrigger(trigger, whichHero, jass.EVENT_UNIT_ISSUED_TARGET_ORDER);
  已注册英雄ID表.add(heroId);
}

export function 初始化宠物移交(this: void): void {
  确保宠物移交触发器();
}

export {};
