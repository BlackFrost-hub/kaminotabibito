--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____9ED1_7267_6756_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["黑牧杖物品ID"]
local ____00_FF0E_6CBB_7597_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.01．治疗触发.00．治疗触发配置")
local _____9ED1_7267_6756_914D_7F6E = ____00_FF0E_6CBB_7597_89E6_53D1_914D_7F6E["黑牧杖配置"]
local ____01_FF0E_6CBB_7597_89E6_53D1_5E38_91CF = require("系统.02．物品系统.15．装备技能.03．主动技能.01．治疗触发.01．治疗触发常量")
local _____9ED1_7267_6756_6700_5C0F_6CBB_7597_89E6_53D1_503C = ____01_FF0E_6CBB_7597_89E6_53D1_5E38_91CF["黑牧杖最小治疗触发值"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_0.createTimedEffect
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
local getEnemyUnitsInRange = ____require_result_1.getEnemyUnitsInRange
local isValidUnit = ____require_result_1.isValidUnit
local isUnitEnemy = ____require_result_1.isUnitEnemy
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行")
local _____9020_6210_88C5_5907_4F24_5BB3 = ____require_result_2["造成装备伤害"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local ____require_result_3 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_3.UnitHasItemOfTypeBJ
local function _____5355_4F4D_662F_5426_6301_6709_9ED1_7267_6756(unit)
    if not isValidUnit(unit) then
        return false
    end
    if _____9ED1_7267_6756_7269_54C1ID <= 0 then
        return false
    end
    return UnitHasItemOfTypeBJ(unit, _____9ED1_7267_6756_7269_54C1ID) == true
end
local function _____5BF9_654C_4EBA_9020_6210_9ED1_7267_6756_4F24_5BB3(_____65BD_6CD5_8005, _____76EE_6807)
    if not isValidUnit(_____65BD_6CD5_8005) or not isValidUnit(_____76EE_6807) then
        return
    end
    _____9020_6210_88C5_5907_4F24_5BB3(
        _____65BD_6CD5_8005,
        _____76EE_6807,
        _____9ED1_7267_6756_914D_7F6E["伤害值"],
        DAMAGE_TYPE_SHADOW_STRIKE,
        false,
        nil,
        {["伤害形态"] = "AOE"}
    )
    createTimedEffect(
        _____9ED1_7267_6756_914D_7F6E["特效路径"],
        GetUnitX(_____76EE_6807),
        GetUnitY(_____76EE_6807),
        0,
        1
    )
end
____exports["处理黑牧杖治疗"] = function(______6765_6E90, _____76EE_6807, _____6CBB_7597_91CF, ______662F_5426_7269_54C1_6CBB_7597)
    if not isValidUnit(_____76EE_6807) or _____6CBB_7597_91CF <= _____9ED1_7267_6756_6700_5C0F_6CBB_7597_89E6_53D1_503C then
        return _____6CBB_7597_91CF
    end
    if not _____5355_4F4D_662F_5426_6301_6709_9ED1_7267_6756(_____76EE_6807) then
        return _____6CBB_7597_91CF
    end
    local _____654C_4EBA_5217_8868 = getEnemyUnitsInRange(
        _____76EE_6807,
        GetUnitX(_____76EE_6807),
        GetUnitY(_____76EE_6807),
        _____9ED1_7267_6756_914D_7F6E["作用范围"]
    )
    do
        local i = 0
        while i < #_____654C_4EBA_5217_8868 do
            do
                local _____654C_4EBA = _____654C_4EBA_5217_8868[i + 1]
                if not isValidUnit(_____654C_4EBA) then
                    goto __continue11
                end
                if not isUnitEnemy(_____654C_4EBA, _____76EE_6807) then
                    goto __continue11
                end
                _____5BF9_654C_4EBA_9020_6210_9ED1_7267_6756_4F24_5BB3(_____76EE_6807, _____654C_4EBA)
            end
            ::__continue11::
            i = i + 1
        end
    end
    return _____6CBB_7597_91CF
end
return ____exports
