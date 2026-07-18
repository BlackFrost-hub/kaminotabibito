--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.00．配置")
local _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["祖地双灵卫单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置")
local _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["祖地双灵卫数值与表现配置"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____12_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.12．台词播放")
local _____64AD_653E_8D64_8A93_7075_536B_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放赤誓灵卫台词"]
local _____64AD_653E_82CD_5F71_7075_536B_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放苍影灵卫台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____05_FF0E_7956_5730_53CC_7075_536B = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.05．祖地双灵卫")
local _____7956_5730_53CC_7075_536BBuffID = ____05_FF0E_7956_5730_53CC_7075_536B["祖地双灵卫BuffID"]
local ____09_FF0E_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.09．伤害生命下限保护")
local _____521B_5EFA_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4 = ____09_FF0E_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4["创建伤害生命下限保护"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_2.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitState = jass.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitScale = jass.SetUnitScale
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local DzSetUnitModel = japi.DzSetUnitModel
local function _____751F_547D_6BD4_4F8B(unit)
    local maxLife = unit ~= nil and unit ~= 0 and GetUnitState(unit, UNIT_STATE_MAX_LIFE) or 0
    return maxLife > 0 and GetUnitState(unit, UNIT_STATE_LIFE) / maxLife or 0
end
local function _____53D8_5F02_5B88_536B(context, name)
    local isRed = name == "赤誓灵卫"
    local ____isRed_3
    if isRed then
        ____isRed_3 = context["赤誓灵卫单位"]
    else
        ____isRed_3 = context["苍影灵卫单位"]
    end
    local unit = ____isRed_3
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["侵蚀择形"],
        GetUnitX(unit),
        GetUnitY(unit),
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    local unitCfg = isRed and _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["赤誓灵卫"] or _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["苍影灵卫"]
    local effectPath = isRed and _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["公共"]["赤誓变异转化特效路径"] or _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["公共"]["苍影变异转化特效路径"]
    local effect = AddSpecialEffect(
        effectPath,
        GetUnitX(unit),
        GetUnitY(unit)
    )
    if effect ~= nil and effect ~= 0 then
        YDWETimerDestroyEffectSafe(1.8, effect)
    end
    if DzSetUnitModel ~= nil then
        DzSetUnitModel(unit, unitCfg["变异模型路径"])
    end
    SetUnitScale(unit, unitCfg["变异模型缩放"], unitCfg["变异模型缩放"], unitCfg["变异模型缩放"])
    if isRed then
        context["赤誓灵卫形态"] = "裂誓战躯"
    else
        context["苍影灵卫形态"] = "无面祷影"
    end
    local animation = isRed and _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["动作"]["裂誓举剑"] or _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["动作"]["无面施法"]
    local stand = isRed and _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["动作"]["裂誓待机"] or _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["动作"]["无面待机"]
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = unit, ["动画编号"] = animation, ["持续秒"] = 1.5, ["恢复动画编号"] = stand})
end
local function _____8FDB_5165P2(context, first, now)
    context["首次变异守卫"] = first
    context["阶段"] = "P2侵蚀失衡"
    context["P2开始时间Ms"] = now
    context["大型机制忙碌到Ms"] = now + 1800
    context["大型技能占用者"] = first
    _____53D8_5F02_5B88_536B(context, first)
    if first == "赤誓灵卫" then
        _____64AD_653E_8D64_8A93_7075_536B_53F0_8BCD(context["赤誓灵卫单位"], "首次变异")
    else
        _____64AD_653E_82CD_5F71_7075_536B_53F0_8BCD(context["苍影灵卫单位"], "首次变异")
    end
end
local function _____8FDB_5165P3(context, now)
    local second = context["首次变异守卫"] == "赤誓灵卫" and "苍影灵卫" or "赤誓灵卫"
    _____53D8_5F02_5B88_536B(context, second)
    if second == "赤誓灵卫" then
        _____64AD_653E_8D64_8A93_7075_536B_53F0_8BCD(context["赤誓灵卫单位"], "P3双蚀共鸣")
    else
        _____64AD_653E_82CD_5F71_7075_536B_53F0_8BCD(context["苍影灵卫单位"], "P3双蚀共鸣")
    end
    context["阶段"] = "P3双蚀共鸣"
    context["大型技能占用者"] = "联合机制"
    context["大型机制忙碌到Ms"] = now + 2200
    context["P3共鸣层数"] = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["净化节点数量"]
    registerManualBuff(
        context["赤誓灵卫单位"],
        _____7956_5730_53CC_7075_536BBuffID["双蚀共鸣"],
        3600,
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["公共"]["P3每层共鸣减伤比例"] * 100,
        {stack = context["P3共鸣层数"], sourceName = "祖地双灵卫-双蚀共鸣"}
    )
    registerManualBuff(
        context["苍影灵卫单位"],
        _____7956_5730_53CC_7075_536BBuffID["双蚀共鸣"],
        3600,
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["公共"]["P3每层共鸣减伤比例"] * 100,
        {stack = context["P3共鸣层数"], sourceName = "祖地双灵卫-双蚀共鸣"}
    )
    context["当前净化节点序号"] = 1
    if #context["净化节点列表"] > 0 then
        context["净化节点列表"][1]["阶段"] = "破壳"
    end
