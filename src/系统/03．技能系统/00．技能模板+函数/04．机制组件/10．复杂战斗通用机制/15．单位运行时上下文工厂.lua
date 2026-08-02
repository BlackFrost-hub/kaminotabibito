local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____15_FF0E_5355_4F4D_6280_80FD_58F3_63D0_793A = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.15．单位技能壳提示")
local _____8BBE_7F6E_5355_4F4D_6280_80FD_58F3_666E_901A_63D0_793A = ____15_FF0E_5355_4F4D_6280_80FD_58F3_63D0_793A["设置单位技能壳普通提示"]
local ____01_FF0E_673A_5236_6E05_7406_7BEE_5B50 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.06．机制清理.01．机制清理篮子")
local _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50 = ____01_FF0E_673A_5236_6E05_7406_7BEE_5B50["创建机制清理篮子"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local function _____9ED8_8BA4_53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["创建单位运行时上下文工厂"] = function(_____53C2_6570)
    local _____4E0A_4E0B_6587_8868 = {}
    local function _____83B7_53D6(unit)
        local id = _____9ED8_8BA4_53D6_5355_4F4DID(unit)
        local ____temp_1
        if id == 0 then
            ____temp_1 = nil
        else
            ____temp_1 = _____4E0A_4E0B_6587_8868[id]
        end
        return ____temp_1
    end
    local function _____83B7_53D6_6216_521B_5EFA(unit)
        local id = _____9ED8_8BA4_53D6_5355_4F4DID(unit)
        if id == 0 then
            return nil
        end
        local context = _____4E0A_4E0B_6587_8868[id]
        if context ~= nil then
            return context
        end
        local _____6E05_7406 = _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50(_____53C2_6570["名称"])
        context = _____53C2_6570["创建上下文"](unit, _____6E05_7406)
        if _____53C2_6570["主动技能提示"] ~= nil then
            _____8BBE_7F6E_5355_4F4D_6280_80FD_58F3_666E_901A_63D0_793A(unit, _____53C2_6570["主动技能提示"])
        end
        _____4E0A_4E0B_6587_8868[id] = context
        if _____53C2_6570["on创建"] ~= nil then
            _____53C2_6570["on创建"](context)
        end
        return context
    end
    local function _____83B7_53D6_5168_90E8()
        local result = {}
        for key in pairs(_____4E0A_4E0B_6587_8868) do
            local context = _____4E0A_4E0B_6587_8868[key]
            if context ~= nil then
                result[#result + 1] = context
            end
        end
        return result
    end
    local function _____6E05_7406_4E0A_4E0B_6587(unit)
        local id = _____9ED8_8BA4_53D6_5355_4F4DID(unit)
        if id == 0 then
            return
        end
        local context = _____4E0A_4E0B_6587_8868[id]
        if context ~= nil then
            if _____53C2_6570["on清理"] ~= nil then
                _____53C2_6570["on清理"](context)
            end
            local ____self_2 = context["清理"]
            ____self_2["清理全部"](____self_2)
        end
        __TS__Delete(_____4E0A_4E0B_6587_8868, id)
    end
    local function _____5904_7406_5355_4F4D_6B7B_4EA1(dyingUnit, killingUnit)
        local id = _____9ED8_8BA4_53D6_5355_4F4DID(dyingUnit)
        if id == 0 then
            return
        end
        local context = _____4E0A_4E0B_6587_8868[id]
        if context == nil then
            return
        end
        if _____53C2_6570["on单位死亡"] ~= nil then
            _____53C2_6570["on单位死亡"](context, dyingUnit, killingUnit)
        end
        if _____53C2_6570["死亡时自动清理"] and _____4E0A_4E0B_6587_8868[id] == context then
            _____6E05_7406_4E0A_4E0B_6587(dyingUnit)
        end
    end
    if _____53C2_6570["死亡时自动清理"] or _____53C2_6570["on单位死亡"] ~= nil then
        registerDeathListener(_____5904_7406_5355_4F4D_6B7B_4EA1)
    end
    return {
        ["获取"] = _____83B7_53D6,
        ["获取或创建"] = _____83B7_53D6_6216_521B_5EFA,
        ["获取全部"] = _____83B7_53D6_5168_90E8,
        ["清理上下文"] = _____6E05_7406_4E0A_4E0B_6587,
        ["取单位ID"] = _____9ED8_8BA4_53D6_5355_4F4DID
    }
end
return ____exports
