/** @noSelfInFile */

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
const { 按名字反查玩家英雄单位ID, 玩家英雄配置表 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置") as {
  按名字反查玩家英雄单位ID: (this: void, name: string) => string | undefined;
  玩家英雄配置表: Record<string, Record<string, any>>;
};
const { 装备掉落表 } = require("系统.02．物品系统.02．装备掉落表") as {
  装备掉落表: Record<string, { id: string; name?: string }>;
};

const 额外单位名索引: Record<string, string> = {};

function 记录额外单位名(this: void, name: any, rawcode: string): void {
  if (typeof name !== "string" || name === "") return;
  if (额外单位名索引[name] == null) {
    额外单位名索引[name] = rawcode;
  }
}

function 初始化额外单位名索引(this: void): void {
  if (Object.keys(额外单位名索引).length > 0) return;

  const 玩家英雄Rawcode列表 = Object.keys(玩家英雄配置表);
  for (let i = 0; i < 玩家英雄Rawcode列表.length; i++) {
    const rawcode = 玩家英雄Rawcode列表[i];
    const 配置 = 玩家英雄配置表[rawcode];
    if (配置 == null) continue;
    记录额外单位名(配置.Name, rawcode);
    记录额外单位名(配置.Propernames, rawcode);
  }

  const 掉落表Rawcode列表 = Object.keys(装备掉落表);
  for (let i = 0; i < 掉落表Rawcode列表.length; i++) {
    const rawcode = 掉落表Rawcode列表[i];
    const 配置 = 装备掉落表[rawcode];
    if (配置 == null) continue;
    记录额外单位名(配置.name, rawcode);
  }
}

export function 按名字反查任意单位ID(this: void, name: string): string | undefined {
  初始化额外单位名索引();

  return 按名字反查杂鱼单位ID(name)
    ?? 按名字反查精英单位ID(name)
    ?? 按名字反查Boss单位ID(name)
    ?? 按名字反查异界Boss单位ID(name)
    ?? 按名字反查玩家英雄单位ID(name)
    ?? 额外单位名索引[name];
}
