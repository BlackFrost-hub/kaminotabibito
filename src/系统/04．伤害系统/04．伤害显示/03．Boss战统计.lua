--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 伤害显示系统 - Boss战统计
-- 
-- 功能：
-- 1. 记录玩家对Boss的伤害
-- 2. 记录Boss对玩家的伤害
-- 
-- 依赖：
-- - YDUserDataGet/YDUserDataSet：Boss战数据存储
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local YDUserDataSet = ____require_result_0.YDUserDataSet
--- 更新Boss战伤害统计
-- 
-- @param source 伤害来源
-- @param target 伤害目标
-- @param damage 伤害值
function ____exports.updateBossDamageStats(source, target, damage)
    local bossUnit = YDUserDataGet(
        nil,
        "string",
        "Boss战",
        "单位",
        "unit"
    )
    if not bossUnit then
        return
    end
    local damageInt = math.floor(damage)
    local playerForce = YDUserDataGet(
        nil,
        "string",
        "玩家",
        "玩家组",
        "force"
    )
    if target == bossUnit and source then
        local ____opt_1 = jass.GetOwningPlayer
        if ____opt_1 ~= nil then
            ____opt_1 = ____opt_1(jass, source)
        end
        local sourcePlayer = ____opt_1
        local ____sourcePlayer_5 = sourcePlayer
        if ____sourcePlayer_5 then
            local ____opt_3 = jass.IsPlayerInForce
            if ____opt_3 ~= nil then
                ____opt_3 = ____opt_3(jass, sourcePlayer, playerForce)
            end
            ____sourcePlayer_5 = ____opt_3
        end
        if ____sourcePlayer_5 then
            local ____opt_6 = jass.GetUnitState
            if ____opt_6 ~= nil then
                ____opt_6 = ____opt_6(jass, bossUnit, jass.UNIT_STATE_LIFE)
            end
            local ____opt_6_8 = ____opt_6
            if ____opt_6_8 == nil then
                ____opt_6_8 = 0
            end
            local bossLife = ____opt_6_8
            local actualDamage = math.min(bossLife, damageInt)
            local ____YDUserDataGet_result_9 = YDUserDataGet(
                nil,
                "player",
                sourcePlayer,
                "造成伤害",
                "real"
            )
            if ____YDUserDataGet_result_9 == nil then
                ____YDUserDataGet_result_9 = 0
            end
            local currentDamage = ____YDUserDataGet_result_9
            YDUserDataSet(
                nil,
                "player",
                sourcePlayer,
                "造成伤害",
                "real",
                currentDamage + actualDamage
            )
        end
    end
    if source == bossUnit and target then
        local ____opt_10 = jass.GetOwningPlayer
        if ____opt_10 ~= nil then
            ____opt_10 = ____opt_10(jass, target)
        end
        local targetPlayer = ____opt_10
        local ____opt_12 = jass.IsUnitType
        if ____opt_12 ~= nil then
            ____opt_12 = ____opt_12(jass, target, jass.UNIT_TYPE_SUMMONED)
        end
        local ____opt_12_14 = ____opt_12
        if ____opt_12_14 == nil then
            ____opt_12_14 = false
        end
        local isSummoned = ____opt_12_14
        local ____temp_17 = not isSummoned and targetPlayer
        if ____temp_17 then
            local ____opt_15 = jass.IsPlayerInForce
            if ____opt_15 ~= nil then
                ____opt_15 = ____opt_15(jass, targetPlayer, playerForce)
            end
            ____temp_17 = ____opt_15
        end
        if ____temp_17 then
            local ____opt_18 = jass.GetUnitState
            if ____opt_18 ~= nil then
                ____opt_18 = ____opt_18(jass, source, jass.UNIT_STATE_LIFE)
            end
            local ____opt_18_20 = ____opt_18
            if ____opt_18_20 == nil then
                ____opt_18_20 = 0
            end
            local bossLife = ____opt_18_20
            local actualDamage = math.min(bossLife, damageInt)
            local ____YDUserDataGet_result_21 = YDUserDataGet(
                nil,
                "player",
                targetPlayer,
                "承受伤害",
                "real"
            )
            if ____YDUserDataGet_result_21 == nil then
                ____YDUserDataGet_result_21 = 0
            end
            local currentDamage = ____YDUserDataGet_result_21
            YDUserDataSet(
                nil,
                "player",
                targetPlayer,
                "承受伤害",
                "real",
                currentDamage + actualDamage
            )
        end
    end
end
--- 检查是否在Boss战中
function ____exports.isInBossBattle()
    local bossUnit = YDUserDataGet(
        nil,
        "string",
        "Boss战",
        "单位",
        "unit"
    )
    return bossUnit ~= nil
end
--- 获取Boss单位
function ____exports.getBossUnit()
    return YDUserDataGet(
        nil,
        "string",
        "Boss战",
        "单位",
        "unit"
    )
end
--- 获取玩家对Boss的总伤害
function ____exports.getPlayerDamageToBoss(player)
    local ____YDUserDataGet_result_22 = YDUserDataGet(
        nil,
        "player",
        player,
        "造成伤害",
        "real"
    )
    if ____YDUserDataGet_result_22 == nil then
        ____YDUserDataGet_result_22 = 0
    end
    return ____YDUserDataGet_result_22
end
--- 获取玩家承受Boss的总伤害
function ____exports.getPlayerDamageFromBoss(player)
    local ____YDUserDataGet_result_23 = YDUserDataGet(
        nil,
        "player",
        player,
        "承受伤害",
        "real"
    )
    if ____YDUserDataGet_result_23 == nil then
        ____YDUserDataGet_result_23 = 0
    end
    return ____YDUserDataGet_result_23
end
return ____exports
