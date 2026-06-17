local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____on_5C42_6570_72B6_6001Tick, getServerTime, _____5C42_6570_72B6_6001_63A7_5236_5668_8868
function ____on_5C42_6570_72B6_6001Tick()
    local now = getServerTime()
    for key in pairs(_____5C42_6570_72B6_6001_63A7_5236_5668_8868) do
        local _____63A7_5236_5668 = _____5C42_6570_72B6_6001_63A7_5236_5668_8868[key]
        if _____63A7_5236_5668 ~= nil then
            _____63A7_5236_5668["推进衰减"](_____63A7_5236_5668, now)
        end
    end
end
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
local _____5C42_6570_72B6_6001_9A71_52A8ID = 0
local _____5C42_6570_72B6_6001_63A7_5236_5668_8BA1_6570 = 0
_____5C42_6570_72B6_6001_63A7_5236_5668_8868 = {}
local function _____9650_5236_5C42_6570(value, max)
    if value <= 0 then
        return 0
    end
    if value >= max then
        return max
    end
    return value
end
local function _____53D6_8868_73B0_952E(_____914D_7F6E, _____5C42_6570)
    if _____5C42_6570 <= 0 or _____914D_7F6E["表现档位"] == nil then
        return ""
    end
    do
        local i = 0
        while i < #_____914D_7F6E["表现档位"] do
            local _____6863_4F4D = _____914D_7F6E["表现档位"][i + 1]
            local _____6700_5927_5C42_6570 = _____6863_4F4D["最大层数"] == nil and _____914D_7F6E["最大层数"] or _____6863_4F4D["最大层数"]
            if _____5C42_6570 >= _____6863_4F4D["最小层数"] and _____5C42_6570 <= _____6700_5927_5C42_6570 then
                return _____6863_4F4D["键"]
            end
            i = i + 1
        end
    end
    return ""
end
local function _____53D6_5F53_524D_8870_51CF_6A21_5F0F(_____5355_4F4D, _____914D_7F6E)
    if _____914D_7F6E["加速条件"] ~= nil and _____914D_7F6E["加速条件"](_____5355_4F4D) then
        return "加速"
    end
    return "普通"
end
local function _____53D6_8870_51CF_7B49_5F85Ms(_____914D_7F6E, _____6A21_5F0F)
    if _____6A21_5F0F == "加速" and _____914D_7F6E["加速等待秒"] ~= nil then
        return _____914D_7F6E["加速等待秒"] * 1000
    end
    return _____914D_7F6E["等待秒"] * 1000
end
local function _____53D6_8870_51CF_95F4_9694Ms(_____914D_7F6E, _____6A21_5F0F)
    if _____6A21_5F0F == "加速" and _____914D_7F6E["加速间隔秒"] ~= nil then
        return _____914D_7F6E["加速间隔秒"] * 1000
    end
    return _____914D_7F6E["间隔秒"] * 1000
end
local function _____786E_4FDD_5C42_6570_72B6_6001_9A71_52A8()
    if _____5C42_6570_72B6_6001_9A71_52A8ID ~= 0 then
        return
    end
    _____5C42_6570_72B6_6001_9A71_52A8ID = addPeriodicCallback(200, ____on_5C42_6570_72B6_6001Tick)
end
local function _____5C1D_8BD5_505C_6B62_5C42_6570_72B6_6001_9A71_52A8()
    for key in pairs(_____5C42_6570_72B6_6001_63A7_5236_5668_8868) do
        if _____5C42_6570_72B6_6001_63A7_5236_5668_8868[key] ~= nil then
            return
        end
    end
    if _____5C42_6570_72B6_6001_9A71_52A8ID ~= 0 then
        removePeriodicCallback(_____5C42_6570_72B6_6001_9A71_52A8ID)
        _____5C42_6570_72B6_6001_9A71_52A8ID = 0
    end
end
local _____53EF_914D_7F6E_5C42_6570_72B6_6001_5B9E_73B0 = __TS__Class()
_____53EF_914D_7F6E_5C42_6570_72B6_6001_5B9E_73B0.name = "可配置层数状态实现"
function _____53EF_914D_7F6E_5C42_6570_72B6_6001_5B9E_73B0.prototype.____constructor(self, _____914D_7F6E)
    self["状态表"] = {}
    self["配置"] = _____914D_7F6E
    _____5C42_6570_72B6_6001_63A7_5236_5668_8BA1_6570 = _____5C42_6570_72B6_6001_63A7_5236_5668_8BA1_6570 + 1
    self["控制器ID"] = _____5C42_6570_72B6_6001_63A7_5236_5668_8BA1_6570
    _____5C42_6570_72B6_6001_63A7_5236_5668_8868[self["控制器ID"]] = self
    _____786E_4FDD_5C42_6570_72B6_6001_9A71_52A8()
