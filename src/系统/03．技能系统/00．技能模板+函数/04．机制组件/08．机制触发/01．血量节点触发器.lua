local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____on_8840_91CF_8282_70B9_89E6_53D1_5668Tick, _____8840_91CF_8282_70B9_89E6_53D1_5668_8868
function ____on_8840_91CF_8282_70B9_89E6_53D1_5668Tick()
    for key in pairs(_____8840_91CF_8282_70B9_89E6_53D1_5668_8868) do
        local _____5B9E_4F8B = _____8840_91CF_8282_70B9_89E6_53D1_5668_8868[key]
        if _____5B9E_4F8B ~= nil then
            _____5B9E_4F8B["推进"](_____5B9E_4F8B)
        end
    end
end
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitState = jass.GetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isValidUnit = ____require_result_1.isValidUnit
_____8840_91CF_8282_70B9_89E6_53D1_5668_8868 = {}
local _____8840_91CF_8282_70B9_89E6_53D1_5668_9A71_52A8ID = 0
local _____4E0B_4E00_4E2A_8840_91CF_8282_70B9_89E6_53D1_5668ID = 0
local function _____53D6_751F_547D_767E_5206_6BD4(_____5355_4F4D)
    local max = GetUnitStateJapi(_____5355_4F4D, UNIT_STATE_MAX_LIFE)
    if not (max > 0) then
        return 0
    end
    return GetUnitState(_____5355_4F4D, UNIT_STATE_LIFE) / max
end
local function _____786E_4FDD_8840_91CF_8282_70B9_89E6_53D1_5668_9A71_52A8(_____95F4_9694_6BEB_79D2)
    if _____8840_91CF_8282_70B9_89E6_53D1_5668_9A71_52A8ID ~= 0 then
        return
    end
    _____8840_91CF_8282_70B9_89E6_53D1_5668_9A71_52A8ID = addPeriodicCallback(_____95F4_9694_6BEB_79D2, ____on_8840_91CF_8282_70B9_89E6_53D1_5668Tick)
end
local function _____5C1D_8BD5_505C_6B62_8840_91CF_8282_70B9_89E6_53D1_5668_9A71_52A8()
    for key in pairs(_____8840_91CF_8282_70B9_89E6_53D1_5668_8868) do
        if _____8840_91CF_8282_70B9_89E6_53D1_5668_8868[key] ~= nil then
            return
        end
    end
    if _____8840_91CF_8282_70B9_89E6_53D1_5668_9A71_52A8ID ~= 0 then
        removePeriodicCallback(_____8840_91CF_8282_70B9_89E6_53D1_5668_9A71_52A8ID)
        _____8840_91CF_8282_70B9_89E6_53D1_5668_9A71_52A8ID = 0
    end
end
local _____8840_91CF_8282_70B9_89E6_53D1_5668_5B9E_73B0 = __TS__Class()
_____8840_91CF_8282_70B9_89E6_53D1_5668_5B9E_73B0.name = "血量节点触发器实现"
function _____8840_91CF_8282_70B9_89E6_53D1_5668_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["已触发表"] = {}
    self["已停止"] = false
    _____4E0B_4E00_4E2A_8840_91CF_8282_70B9_89E6_53D1_5668ID = _____4E0B_4E00_4E2A_8840_91CF_8282_70B9_89E6_53D1_5668ID + 1
    self.ID = _____4E0B_4E00_4E2A_8840_91CF_8282_70B9_89E6_53D1_5668ID
    self["参数"] = _____53C2_6570
    _____8840_91CF_8282_70B9_89E6_53D1_5668_8868[self.ID] = self
    _____786E_4FDD_8840_91CF_8282_70B9_89E6_53D1_5668_9A71_52A8(_____53C2_6570["Tick间隔毫秒"] or 100)
end
_____8840_91CF_8282_70B9_89E6_53D1_5668_5B9E_73B0.prototype["推进"] = function(self)
    if self["已停止"] then
        return
    end
    local _____5355_4F4D = self["参数"]["单位"]
    if not isValidUnit(_____5355_4F4D) then
        if self["参数"]["on单位失效"] ~= nil then
            self["参数"]["on单位失效"](_____5355_4F4D)
        end
        self["停止"](self)
        return
    end
    local _____5F53_524D_767E_5206_6BD4 = _____53D6_751F_547D_767E_5206_6BD4(_____5355_4F4D)
    local _____8282_70B9_5217_8868 = self["参数"]["节点列表"]
    do
        local i = 0
        while i < #_____8282_70B9_5217_8868 do
            do
                local _____8282_70B9 = _____8282_70B9_5217_8868[i + 1]
                if self["已触发表"][_____8282_70B9.ID] ~= nil then
                    goto __continue21
                end
                if _____5F53_524D_767E_5206_6BD4 <= _____8282_70B9["百分比"] then
                    self["已触发表"][_____8282_70B9.ID] = true
                    _____8282_70B9["on触发"](_____5355_4F4D, _____5F53_524D_767E_5206_6BD4)
                end
            end
            ::__continue21::
            i = i + 1
        end
    end
end
_____8840_91CF_8282_70B9_89E6_53D1_5668_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    __TS__Delete(_____8840_91CF_8282_70B9_89E6_53D1_5668_8868, self.ID)
    _____5C1D_8BD5_505C_6B62_8840_91CF_8282_70B9_89E6_53D1_5668_9A71_52A8()
end
____exports["创建血量节点触发器"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____8840_91CF_8282_70B9_89E6_53D1_5668_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_2 = _____53C2_6570["清理"]
        ____self_2["登记清理"](
            ____self_2,
            _____53C2_6570["名称"],
            function()
                _____5B9E_4F8B["停止"](_____5B9E_4F8B)
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
