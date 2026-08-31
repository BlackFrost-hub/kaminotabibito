/** @noSelfInFile */

const jass = require("jass.common") as any;
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
const { 调整玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  调整玩家属性: (this: void, 单位: any, 属性名: string, 增量: number) => void;
};
const { 发送单位提示给玩家 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  发送单位提示给玩家: (this: void, 目标玩家: any, 来源单位: any, 文本: string, 持续时间?: number) => void;
};

const GetUnitState = jass.GetUnitState as (this: void, 单位: any, 状态: number) => number;
const SetUnitState = jass.SetUnitState as (this: void, 单位: any, 状态: number, 数值: number) => void;
const GetHeroAgi = jass.GetHeroAgi as (this: void, 英雄: any, 包含加成: boolean) => number;
const SetHeroAgi = jass.SetHeroAgi as (this: void, 英雄: any, 数值: number, 永久: boolean) => void;
const GetHeroInt = jass.GetHeroInt as (this: void, 英雄: any, 包含加成: boolean) => number;
const SetHeroInt = jass.SetHeroInt as (this: void, 英雄: any, 数值: number, 永久: boolean) => void;
const UnitAddItem = jass.UnitAddItem as (this: void, 单位: any, 物品: any) => boolean;
const SGSS_SetState = (require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, 单位: any, 属性ID: number, 数值: number) => void;
}).SGSS_SetState;

const 提示持续毫秒 = 5200;

function 增加资源(this: void, 玩家ID: number, 状态: number, 数量: number): void {
  const 玩家 = jass.Player(玩家ID);
  jass.SetPlayerState(玩家, 状态, jass.GetPlayerState(玩家, 状态) + 数量);
}

function 给予物品(this: void, 单位: any, 名称: string): boolean {
  const 配置ID = 按名字反查物品ID(名称);
  if (配置ID == null) return false;
  const 物品 = 创建物品并注册排泄监听(解析配置内部ID(配置ID), jass.GetUnitX(单位), jass.GetUnitY(单位));
  if (物品 == null || 物品 === 0) return false;
  return UnitAddItem(单位, 物品);
}

function 完全恢复生命与魔法(this: void, 单位: any): void {
  SetUnitState(单位, jass.UNIT_STATE_LIFE, GetUnitState(单位, jass.UNIT_STATE_MAX_LIFE));
  SetUnitState(单位, jass.UNIT_STATE_MANA, GetUnitState(单位, jass.UNIT_STATE_MAX_MANA));
}

function 处理绿晶双碑(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  SetHeroAgi(施法单位, GetHeroAgi(施法单位, false) + 2, true);
  发送单位提示给玩家(jass.Player(玩家ID), 施法单位, "|cffccffff『绿晶双碑』：|r甬道两侧的绿晶方碑刻满细密的划痕，指岔道的符号被凿去又重刻，最新一层的刻痕还带着石粉。守夜人更新界碑的习惯，比任何一张地图都诚实。|n|cffffff00永久敏捷+2。|r", 提示持续毫秒);
  return true;
}

function 处理测绘营地遗堆(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  if (!给予物品(施法单位, "恶魔结晶")) return false;
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_GOLD, 8000);
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(jass.Player(玩家ID), 施法单位, "|cffff6800『测绘营地遗堆』：|r篝火的灰烬早已冷透，帐篷桩却还立着。宝箱上锁完好，压在箱底的测绘图稿画到一半就断了笔——比测绘师这一批人更早的探路者，也没能走出迷宫。|n|cffffff00获得8000金币、恶魔结晶、1能量碎片。|r", 提示持续毫秒);
  return true;
}

function 处理断流石井(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  if (!给予物品(施法单位, "深井活水囊")) return false;
  完全恢复生命与魔法(施法单位);
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(jass.Player(玩家ID), 施法单位, "|cff66ccff『断流石井』：|r石井早已断流，井口的凹槽被绳子磨出深痕。贴近井口还能听见深处有活水在流，井沿挂着一只守夜人留下的水囊，囊中的水仍在轻轻晃动。|n|cffffff00生命与魔法完全恢复，获得深井活水囊、1能量碎片。|r", 提示持续毫秒);
  return true;
}

function 处理血路祭标(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  调整玩家属性(施法单位, "生命值", 150);
  SGSS_SetState(施法单位, 7, 150);
  发送单位提示给玩家(jass.Player(玩家ID), 施法单位, "|cffff6800『血路祭标』：|r祭坛的血槽里残渍未干，一路向迷宫深处延伸。敌对势力把拖运的路线做成了祭祀的路标——被拆走的引路灯照亮的，从来不是旅客的路。|n|cffffff00永久生命值+150。|r", 提示持续毫秒);
  return true;
}

function 处理封存的宝藏(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  if (!给予物品(施法单位, "熔渊坠饰合成书")) return false;
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(jass.Player(玩家ID), 施法单位, "|cffff6800『封存的宝藏』：|r宝藏堆的封漆上盖着教团印记，撬开箱盖，最上面躺着一本用魔血写就的重铸手记——教团把自己的重铸法也封进了宝藏。|n|cffffff00获得熔渊坠饰合成书、1能量碎片。|r", 提示持续毫秒);
  return true;
}

function 处理向导石像列(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  SetHeroInt(施法单位, GetHeroInt(施法单位, false) + 2, true);
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(jass.Player(玩家ID), 施法单位, "|cffccffff『向导石像列』：|r石像列的每一尊都捧着一颗圣球，唯独其中一尊的圣球颜色更新、接缝粗糙，是后来才补上的。守夜人的序列在某一代断了档，补球的人手艺并不高明。|n|cffffff00永久智力+2，获得1能量碎片。|r", 提示持续毫秒);
  return true;
}

export function 注册恶魔迷宫探索点(this: void): void {
  注册环境互动调查点({ ID: "恶魔迷宫.绿晶双碑", X: 29216.4, Y: -8519.3, 一次性: true, 触发回调: 处理绿晶双碑 });
  注册环境互动调查点({ ID: "恶魔迷宫.测绘营地遗堆", X: 26698.3, Y: -10766.2, 一次性: true, 触发回调: 处理测绘营地遗堆 });
  注册环境互动调查点({ ID: "恶魔迷宫.断流石井", X: 24544.3, Y: -3520.7, 一次性: true, 一次性奖励概率: 环境互动装备奖励概率, 触发回调: 处理断流石井 });
  注册环境互动调查点({ ID: "恶魔迷宫.血路祭标", X: 27139.4, Y: -12154.9, 一次性: true, 触发回调: 处理血路祭标 });
  注册环境互动调查点({ ID: "恶魔迷宫.向导石像列", X: 26353.5, Y: -13607.7, 一次性: true, 触发回调: 处理向导石像列 });
  注册环境互动调查点({ ID: "恶魔迷宫.封存的宝藏", X: 14723.4, Y: -27824.7, 一次性: true, 触发回调: 处理封存的宝藏 });
}

export {};
