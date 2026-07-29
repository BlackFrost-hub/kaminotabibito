/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (player: any, x: number, y: number, duration: number, text: string) => void;

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { Boss测试单位存活, 获取Boss测试玩家基准英雄 } = require("系统.12．测试系统.00．Boss测试系统.02．Boss测试单位") as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 测试命令 = "66";
const 测试模型 = "Common\\Effect\\Element\\Fantasy\\file_002480.mdx";
const 测试高度 = 100;
const 测试缩放 = 1;
const 测试持续秒 = 10;

function on凤凰挽歌圈外命中特效测试(this: void, player: any, _command: string): void {
  const hero = 获取Boss测试玩家基准英雄(player);
  if (!Boss测试单位存活(hero)) {
    DisplayTimedTextToPlayer(player, 0, 0, 8, "[凤凰挽歌圈外命中特效测试] 找不到大法师或已登记玩家英雄。");
    debugLogForce("凤凰挽歌圈外命中特效测试", "创建失败：找不到测试英雄");
    return;
  }

  const x = GetUnitX(hero);
  const y = GetUnitY(hero);
  const effect = 创建点特效({
    模型路径: 测试模型,
    X: x,
    Y: y,
    Z: 测试高度,
    缩放: 测试缩放,
    持续秒: 测试持续秒,
  });
  DisplayTimedTextToPlayer(player, 0, 0, 8, "[凤凰挽歌圈外命中特效测试] 已在大法师坐标创建命中特效，Z=100、缩放=1.0、持续10秒。");
  debugLogForce(
    "凤凰挽歌圈外命中特效测试",
    "命令", 测试命令,
    "模型", 测试模型,
    "X", x,
    "Y", y,
    "Z", 测试高度,
    "缩放", 测试缩放,
    "特效句柄ID", effect != null && effect !== 0 ? GetHandleId(effect) : 0,
  );
}

注册聊天命令监听(测试命令, on凤凰挽歌圈外命中特效测试);

export {};
