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

/**
 * 测试移动速度突破
 */
function testMoveSpeedBreakthrough(this: void): void {
  // 获取测试单位 gg_unit_Hamg_0002
  const testUnit = g.gg_unit_Hamg_0002;

  if (!testUnit) {
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 5, "[移动速度突破测试] 错误：找不到单位 gg_unit_Hamg_0002");
    return;
  }

  // 设置单位为700移速（突破522上限）
  SOS_SetUnitSpeed(testUnit, 700);

  jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 5, "[移动速度突破测试] 已将 gg_unit_Hamg_0002 设置为700移速，3秒后取消注册");

  // 3秒后取消注册
  const cancelTimer = jass.CreateTimer();
  jass.TimerStart(cancelTimer, 3.0, false, () => {
    SOS_UnSetUnitSpeed(testUnit);
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 5, "[移动速度突破测试] 已取消 gg_unit_Hamg_0002 的移动速度突破注册");
    jass.DestroyTimer(cancelTimer);
  });
}

/**
 * 初始化测试
 */
function initTest(this: void): void {
  // 游戏开始0.1秒后执行测试
  const timer = jass.CreateTimer();
  jass.TimerStart(timer, 0.1, false, () => {
    testMoveSpeedBreakthrough();
    jass.DestroyTimer(timer);
  });
}

// 立即执行初始化
initTest();

export {};
