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
local ____require_result_4 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8 = ____require_result_4["记录Boss自动技能启动"]
local ____require_result_5 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_5["应用Boss战启动属性配置"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587 = ____require_result_6["获取或创建树魔首领上下文"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.10．被动效果")
local _____6CE8_518C_6811_9B54_9996_9886_88AB_52A8_6548_679C = ____require_result_7["注册树魔首领被动效果"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.04．扩散冲击波")
local _____91CA_653E_6811_9B54_9996_9886_6269_6563_51B2_51FB_6CE2 = ____require_result_8["释放树魔首领扩散冲击波"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.05．消耗反击")
local _____91CA_653E_6811_9B54_9996_9886_6D88_8017_53CD_51FB = ____require_result_9["释放树魔首领消耗反击"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.06．远古诅咒")
local _____91CA_653E_6811_9B54_9996_9886_8FDC_53E4_8BC5_5492 = ____require_result_10["释放树魔首领远古诅咒"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.07．树魔图腾")
local _____91CA_653E_6811_9B54_9996_9886_6811_9B54_56FE_817E = ____require_result_11["释放树魔首领树魔图腾"]
local ____require_result_12 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_12.getServerTime
local ____require_result_13 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_13["标记测试Boss跳过死亡结算"]
local _____6D4B_8BD5_547D_4EE4 = "smltest"
local _____6811_9B54_9996_9886_5355_4F4DID = stringToFourCC("N05S")
local _____6D4B_8BD5_8F85_52A9_82F1_96C4ID = stringToFourCC("Hpal")
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = 12
local _____6D4B_8BD5_5355_4F4D_6700_5927_751F_547D_503C = 999999
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X = -540.6
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y = -2495.2
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y = -3055.2
local _____6D4B_8BD5_547D_4EE4_8BF4_660E = "smltest1扩散冲击波 2消耗反击 3远古诅咒 4树魔图腾 5立即召唤随从。"
local CreateUnit = jass.CreateUnit
local Player = jass.Player
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
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
local _____6700_8FD1_6D4B_8BD5_8F85_52A9_82F1_96C41 = {}
local _____6700_8FD1_6D4B_8BD5_8F85_52A9_82F1_96C42 = {}
local function _____63D0_793A(player, text)
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        8,
        "[树魔首领测试] " .. text
    )
end
local function _____662F_6709_6548_5B58_6D3B_82F1_96C4(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_HERO) == true and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____662F_6709_6548_5B58_6D3B_5355_4F4D(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
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
        SetUnitPosition(cached, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y)
        SetUnitFacing(cached, 270)
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(cached)
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(cached)
        globals.udg_Boss = cached
        return cached
    end
    local boss = CreateUnit(
        Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
        _____6811_9B54_9996_9886_5355_4F4DID,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y,
        270
    )
    if boss ~= nil and boss ~= 0 then
        _____6700_8FD1_6D4B_8BD5Boss[pid] = boss
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
        SetHeroLevel(boss, 35, false)
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
        globals.udg_Boss = boss
    end
    return boss
end
local function _____83B7_53D6_6216_521B_5EFA_8F85_52A9_82F1_96C4(_____7F13_5B58_8868, ownerId, x, y)
    local cached = _____7F13_5B58_8868[ownerId]
    if _____662F_6709_6548_5B58_6D3B_82F1_96C4(cached) then
        SetUnitPosition(cached, x, y)
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(cached)
        return cached
    end
    local unit = CreateUnit(
        Player(ownerId),
        _____6D4B_8BD5_8F85_52A9_82F1_96C4ID,
        x,
        y,
        90
    )
    if unit ~= nil and unit ~= 0 then
        _____7F13_5B58_8868[ownerId] = unit
        SetHeroLevel(unit, 10, false)
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(unit)
    end
    return unit
end
local function _____51C6_5907_6811_9B54_9996_9886_6D4B_8BD5_573A_666F(player, hero, boss)
    SetUnitPosition(hero, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y)
    SetUnitFacing(hero, 90)
    _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    _____83B7_53D6_6216_521B_5EFA_8F85_52A9_82F1_96C4(_____6700_8FD1_6D4B_8BD5_8F85_52A9_82F1_96C41, 1, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X - 180, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 90)
    _____83B7_53D6_6216_521B_5EFA_8F85_52A9_82F1_96C4(_____6700_8FD1_6D4B_8BD5_8F85_52A9_82F1_96C42, 2, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X + 180, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 90)
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y, 0.2)
    return _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587(boss)
end
local function _____521B_5EFA_5E76_521D_59CB_5316_6811_9B54_9996_9886_6D4B_8BD5(player)
    local hero = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    if hero == nil or hero == 0 then
        _____63D0_793A(player, "未找到地图预设玩家1大法师，无法创建测试 Boss。")
        return nil
    end
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(boss) then
        _____63D0_793A(player, "树魔首领创建失败。")
        return nil
    end
    _____6CE8_518C_6811_9B54_9996_9886_88AB_52A8_6548_679C()
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
    _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8(boss, "Boss战.单位")
    local context = _____51C6_5907_6811_9B54_9996_9886_6D4B_8BD5_573A_666F(player, hero, boss)
    if context == nil then
        _____63D0_793A(player, "树魔首领上下文创建失败。")
    end
    return context
end
local function ____on_6811_9B54_9996_9886_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5E76_521D_59CB_5316_6811_9B54_9996_9886_6D4B_8BD5(player)
    if context == nil then
        return
    end
    _____63D0_793A(player, "已创建/复用树魔首领测试场景，并登记 Boss 自动技能。" .. _____6D4B_8BD5_547D_4EE4_8BF4_660E)
end
local function _____6267_884C_6811_9B54_9996_9886_6280_80FD_6D4B_8BD5(player, _____5E8F_53F7)
    local context = _____521B_5EFA_5E76_521D_59CB_5316_6811_9B54_9996_9886_6D4B_8BD5(player)
    if context == nil then
        return
    end
    if _____5E8F_53F7 == 1 then
        _____91CA_653E_6811_9B54_9996_9886_6269_6563_51B2_51FB_6CE2(context)
        _____63D0_793A(player, "已测试：扩散冲击波。")
    elseif _____5E8F_53F7 == 2 then
        _____91CA_653E_6811_9B54_9996_9886_6D88_8017_53CD_51FB(context)
        _____63D0_793A(player, "已测试：消耗反击。请从正面/背后攻击 Boss 验证反击与破招。")
    elseif _____5E8F_53F7 == 3 then
        _____91CA_653E_6811_9B54_9996_9886_8FDC_53E4_8BC5_5492(context)
        _____63D0_793A(player, "已测试：远古诅咒。三个测试英雄已聚在 400 码附近，便于观察分摊。")
    elseif _____5E8F_53F7 == 4 then
        _____91CA_653E_6811_9B54_9996_9886_6811_9B54_56FE_817E(context)
        _____63D0_793A(player, "已测试：树魔图腾。")
    elseif _____5E8F_53F7 == 5 then
        context["随从特性已初始化"] = true
        context["下一次召唤Ms"] = getServerTime()
        _____63D0_793A(player, "已把下一次随从召唤推进到立刻，等待 1 秒左右观察随从与 Buff 切换。")
    end
end
local function ____on_6811_9B54_9996_9886_6280_80FD1_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_6811_9B54_9996_9886_6280_80FD_6D4B_8BD5(player, 1)
end
local function ____on_6811_9B54_9996_9886_6280_80FD2_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_6811_9B54_9996_9886_6280_80FD_6D4B_8BD5(player, 2)
end
local function ____on_6811_9B54_9996_9886_6280_80FD3_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_6811_9B54_9996_9886_6280_80FD_6D4B_8BD5(player, 3)
end
local function ____on_6811_9B54_9996_9886_6280_80FD4_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_6811_9B54_9996_9886_6280_80FD_6D4B_8BD5(player, 4)
end
local function ____on_6811_9B54_9996_9886_6280_80FD5_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_6811_9B54_9996_9886_6280_80FD_6D4B_8BD5(player, 5)
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_6811_9B54_9996_9886_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("smltest1", ____on_6811_9B54_9996_9886_6280_80FD1_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("smltest2", ____on_6811_9B54_9996_9886_6280_80FD2_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("smltest3", ____on_6811_9B54_9996_9886_6280_80FD3_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("smltest4", ____on_6811_9B54_9996_9886_6280_80FD4_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("smltest5", ____on_6811_9B54_9996_9886_6280_80FD5_6D4B_8BD5_547D_4EE4)
return ____exports
