--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
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
local ____require_result_6 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_6.getServerTime
local ____require_result_7 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_7["标记测试Boss跳过死亡结算"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587 = ____require_result_8["获取或创建菲利斯上下文"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.10．被动效果")
local _____6CE8_518C_83F2_5229_65AF_88AB_52A8_6548_679C = ____require_result_9["注册菲利斯被动效果"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.04．剑魂杀")
local _____91CA_653E_83F2_5229_65AF_5251_9B42_6740 = ____require_result_10["释放菲利斯剑魂杀"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.05．剑气灵斩")
local _____91CA_653E_83F2_5229_65AF_5251_6C14_7075_65A9 = ____require_result_11["释放菲利斯剑气灵斩"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.06．全力封印斩")
local _____91CA_653E_83F2_5229_65AF_5168_529B_5C01_5370_65A9 = ____require_result_12["释放菲利斯全力封印斩"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.07．异形化")
local _____91CA_653E_83F2_5229_65AF_5F02_5F62_5316 = ____require_result_13["释放菲利斯异形化"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587 = ____require_result_14["获取或创建里科特上下文"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.12．被动效果")
local _____6CE8_518C_91CC_79D1_7279_88AB_52A8_6548_679C = ____require_result_15["注册里科特被动效果"]
local ____require_result_16 = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.04．四重风刃")
local _____91CA_653E_91CC_79D1_7279_56DB_91CD_98CE_5203 = ____require_result_16["释放里科特四重风刃"]
local ____require_result_17 = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.05．追击风刃")
local _____91CA_653E_91CC_79D1_7279_8FFD_51FB_98CE_5203 = ____require_result_17["释放里科特追击风刃"]
local ____require_result_18 = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.07．湮灭之炮")
local _____91CA_653E_91CC_79D1_7279_6E6E_706D_4E4B_70AE = ____require_result_18["释放里科特湮灭之炮"]
local ____require_result_19 = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.08．湮灭之风")
local _____91CA_653E_91CC_79D1_7279_6E6E_706D_4E4B_98CE = ____require_result_19["释放里科特湮灭之风"]
local ____require_result_20 = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.09．破魔反击")
local _____91CA_653E_91CC_79D1_7279_7834_9B54_53CD_51FB = ____require_result_20["释放里科特破魔反击"]
local ____require_result_21 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587 = ____require_result_21["获取或创建卡瑟拉上下文"]
local ____require_result_22 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.13．被动效果")
local _____6CE8_518C_5361_745F_62C9_88AB_52A8_6548_679C = ____require_result_22["注册卡瑟拉被动效果"]
local ____require_result_23 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.06．深渊召唤")
local _____91CA_653E_5361_745F_62C9_6DF1_6E0A_53EC_5524 = ____require_result_23["释放卡瑟拉深渊召唤"]
local ____require_result_24 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.03．深海涡流")
local _____91CA_653E_5361_745F_62C9_6DF1_6D77_6DA1_6D41 = ____require_result_24["释放卡瑟拉深海涡流"]
local ____require_result_25 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.04．触手鞭笞")
local _____91CA_653E_5361_745F_62C9_89E6_624B_97AD_7B1E = ____require_result_25["释放卡瑟拉触手鞭笞"]
local ____require_result_26 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.05．墨汁喷吐")
local _____91CA_653E_5361_745F_62C9_58A8_6C41_55B7_5410 = ____require_result_26["释放卡瑟拉墨汁喷吐"]
local ____require_result_27 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.07．高压水炮")
local _____91CA_653E_5361_745F_62C9_9AD8_538B_6C34_70AE = ____require_result_27["释放卡瑟拉高压水炮"]
local ____require_result_28 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.08．触手解放")
local _____5C1D_8BD5_89E6_53D1_5361_745F_62C9_89E6_624B_89E3_653E = ____require_result_28["尝试触发卡瑟拉触手解放"]
local ____require_result_29 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.09．共生电击")
local _____5C1D_8BD5_91CA_653E_5361_745F_62C9_5171_751F_7535_51FB = ____require_result_29["尝试释放卡瑟拉共生电击"]
local ____require_result_30 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587 = ____require_result_30["获取或创建莫尔特斯上下文"]
local ____require_result_31 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.15．被动效果")
local _____6CE8_518C_83AB_5C14_7279_65AF_88AB_52A8_6548_679C = ____require_result_31["注册莫尔特斯被动效果"]
local ____require_result_32 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.04．腐朽根须穿刺")
local _____91CA_653E_83AB_5C14_7279_65AF_8150_673D_6839_987B_7A7F_523A = ____require_result_32["释放莫尔特斯腐朽根须穿刺"]
local ____require_result_33 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.05．腐败孢子云")
local _____91CA_653E_83AB_5C14_7279_65AF_8150_8D25_5B62_5B50_4E91 = ____require_result_33["释放莫尔特斯腐败孢子云"]
local ____require_result_34 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.06．扭曲荆棘鞭笞")
local _____91CA_653E_83AB_5C14_7279_65AF_626D_66F2_8346_68D8_97AD_7B1E = ____require_result_34["释放莫尔特斯扭曲荆棘鞭笞"]
local ____require_result_35 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.07．腐败之种")
local _____91CA_653E_83AB_5C14_7279_65AF_8150_8D25_4E4B_79CD = ____require_result_35["释放莫尔特斯腐败之种"]
local ____require_result_36 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.08．根系觉醒")
local _____5C1D_8BD5_89E6_53D1_83AB_5C14_7279_65AF_6839_7CFB_89C9_9192 = ____require_result_36["尝试触发莫尔特斯根系觉醒"]
local ____require_result_37 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.09．腐朽领域")
local _____5C1D_8BD5_89E6_53D1_83AB_5C14_7279_65AF_8150_673D_9886_57DF = ____require_result_37["尝试触发莫尔特斯腐朽领域"]
local ____require_result_38 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.10．共生腐朽虫群")
local _____5C1D_8BD5_91CA_653E_83AB_5C14_7279_65AF_5171_751F_8150_673D_866B_7FA4 = ____require_result_38["尝试释放莫尔特斯共生腐朽虫群"]
local ____require_result_39 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.11．古木悲鸣")
local _____91CA_653E_83AB_5C14_7279_65AF_53E4_6728_60B2_9E23 = ____require_result_39["释放莫尔特斯古木悲鸣"]
local ____require_result_40 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____require_result_40["获取或创建影骨莫特斯上下文"]
local ____require_result_41 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.10．被动效果")
local _____6CE8_518C_5F71_9AA8_83AB_7279_65AF_88AB_52A8_6548_679C = ____require_result_41["注册影骨莫特斯被动效果"]
local ____require_result_42 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.05．暗影禁锢")
local _____91CA_653E_5F71_9AA8_6697_5F71_7981_9522 = ____require_result_42["释放影骨暗影禁锢"]
local ____require_result_43 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.03．阴影穿梭")
local _____91CA_653E_5F71_9AA8_9634_5F71_7A7F_68AD = ____require_result_43["释放影骨阴影穿梭"]
local ____require_result_44 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.04．骸骨召唤")
local _____91CA_653E_5F71_9AA8_9AB8_9AA8_53EC_5524 = ____require_result_44["释放影骨骸骨召唤"]
local ____require_result_45 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.06．幽影爆发")
local _____91CA_653E_5F71_9AA8_5E7D_5F71_7206_53D1 = ____require_result_45["释放影骨幽影爆发"]
local ____require_result_46 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.07．盗贼的遗产")
local _____91CA_653E_5F71_9AA8_76D7_8D3C_9057_4EA7 = ____require_result_46["释放影骨盗贼遗产"]
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = 12
local _____6D4B_8BD5_5355_4F4D_6700_5927_751F_547D_503C = 999999
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X = -540.6
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y = -2495.2
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y = -3055.2
local CreateUnit = jass.CreateUnit
local Player = jass.Player
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
local _____83F2_5229_65AF_6D4B_8BD5Boss = {}
local _____91CC_79D1_7279_6D4B_8BD5Boss = {}
local _____5361_745F_62C9_6D4B_8BD5Boss = {}
local _____83AB_5C14_7279_65AF_6D4B_8BD5Boss = {}
local _____5F71_9AA8_6D4B_8BD5Boss = {}
local function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
local function _____63D0_793A(player, bossName, text)
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        8,
        (("[" .. bossName) .. "测试] ") .. text
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
local function _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player, cache, unitId, level)
    local pid = GetPlayerId(player)
    local cached = cache[pid]
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
        stringToFourCC(unitId),
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y,
        270
    )
    if boss ~= nil and boss ~= 0 then
        cache[pid] = boss
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
        SetHeroLevel(boss, level, false)
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
        globals.udg_Boss = boss
    end
    return boss
end
local function _____51C6_5907_901A_7528Boss_6D4B_8BD5_573A_666F(player, boss)
    local hero = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    if hero ~= nil and hero ~= 0 then
        SetUnitPosition(hero, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y)
        SetUnitFacing(hero, 90)
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    end
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y, 0.2)
end
local function _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
    _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8(boss, "Boss战.单位")
end
local function _____521B_5EFA_83F2_5229_65AF_6D4B_8BD5(player)
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player, _____83F2_5229_65AF_6D4B_8BD5Boss, "N05T", 38)
    if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(boss) then
        _____63D0_793A(player, "菲利斯", "Boss 创建失败。")
        return nil
    end
    _____6CE8_518C_83F2_5229_65AF_88AB_52A8_6548_679C()
    _____51C6_5907_901A_7528Boss_6D4B_8BD5_573A_666F(player, boss)
    _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    return _____83B7_53D6_6216_521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587(boss)
end
local function _____521B_5EFA_91CC_79D1_7279_6D4B_8BD5(player)
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player, _____91CC_79D1_7279_6D4B_8BD5Boss, "N05U", 40)
    if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(boss) then
        _____63D0_793A(player, "里科特", "Boss 创建失败。")
        return nil
    end
    _____6CE8_518C_91CC_79D1_7279_88AB_52A8_6548_679C()
    _____51C6_5907_901A_7528Boss_6D4B_8BD5_573A_666F(player, boss)
    _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    return _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587(boss)
end
local function _____521B_5EFA_5361_745F_62C9_6D4B_8BD5(player)
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player, _____5361_745F_62C9_6D4B_8BD5Boss, "N05V", 42)
    if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(boss) then
        _____63D0_793A(player, "卡瑟拉", "Boss 创建失败。")
        return nil
    end
    _____6CE8_518C_5361_745F_62C9_88AB_52A8_6548_679C()
    _____51C6_5907_901A_7528Boss_6D4B_8BD5_573A_666F(player, boss)
    _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    return _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587(boss)
end
local function _____521B_5EFA_83AB_5C14_7279_65AF_6D4B_8BD5(player)
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player, _____83AB_5C14_7279_65AF_6D4B_8BD5Boss, "N05W", 42)
    if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(boss) then
        _____63D0_793A(player, "莫尔特斯", "Boss 创建失败。")
        return nil
    end
    _____6CE8_518C_83AB_5C14_7279_65AF_88AB_52A8_6548_679C()
    _____51C6_5907_901A_7528Boss_6D4B_8BD5_573A_666F(player, boss)
    _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    return _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587(boss)
end
local function _____521B_5EFA_5F71_9AA8_6D4B_8BD5(player)
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player, _____5F71_9AA8_6D4B_8BD5Boss, "N01Y", 42)
    if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(boss) then
        _____63D0_793A(player, "影骨莫特斯", "Boss 创建失败。")
        return nil
    end
    _____6CE8_518C_5F71_9AA8_83AB_7279_65AF_88AB_52A8_6548_679C()
    _____51C6_5907_901A_7528Boss_6D4B_8BD5_573A_666F(player, boss)
    _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    return _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587(boss)
