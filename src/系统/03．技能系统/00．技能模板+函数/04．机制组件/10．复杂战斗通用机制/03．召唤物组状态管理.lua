local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____on_53EC_5524_7269_6B7B_4EA1, GetHandleId, _____53EC_5524_7269_7EC4_8868
function ____on_53EC_5524_7269_6B7B_4EA1(dyingUnit, killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    local id = GetHandleId(dyingUnit)
    for key in pairs(_____53EC_5524_7269_7EC4_8868) do
        local _____7EC4 = _____53EC_5524_7269_7EC4_8868[key]
        if _____7EC4 ~= nil and _____7EC4["包含ID"](_____7EC4, id) then
            _____7EC4["处理死亡"](_____7EC4, dyingUnit, killingUnit)
        end
    end
end
local jass = require("jass.common")
GetHandleId = jass.GetHandleId
local RemoveUnit = jass.RemoveUnit
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local unregisterDeathListener = ____require_result_0.unregisterDeathListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local removeDelayedCallback = ____require_result_1.removeDelayedCallback
_____53EC_5524_7269_7EC4_8868 = {}
local _____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C = false
local function _____786E_4FDD_6B7B_4EA1_76D1_542C()
    if _____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C = true
    registerDeathListener(____on_53EC_5524_7269_6B7B_4EA1)
end
local function _____5C1D_8BD5_505C_6B62_6B7B_4EA1_76D1_542C()
    for key in pairs(_____53EC_5524_7269_7EC4_8868) do
        if _____53EC_5524_7269_7EC4_8868[key] ~= nil then
            return
        end
    end
    if not _____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C then
        return
    end
    unregisterDeathListener(____on_53EC_5524_7269_6B7B_4EA1)
    _____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C = false
end
local _____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0 = __TS__Class()
_____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0.name = "召唤物组状态实现"
function _____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0.prototype.____constructor(self, ID, _____53C2_6570)
    self["单位列表"] = {}
    self["死亡表"] = {}
    self["全灭延迟ID"] = 0
    self["已销毁"] = false
    self.ID = ID
    self["参数"] = _____53C2_6570
    _____53EC_5524_7269_7EC4_8868[ID] = self
    _____786E_4FDD_6B7B_4EA1_76D1_542C()
end
_____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0.prototype["登记"] = function(self, _____5355_4F4D)
    if self["已销毁"] or _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local ____self__5355_4F4D_5217_8868_2 = self["单位列表"]
    ____self__5355_4F4D_5217_8868_2[#____self__5355_4F4D_5217_8868_2 + 1] = _____5355_4F4D
    self["死亡表"][GetHandleId(_____5355_4F4D)] = nil
    self["广播数量变化"](self)
end
_____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0.prototype["移除"] = function(self, _____5355_4F4D, _____662F_5426_5220_9664_5355_4F4D)
    if _____662F_5426_5220_9664_5355_4F4D == nil then
        _____662F_5426_5220_9664_5355_4F4D = false
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local id = GetHandleId(_____5355_4F4D)
    do
        local i = #self["单位列表"] - 1
        while i >= 0 do
            if GetHandleId(self["单位列表"][i + 1]) == id then
                __TS__ArraySplice(self["单位列表"], i, 1)
            end
            i = i - 1
        end
    end
    __TS__Delete(self["死亡表"], id)
    if _____662F_5426_5220_9664_5355_4F4D then
        RemoveUnit(_____5355_4F4D)
    end
    self["广播数量变化"](self)
end
_____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0.prototype["取存活数量"] = function(self)
    local count = 0
    do
        local i = 0
        while i < #self["单位列表"] do
            local unit = self["单位列表"][i + 1]
            if unit ~= nil and unit ~= 0 and self["死亡表"][GetHandleId(unit)] == nil then
                count = count + 1
            end
            i = i + 1
        end
    end
    return count
end
_____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0.prototype["取总登记数量"] = function(self)
    return #self["单位列表"]
end
_____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0.prototype["取单位列表"] = function(self)
    local result = {}
    do
        local i = 0
        while i < #self["单位列表"] do
            result[#result + 1] = self["单位列表"][i + 1]
            i = i + 1
        end
    end
    return result
end
_____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0.prototype["清空"] = function(self, _____662F_5426_5220_9664_5355_4F4D)
    if _____662F_5426_5220_9664_5355_4F4D == nil then
        _____662F_5426_5220_9664_5355_4F4D = false
    end
    if self["全灭延迟ID"] ~= 0 then
        removeDelayedCallback(self["全灭延迟ID"])
        self["全灭延迟ID"] = 0
    end
    if _____662F_5426_5220_9664_5355_4F4D then
        do
            local i = 0
            while i < #self["单位列表"] do
                local unit = self["单位列表"][i + 1]
                if unit ~= nil and unit ~= 0 then
                    RemoveUnit(unit)
                end
                i = i + 1
            end
        end
    end
    self["单位列表"] = {}
    self["死亡表"] = {}
    self["广播数量变化"](self)
end
_____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0.prototype["销毁"] = function(self)
    if self["已销毁"] then
        return
    end
    self["已销毁"] = true
    self["清空"](self, false)
    __TS__Delete(_____53EC_5524_7269_7EC4_8868, self.ID)
    _____5C1D_8BD5_505C_6B62_6B7B_4EA1_76D1_542C()
end
_____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0.prototype["包含ID"] = function(self, id)
    do
        local i = 0
        while i < #self["单位列表"] do
            if GetHandleId(self["单位列表"][i + 1]) == id then
                return true
            end
            i = i + 1
        end
    end
    return false
end
_____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0.prototype["处理死亡"] = function(self, _____5355_4F4D, _____51FB_6740_8005)
    local id = GetHandleId(_____5355_4F4D)
    if self["死亡表"][id] == true then
        return
    end
    self["死亡表"][id] = true
    if self["参数"]["on单位死亡"] ~= nil then
        self["参数"]["on单位死亡"](_____5355_4F4D, _____51FB_6740_8005, self)
    end
    self["广播数量变化"](self)
    if self["取存活数量"](self) <= 0 then
        self["调度全灭"](self)
    end
end
_____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0.prototype["调度全灭"] = function(self)
    if self["全灭延迟ID"] ~= 0 then
        return
    end
    local ____self = self
    local delay = (self["参数"]["全灭延迟秒"] or 0) * 1000
    self["全灭延迟ID"] = addDelayedCallback(
        delay,
        function()
            ____self["全灭延迟ID"] = 0
            if ____self["取存活数量"](____self) > 0 then
                return
            end
            if ____self["参数"]["on全部死亡"] ~= nil then
                ____self["参数"]["on全部死亡"](____self)
            end
            if ____self["参数"]["全灭后保留死亡记录"] ~= true then
                ____self["清空"](____self, false)
            end
        end
    )
end
_____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0.prototype["广播数量变化"] = function(self)
    if self["参数"]["on数量变化"] ~= nil then
        self["参数"]["on数量变化"](
            self["取存活数量"](self),
            #self["单位列表"]
        )
    end
end
local _____4E0B_4E00_4E2A_53EC_5524_7269_7EC4ID = 0
____exports["创建召唤物组状态"] = function(_____53C2_6570)
    local ____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0_3 = _____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0
    _____4E0B_4E00_4E2A_53EC_5524_7269_7EC4ID = _____4E0B_4E00_4E2A_53EC_5524_7269_7EC4ID + 1
    local _____5B9E_4F8B = __TS__New(____53EC_5524_7269_7EC4_72B6_6001_5B9E_73B0_3, _____4E0B_4E00_4E2A_53EC_5524_7269_7EC4ID, _____53C2_6570)
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
    return _____5B9E_4F8B
end
return ____exports
