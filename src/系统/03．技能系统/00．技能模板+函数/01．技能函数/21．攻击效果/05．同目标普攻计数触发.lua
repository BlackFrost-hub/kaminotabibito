local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
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
local _____540C_76EE_6807_666E_653B_8BA1_6570_63A7_5236_5668_8868 = {}
local _____540C_76EE_6807_666E_653B_8BA1_6570_63A7_5236_5668_8BA1_6570 = 0
local function _____5355_4F4D_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_5355_4F4DID(_____5355_4F4D)
    if not _____5355_4F4D_6709_6548(_____5355_4F4D) then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local function _____53D6_914D_5BF9_952E(source, target)
    local sourceID = _____53D6_5355_4F4DID(source)
    local targetID = _____53D6_5355_4F4DID(target)
    if sourceID <= 0 or targetID <= 0 then
        return ""
    end
    return (tostring(sourceID) .. ":") .. tostring(targetID)
end
local function _____662F_7EAF_666E_653B_5FEB_7167(snapshot)
    return snapshot ~= nil and snapshot.isNormalAttack == true and snapshot.isSkillAttack ~= true and snapshot.isSkillDamage ~= true
end
local function _____662F_5141_8BB8_7684_666E_653B_5FEB_7167(snapshot, _____53C2_6570)
    if snapshot == nil or snapshot.isNormalAttack ~= true then
        return false
    end
    local _____53EA_5141_8BB8_7EAF_666E_653B = _____53C2_6570["允许技能普攻"] ~= true and _____53C2_6570["仅纯普攻"] ~= false
    if not _____53EA_5141_8BB8_7EAF_666E_653B then
        return true
    end
    return _____662F_7EAF_666E_653B_5FEB_7167(snapshot)
end
local _____540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1_5B9E_73B0 = __TS__Class()
_____540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1_5B9E_73B0.name = "同目标普攻计数触发实现"
function _____540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____53C2_6570)
    self["状态表"] = {}
    self["冷却表"] = {}
    self["已停止"] = false
    self["名称"] = _____540D_79F0
    self["参数"] = _____53C2_6570
    _____540C_76EE_6807_666E_653B_8BA1_6570_63A7_5236_5668_8BA1_6570 = _____540C_76EE_6807_666E_653B_8BA1_6570_63A7_5236_5668_8BA1_6570 + 1
    self["控制器ID"] = _____540C_76EE_6807_666E_653B_8BA1_6570_63A7_5236_5668_8BA1_6570
    _____540C_76EE_6807_666E_653B_8BA1_6570_63A7_5236_5668_8868[self["控制器ID"]] = self
