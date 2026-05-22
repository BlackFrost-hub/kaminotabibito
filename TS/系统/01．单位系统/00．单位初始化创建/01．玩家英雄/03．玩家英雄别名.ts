/** @noSelfInFile */

const { 按名字反查玩家英雄单位ID, 玩家英雄配置表 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置") as {
  按名字反查玩家英雄单位ID: (this: void, name: string) => string | undefined;
  玩家英雄配置表: Record<string, Record<string, any>>;
};
const { 获取单位英雄Rawcode } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具") as {
  获取单位英雄Rawcode: (this: void, unit: any) => string;
};

export interface 玩家英雄别名配置 {
  配置名: string;
  别名列表: readonly string[];
}

export const 玩家英雄别名配置列表: readonly 玩家英雄别名配置[] = [
  { 配置名: "女仆", 别名列表: ["十六夜咲夜"] },
  { 配置名: "永远17岁的少女", 别名列表: ["八云紫"] },
  { 配置名: "月兔", 别名列表: ["铃仙"] },
] as const;

const 英雄Rawcode到别名列表: Record<string, string[]> = (() => {
  const map: Record<string, string[]> = {};
  for (let i = 0; i < 玩家英雄别名配置列表.length; i++) {
    const config = 玩家英雄别名配置列表[i];
    const rawcode = 按名字反查玩家英雄单位ID(config.配置名);
    if (rawcode == null || rawcode === "") continue;
    if (map[rawcode] == null) map[rawcode] = [];
    for (let j = 0; j < config.别名列表.length; j++) {
      map[rawcode].push(config.别名列表[j]);
    }
  }
  return map;
})();

export function 获取玩家英雄别名列表(this: void, heroRawcode: string): readonly string[] {
  if (heroRawcode == null || heroRawcode === "") return [];
  return 英雄Rawcode到别名列表[heroRawcode] ?? [];
}

export function 获取单位玩家英雄全部名称(this: void, unit: any): string[] {
  const heroRawcode = 获取单位英雄Rawcode(unit);
  if (heroRawcode == null || heroRawcode === "") return [];
  const config = 玩家英雄配置表[heroRawcode];
  if (config == null) return [];

  const result: string[] = [];
  const name = String(config.Name ?? "").trim();
  const propernames = String(config.Propernames ?? "").trim();
  if (name !== "") result.push(name);
  if (propernames !== "") result.push(propernames);

  const aliases = 获取玩家英雄别名列表(heroRawcode);
  for (let i = 0; i < aliases.length; i++) {
    const alias = aliases[i];
    if (alias !== "") result.push(alias);
  }

  return result;
}

export function 单位是否匹配玩家英雄名称(this: void, unit: any, name: string): boolean {
  if (name == null || name === "") return false;
  const names = 获取单位玩家英雄全部名称(unit);
  for (let i = 0; i < names.length; i++) {
    if (names[i] === name) return true;
  }
  return false;
}

