local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382["创建技能提示圈"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____8DDD_79BB_5E73_65B9XY = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["距离平方XY"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomInt = jass.GetRandomInt
local ____require_result_0 = require("lib.扩展函数.KK扩展API.00．装饰物函数")
local DzDoodadCreate = ____require_result_0.DzDoodadCreate
local DzDoodadSetModel = ____require_result_0.DzDoodadSetModel
local DzDoodadSetVisible = ____require_result_0.DzDoodadSetVisible
local DzDoodadRemove = ____require_result_0.DzDoodadRemove
local function _____8F6C_88C5_9970_7269ID(id)
    return type(id) == "number" and id or stringToFourCC(id)
end
local _____52A8_6001_88C5_9970_7269_5B89_5168_533A_7EC4_5B9E_73B0 = __TS__Class()
_____52A8_6001_88C5_9970_7269_5B89_5168_533A_7EC4_5B9E_73B0.name = "动态装饰物安全区组实现"
function _____52A8_6001_88C5_9970_7269_5B89_5168_533A_7EC4_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["列表"] = {}
    self["已销毁"] = false
    self["名称"] = _____53C2_6570["名称"]
    self["参数"] = _____53C2_6570
    self["创建全部"](self)
    if _____53C2_6570["默认显示提示"] then
        self["显示提示"](self, _____53C2_6570["提示持续秒"])
    end
end
_____52A8_6001_88C5_9970_7269_5B89_5168_533A_7EC4_5B9E_73B0.prototype["取列表"] = function(self)
    local result = {}
    do
        local i = 0
        while i < #self["列表"] do
            result[#result + 1] = self["列表"][i + 1]
            i = i + 1
        end
    end
    return result
end
_____52A8_6001_88C5_9970_7269_5B89_5168_533A_7EC4_5B9E_73B0.prototype["点是否安全"] = function(self, x, y)
    do
        local i = 0
        while i < #self["列表"] do
            local _____533A = self["列表"][i + 1]
            if _____8DDD_79BB_5E73_65B9XY(x, y, _____533A.X, _____533A.Y) <= _____533A["半径"] * _____533A["半径"] then
                return true
            end
            i = i + 1
        end
    end
    return false
end
_____52A8_6001_88C5_9970_7269_5B89_5168_533A_7EC4_5B9E_73B0.prototype["单位是否安全"] = function(self, unit)
    if unit == nil or unit == 0 then
        return false
    end
    return self["点是否安全"](
        self,
        GetUnitX(unit),
        GetUnitY(unit)
    )
end
_____52A8_6001_88C5_9970_7269_5B89_5168_533A_7EC4_5B9E_73B0.prototype["显示提示"] = function(self, _____6301_7EED_79D2)
    local duration = _____6301_7EED_79D2 or self["参数"]["提示持续秒"] or 3
    do
        local i = 0
        while i < #self["列表"] do
            local _____533A = self["列表"][i + 1]
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "白色安全圆",
                X = _____533A.X,
                Y = _____533A.Y,
                ["半径"] = _____533A["半径"],
                ["持续时间"] = duration,
                ["来源单位"] = self["参数"]["来源单位"]
            })
            i = i + 1
        end
    end
end
_____52A8_6001_88C5_9970_7269_5B89_5168_533A_7EC4_5B9E_73B0.prototype["隐藏"] = function(self)
    do
        local i = 0
        while i < #self["列表"] do
            local _____533A = self["列表"][i + 1]
            if _____533A["装饰物"] ~= nil and _____533A["装饰物"] ~= 0 then
                DzDoodadSetVisible(_____533A["装饰物"], false)
            end
            i = i + 1
        end
    end
end
_____52A8_6001_88C5_9970_7269_5B89_5168_533A_7EC4_5B9E_73B0.prototype["销毁"] = function(self)
    if self["已销毁"] then
        return
    end
    self["已销毁"] = true
    do
        local i = 0
        while i < #self["列表"] do
            local _____533A = self["列表"][i + 1]
            if _____533A["装饰物"] ~= nil and _____533A["装饰物"] ~= 0 then
                DzDoodadRemove(_____533A["装饰物"])
            end
            i = i + 1
        end
    end
    self["列表"] = {}
end
_____52A8_6001_88C5_9970_7269_5B89_5168_533A_7EC4_5B9E_73B0.prototype["创建全部"] = function(self)
    local doodadId = _____8F6C_88C5_9970_7269ID(self["参数"]["装饰物ID"])
    local z = self["参数"].Z or 0
    local scale = self["参数"]["缩放"] or 1
    do
        local i = 0
        while i < #self["参数"]["点位列表"] do
            local _____70B9 = self["参数"]["点位列表"][i + 1]
            local varId = self["参数"]["变量ID"] or 0
            local minVarId = self["参数"]["随机样式最小ID"]
            local maxVarId = self["参数"]["随机样式最大ID"]
            if minVarId ~= nil and maxVarId ~= nil and maxVarId >= minVarId then
                varId = GetRandomInt(minVarId, maxVarId)
            end
            local doodad = DzDoodadCreate(
                doodadId,
                varId,
                _____70B9.X,
                _____70B9.Y,
                z,
                _____70B9["朝向"] or 0,
                scale
            )
            local model = _____70B9["模型路径"] or self["参数"]["默认模型路径"]
            if model ~= nil and model ~= "" then
                DzDoodadSetModel(doodad, model)
            end
            local ____self__5217_8868_1 = self["列表"]
            ____self__5217_8868_1[#____self__5217_8868_1 + 1] = {
                ID = _____70B9.ID or "安全区" .. tostring(i + 1),
                X = _____70B9.X,
                Y = _____70B9.Y,
                ["半径"] = _____70B9["半径"],
                ["装饰物"] = doodad
            }
            i = i + 1
        end
    end
end
____exports["创建动态装饰物安全区组"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____52A8_6001_88C5_9970_7269_5B89_5168_533A_7EC4_5B9E_73B0, _____53C2_6570)
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
