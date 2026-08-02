local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____on_9650_65F6_6467_6BC1_76EE_6807_6B7B_4EA1, ____on_9650_65F6_6467_6BC1_76EE_6807_88AB_51FB_6740, ____on_9650_65F6_6467_6BC1_76EE_6807_81EA_7136_5230_671F, ____on_9650_65F6_6467_6BC1_76EE_6807_9500_6BC1, ____on_9650_65F6_6467_6BC1_76EE_6807_7ED3_675F, ____on_9650_65F6_6467_6BC1_76EE_6807_7EC4Tick, getServerTime
local ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D["创建可攻击机制单位"]
function ____on_9650_65F6_6467_6BC1_76EE_6807_6B7B_4EA1(_____5355_4F4D, _____51FB_6740_8005, _____53D8_91CF)
    local _____4E0A_4E0B_6587 = _____53D8_91CF
    if (_____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["原死亡回调"]) ~= nil then
        _____4E0A_4E0B_6587["原死亡回调"](_____5355_4F4D, _____51FB_6740_8005, _____4E0A_4E0B_6587["原变量"])
    end
end
function ____on_9650_65F6_6467_6BC1_76EE_6807_88AB_51FB_6740(_____5355_4F4D, _____51FB_6740_8005, _____53D8_91CF)
    local _____4E0A_4E0B_6587 = _____53D8_91CF
    if (_____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["原被击杀回调"]) ~= nil then
        _____4E0A_4E0B_6587["原被击杀回调"](_____5355_4F4D, _____51FB_6740_8005, _____4E0A_4E0B_6587["原变量"])
    end
end
function ____on_9650_65F6_6467_6BC1_76EE_6807_81EA_7136_5230_671F(_____5355_4F4D, _____53D8_91CF)
    local _____4E0A_4E0B_6587 = _____53D8_91CF
    if (_____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["原自然到期回调"]) ~= nil then
        _____4E0A_4E0B_6587["原自然到期回调"](_____5355_4F4D, _____4E0A_4E0B_6587["原变量"])
    end
end
function ____on_9650_65F6_6467_6BC1_76EE_6807_9500_6BC1(_____5355_4F4D, _____53D8_91CF)
    local _____4E0A_4E0B_6587 = _____53D8_91CF
    if (_____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["原销毁回调"]) ~= nil then
        _____4E0A_4E0B_6587["原销毁回调"](_____5355_4F4D, _____4E0A_4E0B_6587["原变量"])
    end
end
function ____on_9650_65F6_6467_6BC1_76EE_6807_7ED3_675F(_____5355_4F4D, _____539F_56E0, _____51FB_6740_8005, _____53D8_91CF)
    local _____4E0A_4E0B_6587 = _____53D8_91CF
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    if _____4E0A_4E0B_6587["原结束回调"] ~= nil then
        _____4E0A_4E0B_6587["原结束回调"](_____5355_4F4D, _____539F_56E0, _____51FB_6740_8005, _____4E0A_4E0B_6587["原变量"])
    end
    if _____4E0A_4E0B_6587["目标"] ~= nil then
        local ____self_12 = _____4E0A_4E0B_6587["组"]
        ____self_12["处理目标结束"](____self_12, _____4E0A_4E0B_6587["目标"], _____539F_56E0)
    end
end
function ____on_9650_65F6_6467_6BC1_76EE_6807_7EC4Tick(variable)
    local _____5B9E_4F8B = variable
    if _____5B9E_4F8B ~= nil then
        _____5B9E_4F8B["推进"](
            _____5B9E_4F8B,
            getServerTime()
        )
    end
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
local _____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0 = __TS__Class()
_____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0.name = "限时摧毁目标组实现"
function _____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["目标单位列表"] = {}
    self["Tick回调ID"] = 0
    self["已结束"] = false
    self["参数"] = _____53C2_6570
    self["到期Ms"] = getServerTime() + _____53C2_6570["持续秒"] * 1000
    self["创建目标"](self)
    self["Tick回调ID"] = addPeriodicCallback(_____53C2_6570["Tick间隔毫秒"] or 100, ____on_9650_65F6_6467_6BC1_76EE_6807_7EC4Tick, self)
end
_____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0.prototype["取剩余数量"] = function(self)
    local _____6570_91CF = 0
    do
        local i = 0
        while i < #self["目标单位列表"] do
            local _____76EE_6807 = self["目标单位列表"][i + 1]
            if _____76EE_6807["是否存活"](_____76EE_6807) then
                _____6570_91CF = _____6570_91CF + 1
            else
                _____76EE_6807["处理单位失效"](_____76EE_6807)
            end
            i = i + 1
        end
    end
    return _____6570_91CF
