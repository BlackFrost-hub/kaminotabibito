local ____lualib = require("lualib_bundle")
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local __TS__New = ____lualib.__TS__New
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____17_FF0E_95EA_7535_6548_679C_4EE3_7801 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.17．闪电效果代码")
local _____9ED8_8BA4_95EA_7535_6548_679C_4EE3_7801 = ____17_FF0E_95EA_7535_6548_679C_4EE3_7801["默认闪电效果代码"]
local _____95EA_7535_6548_679C_4EE3_7801 = ____17_FF0E_95EA_7535_6548_679C_4EE3_7801["闪电效果代码"]
local jass = require("jass.common")
local Rect = jass.Rect
local RemoveRect = jass.RemoveRect
local AddLightningEx = jass.AddLightningEx
local DestroyLightning = jass.DestroyLightning
local SetLightningColor = jass.SetLightningColor
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____9ED8_8BA4_95EA_7535_5BAB_683C_540D_79F0 = "闪电宫格区域"
local _____9ED8_8BA4_95EA_7535_9AD8_5EA6 = 60
local function _____89C4_6574_6570_91CF(_____503C, _____9ED8_8BA4_503C)
    if _____503C == nil or _____503C < 1 then
        return _____9ED8_8BA4_503C
    end
    return math.floor(_____503C)
end
local function _____89E3_6790_5BAB_683C_5C3A_5BF8(_____53C2_6570, _____884C_6570, _____5217_6570)
    local _____539F_59CB_5355_683C_5BBD_5EA6 = _____53C2_6570["单格宽度"] or _____53C2_6570["单格边长"]
    local _____539F_59CB_5355_683C_9AD8_5EA6 = _____53C2_6570["单格高度"] or _____53C2_6570["单格边长"]
    local _____539F_59CB_5BBD_5EA6 = _____53C2_6570["宽度"] or (_____539F_59CB_5355_683C_5BBD_5EA6 ~= nil and _____539F_59CB_5355_683C_5BBD_5EA6 * _____5217_6570 or nil)
    local _____539F_59CB_9AD8_5EA6 = _____53C2_6570["高度"] or (_____539F_59CB_5355_683C_9AD8_5EA6 ~= nil and _____539F_59CB_5355_683C_9AD8_5EA6 * _____884C_6570 or nil)
    if _____539F_59CB_5BBD_5EA6 == nil or _____539F_59CB_5BBD_5EA6 <= 0 or _____539F_59CB_9AD8_5EA6 == nil or _____539F_59CB_9AD8_5EA6 <= 0 then
        error(
            __TS__New(Error, "创建闪电宫格区域需要提供有效的 宽度/高度，或 单格宽度/单格高度/单格边长。"),
            0
        )
    end
    return {["宽度"] = _____539F_59CB_5BBD_5EA6, ["高度"] = _____539F_59CB_9AD8_5EA6, ["单格宽度"] = _____539F_59CB_5BBD_5EA6 / _____5217_6570, ["单格高度"] = _____539F_59CB_9AD8_5EA6 / _____884C_6570}
end
local function _____89E3_6790_95EA_7535_6548_679C(_____6548_679C)
    if _____6548_679C == nil or _____6548_679C == "" then
        return _____9ED8_8BA4_95EA_7535_6548_679C_4EE3_7801
    end
    local _____8868 = _____95EA_7535_6548_679C_4EE3_7801
    local _____53EF_80FD_4EE3_7801 = _____8868[_____6548_679C]
    return _____53EF_80FD_4EE3_7801 or _____6548_679C
end
local function _____70B9_5728_683C_5B50_5185(x, y, _____683C_5B50)
    return x >= _____683C_5B50["左"] and x <= _____683C_5B50["右"] and y >= _____683C_5B50["下"] and y <= _____683C_5B50["上"]
end
local function _____521B_5EFA_95EA_7535_7EBF(_____53C2_6570, x1, y1, x2, y2)
    local _____9AD8_5EA6 = _____53C2_6570["闪电高度"] or _____9ED8_8BA4_95EA_7535_9AD8_5EA6
    local _____95EA_7535 = AddLightningEx(
        _____89E3_6790_95EA_7535_6548_679C(_____53C2_6570["闪电效果"]),
        false,
        x1,
        y1,
        _____9AD8_5EA6,
        x2,
        y2,
        _____9AD8_5EA6
    )
    if _____95EA_7535 ~= nil and _____95EA_7535 ~= 0 and _____53C2_6570["闪电颜色"] ~= nil then
        SetLightningColor(
            _____95EA_7535,
            _____53C2_6570["闪电颜色"].r,
            _____53C2_6570["闪电颜色"].g,
            _____53C2_6570["闪电颜色"].b,
            _____53C2_6570["闪电颜色"].a
        )
    end
    return _____95EA_7535
