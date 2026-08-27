--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 特殊单位消耗处理
local jass = require("jass.common")
local ____require_result_0 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具")
local _____662F_5426_6307_5B9A_73A9_5BB6_82F1_96C4 = ____require_result_0["是否指定玩家英雄"]
local heroBridge = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local ____require_result_1 = require("系统.03．技能系统.02．技能消耗.00．消耗常量")
local EDWARD_HERO_ID = ____require_result_1.EDWARD_HERO_ID
local SPECIAL_UNIT_COST_CONFIG = ____require_result_1.SPECIAL_UNIT_COST_CONFIG
--- 获取爱德华单位。
-- 通过玩家英雄注册桥接查当前已登记的玩家英雄，再按配置 rawcode 过滤。
function ____exports.getEdwardUnit()
    do
        local playerId = 0
        while playerId <= 4 do
            local hero = heroBridge.getRegisteredPlayerHero(jass:Player(playerId))
            if _____662F_5426_6307_5B9A_73A9_5BB6_82F1_96C4(hero, EDWARD_HERO_ID) then
                return hero
            end
            playerId = playerId + 1
        end
    end
    return nil
end
--- 检查单位是否为爱德华。
function ____exports.isEdwardUnit(unit)
    return _____662F_5426_6307_5B9A_73A9_5BB6_82F1_96C4(unit, EDWARD_HERO_ID)
end
--- 爱德华被动处理：扣血代替扣蓝。
function ____exports.handleEdwardPassiveCost(unit, manaCost)
    if not ____exports.isEdwardUnit(unit) then
        return
    end
    local currentLife = jass:GetUnitState(unit, jass.UNIT_STATE_LIFE)
    local lifeKeep = currentLife - 1
    local deductAmount = manaCost < lifeKeep and manaCost or lifeKeep
    if deductAmount > 0 then
        jass:SetUnitState(unit, jass.UNIT_STATE_LIFE, currentLife - deductAmount)
    end
end
return ____exports
