/** @noSelfInFile */
/**
 * 移动速度突破系统测试
 *
 * 游戏开始0.1秒后，将 gg_unit_Hamg_0002 设置为700移速
 * 3秒后取消注册，测试特效是否正确删除
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { SOS_SetUnitSpeed, SOS_UnSetUnitSpeed } = require("lib.扩展函数.Star扩展函数.Star扩展库.05．移动速度突破系统") as {
  SOS_SetUnitSpeed: (u: any, speed: number) => void;
  SOS_UnSetUnitSpeed: (u: any) => void;
};

let _cancelTimer: any = null;
let _initTimer: any = null;

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

  jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 5, "[移动速度突破测试] 已将 gg_unit_Hamg_0002 设置为700移速，3秒后取消注册");

  _cancelTimer = jass.CreateTimer();
  jass.TimerStart(_cancelTimer, 3.0, false, onCancelTimerExpire);
}

function onInitTimerExpire(this: void): void {
  testMoveSpeedBreakthrough();
  if (_initTimer) {
    jass.DestroyTimer(_initTimer);
    _initTimer = null;
  }
}

function initTest(this: void): void {
  _initTimer = jass.CreateTimer();
  jass.TimerStart(_initTimer, 0.1, false, onInitTimerExpire);
}

initTest();

export {};
