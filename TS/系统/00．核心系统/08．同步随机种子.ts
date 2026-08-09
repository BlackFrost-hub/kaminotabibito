/** @noSelfInFile */
/**
 * 同步随机种子
 *
 * 仅由 Player(0) 读取平台服务器开局时间并发送低频同步消息。
 * 所有客户端只在同一同步回调中设置 JASS 随机种子，避免各端设置时机不同。
 */

const jass = require("jass.common") as any;

const centerTimer = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const {
  DzSyncData,
  DzTriggerRegisterSyncDataTrg,
  DzGetTriggerSyncPlayer,
  DzGetTriggerSyncData,
} = require("lib.扩展函数.KK扩展API.02．事件注册函数") as {
  DzSyncData: (this: void, prefix: string, data: string) => void;
  DzTriggerRegisterSyncDataTrg: (this: void, trig: any, prefix: string, server: boolean) => void;
  DzGetTriggerSyncPlayer: (this: void) => any;
  DzGetTriggerSyncData: (this: void) => string;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const TriggerAddAction = jass.TriggerAddAction as (this: void, trig: any, callback: (this: void) => void) => any;
const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const Player = jass.Player as (this: void, playerId: number) => any;
const SetRandomSeed = jass.SetRandomSeed as (this: void, seed: number) => void;
const R2I = jass.R2I as (this: void, value: number) => number;
const I2S = jass.I2S as (this: void, value: number) => string;
const S2I = jass.S2I as (this: void, value: string) => number;

const 调试模块 = "同步随机种子";
const 同步前缀 = "MAPSEED";
const 权威玩家ID = 0;
const 最大种子 = 2147483647;
const 有效平台时间下限毫秒 = 1451606400000;
const 重试间隔毫秒 = 100;
const 最多等待日志次数 = 5;

let 已设置 = false;
let 本机已发送 = false;
let 重试任务ID: number | undefined;
let 等待日志次数 = 0;

function 输出日志(this: void, ...args: any[]): void {
  debugLogForce(调试模块, ...args);
}

function 标准化种子(this: void, serverTimeMs: number): number {
  let seed = R2I(serverTimeMs / 1000);
  if (seed > 最大种子) seed = seed % 最大种子;
  return seed > 0 ? seed : 1;
}

function 停止重试(this: void): void {
  if (重试任务ID == null) return;
  centerTimer.removePeriodicCallback(重试任务ID);
  重试任务ID = undefined;
}

function on收到同步种子(this: void): void {
  if (已设置) return;

  const 发送玩家 = DzGetTriggerSyncPlayer();
  const 发送玩家ID = 发送玩家 == null || 发送玩家 === 0 ? -1 : GetPlayerId(发送玩家);
  if (发送玩家ID !== 权威玩家ID) {
    输出日志("拒绝非权威种子", "发送玩家ID=", 发送玩家ID);
    return;
  }

  const seed = S2I(DzGetTriggerSyncData());
  if (seed <= 0 || seed > 最大种子) {
    输出日志("拒绝无效种子", "seed=", seed);
    return;
  }

  SetRandomSeed(seed);
  已设置 = true;
  停止重试();
  输出日志("同步设置完成", "seed=", seed, "发送玩家ID=", 发送玩家ID);
}

function on尝试发送种子(this: void): void {
  if (已设置) {
    停止重试();
    return;
  }
  if (GetLocalPlayer() !== Player(权威玩家ID)) return;
  if (本机已发送) return;

  const serverTimeMs = centerTimer.getServerTime();
  if (serverTimeMs < 有效平台时间下限毫秒) {
    if (等待日志次数 < 最多等待日志次数) {
      等待日志次数++;
      输出日志("等待有效平台服务器时间", "第", 等待日志次数, "次", "serverTimeMs=", serverTimeMs);
    }
    return;
  }

  const seed = 标准化种子(serverTimeMs);
  本机已发送 = true;
  输出日志("权威端发送", "seed=", seed, "serverTimeMs=", serverTimeMs);
  DzSyncData(同步前缀, I2S(seed));
}

function 初始化同步随机种子(this: void): void {
  const 同步触发器 = CreateTrigger();
  TriggerAddAction(同步触发器, on收到同步种子);
  DzTriggerRegisterSyncDataTrg(同步触发器, 同步前缀, true);
  重试任务ID = centerTimer.addPeriodicCallback(重试间隔毫秒, on尝试发送种子);
  输出日志("同步监听已注册", "prefix=", 同步前缀, "权威玩家ID=", 权威玩家ID, "重试任务ID=", 重试任务ID);
}

初始化同步随机种子();

export {};
