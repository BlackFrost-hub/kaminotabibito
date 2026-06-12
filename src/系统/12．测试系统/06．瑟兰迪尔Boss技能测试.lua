--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stringToFourCC
function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
---
-- @noSelfInFile
local jass = require("jass.common")
local globals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_1.getRegisteredPlayerHero
local ____require_result_2 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_2.SelectUnitForPlayerSingle
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_3.StarOther_PanCameraToTimedForPlayer
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．瑟兰迪尔.14．月光碎片")
local _____521B_5EFA_745F_5170_8FEA_5C14_6708_5149_788E_7247 = ____require_result_4["创建瑟兰迪尔月光碎片"]
local _____6D4B_8BD5_547D_4EE4 = "thtest"
local _____6708_5149_788E_7247_6D4B_8BD5_547D_4EE4 = "thfrag"
local _____745F_5170_8FEA_5C14_5355_4F4DID = stringToFourCC("N057")
local _____6D4B_8BD5_9776_5B50_5355_4F4DID = stringToFourCC("hfoo")
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = 12
local CreateUnit = jass.CreateUnit
local Player = jass.Player
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetHeroLevel = jass.SetHeroLevel
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsOfPlayer = jass.GroupEnumUnitsOfPlayer
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local function _____63D0_793A(player, text)
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        8,
        "[瑟兰迪尔测试] " .. text
    )
end
local function _____662F_6709_6548_5B58_6D3B_82F1_96C4(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_HERO) == true and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    local registeredHero = getRegisteredPlayerHero(player)
    if _____662F_6709_6548_5B58_6D3B_82F1_96C4(registeredHero) then
        return registeredHero
    end
    local presetArchmage = globals.gg_unit_Hamg_0002
    if _____662F_6709_6548_5B58_6D3B_82F1_96C4(presetArchmage) then
        return presetArchmage
    end
    local group = CreateGroup()
    GroupEnumUnitsOfPlayer(group, player, nil)
    local result = nil
    local unit = FirstOfGroup(group)
    while unit ~= nil and unit ~= 0 do
        GroupRemoveUnit(group, unit)
        if _____662F_6709_6548_5B58_6D3B_82F1_96C4(unit) then
            result = unit
            break
        end
        unit = FirstOfGroup(group)
    end
    DestroyGroup(group)
    return result
end
local function ____on_745F_5170_8FEA_5C14_6D4B_8BD5_547D_4EE4(player)
    local hero = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    if hero == nil or hero == 0 then
        _____63D0_793A(player, "未找到注册英雄或预置大法师，无法创建测试 Boss。")
        return
    end
    local x = GetUnitX(hero) + 420
    local y = GetUnitY(hero)
    local boss = CreateUnit(
        player,
        _____745F_5170_8FEA_5C14_5355_4F4DID,
        x,
        y,
        180
    )
    local target = CreateUnit(
        Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
        _____6D4B_8BD5_9776_5B50_5355_4F4DID,
        x + 360,
        y,
        180
    )
    if boss ~= nil and boss ~= 0 then
        SetHeroLevel(boss, 10, false)
        SelectUnitForPlayerSingle(boss, player)
        StarOther_PanCameraToTimedForPlayer(player, x, y, 0.2)
    end
    if target == nil or target == 0 then
        _____63D0_793A(player, "已创建瑟兰迪尔，但测试靶子创建失败。")
        return
    end
    _____63D0_793A(player, "已创建瑟兰迪尔和敌对靶子。选中 Boss 后对靶子释放 AT05（月光枷锁）。")
end
local function ____on_6708_5149_788E_7247_6D4B_8BD5_547D_4EE4(player)
    local hero = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    if hero == nil or hero == 0 then
        _____63D0_793A(player, "未找到注册英雄或预置大法师，无法创建月光碎片。")
        return
    end
    _____521B_5EFA_745F_5170_8FEA_5C14_6708_5149_788E_7247(
        GetUnitX(hero) + 120,
        GetUnitY(hero)
    )
    _____63D0_793A(player, "已在英雄旁边创建月光碎片，可直接拾取测试移速 Buff。")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_745F_5170_8FEA_5C14_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6708_5149_788E_7247_6D4B_8BD5_547D_4EE4, ____on_6708_5149_788E_7247_6D4B_8BD5_547D_4EE4)
return ____exports
