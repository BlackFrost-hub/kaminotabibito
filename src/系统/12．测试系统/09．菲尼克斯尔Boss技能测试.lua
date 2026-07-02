--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stringToFourCC
function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local globals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_1.getRegisteredPlayerHero
local ____require_result_2 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_2.SelectUnitForPlayerSingle
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_3.StarOther_PanCameraToTimedForPlayer
local ____require_result_4 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.01．Boss自动技能注册表")
local _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8 = ____require_result_4["记录Boss自动技能启动"]
local ____require_result_5 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.03．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_5["应用Boss战启动属性配置"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587 = ____require_result_6["获取或创建菲尼克斯尔上下文"]
local _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_8FD0_884C_65F6 = ____require_result_6["注册菲尼克斯尔运行时"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.18．技能入口")
local _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_6280_80FD_7ED3_6784 = ____require_result_7["注册菲尼克斯尔技能结构"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.05．永恒冰核与导管")
local _____521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6C38_6052_51B0_6838_4E0E_5BFC_7BA1 = ____require_result_8["初始化菲尼克斯尔永恒冰核与导管"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.06．炽羽散射")
local _____91CA_653E_83F2_5C3C_514B_65AF_5C14_70BD_7FBD_6563_5C04 = ____require_result_9["释放菲尼克斯尔炽羽散射"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.07．熔岩吐息")
local _____91CA_653E_83F2_5C3C_514B_65AF_5C14_7194_5CA9_5410_606F = ____require_result_10["释放菲尼克斯尔熔岩吐息"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.08．凤凰漩涡")
local _____91CA_653E_83F2_5C3C_514B_65AF_5C14_51E4_51F0_6F29_6DA1 = ____require_result_11["释放菲尼克斯尔凤凰漩涡"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.09．浴火重生准备")
local _____89E6_53D1_83F2_5C3C_514B_65AF_5C14P1_8F6C_573A = ____require_result_12["触发菲尼克斯尔P1转场"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.04．双形态转换")
local _____5207_6362_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001 = ____require_result_13["切换菲尼克斯尔第二形态"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.11．骸骨弹幕")
local _____91CA_653E_83F2_5C3C_514B_65AF_5C14_9AB8_9AA8_5F39_5E55 = ____require_result_14["释放菲尼克斯尔骸骨弹幕"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.12．怨火链接")
local _____91CA_653E_83F2_5C3C_514B_65AF_5C14_6028_706B_94FE_63A5 = ____require_result_15["释放菲尼克斯尔怨火链接"]
local ____require_result_16 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.13．凤凰挽歌")
local _____91CA_653E_83F2_5C3C_514B_65AF_5C14_51E4_51F0_633D_6B4C = ____require_result_16["释放菲尼克斯尔凤凰挽歌"]
local ____require_result_17 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.14．元素爆发")
local _____7ED3_7B97_83F2_5C3C_514B_65AF_5C14_5143_7D20_7206_53D1 = ____require_result_17["结算菲尼克斯尔元素爆发"]
local ____require_result_18 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.15．怨火核心暴露")
local _____89E6_53D1_83F2_5C3C_514B_65AF_5C14_6028_706B_6838_5FC3_66B4_9732 = ____require_result_18["触发菲尼克斯尔怨火核心暴露"]
local ____require_result_19 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.16．永恒轮回")
local _____89E6_53D1_83F2_5C3C_514B_65AF_5C14_6C38_6052_8F6E_56DE = ____require_result_19["触发菲尼克斯尔永恒轮回"]
local ____require_result_20 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.19．公共工具")
local _____6DFB_52A0_5143_7D20_5C42_6570 = ____require_result_20["添加元素层数"]
local ____require_result_21 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.01．场地配置")
local _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E = ____require_result_21["菲尼克斯尔场地配置"]
local ____require_result_22 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04 = ____require_result_22["创建测试中心平移映射"]
local _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_5750_6807 = ____require_result_22["按测试映射平移坐标"]
local _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_77E9_5F62 = ____require_result_22["按测试映射平移矩形"]
local _____6D4B_8BD5_547D_4EE4 = "phtest"
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4DID = stringToFourCC("N00U")
local _____6D4B_8BD5_6B65_5175_5355_4F4DID = stringToFourCC("hfoo")
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = 12
local _____6D4B_8BD5_5355_4F4D_6700_5927_751F_547D_503C = 999999
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X = -540.6
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y = -2495.2
local _____4E34_65F6_6D4B_8BD5BossX = -540.6
local _____4E34_65F6_6D4B_8BD5BossY = -2495.2
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6X = -540.6
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y = -3055.2
local _____6D4B_8BD5_547D_4EE4_8BF4_660E = "phtest1炽羽散射 2熔岩吐息 3凤凰漩涡 4转场 5骸骨弹幕 6怨火链接 7凤凰挽歌 8元素爆发 9核心暴露 10永恒轮回。"
local _____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167 = {
    ["战斗矩形"] = {["左"] = -928, ["右"] = 2816, ["下"] = -11744, ["上"] = -7968},
    ["中心点"] = {x = 944, y = -9856},
    ["Boss初始点"] = {x = -244.6, y = -9805.3},
    ["永恒冰核点"] = {x = 944, y = -9856},
    ["导管点位"] = {{x = 44, y = -10756}, {x = 1844, y = -10756}, {x = 44, y = -8956}, {x = 1844, y = -8956}},
    ["怨火核心点"] = {x = 944, y = -9856},
    ["凤凰蛋点位"] = {{x = 44, y = -10756}, {x = 1844, y = -10756}, {x = 44, y = -8956}, {x = 1844, y = -8956}},
    ["挽歌安全区点位"] = {{x = 44, y = -10756, ["元素"] = "火"}, {x = 1844, y = -10756, ["元素"] = "冰"}, {x = 44, y = -8956, ["元素"] = "毒"}, {x = 1844, y = -8956, ["元素"] = "暗"}}
}
local CreateUnit = jass.CreateUnit
local Player = jass.Player
local GetOwningPlayer = jass.GetOwningPlayer
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local GetPlayerId = jass.GetPlayerId
local SetUnitState = jass.SetUnitState
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsOfPlayer = jass.GroupEnumUnitsOfPlayer
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local SetUnitStateJapi = japi.SetUnitState
local _____6700_8FD1_6D4B_8BD5Boss = {}
local _____6700_8FD1_6D4B_8BD5_6B65_51751 = {}
local _____6700_8FD1_6D4B_8BD5_6B65_51752 = {}
local function _____590D_5236_6620_5C04_83F2_5C3C_514B_65AF_5C14_70B9_4F4D_6570_7EC4(_____70B9_4F4D, _____6620_5C04)
    local result = {}
    do
        local i = 0
        while i < #_____70B9_4F4D do
            local mapped = _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_5750_6807(_____70B9_4F4D[i + 1], _____6620_5C04)
            if _____70B9_4F4D[i + 1]["元素"] ~= nil then
                result[#result + 1] = {x = mapped.x, y = mapped.y, ["元素"] = _____70B9_4F4D[i + 1]["元素"]}
            else
                result[#result + 1] = mapped
            end
            i = i + 1
        end
    end
    return result
end
local function _____5E94_7528_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_573A_5730()
    local _____6620_5C04 = _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["中心点"].x, _____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["中心点"].y, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y)
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["战斗矩形"] = _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_77E9_5F62(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["战斗矩形"], _____6620_5C04)
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["中心点"] = _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_5750_6807(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["中心点"], _____6620_5C04)
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["Boss初始点"] = _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_5750_6807(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["Boss初始点"], _____6620_5C04)
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["永恒冰核点"] = _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_5750_6807(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["永恒冰核点"], _____6620_5C04)
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["导管点位"] = _____590D_5236_6620_5C04_83F2_5C3C_514B_65AF_5C14_70B9_4F4D_6570_7EC4(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["导管点位"], _____6620_5C04)
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["怨火核心点"] = _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_5750_6807(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["怨火核心点"], _____6620_5C04)
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["凤凰蛋点位"] = _____590D_5236_6620_5C04_83F2_5C3C_514B_65AF_5C14_70B9_4F4D_6570_7EC4(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["凤凰蛋点位"], _____6620_5C04)
    _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["挽歌安全区点位"] = _____590D_5236_6620_5C04_83F2_5C3C_514B_65AF_5C14_70B9_4F4D_6570_7EC4(_____83F2_5C3C_514B_65AF_5C14_6B63_5F0F_6D4B_8BD5_573A_5730_5FEB_7167["挽歌安全区点位"], _____6620_5C04)
end
local function _____63D0_793A(player, text)
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        8,
        "[菲尼克斯尔测试] " .. text
    )
end
local function _____662F_6709_6548_5B58_6D3B_82F1_96C4(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_HERO) == true and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____662F_6709_6548_5B58_6D3B_5355_4F4D(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____662F_5F53_524D_73A9_5BB6_6D4B_8BD5_9776(unit, player)
    return _____662F_6709_6548_5B58_6D3B_5355_4F4D(unit) and GetPlayerId(GetOwningPlayer(unit)) == GetPlayerId(player)
end
local function _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(unit)
    if unit == nil or unit == 0 then
        return
    end
    SetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE, _____6D4B_8BD5_5355_4F4D_6700_5927_751F_547D_503C)
    SetUnitState(unit, UNIT_STATE_LIFE, _____6D4B_8BD5_5355_4F4D_6700_5927_751F_547D_503C)
end
local function _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    local presetArchmage = globals.gg_unit_Hamg_0002
    if _____662F_6709_6548_5B58_6D3B_82F1_96C4(presetArchmage) then
        return presetArchmage
    end
    local registeredHero = getRegisteredPlayerHero(player)
    if _____662F_6709_6548_5B58_6D3B_82F1_96C4(registeredHero) then
        return registeredHero
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
local function _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    local pid = GetPlayerId(player)
    local cached = _____6700_8FD1_6D4B_8BD5Boss[pid]
    if _____662F_6709_6548_5B58_6D3B_5355_4F4D(cached) then
        SetUnitPosition(cached, _____4E34_65F6_6D4B_8BD5BossX, _____4E34_65F6_6D4B_8BD5BossY)
        SetUnitFacing(cached, 270)
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(cached)
        return cached
    end
    local boss = CreateUnit(
        Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
        _____83F2_5C3C_514B_65AF_5C14_5355_4F4DID,
        _____4E34_65F6_6D4B_8BD5BossX,
        _____4E34_65F6_6D4B_8BD5BossY,
        270
    )
    if boss ~= nil and boss ~= 0 then
        _____6700_8FD1_6D4B_8BD5Boss[pid] = boss
        SetHeroLevel(boss, 40, false)
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
    end
    return boss
end
local function _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5_6B65_5175(_____7F13_5B58_8868, player, x, y)
    local pid = GetPlayerId(player)
    local cached = _____7F13_5B58_8868[pid]
    if _____662F_5F53_524D_73A9_5BB6_6D4B_8BD5_9776(cached, player) then
        SetUnitPosition(cached, x, y)
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(cached)
        return cached
    end
    local unit = CreateUnit(
        player,
        _____6D4B_8BD5_6B65_5175_5355_4F4DID,
        x,
        y,
        180
    )
    if unit ~= nil and unit ~= 0 then
        _____7F13_5B58_8868[pid] = unit
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(unit)
    end
    return unit
end
local function _____51C6_5907_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_573A_666F(player, hero, boss)
    SetUnitPosition(hero, _____4E34_65F6_6D4B_8BD5_73A9_5BB6X, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y)
    SetUnitFacing(hero, 90)
    _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_51751, player, _____4E34_65F6_6D4B_8BD5_73A9_5BB6X - 260, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180)
    _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_51752, player, _____4E34_65F6_6D4B_8BD5_73A9_5BB6X + 260, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180)
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y, 0.2)
    return _____83B7_53D6_6216_521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587(boss)
end
local function _____521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_4E0A_4E0B_6587(context)
    _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_8FD0_884C_65F6()
    _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_6280_80FD_7ED3_6784()
    _____5E94_7528_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_573A_5730()
    _____521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6C38_6052_51B0_6838_4E0E_5BFC_7BA1(context)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(context.Boss)
    _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8(context.Boss, "Boss战.单位")
end
local function _____521B_5EFA_5E76_521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5(player)
    local hero = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    if hero == nil or hero == 0 then
        _____63D0_793A(player, "未找到地图预设玩家1大法师，无法创建测试 Boss。")
        return nil
    end
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(boss) then
        _____63D0_793A(player, "菲尼克斯尔创建失败。")
        return nil
    end
    local context = _____51C6_5907_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_573A_666F(player, hero, boss)
    if context == nil then
        _____63D0_793A(player, "菲尼克斯尔上下文创建失败。")
        return nil
    end
    _____521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_4E0A_4E0B_6587(context)
    return context
end
local function _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
    if context["当前形态"] == "第一形态" then
        _____5207_6362_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
    end
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5E76_521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5(player)
    if context == nil then
        return
    end
    _____63D0_793A(player, "已创建/复用菲尼克斯尔测试场景，并登记 Boss 自动技能。" .. _____6D4B_8BD5_547D_4EE4_8BF4_660E)
end
local function _____6267_884C_83F2_5C3C_514B_65AF_5C14_6280_80FD_6D4B_8BD5(player, _____5E8F_53F7)
    local context = _____521B_5EFA_5E76_521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5(player)
    if context == nil then
        return
    end
    local hero = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    if _____5E8F_53F7 == 1 then
        _____91CA_653E_83F2_5C3C_514B_65AF_5C14_70BD_7FBD_6563_5C04(context, hero)
        _____63D0_793A(player, "已测试：炽羽散射。")
    elseif _____5E8F_53F7 == 2 then
        _____91CA_653E_83F2_5C3C_514B_65AF_5C14_7194_5CA9_5410_606F(context, hero)
        _____63D0_793A(player, "已测试：熔岩吐息。")
    elseif _____5E8F_53F7 == 3 then
        _____91CA_653E_83F2_5C3C_514B_65AF_5C14_51E4_51F0_6F29_6DA1(context, hero)
        _____63D0_793A(player, "已测试：凤凰漩涡。")
    elseif _____5E8F_53F7 == 4 then
        _____89E6_53D1_83F2_5C3C_514B_65AF_5C14P1_8F6C_573A(context)
        _____63D0_793A(player, "已测试：P1转场。")
    elseif _____5E8F_53F7 == 5 then
        _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
        _____91CA_653E_83F2_5C3C_514B_65AF_5C14_9AB8_9AA8_5F39_5E55(context)
        _____63D0_793A(player, "已测试：骸骨弹幕。")
    elseif _____5E8F_53F7 == 6 then
        _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
        _____91CA_653E_83F2_5C3C_514B_65AF_5C14_6028_706B_94FE_63A5(context)
        _____63D0_793A(player, "已测试：怨火链接。")
    elseif _____5E8F_53F7 == 7 then
        _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
        _____91CA_653E_83F2_5C3C_514B_65AF_5C14_51E4_51F0_633D_6B4C(context)
        _____63D0_793A(player, "已测试：凤凰挽歌。")
    elseif _____5E8F_53F7 == 8 then
        _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
        _____6DFB_52A0_5143_7D20_5C42_6570(hero, "火", 3, 30)
        _____6DFB_52A0_5143_7D20_5C42_6570(hero, "暗", 5, 30)
        _____7ED3_7B97_83F2_5C3C_514B_65AF_5C14_5143_7D20_7206_53D1(context)
        _____63D0_793A(player, "已测试：元素爆发，已给大法师预置火3/暗5。")
    elseif _____5E8F_53F7 == 9 then
        _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
        _____89E6_53D1_83F2_5C3C_514B_65AF_5C14_6028_706B_6838_5FC3_66B4_9732(context)
        _____63D0_793A(player, "已测试：怨火核心暴露。")
    elseif _____5E8F_53F7 == 10 then
        _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_7B2C_4E8C_5F62_6001(context)
        _____89E6_53D1_83F2_5C3C_514B_65AF_5C14_6C38_6052_8F6E_56DE(context)
        _____63D0_793A(player, "已测试：永恒轮回。")
    end
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD1_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_83F2_5C3C_514B_65AF_5C14_6280_80FD_6D4B_8BD5(player, 1)
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD2_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_83F2_5C3C_514B_65AF_5C14_6280_80FD_6D4B_8BD5(player, 2)
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD3_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_83F2_5C3C_514B_65AF_5C14_6280_80FD_6D4B_8BD5(player, 3)
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD4_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_83F2_5C3C_514B_65AF_5C14_6280_80FD_6D4B_8BD5(player, 4)
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD5_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_83F2_5C3C_514B_65AF_5C14_6280_80FD_6D4B_8BD5(player, 5)
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD6_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_83F2_5C3C_514B_65AF_5C14_6280_80FD_6D4B_8BD5(player, 6)
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD7_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_83F2_5C3C_514B_65AF_5C14_6280_80FD_6D4B_8BD5(player, 7)
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD8_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_83F2_5C3C_514B_65AF_5C14_6280_80FD_6D4B_8BD5(player, 8)
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD9_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_83F2_5C3C_514B_65AF_5C14_6280_80FD_6D4B_8BD5(player, 9)
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD10_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_83F2_5C3C_514B_65AF_5C14_6280_80FD_6D4B_8BD5(player, 10)
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_83F2_5C3C_514B_65AF_5C14_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("phtest1", ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD1_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("phtest2", ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD2_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("phtest3", ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD3_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("phtest4", ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD4_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("phtest5", ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD5_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("phtest6", ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD6_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("phtest7", ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD7_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("phtest8", ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD8_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("phtest9", ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD9_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("phtest10", ____on_83F2_5C3C_514B_65AF_5C14_6280_80FD10_6D4B_8BD5_547D_4EE4)
return ____exports
