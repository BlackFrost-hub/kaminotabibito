local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local function _____5355_4F4D_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true
end
local function _____4E24_70B9_8DDD_79BB_5E73_65B9(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return dx * dx + dy * dy
end
local function _____53D6_5EF6_8FDF_6BEB_79D2(_____53C2_6570)
    if _____53C2_6570["延迟毫秒"] ~= nil then
        local _____5EF6_8FDF = math.floor(_____53C2_6570["延迟毫秒"])
        return _____5EF6_8FDF > 0 and _____5EF6_8FDF or 0
    end
    if _____53C2_6570["延迟秒"] ~= nil then
        local _____5EF6_8FDF = math.floor(_____53C2_6570["延迟秒"] * 1000)
        return _____5EF6_8FDF > 0 and _____5EF6_8FDF or 0
    end
    return 0
end
local _____70B9_540D_5206_644A_7ED3_7B97_63A7_5236_5668_5B9E_73B0 = __TS__Class()
_____70B9_540D_5206_644A_7ED3_7B97_63A7_5236_5668_5B9E_73B0.name = "点名分摊结算控制器实现"
function _____70B9_540D_5206_644A_7ED3_7B97_63A7_5236_5668_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____5EF6_8FDF_56DE_8C03ID)
    self["已取消"] = false
    self["名称"] = _____540D_79F0
    self["延迟回调ID"] = _____5EF6_8FDF_56DE_8C03ID
    local ____self = self
    self["取消"] = function()
        if ____self["已取消"] then
            return
        end
        ____self["已取消"] = true
        if ____self["延迟回调ID"] ~= 0 then
            removeDelayedCallback(____self["延迟回调ID"])
        end
    end
end
____exports["创建点名分摊结算"] = function(_____53C2_6570)
    local _____540D_79F0 = _____53C2_6570["名称"] or "点名分摊结算"
    local _____76EE_6807 = _____53C2_6570["点名目标"]
    local _____521D_59CBX = _____5355_4F4D_6709_6548(_____76EE_6807) and GetUnitX(_____76EE_6807) or 0
    local _____521D_59CBY = _____5355_4F4D_6709_6548(_____76EE_6807) and GetUnitY(_____76EE_6807) or 0
    if _____53C2_6570["on锁定"] ~= nil then
        _____53C2_6570["on锁定"](_____76EE_6807, _____521D_59CBX, _____521D_59CBY)
    end
    local _____63A7_5236_5668
    local _____5EF6_8FDF_56DE_8C03ID = addDelayedCallback(
        _____53D6_5EF6_8FDF_6BEB_79D2(_____53C2_6570),
        function()
            if _____63A7_5236_5668 == nil then
                return
            end
            if _____63A7_5236_5668["已取消"] == true then
                return
            end
            if not _____5355_4F4D_6709_6548(_____76EE_6807) then
                _____53C2_6570["on结算"]({
                    ["点名目标"] = _____76EE_6807,
                    ["分摊单位列表"] = {},
                    ["分摊人数"] = 0,
                    ["中心X"] = _____521D_59CBX,
                    ["中心Y"] = _____521D_59CBY
                })
                return
            end
            local _____4E2D_5FC3X = GetUnitX(_____76EE_6807)
            local _____4E2D_5FC3Y = GetUnitY(_____76EE_6807)
            local _____534A_5F84_5E73_65B9 = _____53C2_6570["分摊半径"] * _____53C2_6570["分摊半径"]
            local _____5206_644A_5355_4F4D_5217_8868 = {}
            do
                local i = 0
                while i < #_____53C2_6570["参与单位列表"] do
                    do
                        local _____5355_4F4D = _____53C2_6570["参与单位列表"][i + 1]
                        if not _____5355_4F4D_6709_6548(_____5355_4F4D) then
                            goto __continue18
                        end
                        if _____5355_4F4D == _____76EE_6807 and _____53C2_6570["包含点名目标"] == false then
                            goto __continue18
                        end
                        if _____53C2_6570["过滤单位"] ~= nil and not _____53C2_6570["过滤单位"](_____5355_4F4D) then
                            goto __continue18
                        end
                        if _____4E24_70B9_8DDD_79BB_5E73_65B9(
                            GetUnitX(_____5355_4F4D),
                            GetUnitY(_____5355_4F4D),
                            _____4E2D_5FC3X,
                            _____4E2D_5FC3Y
                        ) <= _____534A_5F84_5E73_65B9 then
                            _____5206_644A_5355_4F4D_5217_8868[#_____5206_644A_5355_4F4D_5217_8868 + 1] = _____5355_4F4D
                        end
                    end
                    ::__continue18::
                    i = i + 1
                end
            end
            _____53C2_6570["on结算"]({
                ["点名目标"] = _____76EE_6807,
                ["分摊单位列表"] = _____5206_644A_5355_4F4D_5217_8868,
                ["分摊人数"] = #_____5206_644A_5355_4F4D_5217_8868,
                ["中心X"] = _____4E2D_5FC3X,
                ["中心Y"] = _____4E2D_5FC3Y
            })
        end
    )
    _____63A7_5236_5668 = __TS__New(_____70B9_540D_5206_644A_7ED3_7B97_63A7_5236_5668_5B9E_73B0, _____540D_79F0, _____5EF6_8FDF_56DE_8C03ID)
    if _____53C2_6570["清理篮子"] ~= nil then
        if _____53C2_6570["清理篮子"]["登记延迟回调"] ~= nil then
            local ____self_1 = _____53C2_6570["清理篮子"]
            ____self_1["登记延迟回调"](____self_1, _____540D_79F0 .. "-延迟结算", _____5EF6_8FDF_56DE_8C03ID)
        else
            local ____self_2 = _____53C2_6570["清理篮子"]
            ____self_2["登记清理"](
                ____self_2,
                _____540D_79F0 .. "-取消",
                function()
                    _____63A7_5236_5668["取消"]()
                end
            )
        end
    end
    return _____63A7_5236_5668
end
return ____exports
