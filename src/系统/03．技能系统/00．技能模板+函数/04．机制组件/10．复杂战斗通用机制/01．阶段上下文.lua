local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____01_FF0E_8840_91CF_8282_70B9_89E6_53D1_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.01．血量节点触发器")
local _____521B_5EFA_8840_91CF_8282_70B9_89E6_53D1_5668 = ____01_FF0E_8840_91CF_8282_70B9_89E6_53D1_5668["创建血量节点触发器"]
local _____9636_6BB5_4E0A_4E0B_6587_5B9E_73B0 = __TS__Class()
_____9636_6BB5_4E0A_4E0B_6587_5B9E_73B0.name = "阶段上下文实现"
function _____9636_6BB5_4E0A_4E0B_6587_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["阶段表"] = {}
    self["已销毁"] = false
    self["参数"] = _____53C2_6570
    self["单位"] = _____53C2_6570["单位"]
    self["当前阶段ID"] = _____53C2_6570["初始阶段ID"]
    do
        local i = 0
        while i < #_____53C2_6570["阶段列表"] do
            local _____9636_6BB5 = _____53C2_6570["阶段列表"][i + 1]
            self["阶段表"][_____9636_6BB5.ID] = _____9636_6BB5
            i = i + 1
        end
    end
    self["创建血量触发器"](self)
end
_____9636_6BB5_4E0A_4E0B_6587_5B9E_73B0.prototype["取阶段ID"] = function(self)
    return self["当前阶段ID"]
end
_____9636_6BB5_4E0A_4E0B_6587_5B9E_73B0.prototype["是阶段"] = function(self, _____9636_6BB5ID)
    return self["当前阶段ID"] == _____9636_6BB5ID
end
_____9636_6BB5_4E0A_4E0B_6587_5B9E_73B0.prototype["手动进入阶段"] = function(self, _____9636_6BB5ID, _____5F53_524D_767E_5206_6BD4)
    if _____5F53_524D_767E_5206_6BD4 == nil then
        _____5F53_524D_767E_5206_6BD4 = 1
    end
    if self["已销毁"] or _____9636_6BB5ID == "" or _____9636_6BB5ID == self["当前阶段ID"] then
        return false
    end
    local _____9636_6BB5 = self["阶段表"][_____9636_6BB5ID]
    if _____9636_6BB5 == nil then
        return false
    end
    local _____65E7_9636_6BB5ID = self["当前阶段ID"]
    self["当前阶段ID"] = _____9636_6BB5ID
    if self["参数"]["on阶段变化"] ~= nil then
        self["参数"]["on阶段变化"](_____9636_6BB5ID, _____65E7_9636_6BB5ID, _____5F53_524D_767E_5206_6BD4)
    end
    if _____9636_6BB5["on进入"] ~= nil then
        _____9636_6BB5["on进入"](self, _____5F53_524D_767E_5206_6BD4)
    end
    return true
end
_____9636_6BB5_4E0A_4E0B_6587_5B9E_73B0.prototype["销毁"] = function(self)
    if self["已销毁"] then
        return
    end
    self["已销毁"] = true
    if self["触发器"] ~= nil then
        local ____self_0 = self["触发器"]
        ____self_0["停止"](____self_0)
    end
end
_____9636_6BB5_4E0A_4E0B_6587_5B9E_73B0.prototype["创建血量触发器"] = function(self)
    local _____8282_70B9_5217_8868 = {}
    do
        local i = 0
        while i < #self["参数"]["阶段列表"] do
            do
                local _____9636_6BB5 = self["参数"]["阶段列表"][i + 1]
                if _____9636_6BB5["血量百分比"] == nil then
                    goto __continue17
                end
                local ____self = self
                _____8282_70B9_5217_8868[#_____8282_70B9_5217_8868 + 1] = {
                    ID = _____9636_6BB5.ID,
                    ["百分比"] = _____9636_6BB5["血量百分比"],
                    ["on触发"] = function(______5355_4F4D, _____5F53_524D_767E_5206_6BD4)
                        ____self["手动进入阶段"](____self, _____9636_6BB5.ID, _____5F53_524D_767E_5206_6BD4)
                    end
                }
            end
            ::__continue17::
            i = i + 1
        end
    end
    if #_____8282_70B9_5217_8868 <= 0 then
        return
    end
    self["触发器"] = _____521B_5EFA_8840_91CF_8282_70B9_89E6_53D1_5668({
        ["清理"] = self["参数"]["清理"],
        ["名称"] = self["参数"]["名称"] .. "-阶段节点",
        ["单位"] = self["参数"]["单位"],
        ["节点列表"] = _____8282_70B9_5217_8868,
        ["Tick间隔毫秒"] = self["参数"]["Tick间隔毫秒"]
    })
end
____exports["创建阶段上下文"] = function(_____53C2_6570)
    local _____4E0A_4E0B_6587 = __TS__New(_____9636_6BB5_4E0A_4E0B_6587_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_1 = _____53C2_6570["清理"]
        ____self_1["登记清理"](
            ____self_1,
            _____53C2_6570["名称"] .. "-阶段上下文",
            function()
                _____4E0A_4E0B_6587["销毁"](_____4E0A_4E0B_6587)
            end
        )
    end
    return _____4E0A_4E0B_6587
end
return ____exports
