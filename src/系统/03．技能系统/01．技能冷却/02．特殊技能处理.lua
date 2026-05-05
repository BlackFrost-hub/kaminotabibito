local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArraySome = ____lualib.__TS__ArraySome
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDWESetUnitAbilityState = ____require_result_0.YDWESetUnitAbilityState
local YDWEGetUnitAbilityDataString = ____require_result_0.YDWEGetUnitAbilityDataString
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_1.stringToFourCC
local ____require_result_2 = require("系统.03．技能系统.01．技能冷却.00．冷却常量")
local STORM_BLADE_SKILLS = ____require_result_2.STORM_BLADE_SKILLS
local STORM_BLADE_BASE_CD = ____require_result_2.STORM_BLADE_BASE_CD
local STORM_BLADE_LINKED_ABILITY = ____require_result_2.STORM_BLADE_LINKED_ABILITY
local TRIPLE_SLASH_SKILL_MARKERS = ____require_result_2.TRIPLE_SLASH_SKILL_MARKERS
local TRIPLE_SLASH_BASE_CD = ____require_result_2.TRIPLE_SLASH_BASE_CD
local TRIPLE_SLASH_LINKED_ABILITY = ____require_result_2.TRIPLE_SLASH_LINKED_ABILITY
local function _____63D0_53D6_5185_90E8ID(self, _____914D_7F6E_952E_540D)
    local _____7247_6BB5_5217_8868 = __TS__StringSplit(_____914D_7F6E_952E_540D, "|")
    return _____7247_6BB5_5217_8868[#_____7247_6BB5_5217_8868] or _____914D_7F6E_952E_540D
end
--- 检查是否为风暴之刃技能
function ____exports.isStormBladeSkill(self, abilityId)
    return __TS__ArraySome(
        STORM_BLADE_SKILLS,
        function(____, _____914D_7F6E_952E_540D) return stringToFourCC(
            nil,
            _____63D0_53D6_5185_90E8ID(nil, _____914D_7F6E_952E_540D)
        ) == abilityId end
    )
end
--- 处理风暴之刃冷却
function ____exports.handleStormBladeCooldown(self, unit, reduction)
    local cd = STORM_BLADE_BASE_CD - STORM_BLADE_BASE_CD * reduction
    YDWESetUnitAbilityState(
        nil,
        unit,
        stringToFourCC(
            nil,
            _____63D0_53D6_5185_90E8ID(nil, STORM_BLADE_LINKED_ABILITY)
        ),
        1,
        cd
    )
end
--- 检查是否为三连斩技能
function ____exports.isTripleSlashSkill(self, unit, abilityId)
    local skillString = YDWEGetUnitAbilityDataString(
        nil,
        unit,
        abilityId,
        1,
        216
    )
    return __TS__ArraySome(
        TRIPLE_SLASH_SKILL_MARKERS,
        function(____, _____914D_7F6E_952E_540D) return _____63D0_53D6_5185_90E8ID(nil, _____914D_7F6E_952E_540D) == skillString end
    )
end
--- 处理三连斩冷却
function ____exports.handleTripleSlashCooldown(self, unit, reduction)
    local cd = TRIPLE_SLASH_BASE_CD - TRIPLE_SLASH_BASE_CD * reduction
    YDWESetUnitAbilityState(
        nil,
        unit,
        stringToFourCC(
            nil,
            _____63D0_53D6_5185_90E8ID(nil, TRIPLE_SLASH_LINKED_ABILITY)
        ),
        1,
        cd
    )
end
--- 处理特殊技能冷却
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
