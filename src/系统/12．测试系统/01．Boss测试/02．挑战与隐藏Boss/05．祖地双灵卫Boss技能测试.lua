--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
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
local ____require_result_6 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文")
local _____521B_5EFABoss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_6["创建Boss战运行上下文"]
local _____8BB0_5F55Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_6["记录Boss战运行上下文"]
local _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_6["读取Boss战运行上下文"]
local _____6E05_7406Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_6["清理Boss战运行上下文"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.00．配置")
local _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_7["祖地双灵卫单位技能配置"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.11．被动效果")
local _____6CE8_518C_7956_5730_53CC_7075_536B_88AB_52A8_6548_679C = ____require_result_8["注册祖地双灵卫被动效果"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587 = ____require_result_9["获取或创建祖地双灵卫运行时上下文"]
local _____6E05_7406_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587 = ____require_result_9["清理祖地双灵卫运行时上下文"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.05．侵蚀择形")
local _____66F4_65B0_7956_5730_53CC_7075_536B_4FB5_8680_9636_6BB5 = ____require_result_10["更新祖地双灵卫侵蚀阶段"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.03．双灵同誓")
local _____66F4_65B0_7956_5730_53CC_7075_540C_8A93 = ____require_result_11["更新祖地双灵同誓"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．赤誓灵卫.01．灵印折步")
local _____91CA_653E_7075_5370_6298_6B65 = ____require_result_12["释放灵印折步"]
local _____521B_5EFA_8D64_8A93_9547_9B42_5370 = ____require_result_12["创建赤誓镇魂印"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．赤誓灵卫.02．月纹缚魂")
local _____91CA_653E_6708_7EB9_7F1A_9B42 = ____require_result_13["释放月纹缚魂"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．赤誓灵卫.03．断誓践踏")
local _____91CA_653E_65AD_8A93_8DF5_8E0F = ____require_result_14["释放断誓践踏"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．赤誓灵卫.04．裂魂坠斩")
local _____91CA_653E_88C2_9B42_5760_65A9 = ____require_result_15["释放裂魂坠斩"]
local ____require_result_16 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．苍影灵卫.01．誓锋壁进")
local _____91CA_653E_8A93_950B_58C1_8FDB = ____require_result_16["释放誓锋壁进"]
local ____require_result_17 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．苍影灵卫.02．盾刃裁决")
local _____91CA_653E_76FE_5203_88C1_51B3 = ____require_result_17["释放盾刃裁决"]
local ____require_result_18 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．苍影灵卫.03．失名祷潮")
local _____91CA_653E_5931_540D_7977_6F6E = ____require_result_18["释放失名祷潮"]
local ____require_result_19 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．苍影灵卫.04．记忆剥落")
local _____91CA_653E_8BB0_5FC6_5265_843D = ____require_result_19["释放记忆剥落"]
local ____require_result_20 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.06．封门校验")
local _____91CA_653E_7956_5730_53CC_7075_536B_5C01_95E8_6821_9A8C = ____require_result_20["释放祖地双灵卫封门校验"]
local ____require_result_21 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.08．封门误判")
local _____91CA_653E_7956_5730_53CC_7075_536B_5C01_95E8_8BEF_5224 = ____require_result_21["释放祖地双灵卫封门误判"]
local CreateUnit = jass.CreateUnit
local GetPlayerId = jass.GetPlayerId
local GetUnitState = jass.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitState = jass.SetUnitState
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local SetUnitScale = jass.SetUnitScale
local UnitDamageTarget = jass.UnitDamageTarget
local Rect = jass.Rect
local RemoveRect = jass.RemoveRect
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local DzSetUnitModel = japi.DzSetUnitModel
local _____8D64_8A93_7075_536B_5355_4F4DID = stringToFourCCSafe(_____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["赤誓灵卫"]["单位ID"])
local _____82CD_5F71_7075_536B_5355_4F4DID = stringToFourCCSafe(_____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["苍影灵卫"]["单位ID"])
local _____6D4B_8BD5_4E2D_5FC3X = -540.6
local _____6D4B_8BD5_4E2D_5FC3Y = -2495.2
local _____73A9_5BB6_6D4B_8BD5X = -540.6
local _____73A9_5BB6_6D4B_8BD5Y = -3055.2
local _____53CC_7075_6D4B_8BD5_534A_5BBD = 1000
local _____53CC_7075_6D4B_8BD5_534A_9AD8 = 850
local _____6700_8FD1_8D64_8A93_7075_536B = {}
local _____6700_8FD1_82CD_5F71_7075_536B = {}
local _____6700_8FD1_6D4B_8BD5_6B65_5175 = {}
local _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B = {}
local _____53CC_7075_6D4B_8BD5_77E9_5F62 = {}
local function _____83B7_53D6_6216_521B_5EFA_53CC_7075_6D4B_8BD5_77E9_5F62(player)
    local pid = GetPlayerId(player)
    local rect = _____53CC_7075_6D4B_8BD5_77E9_5F62[pid]
    if rect == nil or rect == 0 then
        rect = Rect(_____6D4B_8BD5_4E2D_5FC3X - _____53CC_7075_6D4B_8BD5_534A_5BBD, _____6D4B_8BD5_4E2D_5FC3Y - _____53CC_7075_6D4B_8BD5_534A_9AD8, _____6D4B_8BD5_4E2D_5FC3X + _____53CC_7075_6D4B_8BD5_534A_5BBD, _____6D4B_8BD5_4E2D_5FC3Y + _____53CC_7075_6D4B_8BD5_534A_9AD8)
        _____53CC_7075_6D4B_8BD5_77E9_5F62[pid] = rect
    end
    return rect
end
local function _____83B7_53D6_6216_521B_5EFA_53CC_7075_6D4B_8BD5Boss(player)
    local pid = GetPlayerId(player)
    local red = _____6700_8FD1_8D64_8A93_7075_536B[pid]
    local azure = _____6700_8FD1_82CD_5F71_7075_536B[pid]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(red) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(azure) then
        _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(red)
        _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(azure)
        red = CreateUnit(
            player,
            _____8D64_8A93_7075_536B_5355_4F4DID,
            _____6D4B_8BD5_4E2D_5FC3X - 320,
            _____6D4B_8BD5_4E2D_5FC3Y,
            270
        )
        azure = CreateUnit(
            player,
            _____82CD_5F71_7075_536B_5355_4F4DID,
            _____6D4B_8BD5_4E2D_5FC3X + 320,
            _____6D4B_8BD5_4E2D_5FC3Y,
            270
        )
        _____6700_8FD1_8D64_8A93_7075_536B[pid] = red
        _____6700_8FD1_82CD_5F71_7075_536B[pid] = azure
        if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(red) then
            SetHeroLevel(red, 45, false)
        end
        if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(azure) then
            SetHeroLevel(azure, 45, false)
        end
    end
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(red) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(azure) then
        return nil
    end
    SetUnitPosition(red, _____6D4B_8BD5_4E2D_5FC3X - 320, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitPosition(azure, _____6D4B_8BD5_4E2D_5FC3X + 320, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitFacing(red, 270)
    SetUnitFacing(azure, 270)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(red)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(azure)
    _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(red)
    _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(azure)
    globals.udg_Boss = red
    return {red = red, azure = azure}
end
local function _____83B7_53D6_6216_521B_5EFA_53CC_7075_6D4B_8BD5_6B65_5175(cache, player, x, y)
    local pid = GetPlayerId(player)
    local unit = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(cache[pid], x, y, 90)
    cache[pid] = unit
    return unit
end
local function _____786E_4FDD_53CC_7075_6D4B_8BD5_6218_6597_77E9_5F62(player, unit)
    if _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587(unit) ~= nil then
        return
    end
    local battle = _____521B_5EFABoss_6218_8FD0_884C_4E0A_4E0B_6587(
        unit,
        _____83B7_53D6_6216_521B_5EFA_53CC_7075_6D4B_8BD5_77E9_5F62(player),
        nil,
        nil
    )
    if battle ~= nil then
        _____8BB0_5F55Boss_6218_8FD0_884C_4E0A_4E0B_6587(battle)
    end
end
local function _____521B_5EFA_6216_83B7_53D6_7956_5730_53CC_7075_536B_6D4B_8BD5_4E0A_4E0B_6587(player)
    local pid = GetPlayerId(player)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    local pair = _____83B7_53D6_6216_521B_5EFA_53CC_7075_6D4B_8BD5Boss(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(hero) or pair == nil then
        return nil
    end
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    local target = _____83B7_53D6_6216_521B_5EFA_53CC_7075_6D4B_8BD5_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_5175, player, _____73A9_5BB6_6D4B_8BD5X - 220, _____73A9_5BB6_6D4B_8BD5Y + 180)
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid], _____73A9_5BB6_6D4B_8BD5X + 220, _____73A9_5BB6_6D4B_8BD5Y + 180, 90)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        return nil
    end
    _____6CE8_518C_7956_5730_53CC_7075_536B_88AB_52A8_6548_679C()
    _____786E_4FDD_53CC_7075_6D4B_8BD5_6218_6597_77E9_5F62(player, pair.red)
    _____786E_4FDD_53CC_7075_6D4B_8BD5_6218_6597_77E9_5F62(player, pair.azure)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(pair.red)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(pair.azure)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(pair.red)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(pair.azure)
    local runtime = _____83B7_53D6_6216_521B_5EFA_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587(pair.red)
    if runtime == nil then
        return nil
    end
    SelectUnitForPlayerSingle(pair.red, player)
    StarOther_PanCameraToTimedForPlayer(player, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y, 0.2)
    return {["运行时"] = runtime, ["目标单位"] = target, ["赤誓灵卫单位"] = pair.red, ["苍影灵卫单位"] = pair.azure}
end
local function _____6E05_7406_7956_5730_53CC_7075_536B_6D4B_8BD5_4E0A_4E0B_6587(player, context)
    local pid = GetPlayerId(player)
    if context ~= nil then
        if context["运行时"] ~= nil then
            _____6E05_7406_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587(context["运行时"])
        end
        _____6E05_7406Boss_6218_8FD0_884C_4E0A_4E0B_6587(context["赤誓灵卫单位"])
        _____6E05_7406Boss_6218_8FD0_884C_4E0A_4E0B_6587(context["苍影灵卫单位"])
    end
    local rect = _____53CC_7075_6D4B_8BD5_77E9_5F62[pid]
    if rect ~= nil and rect ~= 0 then
        RemoveRect(rect)
    end
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_6B65_5175[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_8D64_8A93_7075_536B[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_82CD_5F71_7075_536B[pid])
    _____53CC_7075_6D4B_8BD5_77E9_5F62[pid] = nil
    _____6700_8FD1_6D4B_8BD5_6B65_5175[pid] = nil
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = nil
    _____6700_8FD1_8D64_8A93_7075_536B[pid] = nil
    _____6700_8FD1_82CD_5F71_7075_536B[pid] = nil
    if globals.udg_Boss == (context and context["赤誓灵卫单位"]) then
        globals.udg_Boss = nil
    end
end
local function _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    local runtime = context["运行时"]
    local cfg = _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]
    runtime["阶段"] = "P1双灵守门"
    runtime["赤誓灵卫形态"] = "正常"
    runtime["苍影灵卫形态"] = "正常"
    runtime["首次变异守卫"] = nil
    runtime["大型技能占用者"] = nil
    runtime["大型机制忙碌到Ms"] = 0
    runtime["当前净化节点序号"] = 0
    runtime["已净化节点数量"] = 0
    runtime["封门误判待触发"] = false
    DzSetUnitModel(context["赤誓灵卫单位"], cfg["赤誓灵卫"]["正常模型路径"])
    DzSetUnitModel(context["苍影灵卫单位"], cfg["苍影灵卫"]["正常模型路径"])
    SetUnitScale(context["赤誓灵卫单位"], cfg["赤誓灵卫"]["正常模型缩放"], cfg["赤誓灵卫"]["正常模型缩放"], cfg["赤誓灵卫"]["正常模型缩放"])
    SetUnitScale(context["苍影灵卫单位"], cfg["苍影灵卫"]["正常模型缩放"], cfg["苍影灵卫"]["正常模型缩放"], cfg["苍影灵卫"]["正常模型缩放"])
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["赤誓灵卫单位"])
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["苍影灵卫单位"])
end
local function _____51C6_5907_7956_5730_53CC_7075_536BP2(context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    local maxLife = GetUnitStateJapi(context["赤誓灵卫单位"], UNIT_STATE_MAX_LIFE)
    SetUnitState(context["赤誓灵卫单位"], UNIT_STATE_LIFE, maxLife * 0.6)
    _____66F4_65B0_7956_5730_53CC_7075_536B_4FB5_8680_9636_6BB5(context["运行时"])
end
local function _____51C6_5907_7956_5730_53CC_7075_536BP2_82CD_5F71_5148_53D8_5F02(context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    local maxLife = GetUnitStateJapi(context["苍影灵卫单位"], UNIT_STATE_MAX_LIFE)
    SetUnitState(context["苍影灵卫单位"], UNIT_STATE_LIFE, maxLife * 0.6)
    _____66F4_65B0_7956_5730_53CC_7075_536B_4FB5_8680_9636_6BB5(context["运行时"])
end
local function _____51C6_5907_7956_5730_53CC_7075_536BP3(context)
    _____51C6_5907_7956_5730_53CC_7075_536BP2(context)
    local maxLife = GetUnitStateJapi(context["赤誓灵卫单位"], UNIT_STATE_MAX_LIFE)
    SetUnitState(context["赤誓灵卫单位"], UNIT_STATE_LIFE, maxLife * 0.3)
    _____66F4_65B0_7956_5730_53CC_7075_536B_4FB5_8680_9636_6BB5(context["运行时"])
end
local function _____6D4B_8BD5_53CC_7075_536B_7075_5370_6298_6B65(_player, context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    _____91CA_653E_7075_5370_6298_6B65(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_6708_7EB9_7F1A_9B42(_player, context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    _____91CA_653E_6708_7EB9_7F1A_9B42(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_8A93_950B_58C1_8FDB(_player, context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    _____91CA_653E_8A93_950B_58C1_8FDB(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_76FE_5203_88C1_51B3(_player, context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    _____91CA_653E_76FE_5203_88C1_51B3(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_5C01_95E8_6821_9A8C(_player, context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    _____91CA_653E_7956_5730_53CC_7075_536B_5C01_95E8_6821_9A8C(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_8D64_8A93_53D8_5F02(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP2(context)
end
local function _____6D4B_8BD5_53CC_7075_536B_65AD_8A93_8DF5_8E0F(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP2(context)
    _____91CA_653E_65AD_8A93_8DF5_8E0F(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_65AD_8A93_8DF5_8E0FP3(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP3(context)
    _____91CA_653E_65AD_8A93_8DF5_8E0F(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_88C2_9B42_5760_65A9(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP2(context)
    _____91CA_653E_88C2_9B42_5760_65A9(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_53CC_8680_5171_9E23(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP3(context)
end
local function _____6D4B_8BD5_53CC_7075_536B_5931_540D_7977_6F6E(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP2_82CD_5F71_5148_53D8_5F02(context)
    _____521B_5EFA_8D64_8A93_9547_9B42_5370(
        context["运行时"],
        GetUnitX(context["目标单位"]),
        GetUnitY(context["目标单位"])
    )
    _____91CA_653E_5931_540D_7977_6F6E(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_5931_540D_7977_6F6EP3(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP3(context)
    _____91CA_653E_5931_540D_7977_6F6E(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_8BB0_5FC6_5265_843D(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP2_82CD_5F71_5148_53D8_5F02(context)
    _____91CA_653E_8BB0_5FC6_5265_843D(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_5C01_95E8_8BEF_5224(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP3(context)
    context["运行时"]["已净化节点数量"] = 1
    context["运行时"]["封门误判待触发"] = true
    if context["运行时"]["净化节点列表"][1] ~= nil then
        context["运行时"]["净化节点列表"][1]["阶段"] = "已净化"
    end
    _____91CA_653E_7956_5730_53CC_7075_536B_5C01_95E8_8BEF_5224(context["运行时"])
end
local function _____6D4B_8BD5_53CC_7075_536B_540C_8A93_88AB_52A8(_player, context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    local redMax = GetUnitStateJapi(context["赤誓灵卫单位"], UNIT_STATE_MAX_LIFE)
    local azureMax = GetUnitStateJapi(context["苍影灵卫单位"], UNIT_STATE_MAX_LIFE)
    SetUnitState(context["赤誓灵卫单位"], UNIT_STATE_LIFE, redMax * 0.5)
    SetUnitState(context["苍影灵卫单位"], UNIT_STATE_LIFE, azureMax)
    _____66F4_65B0_7956_5730_53CC_7075_540C_8A93(context["运行时"])
end
local function _____6D4B_8BD5_53CC_7075_536B_4FB5_8680_9501_8840_88AB_52A8(_player, context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    local redMax = GetUnitStateJapi(context["赤誓灵卫单位"], UNIT_STATE_MAX_LIFE)
    UnitDamageTarget(
        context["目标单位"],
        context["赤誓灵卫单位"],
        redMax * 0.9,
        false,
        true,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
end
local function _____6D4B_8BD5_53CC_7075_536B_540C_606F_9501_8840_88AB_52A8(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP3(context)
    local redMax = GetUnitStateJapi(context["赤誓灵卫单位"], UNIT_STATE_MAX_LIFE)
    UnitDamageTarget(
        context["目标单位"],
        context["赤誓灵卫单位"],
        redMax * 0.8,
        false,
        true,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
end
local _____7956_5730_53CC_7075_536B_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "赤誓灵印折步", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_7075_5370_6298_6B65},
    {["序号"] = 2, ["名称"] = "赤誓月纹缚魂", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_6708_7EB9_7F1A_9B42},
    {["序号"] = 3, ["名称"] = "苍影誓锋壁进", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_8A93_950B_58C1_8FDB},
    {["序号"] = 4, ["名称"] = "苍影盾刃裁决", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_76FE_5203_88C1_51B3},
    {["序号"] = 5, ["名称"] = "P1联合封门校验", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_5C01_95E8_6821_9A8C},
    {["序号"] = 6, ["名称"] = "P2赤誓侵蚀变异", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_8D64_8A93_53D8_5F02},
    {["序号"] = 7, ["名称"] = "赤誓断誓践踏（P2盾压制）", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_65AD_8A93_8DF5_8E0F},
    {["序号"] = 7, ["命令"] = "7-3", ["名称"] = "赤誓断誓践踏（P3破壳净化）", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_65AD_8A93_8DF5_8E0FP3},
    {["序号"] = 8, ["名称"] = "赤誓裂魂坠斩", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_88C2_9B42_5760_65A9},
    {["序号"] = 9, ["名称"] = "P3双蚀共鸣", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_53CC_8680_5171_9E23},
    {["序号"] = 10, ["名称"] = "苍影失名祷潮（P2吸收镇魂印）", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_5931_540D_7977_6F6E},
    {["序号"] = 10, ["命令"] = "10-3", ["名称"] = "苍影失名祷潮（P3校准净化）", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_5931_540D_7977_6F6EP3},
    {["序号"] = 11, ["名称"] = "苍影记忆剥落", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_8BB0_5FC6_5265_843D},
    {["序号"] = 12, ["名称"] = "P3封门误判", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_5C01_95E8_8BEF_5224},
    {["序号"] = 13, ["名称"] = "被动：双灵同誓减伤与分担", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_540C_8A93_88AB_52A8},
    {["序号"] = 14, ["名称"] = "被动：侵蚀阶段生命下限", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_4FB5_8680_9501_8840_88AB_52A8},
    {["序号"] = 15, ["名称"] = "被动：同息归寂生命下限", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_540C_606F_9501_8840_88AB_52A8}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "祖地双灵卫",
    ["Boss名称"] = "祖地双灵卫",
    ["场地"] = {["正式中心"] = {x = _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["正式场地"]["中心X"], y = _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["正式场地"]["中心Y"]}, ["测试空地中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}},
    ["创建或获取上下文"] = _____521B_5EFA_6216_83B7_53D6_7956_5730_53CC_7075_536B_6D4B_8BD5_4E0A_4E0B_6587,
    ["清理上下文"] = _____6E05_7406_7956_5730_53CC_7075_536B_6D4B_8BD5_4E0A_4E0B_6587,
    ["技能命令列表"] = _____7956_5730_53CC_7075_536B_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
