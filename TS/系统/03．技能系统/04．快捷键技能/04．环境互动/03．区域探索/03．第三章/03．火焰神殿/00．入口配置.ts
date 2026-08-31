/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 注册环境互动调查点 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心") as {
  注册环境互动调查点: (this: void, 调查点: any) => boolean;
};
const { 环境互动装备奖励概率 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.00．环境互动配置") as {
  环境互动装备奖励概率: number;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, 物品类型ID: number, X: number, Y: number) => any;
};
const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
};
const { 是否已正式击败菲尼克斯尔 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.43．菲尼克斯尔现身") as {
  是否已正式击败菲尼克斯尔: (this: void) => boolean;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, 物品名: string) => string | undefined;
};
const { 发送单位提示给玩家 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  发送单位提示给玩家: (this: void, 目标玩家: any, 来源单位: any, 文本: string, 持续时间?: number) => void;
};

function 处理菲尼克斯尔战后晶核(this: void, 玩家ID: number, 英雄: any, _调查点: any): boolean {
  if (!是否已正式击败菲尼克斯尔()) return false;
  const 配置ID = 按名字反查物品ID("焚羽余烬晶核");
  if (配置ID == null) return false;
  const 物品 = 创建物品并注册排泄监听(解析配置内部ID(配置ID), jass.GetUnitX(英雄), jass.GetUnitY(英雄));
  if (物品 == null || 物品 === 0) return false;
  jass.UnitAddItem(英雄, 物品);
  发送单位提示给玩家(jass.Player(玩家ID), 英雄, "|cffff6800『焚羽余烬晶核』：|r凤凰消散后的晶体仍在冷热之间缓慢脉动，像是把最后的火焰与冰霜都压进了同一枚核心。|n|cffffff00获得装备：焚羽余烬晶核。|r", 5200);
  return true;
}

export function 注册火焰神殿探索点(this: void): void {
  注册环境互动调查点({
    ID: "火焰神殿.菲尼克斯尔战后晶核",
    X: 16243.2,
    Y: -3941.4,
    一次性: true,
    一次性奖励概率: 环境互动装备奖励概率,
    触发前置检查: () => 是否已正式击败菲尼克斯尔(),
    触发回调: 处理菲尼克斯尔战后晶核,
  });
}
