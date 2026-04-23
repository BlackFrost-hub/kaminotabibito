/**
 * 测试系统统一入口
 *
 * 通过开关控制是否加载各个测试模块。
 */

const ENABLE_MOVE_SPEED_TEST = true;
const ENABLE_STES_EVENT_TEST = false;
const ENABLE_YDLOCAL_TEST = false;
const ENABLE_QUEST_TEST = false;
const ENABLE_SHOP_TEST = false;
const ENABLE_TEST_233 = true;
const ENABLE_TEST_EVENT = false;
const ENABLE_TEST_EVENT_2 = true;

function loadTests(): void {
  if (ENABLE_MOVE_SPEED_TEST) {
    require("系统.12．测试系统.移动速度突破测试");
  }

  if (ENABLE_STES_EVENT_TEST) {
    require("系统.12．测试系统.STES事件测试");
  }

  if (ENABLE_YDLOCAL_TEST) {
    require("系统.12．测试系统.YDLocal返回值测试");
  }

  if (ENABLE_QUEST_TEST) {
    require("系统.12．测试系统.任务测试");
  }

  if (ENABLE_SHOP_TEST) {
    require("系统.12．测试系统.模拟商店");
  }

  if (ENABLE_TEST_233) {
    require("系统.12．测试系统.测试233注册");
  }

  if (ENABLE_TEST_EVENT) {
    require("系统.12．测试系统.测试事件");
  }

  if (ENABLE_TEST_EVENT_2) {
    require("系统.12．测试系统.测试事件2");
  }

}

loadTests();

export {};
