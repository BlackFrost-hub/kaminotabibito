local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____on_4E3B_52A8_6280_80FD_6D41_7A0B_5355_4F4D_6B7B_4EA1, _____6D3B_8DC3_6D41_7A0B_5217_8868
function ____on_4E3B_52A8_6280_80FD_6D41_7A0B_5355_4F4D_6B7B_4EA1(dyingUnit)
    do
        local i = #_____6D3B_8DC3_6D41_7A0B_5217_8868 - 1
        while i >= 0 do
            local _____5B9E_4F8B = _____6D3B_8DC3_6D41_7A0B_5217_8868[i + 1]
            if _____5B9E_4F8B ~= nil then
                _____5B9E_4F8B["处理单位死亡"](_____5B9E_4F8B, dyingUnit)
            end
            i = i - 1
        end
    end
end
local jass = require("jass.common")
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
_____6D3B_8DC3_6D41_7A0B_5217_8868 = {}
local _____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C = false
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____79FB_9664_6D3B_8DC3_6D41_7A0B(_____5B9E_4F8B)
    do
        local i = #_____6D3B_8DC3_6D41_7A0B_5217_8868 - 1
        while i >= 0 do
            if _____6D3B_8DC3_6D41_7A0B_5217_8868[i + 1] == _____5B9E_4F8B then
                __TS__ArraySplice(_____6D3B_8DC3_6D41_7A0B_5217_8868, i, 1)
                break
            end
            i = i - 1
        end
    end
end
local function _____786E_4FDD_6B7B_4EA1_76D1_542C()
    if _____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C = true
    registerDeathListener(____on_4E3B_52A8_6280_80FD_6D41_7A0B_5355_4F4D_6B7B_4EA1)
end
local function ____on_4E3B_52A8_6280_80FD_6D41_7A0B_6E05_7406(variable)
    local _____5B9E_4F8B = variable
    if _____5B9E_4F8B ~= nil then
        _____5B9E_4F8B["停止"](_____5B9E_4F8B, "清理")
    end
end
local _____4E3B_52A8_6280_80FD_6D41_7A0B_751F_547D_5468_671F_5B9E_73B0 = __TS__Class()
_____4E3B_52A8_6280_80FD_6D41_7A0B_751F_547D_5468_671F_5B9E_73B0.name = "主动技能流程生命周期实现"
function _____4E3B_52A8_6280_80FD_6D41_7A0B_751F_547D_5468_671F_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["已结束值"] = false
    self["参数"] = _____53C2_6570
    local ____opt_1 = _____53C2_6570["清理"]
    if ____opt_1 and ____opt_1["已清理"](____opt_1) then
        self["结束内部"](self, "清理", false)
        return
    end
    if _____53C2_6570["施法者死亡时取消"] ~= false and not _____5355_4F4D_6709_6548(_____53C2_6570["施法者"]) then
        self["结束内部"](self, "死亡", false)
        return
    end
    if _____53C2_6570["目标死亡时取消"] == true and _____53C2_6570["目标"] ~= nil and _____53C2_6570["目标"] ~= 0 and not _____5355_4F4D_6709_6548(_____53C2_6570["目标"]) then
        self["结束内部"](self, "目标失效", false)
        return
    end
    _____6D3B_8DC3_6D41_7A0B_5217_8868[#_____6D3B_8DC3_6D41_7A0B_5217_8868 + 1] = self
    _____786E_4FDD_6B7B_4EA1_76D1_542C()
    if _____53C2_6570["清理"] ~= nil then
        local ____self_3 = _____53C2_6570["清理"]
        ____self_3["登记清理"](____self_3, _____53C2_6570["名称"] .. "-停止流程", ____on_4E3B_52A8_6280_80FD_6D41_7A0B_6E05_7406, self)
    end
end
_____4E3B_52A8_6280_80FD_6D41_7A0B_751F_547D_5468_671F_5B9E_73B0.prototype["停止"] = function(self, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "中断"
    end
    return self["结束内部"](self, _____539F_56E0, true)
end
_____4E3B_52A8_6280_80FD_6D41_7A0B_751F_547D_5468_671F_5B9E_73B0.prototype["结束"] = function(self, _____539F_56E0)
    return self["结束内部"](self, _____539F_56E0, false)
end
_____4E3B_52A8_6280_80FD_6D41_7A0B_751F_547D_5468_671F_5B9E_73B0.prototype["完成"] = function(self)
    return self["结束内部"](self, "完成", false)
end
_____4E3B_52A8_6280_80FD_6D41_7A0B_751F_547D_5468_671F_5B9E_73B0.prototype["是否结束"] = function(self)
    return self["已结束值"]
end
_____4E3B_52A8_6280_80FD_6D41_7A0B_751F_547D_5468_671F_5B9E_73B0.prototype["读取结束原因"] = function(self)
    return self["结束原因"]
end
_____4E3B_52A8_6280_80FD_6D41_7A0B_751F_547D_5468_671F_5B9E_73B0.prototype["处理单位死亡"] = function(self, dyingUnit)
    if self["已结束值"] then
        return
    end
    if self["参数"]["施法者死亡时取消"] ~= false and dyingUnit == self["参数"]["施法者"] then
        self["停止"](self, "死亡")
        return
    end
    if self["参数"]["目标死亡时取消"] == true and dyingUnit == self["参数"]["目标"] then
        self["停止"](self, "目标失效")
    end
end
_____4E3B_52A8_6280_80FD_6D41_7A0B_751F_547D_5468_671F_5B9E_73B0.prototype["结束内部"] = function(self, _____539F_56E0, _____8C03_7528_505C_6B62_56DE_8C03)
    if self["已结束值"] then
        return false
    end
    self["已结束值"] = true
    self["结束原因"] = _____539F_56E0
    _____79FB_9664_6D3B_8DC3_6D41_7A0B(self)
    if _____8C03_7528_505C_6B62_56DE_8C03 and self["参数"]["on停止"] ~= nil then
        self["参数"]["on停止"](_____539F_56E0, self["参数"]["变量"])
    end
    if self["参数"]["on结束"] ~= nil then
        self["参数"]["on结束"](_____539F_56E0, self["参数"]["变量"])
    end
    return true
end
____exports["创建主动技能流程生命周期"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____4E3B_52A8_6280_80FD_6D41_7A0B_751F_547D_5468_671F_5B9E_73B0, _____53C2_6570)
    return {
        ["停止"] = function(_____539F_56E0)
            return _____5B9E_4F8B["停止"](_____5B9E_4F8B, _____539F_56E0)
        end,
        ["结束"] = function(_____539F_56E0)
            return _____5B9E_4F8B["结束"](_____5B9E_4F8B, _____539F_56E0)
        end,
        ["完成"] = function()
            return _____5B9E_4F8B["完成"](_____5B9E_4F8B)
        end,
        ["是否结束"] = function()
            return _____5B9E_4F8B["是否结束"](_____5B9E_4F8B)
        end,
        ["读取结束原因"] = function()
            return _____5B9E_4F8B["读取结束原因"](_____5B9E_4F8B)
        end
    }
end
return ____exports