end
local _____95EA_7535_5BAB_683C_63A7_5236_5668_5B9E_73B0 = __TS__Class()
_____95EA_7535_5BAB_683C_63A7_5236_5668_5B9E_73B0.name = "闪电宫格控制器实现"
function _____95EA_7535_5BAB_683C_63A7_5236_5668_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____884C_6570, _____5217_6570, _____5BBD_5EA6, _____9AD8_5EA6, _____5355_683C_5BBD_5EA6, _____5355_683C_9AD8_5EA6, _____683C_5B50_5217_8868, _____6A2A_7EBF_5217_8868, _____7AD6_7EBF_5217_8868)
    self["已销毁"] = false
    self["名称"] = _____540D_79F0
    self["行数"] = _____884C_6570
    self["列数"] = _____5217_6570
    self["宽度"] = _____5BBD_5EA6
    self["高度"] = _____9AD8_5EA6
    self["单格宽度"] = _____5355_683C_5BBD_5EA6
    self["单格高度"] = _____5355_683C_9AD8_5EA6
    self["格子列表"] = _____683C_5B50_5217_8868
    self["横线列表"] = _____6A2A_7EBF_5217_8868
    self["竖线列表"] = _____7AD6_7EBF_5217_8868
end
_____95EA_7535_5BAB_683C_63A7_5236_5668_5B9E_73B0.prototype["获取格子"] = function(self, _____884C, _____5217)
    if _____884C < 0 or _____884C >= self["行数"] or _____5217 < 0 or _____5217 >= self["列数"] then
        return nil
    end
    return self["格子列表"][_____884C * self["列数"] + _____5217 + 1]
end
_____95EA_7535_5BAB_683C_63A7_5236_5668_5B9E_73B0.prototype["获取格子By索引"] = function(self, _____7D22_5F15)
    if _____7D22_5F15 < 0 or _____7D22_5F15 >= #self["格子列表"] then
        return nil
    end
    return self["格子列表"][_____7D22_5F15 + 1]
end
_____95EA_7535_5BAB_683C_63A7_5236_5668_5B9E_73B0.prototype["坐标所在格子"] = function(self, x, y)
    do
        local i = 0
        while i < #self["格子列表"] do
            local _____683C_5B50 = self["格子列表"][i + 1]
            if _____70B9_5728_683C_5B50_5185(x, y, _____683C_5B50) then
                return _____683C_5B50
            end
            i = i + 1
        end
    end
    return nil
