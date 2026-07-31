--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____79FB_9664_5355_4F4D_6307_5B9ABuff
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.00．配置")
local _____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["夏提雅单位技能配置"]
local ____01_FF0E_673A_5236_6E05_7406_7BEE_5B50 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.06．机制清理.01．机制清理篮子")
local _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50 = ____01_FF0E_673A_5236_6E05_7406_7BEE_5B50["创建机制清理篮子"]
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器")
local _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668 = ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668["创建周期机制调度器"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6 = ____01_FF0E_63A7_5236_4E0EBuff["单位是否处于硬控制效果合集"]
local ____06_FF0EBuff_5C42_6570_72B6_6001 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.01．层数状态.06．Buff层数状态")
local _____521B_5EFABuff_5C42_6570_72B6_6001 = ____06_FF0EBuff_5C42_6570_72B6_6001["创建Buff层数状态"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.02．数值与表现配置")
local _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["夏提雅数值与表现配置"]
local ____02_FF0E_590F_63D0_96C5 = require("系统.05．Buff系统.03．Buff表.01．Boss.03．异界Boss.02．夏提雅")
local _____590F_63D0_96C5BuffID = ____02_FF0E_590F_63D0_96C5["夏提雅BuffID"]
local ____18_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.18．台词播放")
local _____64AD_653E_590F_63D0_96C5_53F0_8BCD = ____18_FF0E_53F0_8BCD_64AD_653E["播放夏提雅台词"]
____exports["重置夏提雅猎血连击"] = function(context)
    if _____5355_4F4D_6709_6548(context["Boss单位"]) then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["Boss单位"], _____590F_63D0_96C5BuffID["猎血连击"])
    end
    context["当前猎血目标"] = nil
    context["当前猎血段数"] = 0
    context["猎血段数过期时间Ms"] = 0
    context["待结算强化穿刺目标"] = nil
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local getServerTime = ____require_result_0.getServerTime
local jass = require("jass.common")
local japi = require("jass.japi")
local DzSetUnitModel = japi.DzSetUnitModel
local GetUnitStateJapi = japi.GetUnitState
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local RemoveUnit = jass.RemoveUnit
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_1.SGSS_SetState
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local _____653B_901F_5C5E_6027ID = 10
local _____590F_63D0_96C5_8FD0_884C_65F6_5DF2_6CE8_518C = false
local function _____521B_5EFA_4E0A_4E0B_6587(boss, _____6E05_7406)
    local now = getServerTime()
    local context = {
        ["Boss单位"] = boss,
        ["阶段"] = "P1鲜血女武神",
        ["开战时间Ms"] = now,
        ["上次阶段变化Ms"] = now,
        ["普通机制忙碌到Ms"] = 0,
        ["当前猎血段数"] = 0,
        ["猎血段数过期时间Ms"] = 0,
        ["汲血穿刺台词冷却到Ms"] = 0,
        ["血印句柄列表"] = {},
        ["血之狂热控制器"] = nil,
        ["血宴层数"] = 0,
        ["P3转阶段已处理"] = false,
        ["血宴攻速增量"] = 0,
        ["英灵战乙女已登场"] = false,
        ["英灵复刻冷却到Ms"] = 0,
        ["上次英灵复刻技能"] = "",
        ["镜像夹击执行ID"] = 0,
        ["已触发复生"] = false,
        ["血月终舞已释放"] = false,
        ["上次净化投枪目标ID"] = 0,
        ["挑战已结束"] = false,
        ["已初始化"] = true,
        ["清理"] = _____6E05_7406
    }
    local frenzy = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["鲜血印记"]
    context["血之狂热控制器"] = _____521B_5EFABuff_5C42_6570_72B6_6001({
        ["名称"] = "夏提雅-血之狂热",
        ["清理"] = _____6E05_7406,
        BuffID = _____590F_63D0_96C5BuffID["血之狂热"],
        ["Buff持续秒"] = frenzy["血之狂热持续秒"],
        ["层数配置"] = {
            ["状态ID"] = "夏提雅-血之狂热",
            ["最大层数"] = 3,
            ["衰减"] = {["等待秒"] = frenzy["血之狂热持续秒"], ["间隔秒"] = frenzy["血之狂热持续秒"], ["每次减少层数"] = 3},
            ["on层数变化"] = function(event)
                local delta = (event["新层数"] - event["旧层数"]) * frenzy["血之狂热每层攻击速度提高"]
                if delta ~= 0 and _____5355_4F4D_6709_6548(event["单位"]) then
                    SGSS_SetState(event["单位"], _____653B_901F_5C5E_6027ID, delta)
                end
            end
        },
        ["取Buff显示值"] = function(_unit, layers)
            return layers * frenzy["血之狂热每层攻击速度提高"] * 100
        end,
        ["取Buff附加参数"] = function(_unit, layers)
            return {stack = layers, effectValue2 = layers * frenzy["血之狂热每层技能冷却恢复提高"] * 100, sourceName = "夏提雅-鲜血回收"}
        end
    })
    if _____5355_4F4D_6709_6548(boss) then
        _____64AD_653E_590F_63D0_96C5_53F0_8BCD(boss, "登场")
        local battleStartId = addDelayedCallback(
            _____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E["开场台词时间"]["战斗开始延迟Ms"],
            function()
                if _____5355_4F4D_6709_6548(boss) and not context["挑战已结束"] then
                    _____64AD_653E_590F_63D0_96C5_53F0_8BCD(boss, "战斗开始")
                end
            end
        )
        _____6E05_7406["登记延迟回调"](_____6E05_7406, "夏提雅-战斗开始台词", battleStartId)
    end
    return context
end
--- 独立测试可显式创建；正式战斗使用上下文工厂。
____exports["创建夏提雅运行时上下文"] = function(boss)
    return _____521B_5EFA_4E0A_4E0B_6587(
        boss,
        _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50("夏提雅·布拉德弗伦测试上下文")
    )
end
local _____590F_63D0_96C5_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({
    ["名称"] = "夏提雅·布拉德弗伦",
    ["创建上下文"] = _____521B_5EFA_4E0A_4E0B_6587,
    ["on清理"] = function(context)
        context["挑战已结束"] = true
        context["阶段"] = "已结束"
        ____exports["重置夏提雅猎血连击"](context)
        context["当前大型技能"] = nil
        context["待结算强化穿刺目标"] = nil
        if context["血宴攻速增量"] ~= 0 and _____5355_4F4D_6709_6548(context["Boss单位"]) then
            SGSS_SetState(context["Boss单位"], _____653B_901F_5C5E_6027ID, -context["血宴攻速增量"])
            context["血宴攻速增量"] = 0
        end
        if _____5355_4F4D_6709_6548(context["Boss单位"]) then
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["Boss单位"], _____590F_63D0_96C5BuffID["真祖血宴"])
        end
        if _____5355_4F4D_6709_6548(context["英灵战乙女句柄"]) then
            RemoveUnit(context["英灵战乙女句柄"])
        end
        if _____5355_4F4D_6709_6548(context["镜像夹击句柄"]) then
            RemoveUnit(context["镜像夹击句柄"])
        end
        context["英灵战乙女句柄"] = nil
        context["镜像夹击句柄"] = nil
        context["血印句柄列表"] = {}
    end
})
____exports["获取夏提雅运行时上下文"] = function(boss)
    return _____590F_63D0_96C5_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取或创建夏提雅运行时上下文"] = function(boss)
    return _____590F_63D0_96C5_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["获取全部夏提雅运行时上下文"] = function()
    return _____590F_63D0_96C5_4E0A_4E0B_6587_5DE5_5382["获取全部"]()
