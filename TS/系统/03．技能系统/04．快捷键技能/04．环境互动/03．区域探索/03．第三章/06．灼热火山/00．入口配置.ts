/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 注册环境互动调查点, 注销环境互动调查点 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心") as {
  注册环境互动调查点: (this: void, 调查点: any) => boolean;
  注销环境互动调查点: (this: void, 调查点ID: string) => boolean;
};
const { 环境互动装备奖励概率 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.00．环境互动配置") as {
  环境互动装备奖励概率: number;
};
const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, 玩家: any, 单位类型ID: number, X: number, Y: number, 朝向: number) => any;
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
const { registerDeathListener, unregisterDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
  unregisterDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
};
const { 发送单位提示给玩家 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  发送单位提示给玩家: (this: void, 目标玩家: any, 来源单位: any, 文本: string, 持续时间?: number) => void;
};

const Player = jass.Player as (this: void, 玩家ID: number) => any;
const GetUnitX = jass.GetUnitX as (this: void, 单位: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, 单位: any) => number;
const GetHeroAgi = jass.GetHeroAgi as (this: void, 英雄: any, 包含加成: boolean) => number;
const SetHeroAgi = jass.SetHeroAgi as (this: void, 英雄: any, 数值: number, 永久: boolean) => void;
const GetUnitState = jass.GetUnitState as (this: void, 单位: any, 状态: number) => number;
const SetUnitState = jass.SetUnitState as (this: void, 单位: any, 状态: number, 数值: number) => void;
const UnitAddItem = jass.UnitAddItem as (this: void, 单位: any, 物品: any) => boolean;
const SGSS_SetState = (require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, 单位: any, 属性ID: number, 数值: number) => void;
}).SGSS_SetState;

const 中立敌对 = Player(jass.PLAYER_NEUTRAL_AGGRESSIVE as number);
const 提示持续毫秒 = 5200;
const 蛛巢X = 12346.5;
const 蛛巢Y = -26893.9;
const 蛛巢遭遇ID = "灼热火山.焦化蛛巢";
const 蛛巢单位类型ID = 解析配置内部ID("n00Z");
let 蛛巢遭遇单位: any = null;
let 蛛巢遭遇英雄: any = null;
let 蛛巢遭遇玩家ID = -1;

function 增加资源(this: void, 玩家ID: number, 状态: number, 数量: number): void {
  const 玩家 = Player(玩家ID);
  jass.SetPlayerState(玩家, 状态, jass.GetPlayerState(玩家, 状态) + 数量);
}

function 给予物品(this: void, 单位: any, 名称: string): boolean {
  const 配置ID = 按名字反查物品ID(名称);
  if (配置ID == null) return false;
  const 物品 = 创建物品并注册排泄监听(解析配置内部ID(配置ID), GetUnitX(单位), GetUnitY(单位));
  if (物品 == null || 物品 === 0) return false;
  return UnitAddItem(单位, 物品);
}

function 处理焦化蛛巢击杀(this: void): void {
  if (蛛巢遭遇英雄 == null || 蛛巢遭遇玩家ID < 0) return;
  const 玩家ID = 蛛巢遭遇玩家ID;
  const 英雄 = 蛛巢遭遇英雄;
  蛛巢遭遇单位 = null;
  蛛巢遭遇英雄 = null;
  蛛巢遭遇玩家ID = -1;
  unregisterDeathListener(处理灼热火山单位死亡);
  注销环境互动调查点(蛛巢遭遇ID);
  SetHeroAgi(英雄, GetHeroAgi(英雄, false) + 2, true);
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_GOLD, 20000);
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  给予物品(英雄, "熔岩宝石");
  发送单位提示给玩家(Player(玩家ID), 英雄, "|cffff6800『焦化蛛巢』：|r火焰狼蛛倒下后，焦黑的蛛丝中凝出了一枚熔岩宝石。|n|cffffff00获得熔岩宝石、敏捷+2、20000金币、1能量碎片。|r", 提示持续毫秒);
}

