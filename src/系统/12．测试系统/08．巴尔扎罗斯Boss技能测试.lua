--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stringToFourCC, _____662F_6709_6548_5B58_6D3B_5355_4F4D, _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840, _____6D4B_8BD5_5355_4F4D_6700_5927_751F_547D_503C, SetUnitState, IsUnitType, UNIT_TYPE_DEAD, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE, SetUnitStateJapi
function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
function _____662F_6709_6548_5B58_6D3B_5355_4F4D(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
function _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(unit)
    if unit == nil or unit == 0 then
        return
    end
    SetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE, _____6D4B_8BD5_5355_4F4D_6700_5927_751F_547D_503C)
    SetUnitState(unit, UNIT_STATE_LIFE, _____6D4B_8BD5_5355_4F4D_6700_5927_751F_547D_503C)
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
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587 = ____require_result_6["获取或创建巴尔扎罗斯上下文"]
local _____6CE8_518C_5DF4_5C14_624E_7F57_65AF_8FD0_884C_65F6 = ____require_result_6["注册巴尔扎罗斯运行时"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.15．技能入口")
local _____6CE8_518C_5DF4_5C14_624E_7F57_65AF_6280_80FD_7ED3_6784 = ____require_result_7["注册巴尔扎罗斯技能结构"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.04．熔核封印与护卫机制")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_7194_6838_5C01_5370_4E0E_62A4_536B_673A_5236 = ____require_result_8["初始化巴尔扎罗斯熔核封印与护卫机制"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.index")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_683C_9C81_59C6_6280_80FD = ____require_result_9["初始化巴尔扎罗斯格鲁姆技能"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.02．护卫B塞拉.index")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_585E_62C9_6280_80FD = ____require_result_10["初始化巴尔扎罗斯塞拉技能"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.11．地核召唤")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_5730_6838_53EC_5524_8282_70B9 = ____require_result_11["初始化巴尔扎罗斯地核召唤节点"]
local _____91CA_653E_5DF4_5C14_624E_7F57_65AF_5730_6838_53EC_5524 = ____require_result_11["释放巴尔扎罗斯地核召唤"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.12．熔岩护盾")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_8282_70B9 = ____require_result_12["初始化巴尔扎罗斯熔岩护盾节点"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.13．末日熔爆")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_672B_65E5_7194_7206_8282_70B9 = ____require_result_13["初始化巴尔扎罗斯末日熔爆节点"]
local _____91CA_653E_5DF4_5C14_624E_7F57_65AF_672B_65E5_7194_7206 = ____require_result_13["释放巴尔扎罗斯末日熔爆"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.07．恶魔咆哮波")
local _____91CA_653E_5DF4_5C14_624E_7F57_65AF_6076_9B54_5486_54EE_6CE2 = ____require_result_14["释放巴尔扎罗斯恶魔咆哮波"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.08．王者天罚")
local _____91CA_653E_5DF4_5C14_624E_7F57_65AF_738B_8005_5929_7F5A = ____require_result_15["释放巴尔扎罗斯王者天罚"]
local ____require_result_16 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.09．熔岩喷发")
local _____91CA_653E_5DF4_5C14_624E_7F57_65AF_7194_5CA9_55B7_53D1 = ____require_result_16["释放巴尔扎罗斯熔岩喷发"]
local ____require_result_17 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.10．火焰锁链")
local _____91CA_653E_5DF4_5C14_624E_7F57_65AF_706B_7130_9501_94FE = ____require_result_17["释放巴尔扎罗斯火焰锁链"]
local ____require_result_18 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.index")
local _____91CA_653E_683C_9C81_59C6_91CD_9524 = ____require_result_18["释放格鲁姆重锤"]
local _____91CA_653E_683C_9C81_59C6_706B_5F84 = ____require_result_18["释放格鲁姆火径"]
local ____require_result_19 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.02．护卫B塞拉.index")
local _____91CA_653E_51B0_7130_53CC_661F = ____require_result_19["释放冰焰双星"]
local _____91CA_653E_7EDD_5BF9_96F6_5EA6_9886_57DF = ____require_result_19["释放绝对零度领域"]
local _____5207_6362_585E_62C9_5F62_6001 = ____require_result_19["切换塞拉形态"]
local ____require_result_20 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.01．场地配置")
local _____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E = ____require_result_20["巴尔扎罗斯战斗区域配置"]
local _____5DF4_5C14_624E_7F57_65AF_56FA_5B9A_5B89_5168_533A_914D_7F6E_8868 = ____require_result_20["巴尔扎罗斯固定安全区配置表"]
local ____require_result_21 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E = ____require_result_21["巴尔扎罗斯护卫配置"]
local ____require_result_22 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.02．战斗区域.index")
local _____521B_5EFA_52A8_6001_77E9_5F62_533A_57DF_7EC4 = ____require_result_22["创建动态矩形区域组"]
local _____9500_6BC1_52A8_6001_77E9_5F62_533A_57DF_7EC4 = ____require_result_22["销毁动态矩形区域组"]
local ____require_result_23 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04 = ____require_result_23["创建测试中心平移映射"]
local _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_77E9_5F62 = ____require_result_23["按测试映射平移矩形"]
local _____590D_5236_5E73_79FB_6D4B_8BD5_77E9_5F62_6570_7EC4 = ____require_result_23["复制平移测试矩形数组"]
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_23["标记测试Boss跳过死亡结算"]
local _____6D4B_8BD5_547D_4EE4 = "bztest"
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4DID = stringToFourCC("N03G")
local _____6D4B_8BD5_6B65_5175_5355_4F4DID = stringToFourCC("hfoo")
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = 12
_____6D4B_8BD5_5355_4F4D_6700_5927_751F_547D_503C = 999999
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X = -540.6
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y = -2495.2
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6X = -540.6
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y = -3055.2
local _____6D4B_8BD5_547D_4EE4_8BF4_660E = "bztest1恶魔咆哮波 2王者天罚 3熔岩喷发 4火焰锁链 5地核召唤 6末日熔爆 7格鲁姆重锤 8格鲁姆火径 9塞拉冰焰双星 10塞拉绝对零度 11塞拉切火 12塞拉切冰。"
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
SetUnitState = jass.SetUnitState
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsOfPlayer = jass.GroupEnumUnitsOfPlayer
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
IsUnitType = jass.IsUnitType
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
SetUnitStateJapi = japi.SetUnitState
local _____6700_8FD1_6D4B_8BD5Boss = {}
local _____6700_8FD1_6D4B_8BD5_6B65_51751 = {}
local _____6700_8FD1_6D4B_8BD5_6B65_51752 = {}
local function _____5E94_7528_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_573A_5730(context)
    local _____6B63_5F0F_4E2D_5FC3X = (_____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E["左"] + _____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E["右"]) / 2
    local _____6B63_5F0F_4E2D_5FC3Y = (_____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E["下"] + _____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E["上"]) / 2
    local _____6620_5C04 = _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04(_____6B63_5F0F_4E2D_5FC3X, _____6B63_5F0F_4E2D_5FC3Y, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y)
    local _____6D4B_8BD5_6218_6597_533A_57DF = _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_77E9_5F62(_____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E, _____6620_5C04)
    _____9500_6BC1_52A8_6001_77E9_5F62_533A_57DF_7EC4(context["战斗区域组"])
    context["战斗区域组"] = _____521B_5EFA_52A8_6001_77E9_5F62_533A_57DF_7EC4("巴尔扎罗斯测试战斗区域", {_____6D4B_8BD5_6218_6597_533A_57DF})
    context["测试固定安全区配置表"] = _____590D_5236_5E73_79FB_6D4B_8BD5_77E9_5F62_6570_7EC4(_____5DF4_5C14_624E_7F57_65AF_56FA_5B9A_5B89_5168_533A_914D_7F6E_8868, _____6620_5C04)
end
local function _____53D6_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_573A_5730_6620_5C04()
    local _____6B63_5F0F_4E2D_5FC3X = (_____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E["左"] + _____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E["右"]) / 2
    local _____6B63_5F0F_4E2D_5FC3Y = (_____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E["下"] + _____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E["上"]) / 2
    return _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04(_____6B63_5F0F_4E2D_5FC3X, _____6B63_5F0F_4E2D_5FC3Y, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y)
end
local function _____653E_7F6E_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_62A4_536B(context)
    local _____6620_5C04 = _____53D6_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_573A_5730_6620_5C04()
    if _____662F_6709_6548_5B58_6D3B_5355_4F4D(context["格鲁姆"]) then
        SetUnitPosition(context["格鲁姆"], _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E["格鲁姆"].X + _____6620_5C04["偏移X"], _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E["格鲁姆"].Y + _____6620_5C04["偏移Y"])
        SetUnitFacing(context["格鲁姆"], _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E["格鲁姆"]["面向"])
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(context["格鲁姆"])
    end
    if _____662F_6709_6548_5B58_6D3B_5355_4F4D(context["塞拉"]) then
        SetUnitPosition(context["塞拉"], _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E["塞拉"].X + _____6620_5C04["偏移X"], _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E["塞拉"].Y + _____6620_5C04["偏移Y"])
        SetUnitFacing(context["塞拉"], _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E["塞拉"]["面向"])
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(context["塞拉"])
    end
end
local function _____63D0_793A(player, text)
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        8,
        "[巴尔扎罗斯测试] " .. text
    )
end
local function _____662F_6709_6548_5B58_6D3B_82F1_96C4(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_HERO) == true and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____662F_5F53_524D_73A9_5BB6_6D4B_8BD5_9776(unit, player)
    return _____662F_6709_6548_5B58_6D3B_5355_4F4D(unit) and GetPlayerId(GetOwningPlayer(unit)) == GetPlayerId(player)
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
        _____5DF4_5C14_624E_7F57_65AF_5355_4F4DID,
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
local function _____51C6_5907_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_573A_666F(player, hero, boss)
    SetUnitPosition(hero, _____4E34_65F6_6D4B_8BD5_73A9_5BB6X, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y)
    SetUnitFacing(hero, 90)
    _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_51751, player, _____4E34_65F6_6D4B_8BD5_73A9_5BB6X - 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 220)
    _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_51752, player, _____4E34_65F6_6D4B_8BD5_73A9_5BB6X + 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 220)
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y, 0.2)
    local context = _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587(boss)
    if context ~= nil then
        _____5E94_7528_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_573A_5730(context)
    end
    return context
