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

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;

const 模块名 = "火球模型测试";
const 测试命令 = "lock";
const 火球路径 = "Common\\Effect\\Element\\Fire\\OrbFireX.mdx";
let 火球测试特效: any = null;

function on聊天Lock测试(this: void): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "未找到预设大法师 gg_unit_Hamg_0002");
    return;
  }

  if (火球测试特效 != null && 火球测试特效 !== 0) {
    DestroyEffect(火球测试特效);
    火球测试特效 = null;
  }

  const facing = GetUnitFacing(大法师);
  const radians = facing * Math.PI / 180;
  const x = GetUnitX(大法师) + 100 * Cos(radians);
  const y = GetUnitY(大法师) + 100 * Sin(radians);
  火球测试特效 = EC_CreateEffect(火球路径, x, y, 0, facing, 3.0, 1.0, -1);
  if (火球测试特效 == null || 火球测试特效 === 0) {
    debugLogForce(模块名, "创建失败：", 火球路径);
    return;
  }
  debugLogForce(模块名, "已在大法师面前100码创建 OrbFireX，缩放3.0，使用模型默认动画");
}

注册聊天命令监听(测试命令, on聊天Lock测试);

export {};
