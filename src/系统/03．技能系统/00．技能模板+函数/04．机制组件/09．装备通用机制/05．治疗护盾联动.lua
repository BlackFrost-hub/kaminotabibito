local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local registerAppliedFinalHealListener = ____require_result_0.registerAppliedFinalHealListener
local _____6CBB_7597_62A4_76FE_8054_52A8_8868 = {}
local _____6CBB_7597_62A4_76FE_8054_52A8_8BA1_6570 = 0
local _____6CBB_7597_62A4_76FE_8054_52A8_5B9E_73B0 = __TS__Class()
_____6CBB_7597_62A4_76FE_8054_52A8_5B9E_73B0.name = "治疗护盾联动实现"
function _____6CBB_7597_62A4_76FE_8054_52A8_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____53C2_6570)
    self["已停止"] = false
    self["名称"] = _____540D_79F0
    self["参数"] = _____53C2_6570
    _____6CBB_7597_62A4_76FE_8054_52A8_8BA1_6570 = _____6CBB_7597_62A4_76FE_8054_52A8_8BA1_6570 + 1
    self["控制器ID"] = _____6CBB_7597_62A4_76FE_8054_52A8_8BA1_6570
    _____6CBB_7597_62A4_76FE_8054_52A8_8868[self["控制器ID"]] = self
end
_____6CBB_7597_62A4_76FE_8054_52A8_5B9E_73B0.prototype["处理治疗"] = function(self, event)
    if self["已停止"] or self["参数"]["on治疗"] == nil or not self["匹配单位"](self, event) then
        return
    end
    if self["参数"]["过滤事件"] ~= nil and not self["参数"]["过滤事件"](event) then
        return
    end
    self["参数"]["on治疗"](event)
end
_____6CBB_7597_62A4_76FE_8054_52A8_5B9E_73B0.prototype["处理护盾"] = function(self, event)
    if self["已停止"] or self["参数"]["on护盾"] == nil or not self["匹配单位"](self, event) then
        return
    end
    if self["参数"]["过滤事件"] ~= nil and not self["参数"]["过滤事件"](event) then
        return
    end
    self["参数"]["on护盾"](event)
end
_____6CBB_7597_62A4_76FE_8054_52A8_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    __TS__Delete(_____6CBB_7597_62A4_76FE_8054_52A8_8868, self["控制器ID"])
end
_____6CBB_7597_62A4_76FE_8054_52A8_5B9E_73B0.prototype["匹配单位"] = function(self, event)
    if self["参数"]["单位"] == nil then
        return true
    end
    local _____65B9_5411 = self["参数"]["监听方向"] or "双向"
    if _____65B9_5411 == "自己获得" then
        return event["目标单位"] == self["参数"]["单位"]
    end
    if _____65B9_5411 == "自己给予" then
        return event["来源单位"] == self["参数"]["单位"]
    end
    return event["目标单位"] == self["参数"]["单位"] or event["来源单位"] == self["参数"]["单位"]
end
____exports["创建治疗护盾联动"] = function(_____53C2_6570)
    return __TS__New(_____6CBB_7597_62A4_76FE_8054_52A8_5B9E_73B0, _____53C2_6570["名称"] or "治疗护盾联动", _____53C2_6570)
end
____exports["通知获得护盾事件"] = function(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____6570_503C, _____6807_7B7E, _____539F_59CB_53C2_6570)
    local event = {
        ["来源单位"] = _____6765_6E90_5355_4F4D,
        ["目标单位"] = _____76EE_6807_5355_4F4D,
        ["数值"] = _____6570_503C,
        ["标签"] = _____6807_7B7E,
        ["原始参数"] = _____539F_59CB_53C2_6570
    }
    for key in pairs(_____6CBB_7597_62A4_76FE_8054_52A8_8868) do
        local _____63A7_5236_5668 = _____6CBB_7597_62A4_76FE_8054_52A8_8868[key]
        if _____63A7_5236_5668 ~= nil then
            _____63A7_5236_5668["处理护盾"](_____63A7_5236_5668, event)
        end
    end
end
local function ____on_6700_7EC8_6CBB_7597_8054_52A8(source, target, amount, isItemHeal)
    if amount <= 0 then
        return
    end
    local event = {["来源单位"] = source, ["目标单位"] = target, ["数值"] = amount, ["是否物品治疗"] = isItemHeal}
    for key in pairs(_____6CBB_7597_62A4_76FE_8054_52A8_8868) do
        local _____63A7_5236_5668 = _____6CBB_7597_62A4_76FE_8054_52A8_8868[key]
        if _____63A7_5236_5668 ~= nil then
            _____63A7_5236_5668["处理治疗"](_____63A7_5236_5668, event)
        end
    end
end
registerAppliedFinalHealListener(____on_6700_7EC8_6CBB_7597_8054_52A8)
return ____exports
