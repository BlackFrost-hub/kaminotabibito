/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, fac: number, size: number, speed: number, time: number) => any;
};
const { CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;

const 模块名 = "火球模型测试";
const 测试命令 = "lock";
const 金锁路径 = "Common\\Effect\\Form\\Line\\file_001295.mdx";
let 金锁测试特效: any = null;

function on聊天Lock测试(this: void): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "未找到预设大法师 gg_unit_Hamg_0002");
    return;
  }

  if (金锁测试特效 != null && 金锁测试特效 !== 0) {
    DestroyEffect(金锁测试特效);
    金锁测试特效 = null;
  }

  const facing = GetUnitFacing(大法师);
  const x = GetUnitX(大法师) + 180 * CosBJ(facing);
  const y = GetUnitY(大法师) + 180 * SinBJ(facing);
  金锁测试特效 = EC_CreateEffect(金锁路径, x, y, 0, facing, 1.0, 1.0, 1.0);
  if (金锁测试特效 == null || 金锁测试特效 === 0) {
    debugLogForce(模块名, "创建失败：", 金锁路径);
    return;
  }
  debugLogForce(模块名, "已沿大法师技能方向前移180码创建金锁特效，按朝向旋转，1秒后隐藏");
}

注册聊天命令监听(测试命令, on聊天Lock测试);

export {};
