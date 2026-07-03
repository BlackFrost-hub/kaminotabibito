local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local DestroyEffect = jass.DestroyEffect
local RemoveUnit = jass.RemoveUnit
local DestroyLightning = jass.DestroyLightning
local RemoveRect = jass.RemoveRect
local RemoveRegion = jass.RemoveRegion
local DestroyUbersplat = jass.DestroyUbersplat
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local _____673A_5236_6E05_7406_7BEE_5B50_5B9E_73B0 = __TS__Class()
_____673A_5236_6E05_7406_7BEE_5B50_5B9E_73B0.name = "机制清理篮子实现"
function _____673A_5236_6E05_7406_7BEE_5B50_5B9E_73B0.prototype.____constructor(self, _____540D_79F0)
    self["清理项列表"] = {}
    self["已经清理"] = false
    self["名称"] = _____540D_79F0
end
_____673A_5236_6E05_7406_7BEE_5B50_5B9E_73B0.prototype["已清理"] = function(self)
    return self["已经清理"]
end
_____673A_5236_6E05_7406_7BEE_5B50_5B9E_73B0.prototype["登记清理"] = function(self, _____540D_79F0, _____6E05_7406, _____53D8_91CF)
    if self["已经清理"] or _____6E05_7406 == nil then
        return
    end
    local ____self__6E05_7406_9879_5217_8868_1 = self["清理项列表"]
    ____self__6E05_7406_9879_5217_8868_1[#____self__6E05_7406_9879_5217_8868_1 + 1] = {["名称"] = _____540D_79F0, ["清理"] = _____6E05_7406, ["变量"] = _____53D8_91CF}
end
_____673A_5236_6E05_7406_7BEE_5B50_5B9E_73B0.prototype["登记周期回调"] = function(self, _____540D_79F0, _____56DE_8C03ID)
    if _____56DE_8C03ID == nil or _____56DE_8C03ID == 0 then
        return
    end
    self["登记清理"](
        self,
        _____540D_79F0,
        function()
            removePeriodicCallback(_____56DE_8C03ID)
        end
    )
end
_____673A_5236_6E05_7406_7BEE_5B50_5B9E_73B0.prototype["登记延迟回调"] = function(self, _____540D_79F0, _____56DE_8C03ID)
    if _____56DE_8C03ID == nil or _____56DE_8C03ID == 0 then
        return
    end
    self["登记清理"](
        self,
        _____540D_79F0,
        function()
            removeDelayedCallback(_____56DE_8C03ID)
        end
    )
end
_____673A_5236_6E05_7406_7BEE_5B50_5B9E_73B0.prototype["登记特效"] = function(self, _____540D_79F0, _____7279_6548)
    if _____7279_6548 == nil or _____7279_6548 == 0 then
        return
    end
    self["登记清理"](
        self,
        _____540D_79F0,
        function()
            DestroyEffect(_____7279_6548)
        end
    )
end
_____673A_5236_6E05_7406_7BEE_5B50_5B9E_73B0.prototype["登记单位"] = function(self, _____540D_79F0, _____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    self["登记清理"](
        self,
        _____540D_79F0,
        function()
            RemoveUnit(_____5355_4F4D)
        end
    )
end
_____673A_5236_6E05_7406_7BEE_5B50_5B9E_73B0.prototype["登记闪电"] = function(self, _____540D_79F0, _____95EA_7535)
    if _____95EA_7535 == nil or _____95EA_7535 == 0 then
        return
    end
    self["登记清理"](
        self,
        _____540D_79F0,
        function()
            DestroyLightning(_____95EA_7535)
        end
    )
end
_____673A_5236_6E05_7406_7BEE_5B50_5B9E_73B0.prototype["登记矩形"] = function(self, _____540D_79F0, _____77E9_5F62)
    if _____77E9_5F62 == nil or _____77E9_5F62 == 0 then
        return
    end
    self["登记清理"](
        self,
        _____540D_79F0,
        function()
            RemoveRect(_____77E9_5F62)
        end
    )
end
_____673A_5236_6E05_7406_7BEE_5B50_5B9E_73B0.prototype["登记区域"] = function(self, _____540D_79F0, _____533A_57DF)
    if _____533A_57DF == nil or _____533A_57DF == 0 then
        return
    end
    self["登记清理"](
        self,
        _____540D_79F0,
        function()
            RemoveRegion(_____533A_57DF)
        end
    )
end
_____673A_5236_6E05_7406_7BEE_5B50_5B9E_73B0.prototype["登记贴图"] = function(self, _____540D_79F0, _____8D34_56FE)
    if _____8D34_56FE == nil or _____8D34_56FE == 0 then
        return
    end
    self["登记清理"](
        self,
        _____540D_79F0,
        function()
            DestroyUbersplat(_____8D34_56FE)
        end
    )
end
_____673A_5236_6E05_7406_7BEE_5B50_5B9E_73B0.prototype["清理全部"] = function(self)
    if self["已经清理"] then
        return
    end
    self["已经清理"] = true
    do
        local i = #self["清理项列表"] - 1
        while i >= 0 do
            local _____9879 = self["清理项列表"][i + 1]
            if _____9879 ~= nil and _____9879["清理"] ~= nil then
                _____9879["清理"](_____9879["变量"])
            end
            i = i - 1
        end
    end
    self["清理项列表"] = {}
end
____exports["创建机制清理篮子"] = function(_____540D_79F0)
    return __TS__New(_____673A_5236_6E05_7406_7BEE_5B50_5B9E_73B0, _____540D_79F0)
end
return ____exports
