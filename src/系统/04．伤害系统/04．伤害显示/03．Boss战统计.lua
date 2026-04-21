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
        local sourcePlayer = jass.GetOwningPlayer(source)
        if sourcePlayer and jass.IsPlayerInForce(sourcePlayer, playerForce) then
            local bossLife = jass.GetUnitState(bossUnit, jass.UNIT_STATE_LIFE)
            local actualDamage = math.min(bossLife, damageInt)
            local ____YDUserDataGet_result_1 = YDUserDataGet(
                nil,
                "player",
                sourcePlayer,
                "造成伤害",
                "real"
            )
            if ____YDUserDataGet_result_1 == nil then
                ____YDUserDataGet_result_1 = 0
            end
            local currentDamage = ____YDUserDataGet_result_1
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
        local targetPlayer = jass.GetOwningPlayer(target)
        local isSummoned = jass.IsUnitType(target, jass.UNIT_TYPE_SUMMONED)
        if not isSummoned and targetPlayer and jass.IsPlayerInForce(targetPlayer, playerForce) then
            local bossLife = jass.GetUnitState(source, jass.UNIT_STATE_LIFE)
            local actualDamage = math.min(bossLife, damageInt)
            local ____YDUserDataGet_result_2 = YDUserDataGet(
                nil,
                "player",
                targetPlayer,
                "承受伤害",
                "real"
            )
            if ____YDUserDataGet_result_2 == nil then
                ____YDUserDataGet_result_2 = 0
            end
            local currentDamage = ____YDUserDataGet_result_2
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
    local ____YDUserDataGet_result_3 = YDUserDataGet(
        nil,
        "player",
        player,
        "造成伤害",
        "real"
    )
    if ____YDUserDataGet_result_3 == nil then
        ____YDUserDataGet_result_3 = 0
    end
    return ____YDUserDataGet_result_3
end
--- 获取玩家承受Boss的总伤害
function ____exports.getPlayerDamageFromBoss(player)
    local ____YDUserDataGet_result_4 = YDUserDataGet(
        nil,
        "player",
        player,
        "承受伤害",
        "real"
    )
    if ____YDUserDataGet_result_4 == nil then
        ____YDUserDataGet_result_4 = 0
    end
    return ____YDUserDataGet_result_4
end
return ____exports
