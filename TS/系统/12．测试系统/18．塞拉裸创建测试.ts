/** @noSelfInFile */

const jass = require("jass.common") as any;
const globals = require("jass.globals") as { gg_unit_Hamg_0002?: any };

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const Player = jass.Player as (playerId: number) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  player: any,
  x: number,
  y: number,
  duration: number,
  text: string,
) => void;

const 模块名 = "塞拉裸创建测试";
const 测试命令 = "123";
const 玩家一 = Player(0);
// 对应 objediting/Boss/HeroBoss/01-MainlineBoss/03-BalzarothMechanicUnits.lua 的 UnitDefinition:new('N03K', 'nchr')。
const 塞拉物编ID = "N03K";
const 塞拉单位ID = stringToFourCCSafe(塞拉物编ID);

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function on塞拉裸创建命令(this: void, player: any, _command: string): void {
  if (!句柄有效(player) || GetPlayerId(player) !== 0) return;

  const 大法师 = globals.gg_unit_Hamg_0002;
  if (!句柄有效(大法师)) {
    debugLogForce(模块名, "创建失败", "原因=找不到 gg_unit_Hamg_0002");
    DisplayTimedTextToPlayer(player, 0, 0, 5, "[塞拉测试] 创建失败：找不到大法师预设单位。");
    return;
  }

  const x = GetUnitX(大法师);
  const y = GetUnitY(大法师);
  const facing = GetUnitFacing(大法师);
  const 塞拉 = CreateUnit(玩家一, 塞拉单位ID, x, y, facing);
  if (!句柄有效(塞拉)) {
    debugLogForce(模块名, "创建失败", "物编ID=", 塞拉物编ID, "x=", x, "y=", y, "facing=", facing);
    DisplayTimedTextToPlayer(player, 0, 0, 5, "[塞拉测试] 创建失败：CreateUnit 未返回有效单位。");
    return;
  }

  debugLogForce(模块名, "创建成功", "owner=Player1", "物编ID=", 塞拉物编ID, "x=", x, "y=", y, "facing=", facing);
  DisplayTimedTextToPlayer(player, 0, 0, 5, "[塞拉测试] 已在大法师预设位置裸创建玩家1塞拉。");
}

function 初始化塞拉裸创建测试(this: void): void {
  注册聊天命令监听(测试命令, on塞拉裸创建命令);
  debugLogForce(模块名, "已注册命令", 测试命令);
}

初始化塞拉裸创建测试();

export {};
