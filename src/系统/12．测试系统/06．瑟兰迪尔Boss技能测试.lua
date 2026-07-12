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
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587 = ____require_result_4["获取或创建瑟兰迪尔上下文"]
local _____6CE8_518C_745F_5170_8FEA_5C14_8FD0_884C_65F6 = ____require_result_4["注册瑟兰迪尔运行时"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.07．秩序领域")
local _____5237_65B0_745F_5170_8FEA_5C14_79E9_5E8F_9886_57DF = ____require_result_5["刷新瑟兰迪尔秩序领域"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.05．月光枷锁")
local _____91CA_653E_745F_5170_8FEA_5C14_6708_5149_67B7_9501_6548_679C = ____require_result_6["释放瑟兰迪尔月光枷锁效果"]
local _____7ACB_5373_6253_65AD_745F_5170_8FEA_5C14_6708_5149_67B7_9501 = ____require_result_6["立即打断瑟兰迪尔月光枷锁"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.06．精灵箭阵")
local _____91CA_653E_745F_5170_8FEA_5C14_7CBE_7075_7BAD_9635 = ____require_result_7["释放瑟兰迪尔精灵箭阵"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.08．审判之环")
local _____91CA_653E_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF = ____require_result_8["释放瑟兰迪尔审判之环"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.09．罪与罚")
local _____91CA_653E_745F_5170_8FEA_5C14_7F6A_4E0E_7F5A = ____require_result_9["释放瑟兰迪尔罪与罚"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.10．律法召唤")
local _____91CA_653E_745F_5170_8FEA_5C14_5F8B_6CD5_53EC_5524 = ____require_result_10["释放瑟兰迪尔律法召唤"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.11．月光灌注")
local _____91CA_653E_745F_5170_8FEA_5C14_6708_5149_704C_6CE8 = ____require_result_11["释放瑟兰迪尔月光灌注"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.12．终末审判")
local _____91CA_653E_745F_5170_8FEA_5C14_7EC8_672B_5BA1_5224 = ____require_result_12["释放瑟兰迪尔终末审判"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____require_result_13["瑟兰迪尔数值与表现配置"]
local ____require_result_14 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_14["创建单位坐标跟随特效"]
local _____521B_5EFA_5FAA_73AF_70B9_7279_6548 = ____require_result_14["创建循环点特效"]
local ____require_result_15 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_15["标记测试Boss跳过死亡结算"]
local _____6D4B_8BD5_547D_4EE4 = "thtest"
local _____745F_5170_8FEA_5C14_5355_4F4DID = stringToFourCC("N057")
local _____6D4B_8BD5_6B65_5175_5355_4F4DID = stringToFourCC("hfoo")
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = 12
local _____6D4B_8BD5_5355_4F4D_6700_5927_751F_547D_503C = 999999
local _____6D4B_8BD5Boss_521D_59CB_8DDD_79BB = 760
local _____6D4B_8BD5_547D_4EE4_8BF4_660E = "thtest1月光枷锁 2精灵箭阵 3审判之环 4罪与罚 5律法召唤 6月光灌注 7终末审判 8月光枷锁立即打断。"
local CreateUnit = jass.CreateUnit
local Player = jass.Player
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local SetHeroLevel = jass.SetHeroLevel
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
local function _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player, hero)
    local pid = GetPlayerId(player)
    local cached = _____6700_8FD1_6D4B_8BD5Boss[pid]
    local x = GetUnitX(hero) + _____6D4B_8BD5Boss_521D_59CB_8DDD_79BB
    local y = GetUnitY(hero)
    if _____662F_6709_6548_5B58_6D3B_5355_4F4D(cached) then
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(cached)
        return cached
    end
    local boss = CreateUnit(
        Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
        _____745F_5170_8FEA_5C14_5355_4F4DID,
        x,
        y,
        180
    )
    if boss ~= nil and boss ~= 0 then
        _____6700_8FD1_6D4B_8BD5Boss[pid] = boss
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
        SetHeroLevel(boss, 10, false)
        SelectUnitForPlayerSingle(boss, player)
        StarOther_PanCameraToTimedForPlayer(player, x, y, 0.2)
    end
    return boss
end
local function _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5_6B65_5175(_____7F13_5B58_8868, player, hero, xOffset, yOffset)
    local pid = GetPlayerId(player)
    local cached = _____7F13_5B58_8868[pid]
    if _____662F_5F53_524D_73A9_5BB6_6D4B_8BD5_9776(cached, player) then
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(cached)
        return cached
    end
    local unit = CreateUnit(
        player,
        _____6D4B_8BD5_6B65_5175_5355_4F4DID,
        GetUnitX(hero) + xOffset,
        GetUnitY(hero) + yOffset,
        180
    )
    if unit ~= nil and unit ~= 0 then
        _____7F13_5B58_8868[pid] = unit
        _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(unit)
    end
    return unit
end
local function _____51C6_5907_6280_80FD_6D4B_8BD5_573A_666F(player, hero)
    _____8BBE_7F6E_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5_6B65_5175(
        _____6700_8FD1_6D4B_8BD5_6B65_51751,
        player,
        hero,
        180,
        160
    )
    _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5_6B65_5175(
        _____6700_8FD1_6D4B_8BD5_6B65_51752,
        player,
        hero,
        180,
        -160
    )
end
local function ____on_745F_5170_8FEA_5C14_6D4B_8BD5_547D_4EE4(player)
    local hero = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    if hero == nil or hero == 0 then
        _____63D0_793A(player, "未找到地图预设玩家1大法师，无法创建测试 Boss。")
        return
    end
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player, hero)
    if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(boss) then
        _____63D0_793A(player, "瑟兰迪尔创建失败。")
        return
    end
    _____51C6_5907_6280_80FD_6D4B_8BD5_573A_666F(player, hero)
    _____6CE8_518C_745F_5170_8FEA_5C14_8FD0_884C_65F6()
    local context = _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587(boss)
    if context ~= nil then
        _____5237_65B0_745F_5170_8FEA_5C14_79E9_5E8F_9886_57DF(context)
    end
    _____63D0_793A(player, "已创建/复用瑟兰迪尔，并把大法师与2个步兵设为999999满血。" .. _____6D4B_8BD5_547D_4EE4_8BF4_660E)
end
local function ____on_79E9_5E8F_9886_57DF_7ED1_5B9A_7F29_653E_6D4B_8BD5_547D_4EE4(player)
    local hero = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    if hero == nil or hero == 0 then
        _____63D0_793A(player, "未找到地图预设玩家1大法师，无法测试绑定特效缩放。")
        return
    end
    local modelPath = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["秩序领域"]["特效"]
    local effect = _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
        hero,
        modelPath,
        "thranduil-order-aura-scale-test",
        1,
        50
    )
    _____63D0_793A(
        player,
        (("已在大法师脚下创建秩序领域跟随特效，高度50；创建" .. ((effect == nil or effect == 0) and "失败" or "成功")) .. "，路径=") .. tostring(modelPath)
    )
end
local function ____on_5BA1_5224_4E4B_73AF_6CD5_9635_7279_6548_6D4B_8BD5_547D_4EE4(player)
    local hero = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    if hero == nil or hero == 0 then
        _____63D0_793A(player, "未找到地图预设玩家1大法师，无法测试审判之环法阵。")
        return
    end
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["审判之环"]
    local modelPath = config["特效"]
    local x = GetUnitX(hero)
    local y = GetUnitY(hero)
    local handle = _____521B_5EFA_5FAA_73AF_70B9_7279_6548({
        ["模型路径"] = modelPath,
        X = x,
        Y = y,
        ["缩放"] = config["法阵缩放"],
        ["顶点颜色"] = 4294955104,
        ["重建间隔秒"] = config["法阵重建间隔秒"],
        ["单次持续秒"] = config["法阵单次持续秒"],
        ["总持续秒"] = config["周期秒"]
    })
    _____63D0_793A(
        player,
        (((((("已在大法师位置循环创建审判之环法阵" .. tostring(config["周期秒"])) .. "秒；句柄=") .. tostring(handle.id)) .. "，缩放=") .. tostring(config["法阵缩放"])) .. "，路径=") .. tostring(modelPath)
    )
end
local function _____6267_884C_745F_5170_8FEA_5C14_6280_80FD_6D4B_8BD5(player, _____5E8F_53F7)
    local hero = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_57FA_51C6_82F1_96C4(player)
    if hero == nil or hero == 0 then
        _____63D0_793A(player, "未找到地图预设玩家1大法师，无法测试技能。")
        return
    end
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player, hero)
    if not _____662F_6709_6548_5B58_6D3B_5355_4F4D(boss) then
        _____63D0_793A(player, "瑟兰迪尔创建失败。")
        return
    end
    _____51C6_5907_6280_80FD_6D4B_8BD5_573A_666F(player, hero)
    _____6CE8_518C_745F_5170_8FEA_5C14_8FD0_884C_65F6()
    local context = _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587(boss)
    if context == nil then
        _____63D0_793A(player, "瑟兰迪尔上下文创建失败。")
        return
    end
    if _____5E8F_53F7 == 1 then
        _____91CA_653E_745F_5170_8FEA_5C14_6708_5149_67B7_9501_6548_679C(boss, hero)
        _____63D0_793A(player, "已测试：月光枷锁。")
    elseif _____5E8F_53F7 == 2 then
        _____91CA_653E_745F_5170_8FEA_5C14_7CBE_7075_7BAD_9635(context)
        _____63D0_793A(player, "已测试：精灵箭阵。")
    elseif _____5E8F_53F7 == 3 then
        _____91CA_653E_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF(context)
        _____63D0_793A(player, "已测试：审判之环。")
    elseif _____5E8F_53F7 == 4 then
        _____91CA_653E_745F_5170_8FEA_5C14_7F6A_4E0E_7F5A(context, hero)
        _____63D0_793A(player, "已测试：罪与罚。")
    elseif _____5E8F_53F7 == 5 then
        _____91CA_653E_745F_5170_8FEA_5C14_5F8B_6CD5_53EC_5524(context)
        _____63D0_793A(player, "已测试：律法召唤。")
    elseif _____5E8F_53F7 == 6 then
        _____91CA_653E_745F_5170_8FEA_5C14_6708_5149_704C_6CE8(context)
        _____63D0_793A(player, "已测试：月光灌注。")
    elseif _____5E8F_53F7 == 7 then
        _____91CA_653E_745F_5170_8FEA_5C14_7EC8_672B_5BA1_5224(context)
        _____63D0_793A(player, "已测试：终末审判。")
    elseif _____5E8F_53F7 == 8 then
        local success = _____7ACB_5373_6253_65AD_745F_5170_8FEA_5C14_6708_5149_67B7_9501(boss, hero)
        _____63D0_793A(player, success and "已测试：月光枷锁命中后立即打断，碎片应掉落在大法师脚下。" or "月光枷锁立即打断测试失败。")
    end
end
local function ____on_745F_5170_8FEA_5C14_6280_80FD1_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_745F_5170_8FEA_5C14_6280_80FD_6D4B_8BD5(player, 1)
end
local function ____on_745F_5170_8FEA_5C14_6280_80FD2_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_745F_5170_8FEA_5C14_6280_80FD_6D4B_8BD5(player, 2)
end
local function ____on_745F_5170_8FEA_5C14_6280_80FD3_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_745F_5170_8FEA_5C14_6280_80FD_6D4B_8BD5(player, 3)
end
local function ____on_745F_5170_8FEA_5C14_6280_80FD4_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_745F_5170_8FEA_5C14_6280_80FD_6D4B_8BD5(player, 4)
end
local function ____on_745F_5170_8FEA_5C14_6280_80FD5_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_745F_5170_8FEA_5C14_6280_80FD_6D4B_8BD5(player, 5)
end
local function ____on_745F_5170_8FEA_5C14_6280_80FD6_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_745F_5170_8FEA_5C14_6280_80FD_6D4B_8BD5(player, 6)
end
local function ____on_745F_5170_8FEA_5C14_6280_80FD7_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_745F_5170_8FEA_5C14_6280_80FD_6D4B_8BD5(player, 7)
end
local function ____on_745F_5170_8FEA_5C14_6280_80FD8_6D4B_8BD5_547D_4EE4(player)
    _____6267_884C_745F_5170_8FEA_5C14_6280_80FD_6D4B_8BD5(player, 8)
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_745F_5170_8FEA_5C14_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("9998", ____on_5BA1_5224_4E4B_73AF_6CD5_9635_7279_6548_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("9999", ____on_79E9_5E8F_9886_57DF_7ED1_5B9A_7F29_653E_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("thtest1", ____on_745F_5170_8FEA_5C14_6280_80FD1_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("thtest2", ____on_745F_5170_8FEA_5C14_6280_80FD2_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("thtest3", ____on_745F_5170_8FEA_5C14_6280_80FD3_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("thtest4", ____on_745F_5170_8FEA_5C14_6280_80FD4_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("thtest5", ____on_745F_5170_8FEA_5C14_6280_80FD5_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("thtest6", ____on_745F_5170_8FEA_5C14_6280_80FD6_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("thtest7", ____on_745F_5170_8FEA_5C14_6280_80FD7_6D4B_8BD5_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("thtest8", ____on_745F_5170_8FEA_5C14_6280_80FD8_6D4B_8BD5_547D_4EE4)
return ____exports
