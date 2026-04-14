local ____lualib = require("lualib_bundle")
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local ____exports = {}
--- 特殊技能冷却处理
-- 
-- 处理通魔类技能的独立冷却设置
local jass = require("jass.common")
local japi = require("jass.japi")
--- 风暴之刃技能ID
local STORM_BLADE_SKILLS = {1093683786, 1093683785, 1093683787}
--- 风暴之刃基础冷却
local STORM_BLADE_BASE_CD = 12
--- 风暴之刃关联技能ID
local STORM_BLADE_LINKED_ABILITY = 1093683784
--- 检查是否为风暴之刃技能
function ____exports.isStormBladeSkill(self, abilityId)
    return __TS__ArrayIncludes(STORM_BLADE_SKILLS, abilityId)
end
--- 处理风暴之刃冷却
function ____exports.handleStormBladeCooldown(self, unit, reduction)
    local cd = STORM_BLADE_BASE_CD - STORM_BLADE_BASE_CD * reduction
    japi.YDWESetUnitAbilityState(unit, STORM_BLADE_LINKED_ABILITY, 1, cd)
end
--- 检查是否为三连斩技能（通过技能数据字符串判断）
function ____exports.isTripleSlashSkill(self, unit, abilityId)
    local skillString = japi.YDWEGetUnitAbilityDataString(unit, abilityId, 1, 216)
    return skillString == "SLSQW" or skillString == "SLSQE" or skillString == "SLSQR"
end
--- 三连斩基础冷却
local TRIPLE_SLASH_BASE_CD = 9
--- 三连斩关联技能ID
local TRIPLE_SLASH_LINKED_ABILITY = 1093683796
--- 处理三连斩冷却
function ____exports.handleTripleSlashCooldown(self, unit, reduction)
    local cd = TRIPLE_SLASH_BASE_CD - TRIPLE_SLASH_BASE_CD * reduction
    japi.YDWESetUnitAbilityState(unit, TRIPLE_SLASH_LINKED_ABILITY, 1, cd)
end
--- 处理特殊技能冷却
-- 
-- @param unit 施法单位
-- @param abilityId 技能ID
-- @param reduction 冷却缩减比例
-- @returns 是否为特殊技能
function ____exports.handleSpecialSkillCooldown(self, unit, abilityId, reduction)
    if ____exports.isStormBladeSkill(nil, abilityId) then
        ____exports.handleStormBladeCooldown(nil, unit, reduction)
        return true
    end
    if ____exports.isTripleSlashSkill(nil, unit, abilityId) then
        ____exports.handleTripleSlashCooldown(nil, unit, reduction)
        return true
    end
    return false
end
return ____exports
