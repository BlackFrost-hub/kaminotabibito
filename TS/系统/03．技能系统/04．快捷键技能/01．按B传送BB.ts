/** @noSelfInFile */

/**
 * 快捷键技能功能
 *
 * 按B传送BB：按B键让BB单位传送到鼠标位置
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { SelectUnitForPlayerSingle } = require("lib.扩展函数.BJ函数.index") as {
  SelectUnitForPlayerSingle: (this: void, unit: any, player: any) => void;
};
const { String2OrderIdBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  String2OrderIdBJ: (this: void, orderIdString: string) => number;
};
const {
  DzSyncData,
  DzTriggerRegisterSyncDataTrg,
  DzGetTriggerSyncPlayer,
  DzGetTriggerSyncData,
} = require("lib.扩展函数.KK扩展API.02．事件注册函数") as {
  DzSyncData: (this: void, prefix: string, data: string) => void;
  DzTriggerRegisterSyncDataTrg: (this: void, trigger: any, prefix: string, server: boolean) => void;
  DzGetTriggerSyncPlayer: (this: void) => any;
  DzGetTriggerSyncData: (this: void) => string;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { KEY, KEY_STATE } = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义") as {
  KEY: { B: number };
  KEY_STATE: { UP: number };
};
const IssuePointOrderById = jass.IssuePointOrderById as (
  this: void,
  unit: any,
  orderId: number,
  x: number,
  y: number
) => boolean;
const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const TriggerAddAction = jass.TriggerAddAction as (
  this: void,
  trigger: any,
  callback: (this: void) => void
) => any;
const R2S = jass.R2S as (this: void, value: number) => string;
const S2R = jass.S2R as (this: void, value: string) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const DzTriggerRegisterKeyEventByCode = japi.DzTriggerRegisterKeyEventByCode as (
  this: void,
  trigger: any,
  keyCode: number,
  status: number,
  sync: boolean,
  callback: (this: void) => void
) => void;
const DzIsChatBoxOpen = japi.DzIsChatBoxOpen as (this: void) => boolean;
const DzGetMouseTerrainX = japi.DzGetMouseTerrainX as (this: void) => number;
const DzGetMouseTerrainY = japi.DzGetMouseTerrainY as (this: void) => number;

const BB传送命令ID = String2OrderIdBJ("blink");
const BB传送同步前缀 = "BBTP";
const BB传送坐标分隔符 = "|";
const BB传送调试模块 = "按B传送BB诊断";

/** 本机按键触发器与同步数据触发器。 */
let bbTeleportKeyTrigger: any = null;
let bbTeleportSyncTrigger: any = null;

/**
 * 本机确认聊天框未激活后，由键盘中心调用并发送鼠标坐标。
 */
function onBKeyLocal(this: void): void {
  const chatBoxOpen = DzIsChatBoxOpen() === true;
  debugLogForce(BB传送调试模块, "本机B回调", "聊天框", chatBoxOpen);
  if (chatBoxOpen) return;

  const mouseX = DzGetMouseTerrainX();
  const mouseY = DzGetMouseTerrainY();
  DzSyncData(BB传送同步前缀, R2S(mouseX) + BB传送坐标分隔符 + R2S(mouseY));
  debugLogForce(BB传送调试模块, "已发送同步坐标", mouseX, mouseY);
}

/** 在同步数据回调中统一执行 BB 传送。 */
function onBKeyTeleportSync(this: void): void {
  const player = DzGetTriggerSyncPlayer();
  const syncData = DzGetTriggerSyncData();
  debugLogForce(
    BB传送调试模块,
    "收到同步消息",
    "玩家",
    player == null || player === 0 ? 0 : GetHandleId(player),
    "数据",
    syncData
  );
  if (player == null || player === 0) {
    return;
  }

  // 获取玩家的BB单位
  const bbUnit = YDUserDataGetSafe("player", player, "BB", "unit");
  if (bbUnit == null || bbUnit === 0) {
    debugLogForce(BB传送调试模块, "未找到BB单位");
    return;
  }

  const coordinateParts = syncData.split(BB传送坐标分隔符);
  if (coordinateParts.length < 2) return;
  const mouseX = S2R(coordinateParts[0] || "0");
  const mouseY = S2R(coordinateParts[1] || "0");

  // 物编技能A0FC继承闪烁，发布命令时使用技能的真实Order字段
  const orderResult = IssuePointOrderById(bbUnit, BB传送命令ID, mouseX, mouseY);
  debugLogForce(BB传送调试模块, "发布传送命令", "BB", GetHandleId(bbUnit), "结果", orderResult);

  // 选中BB单位
  SelectUnitForPlayerSingle(bbUnit, player);
}

/**
 * 初始化按B传送BB功能
 */
export function initBBTeleport(this: void): void {
  if (bbTeleportKeyTrigger != null || bbTeleportSyncTrigger != null) return;

  bbTeleportSyncTrigger = CreateTrigger();
  TriggerAddAction(bbTeleportSyncTrigger, onBKeyTeleportSync);
  DzTriggerRegisterSyncDataTrg(bbTeleportSyncTrigger, BB传送同步前缀, false);
  bbTeleportKeyTrigger = CreateTrigger();
  DzTriggerRegisterKeyEventByCode(bbTeleportKeyTrigger, KEY.B, KEY_STATE.UP, false, onBKeyLocal);
  debugLogForce(BB传送调试模块, "初始化完成");
}

export {};
