/**
 * 测试系统 - 统一入口
 *
 * 所有测试模块在此统一导入，通过开关控制是否启用
 */

// ==========================================================================================
// 测试开关配置
// ==========================================================================================

/** 是否启用移动速度突破测试 */
const ENABLE_MOVE_SPEED_TEST = true;

/** 是否启用Dz函数测试 */
const ENABLE_DZ_FUNCTION_TEST = false;

/** 是否启用STES事件测试 */
const ENABLE_STES_EVENT_TEST = false;

/** 是否启用YDLocal返回值测试 */
const ENABLE_YDLOCAL_TEST = false;

/** 是否启用任务测试 */
const ENABLE_QUEST_TEST = false;

/** 是否启用模拟商店测试 */
const ENABLE_SHOP_TEST = false;

/** 是否启用测试233注册 */
const ENABLE_TEST_233 = false;

/** 是否启用测试事件 */
const ENABLE_TEST_EVENT = false;

/** 是否启用测试事件2 */
const ENABLE_TEST_EVENT_2 = false;

// ==========================================================================================
// 测试模块加载
// ==========================================================================================

/** 加载测试模块 */
function loadTests(): void {
  // 移动速度突破测试
  if (ENABLE_MOVE_SPEED_TEST) {
    require("系统.12．测试系统.移动速度突破测试");
  }

  // Dz函数测试
  if (ENABLE_DZ_FUNCTION_TEST) {
    require("系统.12．测试系统.dz函数测试");
  }

  // STES事件测试
  if (ENABLE_STES_EVENT_TEST) {
    require("系统.12．测试系统.STES事件测试");
  }

  // YDLocal返回值测试
  if (ENABLE_YDLOCAL_TEST) {
    require("系统.12．测试系统.YDLocal返回值测试");
  }

  // 任务测试
  if (ENABLE_QUEST_TEST) {
    require("系统.12．测试系统.任务测试");
  }

  // 模拟商店测试
  if (ENABLE_SHOP_TEST) {
    require("系统.12．测试系统.模拟商店");
  }

  // 测试233注册
  if (ENABLE_TEST_233) {
    require("系统.12．测试系统.测试233注册");
  }

  // 测试事件
  if (ENABLE_TEST_EVENT) {
    require("系统.12．测试系统.测试事件");
  }

  // 测试事件2
  if (ENABLE_TEST_EVENT_2) {
    require("系统.12．测试系统.测试事件2");
  }
}

// 立即加载测试
loadTests();

export {};
