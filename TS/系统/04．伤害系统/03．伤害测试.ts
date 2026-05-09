/** @noSelfInFile */

/** 伤害测试开关（默认关闭，伤害判断已合并到伤害显示系统） */
const ENABLED = true;

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const 伤害事件 = require("系统.04．伤害系统.01．伤害事件") as {
  MNAnyUnitDamaged: (trg: any, interval: number) => void;
};
const 伤害函数 = require("lib.扩展函数.封装函数.06．伤害函数.index") as {
  YDWEIsEventDamageType: (damageType: any) => boolean;
  YDWEIsEventPhysicalDamage: () => boolean;
  YDWEIsEventAttackDamage: () => boolean;
  YDWEIsEventRangedDamage: () => boolean;
  YDWEIsEventAttackType: (attackType: any) => boolean;
  isMagicDamage: () => boolean;
  isEnhancedDamage: () => boolean;
  isTrueDamage: () => boolean;
  isNormalAttack: () => boolean;
  isSkillAttack: () => boolean;
  isSkillDamage: () => boolean;
  isPhysicalDamage: () => boolean;
  isMetalDamage: () => boolean;
  isWoodDamage: () => boolean;
  isWaterDamage: () => boolean;
  isFireDamage: () => boolean;
  isThunderDamage: () => boolean;
  isLightDamage: () => boolean;
  isDarkDamage: () => boolean;
};
const 护盾模块 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.index") as {
  查询单位是否有护盾: (this: void, 单位: any) => boolean;
  查询单位总护盾值: (this: void, 单位: any) => number;
};

function sendMsg(msg: string): void {
  for (let i = 0; i <= 15; i++) {
    const p = (jass as any).Player(i);
    if (p != null) (jass as any).DisplayTextToPlayer(p, 0, 0, msg);
  }
}

/** 伤害测试：`japi.GetEventDamage`（1.27 与 `YDWESetEventDamage` 改写后一致；无则 0） */
function readEventDamageForDisplay(): number {
  let v: number | undefined;
  (pcall as any)(() => {
    v = (japi as any).GetEventDamage();
  });
  if (v !== undefined && typeof v === "number" && !Number.isNaN(v)) {
    return v;
  }
  return 0;
}

/** 读取原始伤害（GetEventDamage 在某些环境可能返回改写前的值） */
function readOriginalDamage(): number {
  let v: number | undefined;
  (pcall as any)(() => {
    v = (jass as any).GetEventDamage();
  });
  if (v !== undefined && typeof v === "number" && !Number.isNaN(v)) {
    return v;
  }
  return 0;
}

function TrigActions(): void {
  const unit = jass.GetTriggerUnit();
  const finalDamage = readEventDamageForDisplay();
  if (!unit) return;

  const name = (jass as any).GetUnitName(unit);
  const finalDamageStr = (jass as any).R2S(finalDamage);

  // 护盾检测
  const 有护盾 = 护盾模块.查询单位是否有护盾(unit);
  const 护盾值 = 有护盾 ? 护盾模块.查询单位总护盾值(unit) : 0;
  const g = (globalThis as any);
  const 护盾吸收 = (typeof g._shieldAbsorbAmount === "number") ? g._shieldAbsorbAmount : 0;
  const 护盾吸收类型文本 = (typeof g._shieldAbsorbType === "string") ? g._shieldAbsorbType : "";

  let damageTypeParts: string[] = [];
  if (伤害函数.isFireDamage()) {
    damageTypeParts.push("火");
  }
  if (伤害函数.isWaterDamage()) {
    damageTypeParts.push("冰");
  }
  if (伤害函数.isThunderDamage()) {
    damageTypeParts.push("雷");
  }
  if (伤害函数.isMetalDamage()) {
    damageTypeParts.push("毒");
  }
  if (伤害函数.isLightDamage()) {
    damageTypeParts.push("光");
  }
  if (伤害函数.YDWEIsEventDamageType(jass.DAMAGE_TYPE_MAGIC)) {
    damageTypeParts.push("魔法");
  }
  if (伤害函数.isWoodDamage()) {
    damageTypeParts.push("风");
  }
  if (伤害函数.isDarkDamage()) {
    damageTypeParts.push("暗");
  }
  if (伤害函数.isPhysicalDamage()) {
    damageTypeParts.push("物理");
  }

  let typeText = "";
  if (damageTypeParts.length > 0) {
    typeText = damageTypeParts.join("");
    if (伤害函数.isMagicDamage()) {
      typeText = typeText + "魔法";
    }
  }

  const isEnhanced = 伤害函数.isEnhancedDamage();
  const isTrue = 伤害函数.isTrueDamage();
  let prefix = "";
  if (伤害函数.isNormalAttack()) {
    prefix = "普攻";
  } else if (伤害函数.isSkillAttack()) {
    prefix = "技能攻击";
  } else if (伤害函数.isSkillDamage()) {
    prefix = "技能";
  }
  
  if (isEnhanced && prefix !== "") {
    prefix = prefix + "强化";
  }
  if (isTrue && prefix !== "") {
    prefix = prefix + "精神";
  }

  let msg: string;
  if (prefix !== "" && typeText !== "") {
    msg = name + "受到了" + finalDamageStr + "点" + prefix + typeText + "伤害";
  } else if (prefix !== "") {
    msg = name + "受到了" + finalDamageStr + "点" + prefix + "伤害";
  } else if (typeText !== "") {
    msg = name + "受到了" + finalDamageStr + "点" + typeText + "伤害";
  } else {
    msg = name + "受到了" + finalDamageStr + "点伤害";
  }

  if (伤害函数.YDWEIsEventRangedDamage()) {
    msg = msg + "（远程）";
  }

  // 护盾吸收信息
  if (有护盾 && 护盾吸收 > 0) {
    msg = msg + " [护盾吸收" + (jass as any).R2S(护盾吸收) + "点" + 护盾吸收类型文本 + "伤害, 剩余护盾:" + (jass as any).R2S(护盾值) + "]";
  } else if (有护盾) {
    msg = msg + " [护盾:" + (jass as any).R2S(护盾值) + "]";
  }

  let source: any = null;
  (pcall as any)(() => { source = (jass as any).GetEventDamageSource(); });
  if (source == null) {
    (pcall as any)(() => { source = GetEventDamageSource(); });
  }
  if (source != null) {
    const sourceName = (jass as any).GetUnitName(source);
    if (sourceName != null && sourceName !== "") msg = msg + " 伤害来源：" + sourceName;
  }

  sendMsg(msg);
}

function TrigConditions(): boolean {
  return true;
}

function init(): void {
  if (!ENABLED) return;
  const trg = jass.CreateTrigger();
  jass.TriggerAddCondition(trg, jass.Condition(TrigConditions));
  伤害事件.MNAnyUnitDamaged(trg, 60);
  jass.TriggerAddAction(trg, TrigActions);
}

init();

export {};
