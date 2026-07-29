--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_0.SelectUnitForPlayerSingle
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_1.StarOther_PanCameraToTimedForPlayer
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_2["应用Boss战启动属性配置"]
local ____require_result_3 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_3["标记测试Boss跳过死亡结算"]
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_4.debugLogForce
local ____require_result_5 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_5["Boss测试单位存活"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_5["设置Boss测试单位满血"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_5["获取Boss测试玩家基准英雄"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_5["准备Boss测试固定步兵"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = ____require_result_5["准备Boss测试固定山丘之王"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_5["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_5["注册Boss测试命令组"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587 = ____require_result_6["获取或创建里科特上下文"]
local _____6E05_7406_91CC_79D1_7279_4E0A_4E0B_6587 = ____require_result_6["清理里科特上下文"]
local _____53D6_91CC_79D1_7279_5F53_524D_9636_6BB5 = ____require_result_6["取里科特当前阶段"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.12．被动效果")
local _____6CE8_518C_91CC_79D1_7279_88AB_52A8_6548_679C = ____require_result_7["注册里科特被动效果"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.02．数值与表现配置")
local _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E = ____require_result_8["里科特数值与表现配置"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_9["施加快速减速Buff"]
local _____5355_4F4D_662F_5426_5904_4E8E_51CF_901F_6548_679C_5408_96C6 = ____require_result_9["单位是否处于减速效果合集"]
local ____require_result_10 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_10.addDelayedCallback
local removeDelayedCallback = ____require_result_10.removeDelayedCallback
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.04．四重风刃")
local _____91CA_653E_91CC_79D1_7279_56DB_91CD_98CE_5203 = ____require_result_11["释放里科特四重风刃"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.05．追击风刃")
local _____91CA_653E_91CC_79D1_7279_8FFD_51FB_98CE_5203 = ____require_result_12["释放里科特追击风刃"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.06．神风护体与粉碎")
local _____91CA_653E_91CC_79D1_7279_795E_98CE_62A4_4F53 = ____require_result_13["释放里科特神风护体"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.07．湮灭之炮")
local _____91CA_653E_91CC_79D1_7279_6E6E_706D_4E4B_70AE = ____require_result_14["释放里科特湮灭之炮"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.08．湮灭之风")
local _____91CA_653E_91CC_79D1_7279_6E6E_706D_4E4B_98CE = ____require_result_15["释放里科特湮灭之风"]
local ____require_result_16 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.09．破魔反击")
local _____91CA_653E_91CC_79D1_7279_7834_9B54_53CD_51FB = ____require_result_16["释放里科特破魔反击"]
local _____7ACB_5373_5F00_542F_91CC_79D1_7279_7834_9B54_53CD_51FB_7A97_53E3 = ____require_result_16["立即开启里科特破魔反击窗口"]
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X = -540.6
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y = -2495.2
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y = -3055.2
local CreateUnit = jass.CreateUnit
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local GetPlayerId = jass.GetPlayerId
local GetUnitState = jass.GetUnitState
local GetUnitStateJapi = japi.GetUnitState
local SetUnitState = jass.SetUnitState
local UnitDamageTarget = jass.UnitDamageTarget
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local DAMAGE_TYPE_UNIVERSAL = jass.DAMAGE_TYPE_UNIVERSAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____91CC_79D1_7279_88AB_52A8_6D4B_8BD5_8C03_8BD5_6A21_5757 = "里科特被动测试"
local _____91CC_79D1_7279_6D4B_8BD5Boss = {}
local _____91CC_79D1_7279_6D4B_8BD5_6B65_5175 = {}
local _____91CC_79D1_7279_6D4B_8BD5_5C71_4E18_4E4B_738B = {}
local _____91CC_79D1_7279_51CF_901F_6D4B_8BD5_5F85_68C0_67E5Boss = nil
local _____91CC_79D1_7279_51CF_901F_6D4B_8BD5_521D_59CB_5DF2_751F_6548 = false
local _____91CC_79D1_7279_51CF_901F_6D4B_8BD5_56DE_8C03ID = 0
local _____91CC_79D1_7279_53CD_51FB_6D4B_8BD5_56DE_8C03ID = 0
local function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
local function _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    local pid = GetPlayerId(player)
    local cached = _____91CC_79D1_7279_6D4B_8BD5Boss[pid]
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
        stringToFourCC("N05U"),
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y,
        270
    )
    if boss ~= nil and boss ~= 0 then
        _____91CC_79D1_7279_6D4B_8BD5Boss[pid] = boss
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
        SetHeroLevel(boss, 40, false)
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
    _____91CC_79D1_7279_6D4B_8BD5_6B65_5175[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(_____91CC_79D1_7279_6D4B_8BD5_6B65_5175[pid], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X - 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    _____91CC_79D1_7279_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(_____91CC_79D1_7279_6D4B_8BD5_5C71_4E18_4E4B_738B[pid], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X + 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y, 0.2)
end
local function _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
end
local function _____521B_5EFA_91CC_79D1_7279_6D4B_8BD5(player)
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    _____6CE8_518C_91CC_79D1_7279_88AB_52A8_6548_679C()
    _____51C6_5907_6D4B_8BD5_573A_666F(player, boss)
    _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    return _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587(boss)
end
local function _____6E05_7406_91CC_79D1_7279_6D4B_8BD5(player, _context)
    local pid = GetPlayerId(player)
    local boss = _____91CC_79D1_7279_6D4B_8BD5Boss[pid]
    if _____91CC_79D1_7279_51CF_901F_6D4B_8BD5_56DE_8C03ID > 0 then
        removeDelayedCallback(_____91CC_79D1_7279_51CF_901F_6D4B_8BD5_56DE_8C03ID)
    end
    if _____91CC_79D1_7279_53CD_51FB_6D4B_8BD5_56DE_8C03ID > 0 then
        removeDelayedCallback(_____91CC_79D1_7279_53CD_51FB_6D4B_8BD5_56DE_8C03ID)
    end
    _____91CC_79D1_7279_51CF_901F_6D4B_8BD5_56DE_8C03ID = 0
    _____91CC_79D1_7279_53CD_51FB_6D4B_8BD5_56DE_8C03ID = 0
    _____91CC_79D1_7279_51CF_901F_6D4B_8BD5_5F85_68C0_67E5Boss = nil
    _____91CC_79D1_7279_51CF_901F_6D4B_8BD5_521D_59CB_5DF2_751F_6548 = false
    if boss ~= nil and boss ~= 0 then
        _____6E05_7406_91CC_79D1_7279_4E0A_4E0B_6587(boss)
    end
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____91CC_79D1_7279_6D4B_8BD5_6B65_5175[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____91CC_79D1_7279_6D4B_8BD5_5C71_4E18_4E4B_738B[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(boss)
    _____91CC_79D1_7279_6D4B_8BD5_6B65_5175[pid] = nil
    _____91CC_79D1_7279_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = nil
    _____91CC_79D1_7279_6D4B_8BD5Boss[pid] = nil
    if globals.udg_Boss == boss then
        globals.udg_Boss = nil
    end
end
local function _____8BBE_7F6E_91CC_79D1_7279_6D4B_8BD5_9636_6BB5(context, _____9636_6BB5)
    if context == nil or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["Boss单位"]) then
        return false
    end
    local boss = context["Boss单位"]
    local maxLife = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) then
        return false
    end
    local thresholds = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段阈值"]
    local ratio = 1
    if _____9636_6BB5 == 2 then
        ratio = (thresholds["P2生命比例"] + thresholds["P3生命比例"]) * 0.5
    end
    if _____9636_6BB5 == 3 then
        ratio = thresholds["P3生命比例"] * 0.5
    end
    local life = maxLife * ratio
    SetUnitState(boss, UNIT_STATE_LIFE, life)
    local actualStage = _____53D6_91CC_79D1_7279_5F53_524D_9636_6BB5(boss)
    context["阶段"] = actualStage
    if actualStage ~= _____9636_6BB5 then
        debugLogForce(
            _____91CC_79D1_7279_88AB_52A8_6D4B_8BD5_8C03_8BD5_6A21_5757,
            "阶段命令准备失败",
            "目标阶段=",
            _____9636_6BB5,
            "实际阶段=",
            actualStage,
            "最大生命=",
            maxLife,
            "当前生命=",
            GetUnitState(boss, UNIT_STATE_LIFE)
        )
        return false
    end
    return true
end
local function _____6267_884C_91CC_79D1_7279_9636_6BB5_6280_80FD_6D4B_8BD5(context, _____9636_6BB5, _____91CA_653E_6280_80FD)
    if not _____8BBE_7F6E_91CC_79D1_7279_6D4B_8BD5_9636_6BB5(context, _____9636_6BB5) then
        return
    end
    _____91CA_653E_6280_80FD(context)
end
local function ____on_91CC_79D1_7279_6280_80FD1_6D4B_8BD5_547D_4EE4(_player, context)
    _____6267_884C_91CC_79D1_7279_9636_6BB5_6280_80FD_6D4B_8BD5(context, 1, _____91CA_653E_91CC_79D1_7279_56DB_91CD_98CE_5203)
end
local function ____on_91CC_79D1_7279_6280_80FD1P2_6D4B_8BD5_547D_4EE4(_player, context)
    _____6267_884C_91CC_79D1_7279_9636_6BB5_6280_80FD_6D4B_8BD5(context, 2, _____91CA_653E_91CC_79D1_7279_56DB_91CD_98CE_5203)
end
local function ____on_91CC_79D1_7279_6280_80FD1P3_6D4B_8BD5_547D_4EE4(_player, context)
    _____6267_884C_91CC_79D1_7279_9636_6BB5_6280_80FD_6D4B_8BD5(context, 3, _____91CA_653E_91CC_79D1_7279_56DB_91CD_98CE_5203)
end
local function ____on_91CC_79D1_7279_6280_80FD2_6D4B_8BD5_547D_4EE4(_player, context)
    _____6267_884C_91CC_79D1_7279_9636_6BB5_6280_80FD_6D4B_8BD5(context, 1, _____91CA_653E_91CC_79D1_7279_8FFD_51FB_98CE_5203)
end
local function ____on_91CC_79D1_7279_6280_80FD2P2_6D4B_8BD5_547D_4EE4(_player, context)
    _____6267_884C_91CC_79D1_7279_9636_6BB5_6280_80FD_6D4B_8BD5(context, 2, _____91CA_653E_91CC_79D1_7279_8FFD_51FB_98CE_5203)
end
local function ____on_91CC_79D1_7279_6280_80FD2P3_6D4B_8BD5_547D_4EE4(_player, context)
    _____6267_884C_91CC_79D1_7279_9636_6BB5_6280_80FD_6D4B_8BD5(context, 3, _____91CA_653E_91CC_79D1_7279_8FFD_51FB_98CE_5203)
end
local function ____on_91CC_79D1_7279_6280_80FD3_6D4B_8BD5_547D_4EE4(_player, context)
    _____6267_884C_91CC_79D1_7279_9636_6BB5_6280_80FD_6D4B_8BD5(context, 1, _____91CA_653E_91CC_79D1_7279_6E6E_706D_4E4B_70AE)
end
local function ____on_91CC_79D1_7279_6280_80FD3P2_6D4B_8BD5_547D_4EE4(_player, context)
    _____6267_884C_91CC_79D1_7279_9636_6BB5_6280_80FD_6D4B_8BD5(context, 2, _____91CA_653E_91CC_79D1_7279_6E6E_706D_4E4B_70AE)
end
local function ____on_91CC_79D1_7279_6280_80FD3P3_6D4B_8BD5_547D_4EE4(_player, context)
    _____6267_884C_91CC_79D1_7279_9636_6BB5_6280_80FD_6D4B_8BD5(context, 3, _____91CA_653E_91CC_79D1_7279_6E6E_706D_4E4B_70AE)
end
local function ____on_91CC_79D1_7279_6280_80FD4_6D4B_8BD5_547D_4EE4(_player, context)
    _____6267_884C_91CC_79D1_7279_9636_6BB5_6280_80FD_6D4B_8BD5(context, 2, _____91CA_653E_91CC_79D1_7279_6E6E_706D_4E4B_98CE)
end
local function ____on_91CC_79D1_7279_6280_80FD4P2_6D4B_8BD5_547D_4EE4(_player, context)
    _____6267_884C_91CC_79D1_7279_9636_6BB5_6280_80FD_6D4B_8BD5(context, 2, _____91CA_653E_91CC_79D1_7279_6E6E_706D_4E4B_98CE)
end
local function ____on_91CC_79D1_7279_6280_80FD4P3_6D4B_8BD5_547D_4EE4(_player, context)
    _____6267_884C_91CC_79D1_7279_9636_6BB5_6280_80FD_6D4B_8BD5(context, 3, _____91CA_653E_91CC_79D1_7279_6E6E_706D_4E4B_98CE)
end
local function ____on_91CC_79D1_7279_6280_80FD5_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_91CC_79D1_7279_7834_9B54_53CD_51FB(context)
    end
end
local function ____on_91CC_79D1_7279_7834_9B54_53CD_51FB_6D4B_8BD5_653B_51FB(variable)
    _____91CC_79D1_7279_53CD_51FB_6D4B_8BD5_56DE_8C03ID = 0
    local data = variable
    if data == nil or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(data["Boss单位"]) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(data["攻击单位"]) then
        return
    end
    local success = UnitDamageTarget(
        data["攻击单位"],
        data["Boss单位"],
        100,
        true,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
    debugLogForce(_____91CC_79D1_7279_88AB_52A8_6D4B_8BD5_8C03_8BD5_6A21_5757, "命令5-2 破魔反击", "0.5秒后普通攻击调用成功=", success)
end
local function ____on_91CC_79D1_7279_6280_80FD5P2_53CD_51FB_6D4B_8BD5_547D_4EE4(player, context)
    if not _____8BBE_7F6E_91CC_79D1_7279_6D4B_8BD5_9636_6BB5(context, 2) then
        return
    end
    local source = _____91CC_79D1_7279_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(source) then
        debugLogForce(_____91CC_79D1_7279_88AB_52A8_6D4B_8BD5_8C03_8BD5_6A21_5757, "命令5-2失败：找不到固定步兵攻击来源")
        return
    end
    if _____91CC_79D1_7279_53CD_51FB_6D4B_8BD5_56DE_8C03ID > 0 then
        removeDelayedCallback(_____91CC_79D1_7279_53CD_51FB_6D4B_8BD5_56DE_8C03ID)
    end
    _____7ACB_5373_5F00_542F_91CC_79D1_7279_7834_9B54_53CD_51FB_7A97_53E3(context)
    local data = {["Boss单位"] = context["Boss单位"], ["攻击单位"] = source}
    _____91CC_79D1_7279_53CD_51FB_6D4B_8BD5_56DE_8C03ID = addDelayedCallback(500, ____on_91CC_79D1_7279_7834_9B54_53CD_51FB_6D4B_8BD5_653B_51FB, data)
    local ____self_17 = context["清理"]
    ____self_17["登记延迟回调"](____self_17, "里科特-破魔反击自动测试", _____91CC_79D1_7279_53CD_51FB_6D4B_8BD5_56DE_8C03ID)
end
local function ____on_91CC_79D1_7279_6280_80FD6_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_91CC_79D1_7279_795E_98CE_62A4_4F53(context)
    end
end
local function ____on_91CC_79D1_7279_6280_80FD7_6D4B_8BD5_547D_4EE4(player, context)
    if context == nil or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["Boss单位"]) then
        return
    end
    local boss = context["Boss单位"]
    local source = _____91CC_79D1_7279_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(source) then
        debugLogForce(_____91CC_79D1_7279_88AB_52A8_6D4B_8BD5_8C03_8BD5_6A21_5757, "命令7失败：找不到固定步兵伤害来源")
        return
    end
    local maxLife = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE)
    SetUnitState(boss, UNIT_STATE_LIFE, maxLife)
    local beforeLife = GetUnitState(boss, UNIT_STATE_LIFE)
    local inputDamage = maxLife * 0.5
    local expectedCap = maxLife * _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["被动"]["单次最大生命伤害比例"]
    local success = UnitDamageTarget(
        source,
        boss,
        inputDamage,
        false,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_UNIVERSAL,
        WEAPON_TYPE_WHOKNOWS
    )
    local actualLoss = beforeLife - GetUnitState(boss, UNIT_STATE_LIFE)
    debugLogForce(
        _____91CC_79D1_7279_88AB_52A8_6D4B_8BD5_8C03_8BD5_6A21_5757,
        "命令7 单次伤害上限",
        "调用成功=",
        success,
        "输入伤害=",
        inputDamage,
        "理论上限=",
        expectedCap,
        "实际扣血=",
        actualLoss,
        "通过=",
        success and actualLoss <= expectedCap + 1
    )
end
local function ____on_91CC_79D1_7279_51CF_901F_514D_75AB_5EF6_8FDF_68C0_67E5()
    local boss = _____91CC_79D1_7279_51CF_901F_6D4B_8BD5_5F85_68C0_67E5Boss
    local applied = _____91CC_79D1_7279_51CF_901F_6D4B_8BD5_521D_59CB_5DF2_751F_6548
    _____91CC_79D1_7279_51CF_901F_6D4B_8BD5_5F85_68C0_67E5Boss = nil
    _____91CC_79D1_7279_51CF_901F_6D4B_8BD5_521D_59CB_5DF2_751F_6548 = false
    _____91CC_79D1_7279_51CF_901F_6D4B_8BD5_56DE_8C03ID = 0
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return
    end
    local remaining = _____5355_4F4D_662F_5426_5904_4E8E_51CF_901F_6548_679C_5408_96C6(boss)
    debugLogForce(
        _____91CC_79D1_7279_88AB_52A8_6D4B_8BD5_8C03_8BD5_6A21_5757,
        "命令8 减速免疫",
        "初始检测到减速=",
        applied,
        "1.2秒后仍有减速=",
        remaining,
        "通过=",
        applied and not remaining
    )
end
local function ____on_91CC_79D1_7279_6280_80FD8_6D4B_8BD5_547D_4EE4(player, context)
    if context == nil or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["Boss单位"]) then
        return
    end
    local boss = context["Boss单位"]
    local source = _____91CC_79D1_7279_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(source) then
        debugLogForce(_____91CC_79D1_7279_88AB_52A8_6D4B_8BD5_8C03_8BD5_6A21_5757, "命令8失败：找不到固定步兵减速来源")
        return
    end
    _____65BD_52A0_5FEB_901F_51CF_901FBuff(
        source,
        boss,
        0,
        0.5,
        5,
        "里科特被动测试",
        "技能"
    )
    local applied = _____5355_4F4D_662F_5426_5904_4E8E_51CF_901F_6548_679C_5408_96C6(boss)
    debugLogForce(
        _____91CC_79D1_7279_88AB_52A8_6D4B_8BD5_8C03_8BD5_6A21_5757,
        "命令8 减速施加后",
        "检测到减速=",
        applied,
        "等待1.2秒检查被动清除"
    )
    if _____91CC_79D1_7279_51CF_901F_6D4B_8BD5_56DE_8C03ID > 0 then
        removeDelayedCallback(_____91CC_79D1_7279_51CF_901F_6D4B_8BD5_56DE_8C03ID)
    end
    _____91CC_79D1_7279_51CF_901F_6D4B_8BD5_5F85_68C0_67E5Boss = boss
    _____91CC_79D1_7279_51CF_901F_6D4B_8BD5_521D_59CB_5DF2_751F_6548 = applied
    _____91CC_79D1_7279_51CF_901F_6D4B_8BD5_56DE_8C03ID = addDelayedCallback(1200, ____on_91CC_79D1_7279_51CF_901F_514D_75AB_5EF6_8FDF_68C0_67E5)
end
local _____91CC_79D1_7279_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "四重风刃(P1基础)", ["执行"] = ____on_91CC_79D1_7279_6280_80FD1_6D4B_8BD5_547D_4EE4},
    {["序号"] = 1, ["命令"] = "1-2", ["名称"] = "四重风刃(P2强化)", ["执行"] = ____on_91CC_79D1_7279_6280_80FD1P2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 1, ["命令"] = "1-3", ["名称"] = "四重风刃(P3强化)", ["执行"] = ____on_91CC_79D1_7279_6280_80FD1P3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["名称"] = "追击风刃(P1基础)", ["执行"] = ____on_91CC_79D1_7279_6280_80FD2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["命令"] = "2-2", ["名称"] = "追击风刃(P2强化)", ["执行"] = ____on_91CC_79D1_7279_6280_80FD2P2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["命令"] = "2-3", ["名称"] = "追击风刃(P3强化)", ["执行"] = ____on_91CC_79D1_7279_6280_80FD2P3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 3, ["名称"] = "湮灭之炮(P1基础)", ["执行"] = ____on_91CC_79D1_7279_6280_80FD3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 3, ["命令"] = "3-2", ["名称"] = "湮灭之炮(P2强化)", ["执行"] = ____on_91CC_79D1_7279_6280_80FD3P2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 3, ["命令"] = "3-3", ["名称"] = "湮灭之炮(P3强化)", ["执行"] = ____on_91CC_79D1_7279_6280_80FD3P3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 4, ["名称"] = "湮灭之风(P2基础)", ["执行"] = ____on_91CC_79D1_7279_6280_80FD4_6D4B_8BD5_547D_4EE4},
    {["序号"] = 4, ["命令"] = "4-2", ["名称"] = "湮灭之风(P2阶段)", ["执行"] = ____on_91CC_79D1_7279_6280_80FD4P2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 4, ["命令"] = "4-3", ["名称"] = "湮灭之风(P3强化)", ["执行"] = ____on_91CC_79D1_7279_6280_80FD4P3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 5, ["名称"] = "破魔反击", ["执行"] = ____on_91CC_79D1_7279_6280_80FD5_6D4B_8BD5_547D_4EE4},
    {["序号"] = 5, ["命令"] = "5-2", ["名称"] = "破魔反击(P2自动受击测试)", ["执行"] = ____on_91CC_79D1_7279_6280_80FD5P2_53CD_51FB_6D4B_8BD5_547D_4EE4},
    {["序号"] = 6, ["名称"] = "神风护体", ["执行"] = ____on_91CC_79D1_7279_6280_80FD6_6D4B_8BD5_547D_4EE4},
    {["序号"] = 7, ["名称"] = "被动-单次伤害上限", ["执行"] = ____on_91CC_79D1_7279_6280_80FD7_6D4B_8BD5_547D_4EE4},
    {["序号"] = 8, ["名称"] = "被动-减速免疫", ["执行"] = ____on_91CC_79D1_7279_6280_80FD8_6D4B_8BD5_547D_4EE4}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "里科特",
    ["Boss名称"] = "里科特",
    ["创建或获取上下文"] = _____521B_5EFA_91CC_79D1_7279_6D4B_8BD5,
    ["清理上下文"] = _____6E05_7406_91CC_79D1_7279_6D4B_8BD5,
    ["技能命令列表"] = _____91CC_79D1_7279_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
