--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_0.SelectUnitForPlayerSingle
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_1.StarOther_PanCameraToTimedForPlayer
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_2["应用Boss战启动属性配置"]
local ____require_result_3 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_3["标记测试Boss跳过死亡结算"]
local ____require_result_4 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_4["Boss测试单位存活"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_4["设置Boss测试单位满血"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_4["获取Boss测试玩家基准英雄"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_4["准备Boss测试固定步兵"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = ____require_result_4["准备Boss测试固定山丘之王"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_4["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_4["注册Boss测试命令组"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____require_result_5["获取或创建影骨莫特斯上下文"]
local _____6E05_7406_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____require_result_5["清理影骨莫特斯上下文"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.10．被动效果")
local _____6CE8_518C_5F71_9AA8_83AB_7279_65AF_88AB_52A8_6548_679C = ____require_result_6["注册影骨莫特斯被动效果"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.05．暗影禁锢")
local _____91CA_653E_5F71_9AA8_6697_5F71_7981_9522 = ____require_result_7["释放影骨暗影禁锢"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.03．阴影穿梭")
local _____91CA_653E_5F71_9AA8_9634_5F71_7A7F_68AD = ____require_result_8["释放影骨阴影穿梭"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.04．骸骨召唤")
local _____91CA_653E_5F71_9AA8_9AB8_9AA8_53EC_5524 = ____require_result_9["释放影骨骸骨召唤"]
local _____521B_5EFA_5F71_9AA8_53EC_5524_7269 = ____require_result_9["创建影骨召唤物"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.02．数值与表现配置")
local _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____require_result_10["影骨莫特斯数值与表现配置"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.11．公共工具")
local _____6781_5750_6807X = ____require_result_11["极坐标X"]
local _____6781_5750_6807Y = ____require_result_11["极坐标Y"]
local ____require_result_12 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_12.addDelayedCallback
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.06．幽影爆发")
local _____91CA_653E_5F71_9AA8_5E7D_5F71_7206_53D1 = ____require_result_13["释放影骨幽影爆发"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.07．盗贼的遗产")
local _____91CA_653E_5F71_9AA8_76D7_8D3C_9057_4EA7 = ____require_result_14["释放影骨盗贼遗产"]
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X = -540.6
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y = -2495.2
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y = -3055.2
local CreateUnit = jass.CreateUnit
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local SetUnitState = jass.SetUnitState
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomReal = jass.GetRandomReal
local KillUnit = jass.KillUnit
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____5F71_9AA8_6D4B_8BD5Boss = {}
local _____5F71_9AA8_6D4B_8BD5_6B65_5175 = {}
local _____5F71_9AA8_6D4B_8BD5_5C71_4E18_4E4B_738B = {}
local _____5F71_9AA82Kill_6D4B_8BD5_8868 = {}
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
    if hero ~= nil and hero ~= 0 then
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    end
    _____5F71_9AA8_6D4B_8BD5_6B65_5175[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(_____5F71_9AA8_6D4B_8BD5_6B65_5175[pid], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X - 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    _____5F71_9AA8_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(_____5F71_9AA8_6D4B_8BD5_5C71_4E18_4E4B_738B[pid], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X + 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y, 0.2)
end
local function _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
end
local function _____521B_5EFA_5F71_9AA8_6D4B_8BD5(player)
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    _____6CE8_518C_5F71_9AA8_83AB_7279_65AF_88AB_52A8_6548_679C()
    _____51C6_5907_6D4B_8BD5_573A_666F(player, boss)
    _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    return _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587(boss)
end
local function _____6E05_7406_5F71_9AA8_6D4B_8BD5(player, _context)
    local pid = GetPlayerId(player)
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
    _____5F71_9AA82Kill_6D4B_8BD5_8868[pid] = nil
    if globals.udg_Boss == boss then
        globals.udg_Boss = nil
    end
end
local function _____51C6_5907_5F71_9AA8_6D4B_8BD5_9636_6BB5(context, phase)
    local maxLife = GetUnitStateJapi(context["Boss单位"], UNIT_STATE_MAX_LIFE)
    local ratio = phase == 1 and 1 or (phase == 2 and 0.6 or 0.3)
    SetUnitState(context["Boss单位"], UNIT_STATE_LIFE, maxLife * ratio)
    context["阶段"] = phase
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
        _____51C6_5907_5F71_9AA8_6D4B_8BD5_9636_6BB5(context, 2)
        _____91CA_653E_5F71_9AA8_9AB8_9AA8_53EC_5524(context)
    end
end
local function ____on_5F71_9AA8_6280_80FD2P3_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____51C6_5907_5F71_9AA8_6D4B_8BD5_9636_6BB5(context, 3)
        _____91CA_653E_5F71_9AA8_9AB8_9AA8_53EC_5524(context)
    end
end
local function ____on_5F71_9AA8_6280_80FD2Kill_5EF6_8FDF_51FB_6740(variable)
    if variable == nil then
        return
    end
    do
        local i = 0
        while i < #variable["骷髅列表"] do
            local skeleton = variable["骷髅列表"][i + 1]
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
local function ____on_5F71_9AA8_6280_80FD2Kill_6D4B_8BD5_547D_4EE4(player, context)
    if context == nil or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["Boss单位"]) then
        return
    end
    local pid = GetPlayerId(player)
    local previous = _____5F71_9AA82Kill_6D4B_8BD5_8868[pid]
    if previous ~= nil then
        previous["召唤组"]["已重组"] = true
        do
            local i = 0
            while i < #previous["骷髅列表"] do
                local skeleton = previous["骷髅列表"][i + 1]
                if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(skeleton) then
                    KillUnit(skeleton)
                end
                i = i + 1
            end
        end
    end
    local group = {
        ID = (context["下一个召唤组ID"] or 0) + 1,
        ["阶段"] = context["阶段"],
        ["总数"] = 4,
        ["死亡数"] = 0,
        ["已重组"] = false
    }
    context["下一个召唤组ID"] = group.ID
    context["当前召唤组"] = group
    local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]
    local skeletons = {}
    local skeletonTypeId = stringToFourCC(cfg["骷髅盗贼单位类型"])
    do
        local i = 0
        while i < group["总数"] do
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
                group,
                true
            )
            if instance ~= nil and ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(instance["单位"]) then
                skeletons[#skeletons + 1] = instance["单位"]
            end
            i = i + 1
        end
    end
    group["总数"] = #skeletons
    if group["总数"] <= 0 then
        return
    end
    local variable = {["玩家ID"] = pid, ["骷髅列表"] = skeletons, ["召唤组"] = group}
    _____5F71_9AA82Kill_6D4B_8BD5_8868[pid] = variable
    local delayedId = addDelayedCallback(2000, ____on_5F71_9AA8_6280_80FD2Kill_5EF6_8FDF_51FB_6740, variable)
    local ____self_15 = context["清理"]
    ____self_15["登记延迟回调"](____self_15, "影骨测试-2-kill", delayedId)
end
local function ____on_5F71_9AA8_6280_80FD3_6D4B_8BD5_547D_4EE4(player, context)
    local target = _____5F71_9AA8_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    if context ~= nil and ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        _____91CA_653E_5F71_9AA8_6697_5F71_7981_9522(context, target)
    end
end
local function ____on_5F71_9AA8_6280_80FD4_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_5F71_9AA8_5E7D_5F71_7206_53D1(context)
    end
end
local function ____on_5F71_9AA8_6280_80FD5_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_5F71_9AA8_76D7_8D3C_9057_4EA7(context)
    end
end
local _____5F71_9AA8_83AB_7279_65AF_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "阴影穿梭", ["执行"] = ____on_5F71_9AA8_6280_80FD1_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["名称"] = "骸骨召唤（P1基础，死亡后重组）", ["执行"] = ____on_5F71_9AA8_6280_80FD2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["命令"] = "2-2", ["名称"] = "骸骨召唤（P2，死亡后重组）", ["执行"] = ____on_5F71_9AA8_6280_80FD2P2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["命令"] = "2-3", ["名称"] = "骸骨召唤（P3强化，死亡后不重组）", ["执行"] = ____on_5F71_9AA8_6280_80FD2P3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["命令"] = "2-kill", ["名称"] = "骸骨召唤快速击杀", ["执行"] = ____on_5F71_9AA8_6280_80FD2Kill_6D4B_8BD5_547D_4EE4},
    {["序号"] = 3, ["名称"] = "暗影禁锢", ["执行"] = ____on_5F71_9AA8_6280_80FD3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 4, ["名称"] = "幽影爆发", ["执行"] = ____on_5F71_9AA8_6280_80FD4_6D4B_8BD5_547D_4EE4},
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
