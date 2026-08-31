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
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, 表名: string, 键: any, 属性名: string, 类型: string) => any;
  YDUserDataSetSafe: (this: void, 表名: string, 键: any, 属性名: string, 类型: string, 值: any) => void;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};

const GetUnitX = jass.GetUnitX as (this: void, 单位: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, 单位: any) => number;
const UnitAddItem = jass.UnitAddItem as (this: void, 单位: any, 物品: any) => boolean;

const 果子物品ID = "伊达之果#I03W";
const 精灵小屋提示文本 = "意外发现了某处能进入的精灵小屋，命中率+1%。";
const 空木桩提示文本 = "意外发现了藏在空木桩里的果子。";
const 树上物品提示文本 = "意外发现了藏在树上的果子。";

function 创建并给予物品(this: void, 施法单位: any, 物品ID: string): void {
  const 物品 = 创建物品并注册排泄监听(解析配置内部ID(物品ID), GetUnitX(施法单位), GetUnitY(施法单位));
  if (物品 != null && 物品 !== 0) UnitAddItem(施法单位, 物品);
}

function 处理精灵小屋调查(this: void, _玩家ID: number, 施法单位: any, 调查点: any): boolean {
  void 调查点;
  const 玩家 = jass.GetOwningPlayer(施法单位);
  const 当前命中 = Number(YDUserDataGetSafe("player", 玩家, "命中率", "real")) || 0;
  YDUserDataSetSafe("player", 玩家, "命中率", "real", 当前命中 + 0.01);
  广播单位提示(施法单位, 精灵小屋提示文本, 3000);
  return true;
}

function 处理空木桩调查(this: void, _玩家ID: number, 施法单位: any, 调查点: any): boolean {
  void 调查点;
  创建并给予物品(施法单位, 果子物品ID);
  广播单位提示(施法单位, 空木桩提示文本, 3000);
  return true;
}

function 处理树上物品调查(this: void, _玩家ID: number, 施法单位: any, 调查点: any): boolean {
  void 调查点;
  创建并给予物品(施法单位, 果子物品ID);
  广播单位提示(施法单位, 树上物品提示文本, 3000);
  return true;
}

/** 注册精灵传送阵的常驻环境互动探索点。 */
export function 注册精灵传送阵探索点(this: void): void {
  注册环境互动调查点({
    ID: "精灵传送阵.精灵小屋",
    X: -20745.7,
    Y: -15044.7,
    触发范围: 250,
    一次性: false,
    触发回调: 处理精灵小屋调查,
  });
  注册环境互动调查点({
    ID: "精灵传送阵.空木桩",
    X: -19529.4,
    Y: -14869.6,
    触发范围: 250,
    一次性: true,
    触发回调: 处理空木桩调查,
  });
  注册环境互动调查点({
    ID: "精灵传送阵.树上物品",
    X: -17832.0,
    Y: -14822.9,
    触发范围: 250,
    一次性: true,
    触发回调: 处理树上物品调查,
  });
}

export {};
