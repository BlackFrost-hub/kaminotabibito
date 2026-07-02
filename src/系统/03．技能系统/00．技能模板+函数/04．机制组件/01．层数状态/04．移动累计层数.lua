local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____01_FF0E_53EF_914D_7F6E_5C42_6570_72B6_6001 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.01．层数状态.01．可配置层数状态")
local _____521B_5EFA_53EF_914D_7F6E_5C42_6570_72B6_6001 = ____01_FF0E_53EF_914D_7F6E_5C42_6570_72B6_6001["创建可配置层数状态"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitCurrentOrder = jass.GetUnitCurrentOrder
local IsUnitType = jass.IsUnitType
local OrderId = jass.OrderId
local R2I = jass.R2I
local SquareRoot = jass.SquareRoot
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____653B_51FB_547D_4EE4_540E_5907ID = 851983
local _____79FB_52A8_547D_4EE4_540E_5907ID = 851971
local _____667A_80FD_547D_4EE4_540E_5907ID = 851986
local _____7F13_5B58_653B_51FB_547D_4EE4ID = 0
local _____7F13_5B58_79FB_52A8_547D_4EE4ID = 0
local _____7F13_5B58_667A_80FD_547D_4EE4ID = 0
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local function _____5355_4F4D_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true
end
local function _____4E24_70B9_8DDD_79BB(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return SquareRoot(dx * dx + dy * dy)
end
local function _____53D6_667A_80FD_547D_4EE4ID()
    if _____7F13_5B58_667A_80FD_547D_4EE4ID ~= 0 then
        return _____7F13_5B58_667A_80FD_547D_4EE4ID
    end
    local _____547D_4EE4ID = OrderId("smart")
    _____7F13_5B58_667A_80FD_547D_4EE4ID = _____547D_4EE4ID ~= 0 and _____547D_4EE4ID or _____667A_80FD_547D_4EE4_540E_5907ID
    return _____7F13_5B58_667A_80FD_547D_4EE4ID
end
local function _____53D6_653B_51FB_547D_4EE4ID()
    if _____7F13_5B58_653B_51FB_547D_4EE4ID ~= 0 then
        return _____7F13_5B58_653B_51FB_547D_4EE4ID
    end
    local _____547D_4EE4ID = OrderId("attack")
    _____7F13_5B58_653B_51FB_547D_4EE4ID = _____547D_4EE4ID ~= 0 and _____547D_4EE4ID or _____653B_51FB_547D_4EE4_540E_5907ID
    return _____7F13_5B58_653B_51FB_547D_4EE4ID
end
local function _____53D6_79FB_52A8_547D_4EE4ID()
    if _____7F13_5B58_79FB_52A8_547D_4EE4ID ~= 0 then
        return _____7F13_5B58_79FB_52A8_547D_4EE4ID
    end
    local _____547D_4EE4ID = OrderId("move")
    _____7F13_5B58_79FB_52A8_547D_4EE4ID = _____547D_4EE4ID ~= 0 and _____547D_4EE4ID or _____79FB_52A8_547D_4EE4_540E_5907ID
    return _____7F13_5B58_79FB_52A8_547D_4EE4ID
end
local function _____5355_4F4D_5F53_524D_547D_4EE4_5141_8BB8_7D2F_8BA1_79FB_52A8(_____5355_4F4D)
    local _____5F53_524D_547D_4EE4ID = GetUnitCurrentOrder(_____5355_4F4D)
    return _____5F53_524D_547D_4EE4ID == _____53D6_667A_80FD_547D_4EE4ID() or _____5F53_524D_547D_4EE4ID == _____53D6_653B_51FB_547D_4EE4ID() or _____5F53_524D_547D_4EE4ID == _____53D6_79FB_52A8_547D_4EE4ID()
end
local _____79FB_52A8_7D2F_8BA1_5C42_6570_63A7_5236_5668_5B9E_73B0 = __TS__Class()
_____79FB_52A8_7D2F_8BA1_5C42_6570_63A7_5236_5668_5B9E_73B0.name = "移动累计层数控制器实现"
function _____79FB_52A8_7D2F_8BA1_5C42_6570_63A7_5236_5668_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____53C2_6570)
    self["周期回调ID"] = 0
    self["已停止"] = false
    self["上次X"] = 0
    self["上次Y"] = 0
    self["累计距离"] = 0
    self["名称"] = _____540D_79F0
    self["参数"] = _____53C2_6570
    self["层数控制器"] = _____521B_5EFA_53EF_914D_7F6E_5C42_6570_72B6_6001(_____53C2_6570)
    if _____5355_4F4D_6709_6548(_____53C2_6570["单位"]) then
        self["上次X"] = GetUnitX(_____53C2_6570["单位"])
        self["上次Y"] = GetUnitY(_____53C2_6570["单位"])
    end
end
_____79FB_52A8_7D2F_8BA1_5C42_6570_63A7_5236_5668_5B9E_73B0.prototype["设置周期回调ID"] = function(self, id)
    self["周期回调ID"] = id
end
_____79FB_52A8_7D2F_8BA1_5C42_6570_63A7_5236_5668_5B9E_73B0.prototype["读取当前层数"] = function(self)
    local ____self_1 = self["层数控制器"]
    return ____self_1["取层数"](____self_1, self["参数"]["单位"])
end
_____79FB_52A8_7D2F_8BA1_5C42_6570_63A7_5236_5668_5B9E_73B0.prototype["读取累计距离"] = function(self)
    return self["累计距离"]
end
_____79FB_52A8_7D2F_8BA1_5C42_6570_63A7_5236_5668_5B9E_73B0.prototype["重置累计距离"] = function(self)
    self["累计距离"] = 0
end
_____79FB_52A8_7D2F_8BA1_5C42_6570_63A7_5236_5668_5B9E_73B0.prototype["刷新"] = function(self)
    if self["已停止"] then
        return self["读取当前层数"](self)
    end
    local _____5355_4F4D = self["参数"]["单位"]
    if not _____5355_4F4D_6709_6548(_____5355_4F4D) then
        local ____self_2 = self["层数控制器"]
        ____self_2["清空"](____self_2, _____5355_4F4D, "单位失效")
        self["累计距离"] = 0
        return 0
    end
    if not _____5355_4F4D_5F53_524D_547D_4EE4_5141_8BB8_7D2F_8BA1_79FB_52A8(_____5355_4F4D) then
        self["上次X"] = GetUnitX(_____5355_4F4D)
        self["上次Y"] = GetUnitY(_____5355_4F4D)
        return self["读取当前层数"](self)
    end
    if self["参数"]["判断允许累计"] ~= nil and not self["参数"]["判断允许累计"](_____5355_4F4D) then
        self["上次X"] = GetUnitX(_____5355_4F4D)
        self["上次Y"] = GetUnitY(_____5355_4F4D)
        return self["读取当前层数"](self)
    end
    local _____5F53_524DX = GetUnitX(_____5355_4F4D)
    local _____5F53_524DY = GetUnitY(_____5355_4F4D)
    local _____4F4D_79FB = _____4E24_70B9_8DDD_79BB(self["上次X"], self["上次Y"], _____5F53_524DX, _____5F53_524DY)
    self["上次X"] = _____5F53_524DX
    self["上次Y"] = _____5F53_524DY
    local _____6700_5C0F_8BA1_6570_4F4D_79FB = self["参数"]["最小计数位移"] or 1
    if _____4F4D_79FB < _____6700_5C0F_8BA1_6570_4F4D_79FB then
        return self["读取当前层数"](self)
    end
    self["累计距离"] = self["累计距离"] + _____4F4D_79FB
    if self["累计距离"] < self["参数"]["每层距离"] then
        return self["读取当前层数"](self)
    end
    local _____83B7_5F97_5C42_6570 = R2I(self["累计距离"] / self["参数"]["每层距离"])
    local ____self_3 = self["层数控制器"]
    local _____5F53_524D_5C42_6570 = ____self_3["增加"](____self_3, _____5355_4F4D, _____83B7_5F97_5C42_6570, "移动累计叠层")
    if self["参数"]["保留余数"] == false then
        self["累计距离"] = 0
    else
        self["累计距离"] = self["累计距离"] - _____83B7_5F97_5C42_6570 * self["参数"]["每层距离"]
    end
    if self["参数"]["on获得层数"] ~= nil then
        self["参数"]["on获得层数"](_____5F53_524D_5C42_6570)
    end
    return _____5F53_524D_5C42_6570
end
_____79FB_52A8_7D2F_8BA1_5C42_6570_63A7_5236_5668_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    if self["周期回调ID"] ~= 0 then
        removePeriodicCallback(self["周期回调ID"])
        self["周期回调ID"] = 0
    end
    local ____self_4 = self["层数控制器"]
    ____self_4["销毁"](____self_4)
end
____exports["创建移动累计层数"] = function(_____53C2_6570)
    local _____540D_79F0 = _____53C2_6570["名称"] or _____53C2_6570["状态ID"] or "移动累计层数"
    local _____63A7_5236_5668 = __TS__New(_____79FB_52A8_7D2F_8BA1_5C42_6570_63A7_5236_5668_5B9E_73B0, _____540D_79F0, _____53C2_6570)
    local _____95F4_9694 = _____53C2_6570["检查间隔毫秒"] or 100
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
                local ____self_5 = _____53C2_6570["清理篮子"]
                ____self_5["登记周期回调"](____self_5, _____540D_79F0 .. "-周期刷新", id)
            else
                local ____self_6 = _____53C2_6570["清理篮子"]
                ____self_6["登记清理"](
                    ____self_6,
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
