/** @noSelfInFile */
/**
 * 动态技能文本 - 核心业务逻辑
 *
 * 遍历本地玩家选中单位的命令卡技能，动态替换描述中的公式为实际伤害数值
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const selectionSnapshotSystem = require("系统.03．技能系统.00．本地选中技能快照") as {
  获取本地选中技能快照: (this: void) => {
    hero: any | null;
    skills: Record<"Q" | "W" | "E" | "R" | "D", number>;
  };
};

const { debugLog } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLog: (module: string, ...args: any[]) => void;
};

import {
  属性名称列表,
  动态文本白名单,
  动态文本跳过片段列表,
  动态文本属性别名表,
  动态文本增减类前缀列表,
  动态文本目标类前缀列表,
} from "./01．公式配置";
import type { 属性类型 } from "./01．公式配置";
import { 计算公式伤害 } from "./02．属性计算";

const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilcode: number) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

const DzGetUnitAbilityUberTip = japi.DzGetUnitAbilityUberTip as (unit: any, abilityId: number) => string;
const DzSetUnitAbilityUberTip = japi.DzSetUnitAbilityUberTip as (unit: any, abilityId: number, tip: string) => boolean;
const DzSetUnitAbilityUpdate = japi.DzSetUnitAbilityUpdate as (unit: any, abilityId: number) => boolean;

const MODULE_NAME = "动态技能文本";
const 单属性最大替换次数 = 8;
const 原始提示缓存: Record<string, string | undefined> = {};
const 已处理技能缓存: Record<string, number[] | undefined> = {};

type 公式匹配结果 = {
  完整匹配: string;
  倍率: string;
  开始位置: number;
};

type 属性匹配项 = {
  文本名: string;
  计算属性名: 属性类型;
};

const 排序属性匹配项列表: 属性匹配项[] = 属性名称列表
  .filter(function (属性名): boolean {
    return 动态文本白名单.indexOf(属性名) >= 0;
  })
  .flatMap(function (属性名): 属性匹配项[] {
    const 匹配项列表: 属性匹配项[] = [{ 文本名: 属性名, 计算属性名: 属性名 }];
    const 别名列表 = 动态文本属性别名表[属性名];
    if (别名列表 != null) {
      for (let i = 0; i < 别名列表.length; i++) {
        匹配项列表.push({ 文本名: 别名列表[i], 计算属性名: 属性名 });
      }
    }
    return 匹配项列表;
  })
  .sort((a, b) => b.文本名.length - a.文本名.length);

const 增减类属性显示名表: Partial<Record<属性类型, string>> = {
  攻击力: "点攻击力",
  生命值: "点生命值",
  最大生命值: "点生命值",
  魔法值: "点魔法值",
  最大魔法值: "点魔法值",
};

function isValidHandle(handle: any): boolean {
  return handle != null && handle !== 0;
}

function 是否为增减类语境(this: void, text: string, 匹配开始: number): boolean {
  for (let i = 0; i < 动态文本增减类前缀列表.length; i++) {
    const 前缀 = 动态文本增减类前缀列表[i];
    const 前缀开始 = 匹配开始 - 前缀.length;
    if (前缀开始 < 0) continue;
    if (text.substring(前缀开始, 匹配开始) === 前缀) return true;
  }
  return false;
}

function 是否为目标类语境(this: void, text: string, 匹配开始: number): boolean {
  for (let i = 0; i < 动态文本目标类前缀列表.length; i++) {
    const 前缀 = 动态文本目标类前缀列表[i];
    const 搜索起点 = 匹配开始 - 前缀.length - 2;
    if (搜索起点 < 0) continue;
    const 片段 = text.substring(搜索起点, 匹配开始);
    if (片段.indexOf(前缀) >= 0) return true;
  }
  return false;
}

function 是否为自身类语境(this: void, text: string, 匹配开始: number): boolean {
  const 搜索起点 = 匹配开始 - 8;
  const 起点 = 搜索起点 > 0 ? 搜索起点 : 0;
  const 片段 = text.substring(起点, 匹配开始);
  return 片段.indexOf("自身") >= 0;
}

function 获取匹配前窗口(this: void, text: string, 匹配开始: number): string {
  const 搜索起点 = 匹配开始 - 10;
  const 起点 = 搜索起点 > 0 ? 搜索起点 : 0;
  return text.substring(起点, 匹配开始);
}

function 是否命中跳过片段(this: void, text: string): boolean {
  for (let i = 0; i < 动态文本跳过片段列表.length; i++) {
    if (text.indexOf(动态文本跳过片段列表[i]) >= 0) return true;
  }
  return false;
}

function 获取增减类显示文本(this: void, 属性匹配项: 属性匹配项, 数值文本: string): string {
  const 显示名 = 增减类属性显示名表[属性匹配项.计算属性名];
  if (显示名 != null) return 数值文本 + 显示名;
  return 数值文本 + "点" + 属性匹配项.文本名;
}

function 获取快照技能列表(this: void, hero: any): number[] {
  const ids: number[] = [];
  const seen: Record<number, boolean | undefined> = {};
  const 快照 = selectionSnapshotSystem.获取本地选中技能快照();

  if (!isValidHandle(hero) || 快照.hero !== hero) return ids;

  const 技能热键列表: Array<"Q" | "W" | "E" | "R" | "D"> = ["Q", "W", "E", "R", "D"];
  for (let i = 0; i < 技能热键列表.length; i++) {
    const abilityId = 快照.skills[技能热键列表[i]];
    if (abilityId == null || abilityId === 0 || seen[abilityId] === true) continue;
    seen[abilityId] = true;
    ids.push(abilityId);
  }

  return ids;
}

function 生成提示缓存键(this: void, unit: any, abilityId: number): string {
  return GetHandleId(unit).toString() + ":" + abilityId.toString();
}

function 生成英雄缓存键(this: void, unit: any): string {
  return GetHandleId(unit).toString();
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

function 查找最后匹配位置(this: void, text: string, pattern: string, beforeIndex: number): number {
  let 命中位置 = -1;
  let 搜索位置 = text.indexOf(pattern);
  while (搜索位置 >= 0 && 搜索位置 < beforeIndex) {
    命中位置 = 搜索位置;
    搜索位置 = text.indexOf(pattern, 搜索位置 + pattern.length);
  }
  return 命中位置;
}

function 调整前缀倍率起点避开颜色码(this: void, text: string, 数字起始: number, 属性位置: number): number {
  const 颜色起始 = 查找最后匹配位置(text, "|cff", 属性位置);
  if (颜色起始 < 0) return 数字起始;

  const 颜色结束 = 颜色起始 + 10;
  if (颜色结束 <= 数字起始 || 颜色结束 >= 属性位置) return 数字起始;

  const 颜色值 = text.substring(颜色起始 + 2, 颜色结束);
  for (let i = 0; i < 颜色值.length; i++) {
    const 字符 = 颜色值.charAt(i);
    const 是数字 = 字符 >= "0" && 字符 <= "9";
    const 是小写十六进制字母 = 字符 >= "a" && 字符 <= "f";
    const 是大写十六进制字母 = 字符 >= "A" && 字符 <= "F";
    if (!是数字 && !是小写十六进制字母 && !是大写十六进制字母) {
      return 数字起始;
    }
  }

  const 最近重置 = 查找最后匹配位置(text, "|r", 属性位置);
  if (最近重置 > 颜色起始) return 数字起始;

  return 颜色结束;
}

function 提取前缀倍率匹配(this: void, text: string, 属性文本名: string, 起始位置: number): 公式匹配结果 | null {
  let 属性位置 = text.indexOf(属性文本名, 起始位置);
  while (属性位置 >= 0) {
    let 数字起始 = 属性位置;
    while (数字起始 > 0) {
      const 字符 = text.charAt(数字起始 - 1);
      if ((字符 >= "0" && 字符 <= "9") || 字符 === "." || 字符 === "%") {
        数字起始--;
      } else {
        break;
      }
    }

    if (数字起始 < 属性位置) {
      数字起始 = 调整前缀倍率起点避开颜色码(text, 数字起始, 属性位置);
      let 完整匹配开始 = 数字起始;
      if (数字起始 >= 2 && text.substring(数字起始 - 2, 数字起始) === "自身") {
        完整匹配开始 = 数字起始 - 2;
      }
      const 倍率 = text.substring(数字起始, 属性位置);
      const 末字符 = 倍率.charAt(倍率.length - 1);
      let 含数字 = false;
      for (let i = 0; i < 倍率.length; i++) {
        const 字符 = 倍率.charAt(i);
        if (字符 >= "0" && 字符 <= "9") {
          含数字 = true;
          break;
        }
      }

      if (含数字 && (末字符 === "%" || (末字符 >= "0" && 末字符 <= "9") || 末字符 === ".")) {
        return {
          完整匹配: text.substring(完整匹配开始, 属性位置 + 属性文本名.length),
          倍率,
          开始位置: 完整匹配开始,
        };
      }
    }

    属性位置 = text.indexOf(属性文本名, 属性位置 + 属性文本名.length);
  }

  return null;
}

/**
 * 提取一个可替换的公式片段
 * 支持：
 * 1. 属性名×数字 / 属性名×数字%
 * 2. 属性名数字 / 属性名数字%
 */
