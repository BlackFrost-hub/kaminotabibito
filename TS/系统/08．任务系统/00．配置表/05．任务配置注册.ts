/** @noSelfInFile */

import { getObjectProperty, ObjectType } from "../../../lib/扩展函数/YDWE函数/00．YDWE函数";
import { questDB, QuestType, QuestStatus } from "../01．任务数据";
import type { 任务配置 } from "./02．任务配置表";

export interface 任务NPC图标配置 {
  单位ID?: string;
}

const 奖励目标前缀列表 = ["所有玩家", "完成任务的玩家", "Player"];

function 去除奖励目标前缀(this: void, 原文: string): string {
  let 文本 = 原文.trim();
  for (const 前缀 of 奖励目标前缀列表) {
    if (文本.indexOf(前缀) !== 0) continue;
    文本 = 文本.substring(前缀.length).trim();
    while (文本.charAt(0) === "+" || 文本.charAt(0) === "＋") 文本 = 文本.substring(1).trim();
    break;
  }
  return 文本;
}

function 去除完整外括号(this: void, 原文: string): string {
  const 文本 = 原文.trim();
  if (文本.length >= 2 && 文本.charAt(0) === "(" && 文本.charAt(文本.length - 1) === ")") {
    return 文本.substring(1, 文本.length - 1).trim();
  }
  return 文本;
}

function 查找最后字符位置(this: void, 文本: string, 目标字符: string): number {
  for (let i = 文本.length - 1; i >= 0; i--) {
    if (文本.charAt(i) === 目标字符) return i;
  }
  return -1;
}

function 翻译数值表达式(this: void, 原文: string): string {
  let 文本 = 去除完整外括号(原文);
  if (文本.indexOf("IMaxBJ(") === 0) {
    const 逗号位置 = 查找最后字符位置(文本, ",");
    const 右括号位置 = 查找最后字符位置(文本, ")");
    if (逗号位置 >= 0 && 右括号位置 > 逗号位置) {
      return "根据英雄等级计算（最低" + 文本.substring(逗号位置 + 1, 右括号位置).trim() + "）";
    }
    return "根据英雄等级动态计算";
  }
  文本 = 文本.split("*").join("×");
  文本 = 文本.split("等级").join("英雄等级");
  文本 = 文本.split("英雄英雄等级").join("英雄等级");
  文本 = 文本.split("(英雄等级)").join("英雄等级");
  return 文本;
}

function 提取属性奖励数值(this: void, 文本: string, 属性名: string): string {
  const 属性位置 = 文本.indexOf(属性名);
  if (属性位置 < 0) return "";
  const 属性前 = 文本.substring(0, 属性位置).trim();
  const 属性后 = 文本.substring(属性位置 + 属性名.length).trim();
  if (属性前 !== "") return 属性前.split("%").join("").trim();
  let 后段 = 属性后;
  while (后段.charAt(0) === ":" || 后段.charAt(0) === "+" || 后段.charAt(0) === "＋") 后段 = 后段.substring(1).trim();
  return 后段.split("%").join("").trim();
}

function 翻译单条奖励(this: void, 原文: string): string {
  const 文本 = 去除奖励目标前缀(原文);
  if (文本 === "" || 文本 === "null") return "";

  const 百分比属性 = ["金属性抗性", "魔法伤害", "暴击伤害", "暴击率"];
  for (const 属性名 of 百分比属性) {
    if (文本.indexOf(属性名) < 0) continue;
    const 数值 = 提取属性奖励数值(文本, 属性名);
    return 数值 !== "" ? 属性名 + "提升" + 翻译数值表达式(数值) + "%" : 属性名 + "提升";
  }

  if (文本.indexOf("智力成长") >= 0) {
    const 数值 = 提取属性奖励数值(文本, "智力成长");
    return "智力成长提升" + 翻译数值表达式(数值) + "点";
  }

  const 经验位置 = 文本.indexOf("经验");
  if (经验位置 >= 0) {
    const 数值 = 翻译数值表达式(文本.substring(0, 经验位置));
    if (数值.indexOf("根据英雄等级计算") === 0) return "根据英雄等级获得经验（最低10000点）";
    return 数值 + "点经验";
  }

  const 金币位置 = 文本.indexOf("金币");
  if (金币位置 >= 0) return 翻译数值表达式(文本.substring(0, 金币位置)) + "金币";

  const 能量碎片位置 = 文本.indexOf("能量碎片");
  if (能量碎片位置 >= 0) return 翻译数值表达式(文本.substring(0, 能量碎片位置)) + "枚能量碎片";

  const 攻击力位置 = 文本.indexOf("攻击力");
  if (攻击力位置 >= 0) return "攻击力提升" + 翻译数值表达式(文本.substring(0, 攻击力位置)) + "点";

  const 基础属性名列表 = ["力量", "敏捷", "智力"];
  for (const 属性名 of 基础属性名列表) {
    const 属性位置 = 文本.indexOf(属性名);
    if (属性位置 < 0) continue;
    return 属性名 + "提升" + 翻译数值表达式(文本.substring(0, 属性位置)) + "点";
  }

  const 等级位置 = 文本.length - "等级".length;
  if (等级位置 > 0 && 文本.substring(等级位置) === "等级") {
    return "英雄等级提升" + 翻译数值表达式(文本.substring(0, 等级位置)) + "级";
  }

  return 文本;
}

