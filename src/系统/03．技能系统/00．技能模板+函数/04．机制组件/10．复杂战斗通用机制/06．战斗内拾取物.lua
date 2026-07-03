local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____on_62FE_53D6_7269Tick, getServerTime, _____62FE_53D6_7269_8868
function ____on_62FE_53D6_7269Tick()
    local now = getServerTime()
    for key in pairs(_____62FE_53D6_7269_8868) do
        local _____5B9E_4F8B = _____62FE_53D6_7269_8868[key]
        if _____5B9E_4F8B ~= nil then
            _____5B9E_4F8B["推进"](_____5B9E_4F8B, now)
        end
    end
end
local jass = require("jass.common")
local japi = require("jass.japi")
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local SquareRoot = jass.SquareRoot
local EXSetEffectXY = japi.EXSetEffectXY
local EXSetEffectZ = japi.EXSetEffectZ
local EXSetEffectSize = japi.EXSetEffectSize
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
_____62FE_53D6_7269_8868 = {}
local _____4E0B_4E00_4E2A_62FE_53D6_7269ID = 0
local _____62FE_53D6_7269_9A71_52A8ID = 0
local function _____8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return SquareRoot(dx * dx + dy * dy)
end
local function _____786E_4FDD_9A71_52A8(_____95F4_9694_6BEB_79D2)
    if _____62FE_53D6_7269_9A71_52A8ID ~= 0 then
        return
    end
    _____62FE_53D6_7269_9A71_52A8ID = addPeriodicCallback(_____95F4_9694_6BEB_79D2, ____on_62FE_53D6_7269Tick)
end
local function _____5C1D_8BD5_505C_6B62_9A71_52A8()
    for key in pairs(_____62FE_53D6_7269_8868) do
        if _____62FE_53D6_7269_8868[key] ~= nil then
            return
        end
    end
    if _____62FE_53D6_7269_9A71_52A8ID ~= 0 then
        removePeriodicCallback(_____62FE_53D6_7269_9A71_52A8ID)
        _____62FE_53D6_7269_9A71_52A8ID = 0
    end
end
local _____6218_6597_5185_62FE_53D6_7269_5B9E_73B0 = __TS__Class()
_____6218_6597_5185_62FE_53D6_7269_5B9E_73B0.name = "战斗内拾取物实现"
function _____6218_6597_5185_62FE_53D6_7269_5B9E_73B0.prototype.____constructor(self, ID, _____53C2_6570, _____7279_6548)
    self["到期时间"] = 0
    self["已销毁"] = false
    self.ID = ID
    self["参数"] = _____53C2_6570
    self["特效"] = _____7279_6548
    self.x = _____53C2_6570.X
    self.y = _____53C2_6570.Y
    if _____53C2_6570["持续秒"] ~= nil and _____53C2_6570["持续秒"] > 0 then
        self["到期时间"] = getServerTime() + _____53C2_6570["持续秒"] * 1000
    end
    _____62FE_53D6_7269_8868[ID] = self
end
_____6218_6597_5185_62FE_53D6_7269_5B9E_73B0.prototype["取X"] = function(self)
    return self.x
end
_____6218_6597_5185_62FE_53D6_7269_5B9E_73B0.prototype["取Y"] = function(self)
    return self.y
end
_____6218_6597_5185_62FE_53D6_7269_5B9E_73B0.prototype["移动到"] = function(self, x, y)
    self.x = x
    self.y = y
    if type(EXSetEffectXY) == "function" then
        EXSetEffectXY(self["特效"], x, y)
    end