end
_____95EA_7535_5BAB_683C_63A7_5236_5668_5B9E_73B0.prototype["单位所在格子"] = function(self, _____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    return self["坐标所在格子"](
        self,
        GetUnitX(_____5355_4F4D),
        GetUnitY(_____5355_4F4D)
    )
end
_____95EA_7535_5BAB_683C_63A7_5236_5668_5B9E_73B0.prototype["设置格子状态"] = function(self, _____884C, _____5217, _____72B6_6001)
    local _____683C_5B50 = self["获取格子"](self, _____884C, _____5217)
    if _____683C_5B50 ~= nil then
        _____683C_5B50["状态"] = _____72B6_6001
    end
end
_____95EA_7535_5BAB_683C_63A7_5236_5668_5B9E_73B0.prototype["清空格子状态"] = function(self)
    do
        local i = 0
        while i < #self["格子列表"] do
            self["格子列表"][i + 1]["状态"] = nil
            i = i + 1
        end
    end
end
_____95EA_7535_5BAB_683C_63A7_5236_5668_5B9E_73B0.prototype["销毁"] = function(self)
    if self["已销毁"] then
        return
    end
    self["已销毁"] = true
    do
        local i = 0
        while i < #self["横线列表"] do
            local _____95EA_7535 = self["横线列表"][i + 1]
            if _____95EA_7535 ~= nil and _____95EA_7535 ~= 0 then
                DestroyLightning(_____95EA_7535)
            end
            self["横线列表"][i + 1] = nil
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #self["竖线列表"] do
            local _____95EA_7535 = self["竖线列表"][i + 1]
            if _____95EA_7535 ~= nil and _____95EA_7535 ~= 0 then
                DestroyLightning(_____95EA_7535)
            end
            self["竖线列表"][i + 1] = nil
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #self["格子列表"] do
            local _____683C_5B50 = self["格子列表"][i + 1]
            if _____683C_5B50["矩形"] ~= nil and _____683C_5B50["矩形"] ~= 0 then
                RemoveRect(_____683C_5B50["矩形"])
            end
            _____683C_5B50["矩形"] = nil
            _____683C_5B50["状态"] = nil
            i = i + 1
        end
    end
end
____exports["创建闪电宫格区域"] = function(_____53C2_6570)
    local _____540D_79F0 = _____53C2_6570["名称"] or _____9ED8_8BA4_95EA_7535_5BAB_683C_540D_79F0
    local _____884C_6570 = _____89C4_6574_6570_91CF(_____53C2_6570["行数"], 3)
    local _____5217_6570 = _____89C4_6574_6570_91CF(_____53C2_6570["列数"], 3)
    local _____5C3A_5BF8 = _____89E3_6790_5BAB_683C_5C3A_5BF8(_____53C2_6570, _____884C_6570, _____5217_6570)
    local _____5DE6 = _____53C2_6570["中心X"] - _____5C3A_5BF8["宽度"] / 2
    local _____53F3 = _____53C2_6570["中心X"] + _____5C3A_5BF8["宽度"] / 2
    local _____4E0B = _____53C2_6570["中心Y"] - _____5C3A_5BF8["高度"] / 2
    local _____4E0A = _____53C2_6570["中心Y"] + _____5C3A_5BF8["高度"] / 2
    local _____5355_683C_5BBD_5EA6 = _____5C3A_5BF8["单格宽度"]
    local _____5355_683C_9AD8_5EA6 = _____5C3A_5BF8["单格高度"]
    local ____x_7EBF = {}
    local ____y_7EBF = {}
    local _____683C_5B50_5217_8868 = {}
    local _____6A2A_7EBF_5217_8868 = {}
    local _____7AD6_7EBF_5217_8868 = {}
    do
        local i = 0
        while i <= _____5217_6570 do
            ____x_7EBF[#____x_7EBF + 1] = _____5DE6 + _____5355_683C_5BBD_5EA6 * i
            i = i + 1
        end
    end
    do
        local i = 0
        while i <= _____884C_6570 do
            ____y_7EBF[#____y_7EBF + 1] = _____4E0B + _____5355_683C_9AD8_5EA6 * i
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #____y_7EBF do
            _____6A2A_7EBF_5217_8868[#_____6A2A_7EBF_5217_8868 + 1] = _____521B_5EFA_95EA_7535_7EBF(
                _____53C2_6570,
                _____5DE6,
                ____y_7EBF[i + 1],
                _____53F3,
                ____y_7EBF[i + 1]
            )
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #____x_7EBF do
            _____7AD6_7EBF_5217_8868[#_____7AD6_7EBF_5217_8868 + 1] = _____521B_5EFA_95EA_7535_7EBF(
                _____53C2_6570,
                ____x_7EBF[i + 1],
                _____4E0B,
                ____x_7EBF[i + 1],
                _____4E0A
            )
            i = i + 1
        end
    end
    do
        local _____884C = 0
        while _____884C < _____884C_6570 do
            do
                local _____5217 = 0
                while _____5217 < _____5217_6570 do
                    local _____683C_5B50_5DE6 = ____x_7EBF[_____5217 + 1]
                    local _____683C_5B50_53F3 = ____x_7EBF[_____5217 + 1 + 1]
                    local _____683C_5B50_4E0B = ____y_7EBF[_____884C + 1]
                    local _____683C_5B50_4E0A = ____y_7EBF[_____884C + 1 + 1]
                    local _____7D22_5F15 = _____884C * _____5217_6570 + _____5217
                    _____683C_5B50_5217_8868[#_____683C_5B50_5217_8868 + 1] = {
                        ["行"] = _____884C,
                        ["列"] = _____5217,
                        ["索引"] = _____7D22_5F15,
                        ["名称"] = (((_____540D_79F0 .. "-") .. tostring(_____884C + 1)) .. "-") .. tostring(_____5217 + 1),
                        ["左"] = _____683C_5B50_5DE6,
                        ["右"] = _____683C_5B50_53F3,
                        ["下"] = _____683C_5B50_4E0B,
                        ["上"] = _____683C_5B50_4E0A,
                        ["中心X"] = (_____683C_5B50_5DE6 + _____683C_5B50_53F3) / 2,
                        ["中心Y"] = (_____683C_5B50_4E0B + _____683C_5B50_4E0A) / 2,
                        ["矩形"] = Rect(_____683C_5B50_5DE6, _____683C_5B50_4E0B, _____683C_5B50_53F3, _____683C_5B50_4E0A)
                    }
                    _____5217 = _____5217 + 1
                end
            end
            _____884C = _____884C + 1
        end
    end
    local _____63A7_5236_5668 = __TS__New(
        _____95EA_7535_5BAB_683C_63A7_5236_5668_5B9E_73B0,
        _____540D_79F0,
        _____884C_6570,
        _____5217_6570,
        _____5C3A_5BF8["宽度"],
        _____5C3A_5BF8["高度"],
        _____5355_683C_5BBD_5EA6,
        _____5355_683C_9AD8_5EA6,
        _____683C_5B50_5217_8868,
        _____6A2A_7EBF_5217_8868,
        _____7AD6_7EBF_5217_8868
    )
    if _____53C2_6570["清理篮子"] ~= nil then
        local ____self_0 = _____53C2_6570["清理篮子"]
        ____self_0["登记清理"](
            ____self_0,
            _____540D_79F0 .. "-销毁",
            function()
                _____63A7_5236_5668["销毁"](_____63A7_5236_5668)
            end
        )
    end
    return _____63A7_5236_5668
end
____exports["创建闪电九宫格区域"] = ____exports["创建闪电宫格区域"]
return ____exports