end
local function ____on_83F2_5229_65AF_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_83F2_5229_65AF_6D4B_8BD5(player)
    if context == nil then
        return
    end
    _____63D0_793A(player, "菲利斯", "已创建/复用测试场景，并启动 Boss 自动技能。flstest1剑魂杀 2剑气灵斩 3全力封印斩 4异形化。")
end
local function ____on_83F2_5229_65AF_6280_80FD1_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_83F2_5229_65AF_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_83F2_5229_65AF_5251_9B42_6740(context)
        _____63D0_793A(player, "菲利斯", "已测试：剑魂杀。")
    end
end
local function ____on_83F2_5229_65AF_6280_80FD2_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_83F2_5229_65AF_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_83F2_5229_65AF_5251_6C14_7075_65A9(context)
        _____63D0_793A(player, "菲利斯", "已测试：剑气灵斩。")
    end
end
local function ____on_83F2_5229_65AF_6280_80FD3_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_83F2_5229_65AF_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_83F2_5229_65AF_5168_529B_5C01_5370_65A9(context)
        _____63D0_793A(player, "菲利斯", "已测试：全力封印斩。")
    end
end
local function ____on_83F2_5229_65AF_6280_80FD4_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_83F2_5229_65AF_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_83F2_5229_65AF_5F02_5F62_5316(context)
        _____63D0_793A(player, "菲利斯", "已测试：异形化。")
    end
