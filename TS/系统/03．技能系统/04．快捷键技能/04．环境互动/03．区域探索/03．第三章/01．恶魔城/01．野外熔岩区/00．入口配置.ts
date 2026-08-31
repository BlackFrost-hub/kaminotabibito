/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 注册环境互动调查点, 注销环境互动调查点 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心") as {
  注册环境互动调查点: (this: void, 调查点: any) => boolean;
  注销环境互动调查点: (this: void, 调查点ID: string) => boolean;
};
const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, 玩家: any, 单位类型ID: number, X: number, Y: number, 朝向: number) => any;
};
const { registerDeathListener, unregisterDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
  unregisterDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
};
const { 调整玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  调整玩家属性: (this: void, 单位: any, 属性名: string, 增量: number) => void;
};
const { 发送单位提示给玩家 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  发送单位提示给玩家: (this: void, 目标玩家: any, 来源单位: any, 文本: string, 持续时间?: number) => void;
};

const Player = jass.Player as (this: void, 玩家ID: number) => any;
const 中立敌对 = Player(jass.PLAYER_NEUTRAL_AGGRESSIVE);
const 熔核X = 22177.5;
const 熔核Y = -16520.8;
const 熔核遭遇ID = "恶魔城.未冷熔核";
const 熔核单位类型ID = 解析配置内部ID("n027");
const 提示持续毫秒 = 5200;
let 熔核遭遇单位: any = null;
let 熔核遭遇英雄: any = null;
let 熔核遭遇玩家ID = -1;

function 增加玩家资源(this: void, 玩家ID: number, 状态: number, 数量: number): void {
  const 玩家 = Player(玩家ID);
  jass.SetPlayerState(玩家, 状态, jass.GetPlayerState(玩家, 状态) + 数量);
}

function 处理未冷熔核死亡(this: void, 死亡单位: any, _击杀单位: any): void {
  if (死亡单位 !== 熔核遭遇单位) return;
  const 英雄 = 熔核遭遇英雄;
  const 玩家ID = 熔核遭遇玩家ID;
  熔核遭遇单位 = null;
  熔核遭遇英雄 = null;
  熔核遭遇玩家ID = -1;
  unregisterDeathListener(处理未冷熔核死亡);
  注销环境互动调查点(熔核遭遇ID);
  if (英雄 == null || 英雄 === 0 || 玩家ID < 0) return;
  调整玩家属性(英雄, "力量", 2);
  增加玩家资源(玩家ID, jass.PLAYER_STATE_RESOURCE_GOLD, 15000);
  增加玩家资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(Player(玩家ID), 英雄, "|cffff6800『未冷熔核』：|r熔岩元素的核心熄灭后，岩石内部的人为切痕显露出来。这里保存的并不是余热，而是一块被截取的熔核残片。|n|cffffff00获得永久力量+2、15000金币、1能量碎片。|r", 提示持续毫秒);
}

function 处理未冷熔核调查(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  if (熔核遭遇单位 != null || 熔核单位类型ID <= 0) return false;
  const 单位 = 创建单位并登记排泄安全(中立敌对, 熔核单位类型ID, 熔核X, 熔核Y, 270);
  if (单位 == null || 单位 === 0) return false;
  熔核遭遇单位 = 单位;
  熔核遭遇英雄 = 施法单位;
  熔核遭遇玩家ID = 玩家ID;
  registerDeathListener(处理未冷熔核死亡);
  发送单位提示给玩家(Player(玩家ID), 施法单位, "|cffff6800『未冷熔核』：|r你触碰了熔岩石，里面传出沉重的心跳声。凝固的裂缝突然被热光贯穿，一只熔岩元素从石中挣脱出来。|n|cffffff00击败它，才能取出熔核残片。|r", 提示持续毫秒);
  return false;
}

function 处理回流裂痕(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  调整玩家属性(施法单位, "生命恢复", 15);
  增加玩家资源(玩家ID, jass.PLAYER_STATE_RESOURCE_GOLD, 20000);
  发送单位提示给玩家(Player(玩家ID), 施法单位, "|cffff6800『回流裂痕』：|r熔岩的流向与地势完全相反，裂痕深处有一条被人为改造过的熔流通道，似乎通向更深的区域。|n|cffffff00获得永久生命恢复+15、20000金币。|r", 提示持续毫秒);
  return true;
}

export function 注册恶魔城野外熔岩探索点(this: void): void {
  注册环境互动调查点({ ID: "恶魔城.回流裂痕", X: 18528.5, Y: -14922.4, 一次性: true, 触发回调: 处理回流裂痕 });
  注册环境互动调查点({ ID: 熔核遭遇ID, X: 熔核X, Y: 熔核Y, 一次性: true, 触发回调: 处理未冷熔核调查 });
}

export {};