end
local function _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_4E0A_4E0B_6587(context)
    _____6CE8_518C_5DF4_5C14_624E_7F57_65AF_8FD0_884C_65F6()
    _____6CE8_518C_5DF4_5C14_624E_7F57_65AF_6280_80FD_7ED3_6784()
    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_7194_6838_5C01_5370_4E0E_62A4_536B_673A_5236(context)
    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_683C_9C81_59C6_6280_80FD(context)
    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_585E_62C9_6280_80FD(context)
    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_5730_6838_53EC_5524_8282_70B9(context)
    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_8282_70B9(context)
    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_672B_65E5_7194_7206_8282_70B9(context)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(context["Boss单位"])
    _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8(context["Boss单位"], "Boss战.单位")
    _____653E_7F6E_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_62A4_536B(context)
end
local function _____521B_5EFA_5E76_521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5(player)
    local hero = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    if hero == nil or hero == 0 then
        _____63D0_793A(player, "未找到地图预设玩家1大法师，无法创建测试 Boss。")
        return nil
    end
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(boss) then
        _____63D0_793A(player, "巴尔扎罗斯创建失败。")
        return nil
    end
    local context = _____51C6_5907_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_573A_666F(player, hero, boss)
    if context == nil then
        _____63D0_793A(player, "巴尔扎罗斯上下文创建失败。")
        return nil
    end
    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_4E0A_4E0B_6587(context)
    return context
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5E76_521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5(player)
    if context == nil then
        return
    end
    _____63D0_793A(player, "已创建/复用巴尔扎罗斯测试场景，并登记 Boss 自动技能。" .. _____6D4B_8BD5_547D_4EE4_8BF4_660E)
