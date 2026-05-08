--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 牵引回调模板
-- 
-- 为吸附/牵引系统提供可复用的回调工厂函数。
-- 配合 `吸附牵引系统.ts` 的 `开始回调`、`结束回调`、`到达回调` 使用。
local jass = require("jass.common")
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UnitDamageTarget = jass.UnitDamageTarget
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local IsUnitEnemy = jass.IsUnitEnemy
local GetOwningPlayer = jass.GetOwningPlayer
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local SFB_setBuff = ____require_result_0.SFB_setBuff
____exports["创建牵引开始特效回调"] = function(_____6A21_578B_8DEF_5F84)
    return function(_____5355_4F4D, ______7275_5F15ID)
        local _____7279_6548 = AddSpecialEffect(
            _____6A21_578B_8DEF_5F84,
            GetUnitX(_____5355_4F4D),
            GetUnitY(_____5355_4F4D)
        )
        if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
            DestroyEffect(_____7279_6548)
        end
    end
end
____exports["创建牵引结束特效回调"] = function(_____6A21_578B_8DEF_5F84)
    return function(_____5355_4F4D, ______539F_56E0, ______7275_5F15ID)
        local _____7279_6548 = AddSpecialEffect(
            _____6A21_578B_8DEF_5F84,
            GetUnitX(_____5355_4F4D),
            GetUnitY(_____5355_4F4D)
        )
        if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
            DestroyEffect(_____7279_6548)
        end
    end
end
____exports["创建牵引结束控制回调"] = function(_____63A7_5236ID, _____6301_7EED_65F6_95F4)
    return function(_____5355_4F4D, _____539F_56E0, ______7275_5F15ID)
        if _____539F_56E0 == "死亡" then
            return
        end
        SFB_setBuff(_____5355_4F4D, _____5355_4F4D, _____63A7_5236ID, _____6301_7EED_65F6_95F4)
    end
end
____exports["创建牵引到达特效回调"] = function(_____6A21_578B_8DEF_5F84)
    return function(_____5355_4F4D, ______7275_5F15ID)
        local _____7279_6548 = AddSpecialEffect(
            _____6A21_578B_8DEF_5F84,
            GetUnitX(_____5355_4F4D),
            GetUnitY(_____5355_4F4D)
        )
        if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
            DestroyEffect(_____7279_6548)
        end
    end
end
____exports["创建牵引到达伤害回调"] = function(_____534A_5F84, _____4F24_5BB3, _____6765_6E90)
    return function(_____5355_4F4D, ______7275_5F15ID)
        local _____4E2D_5FC3X = GetUnitX(_____5355_4F4D)
        local _____4E2D_5FC3Y = GetUnitY(_____5355_4F4D)
        local ____6765_6E90_1 = _____6765_6E90
        if ____6765_6E90_1 == nil then
            ____6765_6E90_1 = _____5355_4F4D
        end
        local _____4F24_5BB3_6765_6E90 = ____6765_6E90_1
        local _____6240_5C5E_73A9_5BB6 = GetOwningPlayer(_____4F24_5BB3_6765_6E90)
        local _____679A_4E3E_7EC4 = CreateGroup()
        GroupEnumUnitsInRange(
            _____679A_4E3E_7EC4,
            _____4E2D_5FC3X,
            _____4E2D_5FC3Y,
            _____534A_5F84,
            nil
        )
        while true do
            local _____76EE_6807 = FirstOfGroup(_____679A_4E3E_7EC4)
            if _____76EE_6807 == nil or _____76EE_6807 == 0 then
                break
            end
            GroupRemoveUnit(_____679A_4E3E_7EC4, _____76EE_6807)
            if IsUnitEnemy(_____76EE_6807, _____6240_5C5E_73A9_5BB6) then
                UnitDamageTarget(
                    _____4F24_5BB3_6765_6E90,
                    _____76EE_6807,
                    _____4F24_5BB3,
                    false,
                    false,
                    jass.ATTACK_TYPE_NORMAL,
                    jass.DAMAGE_TYPE_NORMAL,
                    jass.WEAPON_TYPE_WHOKNOWS
                )
            end
        end
        DestroyGroup(_____679A_4E3E_7EC4)
    end
end
____exports["创建牵引回调"] = function(_____9009_9879)
    local _____7ED3_679C = {}
    if _____9009_9879["开始特效"] then
        _____7ED3_679C["开始回调"] = ____exports["创建牵引开始特效回调"](_____9009_9879["开始特效"])
    end
    local _____7ED3_675F_56DE_8C03_5217_8868 = {}
    if _____9009_9879["结束特效"] then
        _____7ED3_675F_56DE_8C03_5217_8868[#_____7ED3_675F_56DE_8C03_5217_8868 + 1] = ____exports["创建牵引结束特效回调"](_____9009_9879["结束特效"])
    end
    if _____9009_9879["结束控制"] ~= nil and _____9009_9879["结束控制时间"] ~= nil and _____9009_9879["结束控制时间"] > 0 then
        _____7ED3_675F_56DE_8C03_5217_8868[#_____7ED3_675F_56DE_8C03_5217_8868 + 1] = ____exports["创建牵引结束控制回调"](_____9009_9879["结束控制"], _____9009_9879["结束控制时间"])
    end
    if #_____7ED3_675F_56DE_8C03_5217_8868 > 0 then
        _____7ED3_679C["结束回调"] = function(self, _____5355_4F4D, _____539F_56E0, _____7275_5F15ID)
            for ____, _____56DE_8C03 in ipairs(_____7ED3_675F_56DE_8C03_5217_8868) do
                _____56DE_8C03(_____5355_4F4D, _____539F_56E0, _____7275_5F15ID)
            end
        end
    end
    local _____5230_8FBE_56DE_8C03_5217_8868 = {}
    if _____9009_9879["到达特效"] then
        _____5230_8FBE_56DE_8C03_5217_8868[#_____5230_8FBE_56DE_8C03_5217_8868 + 1] = ____exports["创建牵引到达特效回调"](_____9009_9879["到达特效"])
    end
    if _____9009_9879["到达伤害"] ~= nil and _____9009_9879["到达伤害"] > 0 and _____9009_9879["到达伤害半径"] ~= nil and _____9009_9879["到达伤害半径"] > 0 then
        _____5230_8FBE_56DE_8C03_5217_8868[#_____5230_8FBE_56DE_8C03_5217_8868 + 1] = ____exports["创建牵引到达伤害回调"](_____9009_9879["到达伤害半径"], _____9009_9879["到达伤害"], _____9009_9879["到达伤害来源"])
    end
    if #_____5230_8FBE_56DE_8C03_5217_8868 > 0 then
        _____7ED3_679C["到达回调"] = function(self, _____5355_4F4D, _____7275_5F15ID)
            for ____, _____56DE_8C03 in ipairs(_____5230_8FBE_56DE_8C03_5217_8868) do
                _____56DE_8C03(_____5355_4F4D, _____7275_5F15ID)
            end
        end
    end
    return _____7ED3_679C
end
return ____exports
