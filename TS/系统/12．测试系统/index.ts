/**
 * 测试系统统一入口
 *
 * 通过开关控制是否加载各个测试模块。
 */

import { 测试系统总开关 } from "./00．测试系统开关";

const ENABLE_STES_EVENT_TEST = false;
const ENABLE_YDLOCAL_TEST = false;
const ENABLE_TEST_EVENT = false;
const ENABLE_GOLD_BURST_TEST = true;
const ENABLE_BROADCAST_HINT_TEST = true;
const ENABLE_BOSS_REWARD_SELECTION_TEST = true;
const ENABLE_THRANDUIL_BOSS_SKILL_TEST = true;
const ENABLE_DAMAGE_NUMBER_PREFIX_MODEL_TEST = true;
const ENABLE_BALZAROTH_BOSS_SKILL_TEST = true;
const ENABLE_PHOENIXEL_BOSS_SKILL_TEST = true;
const ENABLE_MIA_BOSS_SKILL_TEST = true;
const ENABLE_TREE_LORD_BOSS_SKILL_TEST = true;
const ENABLE_AINZ_BOSS_SKILL_TEST = true;
const ENABLE_SHALLTEAR_BOSS_SKILL_TEST = true;
const ENABLE_ARONKOS_BOSS_SKILL_TEST = true;
const ENABLE_OGRE_BOSS_SKILL_TEST = true;
const ENABLE_GOBLIN_PRIEST_BOSS_SKILL_TEST = true;
const ENABLE_LIR_BOSS_SKILL_TEST = true;
const ENABLE_MASKED_SWORDSMAN_BOSS_SKILL_TEST = true;
const ENABLE_MASKED_SCHOLAR_BOSS_SKILL_TEST = true;
const ENABLE_ANCESTRAL_TWIN_GUARDS_BOSS_SKILL_TEST = true;
const ENABLE_LATER_BOSS_SKILL_TEST = true;
const ENABLE_PASSIVE_ITEM_COOLDOWN_UI_TEST = true;
const ENABLE_EXTERNAL_VOICE_PACK_TEST = true;
const ENABLE_BOSS_DUAL_HEALTH_BAR_TEST = true;
const ENABLE_LOBSTER_GUARD_DROP_TEST = true;
const ENABLE_BONE_SPEAR_EFFECT_TEST = true;
const ENABLE_BOSS_3D_SOUND_TEST = true;
const ENABLE_SERA_BARE_CREATE_TEST = true;
const ENABLE_MAIN_PROGRESS_TEST = true;
const ENABLE_FULL_MAP_DYNAMIC_BGM_TEST = true;
const ENABLE_EXILED_WATER_MONSTER_ENTRY_TEST = true;
const ENABLE_MORTES_ENTRY_REQUIREMENT_TEST = true;
const ENABLE_SEAL_GUARD_ENEMY_SKILL_TEST = true;
const ENABLE_PLAYER_HERO_REGISTRATION_TEST = true;
const ENABLE_TEST_PLAYER_WHITELIST_UNLOCK = true;
const ENABLE_HERO_LEVEL_LOOP_TEST = true;
const ENABLE_ITEM_SCORE_TEST = true;
const ENABLE_HERO_COOLDOWN_RESET_TEST = true;
const ENABLE_SAKAI_D_SNAKE_EFFECT_TEST = true;
const ENABLE_CREATE_PLAYER_HERO_BY_NAME_TEST = true;

function loadTests(): void {
  // 主线进度指令作为独立调试入口保留，避免打开总开关时连带启动其他测试。
  if (ENABLE_MAIN_PROGRESS_TEST) {
    require("系统.12．测试系统.20．主线进度测试");
  }

  if (!测试系统总开关) return;

  if (ENABLE_FULL_MAP_DYNAMIC_BGM_TEST) {
    require("系统.12．测试系统.21．全图动态BGM测试");
  }

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

  if (ENABLE_OGRE_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.01．Boss测试.01．主线Boss.08．食人魔Boss技能测试");
  }

  if (ENABLE_GOBLIN_PRIEST_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.01．Boss测试.01．主线Boss.09．地精祭祀Boss技能测试");
  }

  if (ENABLE_LIR_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.01．Boss测试.01．主线Boss.10．利尔伯特Boss技能测试");
  }

  if (ENABLE_MASKED_SWORDSMAN_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.01．Boss测试.01．主线Boss.11．教派剑士Boss技能测试");
  }

  if (ENABLE_MASKED_SCHOLAR_BOSS_SKILL_TEST) {
    require("系统.12．测试系统.01．Boss测试.01．主线Boss.12．教派学者Boss技能测试");
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

  if (ENABLE_LOBSTER_GUARD_DROP_TEST) {
    require("系统.12．测试系统.01．Boss测试.16．龙虾守卫掉落测试");
  }

  if (ENABLE_BONE_SPEAR_EFFECT_TEST) {
    require("系统.12．测试系统.16．骸骨弹幕附加特效测试");
  }

  if (ENABLE_BOSS_3D_SOUND_TEST) {
    require("系统.12．测试系统.17．Boss音效3D播放测试");
  }

  if (ENABLE_SERA_BARE_CREATE_TEST) {
    require("系统.12．测试系统.18．塞拉裸创建测试");
  }

  if (ENABLE_EXILED_WATER_MONSTER_ENTRY_TEST) {
    require("系统.12．测试系统.22．被驱逐的水怪入口测试");
  }

  if (ENABLE_MORTES_ENTRY_REQUIREMENT_TEST) {
    require("系统.12．测试系统.23．莫特斯进入条件测试");
  }

  if (ENABLE_SEAL_GUARD_ENEMY_SKILL_TEST) {
    require("系统.12．测试系统.24．封印守卫战敌人技能测试");
  }

  if (ENABLE_PLAYER_HERO_REGISTRATION_TEST) {
    require("系统.12．测试系统.25．玩家英雄注册测试");
  }

  if (ENABLE_TEST_PLAYER_WHITELIST_UNLOCK) {
    require("系统.12．测试系统.26．测试玩家白名单解锁");
  }

  if (ENABLE_HERO_LEVEL_LOOP_TEST) {
    require("系统.12．测试系统.27．英雄循环升级测试");
  }

  if (ENABLE_ITEM_SCORE_TEST) {
    require("系统.12．测试系统.19．物品评分测试");
  }

  if (ENABLE_HERO_COOLDOWN_RESET_TEST) {
    require("系统.12．测试系统.28．重置玩家英雄技能冷却测试");
  }

  if (ENABLE_SAKAI_D_SNAKE_EFFECT_TEST) {
    require("系统.12．测试系统.29．坂井悠二D蛇特效测试");
  }

  if (ENABLE_CREATE_PLAYER_HERO_BY_NAME_TEST) {
    require("系统.12．测试系统.30．按名称创建玩家英雄测试");
  }

  // QWERD 显示排查：聊天输入 -dc 转储命令卡槽位与快照（排查 20-25 英雄 D 技能显示）
  require("系统.12．测试系统.40．QWERD显示调试命令");

}

loadTests();

export {};
