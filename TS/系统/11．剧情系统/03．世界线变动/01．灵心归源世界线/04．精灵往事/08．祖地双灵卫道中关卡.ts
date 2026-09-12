/** @noSelfInFile */

import { 祖地双灵卫副本配置, type 祖地双灵卫道中单位预置 } from "./01．祖地双灵卫副本配置";
import { 祖地双灵卫副本状态 } from "./02．祖地双灵卫副本状态";
import { register祖地双灵卫试炼全部完成Listener } from "./03．祖地双灵卫试炼";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { ModifyGateBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  ModifyGateBJ: (this: void, operation: number, gate: any) => void;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, sourceUnit: any, text: string, durationMs?: number) => void;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;

const 道中广播前缀 = "|cffffff00『祖地秘境』：|r";
const 道中通关广播持续毫秒 = 5000;

let 道中模块已初始化 = false;

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 打开关卡闸门(this: void, 闸门变量名: string): void {
  const gate = jglobals[闸门变量名];
  if (!句柄有效(gate)) return;
  ModifyGateBJ(jglobals.bj_GATEOPERATION_OPEN, gate);
}

function 创建道中关卡单位(this: void, 预置: 祖地双灵卫道中单位预置): boolean {
  const unitTypeId = stringToFourCCSafe(预置.单位ID);
  if (unitTypeId === 0) return false;
  const unit = 创建单位并登记排泄安全(Player(PLAYER_NEUTRAL_AGGRESSIVE), unitTypeId, 预置.X, 预置.Y, 预置.朝向);
  if (!句柄有效(unit)) return false;
  祖地双灵卫副本状态.道中.存活单位句柄表[GetHandleId(unit)] = true;
  祖地双灵卫副本状态.道中.存活单位数 = 祖地双灵卫副本状态.道中.存活单位数 + 1;
  return true;
}

function 开启道中关卡(this: void, 关卡序号: number): void {
  const 关卡 = 祖地双灵卫副本配置.道中关卡列表[关卡序号 - 1];
  if (关卡 == null) return;
  祖地双灵卫副本状态.道中.当前关卡序号 = 关卡序号;
  祖地双灵卫副本状态.道中.存活单位句柄表 = {};
  祖地双灵卫副本状态.道中.存活单位数 = 0;
  for (let i = 0; i < 关卡.编制.length; i++) {
    创建道中关卡单位(关卡.编制[i]);
  }
}

function 进入下一关(this: void): void {
  const 状态 = 祖地双灵卫副本状态.道中;
  const 关卡序号 = 状态.当前关卡序号;
  const 关卡 = 祖地双灵卫副本配置.道中关卡列表[关卡序号 - 1];
  if (关卡 == null) return;
  打开关卡闸门(关卡.闸门变量名);
  广播单位提示(null, 道中广播前缀 + 关卡.通关广播, 道中通关广播持续毫秒);
  if (关卡序号 >= 祖地双灵卫副本配置.道中关卡列表.length) {
    状态.全部通关 = true;
    return;
  }
  开启道中关卡(关卡序号 + 1);
}

function on道中单位死亡(this: void, dyingUnit: any): void {
  const 状态 = 祖地双灵卫副本状态.道中;
  if (!状态.已开启 || 状态.全部通关) return;
  const handleId = GetHandleId(dyingUnit);
  if (handleId === 0) return;
  if (状态.存活单位句柄表[handleId] !== true) return;
  delete 状态.存活单位句柄表[handleId];
  状态.存活单位数 = 状态.存活单位数 - 1;
  if (状态.存活单位数 > 0) return;
  进入下一关();
}

function on祖地双灵卫试炼全部完成开启道中(this: void): void {
  const 状态 = 祖地双灵卫副本状态.道中;
  if (状态.已开启) return;
  状态.已开启 = true;
  开启道中关卡(1);
}

export function init祖地双灵卫道中关卡(this: void): void {
  if (道中模块已初始化) return;
  道中模块已初始化 = true;
  register祖地双灵卫试炼全部完成Listener(on祖地双灵卫试炼全部完成开启道中);
  registerDeathListener(on道中单位死亡);
}