function 处理灼热火山单位死亡(this: void, 死亡单位: any, _击杀单位: any): void {
  if (死亡单位 !== 蛛巢遭遇单位) return;
  处理焦化蛛巢击杀();
}

function 处理火山心脉(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  调整玩家属性(施法单位, "生命恢复", 20);
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(Player(玩家ID), 施法单位, "|cffff6800『火山心脉余烬』：|r火山口的熔壳向内部塌陷，地下热流被持续牵引。余烬融入血脉，你的生命恢复得到永久提升。|n|cffffff00生命恢复+20，获得1能量碎片。|r", 提示持续毫秒);
  return true;
}

function 处理焦化蛛巢(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  if (蛛巢遭遇单位 != null) return false;
  蛛巢遭遇英雄 = 施法单位;
  蛛巢遭遇玩家ID = 玩家ID;
  蛛巢遭遇单位 = 创建单位并登记排泄安全(中立敌对, 蛛巢单位类型ID, 蛛巢X + 220, 蛛巢Y, 180);
  if (蛛巢遭遇单位 == null || 蛛巢遭遇单位 === 0) {
    蛛巢遭遇英雄 = null;
    蛛巢遭遇玩家ID = -1;
    return false;
  }
  registerDeathListener(处理灼热火山单位死亡);
  发送单位提示给玩家(Player(玩家ID), 施法单位, "|cffff6800『焦化蛛巢』：|r你触动了岩壁上的蛛网，巢穴深处传来尖锐的摩擦声。火焰狼蛛已经醒来，击败它才能取出收获。|r", 提示持续毫秒);
  return false;
}

function 处理熔流古道(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  if (!给予物品(施法单位, "余烬寻路灯")) return false;
  SGSS_SetState(施法单位, 7, 300);
  调整玩家属性(施法单位, "生命值", 300);
  发送单位提示给玩家(Player(玩家ID), 施法单位, "|cffff6800『熔流古道压痕』：|r凝固石道上的拖痕指向熔岩小镇，冷却矿渣中还留着一盏余烬寻路灯。|n|cffffff00生命值+300，获得余烬寻路灯。|r", 提示持续毫秒);
  return true;
}

function 处理逆焰冷泉(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  调整玩家属性(施法单位, "魔法恢复", 12);
  SGSS_SetState(施法单位, 8, 200);
  调整玩家属性(施法单位, "魔法值", 200);
  SetUnitState(施法单位, jass.UNIT_STATE_LIFE, GetUnitState(施法单位, jass.UNIT_STATE_MAX_LIFE));
  SetUnitState(施法单位, jass.UNIT_STATE_MANA, GetUnitState(施法单位, jass.UNIT_STATE_MAX_MANA));
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(Player(玩家ID), 施法单位, "|cff66ccff『逆焰冷泉』：|r冷泉下的旧石渠仍在抽走山腹热量，泉水的力量融入你的魔力循环。|n|cffffff00魔法恢复+12、魔法值+200、生命与魔法完全恢复，获得1能量碎片。|r", 提示持续毫秒);
  return true;
}

export function 注册灼热火山探索点(this: void): void {
  注册环境互动调查点({ ID: "灼热火山.火山心脉余烬", X: 8026.8, Y: -27365.7, 一次性: true, 触发回调: 处理火山心脉 });
  注册环境互动调查点({ ID: 蛛巢遭遇ID, X: 蛛巢X, Y: 蛛巢Y, 一次性: true, 触发回调: 处理焦化蛛巢 });
  注册环境互动调查点({ ID: "灼热火山.熔流古道压痕", X: 8715.6, Y: -24386.6, 一次性: true, 一次性奖励概率: 环境互动装备奖励概率, 触发回调: 处理熔流古道 });
  注册环境互动调查点({ ID: "熔岩小镇.逆焰冷泉", X: 7985.2, Y: -22435.5, 一次性: true, 触发回调: 处理逆焰冷泉 });
}

export {};