function 读取条件数字(this: void, 文本: string): number {
  let 数字 = 0;
  let 已开始 = false;
  for (let i = 0; i < 文本.length; i++) {
    const 字符 = 文本.charAt(i);
    if (字符 >= "0" && 字符 <= "9") {
      已开始 = true;
      数字 = 数字 * 10 + 字符.charCodeAt(0) - 48;
    } else if (已开始) {
      break;
    }
  }
  return 数字;
}

function 翻译奖励条件(this: void, 原文: string): string {
  const 文本 = 原文.trim();
  const 等级 = 读取条件数字(文本);
  if (文本.indexOf("英雄等级≤") === 0 || 文本.indexOf("英雄等级<=") === 0) return "英雄等级" + tostring(等级) + "级及以下";
  if (文本.indexOf("英雄等级＞") === 0 || 文本.indexOf("英雄等级>") === 0) return "英雄等级高于" + tostring(等级) + "级";
  if (文本.indexOf("装备等级") === 0) return "提交符合要求的装备时";
  if (文本.indexOf("|") >= 0 && 文本.indexOf("I") >= 0) return "提交指定珍贵物品时";
  return 文本;
}

function 是否奖励条件文本(this: void, 原文: string): boolean {
  const 文本 = 原文.trim();
  if (文本.indexOf("英雄等级") === 0) return true;
  if (文本.indexOf("装备等级") === 0) return true;
  return 文本.indexOf("|") >= 0 && 文本.indexOf("I") >= 0;
}

export function 解析任务奖励展示文本(this: void, 原文: string): string {
  if (!原文 || 原文 === "") return "无";
  const 输出行: string[] = [];
  const 原始行 = 原文.split("\n");
  for (const 行文本 of 原始行) {
    const 行 = 行文本.trim();
    if (行 === "" || 行 === "外部：" || 行 === "内部：") continue;
    const 冒号位置 = 行.indexOf(":");
    if (冒号位置 > 0 && 是否奖励条件文本(行.substring(0, 冒号位置))) {
      const 条件 = 行.substring(0, 冒号位置).trim();
      const 奖励部分 = 行.substring(冒号位置 + 1).trim();
      if (奖励部分 === "") continue;
      const 奖励列表 = 奖励部分.split(";");
      const 展示奖励: string[] = [];
      for (const 奖励 of 奖励列表) {
        const 结果 = 翻译单条奖励(奖励);
        if (结果 !== "") 展示奖励.push(结果);
      }
      if (展示奖励.length > 0) 输出行.push(翻译奖励条件(条件) + "：" + 展示奖励.join("、"));
      continue;
    }

    const 奖励列表 = 行.split(";");
    const 展示奖励: string[] = [];
    for (const 奖励 of 奖励列表) {
      const 结果 = 翻译单条奖励(奖励);
      if (结果 !== "") 展示奖励.push(结果);
    }
    if (展示奖励.length > 0) 输出行.push(展示奖励.join("、"));
  }
  return 输出行.length > 0 ? 输出行.join("\n") : "无";
}

export function resolveRewardDisplayText(quest: Partial<任务配置> | null | undefined): string {
  if (!quest) return "无";
  const reward = quest.奖励显示 && quest.奖励显示 !== "" ? quest.奖励显示 : (quest.奖励 || "");
  return 解析任务奖励展示文本(reward);
}

function normalizeRequireCount(this: void, count?: number): number {
  return count != null && count > 1 ? count : 1;
}

function 构建任务目标(this: void, cfg: 任务配置): Array<{ id: string; description: string; current: number; required: number; completed: boolean }> {
  if (cfg.目标单位分别击杀 === true && cfg.目标单位) {
    const 单位列表 = cfg.目标单位.split("|");
    const 显示名列表 = (cfg.目标单位显示名 || "").split("|");
    const 目标列表: Array<{ id: string; description: string; current: number; required: number; completed: boolean }> = [];
    for (let i = 0; i < 单位列表.length; i++) {
      const 单位代码 = 单位列表[i].trim();
      if (单位代码 === "") continue;
      const 显示名 = (显示名列表[i] || 单位代码).trim();
      目标列表.push({ id: "kill_" + 单位代码, description: "击杀" + 显示名, current: 0, required: 1, completed: false });
    }
    return 目标列表;
  }
  if (!cfg.需求物品 && !cfg.目标单位) return [];
  return [{
    id: "obj1",
    description: cfg.进度文本 || cfg.描述 || cfg.名称 || "",
    current: 0,
    required: normalizeRequireCount(cfg.需求数量),
    completed: false,
  }];
}

export function 注册单个任务配置到任务库(
  this: void,
  cfg: 任务配置,
  npcCfg?: 任务NPC图标配置 | null,
): boolean {
  if (cfg.启用 !== true || !cfg.任务ID) return false;
  const questId = cfg.任务ID.toString();
  if (questDB.getQuest(questId)) return true;

  let iconPath = "";
  if (npcCfg && npcCfg.单位ID) {
    iconPath = getObjectProperty(ObjectType.UNIT, npcCfg.单位ID, "Art");
  }

  questDB.registerQuest({
    id: questId,
    type: QuestType.DAILY,
    title: cfg.名称 || questId,
    description: cfg.描述 || cfg.名称 || "",
    objectives: 构建任务目标(cfg),
    rewards: [{ type: "gold", value: 0, description: resolveRewardDisplayText(cfg) }],
    status: QuestStatus.UNDISCOVERED,
    startNpc: cfg.开始NPC,
    icon: iconPath || undefined,
    createdAt: 0,
    updatedAt: 0,
  });
  return true;
}