end
local function ____on_91CC_79D1_7279_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_91CC_79D1_7279_6D4B_8BD5(player)
    if context == nil then
        return
    end
    _____63D0_793A(player, "里科特", "已创建/复用测试场景，并启动 Boss 自动技能。rktest1四重风刃 2追击风刃 3湮灭之炮 4湮灭之风 5破魔反击。")
end
local function ____on_91CC_79D1_7279_6280_80FD1_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_91CC_79D1_7279_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_91CC_79D1_7279_56DB_91CD_98CE_5203(context)
        _____63D0_793A(player, "里科特", "已测试：四重风刃。")
    end
end
local function ____on_91CC_79D1_7279_6280_80FD2_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_91CC_79D1_7279_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_91CC_79D1_7279_8FFD_51FB_98CE_5203(context)
        _____63D0_793A(player, "里科特", "已测试：追击风刃。")
    end
end
local function ____on_91CC_79D1_7279_6280_80FD3_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_91CC_79D1_7279_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_91CC_79D1_7279_6E6E_706D_4E4B_70AE(context)
        _____63D0_793A(player, "里科特", "已测试：湮灭之炮。")
    end
end
local function ____on_91CC_79D1_7279_6280_80FD4_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_91CC_79D1_7279_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_91CC_79D1_7279_6E6E_706D_4E4B_98CE(context)
        _____63D0_793A(player, "里科特", "已测试：湮灭之风。")
    end
