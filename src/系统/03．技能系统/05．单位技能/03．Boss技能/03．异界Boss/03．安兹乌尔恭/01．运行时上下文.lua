--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.00．配置")
local _____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["安兹乌尔恭单位技能配置"]
local ____00_FF0E_72B6_6001 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.00．状态")
local _____521B_5EFA_96C5_513F_8D1D_5FB7_8FD0_884C_72B6_6001 = ____00_FF0E_72B6_6001["创建雅儿贝德运行状态"]
local ____01_FF0E_673A_5236_6E05_7406_7BEE_5B50 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.06．机制清理.01．机制清理篮子")
local _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50 = ____01_FF0E_673A_5236_6E05_7406_7BEE_5B50["创建机制清理篮子"]
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local IsUnitType = jass.IsUnitType
local GetUnitState = jass.GetUnitState
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____5B89_5179_8FD0_884C_65F6_5DF2_6CE8_518C = false
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____521B_5EFA_5B89_5179_4E0A_4E0B_6587(boss, _____6E05_7406, _____6A21_5F0F)
    local nowMs = getServerTime()
    return {
        ["安兹单位"] = boss,
        ["模式"] = _____6A21_5F0F,
        ["阶段"] = "P1至尊的审视",
        ["开战时间Ms"] = nowMs,
        ["上次阶段变化Ms"] = nowMs,
        ["时间停止中"] = false,
        ["天空坠落已释放"] = false,
        ["一切生命的终点已释放"] = false,
        ["挑战已结束"] = false,
        ["已初始化"] = true,
        ["清理"] = _____6E05_7406
    }
end
____exports["创建安兹运行时上下文"] = function(_____6A21_5F0F, boss)
    return _____521B_5EFA_5B89_5179_4E0A_4E0B_6587(
        boss,
        _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50("安兹·乌尔·恭"),
        _____6A21_5F0F
    )
end
local _____5B89_5179_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({
    ["名称"] = "安兹·乌尔·恭",
    ["创建上下文"] = function(boss, _____6E05_7406)
        return _____521B_5EFA_5B89_5179_4E0A_4E0B_6587(boss, _____6E05_7406, "守护者介入")
    end,
    ["on清理"] = function(context)
        context["挑战已结束"] = true
        context["阶段"] = "已结束"
        if context["雅儿贝德"] ~= nil then
            context["雅儿贝德"]["守护连接生效"] = false
            context["雅儿贝德"]["共同护盾生效"] = false
            context["雅儿贝德"]["阶段状态"] = "已离场"
        end
    end
})
____exports["获取安兹运行时上下文"] = function(boss)
    return _____5B89_5179_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取或创建安兹运行时上下文"] = function(boss)
    return _____5B89_5179_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["清理安兹运行时上下文"] = function(boss)
    _____5B89_5179_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
____exports["绑定雅儿贝德到安兹上下文"] = function(boss, albedo)
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(albedo) then
        return false
    end
    local context = ____exports["获取或创建安兹运行时上下文"](boss)
    if context == nil or context["挑战已结束"] then
        return false
    end
    context["雅儿贝德"] = _____521B_5EFA_96C5_513F_8D1D_5FB7_8FD0_884C_72B6_6001(albedo)
    context["模式"] = "守护者介入"
    return true
end
local function _____5237_65B0_5B89_5179_9636_6BB5(context)
    if context["挑战已结束"] or context["阶段"] == "挑战收束" or context["阶段"] == "已结束" then
        return
    end
    local maxLife = GetUnitState(context["安兹单位"], UNIT_STATE_MAX_LIFE)
    if maxLife <= 0 then
        return
    end
    local ratio = GetUnitState(context["安兹单位"], UNIT_STATE_LIFE) / maxLife
    local nextStage = context["阶段"]
    if ratio <= _____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["阶段阈值"]["P3生命比例"] then
        nextStage = "P3死亡是众生的终点"
    elseif ratio <= _____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["阶段阈值"]["P2生命比例"] then
        nextStage = "P2死亡支配者"
    end
    if nextStage ~= context["阶段"] then
        context["阶段"] = nextStage
        context["上次阶段变化Ms"] = getServerTime()
    end
end
local function _____63A8_8FDB_5B89_5179_8FD0_884C_65F6()
    local contexts = _____5B89_5179_4E0A_4E0B_6587_5DE5_5382["获取全部"]()
    do
        local i = 0
        while i < #contexts do
            do
                local context = contexts[i + 1]
                if context == nil then
                    goto __continue22
                end
                if not _____5355_4F4D_6709_6548(context["安兹单位"]) then
                    ____exports["清理安兹运行时上下文"](context["安兹单位"])
                    goto __continue22
                end
                _____5237_65B0_5B89_5179_9636_6BB5(context)
            end
            ::__continue22::
            i = i + 1
        end
    end
end
____exports["注册安兹运行时"] = function()
    if _____5B89_5179_8FD0_884C_65F6_5DF2_6CE8_518C then
        return
    end
    _____5B89_5179_8FD0_884C_65F6_5DF2_6CE8_518C = true
    addPeriodicCallback(250, _____63A8_8FDB_5B89_5179_8FD0_884C_65F6)
end
return ____exports
