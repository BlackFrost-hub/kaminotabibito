/** @noSelfInFile */

import type { 单位AI归类, 单位AI配置 } from "./01．AI配置类型";

export function 创建单位AI配置(this: void, 配置: 单位AI配置): 单位AI配置 {
  return 配置;
}

export function 按归类筛选单位AI配置(this: void, 配置列表: 单位AI配置[], 归类: 单位AI归类): 单位AI配置[] {
  const 结果: 单位AI配置[] = [];
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    if (配置.归类 === 归类) {
      结果.push(配置);
    }
  }
  return 结果;
}

export function 按单位名筛选单位AI配置(this: void, 配置列表: 单位AI配置[], 单位名: string): 单位AI配置[] {
  const 结果: 单位AI配置[] = [];
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    if (配置.单位名 === 单位名) {
      结果.push(配置);
    }
  }
  return 结果;
}

export function 按AI配置ID获取单位AI配置(this: void, 配置列表: 单位AI配置[], AI配置ID: string): 单位AI配置 | undefined {
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    if (配置.AI配置ID === AI配置ID) {
      return 配置;
    }
  }
  return undefined;
}

export function 按单位名获取单位AI配置(this: void, 配置列表: 单位AI配置[], 单位名: string): 单位AI配置 | undefined {
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    if (配置.单位名 === 单位名) {
      return 配置;
    }
  }
  return undefined;
}

export function 构建单位AI配置ID索引(this: void, 配置列表: 单位AI配置[]): Record<string, 单位AI配置> {
  const 索引: Record<string, 单位AI配置> = {};
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    索引[配置.AI配置ID] = 配置;
  }
  return 索引;
}

export function 构建单位名AI配置索引(this: void, 配置列表: 单位AI配置[]): Record<string, 单位AI配置[]> {
  const 索引: Record<string, 单位AI配置[]> = {};
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    if (!索引[配置.单位名]) {
      索引[配置.单位名] = [];
    }
    索引[配置.单位名].push(配置);
  }
  return 索引;
}
