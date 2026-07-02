local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____on_6218_6597_72B6_6001Tick, _____6218_6597_72B6_6001_63A7_5236_5668_8868
function ____on_6218_6597_72B6_6001Tick()
    for key in pairs(_____6218_6597_72B6_6001_63A7_5236_5668_8868) do
        local _____63A7_5236_5668 = _____6218_6597_72B6_6001_63A7_5236_5668_8868[key]
        if _____63A7_5236_5668 ~= nil then
            _____63A7_5236_5668:Tick()
        end
    end
end
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("系统.00．核心系统.03．脱战系统.00．脱战规则")
local _____53D6_5355_4F4D_9ED8_8BA4_8131_6218_65F6_95F4_79D2 = ____require_result_2["取单位默认脱战时间秒"]
local _____53D6_5355_4F4D_9ED8_8BA4_8131_6218_4E3B_4F53_7C7B_578B = ____require_result_2["取单位默认脱战主体类型"]
local _____8131_6218_4F24_5BB3_9608_503C_6BD4_4F8B = ____require_result_2["脱战伤害阈值比例"]
_____6218_6597_72B6_6001_63A7_5236_5668_8868 = {}
local _____6218_6597_72B6_6001_63A7_5236_5668_8BA1_6570 = 0
local _____6218_6597_72B6_6001TickID = 0
local function _____5355_4F4D_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_5355_4F4DID(_____5355_4F4D)
    if not _____5355_4F4D_6709_6548(_____5355_4F4D) then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local function _____53D6_6218_6597_72B6_6001_4E3B_4F53_7C7B_578B(_____5355_4F4D, _____6307_5B9A_4E3B_4F53_7C7B_578B)
    return _____6307_5B9A_4E3B_4F53_7C7B_578B or _____53D6_5355_4F4D_9ED8_8BA4_8131_6218_4E3B_4F53_7C7B_578B(_____5355_4F4D)
end
local function _____53D7_4F24_8FBE_5230_8FDB_5165_6218_6597_9608_503C(_____5355_4F4D, _____4E3B_4F53_7C7B_578B, applied)
    if _____4E3B_4F53_7C7B_578B ~= "玩家英雄" then
        return true
    end
    local _____6700_5927_751F_547D = GetUnitState(_____5355_4F4D, UNIT_STATE_MAX_LIFE)
    if not (_____6700_5927_751F_547D > 0) then
        return applied > 0
    end
    return applied >= _____6700_5927_751F_547D * _____8131_6218_4F24_5BB3_9608_503C_6BD4_4F8B
end
local function _____786E_4FDD_6218_6597_72B6_6001Tick(interval)
    if _____6218_6597_72B6_6001TickID ~= 0 then
        return
    end
    _____6218_6597_72B6_6001TickID = addPeriodicCallback(interval, ____on_6218_6597_72B6_6001Tick)
end
local function _____5C1D_8BD5_505C_6B62_6218_6597_72B6_6001Tick()
    for key in pairs(_____6218_6597_72B6_6001_63A7_5236_5668_8868) do
        if _____6218_6597_72B6_6001_63A7_5236_5668_8868[key] ~= nil then
            return
        end
    end
    if _____6218_6597_72B6_6001TickID ~= 0 then
        removePeriodicCallback(_____6218_6597_72B6_6001TickID)
        _____6218_6597_72B6_6001TickID = 0
    end
end
local _____6218_6597_72B6_6001_89E6_53D1_5B9E_73B0 = __TS__Class()
_____6218_6597_72B6_6001_89E6_53D1_5B9E_73B0.name = "战斗状态触发实现"
function _____6218_6597_72B6_6001_89E6_53D1_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____53C2_6570)
    self["已停止"] = false
    self["战斗中"] = false
    self["战斗开始毫秒"] = 0
    self["上次战斗毫秒"] = 0
    self["下次周期毫秒"] = 0
    self["已触发持续满足"] = false
    self["最近对方单位"] = nil
    self["名称"] = _____540D_79F0
    self["参数"] = _____53C2_6570
    _____6218_6597_72B6_6001_63A7_5236_5668_8BA1_6570 = _____6218_6597_72B6_6001_63A7_5236_5668_8BA1_6570 + 1
    self["控制器ID"] = _____6218_6597_72B6_6001_63A7_5236_5668_8BA1_6570
    _____6218_6597_72B6_6001_63A7_5236_5668_8868[self["控制器ID"]] = self
    local interval = _____53C2_6570["检查间隔毫秒"] or 200
    _____786E_4FDD_6218_6597_72B6_6001Tick(interval)
end
_____6218_6597_72B6_6001_89E6_53D1_5B9E_73B0.prototype["是否战斗中"] = function(self)
    return self["战斗中"]
end
_____6218_6597_72B6_6001_89E6_53D1_5B9E_73B0.prototype["刷新战斗"] = function(self, _____5BF9_65B9_5355_4F4D)
    if self["已停止"] or not _____5355_4F4D_6709_6548(self["参数"]["单位"]) then
        return
    end
    local now = getServerTime()
    self["最近对方单位"] = _____5BF9_65B9_5355_4F4D
    self["上次战斗毫秒"] = now
    if not self["战斗中"] then
        self["战斗中"] = true
        self["战斗开始毫秒"] = now
        self["下次周期毫秒"] = self["取周期触发毫秒"](self, now)
        self["已触发持续满足"] = false
        if self["参数"]["on进入战斗"] ~= nil then
            self["参数"]["on进入战斗"](self["创建事件"](self, now))
        end
    end