end
_____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0.prototype["推进"] = function(self, now)
    if self["已结束"] then
        return
    end
    local _____5269_4F59_6570_91CF = self["取剩余数量"](self)
    if _____5269_4F59_6570_91CF <= 0 then
        if self["参数"]["on全部摧毁"] ~= nil then
            self["参数"]["on全部摧毁"](self["参数"]["变量"])
        end
        self["结束"](self, true, "全部摧毁", 0)
        return
    end
    if now >= self["到期Ms"] then
        if self["参数"]["on超时"] ~= nil then
            self["参数"]["on超时"](_____5269_4F59_6570_91CF, self["参数"]["变量"])
        end
        self["结束"](self, false, "超时", _____5269_4F59_6570_91CF)
    end
end
_____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0.prototype["结束"] = function(self, _____662F_5426_6210_529F, _____539F_56E0, _____7ED3_675F_524D_5269_4F59_6570_91CF)
    if _____539F_56E0 == nil then
        _____539F_56E0 = _____662F_5426_6210_529F and "全部摧毁" or "主动结束"
    end
    if self["已结束"] then
        return
    end
    self["已结束"] = true
    if self["Tick回调ID"] ~= 0 then
        removePeriodicCallback(self["Tick回调ID"])
        self["Tick回调ID"] = 0
    end
    local _____5269_4F59_6570_91CF = _____7ED3_675F_524D_5269_4F59_6570_91CF or self["取剩余数量"](self)
    if not _____662F_5426_6210_529F then
        do
            local i = 0
            while i < #self["目标单位列表"] do
                local ____self_1 = self["目标单位列表"][i + 1]
                if ____self_1["是否存活"](____self_1) then
                    local ____self_2 = self["目标单位列表"][i + 1]
                    ____self_2["销毁"](____self_2, _____539F_56E0 == "机制清理" and "机制清理" or "主动销毁")
                end
                i = i + 1
            end
        end
    end
    if self["参数"]["on结束"] ~= nil then
        self["参数"]["on结束"](_____662F_5426_6210_529F, _____5269_4F59_6570_91CF, self["参数"]["变量"], _____539F_56E0)
    end
end
_____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0.prototype["创建目标"] = function(self)
    do
        local i = 0
        while i < #self["参数"]["目标列表"] do
            local _____539F_53C2_6570 = self["参数"]["目标列表"][i + 1]
            local _____76EE_6807_4E0A_4E0B_6587 = {
                ["组"] = self,
                ["原结束回调"] = _____539F_53C2_6570["on结束"],
                ["原死亡回调"] = _____539F_53C2_6570["on死亡"],
                ["原被击杀回调"] = _____539F_53C2_6570["on被击杀"],
                ["原自然到期回调"] = _____539F_53C2_6570["on自然到期"],
                ["原销毁回调"] = _____539F_53C2_6570["on销毁"],
                ["原变量"] = _____539F_53C2_6570["变量"]
            }
            local _____76EE_6807_53C2_6570 = __TS__ObjectAssign({}, _____539F_53C2_6570, {
                ["变量"] = _____76EE_6807_4E0A_4E0B_6587,
                ["on死亡"] = ____on_9650_65F6_6467_6BC1_76EE_6807_6B7B_4EA1,
                ["on被击杀"] = ____on_9650_65F6_6467_6BC1_76EE_6807_88AB_51FB_6740,
                ["on自然到期"] = ____on_9650_65F6_6467_6BC1_76EE_6807_81EA_7136_5230_671F,
                ["on销毁"] = ____on_9650_65F6_6467_6BC1_76EE_6807_9500_6BC1,
                ["on结束"] = ____on_9650_65F6_6467_6BC1_76EE_6807_7ED3_675F
            })
            local _____76EE_6807 = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D(_____76EE_6807_53C2_6570)
            if _____76EE_6807 ~= nil then
                _____76EE_6807_4E0A_4E0B_6587["目标"] = _____76EE_6807
                local ____self__76EE_6807_5355_4F4D_5217_8868_3 = self["目标单位列表"]
                ____self__76EE_6807_5355_4F4D_5217_8868_3[#____self__76EE_6807_5355_4F4D_5217_8868_3 + 1] = _____76EE_6807
            end
            i = i + 1
        end
    end
end
_____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0.prototype["处理目标结束"] = function(self, _____76EE_6807, _____539F_56E0)
    if self["已结束"] then
        return
    end
    if self["参数"]["on目标结束"] ~= nil then
        self["参数"]["on目标结束"](_____76EE_6807, _____539F_56E0, self["参数"]["变量"])
    end
    if self["已结束"] then
        return
    end
    if self["取剩余数量"](self) <= 0 then
        if self["参数"]["on全部摧毁"] ~= nil then
            self["参数"]["on全部摧毁"](self["参数"]["变量"])
        end
        self["结束"](self, true, "全部摧毁", 0)
    end
end
____exports["创建限时摧毁目标组"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_13 = _____53C2_6570["清理"]
        ____self_13["登记清理"](
            ____self_13,
            _____53C2_6570["名称"],
            function()
                _____5B9E_4F8B["结束"](_____5B9E_4F8B, false, "机制清理")
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