end
local function ____on_91CC_79D1_7279_6280_80FD5_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_91CC_79D1_7279_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_91CC_79D1_7279_7834_9B54_53CD_51FB(context)
        _____63D0_793A(player, "里科特", "已测试：破魔反击。")
    end
end
local function ____on_5361_745F_62C9_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5361_745F_62C9_6D4B_8BD5(player)
    if context == nil then
        return
    end
    _____63D0_793A(player, "卡瑟拉", "已创建/复用测试场景，并启动 Boss 自动技能。ksltest1深海涡流 2触手鞭笞 3墨汁喷吐 4深渊召唤 5高压水炮 6触手解放 7共生电击。")
end
local function ____on_5361_745F_62C9_6280_80FD1_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5361_745F_62C9_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_5361_745F_62C9_6DF1_6D77_6DA1_6D41(context)
        _____63D0_793A(player, "卡瑟拉", "已测试：深海涡流。")
    end
end
local function ____on_5361_745F_62C9_6280_80FD2_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5361_745F_62C9_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_5361_745F_62C9_89E6_624B_97AD_7B1E(context)
        _____63D0_793A(player, "卡瑟拉", "已测试：触手鞭笞。")
    end
end
local function ____on_5361_745F_62C9_6280_80FD3_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5361_745F_62C9_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_5361_745F_62C9_58A8_6C41_55B7_5410(context)
        _____63D0_793A(player, "卡瑟拉", "已测试：墨汁喷吐。")
    end
end
local function ____on_5361_745F_62C9_6280_80FD4_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5361_745F_62C9_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_5361_745F_62C9_6DF1_6E0A_53EC_5524(context)
        _____63D0_793A(player, "卡瑟拉", "已测试：深渊召唤。")
    end
