local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArraySome = ____lualib.__TS__ArraySome
local ____exports = {}
--- 特殊技能冷却处理
local ____YD_5B89_5168_6A21_5757 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local _____901A_7528_5DE5_5177_6A21_5757 = require("lib.扩展函数.封装函数.01．通用工具.index")
local _____8F6C_56DB_5B57_8282 = _____901A_7528_5DE5_5177_6A21_5757.stringToFourCC
local ____YD_8BBE_7F6E_6280_80FD_72B6_6001 = ____YD_5B89_5168_6A21_5757.YDWESetUnitAbilityStateSafe
local ____YD_8BFB_53D6_6280_80FD_5B57_7B26_4E32 = ____YD_5B89_5168_6A21_5757.YDWEGetUnitAbilityDataStringSafe
local ____require_result_0 = require("系统.03．技能系统.01．技能冷却.00．冷却常量")
local STORM_BLADE_SKILLS = ____require_result_0.STORM_BLADE_SKILLS
local STORM_BLADE_BASE_CD = ____require_result_0.STORM_BLADE_BASE_CD
local STORM_BLADE_LINKED_ABILITY = ____require_result_0.STORM_BLADE_LINKED_ABILITY
local TRIPLE_SLASH_SKILL_MARKERS = ____require_result_0.TRIPLE_SLASH_SKILL_MARKERS
local TRIPLE_SLASH_BASE_CD = ____require_result_0.TRIPLE_SLASH_BASE_CD
local TRIPLE_SLASH_LINKED_ABILITY = ____require_result_0.TRIPLE_SLASH_LINKED_ABILITY
local function _____63D0_53D6_5185_90E8ID(_____914D_7F6E_952E_540D)
    if not _____914D_7F6E_952E_540D then
        return ""
    end
    local _____7247_6BB5_5217_8868 = __TS__StringSplit(_____914D_7F6E_952E_540D, "|")
    return _____7247_6BB5_5217_8868[#_____7247_6BB5_5217_8868] or ""
end
--- 检查是否为风暴之刃技能
function ____exports.isStormBladeSkill(abilityId)
    return __TS__ArraySome(
        STORM_BLADE_SKILLS,
        function(____, _____914D_7F6E_952E_540D) return _____8F6C_56DB_5B57_8282(_____63D0_53D6_5185_90E8ID(_____914D_7F6E_952E_540D)) == abilityId end
    )
end
--- 处理风暴之刃冷却
function ____exports.handleStormBladeCooldown(unit, reduction)
    local cd = STORM_BLADE_BASE_CD - STORM_BLADE_BASE_CD * reduction
    ____YD_8BBE_7F6E_6280_80FD_72B6_6001(
        unit,
        _____8F6C_56DB_5B57_8282(_____63D0_53D6_5185_90E8ID(STORM_BLADE_LINKED_ABILITY)),
        1,
        cd
    )
end
--- 检查是否为三连斩技能
function ____exports.isTripleSlashSkill(unit, abilityId)
    local skillString = ____YD_8BFB_53D6_6280_80FD_5B57_7B26_4E32(unit, abilityId, 1, 216)
    return __TS__ArraySome(
        TRIPLE_SLASH_SKILL_MARKERS,
        function(____, _____914D_7F6E_952E_540D) return _____63D0_53D6_5185_90E8ID(_____914D_7F6E_952E_540D) == skillString end
    )
end
--- 处理三连斩冷却
function ____exports.handleTripleSlashCooldown(unit, reduction)
    local cd = TRIPLE_SLASH_BASE_CD - TRIPLE_SLASH_BASE_CD * reduction
    ____YD_8BBE_7F6E_6280_80FD_72B6_6001(
        unit,
        _____8F6C_56DB_5B57_8282(_____63D0_53D6_5185_90E8ID(TRIPLE_SLASH_LINKED_ABILITY)),
        1,
        cd
    )
end
--- 处理特殊技能冷却
function ____exports.handleSpecialSkillCooldown(unit, abilityId, reduction)
    if ____exports.isStormBladeSkill(abilityId) then
        ____exports.handleStormBladeCooldown(unit, reduction)
        return true
    end
    if ____exports.isTripleSlashSkill(unit, abilityId) then
        ____exports.handleTripleSlashCooldown(unit, reduction)
        return true
    end
    return false
end
return ____exports
