local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__New = ____lualib.__TS__New
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local _____7D2F_8BA1_627F_4F24_63A7_5236_5668_8868 = {}
local _____7D2F_8BA1_627F_4F24_63A7_5236_5668_8BA1_6570 = 0
local function _____5355_4F4D_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_5355_4F4DID(_____5355_4F4D)
    if not _____5355_4F4D_6709_6548(_____5355_4F4D) then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local _____7D2F_8BA1_627F_4F24_89E6_53D1_5B9E_73B0 = __TS__Class()
_____7D2F_8BA1_627F_4F24_89E6_53D1_5B9E_73B0.name = "累计承伤触发实现"
function _____7D2F_8BA1_627F_4F24_89E6_53D1_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____53C2_6570)
    self["状态表"] = {}
    self["已停止"] = false
    self["名称"] = _____540D_79F0
    self["参数"] = _____53C2_6570
    _____7D2F_8BA1_627F_4F24_63A7_5236_5668_8BA1_6570 = _____7D2F_8BA1_627F_4F24_63A7_5236_5668_8BA1_6570 + 1
    self["控制器ID"] = _____7D2F_8BA1_627F_4F24_63A7_5236_5668_8BA1_6570
    _____7D2F_8BA1_627F_4F24_63A7_5236_5668_8868[self["控制器ID"]] = self
end
_____7D2F_8BA1_627F_4F24_89E6_53D1_5B9E_73B0.prototype["处理伤害"] = function(self, target, attacker, applied, snapshot)
    if self["已停止"] or applied <= 0 then
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
    local ____72B6_6001__8BB0_5F55_2 = _____72B6_6001["记录"]
    ____72B6_6001__8BB0_5F55_2[#____72B6_6001__8BB0_5F55_2 + 1] = {["时间毫秒"] = now, ["伤害"] = applied}
    self["清理过期记录"](self, _____72B6_6001, now)
    local _____7D2F_8BA1_4F24_5BB3 = self["计算累计"](self, _____72B6_6001)
    local _____9608_503C = self["计算阈值"](self, target)
    if _____9608_503C <= 0 or _____7D2F_8BA1_4F24_5BB3 < _____9608_503C then
        return
    end
    local event = {
        ["单位"] = target,
        ["攻击者"] = attacker,
        ["本次伤害"] = applied,
        ["累计伤害"] = _____7D2F_8BA1_4F24_5BB3,
        ["阈值"] = _____9608_503C,
        ["伤害快照"] = snapshot
    }
    if self["参数"]["过滤伤害"] ~= nil and not self["参数"]["过滤伤害"](event) then
        return
    end
    self["参数"]["on触发"](event)
    if self["参数"]["触发后清空"] ~= false then
        _____72B6_6001["记录"] = {}
    end
    local cd = self["参数"]["内置CD秒"] or 0
    if cd > 0 then
        _____72B6_6001["下次允许毫秒"] = now + cd * 1000
    end
end
_____7D2F_8BA1_627F_4F24_89E6_53D1_5B9E_73B0.prototype["读取累计伤害"] = function(self, _____5355_4F4D)
    local _____72B6_6001 = self["状态表"][_____53D6_5355_4F4DID(_____5355_4F4D)]
    if _____72B6_6001 == nil then
        return 0
    end
    self["清理过期记录"](
        self,
        _____72B6_6001,
        getServerTime()
    )
    return self["计算累计"](self, _____72B6_6001)
end
_____7D2F_8BA1_627F_4F24_89E6_53D1_5B9E_73B0.prototype["清空"] = function(self, _____5355_4F4D)
    if _____5355_4F4D == nil then
        self["状态表"] = {}
        return
    end
    __TS__Delete(
        self["状态表"],
        _____53D6_5355_4F4DID(_____5355_4F4D)
    )
end
_____7D2F_8BA1_627F_4F24_89E6_53D1_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    self["状态表"] = {}
    __TS__Delete(_____7D2F_8BA1_627F_4F24_63A7_5236_5668_8868, self["控制器ID"])
end
_____7D2F_8BA1_627F_4F24_89E6_53D1_5B9E_73B0.prototype["取或建状态"] = function(self, _____5355_4F4D)
    local id = _____53D6_5355_4F4DID(_____5355_4F4D)
    local _____72B6_6001 = self["状态表"][id]
    if _____72B6_6001 == nil then
        _____72B6_6001 = {["单位"] = _____5355_4F4D, ["记录"] = {}, ["下次允许毫秒"] = 0}
        self["状态表"][id] = _____72B6_6001
    end
    return _____72B6_6001
end
_____7D2F_8BA1_627F_4F24_89E6_53D1_5B9E_73B0.prototype["清理过期记录"] = function(self, _____72B6_6001, now)
    local _____6700_65E9_6BEB_79D2 = now - self["参数"]["窗口秒"] * 1000
    do
        local i = #_____72B6_6001["记录"] - 1
        while i >= 0 do
            do
                if _____72B6_6001["记录"][i + 1]["时间毫秒"] >= _____6700_65E9_6BEB_79D2 then
                    goto __continue25
                end
                __TS__ArraySplice(_____72B6_6001["记录"], i, 1)
            end
            ::__continue25::
            i = i - 1
        end
    end
end
_____7D2F_8BA1_627F_4F24_89E6_53D1_5B9E_73B0.prototype["计算累计"] = function(self, _____72B6_6001)
    local total = 0
    do
        local i = 0
        while i < #_____72B6_6001["记录"] do
            total = total + _____72B6_6001["记录"][i + 1]["伤害"]
            i = i + 1
        end
    end
    return total
end
_____7D2F_8BA1_627F_4F24_89E6_53D1_5B9E_73B0.prototype["计算阈值"] = function(self, _____5355_4F4D)
    local _____9608_503C = self["参数"]["固定阈值"] or 0
    if self["参数"]["最大生命比例阈值"] ~= nil and self["参数"]["最大生命比例阈值"] > 0 then
        local hpValue = GetUnitStateJapi(_____5355_4F4D, UNIT_STATE_MAX_LIFE) * self["参数"]["最大生命比例阈值"]
        if _____9608_503C <= 0 or hpValue < _____9608_503C then
            _____9608_503C = hpValue
        end
    end
    return _____9608_503C
end
____exports["创建累计承伤触发器"] = function(_____53C2_6570)
    return __TS__New(_____7D2F_8BA1_627F_4F24_89E6_53D1_5B9E_73B0, _____53C2_6570["名称"] or "累计承伤触发", _____53C2_6570)
end
local function ____on_7D2F_8BA1_627F_4F24_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    for key in pairs(_____7D2F_8BA1_627F_4F24_63A7_5236_5668_8868) do
        local _____63A7_5236_5668 = _____7D2F_8BA1_627F_4F24_63A7_5236_5668_8868[key]
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
registerAppliedFinalDamageListener(____on_7D2F_8BA1_627F_4F24_6700_7EC8_4F24_5BB3)
return ____exports
