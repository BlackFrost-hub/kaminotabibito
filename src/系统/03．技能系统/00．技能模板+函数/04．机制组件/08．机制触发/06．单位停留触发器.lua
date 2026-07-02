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
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local getServerTime = ____require_result_0.getServerTime
local function _____5355_4F4D_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true
end
local function _____4E24_70B9_8DDD_79BB_5E73_65B9(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return dx * dx + dy * dy
end
local function _____8BFB_53D6_5355_4F4D_5217_8868(_____53C2_6570)
    if _____53C2_6570["读取单位列表"] ~= nil then
        return _____53C2_6570["读取单位列表"]()
    end
    return _____53C2_6570["单位列表"] or ({})
end
local _____5355_4F4D_505C_7559_89E6_53D1_63A7_5236_5668_5B9E_73B0 = __TS__Class()
_____5355_4F4D_505C_7559_89E6_53D1_63A7_5236_5668_5B9E_73B0.name = "单位停留触发控制器实现"
function _____5355_4F4D_505C_7559_89E6_53D1_63A7_5236_5668_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____53C2_6570)
    self["周期回调ID"] = 0
    self["已停止"] = false
    self["状态表"] = {}
    self["名称"] = _____540D_79F0
    self["参数"] = _____53C2_6570
end
_____5355_4F4D_505C_7559_89E6_53D1_63A7_5236_5668_5B9E_73B0.prototype["设置周期回调ID"] = function(self, id)
    self["周期回调ID"] = id
end
_____5355_4F4D_505C_7559_89E6_53D1_63A7_5236_5668_5B9E_73B0.prototype["刷新"] = function(self)
    if self["已停止"] then
        return
    end
    local _____4E2D_5FC3_5355_4F4D = self["参数"]["中心单位"]
    if not _____5355_4F4D_6709_6548(_____4E2D_5FC3_5355_4F4D) then
        self["清空全部"](self, "中心失效")
        return
    end
    local now = getServerTime()
    local centerX = GetUnitX(_____4E2D_5FC3_5355_4F4D)
    local centerY = GetUnitY(_____4E2D_5FC3_5355_4F4D)
    local _____534A_5F84_5E73_65B9 = self["参数"]["半径"] * self["参数"]["半径"]
    local _____5DF2_8BBF_95EE_8868 = {}
    local _____5217_8868 = _____8BFB_53D6_5355_4F4D_5217_8868(self["参数"])
    do
        local i = 0
        while i < #_____5217_8868 do
            do
                local _____5355_4F4D = _____5217_8868[i + 1]
                if not _____5355_4F4D_6709_6548(_____5355_4F4D) then
                    goto __continue12
                end
                if self["参数"]["过滤单位"] ~= nil and not self["参数"]["过滤单位"](_____5355_4F4D) then
                    goto __continue12
                end
                local _____5355_4F4DID = GetHandleId(_____5355_4F4D)
                _____5DF2_8BBF_95EE_8868[_____5355_4F4DID] = true
                local _____5728_8303_56F4_5185 = _____4E24_70B9_8DDD_79BB_5E73_65B9(
                    GetUnitX(_____5355_4F4D),
                    GetUnitY(_____5355_4F4D),
                    centerX,
                    centerY
                ) <= _____534A_5F84_5E73_65B9
                local _____72B6_6001 = self["状态表"][_____5355_4F4DID]
                if not _____5728_8303_56F4_5185 then
                    if _____72B6_6001 ~= nil and _____72B6_6001["当前在范围内"] then
                        self["处理离开"](self, _____5355_4F4DID, _____72B6_6001)
                    end
                    goto __continue12
                end
                if _____72B6_6001 == nil then
                    self["状态表"][_____5355_4F4DID] = {
                        ["目标单位"] = _____5355_4F4D,
                        ["进入毫秒"] = now,
                        ["已持续毫秒"] = 0,
                        ["是否已触发"] = false,
                        ["当前在范围内"] = true
                    }
                    if self["参数"]["on进入"] ~= nil then
                        self["参数"]["on进入"](_____5355_4F4D)
                    end
                    goto __continue12
                end
                _____72B6_6001["当前在范围内"] = true
                _____72B6_6001["已持续毫秒"] = now - _____72B6_6001["进入毫秒"]
                if not _____72B6_6001["是否已触发"] and _____72B6_6001["已持续毫秒"] >= self["参数"]["需求持续毫秒"] then
                    _____72B6_6001["是否已触发"] = true
                    if self["参数"]["on触发"] ~= nil then
                        self["参数"]["on触发"]({["目标单位"] = _____5355_4F4D, ["已持续毫秒"] = _____72B6_6001["已持续毫秒"], ["是否已触发"] = true})
                    end
                    if self["参数"]["只触发一次"] == true then
                        __TS__Delete(self["状态表"], _____5355_4F4DID)
                    end
                end
            end
            ::__continue12::
            i = i + 1
        end
    end
    for key in pairs(self["状态表"]) do
        do
            if _____5DF2_8BBF_95EE_8868[key] == true then
                goto __continue22
            end
            local _____72B6_6001 = self["状态表"][key]
            if _____72B6_6001 ~= nil then
                self["处理离开"](
                    self,
                    __TS__Number(key),
                    _____72B6_6001
                )
            end
        end
        ::__continue22::
    end