end
local function _____6267_884C_5DF4_5C14_624E_7F57_65AF_6280_80FD_6D4B_8BD5(player, _____5E8F_53F7)
    local context = _____521B_5EFA_5E76_521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5(player)
    if context == nil then
        return
    end
    local hero = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    if _____5E8F_53F7 == 1 then
        _____91CA_653E_5DF4_5C14_624E_7F57_65AF_6076_9B54_5486_54EE_6CE2(context)
        _____63D0_793A(player, "已测试：恶魔咆哮波。")
    elseif _____5E8F_53F7 == 2 then
        _____91CA_653E_5DF4_5C14_624E_7F57_65AF_738B_8005_5929_7F5A(context)
        _____63D0_793A(player, "已测试：王者天罚。")
    elseif _____5E8F_53F7 == 3 then
        _____91CA_653E_5DF4_5C14_624E_7F57_65AF_7194_5CA9_55B7_53D1(context)
        _____63D0_793A(player, "已测试：熔岩喷发。")
    elseif _____5E8F_53F7 == 4 then
        _____91CA_653E_5DF4_5C14_624E_7F57_65AF_706B_7130_9501_94FE(context)
        _____63D0_793A(player, "已测试：火焰锁链。")
    elseif _____5E8F_53F7 == 5 then
        _____91CA_653E_5DF4_5C14_624E_7F57_65AF_5730_6838_53EC_5524(context)
        _____63D0_793A(player, "已测试：地核召唤。")
    elseif _____5E8F_53F7 == 6 then
        _____91CA_653E_5DF4_5C14_624E_7F57_65AF_672B_65E5_7194_7206(context)
        _____63D0_793A(player, "已测试：末日熔爆。")
    elseif _____5E8F_53F7 == 7 then
        if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(context["格鲁姆"]) then
            _____63D0_793A(player, "格鲁姆不存在或已死亡，无法测试熔岩重锤。")
            return
        end
        _____91CA_653E_683C_9C81_59C6_91CD_9524(context, hero)
        _____63D0_793A(player, "已测试：格鲁姆熔岩重锤。")
    elseif _____5E8F_53F7 == 8 then
        if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(context["格鲁姆"]) then
            _____63D0_793A(player, "格鲁姆不存在或已死亡，无法测试熔岩火径。")
            return
        end
        _____91CA_653E_683C_9C81_59C6_706B_5F84(context, hero)
        _____63D0_793A(player, "已测试：格鲁姆熔岩火径。")
    elseif _____5E8F_53F7 == 9 then
        if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(context["塞拉"]) then
            _____63D0_793A(player, "塞拉不存在或已死亡，无法测试冰焰双星。")
            return
        end
        _____91CA_653E_51B0_7130_53CC_661F(context, hero)
        _____63D0_793A(player, "已测试：塞拉冰焰双星。")
    elseif _____5E8F_53F7 == 10 then
        if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(context["塞拉"]) then
            _____63D0_793A(player, "塞拉不存在或已死亡，无法测试绝对零度领域。")
            return
        end
        _____91CA_653E_7EDD_5BF9_96F6_5EA6_9886_57DF(context, hero)
        _____63D0_793A(player, "已测试：塞拉绝对零度领域。")
    elseif _____5E8F_53F7 == 11 then
        if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(context["塞拉"]) then
            _____63D0_793A(player, "塞拉不存在或已死亡，无法测试切换火焰形态。")
            return
        end
        _____5207_6362_585E_62C9_5F62_6001(context, "火焰", true)
        _____63D0_793A(player, "已测试：塞拉切换火焰形态。")
    elseif _____5E8F_53F7 == 12 then
        if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(context["塞拉"]) then
            _____63D0_793A(player, "塞拉不存在或已死亡，无法测试切换冰霜形态。")
            return
        end
        _____5207_6362_585E_62C9_5F62_6001(context, "冰霜", true)
        _____63D0_793A(player, "已测试：塞拉切换冰霜形态。")
    end
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD1_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_5DF4_5C14_624E_7F57_65AF_6280_80FD_6D4B_8BD5(player, 1)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD2_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_5DF4_5C14_624E_7F57_65AF_6280_80FD_6D4B_8BD5(player, 2)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD3_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_5DF4_5C14_624E_7F57_65AF_6280_80FD_6D4B_8BD5(player, 3)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD4_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_5DF4_5C14_624E_7F57_65AF_6280_80FD_6D4B_8BD5(player, 4)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD5_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_5DF4_5C14_624E_7F57_65AF_6280_80FD_6D4B_8BD5(player, 5)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD6_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_5DF4_5C14_624E_7F57_65AF_6280_80FD_6D4B_8BD5(player, 6)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD7_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_5DF4_5C14_624E_7F57_65AF_6280_80FD_6D4B_8BD5(player, 7)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD8_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_5DF4_5C14_624E_7F57_65AF_6280_80FD_6D4B_8BD5(player, 8)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD9_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_5DF4_5C14_624E_7F57_65AF_6280_80FD_6D4B_8BD5(player, 9)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD10_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_5DF4_5C14_624E_7F57_65AF_6280_80FD_6D4B_8BD5(player, 10)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD11_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_5DF4_5C14_624E_7F57_65AF_6280_80FD_6D4B_8BD5(player, 11)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD12_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_5DF4_5C14_624E_7F57_65AF_6280_80FD_6D4B_8BD5(player, 12)
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bztest1", ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD1_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bztest2", ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD2_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bztest3", ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD3_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bztest4", ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD4_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bztest5", ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD5_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bztest6", ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD6_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bztest7", ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD7_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bztest8", ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD8_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bztest9", ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD9_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bztest10", ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD10_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bztest11", ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD11_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bztest12", ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD12_6D4B_8BD5_547D_4EE4)
return ____exports
