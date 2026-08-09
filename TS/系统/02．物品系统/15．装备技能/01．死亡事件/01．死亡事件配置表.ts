/** @noSelfInFile */

const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (this: void, s: string | undefined | null) => number;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};

import type { 已解析击杀叠层配置, 已解析死亡事件配置, 死亡事件配置 } from "./00．类型定义";

const 原始死亡事件配置: 死亡事件配置 = {
  尸体召唤: {
    装备名: "小颅盾（唯一）",
    搜索半径: 500,
    召唤单位类型: "u000",
    限时生命Buff: "BHwe",
    持续时间: 5.0,
    特效路径: "Abilities\\Spells\\Demon\\DarkConversion\\ZombifyTarget.mdl",
    特效持续时间: 1.0,
    额外生命值: 300,
    生命值系数: 0.25,
    额外攻击力: 25,
    攻击力状态: 0x15,
    攻击力系数: 0.4,
  },
  击杀叠层列表: [
    { 装备名: "斯尔能量之心", 每次增加层数: 2, 最大层数: 100 },
  ],
};

let 缓存配置: 已解析死亡事件配置 | undefined;

function 解析装备名到ID(装备名: string | undefined): string | undefined {
  if (装备名 == null || 装备名 === "") return undefined;
  return 按名字反查物品ID(装备名);
}

function 解析击杀叠层配置(): 已解析击杀叠层配置[] {
  const 结果: 已解析击杀叠层配置[] = [];
  for (const 配置 of 原始死亡事件配置.击杀叠层列表) {
    结果.push({
      ...配置,
      装备ID: 解析装备名到ID(配置.装备名),
      满层升级到装备ID: 解析装备名到ID(配置.满层升级到装备名),
    });
  }
  return 结果;
}

export function 获取死亡事件配置(this: void): 已解析死亡事件配置 {
  if (缓存配置 != null) return 缓存配置;

  缓存配置 = {
    尸体召唤: {
      ...原始死亡事件配置.尸体召唤,
      装备ID: 解析装备名到ID(原始死亡事件配置.尸体召唤.装备名),
    },
    击杀叠层列表: 解析击杀叠层配置(),
  };
  return 缓存配置;
}

export function 取物品四字码(this: void, 物品ID: string | undefined): number {
  return stringToFourCC(物品ID);
}
