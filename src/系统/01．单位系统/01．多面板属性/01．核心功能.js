/**
 * 多面板属性系统 - 核心功能
 *
 * 功能：创建多面板、定时刷新属性显示
 * 后续接手者：开关 MULTIBOARD_SYSTEM_ENABLED 在常量文件
 */
const jass = require("jass.common");
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.index");
import { MULTIBOARD_SYSTEM_ENABLED, MULTIBOARD_ROWS, MULTIBOARD_COLS, DISPLAY_PLAYER_COUNT, } from "./00．常量定义";
const { getGameTimeFormatted, getGameDifficulty, onTick10ms } = globalThis;
const { YDUserDataGet, YDUserDataSet } = require("lib.扩展函数.YDWE函数.index");
const { forEachUnitInGroup } = require("lib.扩展函数.封装函数.01．通用工具.index");
// ==========================================================================================
// 类型定义
// ==========================================================================================
/** 多面板数组（索引0-4对应玩家1-5，让TSTL自动处理+1转换） */
let multiboards = [];
/** 是否已初始化 */
let _initialized = false;
/** 是否已注册到中心计时器 */
let _registered = false;
/** 刷新计数器（每50个10毫秒=0.5秒刷新一次） */
let _refreshCounter = 0;
// ==========================================================================================
// BJ函数实现（避免依赖BJ函数）
// ==========================================================================================
/** 设置多面板项目值 */
function multiboardSetItemValue(mb, col, row, val) {
    if (mb == null)
        return;
    const item = jass.MultiboardGetItem(mb, row - 1, col - 1);
    if (item != null) {
        jass.MultiboardSetItemValue(item, val);
        jass.MultiboardReleaseItem(item);
    }
}
/** 设置多面板项目图标 */
function multiboardSetItemIcon(mb, col, row, icon) {
    if (mb == null)
        return;
    const item = jass.MultiboardGetItem(mb, row - 1, col - 1);
    if (item != null) {
        jass.MultiboardSetItemIcon(item, icon);
        jass.MultiboardReleaseItem(item);
    }
}
/** 设置多面板项目样式 */
function multiboardSetItemStyle(mb, col, row, showValue, showIcon) {
    if (mb == null)
        return;
    const item = jass.MultiboardGetItem(mb, row - 1, col - 1);
    if (item != null) {
        jass.MultiboardSetItemStyle(item, showValue, showIcon);
        jass.MultiboardReleaseItem(item);
    }
}
// ==========================================================================================
// 工具函数
// ==========================================================================================
/** 获取玩家属性值 */
function getPlayerAttr(playerId, attrName) {
    const player = jass.Player(playerId - 1); // 0-based 索引
    if (player == null)
        return 0;
    const value = YDUserDataGet("player", player, attrName, "real");
    return typeof value === "number" ? value : 0;
}
/** 格式化百分比 */
function formatPercent(value) {
    const pct = jass.R2I(value * 100 + 0.5);
    return pct.toString() + "%";
}
/** 格式化数值 */
function formatNumber(value) {
    return jass.R2I(value + 0.5).toString();
}
/** 格式化实数（保留小数） */
function formatReal(value) {
    return value.toFixed(2);
}
// ==========================================================================================
// 属性显示函数
// ==========================================================================================
/** 更新多面板显示 */
function updateMultiboard(mb, playerId) {
    if (mb == null)
        return;
    // 从中心计时器获取游戏时间
    const { hours: timeH, minutes: timeM, seconds: timeS } = getGameTimeFormatted();
    const difficulty = getGameDifficulty();
    // 设置标题
    const title = `属性面板（难度：${difficulty}）游戏时间：${timeH}小时${timeM}分${timeS}秒`;
    jass.MultiboardSetTitleText(mb, title);
    // 第1行：物理伤害/护甲穿透
    const physDmg = 100 + getPlayerAttr(playerId, "物理伤害") * 100;
    const physResist = 100 - getPlayerAttr(playerId, "物理抗性") * 100;
    multiboardSetItemValue(mb, 1, 1, `物理伤害：${formatPercent(physDmg / 100)}/${formatPercent(physResist / 100)}`);
    const armorPierce = getPlayerAttr(playerId, "护甲穿透") * 100;
    multiboardSetItemValue(mb, 2, 1, `护甲穿透：${formatPercent(armorPierce / 100)}`);
    // 第1行：魔法伤害/魔法穿透
    const magicDmg = 100 + getPlayerAttr(playerId, "魔法伤害") * 100;
    const magicResist = 100 - getPlayerAttr(playerId, "魔抗") * 100;
    multiboardSetItemValue(mb, 3, 1, `魔法伤害：${formatPercent(magicDmg / 100)}/${formatPercent(magicResist / 100)}`);
    const magicPierce = getPlayerAttr(playerId, "魔法穿透") * 100;
    multiboardSetItemValue(mb, 4, 1, `魔法穿透：${formatPercent(magicPierce / 100)}`);
    // 第2行：技能伤害/强化伤害/召唤物伤害
    const skillDmg = 100 + getPlayerAttr(playerId, "技能伤害") * 100;
    const skillResist = 100 - getPlayerAttr(playerId, "技能抗性") * 100;
    multiboardSetItemValue(mb, 2, 2, `技能伤害：${formatPercent(skillDmg / 100)}/${formatPercent(skillResist / 100)}`);
    const enhanceDmg = 100 + getPlayerAttr(playerId, "强化伤害") * 100;
    const enhanceResist = 100 - getPlayerAttr(playerId, "强化抗性") * 100;
    multiboardSetItemValue(mb, 3, 2, `强化伤害：${formatPercent(enhanceDmg / 100)}/${formatPercent(enhanceResist / 100)}`);
    const summonDmg = 100 + getPlayerAttr(playerId, "召唤物伤害") * 100;
    const summonResist = 100 - getPlayerAttr(playerId, "召唤物抗性") * 100;
    multiboardSetItemValue(mb, 4, 2, `召唤物伤害：${formatPercent(summonDmg / 100)}/${formatPercent(summonResist / 100)}`);
    // 第3行：元素属性（金/风/冰）
    const metalDmg = 100 + getPlayerAttr(playerId, "金属性伤害") * 100;
    const metalResist = 100 - getPlayerAttr(playerId, "金属性抗性") * 100;
    multiboardSetItemValue(mb, 1, 3, `金属性伤害：${formatPercent(metalDmg / 100)}/${formatPercent(metalResist / 100)}`);
    const woodDmg = 100 + getPlayerAttr(playerId, "木属性伤害") * 100;
    const woodResist = 100 - getPlayerAttr(playerId, "木属性抗性") * 100;
    multiboardSetItemValue(mb, 2, 3, `风属性伤害：${formatPercent(woodDmg / 100)}/${formatPercent(woodResist / 100)}`);
    const waterDmg = 100 + getPlayerAttr(playerId, "水属性伤害") * 100;
    const waterResist = 100 - getPlayerAttr(playerId, "水属性抗性") * 100;
    multiboardSetItemValue(mb, 3, 3, `冰属性伤害：${formatPercent(waterDmg / 100)}/${formatPercent(waterResist / 100)}`);
    const fireDmg = 100 + getPlayerAttr(playerId, "火属性伤害") * 100;
    const fireResist = 100 - getPlayerAttr(playerId, "火属性抗性") * 100;
    multiboardSetItemValue(mb, 4, 3, `火属性伤害：${formatPercent(fireDmg / 100)}/${formatPercent(fireResist / 100)}`);
    // 第4行：元素属性（土/雷/光/暗）
    const earthDmg = 100 + getPlayerAttr(playerId, "土属性伤害") * 100;
    const earthResist = 100 - getPlayerAttr(playerId, "土属性抗性") * 100;
    multiboardSetItemValue(mb, 1, 4, `土属性伤害：${formatPercent(earthDmg / 100)}/${formatPercent(earthResist / 100)}`);
    const thunderDmg = 100 + getPlayerAttr(playerId, "雷属性伤害") * 100;
    const thunderResist = 100 - getPlayerAttr(playerId, "雷属性抗性") * 100;
    multiboardSetItemValue(mb, 2, 4, `雷属性伤害：${formatPercent(thunderDmg / 100)}/${formatPercent(thunderResist / 100)}`);
    const lightDmg = 100 + getPlayerAttr(playerId, "光属性伤害") * 100;
    const lightResist = 100 - getPlayerAttr(playerId, "光属性抗性") * 100;
    multiboardSetItemValue(mb, 3, 4, `光属性伤害：${formatPercent(lightDmg / 100)}/${formatPercent(lightResist / 100)}`);
    const darkDmg = 100 + getPlayerAttr(playerId, "暗属性伤害") * 100;
    const darkResist = 100 - getPlayerAttr(playerId, "暗属性抗性") * 100;
    multiboardSetItemValue(mb, 4, 4, `暗属性伤害：${formatPercent(darkDmg / 100)}/${formatPercent(darkResist / 100)}`);
    // 第5行：暴击
    const critRate = getPlayerAttr(playerId, "暴击率") * 100;
    multiboardSetItemValue(mb, 1, 5, `暴击率：${formatPercent(critRate / 100)}`);
    const critDmg = 150 + getPlayerAttr(playerId, "暴击伤害") * 100;
    multiboardSetItemValue(mb, 2, 5, `暴击伤害：${formatPercent(critDmg / 100)}`);
    const critTaken = getPlayerAttr(playerId, "被暴击率") * 100;
    multiboardSetItemValue(mb, 3, 5, `被暴击率：-${formatPercent(critTaken / 100)}`);
    const critDmgTaken = getPlayerAttr(playerId, "被暴击伤害") * 100;
    multiboardSetItemValue(mb, 4, 5, `被暴击伤害：-${formatPercent(critDmgTaken / 100)}`);
    // 第6行：命中/闪避/冷却/伤害减少
    const accuracy = 100 + getPlayerAttr(playerId, "命中率") * 100;
    multiboardSetItemValue(mb, 1, 6, `命中率：${formatPercent(accuracy / 100)}`);
    const dodge = getPlayerAttr(playerId, "闪避率") * 100;
    multiboardSetItemValue(mb, 2, 6, `闪避率：${formatPercent(dodge / 100)}`);
    const cdReduction = getPlayerAttr(playerId, "冷却缩减") * 100;
    multiboardSetItemValue(mb, 3, 6, `冷却缩减：${formatPercent(cdReduction / 100)}`);
    const dmgReduction = getPlayerAttr(playerId, "伤害减少");
    multiboardSetItemValue(mb, 4, 6, `伤害固定减少：${formatNumber(dmgReduction)}`);
    // 第7行：攻速/移速/眩晕抗性
    const atkSpeed = getPlayerAttr(playerId, "每秒攻速") || 1;
    multiboardSetItemValue(mb, 1, 7, `攻击速度：${formatReal(atkSpeed)}次/秒`);
    const moveSpeed = getPlayerAttr(playerId, "移动速度") || 0;
    multiboardSetItemValue(mb, 2, 7, `移动速度：${formatReal(moveSpeed)}`);
    const stunResist = getPlayerAttr(playerId, "眩晕抗性") * 100;
    multiboardSetItemValue(mb, 3, 7, `眩晕抗性：${formatPercent(stunResist / 100)}`);
    // 第8行：吸血
    const atkLifesteal = getPlayerAttr(playerId, "普攻伤害吸血") * 100;
    multiboardSetItemValue(mb, 1, 8, `普攻伤害吸血：${formatPercent(atkLifesteal / 100)}`);
    const magicLifesteal = getPlayerAttr(playerId, "魔法伤害吸血") * 100;
    multiboardSetItemValue(mb, 2, 8, `魔法伤害吸血：${formatPercent(magicLifesteal / 100)}`);
    const lifesteal = getPlayerAttr(playerId, "伤害吸血") * 100;
    multiboardSetItemValue(mb, 3, 8, `伤害吸血：${formatPercent(lifesteal / 100)}`);
    // 第9行：生命恢复
    const totalHpRegen = getPlayerAttr(playerId, "总生命恢复");
    multiboardSetItemValue(mb, 1, 9, `当前生命恢复：${formatNumber(totalHpRegen)}/秒`);
    const baseHpRegen = getPlayerAttr(playerId, "生命恢复");
    multiboardSetItemValue(mb, 2, 9, `基础生命恢复：${formatNumber(baseHpRegen)}/秒`);
    const pctHpRegen = getPlayerAttr(playerId, "生命恢复%") * 100;
    multiboardSetItemValue(mb, 3, 9, `百分比生命恢复：${formatPercent(pctHpRegen / 100)}/秒`);
    const hpRegenEff = getPlayerAttr(playerId, "生命恢复效率") * 100;
    multiboardSetItemValue(mb, 4, 9, `生命恢复效率：${formatPercent(hpRegenEff / 100)}`);
    // 第10行：治疗
    const skillHeal = 100 + getPlayerAttr(playerId, "技能治疗率") * 100;
    multiboardSetItemValue(mb, 1, 10, `技能治疗效率：${formatPercent(skillHeal / 100)}`);
    const healReceived = 100 + getPlayerAttr(playerId, "受到的治疗率") * 100;
    multiboardSetItemValue(mb, 2, 10, `受到治疗效率：${formatPercent(healReceived / 100)}`);
    // 第11行：魔法恢复
    const totalMpRegen = getPlayerAttr(playerId, "总魔法恢复");
    multiboardSetItemValue(mb, 1, 11, `当前魔法恢复：${formatNumber(totalMpRegen)}/秒`);
    const baseMpRegen = getPlayerAttr(playerId, "魔法恢复");
    multiboardSetItemValue(mb, 2, 11, `基础魔法恢复：${formatNumber(baseMpRegen)}/秒`);
    const pctMpRegen = getPlayerAttr(playerId, "魔法恢复%") * 100;
    multiboardSetItemValue(mb, 3, 11, `百分比魔法恢复：${formatPercent(pctMpRegen / 100)}/秒`);
    const mpCost = getPlayerAttr(playerId, "魔法消耗") * 100;
    multiboardSetItemValue(mb, 4, 11, `技能消耗减少：${formatPercent(mpCost / 100)}`);
}
/** 更新玩家攻速和移速 */
function updatePlayerSpeed(playerId) {
    const heroGroup = YDUserDataGet("string", "玩家英雄", "单位组", "group");
    if (heroGroup == null)
        return;
    const player = jass.Player(playerId - 1); // 0-based 索引
    let foundUnit = null;
    forEachUnitInGroup(heroGroup, (u) => {
        if (u != null && jass.GetOwningPlayer(u) === player) {
            foundUnit = u;
        }
    });
    if (foundUnit == null)
        return;
    // 计算攻速
    const attackInterval = jass.GetUnitState(foundUnit, jass.ConvertUnitState(0x25));
    const attacksPerSec = attackInterval > 0 ? 1 / attackInterval : 0;
    // 获取移速
    const moveSpeed = jass.GetUnitMoveSpeed(foundUnit);
    // 存储到玩家属性
    YDUserDataSet("player", player, "每秒攻速", "real", attacksPerSec);
    YDUserDataSet("player", player, "移动速度", "real", moveSpeed);
}
// ==========================================================================================
// 刷新回调（使用中心计时器）
// ==========================================================================================
/** 每10毫秒回调，每50次（0.5秒）执行一次刷新 */
function onRefreshTick() {
    _refreshCounter = _refreshCounter + 1;
    if (_refreshCounter >= 50) { // 50 * 10ms = 500ms = 0.5秒
        _refreshCounter = 0;
        onRefresh();
    }
}
/** 执行刷新 */
function onRefresh() {
    for (let i = 0; i < DISPLAY_PLAYER_COUNT; i++) {
        const mb = multiboards[i];
        if (mb == null)
            continue;
        if (!jass.IsMultiboardDisplayed(mb))
            continue;
        updatePlayerSpeed(i + 1); // 玩家ID从1开始
        updateMultiboard(mb, i + 1);
    }
}
// ==========================================================================================
// 创建多面板
// ==========================================================================================
/** 创建单个多面板 */
function createMultiboard(playerId) {
    const player = jass.Player(playerId - 1);
    // 检查玩家是否在线
    const slotState = jass.GetPlayerSlotState(player);
    const PLAYER_SLOT_STATE_PLAYING = jass.PLAYER_SLOT_STATE_PLAYING;
    if (slotState !== PLAYER_SLOT_STATE_PLAYING) {
        return null;
    }
    const mb = jass.CreateMultiboard();
    if (mb == null)
        return null;
    // 设置基本属性
    jass.MultiboardSetTitleText(mb, "属性面板");
    jass.MultiboardSetTitleTextColor(mb, 255, 215, 0, 255);
    jass.MultiboardSetItemsWidth(mb, 0.08);
    jass.MultiboardSetRowCount(mb, MULTIBOARD_ROWS);
    jass.MultiboardSetColumnCount(mb, MULTIBOARD_COLS);
    // 设置初始值（空字符串，后续由刷新计时器更新）
    for (let row = 1; row <= MULTIBOARD_ROWS; row++) {
        for (let col = 1; col <= MULTIBOARD_COLS; col++) {
            multiboardSetItemValue(mb, col, row, "");
        }
    }
    // 设置图标
    multiboardSetItemIcon(mb, 1, 1, "ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp");
    multiboardSetItemIcon(mb, 2, 1, "ReplaceableTextures\\CommandButtons\\BTNSteelRanged.blp");
    multiboardSetItemIcon(mb, 3, 1, "ReplaceableTextures\\CommandButtons\\BTNNecromancerMaster.blp");
    multiboardSetItemIcon(mb, 4, 1, "ReplaceableTextures\\CommandButtons\\BTNTheBlackArrow.blp");
    multiboardSetItemIcon(mb, 1, 2, "ReplaceableTextures\\CommandButtons\\BTNSteelMelee.blp");
    multiboardSetItemIcon(mb, 2, 2, "ReplaceableTextures\\CommandButtons\\BTNWitchDoctorMaster.blp");
    multiboardSetItemIcon(mb, 3, 2, "ReplaceableTextures\\CommandButtons\\BTNCorpseExplode.blp");
    multiboardSetItemIcon(mb, 4, 2, "ReplaceableTextures\\CommandButtons\\BTNGrizzlyBear.blp");
    multiboardSetItemIcon(mb, 1, 3, "ReplaceableTextures\\CommandButtons\\BTNTransmute.blp");
    multiboardSetItemIcon(mb, 2, 3, "ReplaceableTextures\\CommandButtons\\BTNHumanLumberUpgrade1.blp");
    multiboardSetItemIcon(mb, 3, 3, "ReplaceableTextures\\CommandButtons\\BTNCrushingWave.blp");
    multiboardSetItemIcon(mb, 4, 3, "ReplaceableTextures\\CommandButtons\\BTNFireForTheCannon.blp");
    multiboardSetItemIcon(mb, 1, 4, "ReplaceableTextures\\CommandButtons\\BTNGatherGold.blp");
    multiboardSetItemIcon(mb, 2, 4, "ReplaceableTextures\\CommandButtons\\BTNMonsoon.blp");
    multiboardSetItemIcon(mb, 3, 4, "ReplaceableTextures\\CommandButtons\\BTNResurrection.blp");
    multiboardSetItemIcon(mb, 4, 4, "ReplaceableTextures\\CommandButtons\\BTNSoulGem.blp");
    multiboardSetItemIcon(mb, 1, 5, "ReplaceableTextures\\CommandButtons\\BTNCriticalStrike.blp");
    multiboardSetItemIcon(mb, 2, 5, "ReplaceableTextures\\CommandButtons\\BTNSmash.blp");
    multiboardSetItemIcon(mb, 3, 5, "ReplaceableTextures\\CommandButtons\\BTNHumanArmorUpThree.blp");
    multiboardSetItemIcon(mb, 4, 5, "ReplaceableTextures\\CommandButtons\\BTNLightningShield.blp");
    multiboardSetItemIcon(mb, 1, 6, "ReplaceableTextures\\CommandButtons\\BTNMarksmanship.blp");
    multiboardSetItemIcon(mb, 2, 6, "ReplaceableTextures\\PassiveButtons\\PASBTNEvasion.blp");
    multiboardSetItemIcon(mb, 3, 6, "ReplaceableTextures\\CommandButtons\\BTNStarWand.blp");
    multiboardSetItemIcon(mb, 4, 6, "ReplaceableTextures\\PassiveButtons\\PASBTNResistantSkin.blp");
    multiboardSetItemIcon(mb, 1, 7, "ReplaceableTextures\\CommandButtons\\BTNGlove.blp");
    multiboardSetItemIcon(mb, 2, 7, "ReplaceableTextures\\CommandButtons\\BTNBootsOfSpeed.blp");
    multiboardSetItemIcon(mb, 3, 7, "ReplaceableTextures\\CommandButtons\\BTNStun.blp");
    multiboardSetItemIcon(mb, 1, 8, "ReplaceableTextures\\CommandButtons\\BTNMaskOfDeath.blp");
    multiboardSetItemIcon(mb, 2, 8, "ReplaceableTextures\\CommandButtons\\BTNManaDrain.blp");
    multiboardSetItemIcon(mb, 3, 8, "ReplaceableTextures\\CommandButtons\\BTNDevourMagic.blp");
    multiboardSetItemIcon(mb, 1, 9, "ReplaceableTextures\\CommandButtons\\BTNRejuvenation.blp");
    multiboardSetItemIcon(mb, 2, 9, "ReplaceableTextures\\CommandButtons\\BTNRingSkull.blp");
    multiboardSetItemIcon(mb, 3, 9, "ReplaceableTextures\\CommandButtons\\BTNHealOn.blp");
    multiboardSetItemIcon(mb, 4, 9, "ReplaceableTextures\\CommandButtons\\BTNReplenishHealthOff.blp");
    multiboardSetItemIcon(mb, 1, 10, "ReplaceableTextures\\CommandButtons\\BTNHealingWave.blp");
    multiboardSetItemIcon(mb, 2, 10, "ReplaceableTextures\\CommandButtons\\BTNHealingSpray.blp");
    multiboardSetItemIcon(mb, 1, 11, "ReplaceableTextures\\CommandButtons\\BTNVialFull.blp");
    multiboardSetItemIcon(mb, 2, 11, "ReplaceableTextures\\CommandButtons\\BTNSobiMask.blp");
    multiboardSetItemIcon(mb, 3, 11, "ReplaceableTextures\\CommandButtons\\BTNBrilliance.blp");
    multiboardSetItemIcon(mb, 4, 11, "ReplaceableTextures\\CommandButtons\\BTNPriestAdept.blp");
    // 隐藏部分格子
    multiboardSetItemStyle(mb, 4, 7, true, false);
    multiboardSetItemStyle(mb, 4, 8, true, false);
    multiboardSetItemStyle(mb, 3, 10, true, false);
    multiboardSetItemStyle(mb, 4, 10, true, false);
    // 本地玩家显示
    if (player === jass.GetLocalPlayer()) {
        jass.MultiboardDisplay(mb, true);
    }
    return mb;
}
// ==========================================================================================
// 初始化（使用中心计时器）
// ==========================================================================================
/**
 * 初始化多面板属性系统
 */
export function initMultiboardSystem() {
    if (!MULTIBOARD_SYSTEM_ENABLED)
        return;
    if (_initialized)
        return;
    _initialized = true;
    // 创建多面板（索引0-4对应玩家1-5）
    for (let i = 0; i < DISPLAY_PLAYER_COUNT; i++) {
        multiboards[i] = createMultiboard(i + 1); // 玩家ID从1开始
    }
    // 注册到中心计时器（每0.5秒刷新一次，比原来的3秒更及时）
    registerToCenterTimer();
}
/** 注册到中心计时器 */
function registerToCenterTimer() {
    if (_registered)
        return;
    _registered = true;
    // 注册每10毫秒回调，内部计数每50次执行一次刷新（0.5秒）
    onTick10ms(onRefreshTick);
}
/** 检查系统是否启用 */
export function isMultiboardSystemEnabled() {
    return MULTIBOARD_SYSTEM_ENABLED;
}
/** 延迟初始化（游戏开始后执行） */
function delayedInit() {
    initMultiboardSystem();
}
// 延迟初始化：游戏开始后1秒执行（等待玩家进入游戏）
if (MULTIBOARD_SYSTEM_ENABLED) {
    createDelayedCall(2.0, delayedInit);
}
