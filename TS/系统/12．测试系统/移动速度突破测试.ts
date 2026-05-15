/** @noSelfInFile */
/**
 * 移动速度突破系统测试
 *
 * 输入 ms 后，将 gg_unit_Hamg_0002 设置为700移速
 * 输入 ms0 后取消注册，避免开局3秒窗口太短导致看不到效果
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { SOS_SetUnitSpeed, SOS_UnSetUnitSpeed } = require("lib.扩展函数.Star扩展函数.Star扩展库.05．移动速度突破系统") as {
  SOS_SetUnitSpeed: (this: void, u: any, speed: number) => void;
  SOS_UnSetUnitSpeed: (this: void, u: any) => void;
};

let _cancelTimer: any = null;
let _initTimer: any = null;
let _chatTrigger: any = null;

const CMD_ENABLE = "ms";
const CMD_DISABLE = "ms0";

function onCancelTimerExpire(this: void): void {
  const testUnit = g.gg_unit_Hamg_0002;
  if (testUnit) {
    SOS_UnSetUnitSpeed(testUnit);
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 5, "[移动速度突破测试] 已取消 gg_unit_Hamg_0002 的移动速度突破注册");
  }
  if (_cancelTimer) {
    jass.DestroyTimer(_cancelTimer);
    _cancelTimer = null;
  }
}

function testMoveSpeedBreakthrough(this: void): void {
  const testUnit = g.gg_unit_Hamg_0002;

  if (!testUnit) {
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 5, "[移动速度突破测试] 错误：找不到单位 gg_unit_Hamg_0002");
    return;
  }

  SOS_SetUnitSpeed(testUnit, 700);

  jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 5, "[移动速度突破测试] 已将 gg_unit_Hamg_0002 设置为700移速；输入 ms0 取消");
}

function onInitTimerExpire(this: void): void {
  jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 8, "[移动速度突破测试] 输入 ms 设置700移速，输入 ms0 取消");
  if (_initTimer) {
    jass.DestroyTimer(_initTimer);
    _initTimer = null;
  }
}

function onChatCommand(this: void): void {
  const text = jass.GetEventPlayerChatString();
  if (text === CMD_ENABLE) {
    testMoveSpeedBreakthrough();
    return;
  }
  if (text === CMD_DISABLE) {
    onCancelTimerExpire();
  }
}

function initTest(this: void): void {
  _chatTrigger = jass.CreateTrigger();
  jass.TriggerRegisterPlayerChatEvent(_chatTrigger, jass.Player(0), CMD_ENABLE, true);
  jass.TriggerRegisterPlayerChatEvent(_chatTrigger, jass.Player(0), CMD_DISABLE, true);
  jass.TriggerAddAction(_chatTrigger, onChatCommand);

  _initTimer = jass.CreateTimer();
  jass.TimerStart(_initTimer, 0.1, false, onInitTimerExpire);
}

initTest();

export {};
