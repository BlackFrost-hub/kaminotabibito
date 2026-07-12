local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local function _____590D_5236_72B6_6001_5217_8868(_____5217_8868)
    local result = {}
    do
        local i = 0
        while i < #_____5217_8868 do
            result[#result + 1] = _____5217_8868[i + 1]
            i = i + 1
        end
    end
    return result
end
local function _____72B6_6001_5728_5217_8868_4E2D(_____72B6_6001, _____5217_8868)
    do
        local i = 0
        while i < #_____5217_8868 do
            if _____5217_8868[i + 1] == _____72B6_6001 then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____53D6_5355_4F4D_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local _____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0 = __TS__Class()
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.name = "联合战斗成员生命周期实现"
function _____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["成员表"] = {}
    self["成员Key列表"] = {}
    self["单位到成员Key"] = {}
    self["最终结算已触发"] = false
    self["已销毁"] = false
    self["参数"] = _____53C2_6570
    self["名称"] = _____53C2_6570["名称"]
    self["默认最终状态列表"] = _____590D_5236_72B6_6001_5217_8868(_____53C2_6570["默认最终状态列表"] or ({"崩解", "倒地", "离场"}))
    local _____6210_5458_5217_8868 = _____53C2_6570["成员列表"] or ({})
    do
        local i = 0
        while i < #_____6210_5458_5217_8868 do
            self["登记成员"](self, _____6210_5458_5217_8868[i + 1])
            i = i + 1
        end
    end
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["登记成员"] = function(self, _____5B9A_4E49)
    if self["已销毁"] or _____5B9A_4E49.key == "" or self["成员表"][_____5B9A_4E49.key] ~= nil then
        return false
    end
    local _____6210_5458 = {
        key = _____5B9A_4E49.key,
        ["单位"] = _____5B9A_4E49["单位"],
        ["角色"] = _____5B9A_4E49["角色"],
        ["状态"] = _____5B9A_4E49["初始状态"] or "未加入",
        ["数据"] = _____5B9A_4E49["数据"],
        ["参与最终结算"] = _____5B9A_4E49["参与最终结算"],
        ["最终状态列表"] = _____590D_5236_72B6_6001_5217_8868(_____5B9A_4E49["最终状态列表"] or self["默认最终状态列表"])
    }
    self["成员表"][_____5B9A_4E49.key] = _____6210_5458
    local ____self__6210_5458Key_5217_8868_0 = self["成员Key列表"]
    ____self__6210_5458Key_5217_8868_0[#____self__6210_5458Key_5217_8868_0 + 1] = _____5B9A_4E49.key
    self["登记单位映射"](self, _____6210_5458)
    return true
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["移除成员"] = function(self, key)
    if self["已销毁"] then
        return false
    end
    local _____6210_5458 = self["成员表"][key]
    if _____6210_5458 == nil then
        return false
    end
    self["移除单位映射"](self, _____6210_5458)
    __TS__Delete(self["成员表"], key)
    do
        local i = 0
        while i < #self["成员Key列表"] do
            do
                if self["成员Key列表"][i + 1] ~= key then
                    goto __continue20
                end
                __TS__ArraySplice(self["成员Key列表"], i, 1)
                break
            end
            ::__continue20::
            i = i + 1
        end
    end
    return true
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["更新单位"] = function(self, key, _____5355_4F4D)
    if self["已销毁"] then
        return false
    end
    local _____6210_5458 = self["成员表"][key]
    if _____6210_5458 == nil then
        return false
    end
    self["移除单位映射"](self, _____6210_5458)
    _____6210_5458["单位"] = _____5355_4F4D
    self["登记单位映射"](self, _____6210_5458)
    return true
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["设置状态"] = function(self, key, _____72B6_6001, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "成员状态变化"
    end
    if self["已销毁"] then
        return false
    end
    local _____6210_5458 = self["成员表"][key]
    if _____6210_5458 == nil or _____72B6_6001 == "" or _____6210_5458["状态"] == _____72B6_6001 then
        return false
    end
    local _____65E7_72B6_6001 = _____6210_5458["状态"]
    _____6210_5458["状态"] = _____72B6_6001
    if self["参数"]["on状态变化"] ~= nil then
        self["参数"]["on状态变化"]({["成员"] = _____6210_5458, ["旧状态"] = _____65E7_72B6_6001, ["新状态"] = _____72B6_6001, ["原因"] = _____539F_56E0})
    end
    self["检查最终结算"](self)
    return true
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["写入数据"] = function(self, key, _____6570_636E)
    if self["已销毁"] then
        return false
    end
    local _____6210_5458 = self["成员表"][key]
    if _____6210_5458 == nil then
        return false
    end
    _____6210_5458["数据"] = _____6570_636E
    return true
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["取成员"] = function(self, key)
    return self["成员表"][key]
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["按单位取成员"] = function(self, _____5355_4F4D)
    local id = _____53D6_5355_4F4D_53E5_67C4ID(_____5355_4F4D)
    if id == 0 then
        return nil
    end
    local key = self["单位到成员Key"][id]
    local ____temp_1
    if key == nil then
        ____temp_1 = nil
    else
        ____temp_1 = self["成员表"][key]
    end
    return ____temp_1
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["取成员列表"] = function(self)
    local result = {}
    do
        local i = 0
        while i < #self["成员Key列表"] do
            local _____6210_5458 = self["成员表"][self["成员Key列表"][i + 1]]
            if _____6210_5458 ~= nil then
                result[#result + 1] = _____6210_5458
            end
            i = i + 1
        end
    end
    return result
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["按角色取成员"] = function(self, _____89D2_8272)
    local result = {}
    local _____6210_5458_5217_8868 = self["取成员列表"](self)
    do
        local i = 0
        while i < #_____6210_5458_5217_8868 do
            if _____6210_5458_5217_8868[i + 1]["角色"] == _____89D2_8272 then
                result[#result + 1] = _____6210_5458_5217_8868[i + 1]
            end
            i = i + 1
        end
    end
    return result
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["按状态取成员"] = function(self, _____72B6_6001)
    local result = {}
    local _____6210_5458_5217_8868 = self["取成员列表"](self)
    do
        local i = 0
        while i < #_____6210_5458_5217_8868 do
            if _____6210_5458_5217_8868[i + 1]["状态"] == _____72B6_6001 then
                result[#result + 1] = _____6210_5458_5217_8868[i + 1]
            end
            i = i + 1
        end
    end
    return result
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["任一满足"] = function(self, _____5224_65AD)
    local _____6210_5458_5217_8868 = self["取成员列表"](self)
    do
        local i = 0
        while i < #_____6210_5458_5217_8868 do
            if _____5224_65AD(_____6210_5458_5217_8868[i + 1]) then
                return true
            end
            i = i + 1
        end
    end
    return false
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["全部满足"] = function(self, _____5224_65AD, _____53EA_770B_6700_7EC8_7ED3_7B97_6210_5458)
    if _____53EA_770B_6700_7EC8_7ED3_7B97_6210_5458 == nil then
        _____53EA_770B_6700_7EC8_7ED3_7B97_6210_5458 = false
    end
    local _____6210_5458_5217_8868 = self["取成员列表"](self)
    local _____5DF2_68C0_67E5_6570_91CF = 0
    do
        local i = 0
        while i < #_____6210_5458_5217_8868 do
            do
                local _____6210_5458 = _____6210_5458_5217_8868[i + 1]
                if _____53EA_770B_6700_7EC8_7ED3_7B97_6210_5458 and not _____6210_5458["参与最终结算"] then
                    goto __continue53
                end
                _____5DF2_68C0_67E5_6570_91CF = _____5DF2_68C0_67E5_6570_91CF + 1
                if not _____5224_65AD(_____6210_5458) then
                    return false
                end
            end
            ::__continue53::
            i = i + 1
        end
    end
    return _____5DF2_68C0_67E5_6570_91CF > 0
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["是否满足最终结算"] = function(self)
    return self["全部满足"](
        self,
        function(_____6210_5458)
            return _____72B6_6001_5728_5217_8868_4E2D(_____6210_5458["状态"], _____6210_5458["最终状态列表"])
        end,
        true
    )
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["已触发最终结算"] = function(self)
    return self["最终结算已触发"]
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["销毁"] = function(self)
    if self["已销毁"] then
        return
    end
    self["已销毁"] = true
    self["成员表"] = {}
    self["成员Key列表"] = {}
    self["单位到成员Key"] = {}
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["检查最终结算"] = function(self)
    if self["最终结算已触发"] or not self["是否满足最终结算"](self) then
        return
    end
    self["最终结算已触发"] = true
    if self["参数"]["on满足最终结算"] ~= nil then
        self["参数"]["on满足最终结算"](self["取成员列表"](self))
    end
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["登记单位映射"] = function(self, _____6210_5458)
    local id = _____53D6_5355_4F4D_53E5_67C4ID(_____6210_5458["单位"])
    if id ~= 0 then
        self["单位到成员Key"][id] = _____6210_5458.key
    end
end
_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0.prototype["移除单位映射"] = function(self, _____6210_5458)
    local id = _____53D6_5355_4F4D_53E5_67C4ID(_____6210_5458["单位"])
    if id ~= 0 and self["单位到成员Key"][id] == _____6210_5458.key then
        __TS__Delete(self["单位到成员Key"], id)
    end
end
____exports["创建联合战斗成员生命周期"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____8054_5408_6218_6597_6210_5458_751F_547D_5468_671F_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_2 = _____53C2_6570["清理"]
        ____self_2["登记清理"](
            ____self_2,
            _____53C2_6570["名称"] .. "-联合成员生命周期",
            function()
                _____5B9E_4F8B["销毁"](_____5B9E_4F8B)
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
