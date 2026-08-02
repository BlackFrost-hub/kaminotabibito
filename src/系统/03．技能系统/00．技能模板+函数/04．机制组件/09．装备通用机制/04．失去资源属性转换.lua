local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____on_5931_53BB_8D44_6E90_5C5E_6027_8F6C_6362Tick
function ____on_5931_53BB_8D44_6E90_5C5E_6027_8F6C_6362Tick(variable)
    local _____63A7_5236_5668 = variable
    if _____63A7_5236_5668 ~= nil then
        _____63A7_5236_5668["刷新"](_____63A7_5236_5668)
    end
end
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local R2I = jass.R2I
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local function _____5355_4F4D_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_8D44_6E90_6BD4_4F8B(_____5355_4F4D, _____7C7B_578B)
    local ____5355_4F4D_2 = _____5355_4F4D
    local ____temp_1
    if _____7C7B_578B == "生命" then
        ____temp_1 = UNIT_STATE_LIFE
    else
        ____temp_1 = UNIT_STATE_MANA
    end
    local current = GetUnitState(____5355_4F4D_2, ____temp_1)
    local ____5355_4F4D_4 = _____5355_4F4D
    local ____temp_3
    if _____7C7B_578B == "生命" then
        ____temp_3 = UNIT_STATE_MAX_LIFE
    else
        ____temp_3 = UNIT_STATE_MAX_MANA
    end
    local max = GetUnitStateJapi(____5355_4F4D_4, ____temp_3)
    if max <= 0 then
        return 0
    end
    local missing = max - current
    if missing <= 0 then
        return 0
    end
    return missing / max
end
local _____5931_53BB_8D44_6E90_5C5E_6027_8F6C_6362_5B9E_73B0 = __TS__Class()
_____5931_53BB_8D44_6E90_5C5E_6027_8F6C_6362_5B9E_73B0.name = "失去资源属性转换实现"
function _____5931_53BB_8D44_6E90_5C5E_6027_8F6C_6362_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____53C2_6570, _____63A7_5236_5668ID)
    self["当前档位"] = 0
    self["Tick回调ID"] = 0
    self["已停止"] = false
    self["名称"] = _____540D_79F0
    self["参数"] = _____53C2_6570
    self["控制器ID"] = _____63A7_5236_5668ID
    self["刷新"](self)
    self["Tick回调ID"] = addPeriodicCallback(_____53C2_6570["检查间隔毫秒"] or 200, ____on_5931_53BB_8D44_6E90_5C5E_6027_8F6C_6362Tick, self)
end
_____5931_53BB_8D44_6E90_5C5E_6027_8F6C_6362_5B9E_73B0.prototype["读取档位"] = function(self)
    return self["当前档位"]
end
_____5931_53BB_8D44_6E90_5C5E_6027_8F6C_6362_5B9E_73B0.prototype["刷新"] = function(self)
    if self["已停止"] then
        return self["当前档位"]
    end
    if not _____5355_4F4D_6709_6548(self["参数"]["单位"]) then
        self["设置档位"](self, 0, 0)
        return self["当前档位"]
    end
    local ratio = _____53D6_8D44_6E90_6BD4_4F8B(self["参数"]["单位"], self["参数"]["资源类型"])
    local maxRatio = self["参数"]["满档缺失比例"] > 0 and self["参数"]["满档缺失比例"] or 1
    local normalized = ratio / maxRatio
    if normalized < 0 then
        normalized = 0
    end
    if normalized > 1 then
        normalized = 1
    end
    local _____6863_4F4D_6570_91CF = self["参数"]["档位数量"] ~= nil and self["参数"]["档位数量"] > 0 and self["参数"]["档位数量"] or 100
    local _____65B0_6863_4F4D = R2I(normalized * _____6863_4F4D_6570_91CF)
    self["设置档位"](self, _____65B0_6863_4F4D, ratio)
    return self["当前档位"]
end
_____5931_53BB_8D44_6E90_5C5E_6027_8F6C_6362_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    if self["Tick回调ID"] ~= 0 then
        removePeriodicCallback(self["Tick回调ID"])
        self["Tick回调ID"] = 0
    end
    if self["当前档位"] ~= 0 then
        self["设置档位"](self, 0, 0)
    end
end
_____5931_53BB_8D44_6E90_5C5E_6027_8F6C_6362_5B9E_73B0.prototype["设置档位"] = function(self, _____65B0_6863_4F4D, _____7F3A_5931_6BD4_4F8B)
    if _____65B0_6863_4F4D == self["当前档位"] then
        return
    end
    local _____65E7_6863_4F4D = self["当前档位"]
    self["当前档位"] = _____65B0_6863_4F4D
    self["参数"]["on档位变化"]({
        ["单位"] = self["参数"]["单位"],
        ["旧档位"] = _____65E7_6863_4F4D,
        ["新档位"] = _____65B0_6863_4F4D,
        ["缺失比例"] = _____7F3A_5931_6BD4_4F8B,
        ["满档比例"] = self["参数"]["满档缺失比例"]
    })
end
local _____5931_53BB_8D44_6E90_5C5E_6027_8F6C_6362_8BA1_6570 = 0
____exports["创建失去资源属性转换"] = function(_____53C2_6570)
    _____5931_53BB_8D44_6E90_5C5E_6027_8F6C_6362_8BA1_6570 = _____5931_53BB_8D44_6E90_5C5E_6027_8F6C_6362_8BA1_6570 + 1
    return __TS__New(_____5931_53BB_8D44_6E90_5C5E_6027_8F6C_6362_5B9E_73B0, _____53C2_6570["名称"] or "失去资源属性转换", _____53C2_6570, _____5931_53BB_8D44_6E90_5C5E_6027_8F6C_6362_8BA1_6570)
end
return ____exports
