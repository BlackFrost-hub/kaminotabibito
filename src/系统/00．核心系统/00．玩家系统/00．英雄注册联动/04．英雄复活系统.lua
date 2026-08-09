--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____79FB_52A8_955C_5934_5230_73A9_5BB6, _____662F_5426_6709_6548, _____53D6_82F1_96C4_680F_69FD_4F4D, _____9690_85CF_82F1_96C4_680F_5012_8BA1_65F6, _____662F_73A9_5BB6_82F1_96C4, _____5BFB_627E_53EF_901A_884C_590D_6D3B_70B9, _____8BFB_53D6_5F53_524D_590D_6D3BBoss, ____on_590D_6D3B_955C_5934_79FB_52A8, _____65BD_52A0_590D_6D3B_65E0_654C, _____6267_884C_590D_6D3B, jass, g, YDUserDataGetSafe, YDUserDataSetSafe, GetRandomDirectionDeg, getRegisteredPlayerHero, addDelayedCallback, _____5F00_59CB_65E0_654C_5E27, _____6CBF_89D2_5EA6_6B65_8FDB_76F4_5230_5730_5F62_963B_6321, StarOther_PanCameraToTimedForPlayer, _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C, _____663E_793A_51B7_5374_6570_5B57_6587_672C, DzFrameShow, GetUnitX, GetUnitY, ReviveHeroLoc, GetOwningPlayer, GetPlayerId, Location, RemoveLocation, SetUnitX, SetUnitY, _____590D_6D3B_65E0_654C_79D2, _____590D_6D3B_534A_5F84, _____590D_6D3B_63A8_8FDB_6B65_6570, _____590D_6D3B_6B21_6570_5C5E_6027, _____590D_6D3B_6B21_6570_8868, ____Boss_6218_8868, ____Boss_6218_5355_4F4D_5C5E_6027, _____82F1_96C4_680F_6587_672C_6846_4F53_6570_91CF, _____82F1_96C4_680F_5012_8BA1_65F6_5E95_9634_5F71_6846_4F53_8868, _____82F1_96C4_680F_5012_8BA1_65F6_5DE6_63CF_8FB9_6846_4F53_8868, _____82F1_96C4_680F_5012_8BA1_65F6_53F3_63CF_8FB9_6846_4F53_8868, _____82F1_96C4_680F_5012_8BA1_65F6_9634_5F71_6846_4F53_8868, _____82F1_96C4_680F_5012_8BA1_65F6_6846_4F53_8868, _____82F1_96C4_680F_5012_8BA1_65F6_6587_672C_7EC4_8868, _____82F1_96C4_680F_5012_8BA1_65F6_5269_4F59_79D2_8868
function _____79FB_52A8_955C_5934_5230_73A9_5BB6(_____73A9_5BB6, x, y)
    StarOther_PanCameraToTimedForPlayer(_____73A9_5BB6, x, y, 0.1)
end
function _____662F_5426_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
function _____53D6_82F1_96C4_680F_69FD_4F4D(unit)
    if not _____662F_5426_6709_6548(unit) then
        return -1
    end
    local owner = GetOwningPlayer(unit)
    if not _____662F_5426_6709_6548(owner) then
        return -1
    end
    local playerId = GetPlayerId(owner)
    if playerId < 0 or playerId >= _____82F1_96C4_680F_6587_672C_6846_4F53_6570_91CF then
        return -1
    end
    return playerId
