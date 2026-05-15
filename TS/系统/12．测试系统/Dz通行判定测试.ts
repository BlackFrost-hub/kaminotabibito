/** @noSelfInFile */
const japi = require("jass.japi") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};
const { X_IsTerrainWalkable, X_IsUnitTerrainWalkable } = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数") as {
  X_IsTerrainWalkable: (this: void, x: number, y: number) => boolean;
  X_IsUnitTerrainWalkable: (this: void, unit: any, x: number, y: number) => boolean;
};

const DzPositionCanPlaceAround = japi["DzPositionCanPlaceAround"] as (this: void, x: number, y: number, size: number, collisionType: number) => boolean;
const DzUnitCanPlaceAround = japi["DzUnitCanPlaceAround"] as (this: void, unit: any, x: number, y: number) => boolean;

const 模块名 = "Dz通行判定测试";
const 测试命令 = "dzcp";
const 测试X = 845.1;
const 测试Y = -2446.4;
const 测试碰撞大小 = 32.0;
const 测试碰撞类型 = 2;

function onChatDzCanPlaceTest(this: void): void {
  const unit = g.gg_unit_Hamg_0002;
  if (unit == null || unit === 0) {
    debugLogForce(模块名, "未找到 gg_unit_Hamg_0002");
    return;
  }

  const posResult = DzPositionCanPlaceAround(测试X, 测试Y, 测试碰撞大小, 测试碰撞类型);
  const unitResult = DzUnitCanPlaceAround(unit, 测试X, 测试Y);
  const terrainResult = X_IsTerrainWalkable(测试X, 测试Y);
  const xUnitResult = X_IsUnitTerrainWalkable(unit, 测试X, 测试Y);

  debugLogForce(模块名, "坐标=(", 测试X, ",", 测试Y, ")");
  debugLogForce(模块名, "DzPositionCanPlaceAround(size=32,type=2)=", posResult);
  debugLogForce(模块名, "DzUnitCanPlaceAround(unit,x,y)=", unitResult);
  debugLogForce(模块名, "X_IsTerrainWalkable(x,y)=", terrainResult);
  debugLogForce(模块名, "X_IsUnitTerrainWalkable(unit,x,y)=", xUnitResult);
}

注册聊天命令监听(测试命令, onChatDzCanPlaceTest);
debugLogForce(模块名, "已注册测试，输入", 测试命令, "检测坐标", 测试X, 测试Y);

export {};