end
____exports["清理夏提雅运行时上下文"] = function(boss)
    _____590F_63D0_96C5_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
--- 阶段模型由运行时统一维护，测试命令与正式血量转阶段共用这一入口。
____exports["设置夏提雅阶段模型"] = function(context)
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) or DzSetUnitModel == nil then
        return
    end
    local _____4F7F_7528_5973_6B66_795E_6A21_578B = context["阶段"] == "P2英灵战乙女" or context["阶段"] == "P3真祖血宴" or context["阶段"] == "复生仪式"
    DzSetUnitModel(context["Boss单位"], _____4F7F_7528_5973_6B66_795E_6A21_578B and _____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E["女武神形态"]["模型路径"] or _____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E["模型路径"])
end
local function _____5237_65B0_9636_6BB5(context)
    if context["挑战已结束"] or context["阶段"] == "复生仪式" or context["阶段"] == "挑战收束" or context["阶段"] == "已结束" then
        return
    end
    local maxLife = GetUnitStateJapi(context["Boss单位"], UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) then
        return
    end
    local ratio = GetUnitState(context["Boss单位"], UNIT_STATE_LIFE) / maxLife
    local next = context["阶段"]
    if ratio <= _____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E["阶段阈值"]["P3生命比例"] then
        next = "P3真祖血宴"
    elseif ratio <= _____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E["阶段阈值"]["P2生命比例"] then
        next = "P2英灵战乙女"
    end
    if next == context["阶段"] then
        return
    end
    context["阶段"] = next
    ____exports["设置夏提雅阶段模型"](context)
    context["上次阶段变化Ms"] = getServerTime()
    context["当前大型技能"] = nil
    ____exports["重置夏提雅猎血连击"](context)
    if next == "P2英灵战乙女" then
        _____64AD_653E_590F_63D0_96C5_53F0_8BCD(context["Boss单位"], "进入P2")
    end
    if next == "P3真祖血宴" then
        _____64AD_653E_590F_63D0_96C5_53F0_8BCD(context["Boss单位"], "进入P3")
    end
end
local function _____63A8_8FDB_590F_63D0_96C5_8FD0_884C_65F6(context, now)
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        ____exports["清理夏提雅运行时上下文"](context["Boss单位"])
        return
    end
    if context["猎血段数过期时间Ms"] > 0 and now >= context["猎血段数过期时间Ms"] then
        ____exports["重置夏提雅猎血连击"](context)
    end
    if context["当前猎血段数"] > 0 and _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6(context["Boss单位"]) then
        ____exports["重置夏提雅猎血连击"](context)
    end
    _____5237_65B0_9636_6BB5(context)
end
____exports["注册夏提雅运行时"] = function()
    if _____590F_63D0_96C5_8FD0_884C_65F6_5DF2_6CE8_518C then
        return
    end
    _____590F_63D0_96C5_8FD0_884C_65F6_5DF2_6CE8_518C = true
    _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668({
        ["名称"] = "夏提雅-运行时阶段刷新",
        ["间隔毫秒"] = 250,
        ["取当前时间"] = getServerTime,
        ["取上下文列表"] = ____exports["获取全部夏提雅运行时上下文"],
        ["执行"] = _____63A8_8FDB_590F_63D0_96C5_8FD0_884C_65F6
    })
end
return ____exports
