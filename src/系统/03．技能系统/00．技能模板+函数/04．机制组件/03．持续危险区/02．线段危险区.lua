local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____on_7EBF_6BB5_5371_9669_533ATick, getServerTime
local ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382["创建技能提示圈"]
function ____on_7EBF_6BB5_5371_9669_533ATick(variable)
    local _____5B9E_4F8B = variable
    if _____5B9E_4F8B ~= nil then
        _____5B9E_4F8B["推进"](
            _____5B9E_4F8B,
            getServerTime()
        )
    end
end
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ____require_result_0 = require("lib.扩展函数.BJ函数.12．数学函数")
local CosBJ = ____require_result_0.CosBJ
local SinBJ = ____require_result_0.SinBJ
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isValidUnit = ____require_result_2.isValidUnit
local function _____7EDD_5BF9_503C(value)
    return value >= 0 and value or -value
end
local function _____524D_5411_8DDD_79BB_5728_8303_56F4_5185(value, _____957F_5EA6)
    return value >= 0 and value <= _____957F_5EA6
end
local _____7EBF_6BB5_5371_9669_533A_5B9E_73B0 = __TS__Class()
_____7EBF_6BB5_5371_9669_533A_5B9E_73B0.name = "线段危险区实现"
function _____7EBF_6BB5_5371_9669_533A_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["单位状态表"] = {}
    self["Tick回调ID"] = 0
    self["已停止"] = false
    self["参数"] = _____53C2_6570
    self["到期Ms"] = getServerTime() + _____53C2_6570["持续秒"] * 1000
    self["前向X"] = CosBJ(_____53C2_6570["方向角"])
    self["前向Y"] = SinBJ(_____53C2_6570["方向角"])
    self["右向X"] = CosBJ(_____53C2_6570["方向角"] - 90)
    self["右向Y"] = SinBJ(_____53C2_6570["方向角"] - 90)
    self["创建提示圈"](self)
    self["Tick回调ID"] = addPeriodicCallback(_____53C2_6570["Tick间隔毫秒"] or 100, ____on_7EBF_6BB5_5371_9669_533ATick, self)
end
_____7EBF_6BB5_5371_9669_533A_5B9E_73B0.prototype["推进"] = function(self, now)
    if self["已停止"] then
        return
    end
    if now >= self["到期Ms"] then
        self["停止"](self)
        return
    end
    local _____5355_4F4D_5217_8868 = self["参数"]["单位列表"](self["参数"]["变量"])
    do
        local i = 0
        while i < #_____5355_4F4D_5217_8868 do
            do
                local _____5355_4F4D = _____5355_4F4D_5217_8868[i + 1]
                if not isValidUnit(_____5355_4F4D) then
                    goto __continue9
                end
                self["推进单位"](self, now, _____5355_4F4D)
            end
            ::__continue9::
            i = i + 1
        end
    end
end
_____7EBF_6BB5_5371_9669_533A_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    if self["Tick回调ID"] ~= 0 then
        removePeriodicCallback(self["Tick回调ID"])
        self["Tick回调ID"] = 0
    end
    if self["参数"]["on结束"] ~= nil then
        self["参数"]["on结束"]()
    end
