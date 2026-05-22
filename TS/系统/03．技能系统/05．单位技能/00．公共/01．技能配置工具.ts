/** @noSelfInFile */

import type { 单位技能归类, 单位技能配置, 单位技能触发方式 } from "./00．技能配置类型";

export function 创建单位技能配置(this: void, 配置: 单位技能配置): 单位技能配置 {
  return 配置;
}

export function 按归类筛选单位技能配置(this: void, 配置列表: 单位技能配置[], 归类: 单位技能归类): 单位技能配置[] {
  const 结果: 单位技能配置[] = [];
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    if (配置.归类 === 归类) {
      结果.push(配置);
    }
  }
  return 结果;
}

export function 按触发方式筛选单位技能配置(
  this: void,
  配置列表: 单位技能配置[],
  触发方式: 单位技能触发方式,
): 单位技能配置[] {
  const 结果: 单位技能配置[] = [];
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    if (配置.触发方式 === 触发方式) {
      结果.push(配置);
    }
  }
  return 结果;
}

export function 按单位类型筛选单位技能配置(this: void, 配置列表: 单位技能配置[], 单位类型: string | number): 单位技能配置[] {
  const 结果: 单位技能配置[] = [];
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    const 单位类型列表 = 配置.单位类型列表;
    if (!单位类型列表 || 单位类型列表.length === 0) {
      结果.push(配置);
      continue;
    }
    for (let j = 0; j < 单位类型列表.length; j++) {
      if (单位类型列表[j] === 单位类型) {
        结果.push(配置);
        break;
      }
    }
  }
  return 结果;
}

export function 按技能ID获取单位技能配置(
  this: void,
  配置列表: 单位技能配置[],
  技能ID: string,
): 单位技能配置 | undefined {
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    if (配置.技能ID === 技能ID) {
      return 配置;
    }
  }
  return undefined;
}

export function 按技能名称获取单位技能配置(
  this: void,
  配置列表: 单位技能配置[],
  技能名称: string,
): 单位技能配置 | undefined {
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    if (配置.技能名 === 技能名称) {
      return 配置;
    }
  }
  return undefined;
}

export function 构建单位技能配置索引(this: void, 配置列表: 单位技能配置[]): Record<string, 单位技能配置> {
  const 索引: Record<string, 单位技能配置> = {};
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    索引[配置.技能ID] = 配置;
  }
  return 索引;
}

export function 构建按单位类型索引(
  this: void,
  配置列表: 单位技能配置[],
): Record<string, 单位技能配置[]> {
  const 索引: Record<string, 单位技能配置[]> = {};
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    const 单位类型列表 = 配置.单位类型列表;
    if (!单位类型列表 || 单位类型列表.length === 0) {
      continue;
    }
    for (let j = 0; j < 单位类型列表.length; j++) {
      const 单位类型 = String(单位类型列表[j]);
      if (!索引[单位类型]) {
        索引[单位类型] = [];
      }
      索引[单位类型].push(配置);
    }
  }
  return 索引;
}

export function 构建按触发方式索引(
  this: void,
  配置列表: 单位技能配置[],
): Record<单位技能触发方式, 单位技能配置[]> {
  const 索引 = {} as Record<单位技能触发方式, 单位技能配置[]>;
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    const 触发方式 = 配置.触发方式;
    if (!索引[触发方式]) {
      索引[触发方式] = [];
    }
    索引[触发方式].push(配置);
  }
  return 索引;
}