end
_____6218_6597_5185_62FE_53D6_7269_5B9E_73B0.prototype["销毁"] = function(self, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "手动销毁"
    end
    if self["已销毁"] then
        return
    end
    self["已销毁"] = true
    __TS__Delete(_____62FE_53D6_7269_8868, self.ID)
    if self["特效"] ~= nil and self["特效"] ~= 0 then
        DestroyEffect(self["特效"])
    end
    if self["参数"]["on销毁"] ~= nil then
        self["参数"]["on销毁"](self, _____539F_56E0, self["参数"]["变量"])
    end
    _____5C1D_8BD5_505C_6B62_9A71_52A8()
end
_____6218_6597_5185_62FE_53D6_7269_5B9E_73B0.prototype["推进"] = function(self, now)
    if self["已销毁"] then
        return
    end
    if self["到期时间"] > 0 and now >= self["到期时间"] then
        if self["参数"]["on过期"] ~= nil then
            self["参数"]["on过期"](self, self["参数"]["变量"])
        end
        self["销毁"](self, "过期")
        return
    end
    if self["推进吸附"](self) then
        return
    end
    self["检查拾取"](self)
end
_____6218_6597_5185_62FE_53D6_7269_5B9E_73B0.prototype["读取可拾取单位"] = function(self)
    local raw = self["参数"]["可拾取单位列表"]
    return type(raw) == "function" and raw(self["参数"]["变量"]) or raw
end
_____6218_6597_5185_62FE_53D6_7269_5B9E_73B0.prototype["检查拾取"] = function(self)
    local units = self["读取可拾取单位"](self)
    local radius = self["参数"]["拾取半径"]
    do
        local i = 0
        while i < #units do
            do
                local unit = units[i + 1]
                if unit == nil or unit == 0 then
                    goto __continue32
                end
                if _____8DDD_79BB(
                    self.x,
                    self.y,
                    GetUnitX(unit),
                    GetUnitY(unit)
                ) <= radius then
                    if self["参数"]["on拾取"] ~= nil then
                        self["参数"]["on拾取"](unit, self, self["参数"]["变量"])
                    end
                    self["销毁"](self, "拾取")
                    return
                end
            end
            ::__continue32::
            i = i + 1
        end
    end
end
_____6218_6597_5185_62FE_53D6_7269_5B9E_73B0.prototype["推进吸附"] = function(self)
    local target = self["参数"]["吸附目标"]
    if target == nil or target == 0 then
        return false
    end
    local tx = GetUnitX(target)
    local ty = GetUnitY(target)
    local dist = _____8DDD_79BB(self.x, self.y, tx, ty)
    if dist <= (self["参数"]["吸附半径"] or self["参数"]["拾取半径"]) then
        if self["参数"]["on吸收"] ~= nil then
            self["参数"]["on吸收"](target, self, self["参数"]["变量"])
        end
        self["销毁"](self, "吸收")
        return true
    end
    local speed = self["参数"]["吸附速度"] or 0
    if speed <= 0 or dist <= 0 then
        return false
    end
    local step = speed * ((self["参数"]["Tick间隔毫秒"] or 50) / 1000)
    local ratio = step >= dist and 1 or step / dist
    self["移动到"](self, self.x + (tx - self.x) * ratio, self.y + (ty - self.y) * ratio)
    return false
end
____exports["创建战斗内拾取物"] = function(_____53C2_6570)
    if _____53C2_6570["模型路径"] == nil or _____53C2_6570["模型路径"] == "" then
        return nil
    end
    local effect = AddSpecialEffect(_____53C2_6570["模型路径"], _____53C2_6570.X, _____53C2_6570.Y)
    if effect == nil or effect == 0 then
        return nil
    end
    if _____53C2_6570["高度"] ~= nil and type(EXSetEffectZ) == "function" then
        EXSetEffectZ(effect, _____53C2_6570["高度"])
    end
    if _____53C2_6570["缩放"] ~= nil and type(EXSetEffectSize) == "function" then
        EXSetEffectSize(effect, _____53C2_6570["缩放"])
    end
    local ____6218_6597_5185_62FE_53D6_7269_5B9E_73B0_1 = _____6218_6597_5185_62FE_53D6_7269_5B9E_73B0
    _____4E0B_4E00_4E2A_62FE_53D6_7269ID = _____4E0B_4E00_4E2A_62FE_53D6_7269ID + 1
    local _____5B9E_4F8B = __TS__New(____6218_6597_5185_62FE_53D6_7269_5B9E_73B0_1, _____4E0B_4E00_4E2A_62FE_53D6_7269ID, _____53C2_6570, effect)
    _____786E_4FDD_9A71_52A8(_____53C2_6570["Tick间隔毫秒"] or 50)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_2 = _____53C2_6570["清理"]
        ____self_2["登记清理"](
            ____self_2,
            (_____53C2_6570["名称"] .. "#") .. tostring(_____5B9E_4F8B.ID),
            function()
                _____5B9E_4F8B["销毁"](_____5B9E_4F8B)
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
