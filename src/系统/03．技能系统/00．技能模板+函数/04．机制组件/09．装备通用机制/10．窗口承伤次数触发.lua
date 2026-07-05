local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.15．单位窗口累计值")
local _____521B_5EFA_7A97_53E3_4E8B_4EF6_8BA1_6570_5668 = ____require_result_2["创建窗口事件计数器"]
local _____7A97_53E3_627F_4F24_6B21_6570_63A7_5236_5668_8868 = {}
local _____7A97_53E3_627F_4F24_6B21_6570_63A7_5236_5668_8BA1_6570 = 0
local function _____5355_4F4D_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_5355_4F4DID(_____5355_4F4D)
    if not _____5355_4F4D_6709_6548(_____5355_4F4D) then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local _____7A97_53E3_627F_4F24_6B21_6570_89E6_53D1_5B9E_73B0 = __TS__Class()
_____7A97_53E3_627F_4F24_6B21_6570_89E6_53D1_5B9E_73B0.name = "窗口承伤次数触发实现"
function _____7A97_53E3_627F_4F24_6B21_6570_89E6_53D1_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____53C2_6570)
    self["状态表"] = {}
    self["已停止"] = false
    self["触发回调中"] = false
    self["名称"] = _____540D_79F0
    self["参数"] = _____53C2_6570
    self["计数器"] = _____521B_5EFA_7A97_53E3_4E8B_4EF6_8BA1_6570_5668(_____540D_79F0)
    _____7A97_53E3_627F_4F24_6B21_6570_63A7_5236_5668_8BA1_6570 = _____7A97_53E3_627F_4F24_6B21_6570_63A7_5236_5668_8BA1_6570 + 1
    self["控制器ID"] = _____7A97_53E3_627F_4F24_6B21_6570_63A7_5236_5668_8BA1_6570
    _____7A97_53E3_627F_4F24_6B21_6570_63A7_5236_5668_8868[self["控制器ID"]] = self
end
_____7A97_53E3_627F_4F24_6B21_6570_89E6_53D1_5B9E_73B0.prototype["处理伤害"] = function(self, target, attacker, applied, snapshot)
    if self["已停止"] or self["触发回调中"] or not (applied > 0) then
        return
    end
    if self["参数"]["单位"] ~= nil and _____53D6_5355_4F4DID(self["参数"]["单位"]) ~= _____53D6_5355_4F4DID(target) then
        return
    end
    local id = _____53D6_5355_4F4DID(target)
    if id == 0 then
        return
    end
    local now = getServerTime()
    local _____72B6_6001 = self["取或建状态"](self, target)
    if now < _____72B6_6001["下次允许毫秒"] then
        return
    end
    local key = tostring(id)
    local ____self_3 = self["计数器"]
    local _____5F53_524D_6B21_6570 = ____self_3["增加"](____self_3, key, self["参数"]["窗口秒"] or 0)
    local _____9608_503C = self["参数"]["次数阈值"]
    local event = {
        ["单位"] = target,
        ["攻击者"] = attacker,
        ["本次伤害"] = applied,
        ["当前次数"] = _____5F53_524D_6B21_6570,
        ["窗口秒"] = self["参数"]["窗口秒"] or 0,
        ["次数阈值"] = _____9608_503C,
        ["伤害快照"] = snapshot
    }
    if self["参数"]["过滤伤害"] ~= nil and not self["参数"]["过滤伤害"](event) then
        local ____self_4 = self["计数器"]
        ____self_4["撤销最近一次"](____self_4, key)
        return
    end
    if not (_____9608_503C > 0) or _____5F53_524D_6B21_6570 < _____9608_503C then
        return
    end
    if self["参数"]["触发后清空"] ~= false then
        local ____self_5 = self["计数器"]
        ____self_5["清空"](____self_5, key)
    end
    local cd = self["参数"]["内置CD秒"] or 0
    if cd > 0 then
        _____72B6_6001["下次允许毫秒"] = now + cd * 1000
    end
    self["触发回调中"] = true
    self["参数"]["on触发"](event)
    self["触发回调中"] = false
end
_____7A97_53E3_627F_4F24_6B21_6570_89E6_53D1_5B9E_73B0.prototype["读取次数"] = function(self, _____5355_4F4D)
    local id = _____53D6_5355_4F4DID(_____5355_4F4D)
    if id == 0 then
        return 0
    end
    local ____self_6 = self["计数器"]
    return ____self_6["读取"](
        ____self_6,
        tostring(id),
        self["参数"]["窗口秒"] or 0
    )
end
_____7A97_53E3_627F_4F24_6B21_6570_89E6_53D1_5B9E_73B0.prototype["清空"] = function(self, _____5355_4F4D)
    if _____5355_4F4D == nil then
        self["状态表"] = {}
        local ____self_7 = self["计数器"]
        ____self_7["清空"](____self_7)
        return
    end
    local id = _____53D6_5355_4F4DID(_____5355_4F4D)
    __TS__Delete(self["状态表"], id)
    local ____self_8 = self["计数器"]
    ____self_8["清空"](
        ____self_8,
        tostring(id)
    )
end
_____7A97_53E3_627F_4F24_6B21_6570_89E6_53D1_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    self["状态表"] = {}
    local ____self_9 = self["计数器"]
    ____self_9["清空"](____self_9)
    __TS__Delete(_____7A97_53E3_627F_4F24_6B21_6570_63A7_5236_5668_8868, self["控制器ID"])
end
_____7A97_53E3_627F_4F24_6B21_6570_89E6_53D1_5B9E_73B0.prototype["取或建状态"] = function(self, _____5355_4F4D)
    local id = _____53D6_5355_4F4DID(_____5355_4F4D)
    local _____72B6_6001 = self["状态表"][id]
    if _____72B6_6001 == nil then
        _____72B6_6001 = {["单位"] = _____5355_4F4D, ["下次允许毫秒"] = 0}
        self["状态表"][id] = _____72B6_6001
    end
    return _____72B6_6001
end
____exports["创建窗口承伤次数触发器"] = function(_____53C2_6570)
    return __TS__New(_____7A97_53E3_627F_4F24_6B21_6570_89E6_53D1_5B9E_73B0, _____53C2_6570["名称"] or "窗口承伤次数触发", _____53C2_6570)
end
local function ____on_7A97_53E3_627F_4F24_6B21_6570_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    for key in pairs(_____7A97_53E3_627F_4F24_6B21_6570_63A7_5236_5668_8868) do
        local _____63A7_5236_5668 = _____7A97_53E3_627F_4F24_6B21_6570_63A7_5236_5668_8868[key]
        if _____63A7_5236_5668 ~= nil then
            _____63A7_5236_5668["处理伤害"](
                _____63A7_5236_5668,
                target,
                attacker,
                applied,
                snapshot
            )
        end
    end
end
registerAppliedFinalDamageListener(____on_7A97_53E3_627F_4F24_6B21_6570_6700_7EC8_4F24_5BB3)
return ____exports
