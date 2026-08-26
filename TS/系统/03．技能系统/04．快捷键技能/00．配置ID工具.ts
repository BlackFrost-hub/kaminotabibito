/** @noSelfInFile */

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};

const 配置ID缓存: Record<string, number | undefined> = {};

/** 读取“名称#四位内部ID”；没有名称时也兼容直接传入四位 Rawcode。 */
export function 解析配置内部ID(this: void, 配置值: string | undefined | null): number {
  if (配置值 == null || 配置值 === "") return 0;

  const 已缓存 = 配置ID缓存[配置值];
  if (已缓存 != null) return 已缓存;

  const 分隔位置 = 配置值.indexOf("#");
  const 原始ID = 分隔位置 > 0 ? 配置值.substring(分隔位置 + 1).trim() : 配置值.trim();
  if (原始ID.length !== 4) {
    配置ID缓存[配置值] = 0;
    return 0;
  }

  const 类型ID = stringToFourCCSafe(原始ID);
  配置ID缓存[配置值] = 类型ID;
  return 类型ID;
}

export function 解析配置内部ID列表(this: void, 配置列表: readonly (string | undefined | null)[]): number[] {
  const 结果: number[] = [];
  for (let i = 0; i < 配置列表.length; i++) {
    const 类型ID = 解析配置内部ID(配置列表[i]);
    if (类型ID > 0) 结果.push(类型ID);
  }
  return 结果;
}

export {};
