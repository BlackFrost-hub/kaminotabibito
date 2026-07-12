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
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587 = ____require_result_6["获取或创建米亚上下文"]
local _____6CE8_518C_7C73_4E9A_8FD0_884C_65F6 = ____require_result_6["注册米亚运行时"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.03．运行时上下文")
local _____7ED9_5355_4F4D_6DFB_52A0_7C73_4E9A_8150_5316_5C42_6570 = ____require_result_7["给单位添加米亚腐化层数"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.16．技能入口")
local _____6CE8_518C_7C73_4E9A_6280_80FD_7ED3_6784 = ____require_result_8["注册米亚技能结构"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.05．腐化爪击")
local _____91CA_653E_7C73_4E9A_8150_5316_722A_51FB = ____require_result_9["释放米亚腐化爪击"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.06．污水喷吐")
local _____91CA_653E_7C73_4E9A_6C61_6C34_55B7_5410 = ____require_result_10["释放米亚污水喷吐"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.07．灵猫分身")
local _____5C1D_8BD5_89E6_53D1_7C73_4E9A_7075_732B_5206_8EAB = ____require_result_11["尝试触发米亚灵猫分身"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.08．污染标记")
local _____5237_65B0_7C73_4E9A_6C61_67D3_6807_8BB0 = ____require_result_12["刷新米亚污染标记"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.09．污染脉冲")
local _____5C1D_8BD5_89E6_53D1_7C73_4E9A_6C61_67D3_8109_51B2 = ____require_result_13["尝试触发米亚污染脉冲"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.10．污水柱爆发")
local _____5C1D_8BD5_89E6_53D1_7C73_4E9A_6C61_6C34_67F1_7206_53D1 = ____require_result_14["尝试触发米亚污水柱爆发"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.11．腐化转移")
local _____5C1D_8BD5_89E6_53D1_7C73_4E9A_8150_5316_8F6C_79FB = ____require_result_15["尝试触发米亚腐化转移"]
local ____require_result_16 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.12．平台超载惩罚")
local _____5237_65B0_7C73_4E9A_5E73_53F0_8D85_8F7D_60E9_7F5A = ____require_result_16["刷新米亚平台超载惩罚"]
local ____require_result_17 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.13．腐化黏液涂层")
local _____5237_65B0_7C73_4E9A_8150_5316_9ECF_6DB2_6D82_5C42 = ____require_result_17["刷新米亚腐化黏液涂层"]
local ____require_result_18 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.14．终极污染")
local _____5C1D_8BD5_89E6_53D1_7C73_4E9A_7EC8_6781_6C61_67D3 = ____require_result_18["尝试触发米亚终极污染"]
local ____require_result_19 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.01．场地配置")
local _____7C73_4E9A_9ED8_8BA4_5E73_53F0_4E2D_5FC3_914D_7F6E = ____require_result_19["米亚默认平台中心配置"]
local _____7C73_4E9A_9ED8_8BA4_5B89_5168_57DF_914D_7F6E_8868 = ____require_result_19["米亚默认安全域配置表"]
local _____8BBE_7F6E_7C73_4E9A_573A_5730_914D_7F6E = ____require_result_19["设置米亚场地配置"]
local _____6E05_7406_7C73_4E9A_5B89_5168_57DF_77E9_5F62_7EC4 = ____require_result_19["清理米亚安全域矩形组"]
local ____require_result_20 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.01．场地配置")
local _____521B_5EFA_7C73_4E9A_5B89_5168_57DF_77E9_5F62_7EC4 = ____require_result_20["创建米亚安全域矩形组"]
local ____require_result_21 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04 = ____require_result_21["创建测试中心平移映射"]
local _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_77E9_5F62 = ____require_result_21["按测试映射平移矩形"]
local _____590D_5236_5E73_79FB_6D4B_8BD5_77E9_5F62_6570_7EC4 = ____require_result_21["复制平移测试矩形数组"]
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_21["标记测试Boss跳过死亡结算"]
local ____require_result_22 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_22.getServerTime
local _____6D4B_8BD5_547D_4EE4 = "miatest"
local _____7C73_4E9A_5355_4F4DID = stringToFourCC("N00V")
local _____6D4B_8BD5_6B65_5175_5355_4F4DID = stringToFourCC("hfoo")
local _____6D4B_8BD5_526F_82F1_96C4_5355_4F4DID = stringToFourCC("Hpal")
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = 12
local _____6D4B_8BD5_5355_4F4D_6700_5927_751F_547D_503C = 999999
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X = -540.6
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y = -2495.2
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6X = -540.6
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y = -3055.2
local _____6D4B_8BD5_547D_4EE4_8BF4_660E = "miatest1腐化爪击 2污水喷吐 3灵猫分身 4污染标记 5污染脉冲 6污水柱爆发 7腐化转移 8平台超载 9腐化黏液涂层 10终极污染。"
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
local _____6700_8FD1_6D4B_8BD5_6B65_51751 = {}
local _____6700_8FD1_6D4B_8BD5_6B65_51752 = {}
local _____6700_8FD1_6D4B_8BD5_526F_82F1_96C4 = {}
local function _____63D0_793A(player, text)
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        8,
        "[米亚测试] " .. text
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
        SetUnitPosition(cached, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y)
        SetUnitFacing(cached, 270)
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(cached)
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(cached)
        return cached
    end
    local boss = CreateUnit(
        Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
        _____7C73_4E9A_5355_4F4DID,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y,
        270
    )
    if boss ~= nil and boss ~= 0 then
        _____6700_8FD1_6D4B_8BD5Boss[pid] = boss
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
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
local function _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5_526F_82F1_96C4(player, x, y)
    local pid = GetPlayerId(player)
    local cached = _____6700_8FD1_6D4B_8BD5_526F_82F1_96C4[pid]
    if _____662F_5F53_524D_73A9_5BB6_6D4B_8BD5_9776(cached, player) and IsUnitType(cached, UNIT_TYPE_HERO) == true then
        SetUnitPosition(cached, x, y)
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(cached)
        return cached
    end
    local unit = CreateUnit(
        player,
        _____6D4B_8BD5_526F_82F1_96C4_5355_4F4DID,
        x,
        y,
        180
    )
    if unit ~= nil and unit ~= 0 then
        _____6700_8FD1_6D4B_8BD5_526F_82F1_96C4[pid] = unit
        SetHeroLevel(unit, 40, false)
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(unit)
    end
    return unit
end
local function _____5E94_7528_7C73_4E9A_6D4B_8BD5_573A_5730_914D_7F6E(context)
    local _____6B63_5F0F_4E2D_5FC3X = (_____7C73_4E9A_9ED8_8BA4_5E73_53F0_4E2D_5FC3_914D_7F6E["左"] + _____7C73_4E9A_9ED8_8BA4_5E73_53F0_4E2D_5FC3_914D_7F6E["右"]) / 2
    local _____6B63_5F0F_4E2D_5FC3Y = (_____7C73_4E9A_9ED8_8BA4_5E73_53F0_4E2D_5FC3_914D_7F6E["下"] + _____7C73_4E9A_9ED8_8BA4_5E73_53F0_4E2D_5FC3_914D_7F6E["上"]) / 2
    local _____6620_5C04 = _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04(_____6B63_5F0F_4E2D_5FC3X, _____6B63_5F0F_4E2D_5FC3Y, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y)
    local _____6D4B_8BD5_5E73_53F0_4E2D_5FC3_914D_7F6E = _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_77E9_5F62(_____7C73_4E9A_9ED8_8BA4_5E73_53F0_4E2D_5FC3_914D_7F6E, _____6620_5C04)
    local _____6D4B_8BD5_5B89_5168_57DF_914D_7F6E_8868 = _____590D_5236_5E73_79FB_6D4B_8BD5_77E9_5F62_6570_7EC4(_____7C73_4E9A_9ED8_8BA4_5B89_5168_57DF_914D_7F6E_8868, _____6620_5C04)
    _____8BBE_7F6E_7C73_4E9A_573A_5730_914D_7F6E(_____6D4B_8BD5_5B89_5168_57DF_914D_7F6E_8868, _____6D4B_8BD5_5E73_53F0_4E2D_5FC3_914D_7F6E)
    if context ~= nil then
        _____6E05_7406_7C73_4E9A_5B89_5168_57DF_77E9_5F62_7EC4(context["安全域区域组"])
        context["安全域区域组"] = _____521B_5EFA_7C73_4E9A_5B89_5168_57DF_77E9_5F62_7EC4()
    end
end
local function _____51C6_5907_7C73_4E9A_6D4B_8BD5_573A_666F(player, hero, boss)
    SetUnitPosition(hero, _____4E34_65F6_6D4B_8BD5_73A9_5BB6X, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y)
    SetUnitFacing(hero, 90)
    _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_51751, player, _____4E34_65F6_6D4B_8BD5_73A9_5BB6X - 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 220)
    _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_51752, player, _____4E34_65F6_6D4B_8BD5_73A9_5BB6X + 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 220)
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y, 0.2)
    _____5E94_7528_7C73_4E9A_6D4B_8BD5_573A_5730_914D_7F6E(nil)
    local context = _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587(boss)
    _____5E94_7528_7C73_4E9A_6D4B_8BD5_573A_5730_914D_7F6E(context)
    return context
end
local function _____521D_59CB_5316_7C73_4E9A_6D4B_8BD5_4E0A_4E0B_6587(context)
    _____6CE8_518C_7C73_4E9A_8FD0_884C_65F6()
    _____6CE8_518C_7C73_4E9A_6280_80FD_7ED3_6784()
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(context["Boss单位"])
    _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8(context["Boss单位"], "Boss战.单位")
end
local function _____521B_5EFA_5E76_521D_59CB_5316_7C73_4E9A_6D4B_8BD5(player)
    local hero = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    if hero == nil or hero == 0 then
        _____63D0_793A(player, "未找到地图预设玩家1大法师，无法创建测试 Boss。")
        return nil
    end
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(boss) then
        _____63D0_793A(player, "米亚创建失败。")
        return nil
    end
    local context = _____51C6_5907_7C73_4E9A_6D4B_8BD5_573A_666F(player, hero, boss)
    if context == nil then
        _____63D0_793A(player, "米亚上下文创建失败。")
        return nil
    end
    _____521D_59CB_5316_7C73_4E9A_6D4B_8BD5_4E0A_4E0B_6587(context)
    return context
end
local function ____on_7C73_4E9A_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5E76_521D_59CB_5316_7C73_4E9A_6D4B_8BD5(player)
    if context == nil then
        return
    end
    _____63D0_793A(player, "已创建/复用米亚测试场景，并登记 Boss 自动技能。" .. _____6D4B_8BD5_547D_4EE4_8BF4_660E)
end
local function _____6267_884C_7C73_4E9A_6280_80FD_6D4B_8BD5(player, _____5E8F_53F7)
    local context = _____521B_5EFA_5E76_521D_59CB_5316_7C73_4E9A_6D4B_8BD5(player)
    if context == nil then
        return
    end
    local hero = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    local nowMs = getServerTime()
    if _____5E8F_53F7 == 1 then
        _____91CA_653E_7C73_4E9A_8150_5316_722A_51FB(context, hero)
        _____63D0_793A(player, "已测试：腐化爪击。")
    elseif _____5E8F_53F7 == 2 then
        _____91CA_653E_7C73_4E9A_6C61_6C34_55B7_5410(context)
        _____63D0_793A(player, "已测试：污水喷吐。")
    elseif _____5E8F_53F7 == 3 then
        context["阶段"] = 1
        context["已触发分身80"] = false
        SetUnitState(context["Boss单位"], UNIT_STATE_LIFE, _____6D4B_8BD5_5355_4F4D_6700_5927_751F_547D_503C * 0.75)
        _____5C1D_8BD5_89E6_53D1_7C73_4E9A_7075_732B_5206_8EAB(context)
        _____63D0_793A(player, "已测试：灵猫分身。")
    elseif _____5E8F_53F7 == 4 then
        context["阶段"] = 1
        context["上次污染标记Ms"] = 0
        _____7ED9_5355_4F4D_6DFB_52A0_7C73_4E9A_8150_5316_5C42_6570(context, hero, 5, "米亚测试污染标记")
        _____5237_65B0_7C73_4E9A_6C61_67D3_6807_8BB0(context, nowMs)
        _____63D0_793A(player, "已测试：污染标记。")
    elseif _____5E8F_53F7 == 5 then
        context["阶段"] = 2
        context["上次污染脉冲Ms"] = 0
        _____5C1D_8BD5_89E6_53D1_7C73_4E9A_6C61_67D3_8109_51B2(context, nowMs)
        _____63D0_793A(player, "已测试：污染脉冲。")
    elseif _____5E8F_53F7 == 6 then
        context["阶段"] = 2
        context["上次污水柱爆发Ms"] = 0
        _____5C1D_8BD5_89E6_53D1_7C73_4E9A_6C61_6C34_67F1_7206_53D1(context, nowMs)
        _____63D0_793A(player, "已测试：污水柱爆发。")
    elseif _____5E8F_53F7 == 7 then
        context["阶段"] = 2
        context["上次腐化转移Ms"] = 0
        context["腐化转移污染平台ID"] = ""
        _____5C1D_8BD5_89E6_53D1_7C73_4E9A_8150_5316_8F6C_79FB(context, nowMs)
        _____63D0_793A(player, "已测试：腐化转移。")
    elseif _____5E8F_53F7 == 8 then
        context["阶段"] = 2
        context["上次平台超载检测Ms"] = 0
        local _____533A_57DF = context["安全域区域组"]["区域列表"][0]
        if _____533A_57DF ~= nil then
            SetUnitPosition(hero, _____533A_57DF["中心X"] - 45, _____533A_57DF["中心Y"])
            _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5_526F_82F1_96C4(player, _____533A_57DF["中心X"] + 45, _____533A_57DF["中心Y"])
        end
        _____5237_65B0_7C73_4E9A_5E73_53F0_8D85_8F7D_60E9_7F5A(context, nowMs)
        _____63D0_793A(player, "已测试：平台超载。")
    elseif _____5E8F_53F7 == 9 then
        context["阶段"] = 3
        context["上次全场甩黏液Ms"] = 0
        _____5237_65B0_7C73_4E9A_8150_5316_9ECF_6DB2_6D82_5C42(context, nowMs)
        _____63D0_793A(player, "已测试：腐化黏液涂层。")
    elseif _____5E8F_53F7 == 10 then
        context["阶段"] = 3
        context["终极污染引导中"] = false
        context["已触发终极污染30"] = false
        SetUnitState(context["Boss单位"], UNIT_STATE_LIFE, _____6D4B_8BD5_5355_4F4D_6700_5927_751F_547D_503C * 0.25)
        _____5C1D_8BD5_89E6_53D1_7C73_4E9A_7EC8_6781_6C61_67D3(context)
        _____63D0_793A(player, "已测试：终极污染。")
    end
end
local function ____on_7C73_4E9A_6280_80FD1_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_7C73_4E9A_6280_80FD_6D4B_8BD5(player, 1)
end
local function ____on_7C73_4E9A_6280_80FD2_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_7C73_4E9A_6280_80FD_6D4B_8BD5(player, 2)
end
local function ____on_7C73_4E9A_6280_80FD3_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_7C73_4E9A_6280_80FD_6D4B_8BD5(player, 3)
end
local function ____on_7C73_4E9A_6280_80FD4_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_7C73_4E9A_6280_80FD_6D4B_8BD5(player, 4)
end
local function ____on_7C73_4E9A_6280_80FD5_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_7C73_4E9A_6280_80FD_6D4B_8BD5(player, 5)
end
local function ____on_7C73_4E9A_6280_80FD6_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_7C73_4E9A_6280_80FD_6D4B_8BD5(player, 6)
end
local function ____on_7C73_4E9A_6280_80FD7_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_7C73_4E9A_6280_80FD_6D4B_8BD5(player, 7)
end
local function ____on_7C73_4E9A_6280_80FD8_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_7C73_4E9A_6280_80FD_6D4B_8BD5(player, 8)
end
local function ____on_7C73_4E9A_6280_80FD9_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_7C73_4E9A_6280_80FD_6D4B_8BD5(player, 9)
end
local function ____on_7C73_4E9A_6280_80FD10_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_7C73_4E9A_6280_80FD_6D4B_8BD5(player, 10)
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_7C73_4E9A_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("miatest1", ____on_7C73_4E9A_6280_80FD1_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("miatest2", ____on_7C73_4E9A_6280_80FD2_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("miatest3", ____on_7C73_4E9A_6280_80FD3_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("miatest4", ____on_7C73_4E9A_6280_80FD4_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("miatest5", ____on_7C73_4E9A_6280_80FD5_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("miatest6", ____on_7C73_4E9A_6280_80FD6_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("miatest7", ____on_7C73_4E9A_6280_80FD7_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("miatest8", ____on_7C73_4E9A_6280_80FD8_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("miatest9", ____on_7C73_4E9A_6280_80FD9_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("miatest10", ____on_7C73_4E9A_6280_80FD10_6D4B_8BD5_547D_4EE4)
return ____exports
