/** @noSelfInFile */

const jass = require("jass.common") as any;
const 全局变量 = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, 内容: string | undefined | null) => number;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, 物品类型ID: number, x: number, y: number) => any;
};

const GetUnitX = jass.GetUnitX as (单位: any) => number;
const GetUnitY = jass.GetUnitY as (单位: any) => number;
const UnitAddItem = jass.UnitAddItem as (单位: any, 物品: any) => boolean | number;

export function 获取首领奖励接收英雄(this: void, 玩家: any): any {
  const 注册英雄 = YDUserDataGetSafe("player", 玩家, "英雄", "unit");
  if (注册英雄 != null && 注册英雄 !== 0) return 注册英雄;
  return 全局变量.gg_unit_Hamg_0002;
}

export function 发放首领奖励装备(this: void, 玩家: any, 装备名: string): boolean {
  const 英雄 = 获取首领奖励接收英雄(玩家);
  if (英雄 == null || 英雄 === 0) return false;

  const 物品ID字符串 = 按名字反查物品ID(装备名);
  const 物品类型ID = stringToFourCCSafe(物品ID字符串);
  if (物品类型ID === 0) return false;

  const 物品 = 创建物品并注册排泄监听(物品类型ID, GetUnitX(英雄), GetUnitY(英雄));
  if (物品 == null || 物品 === 0) return false;

  UnitAddItem(英雄, 物品);
  return true;
}