end
_____53EF_914D_7F6E_5C42_6570_72B6_6001_5B9E_73B0.prototype["增加"] = function(self, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
    if _____5C42_6570 == nil then
        _____5C42_6570 = 1
    end
    if _____539F_56E0 == nil then
        _____539F_56E0 = "增加"
    end
    return self["设置"](
        self,
        _____5355_4F4D,
        self["取层数"](self, _____5355_4F4D) + _____5C42_6570,
        _____539F_56E0
    )
end
_____53EF_914D_7F6E_5C42_6570_72B6_6001_5B9E_73B0.prototype["减少"] = function(self, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
    if _____5C42_6570 == nil then
        _____5C42_6570 = 1
    end
    if _____539F_56E0 == nil then
        _____539F_56E0 = "减少"
    end
    return self["设置"](
        self,
        _____5355_4F4D,
        self["取层数"](self, _____5355_4F4D) - _____5C42_6570,
        _____539F_56E0
    )
end
_____53EF_914D_7F6E_5C42_6570_72B6_6001_5B9E_73B0.prototype["设置"] = function(self, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "设置"
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    local _____5355_4F4DID = GetHandleId(_____5355_4F4D)
    local _____65E7_72B6_6001 = self["状态表"][_____5355_4F4DID]
    local _____65E7_5C42_6570 = _____65E7_72B6_6001 == nil and 0 or _____65E7_72B6_6001["层数"]
    local _____65B0_5C42_6570 = _____9650_5236_5C42_6570(_____5C42_6570, self["配置"]["最大层数"])
    if _____65E7_5C42_6570 == _____65B0_5C42_6570 then
        return _____65B0_5C42_6570
    end
    if _____65B0_5C42_6570 <= 0 then
        self["清空"](self, _____5355_4F4D, _____539F_56E0)
        return 0
    end
    local _____8868_73B0_952E = _____53D6_8868_73B0_952E(self["配置"], _____65B0_5C42_6570)
    local _____72B6_6001 = _____65E7_72B6_6001 or self["创建空状态"](self, _____5355_4F4D)
    local _____65E7_8868_73B0_952E = _____72B6_6001["表现键"]
    _____72B6_6001["层数"] = _____65B0_5C42_6570
    _____72B6_6001["表现键"] = _____8868_73B0_952E
    self["刷新衰减时间"](
        self,
        _____72B6_6001,
        getServerTime()
    )
    self["状态表"][_____5355_4F4DID] = _____72B6_6001
    self["触发变化"](
        self,
        _____5355_4F4D,
        _____65E7_5C42_6570,
        _____65B0_5C42_6570,
        _____539F_56E0
    )
    self["触发表现变化"](
        self,
        _____5355_4F4D,
        _____65E7_8868_73B0_952E,
        _____8868_73B0_952E,
        _____65B0_5C42_6570
    )
    return _____65B0_5C42_6570
end
_____53EF_914D_7F6E_5C42_6570_72B6_6001_5B9E_73B0.prototype["清空"] = function(self, _____5355_4F4D, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "清空"
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local _____5355_4F4DID = GetHandleId(_____5355_4F4D)
    local _____72B6_6001 = self["状态表"][_____5355_4F4DID]
    if _____72B6_6001 == nil then
        return
    end
    local _____65E7_5C42_6570 = _____72B6_6001["层数"]
    local _____65E7_8868_73B0_952E = _____72B6_6001["表现键"]
    __TS__Delete(self["状态表"], _____5355_4F4DID)
    self["触发变化"](
        self,
        _____5355_4F4D,
        _____65E7_5C42_6570,
        0,
        _____539F_56E0
    )
    self["触发表现变化"](
        self,
        _____5355_4F4D,
        _____65E7_8868_73B0_952E,
        "",
        0
    )
    if self["配置"]["on清空"] ~= nil then
        self["配置"]["on清空"](_____5355_4F4D, _____539F_56E0)
    end
end
_____53EF_914D_7F6E_5C42_6570_72B6_6001_5B9E_73B0.prototype["取层数"] = function(self, _____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    local _____72B6_6001 = self["状态表"][GetHandleId(_____5355_4F4D)]
    return _____72B6_6001 == nil and 0 or _____72B6_6001["层数"]
end
_____53EF_914D_7F6E_5C42_6570_72B6_6001_5B9E_73B0.prototype["销毁"] = function(self)
    for key in pairs(self["状态表"]) do
        local _____72B6_6001 = self["状态表"][key]
        if _____72B6_6001 ~= nil then
            self["清空"](self, _____72B6_6001["单位"], "控制器销毁")
        end
    end
    __TS__Delete(_____5C42_6570_72B6_6001_63A7_5236_5668_8868, self["控制器ID"])
    _____5C1D_8BD5_505C_6B62_5C42_6570_72B6_6001_9A71_52A8()
end
_____53EF_914D_7F6E_5C42_6570_72B6_6001_5B9E_73B0.prototype["推进衰减"] = function(self, now)
    local _____8870_51CF = self["配置"]["衰减"]
    if _____8870_51CF == nil then
        return
    end
    for key in pairs(self["状态表"]) do
        do
            local _____72B6_6001 = self["状态表"][key]
            if _____72B6_6001 == nil then
                goto __continue46
            end
            local _____5355_4F4D = _____72B6_6001["单位"]
            if _____5355_4F4D == nil or _____5355_4F4D == 0 or IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) then
                self["清空"](self, _____5355_4F4D, "单位失效")
                goto __continue46
            end
            local _____5F53_524D_6A21_5F0F = _____53D6_5F53_524D_8870_51CF_6A21_5F0F(_____5355_4F4D, _____8870_51CF)
            if _____5F53_524D_6A21_5F0F ~= _____72B6_6001["衰减模式"] then
                _____72B6_6001["衰减模式"] = _____5F53_524D_6A21_5F0F
                _____72B6_6001["下次衰减Ms"] = now + _____53D6_8870_51CF_7B49_5F85Ms(_____8870_51CF, _____5F53_524D_6A21_5F0F)
                goto __continue46
            end
            if now < _____72B6_6001["下次衰减Ms"] then
                goto __continue46
            end
            local _____51CF_5C11_5C42_6570 = _____8870_51CF["每次减少层数"] == nil and 1 or _____8870_51CF["每次减少层数"]
            self["设置"](self, _____5355_4F4D, _____72B6_6001["层数"] - _____51CF_5C11_5C42_6570, _____5F53_524D_6A21_5F0F == "加速" and "加速衰减" or "衰减")
            local _____65B0_72B6_6001 = self["状态表"][key]
            if _____65B0_72B6_6001 ~= nil then
                _____65B0_72B6_6001["衰减模式"] = _____5F53_524D_6A21_5F0F
                _____65B0_72B6_6001["下次衰减Ms"] = now + _____53D6_8870_51CF_95F4_9694Ms(_____8870_51CF, _____5F53_524D_6A21_5F0F)
            end
        end
        ::__continue46::
    end
end
_____53EF_914D_7F6E_5C42_6570_72B6_6001_5B9E_73B0.prototype["创建空状态"] = function(self, _____5355_4F4D)
    return {
        ["单位"] = _____5355_4F4D,
        ["层数"] = 0,
        ["表现键"] = "",
        ["衰减模式"] = "普通",
        ["下次衰减Ms"] = 0
    }
end
_____53EF_914D_7F6E_5C42_6570_72B6_6001_5B9E_73B0.prototype["刷新衰减时间"] = function(self, _____72B6_6001, now)
    local _____8870_51CF = self["配置"]["衰减"]
    if _____8870_51CF == nil then
        return
    end
    local _____6A21_5F0F = _____53D6_5F53_524D_8870_51CF_6A21_5F0F(_____72B6_6001["单位"], _____8870_51CF)
    _____72B6_6001["衰减模式"] = _____6A21_5F0F
    _____72B6_6001["下次衰减Ms"] = now + _____53D6_8870_51CF_7B49_5F85Ms(_____8870_51CF, _____6A21_5F0F)
end
_____53EF_914D_7F6E_5C42_6570_72B6_6001_5B9E_73B0.prototype["触发变化"] = function(self, _____5355_4F4D, _____65E7_5C42_6570, _____65B0_5C42_6570, _____539F_56E0)
    if self["配置"]["on层数变化"] == nil then
        return
    end
    self["配置"]["on层数变化"]({["单位"] = _____5355_4F4D, ["旧层数"] = _____65E7_5C42_6570, ["新层数"] = _____65B0_5C42_6570, ["原因"] = _____539F_56E0})
end
_____53EF_914D_7F6E_5C42_6570_72B6_6001_5B9E_73B0.prototype["触发表现变化"] = function(self, _____5355_4F4D, _____65E7_8868_73B0_952E, _____65B0_8868_73B0_952E, _____5F53_524D_5C42_6570)
    if _____65E7_8868_73B0_952E == _____65B0_8868_73B0_952E or self["配置"]["on表现变化"] == nil then
        return
    end
    self["配置"]["on表现变化"](_____5355_4F4D, _____65E7_8868_73B0_952E, _____65B0_8868_73B0_952E, _____5F53_524D_5C42_6570)
end
____exports["创建可配置层数状态"] = function(_____914D_7F6E)
    return __TS__New(_____53EF_914D_7F6E_5C42_6570_72B6_6001_5B9E_73B0, _____914D_7F6E)
end
return ____exports