end
function _____9690_85CF_82F1_96C4_680F_5012_8BA1_65F6(_____69FD_4F4D)
    if _____69FD_4F4D < 0 or _____69FD_4F4D >= #_____82F1_96C4_680F_5012_8BA1_65F6_6846_4F53_8868 then
        return
    end
    _____82F1_96C4_680F_5012_8BA1_65F6_5269_4F59_79D2_8868[_____69FD_4F4D + 1] = 0
    local _____6587_672C_7EC4 = _____82F1_96C4_680F_5012_8BA1_65F6_6587_672C_7EC4_8868[_____69FD_4F4D + 1]
    if _____6587_672C_7EC4 ~= nil then
        _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C(_____6587_672C_7EC4, "")
        _____663E_793A_51B7_5374_6570_5B57_6587_672C(_____6587_672C_7EC4, false)
        return
    end
    local _____5E95_9634_5F71_6846_4F53 = _____82F1_96C4_680F_5012_8BA1_65F6_5E95_9634_5F71_6846_4F53_8868[_____69FD_4F4D + 1]
    local _____5DE6_63CF_8FB9_6846_4F53 = _____82F1_96C4_680F_5012_8BA1_65F6_5DE6_63CF_8FB9_6846_4F53_8868[_____69FD_4F4D + 1]
    local _____53F3_63CF_8FB9_6846_4F53 = _____82F1_96C4_680F_5012_8BA1_65F6_53F3_63CF_8FB9_6846_4F53_8868[_____69FD_4F4D + 1]
    local _____9634_5F71_6846_4F53 = _____82F1_96C4_680F_5012_8BA1_65F6_9634_5F71_6846_4F53_8868[_____69FD_4F4D + 1]
    local _____6587_5B57_6846_4F53 = _____82F1_96C4_680F_5012_8BA1_65F6_6846_4F53_8868[_____69FD_4F4D + 1]
    if _____5E95_9634_5F71_6846_4F53 ~= 0 then
        DzFrameShow(_____5E95_9634_5F71_6846_4F53, false)
    end
    if _____5DE6_63CF_8FB9_6846_4F53 ~= 0 then
        DzFrameShow(_____5DE6_63CF_8FB9_6846_4F53, false)
    end
    if _____53F3_63CF_8FB9_6846_4F53 ~= 0 then
        DzFrameShow(_____53F3_63CF_8FB9_6846_4F53, false)
    end
    if _____9634_5F71_6846_4F53 ~= 0 then
        DzFrameShow(_____9634_5F71_6846_4F53, false)
    end
    if _____6587_5B57_6846_4F53 ~= 0 then
        DzFrameShow(_____6587_5B57_6846_4F53, false)
    end
end
function _____662F_73A9_5BB6_82F1_96C4(unit)
    if not _____662F_5426_6709_6548(unit) then
        return false
    end
    return getRegisteredPlayerHero(GetOwningPlayer(unit)) == unit
end
function _____5BFB_627E_53EF_901A_884C_590D_6D3B_70B9(boss, _____68C0_6D4B_5355_4F4D)
    local bx = GetUnitX(boss)
    local by = GetUnitY(boss)
    local _____89D2_5EA6_5EA6 = GetRandomDirectionDeg()
    local _____6B65_8FDB_8DDD_79BB = _____590D_6D3B_534A_5F84 / _____590D_6D3B_63A8_8FDB_6B65_6570
    local _____7ED3_679C = _____6CBF_89D2_5EA6_6B65_8FDB_76F4_5230_5730_5F62_963B_6321({
        ["起点X"] = bx,
        ["起点Y"] = by,
        ["角度度"] = _____89D2_5EA6_5EA6,
        ["单步距离"] = _____6B65_8FDB_8DDD_79BB,
        ["步数"] = _____590D_6D3B_63A8_8FDB_6B65_6570,
        ["检测单位"] = _____68C0_6D4B_5355_4F4D
    })
    return {x = _____7ED3_679C["最终X"], y = _____7ED3_679C["最终Y"]}
end
function _____8BFB_53D6_5F53_524D_590D_6D3BBoss()
    local battleBoss = YDUserDataGetSafe("string", ____Boss_6218_8868, ____Boss_6218_5355_4F4D_5C5E_6027, "unit")
    if _____662F_5426_6709_6548(battleBoss) then
        return battleBoss
    end
    return g.udg_Boss
end
function ____on_590D_6D3B_955C_5934_79FB_52A8(variable)
    if variable == nil then
        return
    end
    _____79FB_52A8_955C_5934_5230_73A9_5BB6(variable["玩家"], variable.x, variable.y)
