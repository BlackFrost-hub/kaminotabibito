local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____on_591A_6CE2_5EF6_8FDFAOETick, getServerTime, _____591A_6CE2_5EF6_8FDFAOE_8868
local ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382["创建技能提示圈"]
function ____on_591A_6CE2_5EF6_8FDFAOETick()
    local now = getServerTime()
    for key in pairs(_____591A_6CE2_5EF6_8FDFAOE_8868) do
        local _____5B9E_4F8B = _____591A_6CE2_5EF6_8FDFAOE_8868[key]
        if _____5B9E_4F8B ~= nil then
            _____5B9E_4F8B["推进"](_____5B9E_4F8B, now)
        end
    end
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
_____591A_6CE2_5EF6_8FDFAOE_8868 = {}
local _____591A_6CE2_5EF6_8FDFAOE_9A71_52A8ID = 0
local _____4E0B_4E00_4E2A_591A_6CE2_5EF6_8FDFAOEID = 0
local function _____786E_4FDD_591A_6CE2_5EF6_8FDFAOE_9A71_52A8(_____95F4_9694_6BEB_79D2)
    if _____591A_6CE2_5EF6_8FDFAOE_9A71_52A8ID ~= 0 then
        return
    end
    _____591A_6CE2_5EF6_8FDFAOE_9A71_52A8ID = addPeriodicCallback(_____95F4_9694_6BEB_79D2, ____on_591A_6CE2_5EF6_8FDFAOETick)
end
local function _____5C1D_8BD5_505C_6B62_591A_6CE2_5EF6_8FDFAOE_9A71_52A8()
    for key in pairs(_____591A_6CE2_5EF6_8FDFAOE_8868) do
        if _____591A_6CE2_5EF6_8FDFAOE_8868[key] ~= nil then
            return
        end
    end
    if _____591A_6CE2_5EF6_8FDFAOE_9A71_52A8ID ~= 0 then
        removePeriodicCallback(_____591A_6CE2_5EF6_8FDFAOE_9A71_52A8ID)
        _____591A_6CE2_5EF6_8FDFAOE_9A71_52A8ID = 0
    end
end
local _____591A_6CE2_5EF6_8FDFAOE_5B9E_73B0 = __TS__Class()
_____591A_6CE2_5EF6_8FDFAOE_5B9E_73B0.name = "多波延迟AOE实现"
function _____591A_6CE2_5EF6_8FDFAOE_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["运行波次列表"] = {}
    self["已停止"] = false
    _____4E0B_4E00_4E2A_591A_6CE2_5EF6_8FDFAOEID = _____4E0B_4E00_4E2A_591A_6CE2_5EF6_8FDFAOEID + 1
    self.ID = _____4E0B_4E00_4E2A_591A_6CE2_5EF6_8FDFAOEID
    self["参数"] = _____53C2_6570
    local now = getServerTime()
    do
        local i = 0
        while i < #_____53C2_6570["波次列表"] do
            local _____6CE2_6B21 = _____53C2_6570["波次列表"][i + 1]
            local ____self__8FD0_884C_6CE2_6B21_5217_8868_1 = self["运行波次列表"]
            ____self__8FD0_884C_6CE2_6B21_5217_8868_1[#____self__8FD0_884C_6CE2_6B21_5217_8868_1 + 1] = {["波次"] = _____6CE2_6B21, ["到期Ms"] = now + _____6CE2_6B21["延迟秒"] * 1000, ["已触发"] = false}
            self["创建提示圈"](self, _____6CE2_6B21)
            if _____53C2_6570["on预警"] ~= nil then
                _____53C2_6570["on预警"](_____6CE2_6B21, i + 1)
            end
            i = i + 1
        end
    end
    _____591A_6CE2_5EF6_8FDFAOE_8868[self.ID] = self
    _____786E_4FDD_591A_6CE2_5EF6_8FDFAOE_9A71_52A8(_____53C2_6570["Tick间隔毫秒"] or 50)
end
_____591A_6CE2_5EF6_8FDFAOE_5B9E_73B0.prototype["推进"] = function(self, now)
    if self["已停止"] then
        return
    end
    local _____5168_90E8_89E6_53D1 = true
    do
        local i = 0
        while i < #self["运行波次列表"] do
            do
                local _____8FD0_884C_6CE2_6B21 = self["运行波次列表"][i + 1]
                if _____8FD0_884C_6CE2_6B21["已触发"] then
                    goto __continue20
                end
                _____5168_90E8_89E6_53D1 = false
                if now >= _____8FD0_884C_6CE2_6B21["到期Ms"] then
                    _____8FD0_884C_6CE2_6B21["已触发"] = true
                    self["参数"]["on触发"](_____8FD0_884C_6CE2_6B21["波次"], i + 1)
                end
            end
            ::__continue20::
            i = i + 1
        end
    end
    if _____5168_90E8_89E6_53D1 then
        self["停止"](self)
    end
end
_____591A_6CE2_5EF6_8FDFAOE_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    __TS__Delete(_____591A_6CE2_5EF6_8FDFAOE_8868, self.ID)
    if self["参数"]["on结束"] ~= nil then
        self["参数"]["on结束"]()
    end
    _____5C1D_8BD5_505C_6B62_591A_6CE2_5EF6_8FDFAOE_9A71_52A8()
end
_____591A_6CE2_5EF6_8FDFAOE_5B9E_73B0.prototype["创建提示圈"] = function(self, _____6CE2_6B21)
    if _____6CE2_6B21["提示圈"] == false then
        return
    end
    _____521B_5EFA_6280_80FD_63D0_793A_5708(__TS__ObjectAssign({
        ["类型"] = "渐变圆形",
        X = _____6CE2_6B21.X,
        Y = _____6CE2_6B21.Y,
        ["半径"] = _____6CE2_6B21["半径"],
        ["持续时间"] = _____6CE2_6B21["延迟秒"]
    }, _____6CE2_6B21["提示圈"] or ({})))
end
____exports["创建多波延迟AOE"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____591A_6CE2_5EF6_8FDFAOE_5B9E_73B0, _____53C2_6570)
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