end
local function ____on_5361_745F_62C9_6280_80FD5_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5361_745F_62C9_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_5361_745F_62C9_9AD8_538B_6C34_70AE(context)
        _____63D0_793A(player, "卡瑟拉", "已测试：高压水炮。")
    end
end
local function ____on_5361_745F_62C9_6280_80FD6_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5361_745F_62C9_6D4B_8BD5(player)
    if context ~= nil then
        _____5C1D_8BD5_89E6_53D1_5361_745F_62C9_89E6_624B_89E3_653E(context)
        _____63D0_793A(player, "卡瑟拉", "已测试：触手解放。")
    end
end
local function ____on_5361_745F_62C9_6280_80FD7_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5361_745F_62C9_6D4B_8BD5(player)
    if context ~= nil then
        _____5C1D_8BD5_91CA_653E_5361_745F_62C9_5171_751F_7535_51FB(
            context,
            getServerTime()
        )
        _____63D0_793A(player, "卡瑟拉", "已测试：共生电击。")
    end
end
local function ____on_83AB_5C14_7279_65AF_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_83AB_5C14_7279_65AF_6D4B_8BD5(player)
    if context == nil then
        return
    end
    _____63D0_793A(player, "莫尔特斯", "已创建/复用测试场景，并启动 Boss 自动技能。mltstest1根须穿刺 2孢子云 3荆棘鞭笞 4腐败之种 5根系觉醒 6腐朽领域 7腐朽虫群 8古木悲鸣。")
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD1_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_83AB_5C14_7279_65AF_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_83AB_5C14_7279_65AF_8150_673D_6839_987B_7A7F_523A(context)
        _____63D0_793A(player, "莫尔特斯", "已测试：腐朽根须穿刺。")
    end
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD2_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_83AB_5C14_7279_65AF_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_83AB_5C14_7279_65AF_8150_8D25_5B62_5B50_4E91(context)
        _____63D0_793A(player, "莫尔特斯", "已测试：腐败孢子云。")
    end
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD3_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_83AB_5C14_7279_65AF_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_83AB_5C14_7279_65AF_626D_66F2_8346_68D8_97AD_7B1E(context)
        _____63D0_793A(player, "莫尔特斯", "已测试：扭曲荆棘鞭笞。")
    end
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD4_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_83AB_5C14_7279_65AF_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_83AB_5C14_7279_65AF_8150_8D25_4E4B_79CD(context)
        _____63D0_793A(player, "莫尔特斯", "已测试：腐败之种。")
    end
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD5_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_83AB_5C14_7279_65AF_6D4B_8BD5(player)
    if context ~= nil then
        _____5C1D_8BD5_89E6_53D1_83AB_5C14_7279_65AF_6839_7CFB_89C9_9192(context)
        _____63D0_793A(player, "莫尔特斯", "已测试：根系觉醒。")
    end
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD6_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_83AB_5C14_7279_65AF_6D4B_8BD5(player)
    if context ~= nil then
        _____5C1D_8BD5_89E6_53D1_83AB_5C14_7279_65AF_8150_673D_9886_57DF(context)
        _____63D0_793A(player, "莫尔特斯", "已测试：腐朽领域。")
    end
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD7_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_83AB_5C14_7279_65AF_6D4B_8BD5(player)
    if context ~= nil then
        _____5C1D_8BD5_91CA_653E_83AB_5C14_7279_65AF_5171_751F_8150_673D_866B_7FA4(
            context,
            getServerTime()
        )
        _____63D0_793A(player, "莫尔特斯", "已测试：共生腐朽虫群。")
    end
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD8_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_83AB_5C14_7279_65AF_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_83AB_5C14_7279_65AF_53E4_6728_60B2_9E23(context)
        _____63D0_793A(player, "莫尔特斯", "已测试：古木悲鸣。")
    end
end
local function ____on_5F71_9AA8_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5F71_9AA8_6D4B_8BD5(player)
    if context == nil then
        return
    end
    _____63D0_793A(player, "影骨莫特斯", "已创建/复用测试场景，并启动 Boss 自动技能。ygtest1阴影穿梭 2骸骨召唤 3暗影禁锢 4幽影爆发 5盗贼的遗产。")
