--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local globals = require("jass.globals")
local ____require_result_0 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_0["Boss测试单位存活"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_0["设置Boss测试单位满血"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_0["获取Boss测试玩家基准英雄"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_0["准备Boss测试固定步兵"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = ____require_result_0["准备Boss测试固定山丘之王"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_0["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_0["注册Boss测试命令组"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_2.SelectUnitForPlayerSingle
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_3.StarOther_PanCameraToTimedForPlayer
local ____require_result_4 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_4["标记测试Boss跳过死亡结算"]
local ____require_result_5 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_5["应用Boss战启动属性配置"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.17．被动效果")
local _____6CE8_518C_590F_63D0_96C5_88AB_52A8_6548_679C = ____require_result_6["注册夏提雅被动效果"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587 = ____require_result_7["获取或创建夏提雅运行时上下文"]
local _____6E05_7406_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587 = ____require_result_7["清理夏提雅运行时上下文"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.04．鲜血印记")
local _____521B_5EFA_590F_63D0_96C5_9C9C_8840_5370_8BB0 = ____require_result_8["创建夏提雅鲜血印记"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.05．滴管穿心")
local _____91CA_653E_590F_63D0_96C5_6EF4_7BA1_7A7F_5FC3 = ____require_result_9["释放夏提雅滴管穿心"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.06．血月轮舞")
local _____91CA_653E_590F_63D0_96C5_8840_6708_8F6E_821E = ____require_result_10["释放夏提雅血月轮舞"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.07．净化投枪")
local _____91CA_653E_590F_63D0_96C5_51C0_5316_6295_67AA = ____require_result_11["释放夏提雅净化投枪"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.08．鲜血回收")
local _____91CA_653E_590F_63D0_96C5_9C9C_8840_56DE_6536 = ____require_result_12["释放夏提雅鲜血回收"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.09．英灵战乙女")
local _____542F_52A8_590F_63D0_96C5_82F1_7075_6218_4E59_5973_9636_6BB5 = ____require_result_13["启动夏提雅英灵战乙女阶段"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.10．镜像夹击")
local _____91CA_653E_590F_63D0_96C5_955C_50CF_5939_51FB = ____require_result_14["释放夏提雅镜像夹击"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.11．真祖血宴")
local _____91CA_653E_590F_63D0_96C5_771F_7956_8840_5BB4 = ____require_result_15["释放夏提雅真祖血宴"]
local ____require_result_16 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.12．血月终舞")
local _____91CA_653E_590F_63D0_96C5_8840_6708_7EC8_821E = ____require_result_16["释放夏提雅血月终舞"]
local CreateUnit = jass.CreateUnit
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local SetUnitState = jass.SetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local _____590F_63D0_96C5_5355_4F4DID = stringToFourCCSafe("U009")
local _____6D4B_8BD5_4E2D_5FC3X = -540.6
local _____6D4B_8BD5_4E2D_5FC3Y = -2495.2
local _____73A9_5BB6_6D4B_8BD5X = -540.6
local _____73A9_5BB6_6D4B_8BD5Y = -3055.2
local _____6700_8FD1_6D4B_8BD5Boss = {}
local _____6700_8FD1_6D4B_8BD5_6B65_5175 = {}
local _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B = {}
local function _____83B7_53D6_6216_521B_5EFA_590F_63D0_96C5_6D4B_8BD5Boss(player)
    local pid = GetPlayerId(player)
    local boss = _____6700_8FD1_6D4B_8BD5Boss[pid]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        boss = CreateUnit(
            player,
            _____590F_63D0_96C5_5355_4F4DID,
            _____6D4B_8BD5_4E2D_5FC3X,
            _____6D4B_8BD5_4E2D_5FC3Y,
            270
        )
        _____6700_8FD1_6D4B_8BD5Boss[pid] = boss
        if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
            SetHeroLevel(boss, 40, false)
        end
    end
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        SetUnitPosition(boss, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y)
        SetUnitFacing(boss, 270)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
        globals.udg_Boss = boss
    end
    return boss
end
local function _____83B7_53D6_6216_521B_5EFA_590F_63D0_96C5_6D4B_8BD5_6B65_5175(cache, player, x, y)
    local pid = GetPlayerId(player)
    local unit = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(cache[pid], x, y, 90)
    cache[pid] = unit
    return unit
end
local function _____521B_5EFA_6216_83B7_53D6_590F_63D0_96C5_6D4B_8BD5_4E0A_4E0B_6587(player)
    local pid = GetPlayerId(player)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    local boss = _____83B7_53D6_6216_521B_5EFA_590F_63D0_96C5_6D4B_8BD5Boss(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(hero) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    local target = _____83B7_53D6_6216_521B_5EFA_590F_63D0_96C5_6D4B_8BD5_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_5175, player, _____73A9_5BB6_6D4B_8BD5X - 220, _____73A9_5BB6_6D4B_8BD5Y + 180)
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid], _____73A9_5BB6_6D4B_8BD5X + 220, _____73A9_5BB6_6D4B_8BD5Y + 180, 90)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        return nil
    end
    _____6CE8_518C_590F_63D0_96C5_88AB_52A8_6548_679C()
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
    local runtime = _____83B7_53D6_6216_521B_5EFA_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587(boss)
    if runtime == nil then
        return nil
    end
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y, 0.2)
    return {["运行时"] = runtime, ["目标单位"] = target, ["Boss单位"] = boss}
end
local function _____6E05_7406_590F_63D0_96C5_6D4B_8BD5_4E0A_4E0B_6587(player, context)
    local pid = GetPlayerId(player)
    if context ~= nil and context["Boss单位"] ~= nil then
        _____6E05_7406_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587(context["Boss单位"])
    end
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_6B65_5175[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5Boss[pid])
    _____6700_8FD1_6D4B_8BD5_6B65_5175[pid] = nil
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = nil
    _____6700_8FD1_6D4B_8BD5Boss[pid] = nil
    if globals.udg_Boss == (context and context["Boss单位"]) then
        globals.udg_Boss = nil
    end
end
local function _____521B_5EFA_590F_63D0_96C5_6D4B_8BD5_8840_5370(context)
    local x = GetUnitX(context["Boss单位"])
    local y = GetUnitY(context["Boss单位"])
    _____521B_5EFA_590F_63D0_96C5_9C9C_8840_5370_8BB0(context["运行时"], x - 260, y - 120)
    _____521B_5EFA_590F_63D0_96C5_9C9C_8840_5370_8BB0(context["运行时"], x + 260, y - 120)
    _____521B_5EFA_590F_63D0_96C5_9C9C_8840_5370_8BB0(context["运行时"], x, y + 260)
end
local function _____6D4B_8BD5_590F_63D0_96C5_6EF4_7BA1_7A7F_5FC3(_player, context)
    _____91CA_653E_590F_63D0_96C5_6EF4_7BA1_7A7F_5FC3(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_8840_6708_8F6E_821E(_player, context)
    _____91CA_653E_590F_63D0_96C5_8840_6708_8F6E_821E(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_51C0_5316_6295_67AA(_player, context)
    _____91CA_653E_590F_63D0_96C5_51C0_5316_6295_67AA(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_9C9C_8840_56DE_6536(_player, context)
    context["运行时"]["阶段"] = "P1鲜血女武神"
    _____521B_5EFA_590F_63D0_96C5_6D4B_8BD5_8840_5370(context)
    _____91CA_653E_590F_63D0_96C5_9C9C_8840_56DE_6536(context["运行时"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_82F1_7075_6218_4E59_5973(_player, context)
    context["运行时"]["阶段"] = "P2英灵战乙女"
    _____542F_52A8_590F_63D0_96C5_82F1_7075_6218_4E59_5973_9636_6BB5(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_955C_50CF_5939_51FB(_player, context)
    context["运行时"]["阶段"] = "P2英灵战乙女"
    _____542F_52A8_590F_63D0_96C5_82F1_7075_6218_4E59_5973_9636_6BB5(context["运行时"], context["目标单位"])
    _____91CA_653E_590F_63D0_96C5_955C_50CF_5939_51FB(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_771F_7956_8840_5BB4(_player, context)
    context["运行时"]["阶段"] = "P3真祖血宴"
    context["运行时"]["P3转阶段已处理"] = false
    _____521B_5EFA_590F_63D0_96C5_6D4B_8BD5_8840_5370(context)
    _____91CA_653E_590F_63D0_96C5_771F_7956_8840_5BB4(context["运行时"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_8840_6708_7EC8_821E(_player, context)
    context["运行时"]["阶段"] = "P3真祖血宴"
    context["运行时"]["P3转阶段已处理"] = true
    context["运行时"]["血月终舞已释放"] = false
    _____91CA_653E_590F_63D0_96C5_8840_6708_7EC8_821E(context["运行时"], context["目标单位"])
end
local function _____51C6_5907_590F_63D0_96C5_8840_4E4B_590D_751F(_player, context)
    context["运行时"]["阶段"] = "P3真祖血宴"
    context["运行时"]["已触发复生"] = false
    SetUnitState(context["Boss单位"], UNIT_STATE_LIFE, 1)
end
local _____590F_63D0_96C5_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "滴管穿心", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_6EF4_7BA1_7A7F_5FC3},
    {["序号"] = 2, ["名称"] = "血月轮舞", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_8840_6708_8F6E_821E},
    {["序号"] = 3, ["名称"] = "净化投枪", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_51C0_5316_6295_67AA},
    {["序号"] = 4, ["名称"] = "鲜血回收", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_9C9C_8840_56DE_6536},
    {["序号"] = 5, ["名称"] = "P2英灵战乙女", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_82F1_7075_6218_4E59_5973},
    {["序号"] = 6, ["名称"] = "P2镜像夹击", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_955C_50CF_5939_51FB},
    {["序号"] = 7, ["名称"] = "P3真祖血宴", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_771F_7956_8840_5BB4},
    {["序号"] = 8, ["名称"] = "P3血月终舞", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_8840_6708_7EC8_821E},
    {["序号"] = 9, ["名称"] = "血之复生触发准备（攻击致死）", ["执行"] = _____51C6_5907_590F_63D0_96C5_8840_4E4B_590D_751F}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "夏提雅",
    ["Boss名称"] = "夏提雅",
    ["场地"] = {["正式中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}, ["测试空地中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}},
    ["创建或获取上下文"] = _____521B_5EFA_6216_83B7_53D6_590F_63D0_96C5_6D4B_8BD5_4E0A_4E0B_6587,
    ["清理上下文"] = _____6E05_7406_590F_63D0_96C5_6D4B_8BD5_4E0A_4E0B_6587,
    ["技能命令列表"] = _____590F_63D0_96C5_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
