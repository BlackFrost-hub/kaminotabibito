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
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_5.addDelayedCallback
local ____require_result_6 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_6["应用Boss战启动属性配置"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____require_result_7["安兹乌尔恭数值与表现配置"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.15．被动效果")
local _____6CE8_518C_5B89_5179_88AB_52A8_6548_679C = ____require_result_8["注册安兹被动效果"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587 = ____require_result_9["获取或创建安兹运行时上下文"]
local _____6E05_7406_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587 = ____require_result_9["清理安兹运行时上下文"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.12．守护者模式")
local _____542F_52A8_5B89_5179_5B88_62A4_8005_6A21_5F0F = ____require_result_10["启动安兹守护者模式"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.03．现实断裂")
local _____91CA_653E_5B89_5179_73B0_5B9E_65AD_88C2 = ____require_result_11["释放安兹现实断裂"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.04．心脏掌握")
local _____91CA_653E_5B89_5179_5FC3_810F_638C_63E1 = ____require_result_12["释放安兹心脏掌握"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.05．高阶魔法箭")
local _____91CA_653E_5B89_5179_9AD8_9636_9B54_6CD5_7BAD = ____require_result_13["释放安兹高阶魔法箭"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.06．光辉翠绿体")
local _____91CA_653E_5B89_5179_5149_8F89_7FE0_7EFF_4F53 = ____require_result_14["释放安兹光辉翠绿体"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.07．时间停止")
local _____91CA_653E_5B89_5179_65F6_95F4_505C_6B62 = ____require_result_15["释放安兹时间停止"]
local ____require_result_16 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.08．高阶亡灵召唤")
local _____91CA_653E_5B89_5179_9AD8_9636_4EA1_7075_53EC_5524 = ____require_result_16["释放安兹高阶亡灵召唤"]
local ____require_result_17 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.09．天空坠落")
local _____91CA_653E_5B89_5179_5929_7A7A_5760_843D = ____require_result_17["释放安兹天空坠落"]
local ____require_result_18 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.10．一切生命的终点")
local _____91CA_653E_5B89_5179_4E00_5207_751F_547D_7684_7EC8_70B9 = ____require_result_18["释放安兹一切生命的终点"]
local ____require_result_19 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.01．至尊拦截")
local _____91CA_653E_96C5_513F_8D1D_5FB7_81F3_5C0A_62E6_622A = ____require_result_19["释放雅儿贝德至尊拦截"]
local ____require_result_20 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.02．黑翼横扫")
local _____91CA_653E_96C5_513F_8D1D_5FB7_9ED1_7FFC_6A2A_626B = ____require_result_20["释放雅儿贝德黑翼横扫"]
local ____require_result_21 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.03．守护者之职责")
local _____91CA_653E_96C5_513F_8D1D_5FB7_5B88_62A4_8005_4E4B_804C_8D23 = ____require_result_21["释放雅儿贝德守护者之职责"]
local ____require_result_22 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.08．守护回归")
local _____91CA_653E_96C5_513F_8D1D_5FB7_5B88_62A4_56DE_5F52 = ____require_result_22["释放雅儿贝德守护回归"]
local ____require_result_23 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.09．护卫反击")
local _____91CA_653E_96C5_513F_8D1D_5FB7_62A4_536B_53CD_51FB = ____require_result_23["释放雅儿贝德护卫反击"]
local CreateUnit = jass.CreateUnit
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local UnitDamageTarget = jass.UnitDamageTarget
local Cos = jass.Cos
local Sin = jass.Sin
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local DAMAGE_TYPE_UNIVERSAL = jass.DAMAGE_TYPE_UNIVERSAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____5B89_5179_5355_4F4DID = stringToFourCCSafe("U007")
local _____6D4B_8BD5_4E2D_5FC3X = -540.6
local _____6D4B_8BD5_4E2D_5FC3Y = -2495.2
local _____73A9_5BB6_6D4B_8BD5X = -540.6
local _____73A9_5BB6_6D4B_8BD5Y = -3055.2
local _____89D2_5EA6_8F6C_5F27_5EA6 = 0.017453292519943295
local _____6700_8FD1_6D4B_8BD5Boss = {}
local _____6700_8FD1_6D4B_8BD5_6B65_5175 = {}
local _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B = {}
local function _____83B7_53D6_6216_521B_5EFA_5B89_5179_6D4B_8BD5Boss(player)
    local pid = GetPlayerId(player)
    local boss = _____6700_8FD1_6D4B_8BD5Boss[pid]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        boss = CreateUnit(
            player,
            _____5B89_5179_5355_4F4DID,
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
local function _____83B7_53D6_6216_521B_5EFA_5B89_5179_6D4B_8BD5_6B65_5175(cache, player, x, y)
    local pid = GetPlayerId(player)
    local unit = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(cache[pid], x, y, 90)
    cache[pid] = unit
    return unit
end
local function _____521B_5EFA_6216_83B7_53D6_5B89_5179_6D4B_8BD5_4E0A_4E0B_6587(player)
    local pid = GetPlayerId(player)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    local boss = _____83B7_53D6_6216_521B_5EFA_5B89_5179_6D4B_8BD5Boss(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(hero) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    local target = _____83B7_53D6_6216_521B_5EFA_5B89_5179_6D4B_8BD5_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_5175, player, _____73A9_5BB6_6D4B_8BD5X - 220, _____73A9_5BB6_6D4B_8BD5Y + 180)
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid], _____73A9_5BB6_6D4B_8BD5X + 220, _____73A9_5BB6_6D4B_8BD5Y + 180, 90)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        return nil
    end
    _____6CE8_518C_5B89_5179_88AB_52A8_6548_679C()
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
    local runtime = _____83B7_53D6_6216_521B_5EFA_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587(boss)
    if runtime == nil or not _____542F_52A8_5B89_5179_5B88_62A4_8005_6A21_5F0F(runtime) then
        return nil
    end
    local ____opt_24 = runtime["雅儿贝德"]
    if ____opt_24 ~= nil then
        ____opt_24 = ____opt_24["单位"]
    end
    local albedo = ____opt_24
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(albedo) then
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(albedo)
    end
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y, 0.2)
    return {["运行时"] = runtime, ["目标单位"] = target, ["Boss单位"] = boss}
end
local function _____6E05_7406_5B89_5179_6D4B_8BD5_4E0A_4E0B_6587(player, context)
    local pid = GetPlayerId(player)
    if context ~= nil and context["Boss单位"] ~= nil then
        _____6E05_7406_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587(context["Boss单位"])
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
local function _____6D4B_8BD5_5B89_5179_73B0_5B9E_65AD_88C2(_player, context)
    _____91CA_653E_5B89_5179_73B0_5B9E_65AD_88C2(context["运行时"])
end
local function _____6D4B_8BD5_5B89_5179_5FC3_810F_638C_63E1(_player, context)
    _____91CA_653E_5B89_5179_5FC3_810F_638C_63E1(context["运行时"])
end
local function _____6D4B_8BD5_5B89_5179_9AD8_9636_9B54_6CD5_7BAD(_player, context)
    _____91CA_653E_5B89_5179_9AD8_9636_9B54_6CD5_7BAD(context["运行时"])
end
local function _____6D4B_8BD5_5B89_5179_5149_8F89_7FE0_7EFF_4F53(_player, context)
    _____91CA_653E_5B89_5179_5149_8F89_7FE0_7EFF_4F53(context["运行时"])
end
local function _____6D4B_8BD5_5B89_5179_65F6_95F4_505C_6B62(_player, context)
    _____91CA_653E_5B89_5179_65F6_95F4_505C_6B62(context["运行时"])
end
local function _____6D4B_8BD5_5B89_5179_9AD8_9636_4EA1_7075_53EC_5524(_player, context)
    _____91CA_653E_5B89_5179_9AD8_9636_4EA1_7075_53EC_5524(context["运行时"])
end
local function _____6D4B_8BD5_5B89_5179_5929_7A7A_5760_843D(_player, context)
    context["运行时"]["天空坠落已释放"] = false
    _____91CA_653E_5B89_5179_5929_7A7A_5760_843D(context["运行时"])
end
local function _____6D4B_8BD5_5B89_5179_4E00_5207_751F_547D_7684_7EC8_70B9(_player, context)
    context["运行时"]["一切生命的终点已释放"] = false
    _____91CA_653E_5B89_5179_4E00_5207_751F_547D_7684_7EC8_70B9(context["运行时"])
end
local function _____6D4B_8BD5_5B89_5179_62A4_536B_6A21_5F0F(_player, context)
    _____542F_52A8_5B89_5179_5B88_62A4_8005_6A21_5F0F(context["运行时"])
end
local function _____6D4B_8BD5_96C5_513F_8D1D_5FB7_81F3_5C0A_62E6_622A(_player, context)
    if context["运行时"]["雅儿贝德"] ~= nil then
        context["运行时"]["雅儿贝德"]["上次至尊拦截Ms"] = 0
    end
    _____91CA_653E_96C5_513F_8D1D_5FB7_81F3_5C0A_62E6_622A(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_96C5_513F_8D1D_5FB7_9ED1_7FFC_6A2A_626B(_player, context)
    if context["运行时"]["雅儿贝德"] ~= nil then
        context["运行时"]["雅儿贝德"]["上次普通技能Ms"] = 0
    end
    _____91CA_653E_96C5_513F_8D1D_5FB7_9ED1_7FFC_6A2A_626B(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_96C5_513F_8D1D_5FB7_5B88_62A4_8005_4E4B_804C_8D23(_player, context)
    if context["运行时"]["雅儿贝德"] ~= nil then
        context["运行时"]["雅儿贝德"]["上次守护职责Ms"] = 0
    end
    _____91CA_653E_96C5_513F_8D1D_5FB7_5B88_62A4_8005_4E4B_804C_8D23(context["运行时"])
end
local function _____7ED3_7B97_5B88_62A4_804C_8D2320_767E_5206_6BD4_6700_5927_751F_547D_53D7_51FB(_____53C2_6570)
    local ____temp_30 = _____53C2_6570 == nil
    if not ____temp_30 then
        local ____opt_28 = _____53C2_6570["雅儿贝德状态"]
        if ____opt_28 ~= nil then
            ____opt_28 = ____opt_28["守护连接生效"]
        end
        ____temp_30 = ____opt_28 ~= true
    end
    if ____temp_30 then
        return
    end
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____53C2_6570["来源单位"]) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____53C2_6570["Boss单位"]) then
        return
    end
    local maxLife = GetUnitStateJapi(_____53C2_6570["Boss单位"], UNIT_STATE_MAX_LIFE)
    if maxLife <= 0 then
        return
    end
    UnitDamageTarget(
        _____53C2_6570["来源单位"],
        _____53C2_6570["Boss单位"],
        maxLife * 0.2,
        true,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
end
local function _____6D4B_8BD5_96C5_513F_8D1D_5FB7_5B88_62A4_8005_4E4B_804C_8D2320_767E_5206_6BD4_53D7_51FB(_player, context)
    if not _____542F_52A8_5B89_5179_5B88_62A4_8005_6A21_5F0F(context["运行时"]) then
        return
    end
    local state = context["运行时"]["雅儿贝德"]
    if state == nil then
        return
    end
    state["上次守护职责Ms"] = 0
    if not _____91CA_653E_96C5_513F_8D1D_5FB7_5B88_62A4_8005_4E4B_804C_8D23(context["运行时"]) then
        return
    end
    local delayMs = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]["守护者之职责预连接秒"] * 1000 + 50
    local delayedId = addDelayedCallback(delayMs, _____7ED3_7B97_5B88_62A4_804C_8D2320_767E_5206_6BD4_6700_5927_751F_547D_53D7_51FB, {["来源单位"] = context["目标单位"], ["Boss单位"] = context["Boss单位"], ["雅儿贝德状态"] = state})
    local ____self_31 = context["运行时"]["清理"]
    ____self_31["登记延迟回调"](____self_31, "安兹测试-守护职责-20%最大生命受击", delayedId)
end
local function _____6D4B_8BD5_96C5_513F_8D1D_5FB7_5B88_62A4_56DE_5F52(_player, context)
    local state = context["运行时"]["雅儿贝德"]
    local ____opt_result_34
    if state ~= nil then
        ____opt_result_34 = state["单位"]
    end
    local albedo = ____opt_result_34
    if state == nil or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(albedo) then
        return
    end
    state["上次守护回归Ms"] = 0
    SetUnitPosition(
        albedo,
        GetUnitX(context["Boss单位"]) + 1200,
        GetUnitY(context["Boss单位"])
    )
    _____91CA_653E_96C5_513F_8D1D_5FB7_5B88_62A4_56DE_5F52(context["运行时"])
end
local function _____6D4B_8BD5_96C5_513F_8D1D_5FB7_62A4_536B_53CD_51FB(_player, context)
    if context["运行时"]["雅儿贝德"] ~= nil then
        context["运行时"]["雅儿贝德"]["上次护卫反击Ms"] = 0
    end
    _____91CA_653E_96C5_513F_8D1D_5FB7_62A4_536B_53CD_51FB(context["运行时"])
end
local function _____7ED3_7B97_96C5_513F_8D1D_5FB7_62A4_536B_53CD_51FB_53D7_51FB(_____53C2_6570)
    if _____53C2_6570 == nil or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____53C2_6570["来源单位"]) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____53C2_6570["雅儿贝德单位"]) then
        return
    end
    local maxLife = GetUnitStateJapi(_____53C2_6570["雅儿贝德单位"], UNIT_STATE_MAX_LIFE)
    if maxLife <= 0 then
        return
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    if not (cfg["护卫反击承伤倍率"] > 0) then
        return
    end
    local damage = maxLife * cfg["护卫反击触发伤害最大生命比例"] / cfg["护卫反击承伤倍率"] + 1
    UnitDamageTarget(
        _____53C2_6570["来源单位"],
        _____53C2_6570["雅儿贝德单位"],
        damage,
        true,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_UNIVERSAL,
        WEAPON_TYPE_WHOKNOWS
    )
end
local function _____6D4B_8BD5_96C5_513F_8D1D_5FB7_62A4_536B_53CD_51FB_81EA_52A8_53D7_51FB(_player, context)
    local state = context["运行时"]["雅儿贝德"]
    local ____opt_result_37
    if state ~= nil then
        ____opt_result_37 = state["单位"]
    end
    local albedo = ____opt_result_37
    local source = context["目标单位"]
    if state == nil or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(albedo) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(source) then
        return
    end
    local facing = GetUnitFacing(albedo)
    local radians = facing * _____89D2_5EA6_8F6C_5F27_5EA6
    SetUnitPosition(
        source,
        GetUnitX(albedo) + Cos(radians) * 270,
        GetUnitY(albedo) + Sin(radians) * 270
    )
    SetUnitFacing(source, facing + 180)
    state["上次护卫反击Ms"] = 0
    if not _____91CA_653E_96C5_513F_8D1D_5FB7_62A4_536B_53CD_51FB(context["运行时"]) then
        return
    end
    local delayedId = addDelayedCallback(50, _____7ED3_7B97_96C5_513F_8D1D_5FB7_62A4_536B_53CD_51FB_53D7_51FB, {["来源单位"] = source, ["雅儿贝德单位"] = albedo})
    local ____self_38 = context["运行时"]["清理"]
    ____self_38["登记延迟回调"](____self_38, "安兹测试-护卫反击自动受击", delayedId)
end
local _____5B89_5179_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "现实断裂", ["执行"] = _____6D4B_8BD5_5B89_5179_73B0_5B9E_65AD_88C2},
    {["序号"] = 2, ["名称"] = "心脏掌握", ["执行"] = _____6D4B_8BD5_5B89_5179_5FC3_810F_638C_63E1},
    {["序号"] = 3, ["名称"] = "高阶魔法箭", ["执行"] = _____6D4B_8BD5_5B89_5179_9AD8_9636_9B54_6CD5_7BAD},
    {["序号"] = 4, ["名称"] = "光辉翠绿体", ["执行"] = _____6D4B_8BD5_5B89_5179_5149_8F89_7FE0_7EFF_4F53},
    {["序号"] = 5, ["名称"] = "时间停止", ["执行"] = _____6D4B_8BD5_5B89_5179_65F6_95F4_505C_6B62},
    {["序号"] = 6, ["名称"] = "高阶亡灵召唤", ["执行"] = _____6D4B_8BD5_5B89_5179_9AD8_9636_4EA1_7075_53EC_5524},
    {["序号"] = 7, ["名称"] = "天空坠落+护卫联动", ["执行"] = _____6D4B_8BD5_5B89_5179_5929_7A7A_5760_843D},
    {["序号"] = 8, ["名称"] = "一切生命的终点+锚点封锁", ["执行"] = _____6D4B_8BD5_5B89_5179_4E00_5207_751F_547D_7684_7EC8_70B9},
    {["序号"] = 9, ["名称"] = "启动护卫模式", ["执行"] = _____6D4B_8BD5_5B89_5179_62A4_536B_6A21_5F0F},
    {["序号"] = 10, ["名称"] = "雅儿贝德至尊拦截", ["执行"] = _____6D4B_8BD5_96C5_513F_8D1D_5FB7_81F3_5C0A_62E6_622A},
    {["序号"] = 11, ["名称"] = "雅儿贝德黑翼横扫", ["执行"] = _____6D4B_8BD5_96C5_513F_8D1D_5FB7_9ED1_7FFC_6A2A_626B},
    {["序号"] = 12, ["名称"] = "雅儿贝德守护者之职责", ["执行"] = _____6D4B_8BD5_96C5_513F_8D1D_5FB7_5B88_62A4_8005_4E4B_804C_8D23},
    {["序号"] = 121, ["命令"] = "12-1", ["名称"] = "守护者之职责（护卫开启后承受20%最大生命伤害）", ["执行"] = _____6D4B_8BD5_96C5_513F_8D1D_5FB7_5B88_62A4_8005_4E4B_804C_8D2320_767E_5206_6BD4_53D7_51FB},
    {["序号"] = 13, ["名称"] = "雅儿贝德守护回归", ["执行"] = _____6D4B_8BD5_96C5_513F_8D1D_5FB7_5B88_62A4_56DE_5F52},
    {["序号"] = 14, ["名称"] = "雅儿贝德护卫反击窗口", ["执行"] = _____6D4B_8BD5_96C5_513F_8D1D_5FB7_62A4_536B_53CD_51FB},
    {["序号"] = 142, ["命令"] = "14-2", ["名称"] = "护卫反击（正面270距离以无视护甲普攻触发4%最终伤害阈值）", ["执行"] = _____6D4B_8BD5_96C5_513F_8D1D_5FB7_62A4_536B_53CD_51FB_81EA_52A8_53D7_51FB}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "安兹乌尔恭",
    ["Boss名称"] = "安兹乌尔恭（护卫模式）",
    ["场地"] = {["正式中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}, ["测试空地中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}},
    ["创建或获取上下文"] = _____521B_5EFA_6216_83B7_53D6_5B89_5179_6D4B_8BD5_4E0A_4E0B_6587,
    ["清理上下文"] = _____6E05_7406_5B89_5179_6D4B_8BD5_4E0A_4E0B_6587,
    ["技能命令列表"] = _____5B89_5179_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