end
_____7EBF_6BB5_5371_9669_533A_5B9E_73B0.prototype["推进单位"] = function(self, now, _____5355_4F4D)
    local id = jass.GetHandleId(_____5355_4F4D)
    local dx = GetUnitX(_____5355_4F4D) - self["参数"]["起点X"]
    local dy = GetUnitY(_____5355_4F4D) - self["参数"]["起点Y"]
    local _____524D_5411_8DDD_79BB = dx * self["前向X"] + dy * self["前向Y"]
    local _____6A2A_5411_8DDD_79BB = dx * self["右向X"] + dy * self["右向Y"]
    local _____5F53_524D_5728_5185_90E8 = self["是否在内部"](
        self,
        GetUnitX(_____5355_4F4D),
        GetUnitY(_____5355_4F4D)
    )
    local _____72B6_6001 = self["单位状态表"][id]
    if _____72B6_6001 == nil then
        _____72B6_6001 = {
            ["在内部"] = false,
            ["下次周期Ms"] = 0,
            ["已采样"] = false,
            ["上次前向距离"] = _____524D_5411_8DDD_79BB,
            ["上次侧向符号"] = 0,
            ["下次穿越Ms"] = 0
        }
        self["单位状态表"][id] = _____72B6_6001
    end
    local _____5F53_524D_4FA7_5411_7B26_53F7 = _____6A2A_5411_8DDD_79BB < 0 and -1 or (_____6A2A_5411_8DDD_79BB > 0 and 1 or 0)
    local _____771F_6B63_8DE8_7EBF = _____72B6_6001["已采样"] and _____5F53_524D_4FA7_5411_7B26_53F7 ~= 0 and _____72B6_6001["上次侧向符号"] ~= 0 and _____5F53_524D_4FA7_5411_7B26_53F7 ~= _____72B6_6001["上次侧向符号"] and _____524D_5411_8DDD_79BB_5728_8303_56F4_5185(_____72B6_6001["上次前向距离"], self["参数"]["长度"]) and _____524D_5411_8DDD_79BB_5728_8303_56F4_5185(_____524D_5411_8DDD_79BB, self["参数"]["长度"]) and now >= _____72B6_6001["下次穿越Ms"]
    _____72B6_6001["已采样"] = true
    _____72B6_6001["上次前向距离"] = _____524D_5411_8DDD_79BB
    if _____5F53_524D_4FA7_5411_7B26_53F7 ~= 0 then
        _____72B6_6001["上次侧向符号"] = _____5F53_524D_4FA7_5411_7B26_53F7
    end
    if _____5F53_524D_5728_5185_90E8 and not _____72B6_6001["在内部"] then
        _____72B6_6001["在内部"] = true
        _____72B6_6001["下次周期Ms"] = now
        if self["参数"]["on进入"] ~= nil then
            self["参数"]["on进入"](_____5355_4F4D, self["参数"]["变量"])
        end
    elseif not _____5F53_524D_5728_5185_90E8 and _____72B6_6001["在内部"] then
        _____72B6_6001["在内部"] = false
        if self["参数"]["on离开"] ~= nil then
            self["参数"]["on离开"](_____5355_4F4D, self["参数"]["变量"])
        end
    end
    if _____771F_6B63_8DE8_7EBF then
        _____72B6_6001["下次穿越Ms"] = now + (self["参数"]["穿越防抖秒"] or 0) * 1000
        if self["参数"]["on穿越"] ~= nil then
            self["参数"]["on穿越"](_____5355_4F4D, self["参数"]["变量"])
        end
    end
    if _____5F53_524D_5728_5185_90E8 and self["参数"]["on周期"] ~= nil and now >= _____72B6_6001["下次周期Ms"] then
        self["参数"]["on周期"](_____5355_4F4D, self["参数"]["变量"])
        _____72B6_6001["下次周期Ms"] = now + (self["参数"]["周期秒"] or 1) * 1000
    end
end
_____7EBF_6BB5_5371_9669_533A_5B9E_73B0.prototype["是否在内部"] = function(self, x, y)
    local dx = x - self["参数"]["起点X"]
    local dy = y - self["参数"]["起点Y"]
    local _____524D_5411_8DDD_79BB = dx * self["前向X"] + dy * self["前向Y"]
    if _____524D_5411_8DDD_79BB < 0 or _____524D_5411_8DDD_79BB > self["参数"]["长度"] then
        return false
    end
    local _____6A2A_5411_8DDD_79BB = dx * self["右向X"] + dy * self["右向Y"]
    return _____7EDD_5BF9_503C(_____6A2A_5411_8DDD_79BB) <= self["参数"]["宽度"] * 0.5
end
_____7EBF_6BB5_5371_9669_533A_5B9E_73B0.prototype["创建提示圈"] = function(self)
    if self["参数"]["提示圈"] == false then
        return
    end
    _____521B_5EFA_6280_80FD_63D0_793A_5708(__TS__ObjectAssign({
        ["类型"] = "矩形",
        ["宽度"] = self["参数"]["宽度"],
        ["长度"] = self["参数"]["长度"],
        ["朝向"] = self["参数"]["方向角"],
        ["持续时间"] = self["参数"]["持续秒"]
    }, self["参数"]["提示圈"] or ({}), {X = self["参数"]["起点X"], Y = self["参数"]["起点Y"]}))
end
____exports["创建线段危险区"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____7EBF_6BB5_5371_9669_533A_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_3 = _____53C2_6570["清理"]
        ____self_3["登记清理"](
            ____self_3,
            _____53C2_6570["名称"],
            function()
                _____5B9E_4F8B["停止"](_____5B9E_4F8B)
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
