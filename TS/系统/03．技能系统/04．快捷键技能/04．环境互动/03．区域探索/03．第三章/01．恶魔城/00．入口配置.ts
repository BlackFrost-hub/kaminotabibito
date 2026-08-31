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
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, 物品类型ID: number, X: number, Y: number) => any;
};
const { 创建召唤物 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口") as {
  创建召唤物: (this: void, 参数: any) => any;
};
const { registerDeathListener, unregisterDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
  unregisterDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
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

const GetUnitX = jass.GetUnitX as (this: void, 单位: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, 单位: any) => number;
const GetHeroStr = jass.GetHeroStr as (this: void, 英雄: any, 包含加成: boolean) => number;
const SetHeroStr = jass.SetHeroStr as (this: void, 英雄: any, 数值: number, 永久: boolean) => void;
const GetUnitState = jass.GetUnitState as (this: void, 单位: any, 状态: number) => number;
const SetUnitState = jass.SetUnitState as (this: void, 单位: any, 状态: number, 数值: number) => void;
const UnitAddItem = jass.UnitAddItem as (this: void, 单位: any, 物品: any) => boolean;
const SGSS_SetState = (require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, 单位: any, 属性ID: number, 数值: number) => void;
}).SGSS_SetState;

const 提示持续毫秒 = 5200;
const 蜘蛛点位X = 24222.4;
const 蜘蛛点位Y = -12127.9;
const 蜘蛛环境互动ID = "恶魔城.焚丝蛛痕";
const 蜘蛛模型路径 = "Unit\\Minion\\FireSpider\\CryptFiend.mdx";
const 蜘蛛单位名称 = "熔狱焚丝蛛";
const 蜘蛛基础生命值 = 6400;
const 蜘蛛攻击力 = 755;
const 蜘蛛攻击间隔 = 1.0;
const 蜘蛛护甲 = 10;
const 蜘蛛索敌范围 = 750;
const 蜘蛛缩放 = 0.85;
const 中立敌对 = jass.Player(jass.PLAYER_NEUTRAL_AGGRESSIVE);
let 蜘蛛遭遇单位: any = null;
let 蜘蛛遭遇英雄: any = null;
let 蜘蛛遭遇玩家ID = -1;

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

function 完全恢复生命与魔法(this: void, 单位: any): void {
  SetUnitState(单位, jass.UNIT_STATE_LIFE, GetUnitState(单位, jass.UNIT_STATE_MAX_LIFE));
  SetUnitState(单位, jass.UNIT_STATE_MANA, GetUnitState(单位, jass.UNIT_STATE_MAX_MANA));
}

function 处理锻造区货箱(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  if (!给予物品(施法单位, "恶魔锻火结晶")) return false;
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(jass.Player(玩家ID), 施法单位, "|cffff6800『锻造区货箱』：|r货箱里的成品早已被搬空，只剩未发运的锻材。装箱单上的收货方一栏被划去重写，最终收货的地址不是城中任何一家铁匠铺。|n|cffffff00获得恶魔锻火结晶、1能量碎片。|r", 提示持续毫秒);
  return true;
}

function 处理花园泉眼(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  调整玩家属性(施法单位, "生命恢复", 12);
  调整玩家属性(施法单位, "魔法恢复", 6);
  完全恢复生命与魔法(施法单位);
  发送单位提示给玩家(jass.Player(玩家ID), 施法单位, "|cff66ccff『花园泉眼』：|r环廊里的植物早已扭曲变形，唯独泉眼周围还留着一圈青草。泉水依旧清冽，只是水底沉着几片黑色的鳞状物，随水流轻轻摆动。|n|cffffff00生命恢复+12、魔法恢复+6，生命与魔法完全恢复。|r", 提示持续毫秒);
  return true;
}

function 处理骑士石像(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  SetHeroStr(施法单位, GetHeroStr(施法单位, false) + 2, true);
  发送单位提示给玩家(jass.Player(玩家ID), 施法单位, "|cffccffff『骑士石像』：|r石像的双手紧握一柄断剑，剑身缺口的位置与底座浮雕上城门破损的位置完全一致。底座刻文只余一句：城在人在。|n|cffffff00永久力量+2。|r", 提示持续毫秒);
  return true;
}

function 处理白石碑列(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  调整玩家属性(施法单位, "生命值", 200);
  SGSS_SetState(施法单位, 7, 200);
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(jass.Player(玩家ID), 施法单位, "|cffccffff『白石碑列』：|r碑列没有立者姓名，只有一行行小字记录着同一天死去的人。刻工起初工整，越往后越潦草，最后一碑只刻了一个未写完的名字。|n|cffffff00生命值+200，获得1能量碎片。|r", 提示持续毫秒);
  return true;
}

