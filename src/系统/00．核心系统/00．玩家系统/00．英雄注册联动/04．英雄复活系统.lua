--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local g = require("jass.globals")
local ____YDWE_6A21_5757 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local ____require_result_0 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_0.getRegisteredPlayerHero
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数")
local X_IsTerrainWalkable = ____require_result_2.X_IsTerrainWalkable
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_3.StarOther_PanCameraToTimedForPlayer
local function _____79FB_52A8_955C_5934_5230_73A9_5BB6(_____73A9_5BB6, x, y)
    StarOther_PanCameraToTimedForPlayer(_____73A9_5BB6, x, y, 0.1)
end
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitName = jass.GetUnitName
local ReviveHeroLoc = jass.ReviveHeroLoc
local GetRandomReal = jass.GetRandomReal
local GetRandomDirectionDeg = jass.GetRandomDirectionDeg
local Cos = jass.Cos
local Sin = jass.Sin
local GetOwningPlayer = jass.GetOwningPlayer
local Location = jass.Location
local RemoveLocation = jass.RemoveLocation
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local _____590D_6D3B_5EF6_8FDF_79D2 = 10
local _____590D_6D3B_534A_5F84 = 400
local _____6700_5927_5C1D_8BD5_6B21_6570 = 8
local _____590D_6D3B_6B21_6570_5C5E_6027 = "次数"
local _____590D_6D3B_6B21_6570_8868 = "团队复活"
local ____Boss_6218_8868 = "Boss战"
local ____Boss_6218_5355_4F4D_5C5E_6027 = "单位"
local _____8BBE_7F6E_6D4B_8BD5_6B21_6570 = true
local _____6D4B_8BD5_590D_6D3B_6B21_6570 = 10
local _____5DF2_6CE8_518C_6B7B_4EA1 = false
local function _____662F_5426_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____662F_73A9_5BB6_82F1_96C4(unit)
    if not _____662F_5426_6709_6548(unit) then
        return false
    end
    return getRegisteredPlayerHero(GetOwningPlayer(unit)) == unit
end
local function _____5BFB_627E_53EF_901A_884C_590D_6D3B_70B9(boss)
    local bx = GetUnitX(boss)
    local by = GetUnitY(boss)
    do
        local i = 0
        while i < _____6700_5927_5C1D_8BD5_6B21_6570 do
            local _____89D2_5EA6_5EA6 = GetRandomDirectionDeg()
            local _____5F27_5EA6 = _____89D2_5EA6_5EA6 * 0.01745329252
            local x = bx + GetRandomReal(0, _____590D_6D3B_534A_5F84) * Cos(_____5F27_5EA6)
            local y = by + GetRandomReal(0, _____590D_6D3B_534A_5F84) * Sin(_____5F27_5EA6)
            if X_IsTerrainWalkable(x, y) then
                return {x = x, y = y}
            end
            i = i + 1
        end
    end
    return nil
end
local function _____6267_884C_590D_6D3B(dyingUnit)
    if not _____662F_5426_6709_6548(dyingUnit) then
        return
    end
    if not _____662F_73A9_5BB6_82F1_96C4(dyingUnit) then
        return
    end
    if jass.IsUnitType(dyingUnit, jass.UNIT_TYPE_DEAD) ~= true then
        return
    end
    local _____5269_4F59_6B21_6570 = ____YDWE_6A21_5757:YDUserDataGet("string", _____590D_6D3B_6B21_6570_8868, _____590D_6D3B_6B21_6570_5C5E_6027, "integer")
    if _____5269_4F59_6B21_6570 ~= nil and _____5269_4F59_6B21_6570 <= 0 then
        return
    end
    if _____5269_4F59_6B21_6570 ~= nil then
        ____YDWE_6A21_5757:YDUserDataSet(
            "string",
            _____590D_6D3B_6B21_6570_8868,
            _____590D_6D3B_6B21_6570_5C5E_6027,
            "integer",
            _____5269_4F59_6B21_6570 - 1
        )
    end
    local boss = ____YDWE_6A21_5757:YDUserDataGet("string", ____Boss_6218_8868, ____Boss_6218_5355_4F4D_5C5E_6027, "unit")
    if _____662F_5426_6709_6548(boss) then
        local pos = _____5BFB_627E_53EF_901A_884C_590D_6D3B_70B9(boss)
        if pos == nil then
            return
        end
        local loc = Location(pos.x, pos.y)
        ReviveHeroLoc(dyingUnit, loc, true)
        RemoveLocation(loc)
        SetUnitInvulnerable(dyingUnit, false)
        addDelayedCallback(
            0,
            function()
                _____79FB_52A8_955C_5934_5230_73A9_5BB6(
                    GetOwningPlayer(dyingUnit),
                    pos.x,
                    pos.y
                )
            end
        )
    else
        local _____590D_6D3B_70B9 = g.udg_FHD
        if not _____662F_5426_6709_6548(_____590D_6D3B_70B9) then
            return
        end
        ReviveHeroLoc(dyingUnit, _____590D_6D3B_70B9, true)
        addDelayedCallback(
            0,
            function()
                _____79FB_52A8_955C_5934_5230_73A9_5BB6(
                    GetOwningPlayer(dyingUnit),
                    GetUnitX(dyingUnit),
                    GetUnitY(dyingUnit)
                )
            end
        )
    end
end
local function _____82F1_96C4_6B7B_4EA1_5EF6_8FDF_590D_6D3B(dyingUnit, _____51FB_6740_8005)
    if not _____662F_73A9_5BB6_82F1_96C4(dyingUnit) then
        return
    end
    addDelayedCallback(
        _____590D_6D3B_5EF6_8FDF_79D2 * 1000,
        function()
            _____6267_884C_590D_6D3B(dyingUnit)
        end
    )
end
____exports["初始化英雄复活"] = function()
    if _____5DF2_6CE8_518C_6B7B_4EA1 then
        return
    end
    _____5DF2_6CE8_518C_6B7B_4EA1 = true
    if _____8BBE_7F6E_6D4B_8BD5_6B21_6570 then
        ____YDWE_6A21_5757:YDUserDataSet(
            "string",
            _____590D_6D3B_6B21_6570_8868,
            _____590D_6D3B_6B21_6570_5C5E_6027,
            "integer",
            _____6D4B_8BD5_590D_6D3B_6B21_6570
        )
    end
    local _____6B7B_4EA1_6A21_5757 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
    _____6B7B_4EA1_6A21_5757.registerDeathListener(_____82F1_96C4_6B7B_4EA1_5EF6_8FDF_590D_6D3B)
end
return ____exports
