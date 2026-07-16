--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．运行时上下文")
local _____6E05_7406_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["清理祖地双灵卫运行时上下文"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.00．配置")
local _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["祖地双灵卫单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置")
local _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["祖地双灵卫数值与表现配置"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____05_FF0E_7956_5730_53CC_7075_536B = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.05．祖地双灵卫")
local _____7956_5730_53CC_7075_536BBuffID = ____05_FF0E_7956_5730_53CC_7075_536B["祖地双灵卫BuffID"]
local ____09_FF0E_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.09．伤害生命下限保护")
local _____521B_5EFA_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4 = ____09_FF0E_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4["创建伤害生命下限保护"]
local ____12_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.12．台词播放")
local _____64AD_653E_8D64_8A93_7075_536B_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放赤誓灵卫台词"]
local _____64AD_653E_82CD_5F71_7075_536B_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放苍影灵卫台词"]
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.03．Boss战运行驱动")
local _____4E3B_52A8_7ED3_675FBoss_6218_8FD0_884C = ____require_result_0["主动结束Boss战运行"]
local ____require_result_1 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑")
local _____6253_5F00Boss_6B7B_4EA1_9996_9886_5956_52B1UI = ____require_result_1["打开Boss死亡首领奖励UI"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_2.getServerTime
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_3.YDWETimerDestroyEffectSafe
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_4.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_4["移除单位指定Buff"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local PauseUnit = jass.PauseUnit
local SetUnitVertexColor = jass.SetUnitVertexColor
local SetUnitScale = jass.SetUnitScale
local ShowUnit = jass.ShowUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local DzSetUnitModel = japi.DzSetUnitModel
local _____53CC_7075_536B_5956_52B1_6C60ID = "chapter2.hidden.ancestral_twin_guards"
local function _____53D6_540D_79F0(context, unit)
    if unit == context["赤誓灵卫单位"] then
        return "赤誓灵卫"
    end
    if unit == context["苍影灵卫单位"] then
        return "苍影灵卫"
    end
    return nil
end
local function _____53D6_5355_4F4D(context, name)
    local ____temp_5
    if name == "赤誓灵卫" then
        ____temp_5 = context["赤誓灵卫单位"]
    else
        ____temp_5 = context["苍影灵卫单位"]
    end
    return ____temp_5
end
local function _____8FDB_5165_7075_9B42_5D29_89E3(context, name)
    local unit = _____53D6_5355_4F4D(context, name)
    local ____self_6 = context["联合生命周期"]
    local member = ____self_6["取成员"](____self_6, name)
    if member == nil or member["状态"] == "崩解" then
        return
    end
    local ____self_7 = context["联合生命周期"]
    ____self_7["设置状态"](____self_7, name, "崩解", "生命达到同步崩解阈值")
    PauseUnit(unit, true)
    SetUnitInvulnerable(unit, true)
    registerManualBuff(
        unit,
        _____7956_5730_53CC_7075_536BBuffID["灵魂崩解"],
        3600,
        1,
        {sourceName = "祖地双灵卫-灵魂崩解", tickWhilePaused = true}
    )
    local animation = name == "赤誓灵卫" and _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["动作"]["裂誓消散"] or _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["动作"]["无面施法"]
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = unit, ["动画编号"] = animation, ["持续秒"] = 2, ["恢复动画编号"] = animation})
    if name == "赤誓灵卫" then
        _____64AD_653E_8D64_8A93_7075_536B_53F0_8BCD(unit, "灵魂崩解")
    else
        _____64AD_653E_82CD_5F71_7075_536B_53F0_8BCD(unit, "灵魂崩解")
    end
    if context["崩解中的守卫"] == nil then
        context["崩解中的守卫"] = name
        local allPurified = context["已净化节点数量"] >= _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["净化节点数量"]
        local seconds = allPurified and _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["阶段阈值"]["完成净化后同步崩解窗口秒"] or _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["阶段阈值"]["默认同步崩解窗口秒"]
        context["崩解截止时间Ms"] = getServerTime() + seconds * 1000
    end
end
____exports["绑定祖地双灵卫同息生命下限"] = function(context)
    if #context["同息生命下限保护列表"] > 0 then
        return
    end
    local units = {context["赤誓灵卫单位"], context["苍影灵卫单位"]}
    do
        local i = 0
        while i < #units do
            local unit = units[i + 1]
            local name = unit == context["赤誓灵卫单位"] and "赤誓灵卫" or "苍影灵卫"
            local controller = _____521B_5EFA_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4({
                ["名称"] = "祖地双灵卫-同息归寂锁血-" .. tostring(i + 1),
                ["单位"] = unit,
                ["最大生命比例下限"] = _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["阶段阈值"]["灵魂崩解生命比例"],
                ["修正优先级"] = -100,
                ["清理"] = context["清理"],
                ["离开下限后重置触底"] = true,
                ["过滤伤害"] = function()
                    return not context["战斗已结束"] and context["阶段"] == "P3双蚀共鸣"
                end,
                ["伤害预处理"] = function(_damage, current)
                    local ____self_8 = context["联合生命周期"]
                    local member = ____self_8["取成员"](____self_8, name)
                    return member ~= nil and member["状态"] == "崩解" and 0 or current
                end,
                ["on首次触底"] = function()
                    _____8FDB_5165_7075_9B42_5D29_89E3(context, name)
                end
            })
            local ____context__540C_606F_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_9 = context["同息生命下限保护列表"]
            ____context__540C_606F_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_9[#____context__540C_606F_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_9 + 1] = controller
            i = i + 1
        end
    end
end
local function _____6062_590D_5D29_89E3_5B88_536B(context, name)
    local unit = _____53D6_5355_4F4D(context, name)
    SetUnitState(
        unit,
        UNIT_STATE_LIFE,
        GetUnitState(unit, UNIT_STATE_MAX_LIFE) * _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["公共"]["同息回灌恢复比例"]
    )
    SetUnitInvulnerable(unit, false)
    PauseUnit(unit, false)
    local ____self_10 = context["联合生命周期"]
    ____self_10["设置状态"](____self_10, name, "活跃", "同步崩解超时回灌")
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____7956_5730_53CC_7075_536BBuffID["灵魂崩解"])
    local reflux = AddSpecialEffect(
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["公共"]["魂力回灌特效路径"],
        GetUnitX(unit),
        GetUnitY(unit)
    )
    if reflux ~= nil and reflux ~= 0 then
        YDWETimerDestroyEffectSafe(1.2, reflux)
    end
    if name == "赤誓灵卫" then
        _____64AD_653E_82CD_5F71_7075_536B_53F0_8BCD(context["苍影灵卫单位"], "同息回灌")
    else
        _____64AD_653E_8D64_8A93_7075_536B_53F0_8BCD(context["赤誓灵卫单位"], "同息回灌")
    end
    context["崩解中的守卫"] = nil
    context["崩解截止时间Ms"] = 0
end
____exports["执行祖地双灵卫净化收束"] = function(context)
    if context["战斗已结束"] or context["阶段"] == "净化收束" then
        return false
    end
    context["最终结算待处理"] = false
    context["阶段"] = "净化收束"
    context["大型技能占用者"] = "联合机制"
    local red = context["赤誓灵卫单位"]
    local azure = context["苍影灵卫单位"]
    if context["首次变异守卫"] == "赤誓灵卫" then
        _____64AD_653E_8D64_8A93_7075_536B_53F0_8BCD(red, "净化收束")
    else
        _____64AD_653E_82CD_5F71_7075_536B_53F0_8BCD(azure, "净化收束")
    end
    PauseUnit(red, true)
    PauseUnit(azure, true)
    SetUnitInvulnerable(red, true)
    SetUnitInvulnerable(azure, true)
    local cleanupBuffs = {_____7956_5730_53CC_7075_536BBuffID["双灵同誓"], _____7956_5730_53CC_7075_536BBuffID["双蚀共鸣"], _____7956_5730_53CC_7075_536BBuffID["灵魂崩解"], _____7956_5730_53CC_7075_536BBuffID["净化反冲"]}
    do
        local i = 0
        while i < #cleanupBuffs do
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(red, cleanupBuffs[i + 1])
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(azure, cleanupBuffs[i + 1])
            i = i + 1
        end
    end
    if DzSetUnitModel ~= nil then
        DzSetUnitModel(red, _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["赤誓灵卫"]["正常模型路径"])
        DzSetUnitModel(azure, _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["苍影灵卫"]["正常模型路径"])
    end
    SetUnitScale(red, _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["赤誓灵卫"]["正常模型缩放"], _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["赤誓灵卫"]["正常模型缩放"], _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["赤誓灵卫"]["正常模型缩放"])
    SetUnitScale(azure, _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["苍影灵卫"]["正常模型缩放"], _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["苍影灵卫"]["正常模型缩放"], _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["苍影灵卫"]["正常模型缩放"])
    SetUnitVertexColor(
        red,
        255,
        255,
        255,
        210
    )
    SetUnitVertexColor(
        azure,
        255,
        255,
        255,
        210
    )
    local effectA = AddSpecialEffect(
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["公共"]["最终净化归静特效路径"],
        GetUnitX(red),
        GetUnitY(red)
    )
    local effectB = AddSpecialEffect(
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["公共"]["最终净化归静特效路径"],
        GetUnitX(azure),
        GetUnitY(azure)
    )
    if effectA ~= nil and effectA ~= 0 then
        YDWETimerDestroyEffectSafe(_____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["最终净化特效持续秒"], effectA)
    end
    if effectB ~= nil and effectB ~= 0 then
        YDWETimerDestroyEffectSafe(_____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["最终净化特效持续秒"], effectB)
    end
    local delayedId = addDelayedCallback(
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["最终净化结算延迟毫秒"],
        function()
            _____4E3B_52A8_7ED3_675FBoss_6218_8FD0_884C(red, {["跳过死亡音效"] = true, ["跳过死亡剧情"] = true})
            _____4E3B_52A8_7ED3_675FBoss_6218_8FD0_884C(azure, {["跳过死亡音效"] = true, ["跳过死亡剧情"] = true})
            _____6253_5F00Boss_6B7B_4EA1_9996_9886_5956_52B1UI(_____53CC_7075_536B_5956_52B1_6C60ID)
            SetUnitVertexColor(
                red,
                255,
                255,
                255,
                0
            )
            SetUnitVertexColor(
                azure,
                255,
                255,
                255,
                0
            )
            ShowUnit(red, false)
            ShowUnit(azure, false)
            _____6E05_7406_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587(context)
        end
    )
    local ____self_11 = context["清理"]
    ____self_11["登记延迟回调"](____self_11, "祖地双灵卫-净化结算", delayedId)
    return true
end
____exports["更新祖地双灵卫同息归寂"] = function(context, now)
    if now == nil then
        now = getServerTime()
    end
    if context["最终结算待处理"] then
        ____exports["执行祖地双灵卫净化收束"](context)
        return
    end
    if context["阶段"] ~= "P3双蚀共鸣" or context["崩解中的守卫"] == nil or context["崩解截止时间Ms"] <= 0 or now < context["崩解截止时间Ms"] then
        return
    end
    local name = context["崩解中的守卫"]
    local ____self_12 = context["联合生命周期"]
    local member = ____self_12["取成员"](____self_12, name)
    if member ~= nil and member["状态"] == "崩解" then
        _____6062_590D_5D29_89E3_5B88_536B(context, name)
    end
end
____exports["同息归寂机制状态"] = {
    ["类型"] = "同步战败机制",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["语义"] = "第一名守卫进入灵魂崩解后暂不死亡，玩家需在时间窗内令另一名同步崩解。",
    ["实现要求"] = "第一名崩解时不得提前触发Boss死亡奖励、剧情结算或全场清理。"
}
return ____exports