end
____exports["更新祖地双灵卫侵蚀阶段"] = function(context, now)
    if now == nil then
        now = getServerTime()
    end
    if context["战斗已结束"] then
        return
    end
    if context["大型技能占用者"] ~= nil and now >= context["大型机制忙碌到Ms"] then
        context["大型技能占用者"] = nil
    end
    local redRatio = _____751F_547D_6BD4_4F8B(context["赤誓灵卫单位"])
    local azureRatio = _____751F_547D_6BD4_4F8B(context["苍影灵卫单位"])
    if context["阶段"] == "P1双灵守门" then
        local threshold = _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["阶段阈值"]["首次变异生命比例"]
        if redRatio <= threshold or azureRatio <= threshold then
            _____8FDB_5165P2(context, redRatio <= azureRatio and "赤誓灵卫" or "苍影灵卫", now)
        end
        return
    end
    if context["阶段"] ~= "P2侵蚀失衡" or context["首次变异守卫"] == nil then
        return
    end
    local firstRatio = context["首次变异守卫"] == "赤誓灵卫" and redRatio or azureRatio
    if now >= context["P2开始时间Ms"] + _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["公共"]["P2最短持续秒"] * 1000 or firstRatio <= _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["公共"]["P2首名变异者推进P3生命比例"] then
        _____8FDB_5165P3(context, now)
    end
end
local function _____53D6_4FB5_8680_9636_6BB5_751F_547D_4E0B_9650_6BD4_4F8B(context, unit)
    if context["阶段"] == "P1双灵守门" then
        return _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["阶段阈值"]["首次变异生命比例"]
    end
    if context["阶段"] ~= "P2侵蚀失衡" or context["首次变异守卫"] == nil then
        return 0
    end
    local ____temp_4
    if context["首次变异守卫"] == "赤誓灵卫" then
        ____temp_4 = context["赤誓灵卫单位"]
    else
        ____temp_4 = context["苍影灵卫单位"]
    end
    local first = ____temp_4
    return unit == first and _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["公共"]["P2首名变异者推进P3生命比例"] or _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["阶段阈值"]["混合阶段第二守卫最低生命比例"]
end
____exports["绑定祖地双灵卫侵蚀生命下限"] = function(context)
    if #context["侵蚀生命下限保护列表"] > 0 then
        return
    end
    local units = {context["赤誓灵卫单位"], context["苍影灵卫单位"]}
    do
        local i = 0
        while i < #units do
            local unit = units[i + 1]
            local controller = _____521B_5EFA_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4({
                ["名称"] = "祖地双灵卫-侵蚀阶段锁血-" .. tostring(i + 1),
                ["单位"] = unit,
                ["修正优先级"] = -90,
                ["清理"] = context["清理"],
                ["离开下限后重置触底"] = true,
                ["过滤伤害"] = function()
                    return not context["战斗已结束"] and (context["阶段"] == "P1双灵守门" or context["阶段"] == "P2侵蚀失衡")
                end,
                ["取生命下限"] = function(target)
                    return GetUnitState(target, UNIT_STATE_MAX_LIFE) * _____53D6_4FB5_8680_9636_6BB5_751F_547D_4E0B_9650_6BD4_4F8B(context, target)
                end,
                ["on首次触底"] = function()
                    local now = getServerTime()
                    local name = unit == context["赤誓灵卫单位"] and "赤誓灵卫" or "苍影灵卫"
                    if context["阶段"] == "P1双灵守门" then
                        _____8FDB_5165P2(context, name, now)
                        return
                    end
                    if context["阶段"] ~= "P2侵蚀失衡" or context["首次变异守卫"] == nil then
                        return
                    end
                    local ____temp_5
                    if context["首次变异守卫"] == "赤誓灵卫" then
                        ____temp_5 = context["赤誓灵卫单位"]
                    else
                        ____temp_5 = context["苍影灵卫单位"]
                    end
                    local first = ____temp_5
                    if unit == first then
                        _____8FDB_5165P3(context, now)
                    end
                end
            })
            local ____context__4FB5_8680_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_6 = context["侵蚀生命下限保护列表"]
            ____context__4FB5_8680_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_6[#____context__4FB5_8680_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_6 + 1] = controller
            i = i + 1
        end
    end
end
____exports["侵蚀择形机制状态"] = {
    ["类型"] = "血量阶段机制",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["语义"] = "第一名到达阶段阈值的守卫率先变异，并决定混合形态阶段的解法。",
    ["实现要求"] = "形态变化需要迁移生命比例、仇恨和共享阶段状态；另一名守卫在混合阶段不得瞬间跳过机制。"
}
return ____exports
