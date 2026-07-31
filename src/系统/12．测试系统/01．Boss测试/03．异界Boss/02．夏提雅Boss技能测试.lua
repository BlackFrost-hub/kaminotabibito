--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
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
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.00．配置")
local _____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_7["夏提雅单位技能配置"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587 = ____require_result_8["获取或创建夏提雅运行时上下文"]
local _____6E05_7406_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587 = ____require_result_8["清理夏提雅运行时上下文"]
local _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB = ____require_result_8["重置夏提雅猎血连击"]
local _____8BBE_7F6E_590F_63D0_96C5_9636_6BB5_6A21_578B = ____require_result_8["设置夏提雅阶段模型"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.04．鲜血印记")
local _____521B_5EFA_590F_63D0_96C5_9C9C_8840_5370_8BB0 = ____require_result_9["创建夏提雅鲜血印记"]
local _____6E05_7406_590F_63D0_96C5_9C9C_8840_5370_8BB0 = ____require_result_9["清理夏提雅鲜血印记"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.05．滴管穿心")
local _____91CA_653E_590F_63D0_96C5_6EF4_7BA1_7A7F_5FC3 = ____require_result_10["释放夏提雅滴管穿心"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.06．血月轮舞")
local _____91CA_653E_590F_63D0_96C5_8840_6708_8F6E_821E = ____require_result_11["释放夏提雅血月轮舞"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.07．净化投枪")
local _____91CA_653E_590F_63D0_96C5_51C0_5316_6295_67AA = ____require_result_12["释放夏提雅净化投枪"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.08．鲜血回收")
local _____91CA_653E_590F_63D0_96C5_9C9C_8840_56DE_6536 = ____require_result_13["释放夏提雅鲜血回收"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.09．英灵战乙女")
local _____542F_52A8_590F_63D0_96C5_82F1_7075_6218_4E59_5973_9636_6BB5 = ____require_result_14["启动夏提雅英灵战乙女阶段"]
local _____6E05_7406_82F1_7075_6218_4E59_5973_6295_5F71 = ____require_result_14["清理英灵战乙女投影"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.10．镜像夹击")
local _____91CA_653E_590F_63D0_96C5_955C_50CF_5939_51FB = ____require_result_15["释放夏提雅镜像夹击"]
local ____require_result_16 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.11．真祖血宴")
local _____91CA_653E_590F_63D0_96C5_771F_7956_8840_5BB4 = ____require_result_16["释放夏提雅真祖血宴"]
local ____require_result_17 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.12．血月终舞")
local _____91CA_653E_590F_63D0_96C5_8840_6708_7EC8_821E = ____require_result_17["释放夏提雅血月终舞"]
local ____require_result_18 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.15．挑战入口与收束")
local _____7ED1_5B9A_590F_63D0_96C5_6311_6218_751F_547D_4E0B_9650 = ____require_result_18["绑定夏提雅挑战生命下限"]
local ____require_result_19 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____505C_6B62_5355_4F4D_4F4D_79FB = ____require_result_19["停止单位位移"]
local ____require_result_20 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_20.debugLogForce
local CreateUnit = jass.CreateUnit
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local SetUnitState = jass.SetUnitState
local GetUnitStateJapi = japi.GetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
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
    _____7ED1_5B9A_590F_63D0_96C5_6311_6218_751F_547D_4E0B_9650(runtime)
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
local function _____6E05_7A7A_590F_63D0_96C5_6D4B_8BD5_8840_5370(context)
    local source = context["运行时"]["血印句柄列表"]
    local marks = {}
    do
        local i = 0
        while i < #source do
            marks[#marks + 1] = source[i + 1]
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #marks do
            _____6E05_7406_590F_63D0_96C5_9C9C_8840_5370_8BB0(context["运行时"], marks[i + 1], false)
            i = i + 1
        end
    end
end
local function _____51C6_5907_590F_63D0_96C5_6D4B_8BD5_9636_6BB5(context, _____9636_6BB5, _____4FDD_7559_8840_5370)
    if _____4FDD_7559_8840_5370 == nil then
        _____4FDD_7559_8840_5370 = false
    end
    local runtime = context["运行时"]
    local boss = context["Boss单位"]
    local maxLife = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) then
        return
    end
    _____505C_6B62_5355_4F4D_4F4D_79FB(boss, "中断")
    _____505C_6B62_5355_4F4D_4F4D_79FB(context["目标单位"], "中断")
    local mirrorExecutor = runtime["镜像夹击执行器"]
    if mirrorExecutor ~= nil and mirrorExecutor["是否运行中"](mirrorExecutor) then
        mirrorExecutor["停止"](mirrorExecutor, nil, "中断")
    end
    runtime["镜像夹击执行器"] = nil
    runtime["镜像夹击执行ID"] = 0
    SetUnitPosition(boss, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitFacing(boss, 270)
    SetUnitPosition(context["目标单位"], _____73A9_5BB6_6D4B_8BD5X - 220, _____73A9_5BB6_6D4B_8BD5Y + 180)
    SetUnitFacing(context["目标单位"], 90)
    if not _____4FDD_7559_8840_5370 then
        _____6E05_7A7A_590F_63D0_96C5_6D4B_8BD5_8840_5370(context)
    end
    if _____9636_6BB5 ~= 2 then
        _____6E05_7406_82F1_7075_6218_4E59_5973_6295_5F71(runtime)
    end
    local lifeRatio = 1
    local phase = "P1鲜血女武神"
    if _____9636_6BB5 == 2 then
        lifeRatio = (_____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E["阶段阈值"]["P2生命比例"] + _____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E["阶段阈值"]["P3生命比例"]) * 0.5
        phase = "P2英灵战乙女"
    elseif _____9636_6BB5 == 3 then
        lifeRatio = _____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E["阶段阈值"]["P3生命比例"] * 0.5
        phase = "P3真祖血宴"
    end
    SetUnitState(boss, UNIT_STATE_LIFE, maxLife * lifeRatio)
    runtime["阶段"] = phase
    _____8BBE_7F6E_590F_63D0_96C5_9636_6BB5_6A21_578B(runtime)
    runtime["当前大型技能"] = nil
    runtime["普通机制忙碌到Ms"] = 0
    runtime["P3转阶段已处理"] = _____9636_6BB5 == 3
    runtime["血月终舞已释放"] = false
    runtime["英灵复刻冷却到Ms"] = 0
    runtime["上次英灵复刻技能"] = ""
    _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB(runtime)
end
local function _____51C6_5907_590F_63D0_96C5P2_82F1_7075(context)
    _____6E05_7406_82F1_7075_6218_4E59_5973_6295_5F71(context["运行时"])
    _____51C6_5907_590F_63D0_96C5_6D4B_8BD5_9636_6BB5(context, 2)
    _____542F_52A8_590F_63D0_96C5_82F1_7075_6218_4E59_5973_9636_6BB5(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_6EF4_7BA1_7A7F_5FC3(_player, context)
    _____51C6_5907_590F_63D0_96C5_6D4B_8BD5_9636_6BB5(context, 1)
    _____91CA_653E_590F_63D0_96C5_6EF4_7BA1_7A7F_5FC3(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_6EF4_7BA1_7A7F_5FC3P2(_player, context)
    _____51C6_5907_590F_63D0_96C5P2_82F1_7075(context)
    local started = _____91CA_653E_590F_63D0_96C5_6EF4_7BA1_7A7F_5FC3(context["运行时"], context["目标单位"])
    debugLogForce(
        "夏提雅-测试命令",
        "命令1-2执行",
        "started=",
        started,
        "phase=",
        context["运行时"]["阶段"],
        "projection=",
        context["运行时"]["英灵战乙女句柄"]
    )
end
local function _____6D4B_8BD5_590F_63D0_96C5_6EF4_7BA1_7A7F_5FC3P3(_player, context)
    _____51C6_5907_590F_63D0_96C5_6D4B_8BD5_9636_6BB5(context, 3)
    _____91CA_653E_590F_63D0_96C5_6EF4_7BA1_7A7F_5FC3(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_8840_6708_8F6E_821E(_player, context)
    _____51C6_5907_590F_63D0_96C5_6D4B_8BD5_9636_6BB5(context, 1)
    _____91CA_653E_590F_63D0_96C5_8840_6708_8F6E_821E(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_8840_6708_8F6E_821EP3(_player, context)
    _____51C6_5907_590F_63D0_96C5_6D4B_8BD5_9636_6BB5(context, 3)
    _____91CA_653E_590F_63D0_96C5_8840_6708_8F6E_821E(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_51C0_5316_6295_67AA(_player, context)
    _____51C6_5907_590F_63D0_96C5_6D4B_8BD5_9636_6BB5(context, 1)
    _____91CA_653E_590F_63D0_96C5_51C0_5316_6295_67AA(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_51C0_5316_6295_67AAP2(_player, context)
    _____51C6_5907_590F_63D0_96C5P2_82F1_7075(context)
    _____91CA_653E_590F_63D0_96C5_51C0_5316_6295_67AA(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_51C0_5316_6295_67AAP3(_player, context)
    _____51C6_5907_590F_63D0_96C5_6D4B_8BD5_9636_6BB5(context, 3)
    _____91CA_653E_590F_63D0_96C5_51C0_5316_6295_67AA(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_9C9C_8840_56DE_6536(_player, context)
    _____51C6_5907_590F_63D0_96C5_6D4B_8BD5_9636_6BB5(context, 1)
    _____521B_5EFA_590F_63D0_96C5_6D4B_8BD5_8840_5370(context)
    _____91CA_653E_590F_63D0_96C5_9C9C_8840_56DE_6536(context["运行时"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_82F1_7075_6218_4E59_5973(_player, context)
    _____51C6_5907_590F_63D0_96C5_6D4B_8BD5_9636_6BB5(context, 2)
    _____542F_52A8_590F_63D0_96C5_82F1_7075_6218_4E59_5973_9636_6BB5(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_955C_50CF_5939_51FB(_player, context)
    _____51C6_5907_590F_63D0_96C5P2_82F1_7075(context)
    _____91CA_653E_590F_63D0_96C5_955C_50CF_5939_51FB(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_771F_7956_8840_5BB4(_player, context)
    _____51C6_5907_590F_63D0_96C5_6D4B_8BD5_9636_6BB5(context, 1)
    _____521B_5EFA_590F_63D0_96C5_6D4B_8BD5_8840_5370(context)
    _____51C6_5907_590F_63D0_96C5_6D4B_8BD5_9636_6BB5(context, 3, true)
    context["运行时"]["P3转阶段已处理"] = false
    _____91CA_653E_590F_63D0_96C5_771F_7956_8840_5BB4(context["运行时"])
end
local function _____6D4B_8BD5_590F_63D0_96C5_8840_6708_7EC8_821E(_player, context)
    _____51C6_5907_590F_63D0_96C5_6D4B_8BD5_9636_6BB5(context, 3)
    context["运行时"]["P3转阶段已处理"] = true
    _____91CA_653E_590F_63D0_96C5_8840_6708_7EC8_821E(context["运行时"], context["目标单位"])
end
local function _____51C6_5907_590F_63D0_96C5_8840_4E4B_590D_751F(_player, context)
    _____51C6_5907_590F_63D0_96C5_6D4B_8BD5_9636_6BB5(context, 3)
    _____7ED1_5B9A_590F_63D0_96C5_6311_6218_751F_547D_4E0B_9650(context["运行时"])
    context["运行时"]["已触发复生"] = false
    SetUnitState(context["Boss单位"], UNIT_STATE_LIFE, 1)
end
local _____590F_63D0_96C5_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "滴管穿心（P1基础）", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_6EF4_7BA1_7A7F_5FC3},
    {["序号"] = 1, ["命令"] = "1-2", ["名称"] = "滴管穿心（P2英灵复刻）", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_6EF4_7BA1_7A7F_5FC3P2},
    {["序号"] = 1, ["命令"] = "1-3", ["名称"] = "滴管穿心（P3两段猎血起手）", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_6EF4_7BA1_7A7F_5FC3P3},
    {["序号"] = 2, ["名称"] = "血月轮舞（P1基础）", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_8840_6708_8F6E_821E},
    {["序号"] = 2, ["命令"] = "2-3", ["名称"] = "血月轮舞（P3第二段加速）", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_8840_6708_8F6E_821EP3},
    {["序号"] = 3, ["名称"] = "净化投枪（P1基础）", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_51C0_5316_6295_67AA},
    {["序号"] = 3, ["命令"] = "3-2", ["名称"] = "净化投枪（P2英灵复刻）", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_51C0_5316_6295_67AAP2},
    {["序号"] = 3, ["命令"] = "3-3", ["名称"] = "净化投枪（P3双投枪）", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_51C0_5316_6295_67AAP3},
    {["序号"] = 4, ["名称"] = "鲜血回收（P1/P2同形态）", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_9C9C_8840_56DE_6536},
    {["序号"] = 5, ["名称"] = "英灵战乙女（P2基础）", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_82F1_7075_6218_4E59_5973},
    {["序号"] = 6, ["名称"] = "镜像夹击（P2基础）", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_955C_50CF_5939_51FB},
    {["序号"] = 7, ["名称"] = "真祖血宴（P3转阶段）", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_771F_7956_8840_5BB4},
    {["序号"] = 8, ["名称"] = "血月终舞（P3基础）", ["执行"] = _____6D4B_8BD5_590F_63D0_96C5_8840_6708_7EC8_821E},
    {["序号"] = 9, ["名称"] = "血之复生被动准备（再输入55触底）", ["执行"] = _____51C6_5907_590F_63D0_96C5_8840_4E4B_590D_751F}
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
