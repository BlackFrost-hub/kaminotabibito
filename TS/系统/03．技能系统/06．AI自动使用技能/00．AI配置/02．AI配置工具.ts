/** @noSelfInFile */

import type {
  AI技能运行时可用条件,
  AI运行时状态,
  AI运行时状态读取器,
  单位AI归类,
  单位AI配置,
} from "./01．AI配置类型";

const { 按名字反查杂鱼单位ID } = require("系统.01．单位系统.08．单位配置表.00．杂鱼配置表") as {
  按名字反查杂鱼单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查精英单位ID } = require("系统.01．单位系统.08．单位配置表.01．精英配置表") as {
  按名字反查精英单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查Boss单位ID } = require("系统.01．单位系统.08．单位配置表.02．Boss配置表") as {
  按名字反查Boss单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查异界Boss单位ID } = require("系统.01．单位系统.08．单位配置表.03．异界Boss配置表") as {
  按名字反查异界Boss单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查玩家英雄单位ID } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置") as {
  按名字反查玩家英雄单位ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

export function 创建单位AI配置(this: void, 配置: 单位AI配置): 单位AI配置 {
  return 配置;
}

export function 创建AI状态白名单条件(
  this: void,
  读取状态: AI运行时状态读取器,
  允许状态列表: AI运行时状态[]
): AI技能运行时可用条件 {
  return function AI状态白名单条件(this: void, unit: any): boolean {
    const 当前状态 = 读取状态(unit);
    if (当前状态 == null) return false;
    for (let i = 0; i < 允许状态列表.length; i++) {
      if (允许状态列表[i] === 当前状态) return true;
    }
    return false;
  };
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

function 按归类反查单位ID(this: void, 归类: 单位AI归类, 单位名: string): string | undefined {
  if (归类 === "杂鱼") return 按名字反查杂鱼单位ID(单位名);
  if (归类 === "精英") return 按名字反查精英单位ID(单位名);
  if (归类 === "Boss") return 按名字反查Boss单位ID(单位名);
  if (归类 === "英雄Boss") {
    return 按名字反查Boss单位ID(单位名)
      ?? 按名字反查玩家英雄单位ID(单位名);
  }
  if (归类 === "异界Boss") return 按名字反查异界Boss单位ID(单位名);
  return undefined;
}

export function 解析单位AI配置单位ID(this: void, 配置: 单位AI配置): string | undefined {
  if (配置.单位ID != null && 配置.单位ID !== "") {
    return 配置.单位ID;
  }
  return 按归类反查单位ID(配置.归类, 配置.单位名);
}

export function 解析单位AI配置单位类型ID(this: void, 配置: 单位AI配置): number {
  return stringToFourCCSafe(解析单位AI配置单位ID(配置));
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

export function 按单位ID筛选单位AI配置(this: void, 配置列表: 单位AI配置[], 单位ID: string): 单位AI配置[] {
  const 结果: 单位AI配置[] = [];
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    if (解析单位AI配置单位ID(配置) === 单位ID) {
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

export function 按单位ID获取单位AI配置(this: void, 配置列表: 单位AI配置[], 单位ID: string): 单位AI配置 | undefined {
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    if (解析单位AI配置单位ID(配置) === 单位ID) {
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

export function 构建单位IDAI配置索引(this: void, 配置列表: 单位AI配置[]): Record<string, 单位AI配置[]> {
  const 索引: Record<string, 单位AI配置[]> = {};
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    const 单位ID = 解析单位AI配置单位ID(配置);
    if (单位ID == null || 单位ID === "") continue;
    if (!索引[单位ID]) {
      索引[单位ID] = [];
    }
    索引[单位ID].push(配置);
  }
  return 索引;
}
