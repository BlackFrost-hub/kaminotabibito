/** @noSelfInFile */
/**
 * 动态技能文本 - 核心业务逻辑
 *
 * 遍历本地玩家选中单位的命令卡技能，动态替换描述中的公式为实际伤害数值
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { debugLog } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLog: (module: string, ...args: any[]) => void;
};

import { 属性名称列表 } from "./01．公式配置";
import { 计算公式伤害 } from "./02．属性计算";

const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilcode: number) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

const DzGetUnitAbilityUberTip = japi.DzGetUnitAbilityUberTip as (unit: any, abilityId: number) => string;
const DzSetUnitAbilityUberTip = japi.DzSetUnitAbilityUberTip as (unit: any, abilityId: number, tip: string) => boolean;
const DzSetUnitAbilityUpdate = japi.DzSetUnitAbilityUpdate as (unit: any, abilityId: number) => boolean;
const EXGetUnitAbilityByIndex = japi.EXGetUnitAbilityByIndex as (unit: any, index: number) => any;
const EXGetAbilityId = japi.EXGetAbilityId as (ability: any) => number;

const MODULE_NAME = "动态技能文本";
const 技能槽遍历上限 = 64;
const 原始提示缓存: Record<string, string | undefined> = {};
const 排序属性名称列表 = [...属性名称列表].sort((a, b) => b.length - a.length);

type 公式匹配结果 = {
  完整匹配: string;
  倍率: string;
};

function isValidHandle(handle: any): boolean {
  return handle != null && handle !== 0;
}

/**
 * 遍历英雄实际技能列表，避免命令卡/物品技能遮挡导致漏改提示。
 */
function getUnitAbilityIds(this: void, hero: any): number[] {
  const ids: number[] = [];
  const seen: Record<number, boolean | undefined> = {};

  for (let slot = 0; slot < 技能槽遍历上限; slot++) {
    const ability = EXGetUnitAbilityByIndex(hero, slot);
    if (!isValidHandle(ability)) continue;

    const abilityId = EXGetAbilityId(ability);
    if (abilityId == null || abilityId === 0 || seen[abilityId] === true) continue;

    seen[abilityId] = true;
    ids.push(abilityId);
  }

  return ids;
}

function 生成提示缓存键(this: void, unit: any, abilityId: number): string {
  return GetHandleId(unit).toString() + ":" + abilityId.toString();
}

/**
 * 从指定位置读取倍率字符串
 * 例如："3"、"50%"
 */
function 提取倍率(this: void, text: string, 数字起始: number): string | null {
  let 数字结束 = 数字起始;

  while (数字结束 < text.length) {
    const 字符 = text.charAt(数字结束);
    if ((字符 >= "0" && 字符 <= "9") || 字符 === ".") {
      数字结束++;
    } else if (字符 === "%") {
      数字结束++;
      break;
    } else {
      break;
    }
  }

  if (数字结束 === 数字起始) return null;

  return text.substring(数字起始, 数字结束);
}

/**
 * 提取一个可替换的公式片段
 * 支持：
 * 1. 属性名×数字 / 属性名×数字%
 * 2. 属性名数字 / 属性名数字%
 */
function 提取公式匹配(this: void, text: string, 属性名称: string): 公式匹配结果 | null {
  const 乘号前缀 = 属性名称 + "×";
  const 乘号位置 = text.indexOf(乘号前缀);
  if (乘号位置 >= 0) {
    const 倍率 = 提取倍率(text, 乘号位置 + 乘号前缀.length);
    if (倍率 != null) {
      return {
        完整匹配: 乘号前缀 + 倍率,
        倍率,
      };
    }
  }

  let 属性位置 = text.indexOf(属性名称);
  while (属性位置 >= 0) {
    const 数字起始 = 属性位置 + 属性名称.length;
    const 首字符 = 数字起始 < text.length ? text.charAt(数字起始) : "";
    if ((首字符 >= "0" && 首字符 <= "9") || 首字符 === ".") {
      const 倍率 = 提取倍率(text, 数字起始);
      if (倍率 != null) {
        return {
          完整匹配: 属性名称 + 倍率,
          倍率,
        };
      }
    }
    属性位置 = text.indexOf(属性名称, 属性位置 + 属性名称.length);
  }

  return null;
}

/**
 * 动态替换技能提示中的公式
 * 例如：智力×3 -> 150（假设英雄智力50）
 */
function 替换公式(this: void, unit: any, tip: string): string {
  let result = tip;

  for (let i = 0; i < 排序属性名称列表.length; i++) {
    const 属性名称 = 排序属性名称列表[i];

    let 匹配结果 = 提取公式匹配(result, 属性名称);
    while (匹配结果 != null) {
      const 伤害 = 计算公式伤害(unit, 属性名称, 匹配结果.倍率);
      const 替换值 = 伤害.toString();
      result = result.replace(匹配结果.完整匹配, 替换值);
      debugLog(MODULE_NAME, "替换 " + 匹配结果.完整匹配 + " -> " + 替换值);
      匹配结果 = 提取公式匹配(result, 属性名称);
    }
  }

  return result;
}

/**
 * 处理单个技能的提示文本
 */
function 处理技能提示(this: void, unit: any, abilityId: number): boolean {
  const currentTip = DzGetUnitAbilityUberTip(unit, abilityId);
  if (!currentTip) return false;

  const 缓存键 = 生成提示缓存键(unit, abilityId);
  let originalTip = 原始提示缓存[缓存键];
  if (originalTip == null) {
    originalTip = currentTip;
    原始提示缓存[缓存键] = originalTip;
  }

  const newTip = 替换公式(unit, originalTip);

  if (newTip !== currentTip) {
    DzSetUnitAbilityUberTip(unit, abilityId, newTip);
    DzSetUnitAbilityUpdate(unit, abilityId);
    return true;
  }

  return false;
}

function 恢复单个技能原始文本(this: void, unit: any, abilityId: number): boolean {
  const originalTip = 原始提示缓存[生成提示缓存键(unit, abilityId)];
  if (!originalTip) return false;

  const currentTip = DzGetUnitAbilityUberTip(unit, abilityId);
  if (currentTip === originalTip) return false;

  DzSetUnitAbilityUberTip(unit, abilityId, originalTip);
  DzSetUnitAbilityUpdate(unit, abilityId);
  return true;
}

/**
 * 检查本地主控单位的命令卡技能
 */
export function 检查英雄技能(this: void, hero: any): void {
  if (!isValidHandle(hero)) return;

  const abilityIds = getUnitAbilityIds(hero);
  for (let i = 0; i < abilityIds.length; i++) {
    const level = GetUnitAbilityLevel(hero, abilityIds[i]);
    if (level > 0) {
      处理技能提示(hero, abilityIds[i]);
    }
  }
}

export function 恢复英雄技能原始文本(this: void, hero: any): void {
  if (!isValidHandle(hero)) return;

  const abilityIds = getUnitAbilityIds(hero);
  for (let i = 0; i < abilityIds.length; i++) {
    恢复单个技能原始文本(hero, abilityIds[i]);
  }
}
