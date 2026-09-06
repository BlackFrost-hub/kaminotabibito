/** @noSelfInFile */
/**
 * 动态技能文本 - 核心业务逻辑
 *
 * 遍历本地玩家选中单位的命令卡技能，动态替换描述中的公式为实际伤害数值
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const heroConfigTool = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具") as {
  获取单位玩家英雄配置: (this: void, unit: any) => Record<string, any> | null;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const selectionSnapshotSystem = require("系统.03．技能系统.00．本地选中技能快照") as {
  获取本地选中技能快照: (this: void) => {
    hero: any | null;
    skills: Record<"Q" | "W" | "E" | "R" | "D", number>;
  };
};
const dynamicSkillData = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．动态技能数据") as {
  刷新单位技能数据: (this: void, unit: any) => void;
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
const R2I = jass.R2I as (value: number) => number;

const DzGetUnitAbilityUberTip = japi.DzGetUnitAbilityUberTip as (unit: any, abilityId: number) => string;
const DzSetUnitAbilityUberTip = japi.DzSetUnitAbilityUberTip as (unit: any, abilityId: number, tip: string) => boolean;
const DzSetUnitAbilityUpdate = japi.DzSetUnitAbilityUpdate as (unit: any, abilityId: number) => boolean;

const MODULE_NAME = "动态技能文本";
const 单属性最大替换次数 = 8;
const 动态数值标记前缀 = "__DYN_NUM_";
const 动态数值标记后缀 = "__";
const ALT提示尾注 = "|n|cff99ccff（按下Alt显示详细信息）|r";
const 原始提示缓存: Record<string, string | undefined> = {};
const 已处理技能缓存: Record<string, number[] | undefined> = {};

type 公式匹配结果 = {
  完整匹配: string;
  倍率: string;
  开始位置: number;
  /** 着色文案中属性名与数值之间的颜色码（如 攻击力|cff87ceeb120%|r）；替换时原样回填到计算结果前 */
  数值颜色前缀?: string;
};

type 属性匹配项 = {
  文本名: string;
  计算属性名: 属性类型;
};