end
function _____65BD_52A0_590D_6D3B_65E0_654C(hero)
    if not _____662F_5426_6709_6548(hero) then
        return
    end
    _____5F00_59CB_65E0_654C_5E27(hero, _____590D_6D3B_65E0_654C_79D2)
end
function _____6267_884C_590D_6D3B(dyingUnit)
    if not _____662F_5426_6709_6548(dyingUnit) then
        return
    end
    if not _____662F_73A9_5BB6_82F1_96C4(dyingUnit) then
        return
    end
    if jass.IsUnitType(dyingUnit, jass.UNIT_TYPE_DEAD) ~= true then
        return
    end
    _____9690_85CF_82F1_96C4_680F_5012_8BA1_65F6(_____53D6_82F1_96C4_680F_69FD_4F4D(dyingUnit))
    local _____5269_4F59_6B21_6570 = YDUserDataGetSafe("string", _____590D_6D3B_6B21_6570_8868, _____590D_6D3B_6B21_6570_5C5E_6027, "integer")
    if _____5269_4F59_6B21_6570 ~= nil and _____5269_4F59_6B21_6570 <= 0 then
        return
    end
    if _____5269_4F59_6B21_6570 ~= nil then
        YDUserDataSetSafe(
            "string",
            _____590D_6D3B_6B21_6570_8868,
            _____590D_6D3B_6B21_6570_5C5E_6027,
            "integer",
            _____5269_4F59_6B21_6570 - 1
        )
    end
    local boss = _____8BFB_53D6_5F53_524D_590D_6D3BBoss()
    if _____662F_5426_6709_6548(boss) then
        local pos = _____5BFB_627E_53EF_901A_884C_590D_6D3B_70B9(boss, dyingUnit)
        if pos == nil then
            return
        end
        local loc = Location(
            GetUnitX(boss),
            GetUnitY(boss)
        )
        ReviveHeroLoc(dyingUnit, loc, true)
        RemoveLocation(loc)
        SetUnitX(dyingUnit, pos.x)
        SetUnitY(dyingUnit, pos.y)
        _____65BD_52A0_590D_6D3B_65E0_654C(dyingUnit)
        addDelayedCallback(
            0,
            ____on_590D_6D3B_955C_5934_79FB_52A8,
            {
                ["玩家"] = GetOwningPlayer(dyingUnit),
                x = pos.x,
                y = pos.y
            }
        )
    else
        local _____590D_6D3B_70B9 = g.udg_FHD
        if not _____662F_5426_6709_6548(_____590D_6D3B_70B9) then
            return
        end
        ReviveHeroLoc(dyingUnit, _____590D_6D3B_70B9, true)
        _____65BD_52A0_590D_6D3B_65E0_654C(dyingUnit)
        addDelayedCallback(
            0,
            ____on_590D_6D3B_955C_5934_79FB_52A8,
            {
                ["玩家"] = GetOwningPlayer(dyingUnit),
                x = GetUnitX(dyingUnit),
                y = GetUnitY(dyingUnit)
            }
        )
    end
