/** @noSelfInFile */

const { 是玩家英雄组单位: 核心是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};

export function 是玩家英雄组单位(this: void, unit: any): boolean {
  return 核心是玩家英雄组单位(unit);
}

export {};
