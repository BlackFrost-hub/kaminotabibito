local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local __TS__New = ____lualib.__TS__New
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.02．计时器")
local createDelayedCall = ____require_result_0.createDelayedCall
local cancelDelayedCall = ____require_result_0.cancelDelayedCall
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local _____9996_4F24_7A97_53E3_63A7_5236_5668_8868 = {}
local _____9996_4F24_7A97_53E3_63A7_5236_5668_8BA1_6570 = 0
local function _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local _____65BD_6CD5_540E_9996_4F24_7A97_53E3_5B9E_73B0 = __TS__Class()
_____65BD_6CD5_540E_9996_4F24_7A97_53E3_5B9E_73B0.name = "施法后首伤窗口实现"
function _____65BD_6CD5_540E_9996_4F24_7A97_53E3_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["状态表"] = {}
    self["已停止"] = false
    self["名称"] = _____53C2_6570["名称"] or "施法后首伤窗口"
    self["参数"] = _____53C2_6570
    _____9996_4F24_7A97_53E3_63A7_5236_5668_8BA1_6570 = _____9996_4F24_7A97_53E3_63A7_5236_5668_8BA1_6570 + 1
    self["控制器ID"] = _____9996_4F24_7A97_53E3_63A7_5236_5668_8BA1_6570
    _____9996_4F24_7A97_53E3_63A7_5236_5668_8868[self["控制器ID"]] = self
end
_____65BD_6CD5_540E_9996_4F24_7A97_53E3_5B9E_73B0.prototype["打开"] = function(self, _____5355_4F4D)
    if self["已停止"] or not (self["参数"]["持续秒"] > 0) then
        return false
    end
    local id = _____53D6_5355_4F4DID(_____5355_4F4D)
    if id == 0 then
        return false
    end
    self["清理"](self, _____5355_4F4D)
    local ____this_72B6_6001_8868 = self["状态表"]
    local _____53E5_67C4 = nil
    _____53E5_67C4 = createDelayedCall(
        self["参数"]["持续秒"],
        function()
            if _____53E5_67C4 == nil then
                return
            end
            local _____72B6_6001 = ____this_72B6_6001_8868[id]
            if _____72B6_6001 ~= nil and _____72B6_6001["句柄"] == _____53E5_67C4 then
                __TS__Delete(____this_72B6_6001_8868, id)
            end
        end
    )
    self["状态表"][id] = {["单位"] = _____5355_4F4D, ["句柄"] = _____53E5_67C4}
    return true
end
_____65BD_6CD5_540E_9996_4F24_7A97_53E3_5B9E_73B0.prototype["清理"] = function(self, _____5355_4F4D)
    if _____5355_4F4D == nil then
        for key in pairs(self["状态表"]) do
            self["清理状态"](
                self,
                __TS__Number(key) or 0,
                true
            )
        end
        self["状态表"] = {}
        return
    end
    self["清理状态"](
        self,
        _____53D6_5355_4F4DID(_____5355_4F4D),
        true
    )
end
_____65BD_6CD5_540E_9996_4F24_7A97_53E3_5B9E_73B0.prototype["是否开启"] = function(self, _____5355_4F4D)
    return self["状态表"][_____53D6_5355_4F4DID(_____5355_4F4D)] ~= nil
end
_____65BD_6CD5_540E_9996_4F24_7A97_53E3_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    self["清理"](self)
    __TS__Delete(_____9996_4F24_7A97_53E3_63A7_5236_5668_8868, self["控制器ID"])
end
_____65BD_6CD5_540E_9996_4F24_7A97_53E3_5B9E_73B0.prototype["处理伤害"] = function(self, target, attacker, applied, snapshot)
    if self["已停止"] or target == nil or target == 0 or attacker == nil or attacker == 0 or not (applied >= 1) then
        return
    end
    local id = _____53D6_5355_4F4DID(attacker)
    if id == 0 or self["状态表"][id] == nil then
        return
    end
    local event = {
        ["单位"] = attacker,
        ["目标"] = target,
        ["攻击者"] = attacker,
        ["本次伤害"] = applied,
        ["伤害快照"] = snapshot,
        ["控制器"] = self
    }
    if self["参数"]["过滤伤害"] ~= nil and not self["参数"]["过滤伤害"](event) then
        return
    end
    self["清理状态"](self, id, true)
    self["参数"]["on首伤"](event)
end
_____65BD_6CD5_540E_9996_4F24_7A97_53E3_5B9E_73B0.prototype["清理状态"] = function(self, id, _____53D6_6D88_8BA1_65F6_5668)
    if id == 0 then
        return
    end
    local _____72B6_6001 = self["状态表"][id]
    if _____72B6_6001 ~= nil and _____53D6_6D88_8BA1_65F6_5668 then
        cancelDelayedCall(_____72B6_6001["句柄"])
    end
    __TS__Delete(self["状态表"], id)
end
local function ____on_65BD_6CD5_540E_9996_4F24_7A97_53E3_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    for key in pairs(_____9996_4F24_7A97_53E3_63A7_5236_5668_8868) do
        local _____63A7_5236_5668 = _____9996_4F24_7A97_53E3_63A7_5236_5668_8868[key]
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
registerAppliedFinalDamageListener(____on_65BD_6CD5_540E_9996_4F24_7A97_53E3_6700_7EC8_4F24_5BB3)
____exports["创建施法后首伤窗口"] = function(_____53C2_6570)
    return __TS__New(_____65BD_6CD5_540E_9996_4F24_7A97_53E3_5B9E_73B0, _____53C2_6570)
end
return ____exports
