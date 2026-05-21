--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.04．伤害系统.06．暴击系统.01．暴击核心")
local registerCritAppliedFinalDamageListener = ____require_result_0.registerCritAppliedFinalDamageListener
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_1.doHeal
local ____require_result_2 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_2.resolveItemIdByName
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_4.UnitHasItemOfTypeBJ
local GetUnitStateJapi = japi.GetUnitState
local UnitDamageTarget = jass.UnitDamageTarget
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____5730_72F1_706B_5361_724C_5E78_8FD0_7269_54C1ID = stringToFourCCSafe(resolveItemIdByName("|cffff6800地狱火卡牌|r|cffff0000（幸运）|r"))
local function _____6062_590D_81EA_8EAB_6700_5927_751F_547D_767E_5206_6BD4(source)
    local _____6700_5927_751F_547D = GetUnitStateJapi(source, UNIT_STATE_MAX_LIFE)
    if _____6700_5927_751F_547D <= 0 then
        return
    end
    doHeal({
        HealSource = source,
        HealTarget = source,
        HealAmount = _____6700_5927_751F_547D * 0.02,
        ItemHeal = true,
        HealEffect = false
    })
end
local function _____9020_6210_989D_5916_7269_7406_4F24_5BB3(source, target)
    UnitDamageTarget(
        source,
        target,
        100,
        false,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
end
local function _____5730_72F1_706B_5361_724C_5E78_8FD0_66B4_51FB_76D1_542C(record, _applied, _snapshot)
    if _____5730_72F1_706B_5361_724C_5E78_8FD0_7269_54C1ID == 0 then
        return
    end
    if record.isNormalAttack ~= true then
        return
    end
    if not UnitHasItemOfTypeBJ(record["暴击归属单位"], _____5730_72F1_706B_5361_724C_5E78_8FD0_7269_54C1ID) then
        return
    end
    _____6062_590D_81EA_8EAB_6700_5927_751F_547D_767E_5206_6BD4(record["暴击归属单位"])
    _____9020_6210_989D_5916_7269_7406_4F24_5BB3(record.attacker, record.target)
end
____exports["init地狱火卡牌幸运暴击"] = function()
    registerCritAppliedFinalDamageListener(_____5730_72F1_706B_5361_724C_5E78_8FD0_66B4_51FB_76D1_542C)
end
____exports["init地狱火卡牌幸运暴击"]()
return ____exports
