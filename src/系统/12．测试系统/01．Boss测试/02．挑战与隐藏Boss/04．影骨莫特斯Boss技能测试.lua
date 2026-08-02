--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____51C6_5907_5F71_9AA8_6D4B_8BD5_9636_6BB5, ____on_5F71_9AA8_6280_80FD2Kill_5EF6_8FDF_51FB_6740, _____6E05_7406_5F71_9AA8_4E0A_4E00_6B21_53EC_5524_6D4B_8BD5, _____5B89_6392_5F71_9AA8_9636_6BB5_5F3A_5316_6D4B_8BD5, GetUnitStateJapi, ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B, _____8BBE_7F6E_5F71_9AA8_83AB_7279_65AF_6D4B_8BD5_9636_6BB5, _____91CA_653E_5F71_9AA8_9AB8_9AA8_53EC_5524, addDelayedCallback, SetUnitState, GetPlayerId, KillUnit, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE, _____5F71_9AA82Kill_6D4B_8BD5_8868
function _____51C6_5907_5F71_9AA8_6D4B_8BD5_9636_6BB5(context, phase)
    local maxLife = GetUnitStateJapi(context["Boss单位"], UNIT_STATE_MAX_LIFE)
    local ratio = phase == 1 and 1 or (phase == 2 and 0.6 or 0.3)
    SetUnitState(context["Boss单位"], UNIT_STATE_LIFE, maxLife * ratio)
    _____8BBE_7F6E_5F71_9AA8_83AB_7279_65AF_6D4B_8BD5_9636_6BB5(context, phase)
end
function ____on_5F71_9AA8_6280_80FD2Kill_5EF6_8FDF_51FB_6740(variable)
    if variable == nil then
        return
    end
    local ____self_19 = variable["召唤组"]
    local skeletons = ____self_19["取单位列表"](____self_19)
    do
        local i = 0
        while i < #skeletons do
            local skeleton = skeletons[i + 1]
            if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(skeleton) then
                KillUnit(skeleton)
            end
            i = i + 1
        end
    end
    if _____5F71_9AA82Kill_6D4B_8BD5_8868[variable["玩家ID"]] == variable then
        _____5F71_9AA82Kill_6D4B_8BD5_8868[variable["玩家ID"]] = nil
    end
end
function _____6E05_7406_5F71_9AA8_4E0A_4E00_6B21_53EC_5524_6D4B_8BD5(previous)
    if previous == nil then
        return
    end
    local ____self_21 = previous["召唤组"]
    local skeletons = ____self_21["取单位列表"](____self_21)
    local ____self_22 = previous["召唤组"]
    ____self_22["销毁"](____self_22)
    do
        local i = 0
        while i < #skeletons do
            local skeleton = skeletons[i + 1]
            if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(skeleton) then
                KillUnit(skeleton)
            end
            i = i + 1
        end
    end
end
function _____5B89_6392_5F71_9AA8_9636_6BB5_5F3A_5316_6D4B_8BD5(player, context, phase)
    if context == nil or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["Boss单位"]) then
        return
    end
    _____51C6_5907_5F71_9AA8_6D4B_8BD5_9636_6BB5(context, phase)
    local pid = GetPlayerId(player)
    _____6E05_7406_5F71_9AA8_4E0A_4E00_6B21_53EC_5524_6D4B_8BD5(_____5F71_9AA82Kill_6D4B_8BD5_8868[pid])
    local group = _____91CA_653E_5F71_9AA8_9AB8_9AA8_53EC_5524(context)
    if group == nil then
        return
    end
    local skeletons = group["取单位列表"](group)
    if #skeletons <= 0 then
        return
    end
    local variable = {["玩家ID"] = pid, ["骷髅列表"] = skeletons, ["召唤组"] = group}
    _____5F71_9AA82Kill_6D4B_8BD5_8868[pid] = variable
    local delayedId = addDelayedCallback(3500, ____on_5F71_9AA8_6280_80FD2Kill_5EF6_8FDF_51FB_6740, variable)
    local ____self_23 = context["清理"]
    ____self_23["登记延迟回调"](____self_23, "影骨测试-阶段强化击杀", delayedId)
