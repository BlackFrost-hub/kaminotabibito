local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382["创建技能提示圈"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local function _____8DDD_79BB_5E73_65B9(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return dx * dx + dy * dy
end
local _____5706_5F62_5B89_5168_533A_7EC4_5B9E_73B0 = __TS__Class()
_____5706_5F62_5B89_5168_533A_7EC4_5B9E_73B0.name = "圆形安全区组实现"
function _____5706_5F62_5B89_5168_533A_7EC4_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["已销毁"] = false
    self["名称"] = _____53C2_6570["名称"]
    self["参数"] = _____53C2_6570
    if _____53C2_6570["默认显示提示"] then
        self["显示提示"](self, _____53C2_6570["提示持续秒"])
    end
end
_____5706_5F62_5B89_5168_533A_7EC4_5B9E_73B0.prototype["取列表"] = function(self)
    return self["参数"]["安全区列表"]
end
_____5706_5F62_5B89_5168_533A_7EC4_5B9E_73B0.prototype["取安全区"] = function(self, ID)
    local _____5217_8868 = self["参数"]["安全区列表"]
    do
        local i = 0
        while i < #_____5217_8868 do
            if _____5217_8868[i + 1].ID == ID then
                return _____5217_8868[i + 1]
            end
            i = i + 1
        end
    end
    return nil
end
_____5706_5F62_5B89_5168_533A_7EC4_5B9E_73B0.prototype["点是否安全"] = function(self, x, y)
    local _____5217_8868 = self["参数"]["安全区列表"]
    do
        local i = 0
        while i < #_____5217_8868 do
            local _____533A = _____5217_8868[i + 1]
            if _____8DDD_79BB_5E73_65B9(x, y, _____533A.X, _____533A.Y) <= _____533A["半径"] * _____533A["半径"] then
                return true
            end
            i = i + 1
        end
    end
    return false
end
_____5706_5F62_5B89_5168_533A_7EC4_5B9E_73B0.prototype["单位是否安全"] = function(self, _____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    return self["点是否安全"](
        self,
        GetUnitX(_____5355_4F4D),
        GetUnitY(_____5355_4F4D)
    )
end
_____5706_5F62_5B89_5168_533A_7EC4_5B9E_73B0.prototype["显示提示"] = function(self, _____6301_7EED_79D2)
    local _____5217_8868 = self["参数"]["安全区列表"]
    do
        local i = 0
        while i < #_____5217_8868 do
            local _____533A = _____5217_8868[i + 1]
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "白色安全圆",
                X = _____533A.X,
                Y = _____533A.Y,
                ["半径"] = _____533A["半径"],
                ["持续时间"] = _____6301_7EED_79D2 or self["参数"]["提示持续秒"] or 3
            })
            i = i + 1
        end
    end
end
_____5706_5F62_5B89_5168_533A_7EC4_5B9E_73B0.prototype["销毁"] = function(self)
    self["已销毁"] = true
end
____exports["创建圆形安全区组"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____5706_5F62_5B89_5168_533A_7EC4_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_0 = _____53C2_6570["清理"]
        ____self_0["登记清理"](
            ____self_0,
            _____53C2_6570["名称"],
            function()
                _____5B9E_4F8B["销毁"](_____5B9E_4F8B)
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
