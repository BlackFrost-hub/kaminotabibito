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

const DzGetUnitAbilityUberTip = japi.DzGetUnitAbilityUberTip as (unit: any, abilityId: number) => string;
const DzSetUnitAbilityUberTip = japi.DzSetUnitAbilityUberTip as (unit: any, abilityId: number, tip: string) => boolean;
const DzSetUnitAbilityUpdate = japi.DzSetUnitAbilityUpdate as (unit: any, abilityId: number) => boolean;
const DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton as (row: number, column: number) => number;
const KKCommandButtonGetAbilityId = japi.KKCommandButtonGetAbilityId as (frame: number) => number;

const MODULE_NAME = "动态技能文本";

/** 命令卡技能槽位坐标映射：[列, 行] */
const 命令卡技能槽位: ReadonlyArray<readonly [number, number]> = [
  [0, 2],
  [1, 2],
  [2, 2],
  [3, 2],
  [0, 1],
];

function isValidHandle(handle: any): boolean {
  return handle != null && handle !== 0;
}

/**
 * 通过命令卡面板XY坐标获取技能ID
 */
function getUnitAbilityIds(): number[] {
  const ids: number[] = [];
  for (let i = 0; i < 命令卡技能槽位.length; i++) {
    const [x, y] = 命令卡技能槽位[i];
    const btn = DzFrameGetCommandBarButton(y, x);
    if (btn !== 0) {
      const abilId = KKCommandButtonGetAbilityId(btn);
      if (abilId !== 0) {
        ids.push(abilId);
      }
    }
  }
  return ids;
}

/**
 * 从字符串中提取数字倍率
 * 例如："×3" -> "3", "×50%" -> "50%"
 */
function 提取倍率(this: void, text: string, 属性名称: string): string | null {
  const 前缀 = 属性名称 + "×";
  const 起始位置 = text.indexOf(前缀);
  if (起始位置 < 0) return null;

  const 数字起始 = 起始位置 + 前缀.length;
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
 * 动态替换技能提示中的公式
 * 例如：智力×3 -> 150（假设英雄智力50）
 */
function 替换公式(this: void, unit: any, tip: string): string {
  let result = tip;

  for (let i = 0; i < 属性名称列表.length; i++) {
    const 属性名称 = 属性名称列表[i];

    let 倍率 = 提取倍率(result, 属性名称);
    while (倍率 != null) {
      const 完整匹配 = 属性名称 + "×" + 倍率;
      const 伤害 = 计算公式伤害(unit, 属性名称, 倍率);
      const 替换值 = 伤害.toString();
      result = result.replace(完整匹配, 替换值);
      debugLog(MODULE_NAME, "替换 " + 完整匹配 + " -> " + 替换值);
      倍率 = 提取倍率(result, 属性名称);
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

  const newTip = 替换公式(unit, currentTip);

  if (newTip !== currentTip) {
    DzSetUnitAbilityUberTip(unit, abilityId, newTip);
    DzSetUnitAbilityUpdate(unit, abilityId);
    return true;
  }

  return false;
}

/**
 * 检查本地主控单位的命令卡技能
 */
export function 检查英雄技能(this: void, hero: any): void {
  if (!isValidHandle(hero)) return;

  const abilityIds = getUnitAbilityIds();
  for (let i = 0; i < abilityIds.length; i++) {
    const level = GetUnitAbilityLevel(hero, abilityIds[i]);
    if (level > 0) {
      处理技能提示(hero, abilityIds[i]);
    }
  }
}