function 提取公式匹配(this: void, text: string, 属性文本名: string, 起始位置: number): 公式匹配结果 | null {
  const 乘号前缀 = 属性文本名 + "×";
  const 乘号位置 = text.indexOf(乘号前缀, 起始位置);
  if (乘号位置 >= 0) {
    const 倍率 = 提取倍率(text, 乘号位置 + 乘号前缀.length);
    if (倍率 != null) {
      return {
        完整匹配: 乘号前缀 + 倍率,
        倍率,
        开始位置: 乘号位置,
      };
    }
  }

  let 属性位置 = text.indexOf(属性文本名, 起始位置);
  while (属性位置 >= 0) {
    const 数字起始 = 属性位置 + 属性文本名.length;
    const 首字符 = 数字起始 < text.length ? text.charAt(数字起始) : "";
    if ((首字符 >= "0" && 首字符 <= "9") || 首字符 === ".") {
      const 倍率 = 提取倍率(text, 数字起始);
      if (倍率 != null) {
        return {
          完整匹配: 属性文本名 + 倍率,
          倍率,
          开始位置: 属性位置,
        };
      }
    }
    属性位置 = text.indexOf(属性文本名, 属性位置 + 属性文本名.length);
  }

  return 提取前缀倍率匹配(text, 属性文本名, 起始位置);
}

