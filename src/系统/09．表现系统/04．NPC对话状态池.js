/**
 * NPC对话状态池
 * 管理NPC占用状态、气泡特效、对话结束回调等全局同步状态
 */
const jass = require("jass.common");
/** 最大支持玩家数 */
const MAX_PLAYERS = 28;
/** 气泡特效路径 */
const BUBBLE_EFFECT_PATH = "resource\\models\\qipao.mdx";
// ────────────────────────────────────────────────
// 全局状态
// ────────────────────────────────────────────────
/** 每个玩家的对话框结束回调（由 setDialogFinishCallback 注册） */
const g_finishCallbacks = [];
/** 当前活跃对话框的玩家ID（用于同步点击事件） */
let g_activePlayerId = -1;
/** 每个玩家的气泡特效句柄 */
const g_bubbleEffects = [];
/** 每个玩家的NPC单位（用于创建气泡特效） */
const g_npcUnits = [];
/** NPC占用表：记录每个NPC单位当前被哪个玩家占用（-1表示空闲） */
const g_npcOccupiedBy = new Map();
// ────────────────────────────────────────────────
// Dz API 安全调用封装
// ────────────────────────────────────────────────
function dzGetPlayerId(p) {
    return typeof jass.GetPlayerId === "function" ? jass.GetPlayerId(p) : -1;
}
function dzPlayer(index) {
    return typeof jass.Player === "function" ? jass.Player(index) : null;
}
// ────────────────────────────────────────────────
// 气泡特效（全局同步）
// ────────────────────────────────────────────────
/**
 * 创建气泡特效（全局同步）
 * @param playerId 玩家ID
 * @param npcUnit NPC单位
 */
export function createBubbleEffect(playerId, npcUnit) {
    // 删除已有特效
    destroyBubbleEffect(playerId);
    // 保存NPC单位
    g_npcUnits[playerId] = npcUnit;
    // 创建新特效（全局同步，不在本地判断内）
    if (npcUnit && typeof jass.AddSpecialEffectTarget === "function") {
        const effect = jass.AddSpecialEffectTarget(BUBBLE_EFFECT_PATH, npcUnit, "overhead");
        g_bubbleEffects[playerId] = effect;
    }
}
/**
 * 删除气泡特效（全局同步）
 * @param playerId 玩家ID
 */
export function destroyBubbleEffect(playerId) {
    const effect = g_bubbleEffects[playerId];
    if (effect && typeof jass.DestroyEffect === "function") {
        jass.DestroyEffect(effect);
    }
    g_bubbleEffects[playerId] = undefined;
    // 注意：g_npcUnits[playerId] 在 releaseNpcOccupation 之后清除
}
/**
 * 释放NPC占用（全局同步）
 * @param playerId 玩家ID
 */
export function releaseNpcOccupation(playerId) {
    const npcUnit = g_npcUnits[playerId];
    if (npcUnit) {
        // 只有当这个NPC被当前玩家占用时才释放
        if (g_npcOccupiedBy.get(npcUnit) === playerId) {
            g_npcOccupiedBy.delete(npcUnit);
        }
    }
    // 清除NPC单位引用
    g_npcUnits[playerId] = undefined;
}
/**
 * 获取玩家的NPC单位
 * @param playerId 玩家ID
 */
export function getNpcUnit(playerId) {
    return g_npcUnits[playerId];
}
// ────────────────────────────────────────────────
// 活跃玩家ID管理
// ────────────────────────────────────────────────
/**
 * 设置当前活跃对话框的玩家ID
 * @param playerId 玩家ID
 */
export function setActivePlayerId(playerId) {
    g_activePlayerId = playerId;
}
/**
 * 获取当前活跃对话框的玩家ID
 * @returns 玩家ID，如果没有则返回 -1
 */
export function getActivePlayerId() {
    return g_activePlayerId;
}
/**
 * 重置活跃玩家ID（如果当前是指定玩家）
 * @param playerId 玩家ID
 */
export function resetActivePlayerIdIfMatch(playerId) {
    if (g_activePlayerId === playerId) {
        g_activePlayerId = -1;
    }
}
// ────────────────────────────────────────────────
// 结束回调管理
// ────────────────────────────────────────────────
/**
 * 注册对话队列全部播完后的回调
 * @param playerId 玩家ID
 * @param callback 回调函数
 */
export function setFinishCallback(playerId, callback) {
    if (playerId < 0 || playerId >= MAX_PLAYERS)
        return;
    g_finishCallbacks[playerId] = callback;
}
/**
 * 触发并清除结束回调
 * @param playerId 玩家ID
 */
export function triggerFinishCallback(playerId) {
    if (playerId < 0 || playerId >= MAX_PLAYERS)
        return;
    const cb = g_finishCallbacks[playerId];
    if (cb) {
        g_finishCallbacks[playerId] = undefined;
        cb();
    }
}
// ────────────────────────────────────────────────
// NPC占用管理
// ────────────────────────────────────────────────
/**
 * 检查NPC是否被其他玩家占用
 * @param npcUnit NPC单位句柄
 * @returns 如果被占用返回占用者玩家ID，否则返回 -1
 */
export function isNpcOccupied(npcUnit) {
    if (!npcUnit)
        return -1;
    return g_npcOccupiedBy.get(npcUnit) ?? -1;
}
/**
 * 尝试占用NPC进行对话
 * @param p 目标玩家
 * @param npcUnit NPC单位句柄
 * @returns 如果成功占用返回 true，如果已被其他玩家占用返回 false
 */
export function tryOccupyNpc(p, npcUnit) {
    if (!npcUnit)
        return false;
    const pid = dzGetPlayerId(p);
    if (pid < 0 || pid >= MAX_PLAYERS)
        return false;
    // 检查是否已被其他玩家占用
    const occupiedBy = g_npcOccupiedBy.get(npcUnit);
    if (occupiedBy !== undefined && occupiedBy !== pid) {
        return false; // 已被其他玩家占用
    }
    // 占用NPC
    g_npcOccupiedBy.set(npcUnit, pid);
    g_npcUnits[pid] = npcUnit;
    return true;
}
/**
 * 设置对话框关联的NPC单位（用于显示气泡特效）
 * @param p 目标玩家
 * @param npcUnit NPC单位句柄
 */
export function setDialogNpcUnit(p, npcUnit) {
    const pid = dzGetPlayerId(p);
    if (pid < 0 || pid >= MAX_PLAYERS)
        return;
    g_npcUnits[pid] = npcUnit;
}