end
_____5355_4F4D_505C_7559_89E6_53D1_63A7_5236_5668_5B9E_73B0.prototype["读取状态"] = function(self, _____5355_4F4D)
    if not _____5355_4F4D_6709_6548(_____5355_4F4D) then
        return nil
    end
    local _____72B6_6001 = self["状态表"][GetHandleId(_____5355_4F4D)]
    if _____72B6_6001 == nil then
        return nil
    end
    return {["目标单位"] = _____72B6_6001["目标单位"], ["已持续毫秒"] = _____72B6_6001["已持续毫秒"], ["是否已触发"] = _____72B6_6001["是否已触发"]}
end
_____5355_4F4D_505C_7559_89E6_53D1_63A7_5236_5668_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    if self["周期回调ID"] ~= 0 then
        removePeriodicCallback(self["周期回调ID"])
        self["周期回调ID"] = 0
    end
    self["状态表"] = {}
end
_____5355_4F4D_505C_7559_89E6_53D1_63A7_5236_5668_5B9E_73B0.prototype["处理离开"] = function(self, _____5355_4F4DID, _____72B6_6001)
    if self["参数"]["on离开"] ~= nil then
        self["参数"]["on离开"](_____72B6_6001["目标单位"], _____72B6_6001["已持续毫秒"])
    end
    if self["参数"]["离开后重置"] ~= false then
        __TS__Delete(self["状态表"], _____5355_4F4DID)
    else
        _____72B6_6001["当前在范围内"] = false
    end
end
_____5355_4F4D_505C_7559_89E6_53D1_63A7_5236_5668_5B9E_73B0.prototype["清空全部"] = function(self, ______539F_56E0)
    for key in pairs(self["状态表"]) do
        local _____72B6_6001 = self["状态表"][key]
        if _____72B6_6001 ~= nil and self["参数"]["on离开"] ~= nil then
            self["参数"]["on离开"](_____72B6_6001["目标单位"], _____72B6_6001["已持续毫秒"])
        end
    end
    self["状态表"] = {}
end
____exports["创建单位停留触发器"] = function(_____53C2_6570)
    local _____540D_79F0 = _____53C2_6570["名称"] or "单位停留触发器"
    local _____63A7_5236_5668 = __TS__New(_____5355_4F4D_505C_7559_89E6_53D1_63A7_5236_5668_5B9E_73B0, _____540D_79F0, _____53C2_6570)
    _____63A7_5236_5668["刷新"](_____63A7_5236_5668)
    local _____95F4_9694 = _____53C2_6570["检查间隔毫秒"] or 100
    if _____95F4_9694 > 0 then
        local id = addPeriodicCallback(
            _____95F4_9694,
            function()
                _____63A7_5236_5668["刷新"](_____63A7_5236_5668)
            end
        )
        _____63A7_5236_5668["设置周期回调ID"](_____63A7_5236_5668, id)
        if _____53C2_6570["清理篮子"] ~= nil then
            if _____53C2_6570["清理篮子"]["登记周期回调"] ~= nil then
                local ____self_1 = _____53C2_6570["清理篮子"]
                ____self_1["登记周期回调"](____self_1, _____540D_79F0 .. "-周期刷新", id)
            else
                local ____self_2 = _____53C2_6570["清理篮子"]
                ____self_2["登记清理"](
                    ____self_2,
                    _____540D_79F0 .. "-停止",
                    function()
                        _____63A7_5236_5668["停止"](_____63A7_5236_5668)
                    end
                )
            end
        end
    end
    return _____63A7_5236_5668
end
return ____exports