end
local jass = require("jass.common")
local japi = require("jass.japi")
GetUnitStateJapi = japi.GetUnitState
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_0.SelectUnitForPlayerSingle
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_1.StarOther_PanCameraToTimedForPlayer
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_2["应用Boss战启动属性配置"]
local ____require_result_3 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_3["标记测试Boss跳过死亡结算"]
local ____require_result_4 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04 = ____require_result_4["创建测试中心平移映射"]
local _____6309_6D4B_8BD5_6620_5C04_5E73_79FBXY_5750_6807 = ____require_result_4["按测试映射平移XY坐标"]
local ____require_result_5 = require("系统.12．测试系统.00．Boss测试系统.index")
____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_5["Boss测试单位存活"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_5["设置Boss测试单位满血"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_5["获取Boss测试玩家基准英雄"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_5["准备Boss测试固定步兵"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = ____require_result_5["准备Boss测试固定山丘之王"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_5["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_5["注册Boss测试命令组"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____require_result_6["获取或创建影骨莫特斯上下文"]
local _____6E05_7406_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____require_result_6["清理影骨莫特斯上下文"]
_____8BBE_7F6E_5F71_9AA8_83AB_7279_65AF_6D4B_8BD5_9636_6BB5 = ____require_result_6["设置影骨莫特斯测试阶段"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.10．被动效果")
local _____6CE8_518C_5F71_9AA8_83AB_7279_65AF_88AB_52A8_6548_679C = ____require_result_7["注册影骨莫特斯被动效果"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.05．暗影禁锢")
local _____91CA_653E_5F71_9AA8_6697_5F71_7981_9522 = ____require_result_8["释放影骨暗影禁锢"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.03．阴影穿梭")
local _____91CA_653E_5F71_9AA8_9634_5F71_7A7F_68AD = ____require_result_9["释放影骨阴影穿梭"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.04．骸骨召唤")
_____91CA_653E_5F71_9AA8_9AB8_9AA8_53EC_5524 = ____require_result_10["释放影骨骸骨召唤"]
local _____521B_5EFA_5F71_9AA8_53EC_5524_7EC4 = ____require_result_10["创建影骨召唤组"]
local _____521B_5EFA_5F71_9AA8_53EC_5524_7269 = ____require_result_10["创建影骨召唤物"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.02．数值与表现配置")
local _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____require_result_11["影骨莫特斯数值与表现配置"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.11．公共工具")
local _____6781_5750_6807X = ____require_result_12["极坐标X"]
local _____6781_5750_6807Y = ____require_result_12["极坐标Y"]
local ____require_result_13 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_13.addDelayedCallback
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.06．幽影爆发")
local _____91CA_653E_5F71_9AA8_5E7D_5F71_7206_53D1 = ____require_result_14["释放影骨幽影爆发"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.07．盗贼的遗产")
local _____91CA_653E_5F71_9AA8_76D7_8D3C_9057_4EA7 = ____require_result_15["释放影骨盗贼遗产"]
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X = -540.6
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y = -2495.2
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y = -3055.2
local CreateUnit = jass.CreateUnit
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local GetUnitFacing = jass.GetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
SetUnitState = jass.SetUnitState
GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomReal = jass.GetRandomReal
KillUnit = jass.KillUnit
local GetUnitState = jass.GetUnitState
local UnitDamageTarget = jass.UnitDamageTarget
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_16 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_16.debugLogForce
local _____5F71_9AA8_6D4B_8BD5Boss = {}
local _____5F71_9AA8_6D4B_8BD5_6B65_5175 = {}
local _____5F71_9AA8_6D4B_8BD5_5C71_4E18_4E4B_738B = {}
local _____5F71_9AA8_6D4B_8BD5_73A9_5BB6_82F1_96C4_5FEB_7167_8868 = {}
_____5F71_9AA82Kill_6D4B_8BD5_8868 = {}
local function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
local function _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    local pid = GetPlayerId(player)
    local cached = _____5F71_9AA8_6D4B_8BD5Boss[pid]
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(cached) then
        SetUnitPosition(cached, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y)
        SetUnitFacing(cached, 270)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(cached)
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(cached)
        globals.udg_Boss = cached
        return cached
    end
    local boss = CreateUnit(
        player,
        stringToFourCC("N01Y"),
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y,
        270
    )
    if boss ~= nil and boss ~= 0 then
        _____5F71_9AA8_6D4B_8BD5Boss[pid] = boss
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
        SetHeroLevel(boss, 42, false)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
        globals.udg_Boss = boss
    end
    return boss
end
local function _____51C6_5907_6D4B_8BD5_573A_666F(player, boss)
    local pid = GetPlayerId(player)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if hero ~= nil then
        if _____5F71_9AA8_6D4B_8BD5_73A9_5BB6_82F1_96C4_5FEB_7167_8868[pid] == nil then
            _____5F71_9AA8_6D4B_8BD5_73A9_5BB6_82F1_96C4_5FEB_7167_8868[pid] = {
                ["单位"] = hero,
                X = GetUnitX(hero),
                Y = GetUnitY(hero),
                ["朝向"] = GetUnitFacing(hero)
            }
        end
        SetUnitPosition(hero, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y)
        SetUnitFacing(hero, 90)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    end
    _____5F71_9AA8_6D4B_8BD5_6B65_5175[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(_____5F71_9AA8_6D4B_8BD5_6B65_5175[pid], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X - 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    _____5F71_9AA8_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(_____5F71_9AA8_6D4B_8BD5_5C71_4E18_4E4B_738B[pid], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X + 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    local ____SelectUnitForPlayerSingle_18 = SelectUnitForPlayerSingle
    local ____temp_17
    if hero ~= nil and hero ~= 0 then
        ____temp_17 = hero
    else
        ____temp_17 = boss
    end
    ____SelectUnitForPlayerSingle_18(____temp_17, player)
    StarOther_PanCameraToTimedForPlayer(player, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y, 0.2)
end
local function _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
end
local function _____5E94_7528_5F71_9AA8_76D7_8D3C_9057_4EA7_6D4B_8BD5_5750_6807(context)
    local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E
    local _____6620_5C04 = _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04(cfg["幽影爆发"]["召唤中心X"], cfg["幽影爆发"]["召唤中心Y"], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y)
    local _____6D4B_8BD5_5B9D_7BB1_70B9 = {}
    do
        local i = 0
        while i < #cfg["盗贼的遗产"]["宝箱点"] do
            local _____6B63_5F0F_5B9D_7BB1_70B9 = cfg["盗贼的遗产"]["宝箱点"][i + 1]
            local _____6D4B_8BD5_5B9D_7BB1_70B9_5750_6807 = _____6309_6D4B_8BD5_6620_5C04_5E73_79FBXY_5750_6807(_____6B63_5F0F_5B9D_7BB1_70B9, _____6620_5C04)
            _____6D4B_8BD5_5B9D_7BB1_70B9[#_____6D4B_8BD5_5B9D_7BB1_70B9 + 1] = {X = _____6D4B_8BD5_5B9D_7BB1_70B9_5750_6807.X, Y = _____6D4B_8BD5_5B9D_7BB1_70B9_5750_6807.Y, ["朝向"] = _____6B63_5F0F_5B9D_7BB1_70B9["朝向"]}
            i = i + 1
        end
    end
    context["遗产宝箱点"] = _____6D4B_8BD5_5B9D_7BB1_70B9
end
local function _____521B_5EFA_5F71_9AA8_6D4B_8BD5(player)
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    _____6CE8_518C_5F71_9AA8_83AB_7279_65AF_88AB_52A8_6548_679C()
    _____51C6_5907_6D4B_8BD5_573A_666F(player, boss)
    _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    local context = _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587(boss)
    if context ~= nil then
        _____5E94_7528_5F71_9AA8_76D7_8D3C_9057_4EA7_6D4B_8BD5_5750_6807(context)
    end
    return context
end
local function _____6E05_7406_5F71_9AA8_6D4B_8BD5(player, _context)
    local pid = GetPlayerId(player)
    local heroSnapshot = _____5F71_9AA8_6D4B_8BD5_73A9_5BB6_82F1_96C4_5FEB_7167_8868[pid]
    if heroSnapshot ~= nil and ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(heroSnapshot["单位"]) then
        SetUnitPosition(heroSnapshot["单位"], heroSnapshot.X, heroSnapshot.Y)
        SetUnitFacing(heroSnapshot["单位"], heroSnapshot["朝向"])
    end
    local boss = _____5F71_9AA8_6D4B_8BD5Boss[pid]
    if boss ~= nil and boss ~= 0 then
        _____6E05_7406_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587(boss)
    end
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____5F71_9AA8_6D4B_8BD5_6B65_5175[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____5F71_9AA8_6D4B_8BD5_5C71_4E18_4E4B_738B[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(boss)
    _____5F71_9AA8_6D4B_8BD5_6B65_5175[pid] = nil
    _____5F71_9AA8_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = nil
    _____5F71_9AA8_6D4B_8BD5Boss[pid] = nil
    _____5F71_9AA8_6D4B_8BD5_73A9_5BB6_82F1_96C4_5FEB_7167_8868[pid] = nil
    _____5F71_9AA82Kill_6D4B_8BD5_8868[pid] = nil
    if globals.udg_Boss == boss then
        globals.udg_Boss = nil
    end
end
local function ____on_5F71_9AA8_6280_80FD1_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_5F71_9AA8_9634_5F71_7A7F_68AD(context)
    end
end
local function ____on_5F71_9AA8_6280_80FD2_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____51C6_5907_5F71_9AA8_6D4B_8BD5_9636_6BB5(context, 1)
        _____91CA_653E_5F71_9AA8_9AB8_9AA8_53EC_5524(context)
    end
end
local function ____on_5F71_9AA8_6280_80FD2P2_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____5B89_6392_5F71_9AA8_9636_6BB5_5F3A_5316_6D4B_8BD5(_player, context, 2)
    end
end
local function ____on_5F71_9AA8_6280_80FD2P3_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____5B89_6392_5F71_9AA8_9636_6BB5_5F3A_5316_6D4B_8BD5(_player, context, 3)
    end
end
local function ____on_5F71_9AA8_6280_80FD2Kill_6D4B_8BD5_547D_4EE4(player, context, phase)
    if phase == nil then
        phase = 1
    end
    if context == nil or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["Boss单位"]) then
        return
    end
    _____51C6_5907_5F71_9AA8_6D4B_8BD5_9636_6BB5(context, phase)
    local pid = GetPlayerId(player)
    local previous = _____5F71_9AA82Kill_6D4B_8BD5_8868[pid]
    _____6E05_7406_5F71_9AA8_4E0A_4E00_6B21_53EC_5524_6D4B_8BD5(previous)
    local group = _____521B_5EFA_5F71_9AA8_53EC_5524_7EC4(context, phase, true, 4)
    context["当前召唤组"] = group
    local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]
    local skeletons = {}
    local skeletonTypeId = stringToFourCC(cfg["骷髅盗贼单位类型"])
    do
        local i = 0
        while i < 4 do
            local angle = GetRandomReal(0, 360)
            local distance = GetRandomReal(80, cfg["召唤偏移半径"])
            local x = _____6781_5750_6807X(
                GetUnitX(context["Boss单位"]),
                distance,
                angle
            )
            local y = _____6781_5750_6807Y(
                GetUnitY(context["Boss单位"]),
                distance,
                angle
            )
            local instance = _____521B_5EFA_5F71_9AA8_53EC_5524_7269(
                context,
                skeletonTypeId,
                x,
                y,
                group
            )
            if instance ~= nil and ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(instance["单位"]) then
                skeletons[#skeletons + 1] = instance["单位"]
            end
            i = i + 1
        end
    end
    group["结束批次"](group)
    if #skeletons <= 0 then
        group["销毁"](group)
        return
    end
    local variable = {["玩家ID"] = pid, ["骷髅列表"] = skeletons, ["召唤组"] = group}
    _____5F71_9AA82Kill_6D4B_8BD5_8868[pid] = variable
    local delayedId = addDelayedCallback(2000, ____on_5F71_9AA8_6280_80FD2Kill_5EF6_8FDF_51FB_6740, variable)
    local ____self_20 = context["清理"]
    ____self_20["登记延迟回调"](____self_20, "影骨测试-2-kill", delayedId)
end
local function ____on_5F71_9AA8_6280_80FD3_6D4B_8BD5_547D_4EE4(player, context)
    local target = _____5F71_9AA8_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    if context ~= nil and ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        SelectUnitForPlayerSingle(target, player)
        _____91CA_653E_5F71_9AA8_6697_5F71_7981_9522(context, target)
    end
end
local _____5F71_9AA8_5E7D_5F71_7206_53D1_4F24_5BB3_6D4B_8BD5_6A21_5757_540D = "影骨-幽影爆发承伤测试"
local _____5F71_9AA8_5E7D_5F71_7206_53D1_6D4B_8BD5_5355_6B21_4F24_5BB3 = 1000
local function _____8BB0_5F55_5F71_9AA8_5E7D_5F71_7206_53D1_6D4B_8BD5_4F24_5BB3(_____6807_7B7E, _____53D8_91CF, _____662F_5426_666E_901A_653B_51FB, _____4F24_5BB3_7C7B_578B)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____53D8_91CF["来源单位"]) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____53D8_91CF["目标单位"]) then
        debugLogForce(_____5F71_9AA8_5E7D_5F71_7206_53D1_4F24_5BB3_6D4B_8BD5_6A21_5757_540D, _____6807_7B7E, "跳过：来源或目标无效")
        return
    end
    local _____4F24_5BB3_524D_751F_547D = GetUnitState(_____53D8_91CF["目标单位"], UNIT_STATE_LIFE)
    local _____8C03_7528_6210_529F = UnitDamageTarget(
        _____53D8_91CF["来源单位"],
        _____53D8_91CF["目标单位"],
        _____5F71_9AA8_5E7D_5F71_7206_53D1_6D4B_8BD5_5355_6B21_4F24_5BB3,
        _____662F_5426_666E_901A_653B_51FB,
        false,
        ATTACK_TYPE_NORMAL,
        _____4F24_5BB3_7C7B_578B,
        WEAPON_TYPE_WHOKNOWS
    )
    local _____4F24_5BB3_540E_751F_547D = GetUnitState(_____53D8_91CF["目标单位"], UNIT_STATE_LIFE)
    debugLogForce(
        _____5F71_9AA8_5E7D_5F71_7206_53D1_4F24_5BB3_6D4B_8BD5_6A21_5757_540D,
        _____6807_7B7E,
        "提交值=",
        _____5F71_9AA8_5E7D_5F71_7206_53D1_6D4B_8BD5_5355_6B21_4F24_5BB3,
        "调用成功=",
        _____8C03_7528_6210_529F,
        "伤害前生命=",
        _____4F24_5BB3_524D_751F_547D,
        "伤害后生命=",
        _____4F24_5BB3_540E_751F_547D,
        "实际扣除=",
        _____4F24_5BB3_524D_751F_547D - _____4F24_5BB3_540E_751F_547D
    )
end
local function ____on_5F71_9AA8_6280_80FD4_2_7269_7406_4F24_5BB3(_____53D8_91CF)
    _____8BB0_5F55_5F71_9AA8_5E7D_5F71_7206_53D1_6D4B_8BD5_4F24_5BB3("第1秒物理伤害", _____53D8_91CF, true, DAMAGE_TYPE_NORMAL)
end
local function ____on_5F71_9AA8_6280_80FD4_2_9B54_6CD5_4F24_5BB3(_____53D8_91CF)
    _____8BB0_5F55_5F71_9AA8_5E7D_5F71_7206_53D1_6D4B_8BD5_4F24_5BB3("第2秒魔法伤害", _____53D8_91CF, false, DAMAGE_TYPE_MAGIC)
end
local function ____on_5F71_9AA8_6280_80FD4_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_5F71_9AA8_5E7D_5F71_7206_53D1(context)
    end
end
local function ____on_5F71_9AA8_6280_80FD4_2_6D4B_8BD5_547D_4EE4(player, context)
    local _____6765_6E90_5355_4F4D = _____5F71_9AA8_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    if context == nil or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____6765_6E90_5355_4F4D) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["Boss单位"]) then
        debugLogForce(_____5F71_9AA8_5E7D_5F71_7206_53D1_4F24_5BB3_6D4B_8BD5_6A21_5757_540D, "命令4-2跳过：测试靶或莫特斯无效")
        return
    end
    _____91CA_653E_5F71_9AA8_5E7D_5F71_7206_53D1(context)
    local _____53D8_91CF = {["来源单位"] = _____6765_6E90_5355_4F4D, ["目标单位"] = context["Boss单位"]}
    local _____7269_7406_4F24_5BB3_56DE_8C03ID = addDelayedCallback(1000, ____on_5F71_9AA8_6280_80FD4_2_7269_7406_4F24_5BB3, _____53D8_91CF)
    local _____9B54_6CD5_4F24_5BB3_56DE_8C03ID = addDelayedCallback(2000, ____on_5F71_9AA8_6280_80FD4_2_9B54_6CD5_4F24_5BB3, _____53D8_91CF)
    local ____self_24 = context["清理"]
    ____self_24["登记延迟回调"](____self_24, "影骨测试-4-2-物理伤害", _____7269_7406_4F24_5BB3_56DE_8C03ID)
    local ____self_25 = context["清理"]
    ____self_25["登记延迟回调"](____self_25, "影骨测试-4-2-魔法伤害", _____9B54_6CD5_4F24_5BB3_56DE_8C03ID)
    debugLogForce(_____5F71_9AA8_5E7D_5F71_7206_53D1_4F24_5BB3_6D4B_8BD5_6A21_5757_540D, "命令4-2已启动", "第1秒物理1000", "第2秒魔法1000")
end
local function ____on_5F71_9AA8_6280_80FD5_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_5F71_9AA8_76D7_8D3C_9057_4EA7(context)
    end
end
local _____5F71_9AA8_83AB_7279_65AF_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "阴影穿梭", ["执行"] = ____on_5F71_9AA8_6280_80FD1_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["名称"] = "骸骨召唤（P1基础，死亡后重组）", ["执行"] = ____on_5F71_9AA8_6280_80FD2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["命令"] = "2-2", ["名称"] = "骸骨召唤强化测试（P2，3.5秒后击杀，随后3秒重组）", ["执行"] = ____on_5F71_9AA8_6280_80FD2P2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["命令"] = "2-3", ["名称"] = "骸骨召唤强化测试（P3，攻击+30%，爆发冷却65%，3.5秒后击杀，不重组）", ["执行"] = ____on_5F71_9AA8_6280_80FD2P3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["命令"] = "2-kill", ["名称"] = "骸骨召唤快速击杀（P1）", ["执行"] = ____on_5F71_9AA8_6280_80FD2Kill_6D4B_8BD5_547D_4EE4},
    {["序号"] = 3, ["名称"] = "暗影禁锢", ["执行"] = ____on_5F71_9AA8_6280_80FD3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 4, ["名称"] = "幽影爆发", ["执行"] = ____on_5F71_9AA8_6280_80FD4_6D4B_8BD5_547D_4EE4},
    {["序号"] = 4, ["命令"] = "4-2", ["名称"] = "幽影爆发承伤测试（1秒物理，2秒魔法）", ["执行"] = ____on_5F71_9AA8_6280_80FD4_2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 5, ["名称"] = "盗贼的遗产", ["执行"] = ____on_5F71_9AA8_6280_80FD5_6D4B_8BD5_547D_4EE4}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "莫特斯",
    ["Boss名称"] = "影骨莫特斯",
    ["创建或获取上下文"] = _____521B_5EFA_5F71_9AA8_6D4B_8BD5,
    ["清理上下文"] = _____6E05_7406_5F71_9AA8_6D4B_8BD5,
    ["技能命令列表"] = _____5F71_9AA8_83AB_7279_65AF_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
