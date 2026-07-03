local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local jass = require("jass.common")
local CreateDestructable = jass.CreateDestructable
local RemoveDestructable = jass.RemoveDestructable
local GetHandleId = jass.GetHandleId
local ____require_result_0 = require("系统.06．经济系统.00．宝箱系统.05．开启中回调")
local _____6CE8_518C_5B9D_7BB1_5F00_542F_4E2D_56DE_8C03 = ____require_result_0["注册宝箱开启中回调"]
local ____require_result_1 = require("系统.06．经济系统.00．宝箱系统.06．开启完成回调")
local _____6CE8_518C_5B9D_7BB1_5F00_542F_5B8C_6210_56DE_8C03 = ____require_result_1["注册宝箱开启完成回调"]
local _____4EA4_4E92_5B9D_7BB1_8868 = {}
local _____5DF2_6CE8_518C_5B9D_7BB1_56DE_8C03 = false
local function stringToFourCC(s)
    local a = #s > 0 and (string.byte(s, 1) or 0 / 0) or 0
    local b = #s > 1 and (string.byte(s, 2) or 0 / 0) or 0
    local c = #s > 2 and (string.byte(s, 3) or 0 / 0) or 0
    local d = #s > 3 and (string.byte(s, 4) or 0 / 0) or 0
    return a * 16777216 + b * 65536 + c * 256 + d
end
local function ____on_4EA4_4E92_5B9D_7BB1_5F00_542F_4E2D(unit, target, _progressBar, _openTime, elapsed, chestConfig, _ownerUnit)
    local _____8BB0_5F55 = _____4EA4_4E92_5B9D_7BB1_8868[GetHandleId(target)]
    if _____8BB0_5F55 == nil or _____8BB0_5F55["参数"]["on开启中"] == nil then
        return
    end
    _____8BB0_5F55["参数"]["on开启中"](
        unit,
        target,
        elapsed,
        chestConfig,
        _____8BB0_5F55["参数"]["变量"]
    )
end
local function ____on_4EA4_4E92_5B9D_7BB1_5F00_542F_5B8C_6210(unit, target, _progressBar, _openTime, chestConfig, _ownerUnit)
    local id = GetHandleId(target)
    local _____8BB0_5F55 = _____4EA4_4E92_5B9D_7BB1_8868[id]
    if _____8BB0_5F55 == nil then
        return
    end
    if _____8BB0_5F55["参数"]["on开启完成"] ~= nil then
        _____8BB0_5F55["参数"]["on开启完成"](unit, target, chestConfig, _____8BB0_5F55["参数"]["变量"])
    end
    __TS__Delete(_____4EA4_4E92_5B9D_7BB1_8868, id)
end
local function _____786E_4FDD_4EA4_4E92_5B9D_7BB1_56DE_8C03()
    if _____5DF2_6CE8_518C_5B9D_7BB1_56DE_8C03 then
        return
    end
    _____5DF2_6CE8_518C_5B9D_7BB1_56DE_8C03 = true
    _____6CE8_518C_5B9D_7BB1_5F00_542F_4E2D_56DE_8C03(____on_4EA4_4E92_5B9D_7BB1_5F00_542F_4E2D)
    _____6CE8_518C_5B9D_7BB1_5F00_542F_5B8C_6210_56DE_8C03(____on_4EA4_4E92_5B9D_7BB1_5F00_542F_5B8C_6210)
end
local _____4EA4_4E92_5B9D_7BB1_5B9E_4F8B_5B9E_73B0 = __TS__Class()
_____4EA4_4E92_5B9D_7BB1_5B9E_4F8B_5B9E_73B0.name = "交互宝箱实例实现"
function _____4EA4_4E92_5B9D_7BB1_5B9E_4F8B_5B9E_73B0.prototype.____constructor(self, _____5B9D_7BB1)
    self["已销毁"] = false
    self["宝箱"] = _____5B9D_7BB1
end
_____4EA4_4E92_5B9D_7BB1_5B9E_4F8B_5B9E_73B0.prototype["销毁"] = function(self)
    if self["已销毁"] then
        return
    end
    self["已销毁"] = true
    __TS__Delete(
        _____4EA4_4E92_5B9D_7BB1_8868,
        GetHandleId(self["宝箱"])
    )
    if self["宝箱"] ~= nil and self["宝箱"] ~= 0 then
        RemoveDestructable(self["宝箱"])
    end
end
____exports["创建交互宝箱"] = function(_____53C2_6570)
    _____786E_4FDD_4EA4_4E92_5B9D_7BB1_56DE_8C03()
    local _____5B9D_7BB1 = CreateDestructable(
        stringToFourCC(_____53C2_6570["可破坏物ID"]),
        _____53C2_6570.X,
        _____53C2_6570.Y,
        _____53C2_6570["朝向"] or 0,
        _____53C2_6570["缩放"] or 1,
        0
    )
    if _____5B9D_7BB1 == nil or _____5B9D_7BB1 == 0 then
        return nil
    end
    local _____5B9E_4F8B = __TS__New(_____4EA4_4E92_5B9D_7BB1_5B9E_4F8B_5B9E_73B0, _____5B9D_7BB1)
    _____4EA4_4E92_5B9D_7BB1_8868[GetHandleId(_____5B9D_7BB1)] = {["参数"] = _____53C2_6570, ["实例"] = _____5B9E_4F8B}
    if _____53C2_6570["清理"] ~= nil then
        local ____self_2 = _____53C2_6570["清理"]
        ____self_2["登记清理"](
            ____self_2,
            _____53C2_6570["名称"],
            function()
                _____5B9E_4F8B["销毁"](_____5B9E_4F8B)
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
