/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 注册环境互动调查点 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心") as {
  注册环境互动调查点: (this: void, 调查点: any) => boolean;
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

function 处理圣钥祭坛(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  if (!给予物品(施法单位, "守誓圣铠合成书")) return false;
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(jass.Player(玩家ID), 施法单位, "|cffccffff『圣钥祭坛』：|r祭坛的石匣被圣水浸了不知多少年，匣中的锻造图谱却字迹如新——守誓者把铠甲的锻法留在了钥匙的诞生地，等一双还愿意守誓的手。|n|cffffff00获得守誓圣铠合成书、1能量碎片。|r", 提示持续毫秒);
  return true;
}

export function 注册钥匙圣地探索点(this: void): void {
  注册环境互动调查点({ ID: "钥匙圣地.圣钥祭坛", X: 26100.5, Y: -14312.2, 一次性: true, 触发回调: 处理圣钥祭坛 });
}

export {};