end
jass = require("jass.common")
local japi = require("jass.japi")
g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local ____require_result_1 = require("lib.扩展函数.BJ函数.07．杂项")
GetRandomDirectionDeg = ____require_result_1.GetRandomDirectionDeg
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
getRegisteredPlayerHero = ____require_result_2.getRegisteredPlayerHero
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_3.addDelayedCallback
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧")
_____5F00_59CB_65E0_654C_5E27 = ____require_result_4["开始无敌帧"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.11．地形步进")
_____6CBF_89D2_5EA6_6B65_8FDB_76F4_5230_5730_5F62_963B_6321 = ____require_result_5["沿角度步进直到地形阻挡"]
local ____require_result_6 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
StarOther_PanCameraToTimedForPlayer = ____require_result_6.StarOther_PanCameraToTimedForPlayer
local ____G_7 = _G
local onTick10ms = ____G_7.onTick10ms
local offTick10ms = ____G_7.offTick10ms
local _____51B7_5374_6570_5B57_6587_672C_6A21_5757 = require("系统.09．表现系统.01．UI工具.06．冷却数字文本")
local _____521B_5EFA_51B7_5374_6570_5B57_6587_672C_7EC4 = _____51B7_5374_6570_5B57_6587_672C_6A21_5757["创建冷却数字文本组"]
local _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C_951A_70B9 = _____51B7_5374_6570_5B57_6587_672C_6A21_5757["设置冷却数字文本锚点"]
_____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C = _____51B7_5374_6570_5B57_6587_672C_6A21_5757["设置冷却数字文本"]
_____663E_793A_51B7_5374_6570_5B57_6587_672C = _____51B7_5374_6570_5B57_6587_672C_6A21_5757["显示冷却数字文本"]
local DzGetGameUI = japi.DzGetGameUI
local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
local DzFrameGetHeroBarButton = japi.DzFrameGetHeroBarButton
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment
local DzFrameSetFont = japi.DzFrameSetFont
local DzFrameSetTextColor = japi.DzFrameSetTextColor
local DzFrameSetPriority = japi.DzFrameSetPriority
DzFrameShow = japi.DzFrameShow
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local GetUnitName = jass.GetUnitName
ReviveHeroLoc = jass.ReviveHeroLoc
local Cos = jass.Cos
local Sin = jass.Sin
local GetLocalPlayer = jass.GetLocalPlayer
GetOwningPlayer = jass.GetOwningPlayer
GetPlayerId = jass.GetPlayerId
Location = jass.Location
RemoveLocation = jass.RemoveLocation
SetUnitX = jass.SetUnitX
SetUnitY = jass.SetUnitY
local R2I = jass.R2I
local _____590D_6D3B_5EF6_8FDF_79D2 = 10
_____590D_6D3B_65E0_654C_79D2 = 1
_____590D_6D3B_534A_5F84 = 500
_____590D_6D3B_63A8_8FDB_6B65_6570 = 20
_____590D_6D3B_6B21_6570_5C5E_6027 = "次数"
_____590D_6D3B_6B21_6570_8868 = "团队复活"
____Boss_6218_8868 = "Boss战"
____Boss_6218_5355_4F4D_5C5E_6027 = "单位"
_____82F1_96C4_680F_6587_672C_6846_4F53_6570_91CF = 5
local _____82F1_96C4_680F_5012_8BA1_65F6_5B57_4F53 = "UI\\uizt.ttf"
local _____82F1_96C4_680F_5012_8BA1_65F6_6587_5B57_5BBD_5EA6 = 0.056
local _____82F1_96C4_680F_5012_8BA1_65F6_6587_5B57_9AD8_5EA6 = 0.02
local _____82F1_96C4_680F_5012_8BA1_65F6_5B57_4F53_5927_5C0F = 0.0175
local _____82F1_96C4_680F_5012_8BA1_65F6_504F_79FBX = -0.0055
local _____82F1_96C4_680F_5012_8BA1_65F6_504F_79FBY = 0.0006
local _____82F1_96C4_680F_5012_8BA1_65F6_5E95_9634_5F71_504F_79FBX = 0.0014
local _____82F1_96C4_680F_5012_8BA1_65F6_5E95_9634_5F71_504F_79FBY = -0.0018
local _____82F1_96C4_680F_5012_8BA1_65F6_9634_5F71_504F_79FBX = -0.0014
local _____82F1_96C4_680F_5012_8BA1_65F6_9634_5F71_504F_79FBY = -0.0014
local _____82F1_96C4_680F_5012_8BA1_65F6_5DE6_63CF_8FB9_504F_79FBX = -0.0011
local _____82F1_96C4_680F_5012_8BA1_65F6_5DE6_63CF_8FB9_504F_79FBY = 0
local _____82F1_96C4_680F_5012_8BA1_65F6_53F3_63CF_8FB9_504F_79FBX = 0.0011
local _____82F1_96C4_680F_5012_8BA1_65F6_53F3_63CF_8FB9_504F_79FBY = 0
local _____82F1_96C4_680F_5012_8BA1_65F6_6587_5B57_4F18_5148_7EA7 = 6
local _____5E27_70B9_4E2D_5FC3 = 4
local _____6587_672C_5BF9_9F50_5C45_4E2D = 18
local _____8BBE_7F6E_6D4B_8BD5_6B21_6570 = true
local _____6D4B_8BD5_590D_6D3B_6B21_6570 = 10
local _____5DF2_6CE8_518C_6B7B_4EA1 = false
local _____5DF2_521D_59CB_5316_82F1_96C4_680F_5012_8BA1_65F6 = false
local _____5DF2_6CE8_518C_82F1_96C4_680F_5012_8BA1_65F6Tick = false
_____82F1_96C4_680F_5012_8BA1_65F6_5E95_9634_5F71_6846_4F53_8868 = {
    0,
    0,
    0,
    0,
    0
}
_____82F1_96C4_680F_5012_8BA1_65F6_5DE6_63CF_8FB9_6846_4F53_8868 = {
    0,
    0,
    0,
    0,
    0
}
_____82F1_96C4_680F_5012_8BA1_65F6_53F3_63CF_8FB9_6846_4F53_8868 = {
    0,
    0,
    0,
    0,
    0
}
_____82F1_96C4_680F_5012_8BA1_65F6_9634_5F71_6846_4F53_8868 = {
    0,
    0,
    0,
    0,
    0
}
_____82F1_96C4_680F_5012_8BA1_65F6_6846_4F53_8868 = {
    0,
    0,
    0,
    0,
    0
}
_____82F1_96C4_680F_5012_8BA1_65F6_6587_672C_7EC4_8868 = {
    nil,
    nil,
    nil,
    nil,
    nil
}
_____82F1_96C4_680F_5012_8BA1_65F6_5269_4F59_79D2_8868 = {
    0,
    0,
    0,
    0,
    0
}
local function _____662F_5426_672C_5730_82F1_96C4_680F_69FD_4F4D(_____69FD_4F4D)
    local localPlayer = GetLocalPlayer()
    if not _____662F_5426_6709_6548(localPlayer) then
        return false
    end
    return GetPlayerId(localPlayer) == _____69FD_4F4D
end
local function _____5341_500D_7CBE_5EA6_6587_672C(value)
    local _____5341_500D_6574_6570 = R2I(value * 10 + 0.5)
    local _____6574_6570_90E8_5206 = R2I(_____5341_500D_6574_6570 / 10)
    local _____5C0F_6570_90E8_5206 = _____5341_500D_6574_6570 - _____6574_6570_90E8_5206 * 10
    return (tostring(_____6574_6570_90E8_5206) .. ".") .. tostring(_____5C0F_6570_90E8_5206)
end
local function _____8F6C_767D_91D1_6587_672C(text)
    if text == "" then
        return ""
    end
    return ("|cfffff2d8" .. text) .. "|r"
end
local function _____8F6C_9634_5F71_6587_672C(text)
    if text == "" then
        return ""
    end
    return ("|cff101010" .. text) .. "|r"
end
local function _____8F6C_5E95_9634_5F71_6587_672C(text)
    if text == "" then
        return ""
    end
    return ("|cff080808" .. text) .. "|r"
end
local function _____8F6C_63CF_8FB9_6587_672C(text)
    if text == "" then
        return ""
    end
    return ("|cff3a2a18" .. text) .. "|r"
end
local function _____662F_5426_6709_82F1_96C4_680F_5012_8BA1_65F6_5728_8FD0_884C()
    do
        local i = 0
        while i < #_____82F1_96C4_680F_5012_8BA1_65F6_5269_4F59_79D2_8868 do
            if _____82F1_96C4_680F_5012_8BA1_65F6_5269_4F59_79D2_8868[i + 1] > 0 then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____5237_65B0_82F1_96C4_680F_5012_8BA1_65F6_6587_672C(_____69FD_4F4D)
    local _____6587_672C_7EC4 = _____82F1_96C4_680F_5012_8BA1_65F6_6587_672C_7EC4_8868[_____69FD_4F4D + 1]
    if _____6587_672C_7EC4 ~= nil then
        _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C(
            _____6587_672C_7EC4,
            _____5341_500D_7CBE_5EA6_6587_672C(_____82F1_96C4_680F_5012_8BA1_65F6_5269_4F59_79D2_8868[_____69FD_4F4D + 1])
        )
        _____663E_793A_51B7_5374_6570_5B57_6587_672C(
            _____6587_672C_7EC4,
            _____662F_5426_672C_5730_82F1_96C4_680F_69FD_4F4D(_____69FD_4F4D)
        )
        return
    end
    local _____5E95_9634_5F71_6846_4F53 = _____82F1_96C4_680F_5012_8BA1_65F6_5E95_9634_5F71_6846_4F53_8868[_____69FD_4F4D + 1]
    local _____5DE6_63CF_8FB9_6846_4F53 = _____82F1_96C4_680F_5012_8BA1_65F6_5DE6_63CF_8FB9_6846_4F53_8868[_____69FD_4F4D + 1]
    local _____53F3_63CF_8FB9_6846_4F53 = _____82F1_96C4_680F_5012_8BA1_65F6_53F3_63CF_8FB9_6846_4F53_8868[_____69FD_4F4D + 1]
    local _____9634_5F71_6846_4F53 = _____82F1_96C4_680F_5012_8BA1_65F6_9634_5F71_6846_4F53_8868[_____69FD_4F4D + 1]
    local _____6587_5B57_6846_4F53 = _____82F1_96C4_680F_5012_8BA1_65F6_6846_4F53_8868[_____69FD_4F4D + 1]
    if _____5E95_9634_5F71_6846_4F53 == 0 or _____5DE6_63CF_8FB9_6846_4F53 == 0 or _____53F3_63CF_8FB9_6846_4F53 == 0 or _____9634_5F71_6846_4F53 == 0 or _____6587_5B57_6846_4F53 == 0 then
        return
    end
    local _____6587_672C = _____5341_500D_7CBE_5EA6_6587_672C(_____82F1_96C4_680F_5012_8BA1_65F6_5269_4F59_79D2_8868[_____69FD_4F4D + 1])
    DzFrameSetText(
        _____5E95_9634_5F71_6846_4F53,
        _____8F6C_5E95_9634_5F71_6587_672C(_____6587_672C)
    )
    DzFrameSetText(
        _____5DE6_63CF_8FB9_6846_4F53,
        _____8F6C_63CF_8FB9_6587_672C(_____6587_672C)
    )
    DzFrameSetText(
        _____53F3_63CF_8FB9_6846_4F53,
        _____8F6C_63CF_8FB9_6587_672C(_____6587_672C)
    )
    DzFrameSetText(
        _____9634_5F71_6846_4F53,
        _____8F6C_9634_5F71_6587_672C(_____6587_672C)
    )
    DzFrameSetText(
        _____6587_5B57_6846_4F53,
        _____8F6C_767D_91D1_6587_672C(_____6587_672C)
    )
end
local function _____521B_5EFA_82F1_96C4_680F_5012_8BA1_65F6_6846_4F53(_____69FD_4F4D)
    local gameUI = DzGetGameUI()
    if gameUI == 0 then
        return 0
    end
    local button = DzFrameGetHeroBarButton(0)
    if button == 0 then
        return 0
    end
    local _____6587_672C_7EC4 = _____521B_5EFA_51B7_5374_6570_5B57_6587_672C_7EC4({
        ["名称前缀"] = ("英雄复活倒计时_" .. tostring(_____69FD_4F4D)) .. "_",
        ["父级"] = gameUI,
        ["宽度"] = _____82F1_96C4_680F_5012_8BA1_65F6_6587_5B57_5BBD_5EA6,
        ["高度"] = _____82F1_96C4_680F_5012_8BA1_65F6_6587_5B57_9AD8_5EA6,
        ["字体大小"] = _____82F1_96C4_680F_5012_8BA1_65F6_5B57_4F53_5927_5C0F,
        ["优先级"] = _____82F1_96C4_680F_5012_8BA1_65F6_6587_5B57_4F18_5148_7EA7,
        ["对齐"] = _____6587_672C_5BF9_9F50_5C45_4E2D,
        ["层"] = _____51B7_5374_6570_5B57_6587_672C_6A21_5757["英雄栏冷却数字层"]
    })
    if _____6587_672C_7EC4 == nil then
        return 0
    end
    _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C_951A_70B9(
        _____6587_672C_7EC4,
        button,
        _____5E27_70B9_4E2D_5FC3,
        _____5E27_70B9_4E2D_5FC3,
        _____82F1_96C4_680F_5012_8BA1_65F6_504F_79FBX,
        _____82F1_96C4_680F_5012_8BA1_65F6_504F_79FBY
    )
    _____663E_793A_51B7_5374_6570_5B57_6587_672C(_____6587_672C_7EC4, false)
    _____82F1_96C4_680F_5012_8BA1_65F6_6587_672C_7EC4_8868[_____69FD_4F4D + 1] = _____6587_672C_7EC4
    _____82F1_96C4_680F_5012_8BA1_65F6_6846_4F53_8868[_____69FD_4F4D + 1] = _____6587_672C_7EC4["主文本框体"]
    return _____6587_672C_7EC4["主文本框体"]
end
local function _____786E_4FDD_82F1_96C4_680F_5012_8BA1_65F6_6846_4F53(_____69FD_4F4D)
    if _____69FD_4F4D < 0 or _____69FD_4F4D >= #_____82F1_96C4_680F_5012_8BA1_65F6_6846_4F53_8868 then
        return 0
    end
    local oldFrame = _____82F1_96C4_680F_5012_8BA1_65F6_6846_4F53_8868[_____69FD_4F4D + 1]
    if oldFrame ~= 0 then
        return oldFrame
    end
    return _____521B_5EFA_82F1_96C4_680F_5012_8BA1_65F6_6846_4F53(_____69FD_4F4D)
end
local function _____521D_59CB_5316_82F1_96C4_680F_5012_8BA1_65F6_6846_4F53()
    if _____5DF2_521D_59CB_5316_82F1_96C4_680F_5012_8BA1_65F6 then
        return
    end
    _____5DF2_521D_59CB_5316_82F1_96C4_680F_5012_8BA1_65F6 = true
    do
        local i = 0
        while i < _____82F1_96C4_680F_6587_672C_6846_4F53_6570_91CF do
            _____786E_4FDD_82F1_96C4_680F_5012_8BA1_65F6_6846_4F53(i)
            i = i + 1
        end
    end
end
local function ____on_82F1_96C4_680F_5012_8BA1_65F6Tick()
    local _____4ECD_6709_5012_8BA1_65F6 = false
    do
        local i = 0
        while i < #_____82F1_96C4_680F_5012_8BA1_65F6_5269_4F59_79D2_8868 do
            do
                local _____5269_4F59_79D2 = _____82F1_96C4_680F_5012_8BA1_65F6_5269_4F59_79D2_8868[i + 1]
                if _____5269_4F59_79D2 <= 0 then
                    goto __continue47
                end
                local _____65B0_5269_4F59_79D2 = _____5269_4F59_79D2 - 0.01
                if _____65B0_5269_4F59_79D2 <= 0 then
                    _____9690_85CF_82F1_96C4_680F_5012_8BA1_65F6(i)
                    goto __continue47
                end
                _____82F1_96C4_680F_5012_8BA1_65F6_5269_4F59_79D2_8868[i + 1] = _____65B0_5269_4F59_79D2
                _____5237_65B0_82F1_96C4_680F_5012_8BA1_65F6_6587_672C(i)
                _____4ECD_6709_5012_8BA1_65F6 = true
            end
            ::__continue47::
            i = i + 1
        end
    end
    if not _____4ECD_6709_5012_8BA1_65F6 and _____5DF2_6CE8_518C_82F1_96C4_680F_5012_8BA1_65F6Tick then
        _____5DF2_6CE8_518C_82F1_96C4_680F_5012_8BA1_65F6Tick = false
        offTick10ms(____on_82F1_96C4_680F_5012_8BA1_65F6Tick)
    end
end
local function _____542F_52A8_82F1_96C4_680F_5012_8BA1_65F6(unit)
    local _____69FD_4F4D = _____53D6_82F1_96C4_680F_69FD_4F4D(unit)
    if _____69FD_4F4D < 0 then
        return
    end
    local frame = _____786E_4FDD_82F1_96C4_680F_5012_8BA1_65F6_6846_4F53(_____69FD_4F4D)
    if frame == 0 then
        return
    end
    _____82F1_96C4_680F_5012_8BA1_65F6_5269_4F59_79D2_8868[_____69FD_4F4D + 1] = _____590D_6D3B_5EF6_8FDF_79D2
    _____5237_65B0_82F1_96C4_680F_5012_8BA1_65F6_6587_672C(_____69FD_4F4D)
    local _____5E95_9634_5F71_6846_4F53 = _____82F1_96C4_680F_5012_8BA1_65F6_5E95_9634_5F71_6846_4F53_8868[_____69FD_4F4D + 1]
    local _____5DE6_63CF_8FB9_6846_4F53 = _____82F1_96C4_680F_5012_8BA1_65F6_5DE6_63CF_8FB9_6846_4F53_8868[_____69FD_4F4D + 1]
    local _____53F3_63CF_8FB9_6846_4F53 = _____82F1_96C4_680F_5012_8BA1_65F6_53F3_63CF_8FB9_6846_4F53_8868[_____69FD_4F4D + 1]
    local _____9634_5F71_6846_4F53 = _____82F1_96C4_680F_5012_8BA1_65F6_9634_5F71_6846_4F53_8868[_____69FD_4F4D + 1]
    local _____672C_5730_53EF_89C1 = _____662F_5426_672C_5730_82F1_96C4_680F_69FD_4F4D(_____69FD_4F4D)
    if _____5E95_9634_5F71_6846_4F53 ~= 0 then
        DzFrameShow(_____5E95_9634_5F71_6846_4F53, _____672C_5730_53EF_89C1)
    end
    if _____5DE6_63CF_8FB9_6846_4F53 ~= 0 then
        DzFrameShow(_____5DE6_63CF_8FB9_6846_4F53, _____672C_5730_53EF_89C1)
    end
    if _____53F3_63CF_8FB9_6846_4F53 ~= 0 then
        DzFrameShow(_____53F3_63CF_8FB9_6846_4F53, _____672C_5730_53EF_89C1)
    end
    if _____9634_5F71_6846_4F53 ~= 0 then
        DzFrameShow(_____9634_5F71_6846_4F53, _____672C_5730_53EF_89C1)
    end
    DzFrameShow(frame, _____672C_5730_53EF_89C1)
    if not _____5DF2_6CE8_518C_82F1_96C4_680F_5012_8BA1_65F6Tick then
        _____5DF2_6CE8_518C_82F1_96C4_680F_5012_8BA1_65F6Tick = true
        onTick10ms(____on_82F1_96C4_680F_5012_8BA1_65F6Tick)
    end
end
local function ____on_82F1_96C4_6B7B_4EA1_5EF6_8FDF_590D_6D3B(variable)
    _____6267_884C_590D_6D3B(variable)
end
local function _____82F1_96C4_6B7B_4EA1_5EF6_8FDF_590D_6D3B(dyingUnit, _____51FB_6740_8005)
    if not _____662F_73A9_5BB6_82F1_96C4(dyingUnit) then
        return
    end
    _____542F_52A8_82F1_96C4_680F_5012_8BA1_65F6(dyingUnit)
    addDelayedCallback(_____590D_6D3B_5EF6_8FDF_79D2 * 1000, ____on_82F1_96C4_6B7B_4EA1_5EF6_8FDF_590D_6D3B, dyingUnit)
end
____exports["初始化英雄复活"] = function()
    if _____5DF2_6CE8_518C_6B7B_4EA1 then
        return
    end
    _____5DF2_6CE8_518C_6B7B_4EA1 = true
    _____521D_59CB_5316_82F1_96C4_680F_5012_8BA1_65F6_6846_4F53()
    if _____8BBE_7F6E_6D4B_8BD5_6B21_6570 then
        YDUserDataSetSafe(
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
