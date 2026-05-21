/** @noSelfInFile */
/**
 * 扩展控制 - 控制效果定义
 */

export type 快速控制类型 = "stun" | "freeze" | "silence" | "polymorph" | "disarm" | "slow" | "stagger" | "pause" | "expause" | "sleep" | "roots" | "cyclone";
export type 扩展控制类型 = "taunt" | "charm" | "fear";
export type 扩展控制兼容类型 = 快速控制类型 | 扩展控制类型;
export type 恐惧模式 = "逃离施法者" | "随机乱跑";

export interface 嘲讽参数 {
  持续时间: number;
  反伤倍率?: number;
}

export interface 魅惑参数 {
  持续时间: number;
  跟随半径?: number;
}

export interface 恐惧参数 {
  持续时间: number;
  模式?: 恐惧模式;
  逃离距离?: number;
  随机半径?: number;
  移动速度?: number;
}

export type 扩展控制参数 = 嘲讽参数 | 魅惑参数 | 恐惧参数;

export interface 控制效果定义 {
  类型键: string;
  显示名: string;
  BuffID: string;
  类型分类: "快速控制" | "扩展控制";
  快速控制ID?: number;
  吃控制抗性: boolean;
  屏蔽控制命令: boolean;
  需要周期驱动: boolean;
}

export const 快速控制效果定义表 = {
  击晕: { 类型键: "stun", 显示名: "击晕", BuffID: "C001", 类型分类: "快速控制", 快速控制ID: 0, 吃控制抗性: true, 屏蔽控制命令: false, 需要周期驱动: false },
  冰冻: { 类型键: "freeze", 显示名: "冰冻", BuffID: "C002", 类型分类: "快速控制", 快速控制ID: 1, 吃控制抗性: true, 屏蔽控制命令: false, 需要周期驱动: false },
  沉默: { 类型键: "silence", 显示名: "沉默", BuffID: "C003", 类型分类: "快速控制", 快速控制ID: 2, 吃控制抗性: true, 屏蔽控制命令: false, 需要周期驱动: false },
  变形: { 类型键: "polymorph", 显示名: "变形", BuffID: "C004", 类型分类: "快速控制", 快速控制ID: 3, 吃控制抗性: true, 屏蔽控制命令: false, 需要周期驱动: false },
  缴械: { 类型键: "disarm", 显示名: "缴械", BuffID: "C006", 类型分类: "快速控制", 快速控制ID: 5, 吃控制抗性: true, 屏蔽控制命令: false, 需要周期驱动: false },
  减速: { 类型键: "slow", 显示名: "减速", BuffID: "C007", 类型分类: "快速控制", 快速控制ID: 7, 吃控制抗性: true, 屏蔽控制命令: false, 需要周期驱动: false },
  硬直: { 类型键: "stagger", 显示名: "硬直", BuffID: "C008", 类型分类: "快速控制", 快速控制ID: 21, 吃控制抗性: true, 屏蔽控制命令: false, 需要周期驱动: false },
  暂停: { 类型键: "pause", 显示名: "暂停", BuffID: "C009", 类型分类: "快速控制", 快速控制ID: 22, 吃控制抗性: true, 屏蔽控制命令: false, 需要周期驱动: false },
  EX暂停: { 类型键: "expause", 显示名: "EX暂停", BuffID: "C010", 类型分类: "快速控制", 快速控制ID: 23, 吃控制抗性: true, 屏蔽控制命令: false, 需要周期驱动: false },
  睡眠: { 类型键: "sleep", 显示名: "睡眠", BuffID: "C016", 类型分类: "快速控制", 快速控制ID: 44, 吃控制抗性: true, 屏蔽控制命令: false, 需要周期驱动: false },
  纠缠根须: { 类型键: "roots", 显示名: "纠缠根须", BuffID: "C017", 类型分类: "快速控制", 快速控制ID: 45, 吃控制抗性: true, 屏蔽控制命令: false, 需要周期驱动: false },
  飓风: { 类型键: "cyclone", 显示名: "飓风", BuffID: "C018", 类型分类: "快速控制", 快速控制ID: 46, 吃控制抗性: true, 屏蔽控制命令: false, 需要周期驱动: false },
} as const satisfies Record<string, 控制效果定义>;

export const 扩展控制效果定义表 = {
  taunt: { 类型键: "taunt", 显示名: "嘲讽", BuffID: "C020", 类型分类: "扩展控制", 吃控制抗性: true, 屏蔽控制命令: true, 需要周期驱动: true },
  charm: { 类型键: "charm", 显示名: "魅惑", BuffID: "C022", 类型分类: "扩展控制", 吃控制抗性: true, 屏蔽控制命令: true, 需要周期驱动: true },
  fear: { 类型键: "fear", 显示名: "恐惧", BuffID: "C023", 类型分类: "扩展控制", 吃控制抗性: true, 屏蔽控制命令: true, 需要周期驱动: true },
} as const satisfies Record<扩展控制类型, 控制效果定义>;

export const 默认魅惑跟随半径 = 160;
export const 默认恐惧逃离距离 = 500;
export const 默认恐惧随机半径 = 450;
export const 默认恐惧移动速度 = 50;
export const 魅惑特效模型 = "Abilities\\Spells\\Other\\SoulBurn\\SoulBurnbuff.mdl";
export const 恐惧特效模型 = "BuffIcon\\model\\Grin Curse.mdx";
export const 扩展控制特效挂点 = "overhead";

export function 获取扩展控制定义(this: void, 类型: 扩展控制类型): 控制效果定义 {
  return 扩展控制效果定义表[类型];
}

export function 获取控制效果定义(this: void, 类型: 扩展控制兼容类型 | string): 控制效果定义 | undefined {
  const 扩展定义 = 扩展控制效果定义表[类型 as 扩展控制类型];
  if (扩展定义 != null) return 扩展定义;
  const 快速键列表 = Object.keys(快速控制效果定义表) as Array<keyof typeof 快速控制效果定义表>;
  for (let i = 0; i < 快速键列表.length; i++) {
    const 定义 = 快速控制效果定义表[快速键列表[i]];
    if (定义.类型键 === 类型) return 定义;
  }
  return undefined;
}

export {};