function 处理遗落货箱金堆(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  if (!给予物品(施法单位, "夜行教团坠饰")) return false;
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(jass.Player(玩家ID), 施法单位, "|cffff6800『遗落货箱金堆』：|r货箱没有上锁，金币散落在箱口，像是搬运的人中途被什么打断，再没有回来。箱底压着一条教团样式的坠饰。|n|cffffff00获得夜行教团坠饰、1能量碎片。|r", 提示持续毫秒);
  return true;
}

function 处理焚丝蛛死亡(this: void, 死亡单位: any, _击杀单位: any): void {
  if (死亡单位 !== 蜘蛛遭遇单位) return;
  const 英雄 = 蜘蛛遭遇英雄;
  const 玩家ID = 蜘蛛遭遇玩家ID;
  蜘蛛遭遇单位 = null;
  蜘蛛遭遇英雄 = null;
  蜘蛛遭遇玩家ID = -1;
  unregisterDeathListener(处理焚丝蛛死亡);
  注销环境互动调查点(蜘蛛环境互动ID);
  if (英雄 == null || 英雄 === 0 || 玩家ID < 0) return;
  调整玩家属性(英雄, "魔法恢复", 10);
  增加资源(玩家ID, jass.PLAYER_STATE_RESOURCE_GOLD, 20000);
  发送单位提示给玩家(jass.Player(玩家ID), 英雄, "|cffff6800『焚丝蛛痕』：|r熔狱焚丝蛛倒下，缠在岩缝里的赤黑蛛丝逐渐失去光泽。蛛丝深处残留着一股持续牵引魔力的热流。|n|cffffff00获得永久魔法恢复+10、20000金币。|r", 提示持续毫秒);
}

function 处理焚丝蛛痕(this: void, _玩家ID: number, 施法单位: any, _调查点: any): boolean {
  if (蜘蛛遭遇单位 != null) return false;
  const 蜘蛛 = 创建召唤物({
    所属玩家: 中立敌对,
    单位类型: "e08P",
    单位名称: 蜘蛛单位名称,
    模型文件: 蜘蛛模型路径,
    X: 蜘蛛点位X,
    Y: 蜘蛛点位Y,
    朝向: 180,
    飞行高度: 0,
    生命值: 蜘蛛基础生命值,
    生命值受小怪倍率: false,
    生命值受难度倍率: true,
    攻击力: 蜘蛛攻击力,
    攻击间隔: 蜘蛛攻击间隔,
    护甲: 蜘蛛护甲,
    索敌范围: 蜘蛛索敌范围,
    缩放: 蜘蛛缩放,
  });
  if (蜘蛛 == null || 蜘蛛 === 0) return false;
  蜘蛛遭遇单位 = 蜘蛛;
  蜘蛛遭遇英雄 = 施法单位;
  蜘蛛遭遇玩家ID = jass.GetPlayerId(jass.GetOwningPlayer(施法单位));
  registerDeathListener(处理焚丝蛛死亡);
  发送单位提示给玩家(jass.Player(蜘蛛遭遇玩家ID), 施法单位, "|cffff6800『焚丝蛛痕』：|r蛛网深处传来甲壳刮过熔岩的声响，一只熔狱焚丝蛛从裂缝中爬出。击败它，才能看清这片蛛丝隐藏的痕迹。|r", 提示持续毫秒);
  return false;
}

export function 注册恶魔城探索点(this: void): void {
  注册环境互动调查点({ ID: "恶魔城.锻造区货箱", X: 14000.2, Y: -18593.3, 一次性: true, 触发回调: 处理锻造区货箱 });
  注册环境互动调查点({ ID: "恶魔城.花园泉眼", X: 15643.2, Y: -16256.1, 一次性: true, 触发回调: 处理花园泉眼 });
  注册环境互动调查点({ ID: "恶魔城.骑士石像", X: 14602.7, Y: -16744.0, 一次性: true, 触发回调: 处理骑士石像 });
  注册环境互动调查点({ ID: "恶魔城.白石碑列", X: 13804.9, Y: -15086.5, 一次性: true, 触发回调: 处理白石碑列 });
  注册环境互动调查点({ ID: "恶魔城.遗落货箱金堆", X: 16413.4, Y: -14487.5, 一次性: true, 一次性奖励概率: 环境互动装备奖励概率, 触发回调: 处理遗落货箱金堆 });
  注册环境互动调查点({ ID: 蜘蛛环境互动ID, X: 蜘蛛点位X, Y: 蜘蛛点位Y, 一次性: true, 触发回调: 处理焚丝蛛痕 });
}

export {};
