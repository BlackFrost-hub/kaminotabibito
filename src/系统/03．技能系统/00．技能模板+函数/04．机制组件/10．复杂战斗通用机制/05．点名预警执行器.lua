local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382["创建技能提示圈"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local _____70B9_540D_9884_8B66_6267_884C_5668_5B9E_73B0 = __TS__Class()
_____70B9_540D_9884_8B66_6267_884C_5668_5B9E_73B0.name = "点名预警执行器实现"
function _____70B9_540D_9884_8B66_6267_884C_5668_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["延迟ID"] = 0
    self["已取消"] = false
    self["参数"] = _____53C2_6570
    self["结果"] = {
        ["目标"] = _____53C2_6570["目标"],
        ["锁定X"] = _____53C2_6570["目标"] ~= nil and _____53C2_6570["目标"] ~= 0 and GetUnitX(_____53C2_6570["目标"]) or 0,
        ["锁定Y"] = _____53C2_6570["目标"] ~= nil and _____53C2_6570["目标"] ~= 0 and GetUnitY(_____53C2_6570["目标"]) or 0
    }
    if _____53C2_6570["on锁定"] ~= nil then
        _____53C2_6570["on锁定"](self["结果"])
    end
    self["创建提示圈"](self)
    local ____self = self
    self["延迟ID"] = addDelayedCallback(
        _____53C2_6570["延迟秒"] * 1000,
        function()
            ____self["结算"](____self)
        end
    )
end
_____70B9_540D_9884_8B66_6267_884C_5668_5B9E_73B0.prototype["取消"] = function(self)
    if self["已取消"] then
        return
    end
    self["已取消"] = true
    if self["延迟ID"] ~= 0 then
        removeDelayedCallback(self["延迟ID"])
        self["延迟ID"] = 0
    end
    if self["参数"]["on取消"] ~= nil then
        self["参数"]["on取消"]()
    end
end
_____70B9_540D_9884_8B66_6267_884C_5668_5B9E_73B0.prototype["结算"] = function(self)
    if self["已取消"] then
        return
    end
    self["已取消"] = true
    self["延迟ID"] = 0
    if self["参数"]["锁定坐标"] == false and self["参数"]["目标"] ~= nil and self["参数"]["目标"] ~= 0 then
        self["结果"]["锁定X"] = GetUnitX(self["参数"]["目标"])
        self["结果"]["锁定Y"] = GetUnitY(self["参数"]["目标"])
    end
    self["参数"]["on结算"](self["结果"])
end
_____70B9_540D_9884_8B66_6267_884C_5668_5B9E_73B0.prototype["创建提示圈"] = function(self)
    local _____63D0_793A_5708 = self["参数"]["提示圈"]
    if _____63D0_793A_5708 == false or _____63D0_793A_5708 == nil then
        return
    end
    local ____temp_1
    if type(_____63D0_793A_5708) == "function" then
        ____temp_1 = _____63D0_793A_5708(self["结果"])
    else
        ____temp_1 = _____63D0_793A_5708
    end
    local _____914D_7F6E = ____temp_1
    if _____914D_7F6E == false then
        return
    end
    _____521B_5EFA_6280_80FD_63D0_793A_5708(__TS__ObjectAssign({}, _____914D_7F6E, {X = _____914D_7F6E.X or _____914D_7F6E.x or self["结果"]["锁定X"], Y = _____914D_7F6E.Y or _____914D_7F6E.y or self["结果"]["锁定Y"], ["持续时间"] = _____914D_7F6E["持续时间"] or self["参数"]["延迟秒"]}))
end
____exports["创建点名预警执行器"] = function(_____53C2_6570)
    local _____6267_884C_5668 = __TS__New(_____70B9_540D_9884_8B66_6267_884C_5668_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_2 = _____53C2_6570["清理"]
        ____self_2["登记清理"](
            ____self_2,
            _____53C2_6570["名称"],
            function()
                _____6267_884C_5668["取消"](_____6267_884C_5668)
            end
        )
    end
    return _____6267_884C_5668
end
return ____exports
