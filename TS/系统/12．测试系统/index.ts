/**
 * 测试系统统一入口
 *
 * 通过开关控制是否加载各个测试模块。
 */

const ENABLE_STES_EVENT_TEST = false;
const ENABLE_YDLOCAL_TEST = false;
const ENABLE_TEST_EVENT = false;
const ENABLE_GOLD_BURST_TEST = true;
const ENABLE_BROADCAST_HINT_TEST = true;
const ENABLE_BOSS_REWARD_SELECTION_TEST = false;
const ENABLE_THRANDUIL_BOSS_SKILL_TEST = true;
const ENABLE_DAMAGE_NUMBER_PREFIX_MODEL_TEST = true;
const ENABLE_BALZAROTH_BOSS_SKILL_TEST = true;
const ENABLE_PHOENIXEL_BOSS_SKILL_TEST = true;
const ENABLE_MIA_BOSS_SKILL_TEST = true;
const ENABLE_TREE_LORD_BOSS_SKILL_TEST = true;
const ENABLE_LATER_BOSS_SKILL_TEST = true;

function loadTests(): void {
  if (ENABLE_STES_EVENT_TEST) {
    require("系统.12．测试系统.STES事件测试");
  }

  if (ENABLE_YDLOCAL_TEST) {
    require("系统.12．测试系统.YDLocal返回值测试");
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

  if (ENABLE_BOSS_REWARD_SELECTION_TEST) {
    require("系统.12．测试系统.05．首领奖励选择测试");
  }

  if (ENABLE_THRANDUIL_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.06．瑟兰迪尔Boss技能测试");
  }

  if (ENABLE_DAMAGE_NUMBER_PREFIX_MODEL_TEST) {
    require("系统.12．测试系统.07．伤害数字前缀模型测试");
  }

  if (ENABLE_BALZAROTH_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.08．巴尔扎罗斯Boss技能测试");
  }

  if (ENABLE_PHOENIXEL_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.09．菲尼克斯尔Boss技能测试");
  }

  if (ENABLE_MIA_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.10．米亚Boss技能测试");
  }

  if (ENABLE_TREE_LORD_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.11．树魔首领Boss技能测试");
  }

  if (ENABLE_LATER_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.12．后续Boss技能测试");
  }

}

loadTests();

export {};
