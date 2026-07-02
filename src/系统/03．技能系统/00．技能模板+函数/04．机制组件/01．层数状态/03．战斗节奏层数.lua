local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____01_FF0E_53EF_914D_7F6E_5C42_6570_72B6_6001 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.01．层数状态.01．可配置层数状态")
local _____521B_5EFA_53EF_914D_7F6E_5C42_6570_72B6_6001 = ____01_FF0E_53EF_914D_7F6E_5C42_6570_72B6_6001["创建可配置层数状态"]
local jass = require("jass.common")
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local function _____5355_4F4D_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true
end
local _____6218_6597_8282_594F_5C42_6570_63A7_5236_5668_5B9E_73B0 = __TS__Class()
_____6218_6597_8282_594F_5C42_6570_63A7_5236_5668_5B9E_73B0.name = "战斗节奏层数控制器实现"
function _____6218_6597_8282_594F_5C42_6570_63A7_5236_5668_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____53C2_6570)
    self["周期回调ID"] = 0
    self["已停止"] = false
    self["下次叠层毫秒"] = 0
    self["名称"] = _____540D_79F0
    self["参数"] = _____53C2_6570
    self["层数控制器"] = _____521B_5EFA_53EF_914D_7F6E_5C42_6570_72B6_6001(_____53C2_6570)
end
_____6218_6597_8282_594F_5C42_6570_63A7_5236_5668_5B9E_73B0.prototype["设置周期回调ID"] = function(self, id)
    self["周期回调ID"] = id
end
_____6218_6597_8282_594F_5C42_6570_63A7_5236_5668_5B9E_73B0.prototype["读取当前层数"] = function(self)
    local ____self_1 = self["层数控制器"]
    return ____self_1["取层数"](____self_1, self["参数"]["单位"])
end
_____6218_6597_8282_594F_5C42_6570_63A7_5236_5668_5B9E_73B0.prototype["刷新"] = function(self)
    if self["已停止"] then
        return self["读取当前层数"](self)
    end
    local _____5355_4F4D = self["参数"]["单位"]
    if not _____5355_4F4D_6709_6548(_____5355_4F4D) then
        local ____self_2 = self["层数控制器"]
        ____self_2["清空"](____self_2, _____5355_4F4D, "单位失效")
        return 0
    end
    local _____5728_6218_6597 = self["参数"]["判断战斗状态"](_____5355_4F4D)
    if not _____5728_6218_6597 then
        self["下次叠层毫秒"] = 0
        if self["参数"]["脱战清空"] ~= false then
            local ____self_3 = self["层数控制器"]
            ____self_3["清空"](____self_3, _____5355_4F4D, "脱离战斗")
        end
        return self["读取当前层数"](self)
    end
    if self["下次叠层毫秒"] <= 0 then
        self["下次叠层毫秒"] = self["参数"]["叠层间隔毫秒"]
        return self["读取当前层数"](self)
    end
    self["下次叠层毫秒"] = self["下次叠层毫秒"] - (self["参数"]["检查间隔毫秒"] or 200)
    if self["下次叠层毫秒"] > 0 then
        return self["读取当前层数"](self)
    end
    local ____self_4 = self["层数控制器"]
    local _____5F53_524D_5C42_6570 = ____self_4["增加"](____self_4, _____5355_4F4D, 1, "战斗节奏叠层")
    self["下次叠层毫秒"] = self["参数"]["叠层间隔毫秒"]
    if self["参数"]["on获得层数"] ~= nil then
        self["参数"]["on获得层数"](_____5F53_524D_5C42_6570)
    end
    return _____5F53_524D_5C42_6570
end
_____6218_6597_8282_594F_5C42_6570_63A7_5236_5668_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    if self["周期回调ID"] ~= 0 then
        removePeriodicCallback(self["周期回调ID"])
        self["周期回调ID"] = 0
    end
    local ____self_5 = self["层数控制器"]
    ____self_5["销毁"](____self_5)
end
____exports["创建战斗节奏层数"] = function(_____53C2_6570)
    local _____540D_79F0 = _____53C2_6570["名称"] or _____53C2_6570["状态ID"] or "战斗节奏层数"
    local _____63A7_5236_5668 = __TS__New(_____6218_6597_8282_594F_5C42_6570_63A7_5236_5668_5B9E_73B0, _____540D_79F0, _____53C2_6570)
    _____63A7_5236_5668["刷新"](_____63A7_5236_5668)
    local _____95F4_9694 = _____53C2_6570["检查间隔毫秒"] or 200
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
                local ____self_6 = _____53C2_6570["清理篮子"]
                ____self_6["登记周期回调"](____self_6, _____540D_79F0 .. "-周期刷新", id)
            else
                local ____self_7 = _____53C2_6570["清理篮子"]
                ____self_7["登记清理"](
                    ____self_7,
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
