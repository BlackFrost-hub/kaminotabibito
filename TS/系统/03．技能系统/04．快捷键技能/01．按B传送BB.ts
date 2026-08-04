/** @noSelfInFile */

/**
 * 快捷键技能功能
 *
 * 按B传送BB：按B键让BB单位传送到鼠标位置
 */

const jass = require("jass.common") as any;
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { SelectUnitForPlayerSingle } = require("lib.扩展函数.BJ函数.index") as {
  SelectUnitForPlayerSingle: (this: void, unit: any, player: any) => void;
};
const { String2OrderIdBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  String2OrderIdBJ: (this: void, orderIdString: string) => number;
};
const { registerSyncHardwareKey } = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心") as {
  registerSyncHardwareKey: (
    this: void,
    key: number | string,
    status: number,
    callback: (this: void, event: { player: any; key: number | string; status: number }) => void
  ) => any;
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
const DzGetMouseTerrainX = (require("jass.japi") as any).DzGetMouseTerrainX as (this: void) => number;
const DzGetMouseTerrainY = (require("jass.japi") as any).DzGetMouseTerrainY as (this: void) => number;
const DzGetTriggerKeyPlayer = (require("jass.japi") as any).DzGetTriggerKeyPlayer as (this: void) => any;

interface 同步键盘事件 {
  player: any;
  key: number | string;
  status: number;
}

const BB传送命令ID = String2OrderIdBJ("blink");

/** 触发器 */
let bbTeleportTrigger: any = null;

/**
 * 按B传送BB事件处理
 */
function onBKeyTeleport(this: void, event: 同步键盘事件): void {
  // 检查按键是否为B
  if (event.key !== KEY.B && event.key !== "B") {
    return;
  }

  const player = event.player || DzGetTriggerKeyPlayer();
  if (player == null || player === 0) {
    return;
  }

  // 获取玩家的BB单位
  const bbUnit = YDUserDataGetSafe("player", player, "BB", "unit");
  if (bbUnit == null || bbUnit === 0) {
    return;
  }

  // 获取鼠标位置
  const mouseX = DzGetMouseTerrainX();
  const mouseY = DzGetMouseTerrainY();

  // 物编技能A0FC继承闪烁，发布命令时使用技能的真实Order字段
  IssuePointOrderById(bbUnit, BB传送命令ID, mouseX, mouseY);

  // 选中BB单位
  SelectUnitForPlayerSingle(bbUnit, player);
}

/**
 * 初始化按B传送BB功能
 */
export function initBBTeleport(this: void): void {
  if (bbTeleportTrigger != null) return;

  bbTeleportTrigger = registerSyncHardwareKey(KEY.B, KEY_STATE.UP, onBKeyTeleport);
}

export {};
