local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local _____63A7_5236Debuff_8054_52A8_8868 = {}
local _____63A7_5236Debuff_8054_52A8_8BA1_6570 = 0
local _____63A7_5236Debuff_8054_52A8_5B9E_73B0 = __TS__Class()
_____63A7_5236Debuff_8054_52A8_5B9E_73B0.name = "控制Debuff联动实现"
function _____63A7_5236Debuff_8054_52A8_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____53C2_6570)
    self["已停止"] = false
    self["名称"] = _____540D_79F0
    self["参数"] = _____53C2_6570
    _____63A7_5236Debuff_8054_52A8_8BA1_6570 = _____63A7_5236Debuff_8054_52A8_8BA1_6570 + 1
    self["控制器ID"] = _____63A7_5236Debuff_8054_52A8_8BA1_6570
    _____63A7_5236Debuff_8054_52A8_8868[self["控制器ID"]] = self
end
_____63A7_5236Debuff_8054_52A8_5B9E_73B0.prototype["处理"] = function(self, event)
    if self["已停止"] then
        return
    end
    if self["参数"]["只监听控制"] == true and event["是否控制"] ~= true then
        return
    end
    if not self["匹配单位"](self, event) then
        return
    end
    if self["参数"]["过滤事件"] ~= nil and not self["参数"]["过滤事件"](event) then
        return
    end
    self["参数"]["on触发"](event)
end
_____63A7_5236Debuff_8054_52A8_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    __TS__Delete(_____63A7_5236Debuff_8054_52A8_8868, self["控制器ID"])
end
_____63A7_5236Debuff_8054_52A8_5B9E_73B0.prototype["匹配单位"] = function(self, event)
    if self["参数"]["单位"] == nil then
        return true
    end
    local _____65B9_5411 = self["参数"]["监听方向"] or "自己施加"
    if _____65B9_5411 == "自己施加" then
        return event["来源单位"] == self["参数"]["单位"]
    end
    if _____65B9_5411 == "自己受到" then
        return event["目标单位"] == self["参数"]["单位"]
    end
    return event["来源单位"] == self["参数"]["单位"] or event["目标单位"] == self["参数"]["单位"]
end
____exports["创建控制Debuff联动"] = function(_____53C2_6570)
    return __TS__New(_____63A7_5236Debuff_8054_52A8_5B9E_73B0, _____53C2_6570["名称"] or "控制Debuff联动", _____53C2_6570)
end
____exports["通知控制Debuff事件"] = function(event)
    for key in pairs(_____63A7_5236Debuff_8054_52A8_8868) do
        local _____63A7_5236_5668 = _____63A7_5236Debuff_8054_52A8_8868[key]
        if _____63A7_5236_5668 ~= nil then
            _____63A7_5236_5668["处理"](_____63A7_5236_5668, event)
        end
    end
end
return ____exports