end
_____540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1_5B9E_73B0.prototype["处理伤害"] = function(self, target, attacker, applied, snapshot)
    if self["已停止"] or not (applied > 0) then
        return
    end
    if not _____5355_4F4D_6709_6548(attacker) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    if self["参数"]["攻击者"] ~= nil and _____53D6_5355_4F4DID(self["参数"]["攻击者"]) ~= _____53D6_5355_4F4DID(attacker) then
        return
    end
    if self["参数"]["目标"] ~= nil and _____53D6_5355_4F4DID(self["参数"]["目标"]) ~= _____53D6_5355_4F4DID(target) then
        return
    end
    if not _____662F_5141_8BB8_7684_666E_653B_5FEB_7167(snapshot, self["参数"]) then
        return
    end
    local key = _____53D6_914D_5BF9_952E(attacker, target)
    if key == "" then
        return
    end
    local now = getServerTime()
    if self["是否冷却中"](self, attacker, target, now) then
        return
    end
    local _____72B6_6001 = self["取或建状态"](self, key, attacker, target)
    local ____72B6_6001__8BB0_5F55_2 = _____72B6_6001["记录"]
    ____72B6_6001__8BB0_5F55_2[#____72B6_6001__8BB0_5F55_2 + 1] = {["时间毫秒"] = now}
    self["清理过期记录"](self, _____72B6_6001, now)
    local _____5F53_524D_6B21_6570 = #_____72B6_6001["记录"]
    local _____9608_503C = self["参数"]["次数阈值"]
    if not (_____9608_503C > 0) or _____5F53_524D_6B21_6570 < _____9608_503C then
        return
    end
    local event = {
        source = attacker,
        target = target,
        applied = applied,
        snapshot = snapshot,
        ["当前次数"] = _____5F53_524D_6B21_6570,
        ["窗口秒"] = self["参数"]["窗口秒"],
        ["次数阈值"] = _____9608_503C
    }
    if self["参数"]["过滤"] ~= nil and not self["参数"]["过滤"](event) then
        return
    end
    self["参数"]["on触发"](event)
    _____72B6_6001["记录"] = {}
    self["进入冷却"](self, attacker, target, now)
end
_____540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1_5B9E_73B0.prototype["读取次数"] = function(self, _____653B_51FB_8005, _____76EE_6807)
    local key = _____53D6_914D_5BF9_952E(_____653B_51FB_8005, _____76EE_6807)
    if key == "" then
        return 0
    end
    local _____72B6_6001 = self["状态表"][key]
    if _____72B6_6001 == nil then
        return 0
    end
    self["清理过期记录"](
        self,
        _____72B6_6001,
        getServerTime()
    )
    return #_____72B6_6001["记录"]
end
_____540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1_5B9E_73B0.prototype["清空"] = function(self, _____653B_51FB_8005, _____76EE_6807)
    if _____653B_51FB_8005 == nil and _____76EE_6807 == nil then
        self["状态表"] = {}
        self["冷却表"] = {}
        return
    end
    if _____653B_51FB_8005 ~= nil and _____76EE_6807 ~= nil then
        local key = _____53D6_914D_5BF9_952E(_____653B_51FB_8005, _____76EE_6807)
        if key ~= "" then
            __TS__Delete(self["状态表"], key)
            __TS__Delete(self["冷却表"], key)
        end
        return
    end
    local _____653B_51FB_8005ID = _____653B_51FB_8005 ~= nil and _____53D6_5355_4F4DID(_____653B_51FB_8005) or 0
    local _____76EE_6807ID = _____76EE_6807 ~= nil and _____53D6_5355_4F4DID(_____76EE_6807) or 0
    for key in pairs(self["状态表"]) do
        do
            local _____72B6_6001 = self["状态表"][key]
            if _____72B6_6001 == nil then
                goto __continue29
            end
            if _____653B_51FB_8005ID > 0 and _____53D6_5355_4F4DID(_____72B6_6001.source) ~= _____653B_51FB_8005ID then
                goto __continue29
            end
            if _____76EE_6807ID > 0 and _____53D6_5355_4F4DID(_____72B6_6001.target) ~= _____76EE_6807ID then
                goto __continue29
            end
            __TS__Delete(self["状态表"], key)
            __TS__Delete(self["冷却表"], key)
        end
        ::__continue29::
    end
end
_____540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    self["状态表"] = {}
    self["冷却表"] = {}
    __TS__Delete(_____540C_76EE_6807_666E_653B_8BA1_6570_63A7_5236_5668_8868, self["控制器ID"])
end
_____540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1_5B9E_73B0.prototype["取或建状态"] = function(self, key, source, target)
    local _____72B6_6001 = self["状态表"][key]
    if _____72B6_6001 == nil then
        _____72B6_6001 = {source = source, target = target, ["记录"] = {}}
        self["状态表"][key] = _____72B6_6001
    end
    return _____72B6_6001
end
_____540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1_5B9E_73B0.prototype["清理过期记录"] = function(self, _____72B6_6001, now)
    local _____6700_65E9_6BEB_79D2 = now - self["参数"]["窗口秒"] * 1000
    do
        local i = #_____72B6_6001["记录"] - 1
        while i >= 0 do
            do
                if _____72B6_6001["记录"][i + 1]["时间毫秒"] >= _____6700_65E9_6BEB_79D2 then
                    goto __continue40
                end
                __TS__ArraySplice(_____72B6_6001["记录"], i, 1)
            end
            ::__continue40::
            i = i - 1
        end
    end
end
_____540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1_5B9E_73B0.prototype["取冷却键"] = function(self, source, target)
    local sourceID = _____53D6_5355_4F4DID(source)
    if sourceID <= 0 then
        return ""
    end
    if (self["参数"]["冷却作用域"] or "攻击者目标") == "攻击者" then
        return tostring(sourceID)
    end
    return _____53D6_914D_5BF9_952E(source, target)
end
_____540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1_5B9E_73B0.prototype["是否冷却中"] = function(self, source, target, now)
    local cd = self["参数"]["内置CD秒"] or 0
    if cd <= 0 then
        return false
    end
    local key = self["取冷却键"](self, source, target)
    if key == "" then
        return false
    end
    local _____4E0B_6B21_5141_8BB8 = self["冷却表"][key]
    return _____4E0B_6B21_5141_8BB8 ~= nil and now < _____4E0B_6B21_5141_8BB8
end
_____540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1_5B9E_73B0.prototype["进入冷却"] = function(self, source, target, now)
    local cd = self["参数"]["内置CD秒"] or 0
    if cd <= 0 then
        return
    end
    local key = self["取冷却键"](self, source, target)
    if key == "" then
        return
    end
    self["冷却表"][key] = now + cd * 1000
end
____exports["创建同目标普攻计数触发器"] = function(_____53C2_6570)
    return __TS__New(_____540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1_5B9E_73B0, _____53C2_6570["名称"] or "同目标普攻计数触发", _____53C2_6570)
end
____exports["伤害快照是纯普攻"] = function(snapshot)
    return _____662F_7EAF_666E_653B_5FEB_7167(snapshot)
end
local function ____on_540C_76EE_6807_666E_653B_8BA1_6570_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    for key in pairs(_____540C_76EE_6807_666E_653B_8BA1_6570_63A7_5236_5668_8868) do
        local _____63A7_5236_5668 = _____540C_76EE_6807_666E_653B_8BA1_6570_63A7_5236_5668_8868[key]
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
registerAppliedFinalDamageListener(____on_540C_76EE_6807_666E_653B_8BA1_6570_6700_7EC8_4F24_5BB3)
return ____exports