end
local function ____on_5F71_9AA8_6280_80FD1_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5F71_9AA8_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_5F71_9AA8_9634_5F71_7A7F_68AD(context)
        _____63D0_793A(player, "影骨莫特斯", "已测试：阴影穿梭。")
    end
end
local function ____on_5F71_9AA8_6280_80FD2_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5F71_9AA8_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_5F71_9AA8_9AB8_9AA8_53EC_5524(context)
        _____63D0_793A(player, "影骨莫特斯", "已测试：骸骨召唤。")
    end
end
local function ____on_5F71_9AA8_6280_80FD3_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5F71_9AA8_6D4B_8BD5(player)
    local hero = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    if context ~= nil and _____662F_6709_6548_5B58_6D3B_82F1_96C4(hero) then
        _____91CA_653E_5F71_9AA8_6697_5F71_7981_9522(context, hero)
        _____63D0_793A(player, "影骨莫特斯", "已测试：暗影禁锢。")
    end
end
local function ____on_5F71_9AA8_6280_80FD4_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5F71_9AA8_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_5F71_9AA8_5E7D_5F71_7206_53D1(context)
        _____63D0_793A(player, "影骨莫特斯", "已测试：幽影爆发。")
    end
end
local function ____on_5F71_9AA8_6280_80FD5_6D4B_8BD5_547D_4EE4(player)
    local context = _____521B_5EFA_5F71_9AA8_6D4B_8BD5(player)
    if context ~= nil then
        _____91CA_653E_5F71_9AA8_76D7_8D3C_9057_4EA7(context)
        _____63D0_793A(player, "影骨莫特斯", "已测试：盗贼的遗产。")
    end
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("flstest", ____on_83F2_5229_65AF_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("flstest1", ____on_83F2_5229_65AF_6280_80FD1_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("flstest2", ____on_83F2_5229_65AF_6280_80FD2_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("flstest3", ____on_83F2_5229_65AF_6280_80FD3_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("flstest4", ____on_83F2_5229_65AF_6280_80FD4_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("rktest", ____on_91CC_79D1_7279_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("rktest1", ____on_91CC_79D1_7279_6280_80FD1_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("rktest2", ____on_91CC_79D1_7279_6280_80FD2_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("rktest3", ____on_91CC_79D1_7279_6280_80FD3_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("rktest4", ____on_91CC_79D1_7279_6280_80FD4_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("rktest5", ____on_91CC_79D1_7279_6280_80FD5_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("ksltest", ____on_5361_745F_62C9_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("ksltest1", ____on_5361_745F_62C9_6280_80FD1_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("ksltest2", ____on_5361_745F_62C9_6280_80FD2_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("ksltest3", ____on_5361_745F_62C9_6280_80FD3_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("ksltest4", ____on_5361_745F_62C9_6280_80FD4_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("ksltest5", ____on_5361_745F_62C9_6280_80FD5_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("ksltest6", ____on_5361_745F_62C9_6280_80FD6_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("ksltest7", ____on_5361_745F_62C9_6280_80FD7_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("mltstest", ____on_83AB_5C14_7279_65AF_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("mltstest1", ____on_83AB_5C14_7279_65AF_6280_80FD1_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("mltstest2", ____on_83AB_5C14_7279_65AF_6280_80FD2_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("mltstest3", ____on_83AB_5C14_7279_65AF_6280_80FD3_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("mltstest4", ____on_83AB_5C14_7279_65AF_6280_80FD4_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("mltstest5", ____on_83AB_5C14_7279_65AF_6280_80FD5_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("mltstest6", ____on_83AB_5C14_7279_65AF_6280_80FD6_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("mltstest7", ____on_83AB_5C14_7279_65AF_6280_80FD7_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("mltstest8", ____on_83AB_5C14_7279_65AF_6280_80FD8_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("ygtest", ____on_5F71_9AA8_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("ygtest1", ____on_5F71_9AA8_6280_80FD1_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("ygtest2", ____on_5F71_9AA8_6280_80FD2_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("ygtest3", ____on_5F71_9AA8_6280_80FD3_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("ygtest4", ____on_5F71_9AA8_6280_80FD4_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("ygtest5", ____on_5F71_9AA8_6280_80FD5_6D4B_8BD5_547D_4EE4)
return ____exports
