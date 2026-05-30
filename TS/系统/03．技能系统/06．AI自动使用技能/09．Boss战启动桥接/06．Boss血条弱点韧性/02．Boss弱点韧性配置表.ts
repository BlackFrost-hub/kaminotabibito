/** @noSelfInFile */

import type { Boss弱点定义, Boss弱点韧性配置 } from "./00．类型";
import { Boss弱点反馈默认配置, Boss弱点候选列表, Boss弱点YD字段 } from "./01．常量定义";

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableTypeName: string, tableKey: any, attr: string, valueTypeName: string) => any;
};

// 后续按旧 JASS/YD 字段与 wts 常量逐个 Boss 迁移，配置表不直接堆 111.j 的重复分支。
export const Boss弱点韧性配置表: Boss弱点韧性配置[] = [];

function 读取Boss弱点标记(this: void, bossUnit: any, weakKey: string): boolean {
  return YDUserDataGetSafe("unit", bossUnit, weakKey, "boolean") === true;
}

function 读取Boss护盾值(this: void, bossUnit: any, attr: string): number | undefined {
  const value = Number(YDUserDataGetSafe("unit", bossUnit, attr, "integer")) || 0;
  return value > 0 ? value : undefined;
}

function 读取Boss秒数字段毫秒(this: void, bossUnit: any, attr: string): number | undefined {
  const value = Number(YDUserDataGetSafe("unit", bossUnit, attr, "real")) || 0;
  return value > 0 ? value * 1000 : undefined;
}

function 创建YD弱点配置(this: void, bossUnit: any): Boss弱点韧性配置 | undefined {
  const weakList: Boss弱点定义[] = [];
  for (let i = 0; i < Boss弱点候选列表.length; i++) {
    const candidate = Boss弱点候选列表[i];
    if (读取Boss弱点标记(bossUnit, candidate.弱点键)) {
      weakList.push(candidate);
    }
  }
  if (weakList.length <= 0) return undefined;

  return {
    配置键: "YD弱点标记",
    弱点列表: weakList,
    天生弱点数: weakList.length,
    初始护盾值: 读取Boss护盾值(bossUnit, Boss弱点YD字段.原始护盾值),
    弱点伤害需求: 读取Boss护盾值(bossUnit, Boss弱点YD字段.器弱伤害需求),
    护盾冷却毫秒: 读取Boss秒数字段毫秒(bossUnit, Boss弱点YD字段.护盾冷却) ?? Boss弱点反馈默认配置.护盾恢复延迟毫秒,
    弱点发现音效路径: Boss弱点反馈默认配置.弱点发现音效路径,
    弱点击中音效路径: Boss弱点反馈默认配置.弱点击中音效路径,
    护盾破碎音效路径: Boss弱点反馈默认配置.护盾破碎音效路径,
    弱点发现提示启用: Boss弱点反馈默认配置.弱点发现提示启用,
    护盾命中削减值: Boss弱点反馈默认配置.护盾命中削减值,
    弱点命中表现毫秒: Boss弱点反馈默认配置.弱点命中表现毫秒,
    弱点命中伤害加成: Boss弱点反馈默认配置.弱点命中伤害加成,
    破盾控制Buff类型: Boss弱点反馈默认配置.破盾控制Buff类型,
    破盾控制持续秒: Boss弱点反馈默认配置.破盾控制持续秒,
    破盾伤害倍率: Boss弱点反馈默认配置.破盾伤害倍率,
    破碎护盾显示毫秒: Boss弱点反馈默认配置.破碎护盾显示毫秒,
  };
}

export function 查找Boss弱点韧性配置(this: void, bossUnit: any): Boss弱点韧性配置 | undefined {
  if (bossUnit == null || bossUnit === 0) return undefined;
  const ydConfig = 创建YD弱点配置(bossUnit);
  if (ydConfig != null) return ydConfig;
  return undefined;
}
