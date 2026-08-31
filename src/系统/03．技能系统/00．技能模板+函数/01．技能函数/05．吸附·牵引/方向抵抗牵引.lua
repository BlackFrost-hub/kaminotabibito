local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local IsUnitType = jass.IsUnitType
local GetUnitState = jass.GetUnitState
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local SquareRoot = jass.SquareRoot
local Atan2 = jass.Atan2
local Cos = jass.Cos
local Sin = jass.Sin
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local _____89D2_5EA6_8F6C_5F27_5EA6 = 0.017453292519943295
local _____5F27_5EA6_8F6C_89D2_5EA6 = 57.29577951308232
local function _____5355_4F4D_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true and GetUnitState(_____5355_4F4D, UNIT_STATE_LIFE) > 0.405
end
local function _____89D2_5EA6_5DEE(a, b)
    local diff = a - b
    while diff > 180 do
        diff = diff - 360
    end
    while diff < -180 do
        diff = diff + 360
    end
    return diff < 0 and -diff or diff
end
local function _____53D6_4E2D_5FC3(_____53C2_6570)
    if _____5355_4F4D_6709_6548(_____53C2_6570["中心单位"]) then
        return {
            x = GetUnitX(_____53C2_6570["中心单位"]),
            y = GetUnitY(_____53C2_6570["中心单位"])
        }
    end
    if _____53C2_6570["中心X"] ~= nil and _____53C2_6570["中心Y"] ~= nil then
        return {x = _____53C2_6570["中心X"], y = _____53C2_6570["中心Y"]}
    end
    return nil
end
local _____65B9_5411_62B5_6297_7275_5F15_63A7_5236_5668_5B9E_73B0 = __TS__Class()
_____65B9_5411_62B5_6297_7275_5F15_63A7_5236_5668_5B9E_73B0.name = "方向抵抗牵引控制器实现"
function _____65B9_5411_62B5_6297_7275_5F15_63A7_5236_5668_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____53C2_6570)
    self["周期回调ID"] = 0
    self["已停止"] = false
    self["运行毫秒"] = 0
    self["已执行次数"] = 0
    self["位置记录"] = {}
    self["名称"] = _____540D_79F0
    self["参数"] = _____53C2_6570
end
_____65B9_5411_62B5_6297_7275_5F15_63A7_5236_5668_5B9E_73B0.prototype["设置周期回调ID"] = function(self, id)
    self["周期回调ID"] = id
