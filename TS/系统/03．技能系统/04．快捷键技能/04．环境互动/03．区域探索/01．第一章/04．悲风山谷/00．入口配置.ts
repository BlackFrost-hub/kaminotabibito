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
const 提示持续毫秒 = 5200;
const 风痕遭遇单位类型ID = 解析配置内部ID("n041");
const 风痕X = 4693.2;
const 风痕Y = -27261.8;
const 风痕调查点ID = "悲风山谷.无声风痕";
let 风痕遭遇单位: any = null;
let 风痕遭遇英雄: any = null;
let 风痕遭遇玩家ID = -1;

function 增加玩家资源(this: void, 玩家ID: number, 状态: number, 数量: number): void {
  const 玩家 = Player(玩家ID);
  jass.SetPlayerState(玩家, 状态, jass.GetPlayerState(玩家, 状态) + 数量);
}

function 处理无声风痕死亡(this: void, 死亡单位: any, _击杀单位: any): void {
  if (死亡单位 !== 风痕遭遇单位) return;
  const 英雄 = 风痕遭遇英雄;
  const 玩家ID = 风痕遭遇玩家ID;
  风痕遭遇单位 = null;
  风痕遭遇英雄 = null;
  风痕遭遇玩家ID = -1;
  unregisterDeathListener(处理无声风痕死亡);
  注销环境互动调查点(风痕调查点ID);
  if (英雄 == null || 英雄 === 0 || 玩家ID < 0) return;
  调整玩家属性(英雄, "魔法恢复", 10);
  增加玩家资源(玩家ID, jass.PLAYER_STATE_RESOURCE_GOLD, 15000);
  发送单位提示给玩家(Player(玩家ID), 英雄, "|cffcc99ff『无声风痕』：|r风痕中的亡灵已经消散，石面下残留的风祭力量回到了你的魔力循环。|n|cffffff00获得永久魔法恢复+10、15000金币。|r", 提示持续毫秒);
}

function 处理无声风痕调查(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  if (风痕遭遇单位 != null || 风痕遭遇单位类型ID <= 0) return false;
  const 单位 = 创建单位并登记排泄安全(中立敌对, 风痕遭遇单位类型ID, 风痕X, 风痕Y, 180);
  if (单位 == null || 单位 === 0) return false;
  风痕遭遇单位 = 单位;
  风痕遭遇英雄 = 施法单位;
  风痕遭遇玩家ID = 玩家ID;
  registerDeathListener(处理无声风痕死亡);
  发送单位提示给玩家(Player(玩家ID), 施法单位, "|cffcc99ff『无声风痕』：|r弧痕之间的风突然停了，沙下传来骨甲摩擦石面的声音。一个被风祭束缚的亡灵从痕迹深处醒来。|n|cffffff00击败它，才能平息这里的异动。|r", 提示持续毫秒);
  return false;
}

function 处理风葬石堆(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  调整玩家属性(施法单位, "生命恢复", 10);
  增加玩家资源(玩家ID, jass.PLAYER_STATE_RESOURCE_GOLD, 10000);
  发送单位提示给玩家(Player(玩家ID), 施法单位, "|cffcc99ff『风葬石堆』：|r石缝里露出一支被砂砾磨平的骨笛，笛身刻痕始终指向谷地深处。这里曾有人在风暴中留下求救标记。|n|cffffff00获得永久生命恢复+10、10000金币。|r", 提示持续毫秒);
  return true;
}

function 处理蛇人旧门守像(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  调整玩家属性(施法单位, "护甲", 2);
  增加玩家资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(Player(玩家ID), 施法单位, "|cffcc99ff『蛇人旧门守像』：|r雕像底座的鳞纹被凿去一角，残留刻痕显示它并非迎宾标志，而是旧时代封门时留下的守门记号。|n|cffffff00获得永久护甲+2、1能量碎片。|r", 提示持续毫秒);
  return true;
}

export function 注册悲风山谷探索点(this: void): void {
  注册环境互动调查点({ ID: "悲风山谷.风葬石堆", X: 3645.7, Y: -25024.8, 一次性: true, 触发回调: 处理风葬石堆 });
  注册环境互动调查点({ ID: 风痕调查点ID, X: 风痕X, Y: 风痕Y, 一次性: true, 触发回调: 处理无声风痕调查 });
  注册环境互动调查点({ ID: "蛇人领地.旧门守像", X: -60.5, Y: -22754.1, 一次性: true, 触发回调: 处理蛇人旧门守像 });
}

export {};
