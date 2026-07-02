local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____on_9650_65F6_6467_6BC1_76EE_6807_7EC4Tick, getServerTime, _____9650_65F6_6467_6BC1_76EE_6807_7EC4_8868
local ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D["创建可攻击机制单位"]
function ____on_9650_65F6_6467_6BC1_76EE_6807_7EC4Tick()
    local now = getServerTime()
    for key in pairs(_____9650_65F6_6467_6BC1_76EE_6807_7EC4_8868) do
        local _____5B9E_4F8B = _____9650_65F6_6467_6BC1_76EE_6807_7EC4_8868[key]
        if _____5B9E_4F8B ~= nil then
            _____5B9E_4F8B["推进"](_____5B9E_4F8B, now)
        end
    end
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
_____9650_65F6_6467_6BC1_76EE_6807_7EC4_8868 = {}
local _____9650_65F6_6467_6BC1_76EE_6807_7EC4_9A71_52A8ID = 0
local _____4E0B_4E00_4E2A_9650_65F6_6467_6BC1_76EE_6807_7EC4ID = 0
local function _____786E_4FDD_9650_65F6_6467_6BC1_76EE_6807_7EC4_9A71_52A8(_____95F4_9694_6BEB_79D2)
    if _____9650_65F6_6467_6BC1_76EE_6807_7EC4_9A71_52A8ID ~= 0 then
        return
    end
    _____9650_65F6_6467_6BC1_76EE_6807_7EC4_9A71_52A8ID = addPeriodicCallback(_____95F4_9694_6BEB_79D2, ____on_9650_65F6_6467_6BC1_76EE_6807_7EC4Tick)
end
local function _____5C1D_8BD5_505C_6B62_9650_65F6_6467_6BC1_76EE_6807_7EC4_9A71_52A8()
    for key in pairs(_____9650_65F6_6467_6BC1_76EE_6807_7EC4_8868) do
        if _____9650_65F6_6467_6BC1_76EE_6807_7EC4_8868[key] ~= nil then
            return
        end
    end
    if _____9650_65F6_6467_6BC1_76EE_6807_7EC4_9A71_52A8ID ~= 0 then
        removePeriodicCallback(_____9650_65F6_6467_6BC1_76EE_6807_7EC4_9A71_52A8ID)
        _____9650_65F6_6467_6BC1_76EE_6807_7EC4_9A71_52A8ID = 0
    end
end
local _____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0 = __TS__Class()
_____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0.name = "限时摧毁目标组实现"
function _____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["目标单位列表"] = {}
    self["已结束"] = false
    _____4E0B_4E00_4E2A_9650_65F6_6467_6BC1_76EE_6807_7EC4ID = _____4E0B_4E00_4E2A_9650_65F6_6467_6BC1_76EE_6807_7EC4ID + 1
    self.ID = _____4E0B_4E00_4E2A_9650_65F6_6467_6BC1_76EE_6807_7EC4ID
    self["参数"] = _____53C2_6570
    self["到期Ms"] = getServerTime() + _____53C2_6570["持续秒"] * 1000
    _____9650_65F6_6467_6BC1_76EE_6807_7EC4_8868[self.ID] = self
    self["创建目标"](self)
    _____786E_4FDD_9650_65F6_6467_6BC1_76EE_6807_7EC4_9A71_52A8(_____53C2_6570["Tick间隔毫秒"] or 100)
end
_____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0.prototype["取剩余数量"] = function(self)
    local _____6570_91CF = 0
    do
        local i = 0
        while i < #self["目标单位列表"] do
            if self["目标单位列表"][i + 1]["是否存活"]() then
                _____6570_91CF = _____6570_91CF + 1
            end
            i = i + 1
        end
    end
    return _____6570_91CF
end
_____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0.prototype["推进"] = function(self, now)
    if self["已结束"] then
        return
    end
    local _____5269_4F59_6570_91CF = self["取剩余数量"](self)
    if _____5269_4F59_6570_91CF <= 0 then
        if self["参数"]["on全部摧毁"] ~= nil then
            self["参数"]["on全部摧毁"]()
        end
        self["结束"](self, true)
        return
    end
    if now >= self["到期Ms"] then
        if self["参数"]["on超时"] ~= nil then
            self["参数"]["on超时"](_____5269_4F59_6570_91CF)
        end
        self["结束"](self, false)
    end
end
_____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0.prototype["结束"] = function(self, _____662F_5426_6210_529F)
    if self["已结束"] then
        return
    end
    self["已结束"] = true
    __TS__Delete(_____9650_65F6_6467_6BC1_76EE_6807_7EC4_8868, self.ID)
    local _____5269_4F59_6570_91CF = self["取剩余数量"](self)
    if not _____662F_5426_6210_529F then
        do
            local i = 0
            while i < #self["目标单位列表"] do
                if self["目标单位列表"][i + 1]["是否存活"]() then
                    self["目标单位列表"][i + 1]["销毁"]()
                end
                i = i + 1
            end
        end
    end
    if self["参数"]["on结束"] ~= nil then
        self["参数"]["on结束"](_____662F_5426_6210_529F, _____5269_4F59_6570_91CF)
    end
    _____5C1D_8BD5_505C_6B62_9650_65F6_6467_6BC1_76EE_6807_7EC4_9A71_52A8()
end
_____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0.prototype["创建目标"] = function(self)
    do
        local i = 0
        while i < #self["参数"]["目标列表"] do
            local _____76EE_6807 = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D(self["参数"]["目标列表"][i + 1])
            if _____76EE_6807 ~= nil then
                local ____self__76EE_6807_5355_4F4D_5217_8868_1 = self["目标单位列表"]
                ____self__76EE_6807_5355_4F4D_5217_8868_1[#____self__76EE_6807_5355_4F4D_5217_8868_1 + 1] = _____76EE_6807
            end
            i = i + 1
        end
    end
end
____exports["创建限时摧毁目标组"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____9650_65F6_6467_6BC1_76EE_6807_7EC4_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_2 = _____53C2_6570["清理"]
        ____self_2["登记清理"](
            ____self_2,
            _____53C2_6570["名称"],
            function()
                _____5B9E_4F8B["结束"](_____5B9E_4F8B, false)
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
