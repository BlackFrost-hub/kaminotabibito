const jass = require("jass.common") as any;
const 伤害事件 = require("系统.04．伤害系统.01．伤害事件") as {
  MNAnyUnitDamaged: (trg: any, interval: number) => void;
};
const 伤害函数 = require("系统.00．核心系统.08．伤害函数") as {
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
};

function sendMsg(msg: string): void {
  if (typeof (jass as any).DisplayTextToPlayer !== "function") return;
  for (let i = 0; i <= 15; i++) {
    const p = (jass as any).Player(i);
    if (p != null) (jass as any).DisplayTextToPlayer(p, 0, 0, msg);
  }
}

function TrigActions(): void {
  const unit = jass.GetTriggerUnit();
  const damage = jass.GetEventDamage();
  if (!unit) return;

  const name = typeof (jass as any).GetUnitName === "function" ? (jass as any).GetUnitName(unit) : "单位";
  const damageStr = typeof (jass as any).R2S === "function" ? (jass as any).R2S(damage) : tostring(damage);

  let damageTypeParts: string[] = [];
  if (伤害函数.YDWEIsEventDamageType(jass.DAMAGE_TYPE_FIRE)) {
    damageTypeParts.push("火");
  }
  if (伤害函数.YDWEIsEventDamageType(jass.DAMAGE_TYPE_COLD)) {
    damageTypeParts.push("冰");
  }
  if (伤害函数.YDWEIsEventDamageType(jass.DAMAGE_TYPE_LIGHTNING)) {
    damageTypeParts.push("雷");
  }
  if (
    伤害函数.YDWEIsEventDamageType(jass.DAMAGE_TYPE_POISON) ||
    伤害函数.YDWEIsEventDamageType(jass.DAMAGE_TYPE_DISEASE) ||
    伤害函数.YDWEIsEventDamageType(jass.DAMAGE_TYPE_SLOW_POISON)
  ) {
    damageTypeParts.push("毒");
  }
  if (伤害函数.YDWEIsEventDamageType(jass.DAMAGE_TYPE_DIVINE)) {
    damageTypeParts.push("光");
  }
  if (伤害函数.YDWEIsEventDamageType(jass.DAMAGE_TYPE_MAGIC)) {
    damageTypeParts.push("魔法");
  }
  if (伤害函数.YDWEIsEventDamageType(jass.DAMAGE_TYPE_PLANT)) {
    damageTypeParts.push("风");
  }
  if (伤害函数.YDWEIsEventDamageType(jass.DAMAGE_TYPE_SHADOW_STRIKE)) {
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
    prefix = prefix + "真实";
  }

  let msg: string;
  if (prefix !== "" && typeText !== "") {
    msg = name + "受到了" + damageStr + "点" + prefix + typeText + "伤害";
  } else if (prefix !== "") {
    msg = name + "受到了" + damageStr + "点" + prefix + "伤害";
  } else if (typeText !== "") {
    msg = name + "受到了" + damageStr + "点" + typeText + "伤害";
  } else {
    msg = name + "受到了" + damageStr + "点伤害";
  }

  if (伤害函数.YDWEIsEventRangedDamage()) {
    msg = msg + "（远程）";
  }

  let source: any = null;
  if (typeof (jass as any).GetEventDamageSource === "function") {
    (pcall as any)(() => { source = (jass as any).GetEventDamageSource(); });
  }
  if (source == null) {
    (pcall as any)(() => { source = GetEventDamageSource(); });
  }
  if (source != null && typeof (jass as any).GetUnitName === "function") {
    const sourceName = (jass as any).GetUnitName(source);
    if (sourceName != null && sourceName !== "") msg = msg + " 伤害来源：" + sourceName;
  }

  sendMsg(msg);
}

function TrigConditions(): boolean {
  return true;
}

function init(): void {
  const trg = jass.CreateTrigger();
  if (typeof jass.TriggerAddCondition === "function" && typeof jass.Condition === "function") {
    jass.TriggerAddCondition(trg, jass.Condition(TrigConditions));
  }
  伤害事件.MNAnyUnitDamaged(trg, 60);
  if (typeof jass.TriggerAddAction === "function") {
    jass.TriggerAddAction(trg, TrigActions);
  }
}

init();

export {};