type 保护片段 = {
  标记: string;
  原文: string;
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

function 是否命中跳过片段(this: void, text: string, 忽略通用消耗保护?: boolean): boolean {
  for (let i = 0; i < 动态文本跳过片段列表.length; i++) {
    const 片段 = 动态文本跳过片段列表[i];
    if (忽略通用消耗保护 === true && 片段 === "消耗") continue;
    if (text.indexOf(片段) >= 0) return true;
  }
  return false;
}

function 获取增减类显示文本(this: void, 属性匹配项: 属性匹配项, 数值文本: string): string {
  const 显示名 = 增减类属性显示名表[属性匹配项.计算属性名];
  if (显示名 != null) return 数值文本 + 显示名;
  return 数值文本 + "点" + 属性匹配项.文本名;
}

function 尝试匹配属性文本(this: void, text: string, 起始位置: number): string | null {
  for (let i = 0; i < 排序属性匹配项列表.length; i++) {
    const 属性文本名 = 排序属性匹配项列表[i].文本名;
    if (text.substring(起始位置, 起始位置 + 属性文本名.length) === 属性文本名) {
      return 属性文本名;
    }
  }
  return null;
}

function 保护目标前缀公式(this: void, text: string, 前缀: string, 保护片段表: 保护片段[]): string {
  let result = text;
  let 搜索起点 = 0;

  while (true) {
    const 前缀位置 = result.indexOf(前缀, 搜索起点);
    if (前缀位置 < 0) break;

    let 当前位置 = 前缀位置 + 前缀.length;
    const 倍率 = 提取倍率(result, 当前位置);
    if (倍率 == null) {
      搜索起点 = 前缀位置 + 前缀.length;
      continue;
    }
    当前位置 += 倍率.length;

    let 命中属性 = false;
    while (true) {
      const 属性文本名 = 尝试匹配属性文本(result, 当前位置);
      if (属性文本名 == null) break;
      命中属性 = true;
      当前位置 += 属性文本名.length;
    }

    if (!命中属性) {
      搜索起点 = 前缀位置 + 前缀.length;
      continue;
    }

    const 原文 = result.substring(前缀位置, 当前位置);
    const 标记 = "__DYN_SKIP_" + 保护片段表.length.toString() + "__";
    保护片段表.push({ 标记, 原文 });
    result = result.substring(0, 前缀位置) + 标记 + result.substring(当前位置);
    搜索起点 = 前缀位置 + 标记.length;
  }

  return result;
}

function 保护目标类公式(this: void, text: string): [string, 保护片段[]] {
  const 保护片段表: 保护片段[] = [];
  let result = text;
  result = 保护目标前缀公式(result, "目标已损失", 保护片段表);
  result = 保护目标前缀公式(result, "目标", 保护片段表);
  result = 保护目标前缀公式(result, "主目标", 保护片段表);
  result = 保护目标前缀公式(result, "副目标", 保护片段表);
  return [result, 保护片段表];
}

function 恢复保护片段(this: void, text: string, 保护片段表: 保护片段[]): string {
  let result = text;
  for (let i = 0; i < 保护片段表.length; i++) {
    const 保护片段 = 保护片段表[i];
    result = result.replace(保护片段.标记, 保护片段.原文);
  }
  return result;
}

function 消除造成自身数值前缀(this: void, text: string): string {
  let result = text;
  const 目标前缀 = "造成自身";
  let 位置 = result.indexOf(目标前缀);
  while (位置 >= 0) {
    const 数字开始 = 位置 + 目标前缀.length;
    const 下一个字符位置 = 数字开始;
    const 字符 = 下一个字符位置 < result.length ? result.charAt(下一个字符位置) : "";
    if ((字符 >= "0" && 字符 <= "9") || 字符 === ".") {
      result = result.substring(0, 位置) + "造成" + result.substring(数字开始);
      位置 = result.indexOf(目标前缀, 位置 + 2);
    } else {
      位置 = result.indexOf(目标前缀, 位置 + 2);
    }
  }
  return result;
}

function 追加Alt提示尾注(this: void, text: string): string {
  if (text.indexOf(ALT提示尾注) >= 0) return text;
  return text + ALT提示尾注;
}

function 包装动态数值(this: void, 数值文本: string): string {
  return 动态数值标记前缀 + 数值文本 + 动态数值标记后缀;
}

function 格式化动态整数(this: void, value: number): string {
  if (value >= 0) return tostring(R2I(value + 0.5));
  return "-" + tostring(R2I(-value + 0.5));
}

type 动态数值标记解析结果 = {
  结束位置: number;
  数值文本: string;
  数值: number;
};

function 解析动态数值标记(this: void, text: string, 起始位置: number): 动态数值标记解析结果 | null {
  if (text.substring(起始位置, 起始位置 + 动态数值标记前缀.length) !== 动态数值标记前缀) return null;

  const 数值开始 = 起始位置 + 动态数值标记前缀.length;
  const 标记结束 = text.indexOf(动态数值标记后缀, 数值开始);
  if (标记结束 < 0) return null;

  const 数值文本 = text.substring(数值开始, 标记结束);
  const 数值 = parseFloat(数值文本);
  if (数值 !== 数值) return null;

  return {
    结束位置: 标记结束 + 动态数值标记后缀.length,
    数值文本,
    数值,
  };
}

function 合并动态数值加法(this: void, text: string): string {
  let result = "";
  let 位置 = 0;

  while (位置 < text.length) {
    const 第一个标记 = 解析动态数值标记(text, 位置);
    if (第一个标记 == null) {
      result += text.charAt(位置);
      位置++;
      continue;
    }

    let 求和 = 第一个标记.数值;
    let 当前结束 = 第一个标记.结束位置;
    let 是否发生合并 = false;

    while (当前结束 < text.length && text.charAt(当前结束) === "+") {
      const 下一个标记 = 解析动态数值标记(text, 当前结束 + 1);
      if (下一个标记 == null) break;
      求和 += 下一个标记.数值;
      当前结束 = 下一个标记.结束位置;
      是否发生合并 = true;
    }

    if (是否发生合并) {
      result += 求和.toString();
    } else {
      result += 第一个标记.数值文本;
    }
    位置 = 当前结束;
  }

  return result;
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

function 是否十六进制字符(this: void, 字符: string): boolean {
  if (字符 >= "0" && 字符 <= "9") return true;
  if (字符 >= "a" && 字符 <= "f") return true;
  return 字符 >= "A" && 字符 <= "F";
}

/**
 * 跳过指定位置开始的连续颜色码（|cffXXXXXXXX 或 |r），返回跳过后的位置。
 * 着色文案中属性名与数值之间会插入颜色码（攻击力|cff87ceeb120%|r），
 * 公式匹配必须越过它们才能重新邻接。
 */
function 跳过颜色码(this: void, text: string, 位置: number): number {
  let 当前 = 位置;
  while (当前 < text.length) {
    if (text.substring(当前, 当前 + 2) === "|r") {
      当前 += 2;
      continue;
    }
    if (当前 + 10 <= text.length && text.substring(当前, 当前 + 2) === "|c") {
      let 合法 = true;
      for (let i = 0; i < 8; i++) {
        if (!是否十六进制字符(text.charAt(当前 + 2 + i))) {
          合法 = false;
          break;
        }
      }
      if (合法) {
        当前 += 10;
        continue;
      }
    }
    break;
  }
  return 当前;
}

function 倍率是否可隐式匹配(this: void, 倍率: string): boolean {
  return 倍率.indexOf("%") >= 0;
}

function 查找最后颜色码起始(this: void, text: string, beforeIndex: number): number {
  let 命中位置 = -1;
  let 搜索位置 = text.indexOf("|c");
  while (搜索位置 >= 0 && 搜索位置 < beforeIndex) {
    let 是颜色码 = 搜索位置 + 10 <= text.length;
    for (let i = 0; i < 8 && 是颜色码; i++) {
      if (!是否十六进制字符(text.charAt(搜索位置 + 2 + i))) {
        是颜色码 = false;
      }
    }
    if (是颜色码) 命中位置 = 搜索位置;
    搜索位置 = text.indexOf("|c", 搜索位置 + 2);
  }
  return 命中位置;
}

function 调整前缀倍率起点避开颜色码(this: void, text: string, 数字起始: number, 属性位置: number): number {
  const 颜色起始 = 查找最后颜色码起始(text, 属性位置);
  if (颜色起始 < 0) return 数字起始;

  const 颜色结束 = 颜色起始 + 10;
  if (颜色结束 <= 数字起始 || 颜色结束 > 属性位置) return 数字起始;

  const 颜色值 = text.substring(颜色起始 + 2, 颜色结束);
  for (let i = 0; i < 颜色值.length; i++) {
    if (!是否十六进制字符(颜色值.charAt(i))) {
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
      if (数字起始 >= 属性位置) {
        属性位置 = text.indexOf(属性文本名, 属性位置 + 属性文本名.length);
        continue;
      }
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

      if (含数字 && 倍率是否可隐式匹配(倍率)) {
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
 * 3. 属性名的数字% —— 例如「最大魔法值的6%」（倍率必须带 %，避免误匹配）
 * 4. 数字%属性名 / 数字属性名（前缀倍率）
 */
function 提取公式匹配(this: void, text: string, 属性文本名: string, 起始位置: number): 公式匹配结果 | null {
  const 乘号前缀 = 属性文本名 + "×";
  const 乘号位置 = text.indexOf(乘号前缀, 起始位置);
  if (乘号位置 >= 0) {
    const 乘号数字起点 = 跳过颜色码(text, 乘号位置 + 乘号前缀.length);
    const 倍率 = 提取倍率(text, 乘号数字起点);
    if (倍率 != null) {
      return {
        完整匹配: text.substring(乘号位置, 乘号数字起点 + 倍率.length),
        倍率,
        开始位置: 乘号位置,
        数值颜色前缀: text.substring(乘号位置 + 乘号前缀.length, 乘号数字起点),
      };
    }
  }

  let 属性位置 = text.indexOf(属性文本名, 起始位置);
  while (属性位置 >= 0) {
    const 数字起始 = 属性位置 + 属性文本名.length;
    // 直连形态：属性名后紧跟数值（攻击力120%）
    const 直连倍率 = 提取倍率(text, 数字起始);
    if (直连倍率 != null && 倍率是否可隐式匹配(直连倍率)) {
      return {
        完整匹配: 属性文本名 + 直连倍率,
        倍率: 直连倍率,
        开始位置: 属性位置,
      };
    }
    // 着色形态：属性名与数值之间隔着颜色码（攻击力|cff87ceeb120%|r）
    const 跳过后 = 跳过颜色码(text, 数字起始);
    if (跳过后 > 数字起始) {
      const 着色倍率 = 提取倍率(text, 跳过后);
      if (着色倍率 != null && 倍率是否可隐式匹配(着色倍率)) {
        return {
          完整匹配: text.substring(属性位置, 跳过后 + 着色倍率.length),
          倍率: 着色倍率,
          开始位置: 属性位置,
          数值颜色前缀: text.substring(数字起始, 跳过后),
        };
      }
    }
    属性位置 = text.indexOf(属性文本名, 属性位置 + 属性文本名.length);
  }

  // 形式三：属性名的数字% —— 例如「最大魔法值的6%」按英雄最大魔法值折算
  const 的连接前缀 = 属性文本名 + "的";
  let 的位置 = text.indexOf(的连接前缀, 起始位置);
  while (的位置 >= 0) {
    const 数字起始 = 的位置 + 的连接前缀.length;
    const 直连倍率 = 提取倍率(text, 数字起始);
    if (直连倍率 != null && 倍率是否可隐式匹配(直连倍率)) {
      return {
        完整匹配: 的连接前缀 + 直连倍率,
        倍率: 直连倍率,
        开始位置: 的位置,
      };
    }
    // 着色形态：最大魔法值的|cff87ceeb6%|r
    const 跳过后 = 跳过颜色码(text, 数字起始);
    if (跳过后 > 数字起始) {
      const 着色倍率 = 提取倍率(text, 跳过后);
      if (着色倍率 != null && 倍率是否可隐式匹配(着色倍率)) {
        return {
          完整匹配: text.substring(的位置, 跳过后 + 着色倍率.length),
          倍率: 着色倍率,
          开始位置: 的位置,
          数值颜色前缀: text.substring(数字起始, 跳过后),
        };
      }
    }
    的位置 = text.indexOf(的连接前缀, 的位置 + 的连接前缀.length);
  }

  return 提取前缀倍率匹配(text, 属性文本名, 起始位置);
}

/**
 * 动态替换技能提示中的公式
 * 例如：智力×3 -> 150（假设英雄智力50）
 */
export interface 动态文本渲染选项 {
  appendAltHint?: boolean;
  preserveFormula?: boolean;
}

function 替换公式(this: void, unit: any, tip: string, options?: 动态文本渲染选项): string {
  const 保护结果 = 保护目标类公式(tip);
  let result = 保护结果[0];
  const 保护片段表 = 保护结果[1];

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

      if (
        (完整匹配文本.indexOf("目标") >= 0 || 匹配前窗口.indexOf("目标") >= 0 || 匹配前窗口.indexOf("目标已损失") >= 0) &&
        完整匹配文本.indexOf("自身") < 0 &&
        匹配前窗口.indexOf("自身") < 0
      ) {
        搜索起点 = 匹配开始 + 完整匹配文本.length;
        匹配结果 = 提取公式匹配(result, 属性匹配项.文本名, 搜索起点);
        continue;
      }

      const 忽略通用消耗保护 = 属性匹配项.计算属性名 === "最大魔法值";
      if (是否命中跳过片段(完整匹配文本, 忽略通用消耗保护) || 是否命中跳过片段(匹配前窗口 + 完整匹配文本, 忽略通用消耗保护)) {
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
      const 动态数值 = 包装动态数值(格式化动态整数(伤害));
      // 着色文案：数值自带的颜色前缀回填到计算结果前，保持数值高亮色不变
      let 替换值 = (匹配结果.数值颜色前缀 != null ? 匹配结果.数值颜色前缀 : "") + 动态数值;
      if (options != null && options.preserveFormula === true) {
        const 保护标记 = "__DYN_SKIP_" + 保护片段表.length.toString() + "__";
        保护片段表.push({ 标记: 保护标记, 原文: 完整匹配文本 + "（" + 动态数值 + "）" });
        替换值 = 保护标记;
      }
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

  result = 恢复保护片段(result, 保护片段表);
  result = 合并动态数值加法(result);
  result = 消除造成自身数值前缀(result);
  if (options == null || options.appendAltHint !== false) {
    result = 追加Alt提示尾注(result);
  }
  return result;
}

export function 渲染动态文本(this: void, unit: any, tip: string, options?: 动态文本渲染选项): string {
  if (unit == null || unit === 0 || tip === "") return tip;
  return 替换公式(unit, tip, options);
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
  return true;
}

function 解析配置技能列表(this: void, hero: any): number[] {
  const config = heroConfigTool.获取单位玩家英雄配置(hero);
  if (config == null) return [];

  const result: number[] = [];
  const seen: Record<number, boolean | undefined> = {};
  const fields = [config.heroAbilList, config.abilList];
  for (let i = 0; i < fields.length; i++) {
    const rawList = fields[i];
    if (typeof rawList !== "string") continue;
    const parts = rawList.split(",");
    for (let j = 0; j < parts.length; j++) {
      const abilityId = stringToFourCCSafe(parts[j]);
      if (abilityId === 0 || seen[abilityId] === true) continue;
      seen[abilityId] = true;
      result.push(abilityId);
    }
  }
  return result;
}

/**
 * 检查本地主控单位的命令卡技能
 */
export function 检查英雄技能(this: void, hero: any): void {
  if (!isValidHandle(hero)) return;

  // Q/W/E/R 可能在英雄注册后才由升级系统加入，先把已登记的显示配置写入新技能。
  dynamicSkillData.刷新单位技能数据(hero);
  const abilityIds = 获取快照技能列表(hero);
  已处理技能缓存[生成英雄缓存键(hero)] = abilityIds;
  // 原始提示只在首次读取技能时缓存；周期刷新不能清掉它，否则 Alt 无法稳定回看原文。
  for (let i = 0; i < abilityIds.length; i++) {
    const level = GetUnitAbilityLevel(hero, abilityIds[i]);
    if (level > 0) {
      处理技能提示(hero, abilityIds[i]);
    }
  }
}

export function 恢复英雄技能原始文本(this: void, hero: any): void {
  if (!isValidHandle(hero)) return;

  const cacheKey = 生成英雄缓存键(hero);
  const cachedAbilityIds = 已处理技能缓存[cacheKey];
  const abilityIds = cachedAbilityIds || 获取快照技能列表(hero);
  for (let i = 0; i < abilityIds.length; i++) {
    恢复单个技能原始文本(hero, abilityIds[i]);
  }
  delete 已处理技能缓存[cacheKey];
}

export function 恢复单个英雄技能原始文本(this: void, hero: any, abilityId: number): void {
  if (!isValidHandle(hero) || abilityId === 0) return;
  恢复单个技能原始文本(hero, abilityId);
}

export function 刷新单个英雄技能动态文本(this: void, hero: any, abilityId: number): void {
  if (!isValidHandle(hero) || abilityId === 0) return;
  if (GetUnitAbilityLevel(hero, abilityId) <= 0) return;
  处理技能提示(hero, abilityId);
}

/** 返回技能首次读取到的原始说明，供自定义提示框的 Alt 原始模式使用。 */
export function 获取技能原始提示(this: void, hero: any, abilityId: number): string {
  if (!isValidHandle(hero) || abilityId === 0) return "";
  const 缓存键 = 生成提示缓存键(hero, abilityId);
  const 已缓存文本 = 原始提示缓存[缓存键];
  if (已缓存文本 != null) return 已缓存文本;

  const 当前文本 = DzGetUnitAbilityUberTip(hero, abilityId) || "";
  if (当前文本 !== "") 原始提示缓存[缓存键] = 当前文本;
  return 当前文本;
}

function 本地刷新指定英雄动态文本(this: void, hero: any): void {
  const 快照 = selectionSnapshotSystem.获取本地选中技能快照();
  if (快照.hero !== hero) return;
  检查英雄技能(hero);
}

/** 装备属性变化后的同步技能界面刷新。调用者必须处于全端对称事件。 */
export function 同步刷新英雄技能界面(this: void, hero: any): void {
  if (!isValidHandle(hero)) return;

  本地刷新指定英雄动态文本(hero);
  const abilityIds = 解析配置技能列表(hero);
  for (let i = 0; i < abilityIds.length; i++) {
    DzSetUnitAbilityUpdate(hero, abilityIds[i]);
  }
}

export function 同步刷新英雄技能原始界面(this: void, hero: any): void {
  if (!isValidHandle(hero)) return;

  const 快照 = selectionSnapshotSystem.获取本地选中技能快照();
  if (快照.hero === hero) {
    恢复英雄技能原始文本(hero);
  }

  const abilityIds = 解析配置技能列表(hero);
  for (let i = 0; i < abilityIds.length; i++) {
    DzSetUnitAbilityUpdate(hero, abilityIds[i]);
  }
}
