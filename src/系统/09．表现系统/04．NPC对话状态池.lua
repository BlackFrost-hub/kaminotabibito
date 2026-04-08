local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local jass, g_bubbleEffects
--- 删除气泡特效（全局同步）
-- 
-- @param playerId 玩家ID
function ____exports.destroyBubbleEffect(self, playerId)
    local effect = g_bubbleEffects[playerId + 1]
    if effect and type(jass.DestroyEffect) == "function" then
        jass.DestroyEffect(effect)
    end
    g_bubbleEffects[playerId + 1] = nil
end
jass = require("jass.common")
--- 最大支持玩家数
local MAX_PLAYERS = 28
--- 气泡特效路径
local BUBBLE_EFFECT_PATH = "resource\\models\\qipao.mdx"
--- 每个玩家的对话框结束回调（由 setDialogFinishCallback 注册）
local g_finishCallbacks = {}
--- 当前活跃对话框的玩家ID（用于同步点击事件）
local g_activePlayerId = -1
g_bubbleEffects = {}
--- 每个玩家的NPC单位（用于创建气泡特效）
local g_npcUnits = {}
--- NPC占用表：记录每个NPC单位当前被哪个玩家占用（-1表示空闲）
local g_npcOccupiedBy = __TS__New(Map)
local function dzGetPlayerId(self, p)
    return type(jass.GetPlayerId) == "function" and jass.GetPlayerId(p) or -1
end
local function dzPlayer(self, index)
    local ____temp_0
    if type(jass.Player) == "function" then
        ____temp_0 = jass.Player(index)
    else
        ____temp_0 = nil
    end
    return ____temp_0
end
--- 创建气泡特效（全局同步）
-- 
-- @param playerId 玩家ID
-- @param npcUnit NPC单位
function ____exports.createBubbleEffect(self, playerId, npcUnit)
    ____exports.destroyBubbleEffect(nil, playerId)
    g_npcUnits[playerId + 1] = npcUnit
    if npcUnit and type(jass.AddSpecialEffectTarget) == "function" then
        local effect = jass.AddSpecialEffectTarget(BUBBLE_EFFECT_PATH, npcUnit, "overhead")
        g_bubbleEffects[playerId + 1] = effect
    end
end
--- 释放NPC占用（全局同步）
-- 
-- @param playerId 玩家ID
function ____exports.releaseNpcOccupation(self, playerId)
    local npcUnit = g_npcUnits[playerId + 1]
    if npcUnit then
        if g_npcOccupiedBy:get(npcUnit) == playerId then
            g_npcOccupiedBy:delete(npcUnit)
        end
    end
    g_npcUnits[playerId + 1] = nil
end
--- 获取玩家的NPC单位
-- 
-- @param playerId 玩家ID
function ____exports.getNpcUnit(self, playerId)
    return g_npcUnits[playerId + 1]
end
--- 设置当前活跃对话框的玩家ID
-- 
-- @param playerId 玩家ID
function ____exports.setActivePlayerId(self, playerId)
    g_activePlayerId = playerId
end
--- 获取当前活跃对话框的玩家ID
-- 
-- @returns 玩家ID，如果没有则返回 -1
function ____exports.getActivePlayerId(self)
    return g_activePlayerId
end
--- 重置活跃玩家ID（如果当前是指定玩家）
-- 
-- @param playerId 玩家ID
function ____exports.resetActivePlayerIdIfMatch(self, playerId)
    if g_activePlayerId == playerId then
        g_activePlayerId = -1
    end
end
--- 注册对话队列全部播完后的回调
-- 
-- @param playerId 玩家ID
-- @param callback 回调函数
function ____exports.setFinishCallback(self, playerId, callback)
    if playerId < 0 or playerId >= MAX_PLAYERS then
        return
    end
    g_finishCallbacks[playerId + 1] = callback
end
--- 触发并清除结束回调
-- 
-- @param playerId 玩家ID
function ____exports.triggerFinishCallback(self, playerId)
    if playerId < 0 or playerId >= MAX_PLAYERS then
        return
    end
    local cb = g_finishCallbacks[playerId + 1]
    if cb then
        g_finishCallbacks[playerId + 1] = nil
        cb(nil)
    end
end
--- 检查NPC是否被其他玩家占用
-- 
-- @param npcUnit NPC单位句柄
-- @returns 如果被占用返回占用者玩家ID，否则返回 -1
function ____exports.isNpcOccupied(self, npcUnit)
    if not npcUnit then
        return -1
    end
    return g_npcOccupiedBy:get(npcUnit) or -1
end
--- 尝试占用NPC进行对话
-- 
-- @param p 目标玩家
-- @param npcUnit NPC单位句柄
-- @returns 如果成功占用返回 true，如果已被其他玩家占用返回 false
function ____exports.tryOccupyNpc(self, p, npcUnit)
    if not npcUnit then
        return false
    end
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return false
    end
    local occupiedBy = g_npcOccupiedBy:get(npcUnit)
    if occupiedBy ~= nil and occupiedBy ~= pid then
        return false
    end
    g_npcOccupiedBy:set(npcUnit, pid)
    g_npcUnits[pid + 1] = npcUnit
    return true
end
--- 设置对话框关联的NPC单位（用于显示气泡特效）
-- 
-- @param p 目标玩家
-- @param npcUnit NPC单位句柄
function ____exports.setDialogNpcUnit(self, p, npcUnit)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    g_npcUnits[pid + 1] = npcUnit
end
return ____exports
