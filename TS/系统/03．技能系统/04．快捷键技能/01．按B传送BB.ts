/**
 * 快捷键技能功能
 *
 * 按B传送BB：按B键让BB单位传送到鼠标位置
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { SelectUnitForPlayerSingle } = require("lib.扩展函数.BJ函数.index") as {
  SelectUnitForPlayerSingle: (unit: any, player: any) => void;
};
const { DzTriggerRegisterKeyEventTrg } = require("lib.扩展函数.KK扩展API.index") as {
  DzTriggerRegisterKeyEventTrg: (trg: any, status: number, btn: number | string) => void;
};
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (this: void, s: string) => number;
};

/** BB传送技能ID */
const BB_TELEPORT_ABILITY = 'A0FC';

/** 触发器 */
let bbTeleportTrigger: any = null;

/**
 * 按B传送BB事件处理
 */
function onBKeyTeleport(): void {
  // 检查按键是否为B
  const key = japi.DzGetTriggerKey();
  if (key !== 'B') return;

  const player = japi.DzGetTriggerKeyPlayer();

  // 获取玩家的BB单位
  const bbUnit = YDUserDataGet("player", player, "BB", "unit");
  if (bbUnit == null) return;

  // 获取鼠标位置
  const mouseX = japi.DzGetMouseTerrainX();
  const mouseY = japi.DzGetMouseTerrainY();

  // 直接发布点目标命令，使用技能ID
  // 对于传送类技能，直接使用技能ID作为orderId
  const abilityId = stringToFourCC(BB_TELEPORT_ABILITY);
  jass.IssuePointOrderById(bbUnit, abilityId, mouseX, mouseY);

  // 注：YDWEAbilityId2OrderId 是YDWE宏定义，非标准JAPI函数
  // const orderId = japi.YDWEAbilityId2OrderId(BB_TELEPORT_ABILITY, "Order");
  // jass.IssueNeutralPointOrderById(player, bbUnit, orderId, mouseX, mouseY);

  // 选中BB单位
  SelectUnitForPlayerSingle(bbUnit, player);
}

/**
 * 初始化按B传送BB功能
 */
export function initBBTeleport(): void {
  if (bbTeleportTrigger != null) return;

  bbTeleportTrigger = jass.CreateTrigger();

  DzTriggerRegisterKeyEventTrg(bbTeleportTrigger, 0, 'B');

  jass.TriggerAddAction(bbTeleportTrigger, onBKeyTeleport);
}

export {};
