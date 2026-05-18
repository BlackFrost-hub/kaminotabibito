/** @noSelfInFile */
/**
 * 原生弹幕追踪测试
 *
 * 输入 "1014"
 * - 让 gg_unit_Hamg_0002 对 gg_unit_ogru_0019 发射原生追踪弹幕
 * - 只验证原生弹幕创建、追踪、命中、到达目标点回调是否正常
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as {
  gg_unit_Hamg_0002?: any;
  gg_unit_ogru_0019?: any;
  [key: string]: any;
};

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, 玩家: any, 命令: string) => void) => void;
};
const { 创建原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, 参数: any) => { 弹幕ID: number };
};
const { 创建追踪插值轨迹 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index") as {
  创建追踪插值轨迹: (this: void, 目标单位: any, 到达距离?: number) => any;
};
const { isSameUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isSameUnit: (this: void, unitA: any, unitB: any) => boolean;
};

const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (whichUnit: any) => number;
const GetUnitName = jass.GetUnitName as (whichUnit: any) => string;
const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;

const 模块名 = "原生弹幕追踪测试";
const 测试命令 = "1041";
const 弹幕模型 = "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl";

function 追踪测试命中单位(this: void, 目标单位: any, 弹幕ID: number): void {
  debugLogForce(模块名, "命中单位", "弹幕ID=", 弹幕ID, "目标=", GetUnitName(目标单位), "#", GetHandleId(目标单位));
}

function 追踪测试命中(this: void, 目标单位: any, 弹幕ID: number): void {
  debugLogForce(模块名, "on命中", "弹幕ID=", 弹幕ID, "目标=", GetUnitName(目标单位), "#", GetHandleId(目标单位));
}

function 追踪测试到达目标点(this: void, 弹幕ID: number, 原因: "完成" | "距离结束"): void {
  debugLogForce(模块名, "到达目标点", "弹幕ID=", 弹幕ID, "原因=", 原因);
}

function 追踪测试结束(this: void, 原因: string, 弹幕ID: number): void {
  debugLogForce(模块名, "结束", "弹幕ID=", 弹幕ID, "原因=", 原因);
}

function 追踪测试目标筛选(this: void, 目标单位: any): boolean {
  const 固定目标 = g.gg_unit_ogru_0019;
  if (固定目标 == null || 固定目标 === 0) return false;
  return isSameUnit(目标单位, 固定目标);
}

function 执行1014原生追踪测试(this: void): void {
  const 施法者 = g.gg_unit_Hamg_0002;
  const 目标单位 = g.gg_unit_ogru_0019;
  if (施法者 == null || 施法者 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }
  if (目标单位 == null || 目标单位 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_ogru_0019");
    return;
  }

  debugLogForce(
    模块名,
    "准备发射",
    "source=",
    GetUnitName(施法者),
    "#",
    GetHandleId(施法者),
    "target=",
    GetUnitName(目标单位),
    "#",
    GetHandleId(目标单位),
    "sourcePos=(",
    GetUnitX(施法者),
    ",",
    GetUnitY(施法者),
    ")",
    "targetPos=(",
    GetUnitX(目标单位),
    ",",
    GetUnitY(目标单位),
    ")",
  );

  const 实例 = 创建原生弹幕({
    所有者: 施法者,
    X: GetUnitX(施法者),
    Y: GetUnitY(施法者),
    方向角: GetUnitFacing(施法者),
    指定目标: 目标单位,
    速度: 1000,
    轨迹采样器: 创建追踪插值轨迹(目标单位, 100),
    命中半径: 100,
    生命周期: 6,
    碰撞消失: true,
    最大距离: 5000,
    模型: 弹幕模型,
    附着特效模型: 弹幕模型,
    影响目标: "全部",
    目标筛选: 追踪测试目标筛选,
    最大总命中次数: 1,
    每单位最大命中次数: 1,
    on命中: 追踪测试命中,
    on命中单位: 追踪测试命中单位,
    on到达目标点: 追踪测试到达目标点,
    on结束: 追踪测试结束,
  });

  debugLogForce(模块名, "已发射追踪弹幕", "弹幕ID=", 实例.弹幕ID);
}

function on聊天1014(this: void): void {
  执行1014原生追踪测试();
}

注册聊天命令监听(测试命令, on聊天1014);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "让大法师对食人魔勇士发射追踪弹幕");

export {};
