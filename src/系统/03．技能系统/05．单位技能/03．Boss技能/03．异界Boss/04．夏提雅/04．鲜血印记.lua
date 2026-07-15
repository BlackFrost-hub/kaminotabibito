local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.02．数值与表现配置")
local _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["夏提雅数值与表现配置"]
local ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D["创建可攻击机制单位"]
local ____06_FF0E_5355_4F4D_505C_7559_89E6_53D1_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.06．单位停留触发器")
local _____521B_5EFA_5355_4F4D_505C_7559_89E6_53D1_5668 = ____06_FF0E_5355_4F4D_505C_7559_89E6_53D1_5668["创建单位停留触发器"]
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_0["获取Boss技能敌对英雄列表"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local removeDelayedCallback = ____require_result_1.removeDelayedCallback
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_2.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local Player = jass.Player
local UnitAddAbility = jass.UnitAddAbility
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local PauseUnit = jass.PauseUnit
local SetUnitPathing = jass.SetUnitPathing
local AddSpecialEffect = jass.AddSpecialEffect
local _____8757_866B_6280_80FDID = 1097625443
local function _____4ECE_5217_8868_79FB_9664(context, mark)
    do
        local i = #context["血印句柄列表"] - 1
        while i >= 0 do
            if context["血印句柄列表"][i + 1] == mark then
                __TS__ArraySplice(context["血印句柄列表"], i, 1)
            end
            i = i - 1
        end
    end
end
____exports["清理夏提雅鲜血印记"] = function(context, mark, purified)
    if purified == nil then
        purified = false
    end
    if mark["已清理"] then
        return
    end
    mark["已清理"] = true
    local ____self_3 = mark["停留控制器"]
    ____self_3["停止"](____self_3)
    if mark["到期ID"] ~= 0 then
        removeDelayedCallback(mark["到期ID"])
    end
    if purified then
        local effect = AddSpecialEffect(_____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["血印净化特效路径"], mark.X, mark.Y)
        if effect ~= nil and effect ~= 0 then
            YDWETimerDestroyEffectSafe(1.2, effect)
        end
    end
    mark["单位实例"]["销毁"]()
    _____4ECE_5217_8868_79FB_9664(context, mark)
end
____exports["创建夏提雅鲜血印记"] = function(context, x, y)
    if context["阶段"] == "P3真祖血宴" or context["挑战已结束"] then
        return nil
    end
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["鲜血印记"]
    if #context["血印句柄列表"] >= cfg["同时存在上限"] then
        return nil
    end
    local unitInstance = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "夏提雅-鲜血印记",
        ["主人单位"] = context["Boss单位"],
        ["所属玩家"] = Player(15),
        ["单位类型"] = cfg["机制单位ID"],
        ["模型路径"] = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["血印地面特效路径"],
        X = x,
        Y = y,
        ["最大生命"] = 1,
        ["生命值受小怪倍率"] = false,
        ["缩放"] = cfg["机制单位缩放"]
    })
    if unitInstance == nil then
        return nil
    end
    UnitAddAbility(unitInstance["单位"], _____8757_866B_6280_80FDID)
    SetUnitInvulnerable(unitInstance["单位"], true)
    PauseUnit(unitInstance["单位"], true)
    SetUnitPathing(unitInstance["单位"], false)
    local mark = {
        X = x,
        Y = y,
        ["单位实例"] = unitInstance,
        ["停留控制器"] = nil,
        ["到期ID"] = 0,
        ["已清理"] = false
    }
    mark["停留控制器"] = _____521B_5EFA_5355_4F4D_505C_7559_89E6_53D1_5668({
        ["名称"] = "夏提雅-鲜血印记主动净化",
        ["中心单位"] = unitInstance["单位"],
        ["半径"] = cfg["净化半径"],
        ["需求持续毫秒"] = cfg["主动净化秒"] * 1000,
        ["检查间隔毫秒"] = 100,
        ["离开后重置"] = true,
        ["只触发一次"] = true,
        ["清理篮子"] = context["清理"],
        ["读取单位列表"] = function()
            return _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
        end,
        ["on触发"] = function()
            ____exports["清理夏提雅鲜血印记"](context, mark, true)
        end
    })
    mark["到期ID"] = addDelayedCallback(
        cfg["持续最大秒"] * 1000,
        function()
            ____exports["清理夏提雅鲜血印记"](context, mark, false)
        end
    )
    local ____self_4 = context["清理"]
    ____self_4["登记延迟回调"](____self_4, "夏提雅-鲜血印记到期", mark["到期ID"])
    local ____context__8840_5370_53E5_67C4_5217_8868_5 = context["血印句柄列表"]
    ____context__8840_5370_53E5_67C4_5217_8868_5[#____context__8840_5370_53E5_67C4_5217_8868_5 + 1] = mark
    return mark
end
____exports["净化落点内夏提雅鲜血印记"] = function(context, x, y, radius)
    local count = 0
    local list = __TS__ArraySlice(context["血印句柄列表"])
    do
        local i = 0
        while i < #list do
            local mark = list[i + 1]
            local dx = mark.X - x
            local dy = mark.Y - y
            if not mark["已清理"] and dx * dx + dy * dy <= radius * radius then
                ____exports["清理夏提雅鲜血印记"](context, mark, true)
                count = count + 1
            end
            i = i + 1
        end
    end
    return count
end
____exports["吸收夏提雅鲜血印记"] = function(context, mark)
    if mark == nil or mark["已清理"] then
        return false
    end
    local effect = AddSpecialEffect(_____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["血印净化特效路径"], mark.X, mark.Y)
    if effect ~= nil and effect ~= 0 then
        YDWETimerDestroyEffectSafe(1.2, effect)
    end
    ____exports["清理夏提雅鲜血印记"](context, mark, false)
    return true
end
____exports["鲜血印记机制状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["类型"] = "有限场地资源",
    ["语义"] = "符合条件的强化穿刺留下血印，玩家可站入净化或诱导净化投枪摧毁。",
    ["实现要求"] = "场上最多三个；技能伤害、DOT、反伤和英灵复刻不得误生成血印。"
}
return ____exports
