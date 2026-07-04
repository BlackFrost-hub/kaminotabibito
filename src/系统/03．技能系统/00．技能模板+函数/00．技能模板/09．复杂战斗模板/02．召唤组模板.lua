local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____00_FF0E_673A_5236_5355_4F4D_751F_547D_5468_671F_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.00．机制单位生命周期模板")
local _____521B_5EFA_673A_5236_5355_4F4D_751F_547D_5468_671F = ____00_FF0E_673A_5236_5355_4F4D_751F_547D_5468_671F_6A21_677F["创建机制单位生命周期"]
local ____03_FF0E_53EC_5524_7269_7EC4_72B6_6001_7BA1_7406 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.03．召唤物组状态管理")
local _____521B_5EFA_53EC_5524_7269_7EC4_72B6_6001 = ____03_FF0E_53EC_5524_7269_7EC4_72B6_6001_7BA1_7406["创建召唤物组状态"]
local jass = require("jass.common")
local IssueTargetOrder = jass.IssueTargetOrder
local IssuePointOrder = jass.IssuePointOrder
local _____53EC_5524_7EC4_5B9E_73B0 = __TS__Class()
_____53EC_5524_7EC4_5B9E_73B0.name = "召唤组实现"
function _____53EC_5524_7EC4_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["实例列表"] = {}
    self["已创建"] = false
    self["参数"] = _____53C2_6570
    self["组状态"] = _____521B_5EFA_53EC_5524_7269_7EC4_72B6_6001({["清理"] = _____53C2_6570["清理"], ["名称"] = _____53C2_6570["名称"], ["全灭延迟秒"] = _____53C2_6570["全灭延迟秒"], ["on全部死亡"] = _____53C2_6570["on全部死亡"]})
end
_____53EC_5524_7EC4_5B9E_73B0.prototype["取实例列表"] = function(self)
    local result = {}
    do
        local i = 0
        while i < #self["实例列表"] do
            result[#result + 1] = self["实例列表"][i + 1]
            i = i + 1
        end
    end
    return result
end
_____53EC_5524_7EC4_5B9E_73B0.prototype["创建全部"] = function(self)
    if self["已创建"] then
        return
    end
    self["已创建"] = true
    do
        local i = 0
        while i < #self["参数"]["单位列表"] do
            self["创建单个"](self, i, self["参数"]["单位列表"][i + 1])
            i = i + 1
        end
    end
end
_____53EC_5524_7EC4_5B9E_73B0.prototype["销毁"] = function(self)
    do
        local i = 0
        while i < #self["实例列表"] do
            local _____5B9E_4F8B = self["实例列表"][i + 1]
            if _____5B9E_4F8B ~= nil then
                _____5B9E_4F8B["销毁"](_____5B9E_4F8B, "手动销毁")
            end
            i = i + 1
        end
    end
    self["实例列表"] = {}
    local ____self_0 = self["组状态"]
    ____self_0["销毁"](____self_0)
end
_____53EC_5524_7EC4_5B9E_73B0.prototype["创建单个"] = function(self, index, _____5355_4F4D_53C2_6570)
    local ____self = self
    local _____5B9E_4F8B = _____521B_5EFA_673A_5236_5355_4F4D_751F_547D_5468_671F(__TS__ObjectAssign(
        {},
        _____5355_4F4D_53C2_6570,
        {
            ["清理"] = _____5355_4F4D_53C2_6570["清理"] or self["参数"]["清理"],
            ["on创建"] = function(created)
                local ____self_1 = ____self["组状态"]
                ____self_1["登记"](____self_1, created["单位"])
                ____self["下达命令"](____self, created, _____5355_4F4D_53C2_6570)
                if _____5355_4F4D_53C2_6570["on创建"] ~= nil then
                    _____5355_4F4D_53C2_6570["on创建"](created)
                end
                if ____self["参数"]["on单位创建"] ~= nil then
                    ____self["参数"]["on单位创建"](created, index)
                end
            end,
            ["on结束"] = function(ended, _____539F_56E0)
                if _____5355_4F4D_53C2_6570["on结束"] ~= nil then
                    _____5355_4F4D_53C2_6570["on结束"](ended, _____539F_56E0)
                end
                if ____self["参数"]["on单位结束"] ~= nil then
                    ____self["参数"]["on单位结束"](ended, _____539F_56E0, index)
                end
            end
        }
    ))
    if _____5B9E_4F8B ~= nil then
        local ____self__5B9E_4F8B_5217_8868_2 = self["实例列表"]
        ____self__5B9E_4F8B_5217_8868_2[#____self__5B9E_4F8B_5217_8868_2 + 1] = _____5B9E_4F8B
    end
end
_____53EC_5524_7EC4_5B9E_73B0.prototype["下达命令"] = function(self, _____5B9E_4F8B, _____5355_4F4D_53C2_6570)
    local order = _____5355_4F4D_53C2_6570["命令"] or "attack"
    if _____5355_4F4D_53C2_6570["攻击目标"] ~= nil and _____5355_4F4D_53C2_6570["攻击目标"] ~= 0 then
        IssueTargetOrder(_____5B9E_4F8B["单位"], order, _____5355_4F4D_53C2_6570["攻击目标"])
        return
    end
    if _____5355_4F4D_53C2_6570["命令X"] ~= nil and _____5355_4F4D_53C2_6570["命令Y"] ~= nil then
        IssuePointOrder(_____5B9E_4F8B["单位"], order, _____5355_4F4D_53C2_6570["命令X"], _____5355_4F4D_53C2_6570["命令Y"])
    end
end
____exports["创建召唤组"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____53EC_5524_7EC4_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_3 = _____53C2_6570["清理"]
        ____self_3["登记清理"](
            ____self_3,
            _____53C2_6570["名称"],
            function()
                _____5B9E_4F8B["销毁"](_____5B9E_4F8B)
            end
        )
    end
    _____5B9E_4F8B["创建全部"](_____5B9E_4F8B)
    return _____5B9E_4F8B
end
return ____exports
