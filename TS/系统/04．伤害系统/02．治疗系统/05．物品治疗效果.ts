/** @noSelfInFile */
/**
 * 物品治疗效果系统
 *
 * 功能：根据技能ID执行不同类型的治疗效果
 * - A002: 单体瞬间回复生命值
 * - A0LF: 单体瞬间回复魔法值
 * - A015: 单体瞬间回复生命值和魔法值
 * - A0B8: 群体瞬间回复生命值和魔法值（范围1000）
 * - A08C: 单体缓慢回复生命值和魔法值（HOT，10秒）
 *
 * 后续接手者注意：
 * 1. 直接调用 doHeal 和 startHot，不需要通过STES事件
 * 2. 技能ID使用FourCC整数比较
 */

const jass = require("jass.common") as any;

const { isValidUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isValidUnit: (this: void, unit: any) => boolean;
};

const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (s: string) => number;
};

// 导入核心治疗功能
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (params: {
    HealSource: any;
    HealTarget: any;
    HealAmount: number;
    HealManaAmount?: number;
    ItemHeal: boolean;
    HealEffect: boolean;
    ManaEffect?: boolean;
  }) => number;
};

// 导入HOT系统
const { startHot, isHotActive } = require("系统.04．伤害系统.02．治疗系统.04．持续治疗效果") as {
  startHot: (target: any, source: any, tickHP: number, tickMP: number, duration: number) => void;
  isHotActive: (target: any) => boolean;
};

const {
  YDUserDataGet,
} = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, key: any, attr: string, valueType: string) => any;
};

//=============================================================================
// 一、常量配置
//=============================================================================

/** 技能ID */
const ABIL_A002 = stringToFourCC("A002"); // 单体瞬间回复生命值
const ABIL_A0LF = stringToFourCC("A0LF"); // 单体瞬间回复魔法值
const ABIL_A015 = stringToFourCC("A015"); // 单体瞬间回复生命值和魔法值
const ABIL_A0B8 = stringToFourCC("A0B8"); // 群体瞬间回复生命值和魔法值
const ABIL_A08C = stringToFourCC("A08C"); // 单体缓慢回复生命值和魔法值

/** 群体治疗范围 */
const GROUP_HEAL_RADIUS = 1000.0;

/** HOT持续时间 */
const HOT_DURATION = 10.0;

/** HOT每秒恢复比例 */
const HOT_TICK_RATIO = 0.1;

/** 系统开关 */
const HEAL_ITEM_SYSTEM_ENABLED = true;

//=============================================================================
// 二、辅助函数
//=============================================================================

/**
 * 检查单位是否可以被治疗（有效单位 + 友方或自身）
 */
function canBeHealed(unit: any, sourcePlayer: any, source: any): boolean {
  if (!isValidUnit(unit)) return false;
  if (!jass.IsUnitAlly(unit, sourcePlayer) && unit !== source) return false;
  return true;
}

//=============================================================================
// 三、核心功能
//=============================================================================

/**
 * 执行物品治疗效果
 *
 * @param abilId 技能ID（FourCC整数）
 * @param target 目标单位
 * @param healHP 治疗HP量
 * @param healMP 治疗MP量
 */
export function doHealItemEffect(
  abilId: number,
  target: any,
  healHP: number,
  healMP: number
): void {
  if (!HEAL_ITEM_SYSTEM_ENABLED) return;
  if (target == null) return;

  const sourcePlayer = jass.GetOwningPlayer(target);

  // A002: 单体瞬间回复生命值
  if (abilId === ABIL_A002) {
    doHeal({
      HealSource: target,
      HealTarget: target,
      HealAmount: healHP,
      ItemHeal: true,
      HealEffect: true,
    });
    return;
  }

  // A0LF: 单体瞬间回复魔法值
  if (abilId === ABIL_A0LF) {
    doHeal({
      HealSource: target,
      HealTarget: target,
      HealAmount: 0,
      HealManaAmount: healMP,
      ItemHeal: true,
      HealEffect: false,
      ManaEffect: true,
    });
    return;
  }

  // A015: 单体瞬间回复生命值和魔法值
  if (abilId === ABIL_A015) {
    doHeal({
      HealSource: target,
      HealTarget: target,
      HealAmount: healHP,
      HealManaAmount: healMP,
      ItemHeal: true,
      HealEffect: true,
      ManaEffect: true,
    });
    return;
  }

  // A0B8: 群体瞬间回复生命值和魔法值
  if (abilId === ABIL_A0B8) {
    const x = jass.GetUnitX(target);
    const y = jass.GetUnitY(target);
    const group = jass.CreateGroup();

    jass.GroupEnumUnitsInRange(group, x, y, GROUP_HEAL_RADIUS, null);

    let unit = jass.FirstOfGroup(group);
    while (unit != null) {
      jass.GroupRemoveUnit(group, unit);

      if (canBeHealed(unit, sourcePlayer, target)) {
        doHeal({
          HealSource: target,
          HealTarget: unit,
          HealAmount: healHP,
          HealManaAmount: healMP,
          ItemHeal: true,
          HealEffect: true,
          ManaEffect: true,
        });
      }

      unit = jass.FirstOfGroup(group);
    }

    jass.DestroyGroup(group);
    return;
  }

  // A08C: 单体缓慢回复生命值和魔法值（HOT）
  if (abilId === ABIL_A08C) {
    // JASS条件：新的治疗量 >= 当前HOT总治疗量 时才更新
    // 防止覆盖更强的HOT效果
    if (isHotActive(target)) {
      const currentTickHP = YDUserDataGet("unit", target, "hotTickHP", "real");
      const currentTickMP = YDUserDataGet("unit", target, "hotTickMP", "real");
      const currentCountdown = YDUserDataGet("unit", target, "持续恢复倒计时", "real");
      const currentTotalHP = currentTickHP * currentCountdown;
      const currentTotalMP = currentTickMP * currentCountdown;

      // 如果新的治疗量不够强，不覆盖
      if (healHP < currentTotalHP && healMP < currentTotalMP) {
        return;
      }
    }

    // 启动新的HOT
    const tickHP = healHP * HOT_TICK_RATIO;
    const tickMP = healMP * HOT_TICK_RATIO;
    startHot(target, target, tickHP, tickMP, HOT_DURATION);
    return;
  }
}

/**
 * 通过技能ID字符串执行物品治疗效果
 *
 * @param abilIdStr 技能ID字符串（如 "A002"）
 * @param target 目标单位
 * @param healHP 治疗HP量
 * @param healMP 治疗MP量
 */
export function doHealItemEffectById(
  abilIdStr: string,
  target: any,
  healHP: number,
  healMP: number
): void {
  if (typeof abilIdStr !== "string" || abilIdStr.length !== 4) return;
  const abilId = stringToFourCC(abilIdStr);
  doHealItemEffect(abilId, target, healHP, healMP);
}

/**
 * 检查技能ID是否为物品治疗技能
 */
export function isHealItemAbility(abilId: number): boolean {
  return (
    abilId === ABIL_A002 ||
    abilId === ABIL_A0LF ||
    abilId === ABIL_A015 ||
    abilId === ABIL_A0B8 ||
    abilId === ABIL_A08C
  );
}

export {};
/** @noSelfInFile */