/**
 * 动态替换技能提示中的公式
 * 例如：智力×3 -> 150（假设英雄智力50）
 */
function 替换公式(this: void, unit: any, tip: string): string {
  if (是否命中跳过片段(tip)) return tip;

  let result = tip;

  for (let i = 0; i < 排序属性匹配项列表.length; i++) {
    const 属性匹配项 = 排序属性匹配项列表[i];

    let 搜索起点 = 0;
    let 匹配结果 = 提取公式匹配(result, 属性匹配项.文本名, 搜索起点);
    let 替换次数 = 0;
    while (匹配结果 != null) {
      let 匹配开始 = 匹配结果.开始位置;
      if (匹配开始 < 0) break;
      let 完整匹配文本 = 匹配结果.完整匹配;
      const 匹配前窗口 = 获取匹配前窗口(result, 匹配开始);

      if (完整匹配文本.indexOf("自身") < 0 && 匹配开始 >= 2 && result.substring(匹配开始 - 2, 匹配开始) === "自身") {
        匹配开始 -= 2;
        完整匹配文本 = "自身" + 完整匹配文本;
      }

      if ((完整匹配文本.indexOf("目标") >= 0 || 匹配前窗口.indexOf("目标") >= 0) && 完整匹配文本.indexOf("自身") < 0 && 匹配前窗口.indexOf("自身") < 0) {
        搜索起点 = 匹配开始 + 完整匹配文本.length;
        匹配结果 = 提取公式匹配(result, 属性匹配项.文本名, 搜索起点);
        continue;
      }

      if (是否为增减类语境(result, 匹配开始)) {
        搜索起点 = 匹配开始 + 完整匹配文本.length;
        匹配结果 = 提取公式匹配(result, 属性匹配项.文本名, 搜索起点);
        continue;
      }

      if (是否为目标类语境(result, 匹配开始) && !是否为自身类语境(result, 匹配开始)) {
        搜索起点 = 匹配开始 + 完整匹配文本.length;
        匹配结果 = 提取公式匹配(result, 属性匹配项.文本名, 搜索起点);
        continue;
      }

      const 伤害 = 计算公式伤害(unit, 属性匹配项.计算属性名, 匹配结果.倍率);
      const 替换值 = 伤害.toString();
      result = result.substring(0, 匹配开始) + 替换值 + result.substring(匹配开始 + 完整匹配文本.length);
      替换次数++;
      if (替换次数 >= 单属性最大替换次数) {
        debugLog(MODULE_NAME, "单属性替换达到上限，提前中止", 属性匹配项.文本名);
        break;
      }
      搜索起点 = 匹配开始 + 替换值.length;
      匹配结果 = 提取公式匹配(result, 属性匹配项.文本名, 搜索起点);
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

  const abilityIds = 获取快照技能列表(hero);
  已处理技能缓存[生成英雄缓存键(hero)] = abilityIds;
  for (let i = 0; i < abilityIds.length; i++) {
    const level = GetUnitAbilityLevel(hero, abilityIds[i]);
    if (level > 0) {
      处理技能提示(hero, abilityIds[i]);
    }
  }
}

export function 恢复英雄技能原始文本(this: void, hero: any): void {
  if (!isValidHandle(hero)) return;

  const abilityIds = 已处理技能缓存[生成英雄缓存键(hero)] || 获取快照技能列表(hero);
  for (let i = 0; i < abilityIds.length; i++) {
    恢复单个技能原始文本(hero, abilityIds[i]);
  }
  delete 已处理技能缓存[生成英雄缓存键(hero)];
}