end
_____6218_6597_72B6_6001_89E6_53D1_5B9E_73B0.prototype["处理伤害"] = function(self, target, attacker, applied, snapshot)
    if self["已停止"] or applied <= 0 then
        return
    end
    local _____5355_4F4DID = _____53D6_5355_4F4DID(self["参数"]["单位"])
    if _____5355_4F4DID == 0 then
        return
    end
    local _____76EE_6807_5339_914D = _____53D6_5355_4F4DID(target) == _____5355_4F4DID
    local _____653B_51FB_8005_5339_914D = _____53D6_5355_4F4DID(attacker) == _____5355_4F4DID
    if not _____76EE_6807_5339_914D and not _____653B_51FB_8005_5339_914D then
        return
    end
    if self["参数"]["过滤战斗事件"] ~= nil and not self["参数"]["过滤战斗事件"](target, attacker, applied, snapshot) then
        return
    end
    if _____653B_51FB_8005_5339_914D then
        self["刷新战斗"](self, target)
        return
    end
    local _____4E3B_4F53_7C7B_578B = _____53D6_6218_6597_72B6_6001_4E3B_4F53_7C7B_578B(self["参数"]["单位"], self["参数"]["主体类型"])
    if not _____53D7_4F24_8FBE_5230_8FDB_5165_6218_6597_9608_503C(self["参数"]["单位"], _____4E3B_4F53_7C7B_578B, applied) then
        return
    end
    self["刷新战斗"](self, attacker)
end
function _____6218_6597_72B6_6001_89E6_53D1_5B9E_73B0.prototype.Tick(self)
    if self["已停止"] then
        return
    end
    if not _____5355_4F4D_6709_6548(self["参数"]["单位"]) then
        self["停止"](self)
        return
    end
    if not self["战斗中"] then
        return
    end
    local now = getServerTime()
    local _____4FDD_6301_79D2 = self["参数"]["战斗保持秒"] or _____53D6_5355_4F4D_9ED8_8BA4_8131_6218_65F6_95F4_79D2(self["参数"]["单位"], self["参数"]["主体类型"])
    local _____4FDD_6301_6BEB_79D2 = _____4FDD_6301_79D2 * 1000
    if now - self["上次战斗毫秒"] > _____4FDD_6301_6BEB_79D2 then
        local event = self["创建事件"](self, now)
        self["战斗中"] = false
        self["战斗开始毫秒"] = 0
        self["上次战斗毫秒"] = 0
        self["下次周期毫秒"] = 0
        self["已触发持续满足"] = false
        if self["参数"]["on脱离战斗"] ~= nil then
            self["参数"]["on脱离战斗"](event)
        end
        return
    end
    local _____6301_7EED_6218_6597_79D2 = self["参数"]["持续战斗秒"] or 0
    if not self["已触发持续满足"] and _____6301_7EED_6218_6597_79D2 > 0 and now - self["战斗开始毫秒"] >= _____6301_7EED_6218_6597_79D2 * 1000 then
        self["已触发持续满足"] = true
        if self["参数"]["on持续战斗满足"] ~= nil then
            self["参数"]["on持续战斗满足"](self["创建事件"](self, now))
        end
    end
    if self["参数"]["周期触发秒"] ~= nil and self["参数"]["周期触发秒"] > 0 and now >= self["下次周期毫秒"] then
        if self["参数"]["on周期触发"] ~= nil then
            self["参数"]["on周期触发"](self["创建事件"](self, now))
        end
        self["下次周期毫秒"] = self["取周期触发毫秒"](self, now)
    end
end
_____6218_6597_72B6_6001_89E6_53D1_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    __TS__Delete(_____6218_6597_72B6_6001_63A7_5236_5668_8868, self["控制器ID"])
    _____5C1D_8BD5_505C_6B62_6218_6597_72B6_6001Tick()
end
_____6218_6597_72B6_6001_89E6_53D1_5B9E_73B0.prototype["创建事件"] = function(self, now)
    return {["单位"] = self["参数"]["单位"], ["对方单位"] = self["最近对方单位"], ["已战斗毫秒"] = self["战斗开始毫秒"] > 0 and now - self["战斗开始毫秒"] or 0, ["距离上次战斗毫秒"] = self["上次战斗毫秒"] > 0 and now - self["上次战斗毫秒"] or 0}
end
_____6218_6597_72B6_6001_89E6_53D1_5B9E_73B0.prototype["取周期触发毫秒"] = function(self, now)
    local sec = self["参数"]["周期触发秒"] or 0
    return sec > 0 and now + sec * 1000 or 0
end
____exports["创建战斗状态触发器"] = function(_____53C2_6570)
    return __TS__New(_____6218_6597_72B6_6001_89E6_53D1_5B9E_73B0, _____53C2_6570["名称"] or "战斗状态触发器", _____53C2_6570)
end
local function ____on_6218_6597_72B6_6001_4F24_5BB3_4E8B_4EF6(target, attacker, applied, snapshot)
    for key in pairs(_____6218_6597_72B6_6001_63A7_5236_5668_8868) do
        local _____63A7_5236_5668 = _____6218_6597_72B6_6001_63A7_5236_5668_8868[key]
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
registerAppliedFinalDamageListener(____on_6218_6597_72B6_6001_4F24_5BB3_4E8B_4EF6)
return ____exports