end
function _____65B9_5411_62B5_6297_7275_5F15_63A7_5236_5668_5B9E_73B0.prototype.Tick(self)
    if self["已停止"] then
        return
    end
    if self["参数"]["最大执行次数"] ~= nil and self["已执行次数"] >= self["参数"]["最大执行次数"] then
        self["停止"](self)
        if self["参数"]["on结束"] ~= nil then
            self["参数"]["on结束"]()
        end
        return
    end
    local ____tick_6BEB_79D2 = self["参数"]["Tick毫秒"] or 20
    self["运行毫秒"] = self["运行毫秒"] + ____tick_6BEB_79D2
    if self["运行毫秒"] >= self["参数"]["持续秒"] * 1000 then
        self["停止"](self)
        if self["参数"]["on结束"] ~= nil then
            self["参数"]["on结束"]()
        end
        return
    end
    local _____4E2D_5FC3 = _____53D6_4E2D_5FC3(self["参数"])
    if _____4E2D_5FC3 == nil then
        return
    end
    local _____6BCFTick_62C9_529B = self["参数"]["每秒拉力速度"] * ____tick_6BEB_79D2 / 1000
    local _____542F_7528_65B9_5411_62B5_6297 = self["参数"]["启用方向抵抗"] ~= false
    local _____62B5_6297_5939_89D2 = self["参数"]["抵抗夹角"] or 45
    local _____62B5_6297_500D_7387 = self["参数"]["抵抗后拉力倍率"] or 0.25
    local _____6700_5C0F_4F4D_79FB_8BC6_522B = self["参数"]["最小位移识别"] or 2
    local _____5230_8FBE_8DDD_79BB = self["参数"]["到达距离"] or 32
    local ____temp_1
    if self["参数"]["目标单位提供器"] ~= nil then
        ____temp_1 = self["参数"]["目标单位提供器"]()
    else
        ____temp_1 = self["参数"]["目标单位列表"]
    end
    local _____76EE_6807_5355_4F4D_5217_8868 = ____temp_1 or ({})
    do
        local i = 0
        while i < #_____76EE_6807_5355_4F4D_5217_8868 do
            do
                local _____5355_4F4D = _____76EE_6807_5355_4F4D_5217_8868[i + 1]
                if not _____5355_4F4D_6709_6548(_____5355_4F4D) then
                    goto __continue19
                end
                if self["参数"]["过滤单位"] ~= nil and not self["参数"]["过滤单位"](_____5355_4F4D) then
                    goto __continue19
                end
                local x = GetUnitX(_____5355_4F4D)
                local y = GetUnitY(_____5355_4F4D)
                local id = jass.GetHandleId(_____5355_4F4D) or 0
                local _____4E0A_6B21 = self["位置记录"][id]
                local _____62C9_529B_500D_7387 = 1
                if _____542F_7528_65B9_5411_62B5_6297 and _____4E0A_6B21 ~= nil then
                    local mx = x - _____4E0A_6B21.x
                    local my = y - _____4E0A_6B21.y
                    if mx * mx + my * my >= _____6700_5C0F_4F4D_79FB_8BC6_522B * _____6700_5C0F_4F4D_79FB_8BC6_522B then
                        local _____79FB_52A8_89D2_5EA6 = Atan2(my, mx) * _____5F27_5EA6_8F6C_89D2_5EA6
                        if _____89D2_5EA6_5DEE(_____79FB_52A8_89D2_5EA6, self["参数"]["抵抗方向角度"]) <= _____62B5_6297_5939_89D2 then
                            _____62C9_529B_500D_7387 = _____62B5_6297_500D_7387
                        end
                    end
                end
                local dx = _____4E2D_5FC3.x - x
                local dy = _____4E2D_5FC3.y - y
                local _____8DDD_79BB = SquareRoot(dx * dx + dy * dy)
                if _____8DDD_79BB > _____5230_8FBE_8DDD_79BB then
                    local _____62C9_529B_89D2_5EA6 = Atan2(dy, dx)
                    local _____4F4D_79FB = _____6BCFTick_62C9_529B * _____62C9_529B_500D_7387
                    SetUnitX(
                        _____5355_4F4D,
                        x + Cos(_____62C9_529B_89D2_5EA6) * _____4F4D_79FB
                    )
                    SetUnitY(
                        _____5355_4F4D,
                        y + Sin(_____62C9_529B_89D2_5EA6) * _____4F4D_79FB
                    )
                end
                self["位置记录"][id] = {
                    x = GetUnitX(_____5355_4F4D),
                    y = GetUnitY(_____5355_4F4D)
                }
            end
            ::__continue19::
            i = i + 1
        end
    end
    self["已执行次数"] = self["已执行次数"] + 1
    if self["参数"]["最大执行次数"] ~= nil and self["已执行次数"] >= self["参数"]["最大执行次数"] then
        self["停止"](self)
        if self["参数"]["on结束"] ~= nil then
            self["参数"]["on结束"]()
        end
    end
end
_____65B9_5411_62B5_6297_7275_5F15_63A7_5236_5668_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    if self["周期回调ID"] ~= 0 then
        removePeriodicCallback(self["周期回调ID"])
        self["周期回调ID"] = 0
    end
    self["位置记录"] = {}
end
____exports["开始方向抵抗牵引"] = function(_____53C2_6570)
    local _____540D_79F0 = _____53C2_6570["名称"] or "方向抵抗牵引"
    local _____63A7_5236_5668 = __TS__New(_____65B9_5411_62B5_6297_7275_5F15_63A7_5236_5668_5B9E_73B0, _____540D_79F0, _____53C2_6570)
    local ____tick_6BEB_79D2 = _____53C2_6570["Tick毫秒"] or 20
    local id = addPeriodicCallback(
        ____tick_6BEB_79D2,
        function()
            _____63A7_5236_5668:Tick()
        end
    )
    _____63A7_5236_5668["设置周期回调ID"](_____63A7_5236_5668, id)
    if _____53C2_6570["清理篮子"] ~= nil then
        if _____53C2_6570["清理篮子"]["登记周期回调"] ~= nil then
            local ____self_2 = _____53C2_6570["清理篮子"]
            ____self_2["登记周期回调"](____self_2, _____540D_79F0 .. "-周期", id)
        else
            local ____self_3 = _____53C2_6570["清理篮子"]
            ____self_3["登记清理"](
                ____self_3,
                _____540D_79F0 .. "-停止",
                function()
                    _____63A7_5236_5668["停止"](_____63A7_5236_5668)
                end
            )
        end
    end
    return _____63A7_5236_5668
end
return ____exports
