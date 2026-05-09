--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- AI自动使用技能系统 - 工具函数
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local EXGetUnitAbility = ____require_result_0.EXGetUnitAbility
local EXGetAbilityState = ____require_result_0.EXGetAbilityState
local ABILITY_STATE_COOLDOWN = ____require_result_0.ABILITY_STATE_COOLDOWN
--- 获取单位句柄ID
function ____exports.getHandleId(self, unit)
    return jass.GetHandleId(unit) or 0
end
--- 获取当前游戏时间（秒）
function ____exports.getGameTime(self)
    return jass.GetGameTime()
end
--- 获取单位魔法值
function ____exports.getUnitMana(self, unit)
    return jass.GetUnitState(unit, jass.UNIT_STATE_MANA) or 0
end
--- 获取单位等级
function ____exports.getUnitLevel(self, unit)
    return jass.GetHeroLevel(unit) or 0
end
--- 获取技能当前冷却时间
function ____exports.getSkillCooldown(self, unit, abilityId)
    local abil = EXGetUnitAbility(nil, unit, abilityId)
    if not abil then
        return 0
    end
    return EXGetAbilityState(nil, abil, ABILITY_STATE_COOLDOWN) or 0
end
--- 获取两点距离
function ____exports.getDistance(self, x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return jass.SquareRoot(dx * dx + dy * dy)
end
--- 获取单位坐标
function ____exports.getUnitPos(self, unit)
    return {
        x = jass.GetUnitX(unit),
        y = jass.GetUnitY(unit)
    }
end
--- 检查单位是否有效
function ____exports.isValidUnit(self, unit)
    if not unit then
        return false
    end
    return jass.GetUnitTypeId(unit) ~= 0
end
--- 检查单位是否死亡
function ____exports.isUnitDead(self, unit)
    if not unit then
        return true
    end
    return jass.IsUnitType(unit, jass.UNIT_TYPE_DEAD)
end
return ____exports
