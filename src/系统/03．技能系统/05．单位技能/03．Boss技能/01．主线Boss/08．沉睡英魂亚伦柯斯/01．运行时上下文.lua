--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.00．配置")
local _____4E9A_4F26_67EF_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["亚伦柯斯单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.02．数值与表现配置")
local _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["亚伦柯斯正式设计配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.11．台词播放")
local _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放亚伦柯斯台词"]
local ____01_FF0E_673A_5236_6E05_7406_7BEE_5B50 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.06．机制清理.01．机制清理篮子")
local _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50 = ____01_FF0E_673A_5236_6E05_7406_7BEE_5B50["创建机制清理篮子"]
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器")
local _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668 = ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668["创建周期机制调度器"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local ____09_FF0E_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.09．伤害生命下限保护")
local _____521B_5EFA_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4 = ____09_FF0E_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4["创建伤害生命下限保护"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_2.YDWETimerDestroyEffectSafe
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_3.SGSS_SetState
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local AddSpecialEffect = jass.AddSpecialEffect
local SetUnitVertexColor = jass.SetUnitVertexColor
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____653B_51FB_529B_5C5E_6027ID = 1
local _____653B_901F_5C5E_6027ID = 10
local _____4E9A_4F26_67EF_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____4E9A_4F26_67EF_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____4E9A_4F26_67EF_65AF_8FD0_884C_65F6_5DF2_6CE8_518C = false
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____521B_5EFA_4E0A_4E0B_6587(boss, _____6E05_7406)
    local now = getServerTime()
    local context = {
        ["Boss单位"] = boss,
        ["阶段"] = "P1守墓者苏醒",
        ["开战时间Ms"] = now,
        ["上次阶段变化Ms"] = now,
        ["普通机制忙碌到Ms"] = now + 1800,
        ["已安魂墓碑数量"] = 0,
        ["未安魂墓碑数量"] = 0,
        ["墓碑机制已启动"] = false,
        ["墓碑状态列表"] = {},
        ["不灭军魂已启用"] = false,
        ["已触发最终强化"] = false,
        ["最终强化攻击力增量"] = 0,
        ["最终强化攻速增量"] = 0,
        ["战斗已结束"] = false,
        ["已初始化"] = true,
        ["清理"] = _____6E05_7406
    }
    local effect = AddSpecialEffect(
        _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["开战苏醒特效路径"],
        GetUnitX(boss),
        GetUnitY(boss)
    )
    if effect ~= nil and effect ~= 0 then
        YDWETimerDestroyEffectSafe(2, effect)
    end
    _____521B_5EFA_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4({
        ["名称"] = "亚伦柯斯-P2墓碑锁血",
        ["单位"] = boss,
        ["最大生命比例下限"] = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["旧誓墓碑"]["P2最低生命比例"],
        ["修正优先级"] = -80,
        ["清理"] = _____6E05_7406,
        ["过滤伤害"] = function()
            return not context["战斗已结束"] and context["阶段"] == "P2旧誓回响" and context["未安魂墓碑数量"] > 0
        end,
        ["伤害预处理"] = function(_damage, current)
            local result = current * (1 - context["未安魂墓碑数量"] * _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["旧誓墓碑"]["未安魂减伤每层"])
            return result > 0 and result or 0
        end
    })
    _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD(boss, "开场")
    return context
end
--- 独立测试可显式创建；正式战斗使用上下文工厂。
____exports["创建亚伦柯斯运行时上下文"] = function(boss)
    return _____521B_5EFA_4E0A_4E0B_6587(
        boss,
        _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50("亚伦柯斯测试上下文")
    )
end
local _____4E9A_4F26_67EF_65AF_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({
    ["名称"] = "沉睡英魂·亚伦柯斯",
    ["主动技能提示"] = _____4E9A_4F26_67EF_65AF_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"],
    ["创建上下文"] = _____521B_5EFA_4E0A_4E0B_6587,
    ["on清理"] = function(context)
        context["战斗已结束"] = true
        context["阶段"] = "已结束"
        context["当前大型技能"] = nil
        if _____5355_4F4D_6709_6548(context["Boss单位"]) then
            if context["最终强化攻击力增量"] ~= 0 then
                SGSS_SetState(context["Boss单位"], _____653B_51FB_529B_5C5E_6027ID, -context["最终强化攻击力增量"])
            end
            if context["最终强化攻速增量"] ~= 0 then
                SGSS_SetState(context["Boss单位"], _____653B_901F_5C5E_6027ID, -context["最终强化攻速增量"])
            end
        end
        context["最终强化攻击力增量"] = 0
        context["最终强化攻速增量"] = 0
        context["墓碑状态列表"] = {}
    end
})
____exports["获取亚伦柯斯运行时上下文"] = function(boss)
    return _____4E9A_4F26_67EF_65AF_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取或创建亚伦柯斯运行时上下文"] = function(boss)
    return _____4E9A_4F26_67EF_65AF_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["获取全部亚伦柯斯运行时上下文"] = function()
    return _____4E9A_4F26_67EF_65AF_4E0A_4E0B_6587_5DE5_5382["获取全部"]()
end
____exports["清理亚伦柯斯运行时上下文"] = function(boss)
    _____4E9A_4F26_67EF_65AF_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
____exports["进入亚伦柯斯P3"] = function(context)
    if context["战斗已结束"] or context["阶段"] ~= "P2旧誓回响" or context["未安魂墓碑数量"] > 0 then
        return
    end
    context["阶段"] = "P3最后的誓约"
    context["上次阶段变化Ms"] = getServerTime()
    context["普通机制忙碌到Ms"] = context["上次阶段变化Ms"] + 1800
    context["当前大型技能"] = nil
    _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD(context["Boss单位"], "记忆恢复")
    local delayedId = addDelayedCallback(
        1800,
        function()
            if not context["战斗已结束"] and context["阶段"] == "P3最后的誓约" then
                _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD(context["Boss单位"], "转阶段3最后誓约")
            end
        end
    )
    local ____self_4 = context["清理"]
    ____self_4["登记延迟回调"](____self_4, "亚伦柯斯-P3宣言", delayedId)
end
local function _____63A8_8FDB_4E9A_4F26_67EF_65AF_8FD0_884C_65F6(context, now)
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) or context["战斗已结束"] then
        return
    end
    local maxLife = GetUnitState(context["Boss单位"], UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) then
        return
    end
    local ratio = GetUnitState(context["Boss单位"], UNIT_STATE_LIFE) / maxLife
    if context["阶段"] == "P1守墓者苏醒" and ratio <= _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["阶段阈值"]["P2生命比例"] then
        context["阶段"] = "P2旧誓回响"
        context["上次阶段变化Ms"] = now
        context["普通机制忙碌到Ms"] = now + 1500
        context["当前大型技能"] = "旧誓回响转阶段"
        context["未安魂墓碑数量"] = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["旧誓墓碑"]["数量"]
        _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD(context["Boss单位"], "转阶段2旧誓回响")
        local delayedId = addDelayedCallback(
            1500,
            function()
                if context["当前大型技能"] == "旧誓回响转阶段" then
                    context["当前大型技能"] = nil
                end
            end
        )
        local ____self_5 = context["清理"]
        ____self_5["登记延迟回调"](____self_5, "亚伦柯斯-P2转阶段结束", delayedId)
    end
end
local function ____on_4E9A_4F26_67EF_65AF_6B7B_4EA1(dyingUnit)
    if GetUnitTypeId(dyingUnit) ~= _____4E9A_4F26_67EF_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = ____exports["获取亚伦柯斯运行时上下文"](dyingUnit)
    if context == nil or context["战斗已结束"] then
        return
    end
    context["战斗已结束"] = true
    context["阶段"] = "战败归静"
    context["当前大型技能"] = nil
    _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD(dyingUnit, "战败")
    local effect = AddSpecialEffect(
        _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["战败归静特效路径"],
        GetUnitX(dyingUnit),
        GetUnitY(dyingUnit)
    )
    if effect ~= nil and effect ~= 0 then
        YDWETimerDestroyEffectSafe(2.6, effect)
    end
    local delayedId = addDelayedCallback(
        2300,
        function()
            SetUnitVertexColor(
                dyingUnit,
                255,
                255,
                255,
                0
            )
            ____exports["清理亚伦柯斯运行时上下文"](dyingUnit)
        end
    )
    local ____self_6 = context["清理"]
    ____self_6["登记延迟回调"](____self_6, "亚伦柯斯-战败归静", delayedId)
end
____exports["注册亚伦柯斯运行时"] = function()
    if _____4E9A_4F26_67EF_65AF_8FD0_884C_65F6_5DF2_6CE8_518C then
        return
    end
    _____4E9A_4F26_67EF_65AF_8FD0_884C_65F6_5DF2_6CE8_518C = true
    registerDeathListener(____on_4E9A_4F26_67EF_65AF_6B7B_4EA1)
    _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668({
        ["名称"] = "亚伦柯斯-运行时阶段刷新",
        ["间隔毫秒"] = 200,
        ["取当前时间"] = getServerTime,
        ["取上下文列表"] = ____exports["获取全部亚伦柯斯运行时上下文"],
        ["执行"] = _____63A8_8FDB_4E9A_4F26_67EF_65AF_8FD0_884C_65F6
    })
end
return ____exports
