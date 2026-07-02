local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local function _____5355_4F4D_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true
end
local function _____8BFB_53D6_5217_8868(_____53C2_6570)
    if _____53C2_6570["读取单位列表"] ~= nil then
        return _____53C2_6570["读取单位列表"]()
    end
    return _____53C2_6570["单位列表"] or ({})
end
local function _____7EDF_8BA1_6570_91CF(_____53C2_6570)
    local _____5217_8868 = _____8BFB_53D6_5217_8868(_____53C2_6570)
    local _____6570_91CF = 0
    do
        local i = 0
        while i < #_____5217_8868 do
            do
                local _____5355_4F4D = _____5217_8868[i + 1]
                if not _____5355_4F4D_6709_6548(_____5355_4F4D) then
                    goto __continue7
                end
                if _____53C2_6570["过滤单位"] ~= nil and not _____53C2_6570["过滤单位"](_____5355_4F4D) then
                    goto __continue7
                end
                _____6570_91CF = _____6570_91CF + 1
            end
            ::__continue7::
            i = i + 1
        end
    end
    return _____6570_91CF
end
local _____5355_4F4D_6570_91CF_72B6_6001_76D1_542C_63A7_5236_5668_5B9E_73B0 = __TS__Class()
_____5355_4F4D_6570_91CF_72B6_6001_76D1_542C_63A7_5236_5668_5B9E_73B0.name = "单位数量状态监听控制器实现"
function _____5355_4F4D_6570_91CF_72B6_6001_76D1_542C_63A7_5236_5668_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____53C2_6570)
    self["当前数量"] = -1
    self["周期回调ID"] = 0
    self["已停止"] = false
    self["名称"] = _____540D_79F0
    self["参数"] = _____53C2_6570
end
_____5355_4F4D_6570_91CF_72B6_6001_76D1_542C_63A7_5236_5668_5B9E_73B0.prototype["设置周期回调ID"] = function(self, id)
    self["周期回调ID"] = id
end
_____5355_4F4D_6570_91CF_72B6_6001_76D1_542C_63A7_5236_5668_5B9E_73B0.prototype["刷新"] = function(self)
    if self["已停止"] then
        return self["当前数量"]
    end
    local _____4E0A_6B21_6570_91CF = self["当前数量"]
    local _____5F53_524D_6570_91CF = _____7EDF_8BA1_6570_91CF(self["参数"])
    self["当前数量"] = _____5F53_524D_6570_91CF
    if self["参数"]["on刷新"] ~= nil then
        self["参数"]["on刷新"](_____5F53_524D_6570_91CF)
    end
    if _____4E0A_6B21_6570_91CF ~= -1 and _____5F53_524D_6570_91CF ~= _____4E0A_6B21_6570_91CF and self["参数"]["on数量变化"] ~= nil then
        self["参数"]["on数量变化"](_____5F53_524D_6570_91CF, _____4E0A_6B21_6570_91CF)
    end
    return _____5F53_524D_6570_91CF
end
_____5355_4F4D_6570_91CF_72B6_6001_76D1_542C_63A7_5236_5668_5B9E_73B0.prototype["读取当前数量"] = function(self)
    return self["当前数量"] < 0 and 0 or self["当前数量"]
end
_____5355_4F4D_6570_91CF_72B6_6001_76D1_542C_63A7_5236_5668_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    if self["周期回调ID"] ~= 0 then
        removePeriodicCallback(self["周期回调ID"])
        self["周期回调ID"] = 0
    end
end
____exports["创建单位数量状态监听"] = function(_____53C2_6570)
    local _____540D_79F0 = _____53C2_6570["名称"] or "单位数量状态监听"
    local _____63A7_5236_5668 = __TS__New(_____5355_4F4D_6570_91CF_72B6_6001_76D1_542C_63A7_5236_5668_5B9E_73B0, _____540D_79F0, _____53C2_6570)
    _____63A7_5236_5668["刷新"](_____63A7_5236_5668)
    local _____95F4_9694 = _____53C2_6570["监听间隔毫秒"] or 500
    if _____95F4_9694 > 0 then
        local id = addPeriodicCallback(
            _____95F4_9694,
            function()
                _____63A7_5236_5668["刷新"](_____63A7_5236_5668)
            end
        )
        _____63A7_5236_5668["设置周期回调ID"](_____63A7_5236_5668, id)
        if _____53C2_6570["清理篮子"] ~= nil then
            if _____53C2_6570["清理篮子"]["登记周期回调"] ~= nil then
                local ____self_1 = _____53C2_6570["清理篮子"]
                ____self_1["登记周期回调"](____self_1, _____540D_79F0 .. "-周期刷新", id)
            else
                local ____self_2 = _____53C2_6570["清理篮子"]
                ____self_2["登记清理"](
                    ____self_2,
                    _____540D_79F0 .. "-停止",
                    function()
                        _____63A7_5236_5668["停止"](_____63A7_5236_5668)
                    end
                )
            end
        end
    end
    return _____63A7_5236_5668
end
return ____exports
