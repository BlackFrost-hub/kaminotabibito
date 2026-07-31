--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stringToFourCC
function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_FixUnitStandingSafe = ____require_result_0.X_FixUnitStandingSafe
local ____require_result_1 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_1.SelectUnitForPlayerSingle
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_2.StarOther_PanCameraToTimedForPlayer
local ____require_result_3 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_3["应用Boss战启动属性配置"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587 = ____require_result_4["获取或创建米亚上下文"]
local _____6E05_7406_7C73_4E9A_4E0A_4E0B_6587 = ____require_result_4["清理米亚上下文"]
local _____6CE8_518C_7C73_4E9A_8FD0_884C_65F6 = ____require_result_4["注册米亚运行时"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_9636_6BB5_9608_503C = ____require_result_5["米亚阶段阈值"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_6["米亚单位技能配置"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.03．运行时上下文")
local _____7ED9_5355_4F4D_6DFB_52A0_7C73_4E9A_8150_5316_5C42_6570 = ____require_result_7["给单位添加米亚腐化层数"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.16．技能入口")
local _____6CE8_518C_7C73_4E9A_6280_80FD_7ED3_6784 = ____require_result_8["注册米亚技能结构"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.05．腐化爪击")
local _____91CA_653E_7C73_4E9A_8150_5316_722A_51FB = ____require_result_9["释放米亚腐化爪击"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.06．污水喷吐")
local _____91CA_653E_7C73_4E9A_6C61_6C34_55B7_5410 = ____require_result_10["释放米亚污水喷吐"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.07．灵猫分身")
local _____89E6_53D1_7C73_4E9A_7075_732B_5206_8EAB = ____require_result_11["触发米亚灵猫分身"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.08．污染标记")
local _____5237_65B0_7C73_4E9A_6C61_67D3_6807_8BB0 = ____require_result_12["刷新米亚污染标记"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.09．污染脉冲")
local _____91CA_653E_7C73_4E9A_6C61_67D3_8109_51B2 = ____require_result_13["释放米亚污染脉冲"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.10．污水柱爆发")
local _____91CA_653E_7C73_4E9A_6C61_6C34_67F1_7206_53D1 = ____require_result_14["释放米亚污水柱爆发"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.11．腐化转移")
local _____91CA_653E_7C73_4E9A_8150_5316_8F6C_79FB = ____require_result_15["释放米亚腐化转移"]
local ____require_result_16 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.12．平台超载惩罚")
local _____5237_65B0_7C73_4E9A_5E73_53F0_8D85_8F7D_60E9_7F5A = ____require_result_16["刷新米亚平台超载惩罚"]
local ____require_result_17 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.13．腐化黏液涂层")
local _____5237_65B0_7C73_4E9A_8150_5316_9ECF_6DB2_6D82_5C42_88AB_52A8_72B6_6001 = ____require_result_17["刷新米亚腐化黏液涂层被动状态"]
local _____91CA_653E_7C73_4E9A_5168_573A_8150_5316_9ECF_6DB2 = ____require_result_17["释放米亚全场腐化黏液"]
local ____require_result_18 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.14．终极污染")
local _____89E6_53D1_7C73_4E9A_7EC8_6781_6C61_67D3 = ____require_result_18["触发米亚终极污染"]
local ____require_result_19 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.01．场地配置")
local _____7C73_4E9A_9ED8_8BA4_5E73_53F0_4E2D_5FC3_914D_7F6E = ____require_result_19["米亚默认平台中心配置"]
local _____7C73_4E9A_9ED8_8BA4_5B89_5168_57DF_914D_7F6E_8868 = ____require_result_19["米亚默认安全域配置表"]
local _____8BBE_7F6E_7C73_4E9A_573A_5730_914D_7F6E = ____require_result_19["设置米亚场地配置"]
local _____91CD_7F6E_7C73_4E9A_573A_5730_914D_7F6E = ____require_result_19["重置米亚场地配置"]
local _____6E05_7406_7C73_4E9A_5B89_5168_57DF_77E9_5F62_7EC4 = ____require_result_19["清理米亚安全域矩形组"]
local ____require_result_20 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.01．场地配置")
local _____521B_5EFA_7C73_4E9A_5B89_5168_57DF_77E9_5F62_7EC4 = ____require_result_20["创建米亚安全域矩形组"]
local ____require_result_21 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04 = ____require_result_21["创建测试中心平移映射"]
local _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_77E9_5F62 = ____require_result_21["按测试映射平移矩形"]
local _____590D_5236_5E73_79FB_6D4B_8BD5_77E9_5F62_6570_7EC4 = ____require_result_21["复制平移测试矩形数组"]
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_21["标记测试Boss跳过死亡结算"]
local ____require_result_22 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_22.getServerTime
local ____require_result_23 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_23.addDelayedCallback
local ____require_result_24 = require("系统.05．Buff系统.00．Buff系统")
local getBuffRuntime = ____require_result_24.getBuffRuntime
local ____require_result_25 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_25["Boss测试单位存活"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_25["设置Boss测试单位满血"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_25["获取Boss测试玩家基准英雄"]
local _____521B_5EFABoss_6D4B_8BD5_4E34_65F6_6B65_5175 = ____require_result_25["创建Boss测试临时步兵"]
local ____Boss_6D4B_8BD5_56FA_5B9A_6B65_5175_6700_5927_751F_547D_503C = ____require_result_25["Boss测试固定步兵最大生命值"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_25["准备Boss测试固定步兵"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = ____require_result_25["准备Boss测试固定山丘之王"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_25["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_25["注册Boss测试命令组"]
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
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitState = jass.SetUnitState
local IssueTargetOrder = jass.IssueTargetOrder
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____6700_8FD1_6D4B_8BD5Boss = {}
local _____6700_8FD1_6D4B_8BD5_6B65_5175 = {}
local _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B = {}
local _____6700_8FD1_8150_5316_8F6C_79FB_6D4B_8BD5_6B65_5175 = {}
local _____6700_8FD1_5E73_53F0_8D85_8F7D_6D4B_8BD5_6B65_5175 = {}
local _____6700_8FD1_8150_5316_9ECF_6DB2_6D4B_8BD5_6B65_5175 = {}
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
local function _____53D6_7C73_4E9A_6D4B_8BD5_6700_5927_751F_547D(boss)
    local _____6700_5927_751F_547D_503C = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE)
    return _____6700_5927_751F_547D_503C or 0
end
local function _____8BBE_7F6E_7C73_4E9A_6D4B_8BD5_9636_6BB5(context, _____9636_6BB5)
    local ____temp_26
    if context ~= nil then
        ____temp_26 = context["Boss单位"]
    else
        ____temp_26 = nil
    end
    local boss = ____temp_26
    if context == nil or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return false
    end
    local _____6700_5927_751F_547D_503C = _____53D6_7C73_4E9A_6D4B_8BD5_6700_5927_751F_547D(boss)
    if not (_____6700_5927_751F_547D_503C > 0) then
        return false
    end
    local _____751F_547D_6BD4_4F8B = _____9636_6BB5 == 1 and 1 or (_____9636_6BB5 == 2 and (_____7C73_4E9A_9636_6BB5_9608_503C["第二阶段生命比例"] + _____7C73_4E9A_9636_6BB5_9608_503C["第三阶段生命比例"]) * 0.5 or _____7C73_4E9A_9636_6BB5_9608_503C["第三阶段生命比例"] * 0.5)
    SetUnitState(boss, UNIT_STATE_LIFE, _____6700_5927_751F_547D_503C * _____751F_547D_6BD4_4F8B)
    local _____9636_6BB5ID = _____9636_6BB5 == 1 and "P1" or (_____9636_6BB5 == 2 and "P2" or "P3")
    local _____9636_6BB5_4E0A_4E0B_6587 = context["阶段上下文"]
    if _____9636_6BB5_4E0A_4E0B_6587 == nil then
        return false
    end
    local _____624B_52A8_8FDB_5165_9636_6BB5_7ED3_679C = true
    if _____9636_6BB5_4E0A_4E0B_6587["取阶段ID"](_____9636_6BB5_4E0A_4E0B_6587) ~= _____9636_6BB5ID then
        _____624B_52A8_8FDB_5165_9636_6BB5_7ED3_679C = _____9636_6BB5_4E0A_4E0B_6587["手动进入阶段"](_____9636_6BB5_4E0A_4E0B_6587, _____9636_6BB5ID, _____751F_547D_6BD4_4F8B)
        if not _____624B_52A8_8FDB_5165_9636_6BB5_7ED3_679C and _____9636_6BB5_4E0A_4E0B_6587["取阶段ID"](_____9636_6BB5_4E0A_4E0B_6587) ~= _____9636_6BB5ID then
            return false
        end
    end
    context["阶段"] = _____9636_6BB5
    local _____5B9E_9645_9636_6BB5ID = _____9636_6BB5_4E0A_4E0B_6587["取阶段ID"](_____9636_6BB5_4E0A_4E0B_6587)
    return _____5B9E_9645_9636_6BB5ID == _____9636_6BB5ID
end
local function _____53D6_7C73_4E9A_8150_5316_8F6C_79FB_6D4B_8BD5_5E73_53F0(context)
    local ____temp_27
    if context ~= nil and context["安全域区域组"] ~= nil then
        ____temp_27 = context["安全域区域组"]["区域列表"]
    else
        ____temp_27 = nil
    end
    local _____533A_57DF_5217_8868 = ____temp_27
    if _____533A_57DF_5217_8868 == nil then
        return nil
    end
    return _____533A_57DF_5217_8868[1]
end
local function _____51C6_5907_7C73_4E9A_8150_5316_8F6C_79FB_6D4B_8BD5_6B65_5175(playerId, _____533A_57DF)
    local x = _____533A_57DF["中心X"]
    local y = _____533A_57DF["中心Y"]
    local target = _____6700_8FD1_8150_5316_8F6C_79FB_6D4B_8BD5_6B65_5175[playerId]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        target = _____521B_5EFABoss_6D4B_8BD5_4E34_65F6_6B65_5175(x, y, 90)
        _____6700_8FD1_8150_5316_8F6C_79FB_6D4B_8BD5_6B65_5175[playerId] = target
    else
        SetUnitPosition(target, x, y)
        SetUnitFacing(target, 90)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(target, ____Boss_6D4B_8BD5_56FA_5B9A_6B65_5175_6700_5927_751F_547D_503C)
        X_FixUnitStandingSafe(target)
    end
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        X_FixUnitStandingSafe(target)
    end
    return target
end
local function _____51C6_5907_7C73_4E9A_5E73_53F0_8D85_8F7D_6D4B_8BD5_6B65_5175(playerId, _____533A_57DF, _____76EE_6807_6570_91CF)
    local _____7ED3_679C = {}
    local _____7F13_5B58 = _____6700_8FD1_5E73_53F0_8D85_8F7D_6D4B_8BD5_6B65_5175[playerId] or ({})
    local _____504F_79FBX_5217_8868 = {-45, 0, 45}
    local _____6682_5B58X = _____4E34_65F6_6D4B_8BD5_73A9_5BB6X
    local _____6682_5B58Y = _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y - 220
    do
        local i = _____76EE_6807_6570_91CF
        while i < #_____7F13_5B58 do
            do
                local _____6682_5B58_6B65_5175 = _____7F13_5B58[i + 1]
                if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____6682_5B58_6B65_5175) then
                    goto __continue25
                end
                SetUnitPosition(_____6682_5B58_6B65_5175, _____6682_5B58X + i * 80, _____6682_5B58Y)
                SetUnitFacing(_____6682_5B58_6B65_5175, 90)
                _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(_____6682_5B58_6B65_5175, ____Boss_6D4B_8BD5_56FA_5B9A_6B65_5175_6700_5927_751F_547D_503C)
                X_FixUnitStandingSafe(_____6682_5B58_6B65_5175)
            end
            ::__continue25::
            i = i + 1
        end
    end
    do
        local i = 0
        while i < _____76EE_6807_6570_91CF do
            do
                local x = _____533A_57DF["中心X"] + _____504F_79FBX_5217_8868[i + 1]
                local y = _____533A_57DF["中心Y"]
                local _____6B65_5175 = _____7F13_5B58[i + 1]
                local _____65B0_521B_5EFA = not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____6B65_5175)
                if _____65B0_521B_5EFA then
                    _____6B65_5175 = _____521B_5EFABoss_6D4B_8BD5_4E34_65F6_6B65_5175(x, y, 90)
                    _____7F13_5B58[i + 1] = _____6B65_5175
                else
                    SetUnitPosition(_____6B65_5175, x, y)
                    SetUnitFacing(_____6B65_5175, 90)
                    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(_____6B65_5175, ____Boss_6D4B_8BD5_56FA_5B9A_6B65_5175_6700_5927_751F_547D_503C)
                end
                if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____6B65_5175) then
                    goto __continue28
                end
                X_FixUnitStandingSafe(_____6B65_5175)
                _____7ED3_679C[#_____7ED3_679C + 1] = _____6B65_5175
            end
            ::__continue28::
            i = i + 1
        end
    end
    _____6700_8FD1_5E73_53F0_8D85_8F7D_6D4B_8BD5_6B65_5175[playerId] = _____7F13_5B58
    return _____7ED3_679C
end
local function _____51C6_5907_7C73_4E9A_8150_5316_9ECF_6DB2_6D4B_8BD5_6B65_5175(playerId, boss)
    local x = GetUnitX(boss) + 120
    local y = GetUnitY(boss)
    local target = _____6700_8FD1_8150_5316_9ECF_6DB2_6D4B_8BD5_6B65_5175[playerId]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        target = _____521B_5EFABoss_6D4B_8BD5_4E34_65F6_6B65_5175(x, y, 180)
        _____6700_8FD1_8150_5316_9ECF_6DB2_6D4B_8BD5_6B65_5175[playerId] = target
    else
        SetUnitPosition(target, x, y)
        SetUnitFacing(target, 180)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(target, ____Boss_6D4B_8BD5_56FA_5B9A_6B65_5175_6700_5927_751F_547D_503C)
    end
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        X_FixUnitStandingSafe(target)
    end
    return target
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
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_8150_5316_9ECF_6DB2_6D4B_8BD5_6B65_5175[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(boss)
    _____6700_8FD1_6D4B_8BD5_6B65_5175[pid] = nil
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = nil
    _____6700_8FD1_6D4B_8BD5Boss[pid] = nil
    _____6700_8FD1_8150_5316_8F6C_79FB_6D4B_8BD5_6B65_5175[pid] = nil
    _____6700_8FD1_5E73_53F0_8D85_8F7D_6D4B_8BD5_6B65_5175[pid] = nil
    _____6700_8FD1_8150_5316_9ECF_6DB2_6D4B_8BD5_6B65_5175[pid] = nil
    if globals.udg_Boss == boss then
        globals.udg_Boss = nil
    end
end
local function ____on_7C73_4E9A_6280_80FD1_6D4B_8BD5_547D_4EE4(player, context)
    local target = _____6700_8FD1_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    local _____9636_6BB5_8BBE_7F6E_6210_529F = _____8BBE_7F6E_7C73_4E9A_6D4B_8BD5_9636_6BB5(context, 1)
    if not _____9636_6BB5_8BBE_7F6E_6210_529F then
        return
    end
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        return
    end
    _____91CA_653E_7C73_4E9A_8150_5316_722A_51FB(context, target)
end
local function ____on_7C73_4E9A_6280_80FD2_6D4B_8BD5_547D_4EE4(_player, context)
    if not _____8BBE_7F6E_7C73_4E9A_6D4B_8BD5_9636_6BB5(context, 1) then
        return
    end
    _____91CA_653E_7C73_4E9A_6C61_6C34_55B7_5410(context)
end
local function ____on_7C73_4E9A_6280_80FD3_6D4B_8BD5_547D_4EE4(_player, context)
    if not _____8BBE_7F6E_7C73_4E9A_6D4B_8BD5_9636_6BB5(context, 1) then
        return
    end
    context["已触发分身80"] = false
    local _____6700_5927_751F_547D_503C = _____53D6_7C73_4E9A_6D4B_8BD5_6700_5927_751F_547D(context["Boss单位"])
    if not (_____6700_5927_751F_547D_503C > 0) then
        return
    end
    SetUnitState(context["Boss单位"], UNIT_STATE_LIFE, _____6700_5927_751F_547D_503C * 0.75)
    _____89E6_53D1_7C73_4E9A_7075_732B_5206_8EAB(context)
end
local function ____on_7C73_4E9A_6280_80FD4_6D4B_8BD5_547D_4EE4(player, context)
    local _____9636_6BB5_8BBE_7F6E_6210_529F = _____8BBE_7F6E_7C73_4E9A_6D4B_8BD5_9636_6BB5(context, 1)
    if not _____9636_6BB5_8BBE_7F6E_6210_529F then
        return
    end
    local target = _____6700_8FD1_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        return
    end
    local nowMs = getServerTime()
    context["上次污染标记Ms"] = 0
    _____7ED9_5355_4F4D_6DFB_52A0_7C73_4E9A_8150_5316_5C42_6570(context, target, 5, "米亚测试污染标记")
    _____5237_65B0_7C73_4E9A_6C61_67D3_6807_8BB0(context, nowMs)
end
local function ____on_7C73_4E9A_6280_80FD5_6D4B_8BD5_547D_4EE4(_player, context)
    if not _____8BBE_7F6E_7C73_4E9A_6D4B_8BD5_9636_6BB5(context, 2) then
        return
    end
    _____91CA_653E_7C73_4E9A_6C61_67D3_8109_51B2(context)
end
local function _____7C73_4E9A_6280_80FD6_76EE_6807_89C2_5BDF_56DE_8C03(data)
    if data == nil or data["玩家"] == nil then
        return
    end
    local _____6B65_5175 = data["步兵"]
    local _____5C71_4E18_4E4B_738B = data["山丘之王"]
    local buffID = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E.BuffID["腐化感染"]
    local ____temp_30
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____6B65_5175) and getBuffRuntime(_____6B65_5175, buffID) ~= nil then
        ____temp_30 = _____6B65_5175
    else
        local ____temp_29
        if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____5C71_4E18_4E4B_738B) and getBuffRuntime(_____5C71_4E18_4E4B_738B, buffID) ~= nil then
            ____temp_29 = _____5C71_4E18_4E4B_738B
        else
            local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B_result_28
            if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____6B65_5175) then
                ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B_result_28 = _____6B65_5175
            else
                ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B_result_28 = _____5C71_4E18_4E4B_738B
            end
            ____temp_29 = ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B_result_28
        end
        ____temp_30 = ____temp_29
    end
    local _____76EE_6807 = ____temp_30
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____76EE_6807) then
        SelectUnitForPlayerSingle(_____76EE_6807, data["玩家"])
    end
end
local function ____on_7C73_4E9A_6280_80FD6_6D4B_8BD5_547D_4EE4(player, context)
    if not _____8BBE_7F6E_7C73_4E9A_6D4B_8BD5_9636_6BB5(context, 2) then
        return
    end
    local pid = GetPlayerId(player)
    local _____6B65_5175 = _____6700_8FD1_6D4B_8BD5_6B65_5175[pid]
    local _____5C71_4E18_4E4B_738B = _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid]
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____6B65_5175) then
        SelectUnitForPlayerSingle(_____6B65_5175, player)
    end
    local _____91CA_653E_6210_529F = _____91CA_653E_7C73_4E9A_6C61_6C34_67F1_7206_53D1(context)
    if not _____91CA_653E_6210_529F then
        return
    end
    local _____89C2_5BDF_56DE_8C03ID = addDelayedCallback(2200, _____7C73_4E9A_6280_80FD6_76EE_6807_89C2_5BDF_56DE_8C03, {["玩家"] = player, ["步兵"] = _____6B65_5175, ["山丘之王"] = _____5C71_4E18_4E4B_738B})
    local ____self_31 = context["清理"]
    ____self_31["登记延迟回调"](____self_31, "米亚测试-污水柱爆发目标观察", _____89C2_5BDF_56DE_8C03ID)
end
local function ____on_7C73_4E9A_6280_80FD7_6D4B_8BD5_547D_4EE4(_player, context)
    if not _____8BBE_7F6E_7C73_4E9A_6D4B_8BD5_9636_6BB5(context, 2) then
        return
    end
    context["腐化转移污染平台ID"] = ""
    _____91CA_653E_7C73_4E9A_8150_5316_8F6C_79FB(
        context,
        getServerTime()
    )
end
local function ____on_7C73_4E9A_6280_80FD7Test_6D4B_8BD5_547D_4EE4(player, context)
    if not _____8BBE_7F6E_7C73_4E9A_6D4B_8BD5_9636_6BB5(context, 2) then
        return
    end
    local pid = GetPlayerId(player)
    context["腐化转移污染平台ID"] = ""
    local _____533A_57DF = _____53D6_7C73_4E9A_8150_5316_8F6C_79FB_6D4B_8BD5_5E73_53F0(context)
    if _____533A_57DF == nil then
        return
    end
    local _____76EE_6807 = _____51C6_5907_7C73_4E9A_8150_5316_8F6C_79FB_6D4B_8BD5_6B65_5175(pid, _____533A_57DF)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____76EE_6807) then
        return
    end
    SelectUnitForPlayerSingle(_____76EE_6807, player)
    local nowMs = getServerTime()
    _____91CA_653E_7C73_4E9A_8150_5316_8F6C_79FB(context, nowMs, _____533A_57DF)
end
local function ____on_7C73_4E9A_6280_80FD8_6D4B_8BD5_547D_4EE4(player, context)
    if not _____8BBE_7F6E_7C73_4E9A_6D4B_8BD5_9636_6BB5(context, 2) then
        return
    end
    local pid = GetPlayerId(player)
    context["平台超载测试容量覆盖"] = nil
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
local function _____7C73_4E9A_5E73_53F0_8D85_8F7D_5B8C_6574_6D4B_8BD5_89C2_5BDF_56DE_8C03(data)
    if data == nil or data["玩家"] == nil then
        return
    end
    local targets = data["目标列表"]
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(targets[1]) then
        SelectUnitForPlayerSingle(targets[1], data["玩家"])
    end
end
local function _____6267_884C_7C73_4E9A_5E73_53F0_8D85_8F7D_5B8C_6574_6D4B_8BD5(player, context, _____6D4B_8BD5_5BB9_91CF)
    if not _____8BBE_7F6E_7C73_4E9A_6D4B_8BD5_9636_6BB5(context, 2) then
        return
    end
    local pid = GetPlayerId(player)
    local _____533A_57DF = _____53D6_7C73_4E9A_8150_5316_8F6C_79FB_6D4B_8BD5_5E73_53F0(context)
    if _____533A_57DF == nil then
        return
    end
    local _____76EE_6807_6570_91CF = _____6D4B_8BD5_5BB9_91CF + 1
    local _____76EE_6807_5217_8868 = _____51C6_5907_7C73_4E9A_5E73_53F0_8D85_8F7D_6D4B_8BD5_6B65_5175(pid, _____533A_57DF, _____76EE_6807_6570_91CF)
    if #_____76EE_6807_5217_8868 < _____76EE_6807_6570_91CF then
        return
    end
    context["平台超载测试容量覆盖"] = _____6D4B_8BD5_5BB9_91CF
    context["上次平台超载检测Ms"] = 0
    SelectUnitForPlayerSingle(_____76EE_6807_5217_8868[1], player)
    local nowMs = getServerTime()
    _____5237_65B0_7C73_4E9A_5E73_53F0_8D85_8F7D_60E9_7F5A(context, nowMs)
    local _____89C2_5BDF_56DE_8C03ID = addDelayedCallback(1200, _____7C73_4E9A_5E73_53F0_8D85_8F7D_5B8C_6574_6D4B_8BD5_89C2_5BDF_56DE_8C03, {["玩家"] = player, ["目标列表"] = _____76EE_6807_5217_8868})
    local ____self_32 = context["清理"]
    ____self_32["登记延迟回调"](____self_32, "米亚测试-平台超载完整观察", _____89C2_5BDF_56DE_8C03ID)
end
local function ____on_7C73_4E9A_6280_80FD8_5355_53CC_4EBA_5B8C_6574_6D4B_8BD5_547D_4EE4(player, context)
    _____6267_884C_7C73_4E9A_5E73_53F0_8D85_8F7D_5B8C_6574_6D4B_8BD5(player, context, 1)
end
local function ____on_7C73_4E9A_6280_80FD8_4E09_56DB_4EBA_5B8C_6574_6D4B_8BD5_547D_4EE4(player, context)
    _____6267_884C_7C73_4E9A_5E73_53F0_8D85_8F7D_5B8C_6574_6D4B_8BD5(player, context, 2)
end
local function ____on_7C73_4E9A_6280_80FD9_6D4B_8BD5_547D_4EE4(player, context)
    if not _____8BBE_7F6E_7C73_4E9A_6D4B_8BD5_9636_6BB5(context, 3) then
        return
    end
    _____5237_65B0_7C73_4E9A_8150_5316_9ECF_6DB2_6D82_5C42_88AB_52A8_72B6_6001(context)
    _____91CA_653E_7C73_4E9A_5168_573A_8150_5316_9ECF_6DB2(context)
end
local function ____on_7C73_4E9A_6280_80FD9_8FD1_6218_53CD_566C_6D4B_8BD5_547D_4EE4(player, context)
    if not _____8BBE_7F6E_7C73_4E9A_6D4B_8BD5_9636_6BB5(context, 3) then
        return
    end
    local boss = context["Boss单位"]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return
    end
    _____5237_65B0_7C73_4E9A_8150_5316_9ECF_6DB2_6D82_5C42_88AB_52A8_72B6_6001(context)
    local target = _____51C6_5907_7C73_4E9A_8150_5316_9ECF_6DB2_6D4B_8BD5_6B65_5175(
        GetPlayerId(player),
        boss
    )
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        return
    end
    IssueTargetOrder(target, "attack", boss)
    SelectUnitForPlayerSingle(target, player)
end
local function ____on_7C73_4E9A_6280_80FD10_6D4B_8BD5_547D_4EE4(_player, context)
    if not _____8BBE_7F6E_7C73_4E9A_6D4B_8BD5_9636_6BB5(context, 3) then
        return
    end
    context["终极污染引导中"] = false
    context["已触发终极污染30"] = false
    local _____6700_5927_751F_547D_503C = _____53D6_7C73_4E9A_6D4B_8BD5_6700_5927_751F_547D(context["Boss单位"])
    if not (_____6700_5927_751F_547D_503C > 0) then
        return
    end
    SetUnitState(context["Boss单位"], UNIT_STATE_LIFE, _____6700_5927_751F_547D_503C * 0.25)
    _____89E6_53D1_7C73_4E9A_7EC8_6781_6C61_67D3(context, 0)
end
local _____7C73_4E9A_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "腐化爪击（P1基础）", ["执行"] = ____on_7C73_4E9A_6280_80FD1_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["名称"] = "污水喷吐（P1基础）", ["执行"] = ____on_7C73_4E9A_6280_80FD2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 3, ["名称"] = "灵猫分身（P1阶段阈值）", ["执行"] = ____on_7C73_4E9A_6280_80FD3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 4, ["名称"] = "污染标记（P1被动）", ["执行"] = ____on_7C73_4E9A_6280_80FD4_6D4B_8BD5_547D_4EE4},
    {["序号"] = 5, ["名称"] = "污染脉冲（P2阶段）", ["执行"] = ____on_7C73_4E9A_6280_80FD5_6D4B_8BD5_547D_4EE4},
    {["序号"] = 6, ["名称"] = "污水柱爆发（P2阶段）", ["执行"] = ____on_7C73_4E9A_6280_80FD6_6D4B_8BD5_547D_4EE4},
    {["序号"] = 7, ["名称"] = "腐化转移（P2阶段）", ["执行"] = ____on_7C73_4E9A_6280_80FD7_6D4B_8BD5_547D_4EE4},
    {["序号"] = 7, ["命令"] = "7-test", ["名称"] = "腐化转移（目标平台站桩步兵测试）", ["执行"] = ____on_7C73_4E9A_6280_80FD7Test_6D4B_8BD5_547D_4EE4},
    {["序号"] = 8, ["名称"] = "平台超载（P2阶段）", ["执行"] = ____on_7C73_4E9A_6280_80FD8_6D4B_8BD5_547D_4EE4},
    {["序号"] = 8, ["命令"] = "8-1-2", ["名称"] = "平台超载（1-2人容量完整测试）", ["执行"] = ____on_7C73_4E9A_6280_80FD8_5355_53CC_4EBA_5B8C_6574_6D4B_8BD5_547D_4EE4},
    {["序号"] = 8, ["命令"] = "8-3-4", ["名称"] = "平台超载（3-4人容量完整测试）", ["执行"] = ____on_7C73_4E9A_6280_80FD8_4E09_56DB_4EBA_5B8C_6574_6D4B_8BD5_547D_4EE4},
    {["序号"] = 9, ["名称"] = "腐化黏液涂层（P3强化）", ["执行"] = ____on_7C73_4E9A_6280_80FD9_6D4B_8BD5_547D_4EE4},
    {["序号"] = 9, ["命令"] = "9-1", ["名称"] = "腐化黏液涂层（近战反噬测试）", ["执行"] = ____on_7C73_4E9A_6280_80FD9_8FD1_6218_53CD_566C_6D4B_8BD5_547D_4EE4},
    {["序号"] = 10, ["名称"] = "终极污染（P3阶段）", ["执行"] = ____on_7C73_4E9A_6280_80FD10_6D4B_8BD5_547D_4EE4}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "米亚",
    ["Boss名称"] = "米亚",
    ["创建或获取上下文"] = _____521B_5EFA_5E76_521D_59CB_5316_7C73_4E9A_6D4B_8BD5,
    ["清理上下文"] = _____6E05_7406_7C73_4E9A_6D4B_8BD5,
    ["技能命令列表"] = _____7C73_4E9A_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
