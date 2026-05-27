/**
 * 测试系统统一入口
 *
 * 通过开关控制是否加载各个测试模块。
 */

const ENABLE_STES_EVENT_TEST = false;
const ENABLE_YDLOCAL_TEST = false;
const ENABLE_QUEST_TEST = false;
const ENABLE_TEST_233 = true;
const ENABLE_TEST_EVENT = false;
const ENABLE_GOLD_BURST_TEST = true;
const ENABLE_BROADCAST_HINT_TEST = true;

function loadTests(): void {
  if (ENABLE_STES_EVENT_TEST) {
    require("系统.12．测试系统.STES事件测试");
  }

  if (ENABLE_YDLOCAL_TEST) {
    require("系统.12．测试系统.YDLocal返回值测试");
  }

  if (ENABLE_QUEST_TEST) {
    require("系统.12．测试系统.任务测试");
  }

  if (ENABLE_TEST_233) {
    require("系统.12．测试系统.02．平台API测试");
  }

  if (ENABLE_TEST_EVENT) {
    require("系统.12．测试系统.03．伤害事件测试");
  }

  if (ENABLE_GOLD_BURST_TEST) {
    require("系统.12．测试系统.01．金币爆发测试");
  }

  if (ENABLE_BROADCAST_HINT_TEST) {
    require("系统.12．测试系统.04．广播提示消息测试");
  }

}

loadTests();

export {};
