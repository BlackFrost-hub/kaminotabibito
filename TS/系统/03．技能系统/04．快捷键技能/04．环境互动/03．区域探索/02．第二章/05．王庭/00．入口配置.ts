/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const DzGetUnitNeededXP = japi.DzGetUnitNeededXP as (this: void, unit: any, level: number) => number;
const { 注册环境互动调查点 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心") as {
  注册环境互动调查点: (this: void, 调查点: any) => boolean;
};
const { 环境互动装备奖励概率 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.00．环境互动配置") as {
  环境互动装备奖励概率: number;
};
const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, 物品类型ID: number, X: number, Y: number) => any;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, 物品名: string) => string | undefined;
};
const { 发送单位提示给玩家 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  发送单位提示给玩家: (this: void, 目标玩家: any, 来源单位: any, 文本: string, 持续时间?: number) => void;
};

const GetUnitX = jass.GetUnitX as (this: void, 单位: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, 单位: any) => number;
const UnitAddItem = jass.UnitAddItem as (this: void, 单位: any, 物品: any) => boolean;

const 提示持续毫秒 = 5200;

function 增加资源(this: void, 玩家ID: number, 状态: number, 数量: number): void {
  const 玩家 = jass.Player(玩家ID);
  jass.SetPlayerState(玩家, 状态, jass.GetPlayerState(玩家, 状态) + 数量);
}

function 给予物品(this: void, 单位: any, 名称: string): boolean {
  const 配置ID = 按名字反查物品ID(名称);
  if (配置ID == null) return false;
  const 物品 = 创建物品并注册排泄监听(解析配置内部ID(配置ID), GetUnitX(单位), GetUnitY(单位));
  if (物品 == null || 物品 === 0) return false;
  return UnitAddItem(单位, 物品);
}

function 获得当前升级经验百分比(this: void, 单位: any, 比例: number): void {
  const level = jass.GetHeroLevel(单位) as number;
  const neededExp = DzGetUnitNeededXP(单位, level) as number;
  const value = jass.R2I(neededExp * 比例) as number;
  if (value > 0) jass.AddHeroXP(单位, value, true);
}

function 处理武备陈列长桌(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  if (!给予物品(施法单位, "王庭礼剑")) return false;
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(jass.Player(玩家ID), 施法单位, "|cffccffff『武备陈列长桌』：|r长桌上的礼器兵器保养得一丝不苟，其中一柄长剑的铭牌写着仿制品，剑格内侧的守夜人戳记却骗不了人——被调包的是赝品，真品一直立在原地。|n|cffffff00获得王庭礼剑、1能量碎片。|r", 提示持续毫秒);
  return true;
}

function 处理王庭库金(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_GOLD, 10000);
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(jass.Player(玩家ID), 施法单位, "|cffffcc99『王庭库金』：|r墙边封存的库金积着薄灰，封条完好，账册上却查不到这一笔——像是有人特意把它留在这里，等一个会数数的人。|n|cffffff00获得10000金币、1能量碎片。|r", 提示持续毫秒);
  return true;
}

function 处理仓促撤离的杂堆(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  if (!给予物品(施法单位, "月影花")) return false;
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_GOLD, 8000);
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(jass.Player(玩家ID), 施法单位, "|cffff6800『仓促撤离的杂堆』：|r翻检过的箱笼与文书散了一地，椅子倒着没人扶——来过的人翻得很仔细，走得很急，带不走的又原样丢了回来。|n|cffffff00获得8000金币、月影花、1能量碎片。|r", 提示持续毫秒);
  return true;
}

function 处理未寄出的信笺(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  获得当前升级经验百分比(施法单位, 0.15);
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(jass.Player(玩家ID), 施法单位, "|cffccffff『未寄出的信笺』：|r大桌上压着一叠信笺，火漆完整却从未封发，每一封的抬头都被裁去——写信的人不想让收信人被认出来。|n|cffffff00获得当前等级升级所需经验的15%、1能量碎片。|r", 提示持续毫秒);
  return true;
}

export function 注册王庭探索点(this: void): void {
  注册环境互动调查点({ ID: "王庭.武备陈列长桌", X: 21462.1, Y: -24415.7, 一次性: true, 一次性奖励概率: 环境互动装备奖励概率, 触发回调: 处理武备陈列长桌 });
  注册环境互动调查点({ ID: "王庭.王庭库金", X: 23207.0, Y: -24091.3, 一次性: true, 触发回调: 处理王庭库金 });
  注册环境互动调查点({ ID: "王庭.仓促撤离的杂堆", X: 23093.0, Y: -25204.5, 一次性: true, 触发回调: 处理仓促撤离的杂堆 });
  注册环境互动调查点({ ID: "王庭.未寄出的信笺", X: 22607.6, Y: -23836.5, 一次性: true, 触发回调: 处理未寄出的信笺 });
}

export {};
