/**
 * Boss自动通魔AI - 常量定义
 *
 * 旧配置式 AI 预览已删除；本文件只保留新系统规划需要的稳定常量。
 */

export const 默认检查间隔Ms = 1000;
export const 默认公共施法间隔Ms = 1500;
export const 默认施法距离 = 1000;
export const 默认扫描槽位数 = 64;

export const 通魔目标_无目标或自身 = 0;
export const 通魔目标_单位目标 = 1;
export const 通魔目标_点目标 = 2;
export const 通魔目标_单位或点目标 = 3;

export type Boss技能目标类型 = "none" | "self" | "unit" | "point" | "unitOrPoint";
export type Boss技能来源类型 = "template" | "channel";

export {};
