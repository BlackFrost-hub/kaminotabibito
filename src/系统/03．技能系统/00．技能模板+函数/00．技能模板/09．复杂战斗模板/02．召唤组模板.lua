local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____00_FF0E_673A_5236_5355_4F4D_751F_547D_5468_671F_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.00．机制单位生命周期模板")
local _____521B_5EFA_673A_5236_5355_4F4D_751F_547D_5468_671F = ____00_FF0E_673A_5236_5355_4F4D_751F_547D_5468_671F_6A21_677F["创建机制单位生命周期"]
local ____03_FF0E_53EC_5524_7269_7EC4_72B6_6001_7BA1_7406 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.03．召唤物组状态管理")
local _____521B_5EFA_53EC_5524_7269_7EC4_72B6_6001 = ____03_FF0E_53EC_5524_7269_7EC4_72B6_6001_7BA1_7406["创建召唤物组状态"]
local jass = require("jass.common")
local IssueTargetOrder = jass.IssueTargetOrder
local IssuePointOrder = jass.IssuePointOrder
local GetHandleId = jass.GetHandleId
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
--- 主人死亡清理登记（主人 handleId → 清理函数数组）；策略="清理" 时登记
local _____4E3B_4EBA_6B7B_4EA1_6E05_7406_8868 = {}
local _____4E3B_4EBA_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____53EC_5524_7EC4_4E3B_4EBA_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    local id = GetHandleId(dyingUnit)
    local _____5217_8868 = _____4E3B_4EBA_6B7B_4EA1_6E05_7406_8868[id]
    if _____5217_8868 == nil then
        return
    end
    __TS__Delete(_____4E3B_4EBA_6B7B_4EA1_6E05_7406_8868, id)
    do
        local i = 0
        while i < #_____5217_8868 do
            if _____5217_8868[i + 1] ~= nil then
                _____5217_8868[i + 1]()
            end
            i = i + 1
        end
    end
end
local function _____786E_4FDD_4E3B_4EBA_6B7B_4EA1_76D1_542C()
    if _____4E3B_4EBA_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____4E3B_4EBA_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
    registerDeathListener(_____53EC_5524_7EC4_4E3B_4EBA_6B7B_4EA1_6E05_7406)
end
local _____53EC_5524_7EC4_5B9E_73B0 = __TS__Class()
_____53EC_5524_7EC4_5B9E_73B0.name = "召唤组实现"
function _____53EC_5524_7EC4_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["实例列表"] = {}
    self["已创建"] = false
    self["主人清理已登记"] = false
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
    local _____6570_91CF = #self["参数"]["单位列表"]
    do
        local i = 0
        while i < _____6570_91CF do
            local _____5355_4F4D_53C2_6570 = __TS__ObjectAssign({}, self["参数"]["单位列表"][i + 1])
            if self["参数"]["按索引位置"] ~= nil then
                local _____4F4D_7F6E = self["参数"]["按索引位置"](i, _____6570_91CF)
                if (_____5355_4F4D_53C2_6570.X == nil or _____5355_4F4D_53C2_6570.X == 0) and (_____5355_4F4D_53C2_6570.Y == nil or _____5355_4F4D_53C2_6570.Y == 0) then
                    _____5355_4F4D_53C2_6570.X = _____4F4D_7F6E.X
                    _____5355_4F4D_53C2_6570.Y = _____4F4D_7F6E.Y
                end
            end
            self["创建单个"](self, i, _____5355_4F4D_53C2_6570)
            i = i + 1
        end
    end
    self["登记主人死亡清理"](self)
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
    local ____self_1 = self["组状态"]
    ____self_1["销毁"](____self_1)
    self["注销主人死亡清理"](self)
end
_____53EC_5524_7EC4_5B9E_73B0.prototype["登记主人死亡清理"] = function(self)
    if self["主人清理已登记"] then
        return
    end
    local _____4E3B_4EBA = self["参数"]["主人"]
    if _____4E3B_4EBA == nil or _____4E3B_4EBA == 0 then
        return
    end
    if self["参数"]["主人死亡策略"] ~= "清理" then
        return
    end
    local id = GetHandleId(_____4E3B_4EBA)
    local ____self = self
    local function _____6E05_7406_51FD_6570()
        ____self["销毁"](____self)
    end
    local _____5217_8868 = _____4E3B_4EBA_6B7B_4EA1_6E05_7406_8868[id]
    if _____5217_8868 == nil then
        _____5217_8868 = {}
        _____4E3B_4EBA_6B7B_4EA1_6E05_7406_8868[id] = _____5217_8868
    end
    _____5217_8868[#_____5217_8868 + 1] = _____6E05_7406_51FD_6570
    self["主人清理函数"] = _____6E05_7406_51FD_6570
    self["主人清理已登记"] = true
    _____786E_4FDD_4E3B_4EBA_6B7B_4EA1_76D1_542C()
end
_____53EC_5524_7EC4_5B9E_73B0.prototype["注销主人死亡清理"] = function(self)
    if not self["主人清理已登记"] then
        return
    end
    self["主人清理已登记"] = false
    local _____4E3B_4EBA = self["参数"]["主人"]
    if _____4E3B_4EBA == nil or _____4E3B_4EBA == 0 then
        return
    end
    local id = GetHandleId(_____4E3B_4EBA)
    local _____5217_8868 = _____4E3B_4EBA_6B7B_4EA1_6E05_7406_8868[id]
    if _____5217_8868 ~= nil then
        local _____6E05_7406_51FD_6570 = self["主人清理函数"]
        if _____6E05_7406_51FD_6570 ~= nil then
            local index = __TS__ArrayIndexOf(_____5217_8868, _____6E05_7406_51FD_6570)
            if index >= 0 then
                __TS__ArraySplice(_____5217_8868, index, 1)
            end
        end
        if #_____5217_8868 <= 0 then
            __TS__Delete(_____4E3B_4EBA_6B7B_4EA1_6E05_7406_8868, id)
        end
    end
    self["主人清理函数"] = nil
end
_____53EC_5524_7EC4_5B9E_73B0.prototype["创建单个"] = function(self, index, _____5355_4F4D_53C2_6570)
    local ____self = self
    local _____5B9E_4F8B = _____521B_5EFA_673A_5236_5355_4F4D_751F_547D_5468_671F(__TS__ObjectAssign(
        {},
        _____5355_4F4D_53C2_6570,
        {
            ["清理"] = _____5355_4F4D_53C2_6570["清理"] or self["参数"]["清理"],
            ["on创建"] = function(created)
                local ____self_2 = ____self["组状态"]
                ____self_2["登记"](____self_2, created["单位"])
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
        local ____self__5B9E_4F8B_5217_8868_3 = self["实例列表"]
        ____self__5B9E_4F8B_5217_8868_3[#____self__5B9E_4F8B_5217_8868_3 + 1] = _____5B9E_4F8B
    end
end
_____53EC_5524_7EC4_5B9E_73B0.prototype["下达命令"] = function(self, _____5B9E_4F8B, _____5355_4F4D_53C2_6570)
    local order = _____5355_4F4D_53C2_6570["命令"] == nil and "attack" or _____5355_4F4D_53C2_6570["命令"]
    if order == "" then
        return
    end
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
        local ____self_4 = _____53C2_6570["清理"]
        ____self_4["登记清理"](
            ____self_4,
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
