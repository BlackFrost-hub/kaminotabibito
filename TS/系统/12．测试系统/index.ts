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
const ENABLE_AINZ_BOSS_SKILL_TEST = true;
const ENABLE_SHALLTEAR_BOSS_SKILL_TEST = true;
const ENABLE_ARONKOS_BOSS_SKILL_TEST = true;
const ENABLE_ANCESTRAL_TWIN_GUARDS_BOSS_SKILL_TEST = true;
const ENABLE_LATER_BOSS_SKILL_TEST = true;
const ENABLE_PASSIVE_ITEM_COOLDOWN_UI_TEST = true;
const ENABLE_EXTERNAL_VOICE_PACK_TEST = true;
const ENABLE_BOSS_DUAL_HEALTH_BAR_TEST = true;
const ENABLE_BONE_SPEAR_EFFECT_TEST = true;
const ENABLE_BOSS_3D_SOUND_TEST = true;

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
    require("系统.12．测试系统.01．Boss测试.01．主线Boss.07．瑟兰迪尔Boss技能测试");
  }

  if (ENABLE_DAMAGE_NUMBER_PREFIX_MODEL_TEST) {
    require("系统.12．测试系统.07．伤害数字前缀模型测试");
  }

  if (ENABLE_BALZAROTH_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.01．Boss测试.01．主线Boss.01．巴尔扎罗斯Boss技能测试");
  }

  if (ENABLE_PHOENIXEL_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.01．Boss测试.01．主线Boss.02．菲尼克斯尔Boss技能测试");
  }

  if (ENABLE_MIA_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.01．Boss测试.02．挑战与隐藏Boss.01．米亚Boss技能测试");
  }

  if (ENABLE_TREE_LORD_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.01．Boss测试.01．主线Boss.03．树魔首领Boss技能测试");
  }

  if (ENABLE_AINZ_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.01．Boss测试.03．异界Boss.01．安兹乌尔恭Boss技能测试");
  }

  if (ENABLE_SHALLTEAR_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.01．Boss测试.03．异界Boss.02．夏提雅Boss技能测试");
  }

  if (ENABLE_ARONKOS_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.01．Boss测试.01．主线Boss.06．亚伦柯斯Boss技能测试");
  }

  if (ENABLE_ANCESTRAL_TWIN_GUARDS_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.01．Boss测试.02．挑战与隐藏Boss.05．祖地双灵卫Boss技能测试");
  }

  if (ENABLE_LATER_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.01．Boss测试.01．主线Boss.04．菲利斯Boss技能测试");
    require("系统.12．测试系统.01．Boss测试.01．主线Boss.05．里科特Boss技能测试");
    require("系统.12．测试系统.01．Boss测试.02．挑战与隐藏Boss.02．卡瑟拉Boss技能测试");
    require("系统.12．测试系统.01．Boss测试.02．挑战与隐藏Boss.03．莫尔特斯Boss技能测试");
    require("系统.12．测试系统.01．Boss测试.02．挑战与隐藏Boss.04．影骨莫特斯Boss技能测试");
  }

  if (ENABLE_PASSIVE_ITEM_COOLDOWN_UI_TEST) {
    require("系统.12．测试系统.13．物品栏被动冷却UI测试");
  }

  if (ENABLE_EXTERNAL_VOICE_PACK_TEST) {
    require("系统.12．测试系统.14．外置语音包测试");
  }

  if (ENABLE_BOSS_DUAL_HEALTH_BAR_TEST) {
    require("系统.12．测试系统.01．Boss测试.15．Boss双血条测试");
  }

  if (ENABLE_BONE_SPEAR_EFFECT_TEST) {
    require("系统.12．测试系统.16．骸骨弹幕附加特效测试");
  }

  if (ENABLE_BOSS_3D_SOUND_TEST) {
    require("系统.12．测试系统.17．Boss音效3D播放测试");
  }

}

loadTests();

export {};
