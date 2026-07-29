--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stringToFourCC
function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
local jass = require("jass.common")
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_0.SelectUnitForPlayerSingle
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_1.StarOther_PanCameraToTimedForPlayer
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_2["应用Boss战启动属性配置"]
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587 = ____require_result_3["获取或创建米亚上下文"]
local _____6E05_7406_7C73_4E9A_4E0A_4E0B_6587 = ____require_result_3["清理米亚上下文"]
local _____6CE8_518C_7C73_4E9A_8FD0_884C_65F6 = ____require_result_3["注册米亚运行时"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.03．运行时上下文")
local _____7ED9_5355_4F4D_6DFB_52A0_7C73_4E9A_8150_5316_5C42_6570 = ____require_result_4["给单位添加米亚腐化层数"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.16．技能入口")
local _____6CE8_518C_7C73_4E9A_6280_80FD_7ED3_6784 = ____require_result_5["注册米亚技能结构"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.05．腐化爪击")
local _____91CA_653E_7C73_4E9A_8150_5316_722A_51FB = ____require_result_6["释放米亚腐化爪击"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.06．污水喷吐")
local _____91CA_653E_7C73_4E9A_6C61_6C34_55B7_5410 = ____require_result_7["释放米亚污水喷吐"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.07．灵猫分身")
local _____89E6_53D1_7C73_4E9A_7075_732B_5206_8EAB = ____require_result_8["触发米亚灵猫分身"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.08．污染标记")
local _____5237_65B0_7C73_4E9A_6C61_67D3_6807_8BB0 = ____require_result_9["刷新米亚污染标记"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.09．污染脉冲")
local _____91CA_653E_7C73_4E9A_6C61_67D3_8109_51B2 = ____require_result_10["释放米亚污染脉冲"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.10．污水柱爆发")
local _____91CA_653E_7C73_4E9A_6C61_6C34_67F1_7206_53D1 = ____require_result_11["释放米亚污水柱爆发"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.11．腐化转移")
local _____91CA_653E_7C73_4E9A_8150_5316_8F6C_79FB = ____require_result_12["释放米亚腐化转移"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.12．平台超载惩罚")
local _____5237_65B0_7C73_4E9A_5E73_53F0_8D85_8F7D_60E9_7F5A = ____require_result_13["刷新米亚平台超载惩罚"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.13．腐化黏液涂层")
local _____5237_65B0_7C73_4E9A_8150_5316_9ECF_6DB2_6D82_5C42_88AB_52A8_72B6_6001 = ____require_result_14["刷新米亚腐化黏液涂层被动状态"]
local _____91CA_653E_7C73_4E9A_5168_573A_8150_5316_9ECF_6DB2 = ____require_result_14["释放米亚全场腐化黏液"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.14．终极污染")
local _____89E6_53D1_7C73_4E9A_7EC8_6781_6C61_67D3 = ____require_result_15["触发米亚终极污染"]
local ____require_result_16 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.01．场地配置")
local _____7C73_4E9A_9ED8_8BA4_5E73_53F0_4E2D_5FC3_914D_7F6E = ____require_result_16["米亚默认平台中心配置"]
local _____7C73_4E9A_9ED8_8BA4_5B89_5168_57DF_914D_7F6E_8868 = ____require_result_16["米亚默认安全域配置表"]
local _____8BBE_7F6E_7C73_4E9A_573A_5730_914D_7F6E = ____require_result_16["设置米亚场地配置"]
local _____91CD_7F6E_7C73_4E9A_573A_5730_914D_7F6E = ____require_result_16["重置米亚场地配置"]
local _____6E05_7406_7C73_4E9A_5B89_5168_57DF_77E9_5F62_7EC4 = ____require_result_16["清理米亚安全域矩形组"]
local ____require_result_17 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.01．场地配置")
local _____521B_5EFA_7C73_4E9A_5B89_5168_57DF_77E9_5F62_7EC4 = ____require_result_17["创建米亚安全域矩形组"]
local ____require_result_18 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04 = ____require_result_18["创建测试中心平移映射"]
local _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_77E9_5F62 = ____require_result_18["按测试映射平移矩形"]
local _____590D_5236_5E73_79FB_6D4B_8BD5_77E9_5F62_6570_7EC4 = ____require_result_18["复制平移测试矩形数组"]
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_18["标记测试Boss跳过死亡结算"]
local ____require_result_19 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_19.getServerTime
local ____require_result_20 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_20["Boss测试单位存活"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_20["设置Boss测试单位满血"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_20["获取Boss测试玩家基准英雄"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_20["准备Boss测试固定步兵"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = ____require_result_20["准备Boss测试固定山丘之王"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_20["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_20["注册Boss测试命令组"]
local _____7C73_4E9A_5355_4F4DID = stringToFourCC("N00V")
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X = -540.6
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y = -2495.2
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6X = -540.6
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y = -3055.2
local CreateUnit = jass.CreateUnit
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local GetPlayerId = jass.GetPlayerId
local SetUnitState = jass.SetUnitState
local GetUnitState = jass.GetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____6700_8FD1_6D4B_8BD5Boss = {}
local _____6700_8FD1_6D4B_8BD5_6B65_5175 = {}
local _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B = {}
local function _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    local pid = GetPlayerId(player)
    local cached = _____6700_8FD1_6D4B_8BD5Boss[pid]
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
        _____7C73_4E9A_5355_4F4DID,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y,
        270
    )
    if boss ~= nil and boss ~= 0 then
        _____6700_8FD1_6D4B_8BD5Boss[pid] = boss
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
        SetHeroLevel(boss, 40, false)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
        globals.udg_Boss = boss
    end
    return boss
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
    local pid = GetPlayerId(player)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    _____6700_8FD1_6D4B_8BD5_6B65_5175[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_5175[pid], _____4E34_65F6_6D4B_8BD5_73A9_5BB6X - 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 220, 90)
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid], _____4E34_65F6_6D4B_8BD5_73A9_5BB6X + 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 220, 90)
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
end
local function _____521B_5EFA_5E76_521D_59CB_5316_7C73_4E9A_6D4B_8BD5(player)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(hero) then
        return nil
    end
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    local context = _____51C6_5907_7C73_4E9A_6D4B_8BD5_573A_666F(player, hero, boss)
    if context == nil then
        return nil
    end
    _____521D_59CB_5316_7C73_4E9A_6D4B_8BD5_4E0A_4E0B_6587(context)
    return context
end
local function _____6E05_7406_7C73_4E9A_6D4B_8BD5(player, _context)
    local pid = GetPlayerId(player)
    local boss = _____6700_8FD1_6D4B_8BD5Boss[pid]
    if boss ~= nil and boss ~= 0 then
        _____6E05_7406_7C73_4E9A_4E0A_4E0B_6587(boss)
    end
    _____91CD_7F6E_7C73_4E9A_573A_5730_914D_7F6E()
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_6B65_5175[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(boss)
    _____6700_8FD1_6D4B_8BD5_6B65_5175[pid] = nil
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = nil
    _____6700_8FD1_6D4B_8BD5Boss[pid] = nil
    if globals.udg_Boss == boss then
        globals.udg_Boss = nil
    end
end
local function ____on_7C73_4E9A_6280_80FD1_6D4B_8BD5_547D_4EE4(player, context)
    local target = _____6700_8FD1_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        _____91CA_653E_7C73_4E9A_8150_5316_722A_51FB(context, target)
    end
end
local function ____on_7C73_4E9A_6280_80FD2_6D4B_8BD5_547D_4EE4(_player, context)
    _____91CA_653E_7C73_4E9A_6C61_6C34_55B7_5410(context)
end
local function ____on_7C73_4E9A_6280_80FD3_6D4B_8BD5_547D_4EE4(_player, context)
    context["阶段"] = 1
    context["已触发分身80"] = false
    SetUnitState(
        context["Boss单位"],
        UNIT_STATE_LIFE,
        GetUnitState(context["Boss单位"], UNIT_STATE_MAX_LIFE) * 0.75
    )
    _____89E6_53D1_7C73_4E9A_7075_732B_5206_8EAB(context)
end
local function ____on_7C73_4E9A_6280_80FD4_6D4B_8BD5_547D_4EE4(player, context)
    local target = _____6700_8FD1_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        return
    end
    local nowMs = getServerTime()
    context["阶段"] = 1
    context["上次污染标记Ms"] = 0
    _____7ED9_5355_4F4D_6DFB_52A0_7C73_4E9A_8150_5316_5C42_6570(context, target, 5, "米亚测试污染标记")
    _____5237_65B0_7C73_4E9A_6C61_67D3_6807_8BB0(context, nowMs)
end
local function ____on_7C73_4E9A_6280_80FD5_6D4B_8BD5_547D_4EE4(_player, context)
    context["阶段"] = 2
    _____91CA_653E_7C73_4E9A_6C61_67D3_8109_51B2(context)
end
local function ____on_7C73_4E9A_6280_80FD6_6D4B_8BD5_547D_4EE4(_player, context)
    context["阶段"] = 2
    _____91CA_653E_7C73_4E9A_6C61_6C34_67F1_7206_53D1(context)
end
local function ____on_7C73_4E9A_6280_80FD7_6D4B_8BD5_547D_4EE4(_player, context)
    context["阶段"] = 2
    context["腐化转移污染平台ID"] = ""
    _____91CA_653E_7C73_4E9A_8150_5316_8F6C_79FB(
        context,
        getServerTime()
    )
end
local function ____on_7C73_4E9A_6280_80FD8_6D4B_8BD5_547D_4EE4(player, context)
    local pid = GetPlayerId(player)
    context["阶段"] = 2
    context["上次平台超载检测Ms"] = 0
    local _____533A_57DF = context["安全域区域组"]["区域列表"][1]
    if _____533A_57DF ~= nil then
        SetUnitPosition(_____6700_8FD1_6D4B_8BD5_6B65_5175[pid], _____533A_57DF["中心X"] - 45, _____533A_57DF["中心Y"])
        SetUnitPosition(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid], _____533A_57DF["中心X"] + 45, _____533A_57DF["中心Y"])
    end
    _____5237_65B0_7C73_4E9A_5E73_53F0_8D85_8F7D_60E9_7F5A(
        context,
        getServerTime()
    )
end
local function ____on_7C73_4E9A_6280_80FD9_6D4B_8BD5_547D_4EE4(_player, context)
    context["阶段"] = 3
    _____5237_65B0_7C73_4E9A_8150_5316_9ECF_6DB2_6D82_5C42_88AB_52A8_72B6_6001(context)
    _____91CA_653E_7C73_4E9A_5168_573A_8150_5316_9ECF_6DB2(context)
end
local function ____on_7C73_4E9A_6280_80FD10_6D4B_8BD5_547D_4EE4(_player, context)
    context["阶段"] = 3
    context["终极污染引导中"] = false
    context["已触发终极污染30"] = false
    SetUnitState(
        context["Boss单位"],
        UNIT_STATE_LIFE,
        GetUnitState(context["Boss单位"], UNIT_STATE_MAX_LIFE) * 0.25
    )
    _____89E6_53D1_7C73_4E9A_7EC8_6781_6C61_67D3(context, 0)
end
local _____7C73_4E9A_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "腐化爪击", ["执行"] = ____on_7C73_4E9A_6280_80FD1_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["名称"] = "污水喷吐", ["执行"] = ____on_7C73_4E9A_6280_80FD2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 3, ["名称"] = "灵猫分身", ["执行"] = ____on_7C73_4E9A_6280_80FD3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 4, ["名称"] = "污染标记", ["执行"] = ____on_7C73_4E9A_6280_80FD4_6D4B_8BD5_547D_4EE4},
    {["序号"] = 5, ["名称"] = "污染脉冲", ["执行"] = ____on_7C73_4E9A_6280_80FD5_6D4B_8BD5_547D_4EE4},
    {["序号"] = 6, ["名称"] = "污水柱爆发", ["执行"] = ____on_7C73_4E9A_6280_80FD6_6D4B_8BD5_547D_4EE4},
    {["序号"] = 7, ["名称"] = "腐化转移", ["执行"] = ____on_7C73_4E9A_6280_80FD7_6D4B_8BD5_547D_4EE4},
    {["序号"] = 8, ["名称"] = "平台超载", ["执行"] = ____on_7C73_4E9A_6280_80FD8_6D4B_8BD5_547D_4EE4},
    {["序号"] = 9, ["名称"] = "腐化黏液涂层", ["执行"] = ____on_7C73_4E9A_6280_80FD9_6D4B_8BD5_547D_4EE4},
    {["序号"] = 10, ["名称"] = "终极污染", ["执行"] = ____on_7C73_4E9A_6280_80FD10_6D4B_8BD5_547D_4EE4}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "米亚",
    ["Boss名称"] = "米亚",
    ["创建或获取上下文"] = _____521B_5EFA_5E76_521D_59CB_5316_7C73_4E9A_6D4B_8BD5,
    ["清理上下文"] = _____6E05_7406_7C73_4E9A_6D4B_8BD5,
    ["技能命令列表"] = _____7C73_4E9A_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
