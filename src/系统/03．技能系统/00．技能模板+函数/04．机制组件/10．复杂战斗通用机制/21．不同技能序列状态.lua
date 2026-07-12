local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local getServerTime = ____require_result_0.getServerTime
local function ____on_4E0D_540C_6280_80FD_5E8F_5217_5230_671F(variable)
    local data = variable
    if data == nil then
        return
    end
    local ____self_1 = data["管理器"]
    ____self_1["处理到期"](____self_1, data["状态Key"], data.token)
end
local function _____9ED8_8BA4_53D6_53E5_67C4Key(handle)
    if handle == nil or handle == 0 then
        return 0
    end
    return GetHandleId(handle) or 0
end
local function _____8F6C_6362Key(value)
    return type(value) == "number" and tostring(value) or value
end
local _____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0 = __TS__Class()
_____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0.name = "不同技能序列状态实现"
function _____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["状态表"] = {}
    self["下一个Token"] = 0
    self["已销毁"] = false
    self["参数"] = _____53C2_6570
    self["名称"] = _____53C2_6570["名称"]
    self["需要不同技能数"] = _____53C2_6570["需要不同技能数"] > 0 and _____53C2_6570["需要不同技能数"] or 1
    self["时间窗毫秒"] = _____53C2_6570["时间窗毫秒"] > 0 and _____53C2_6570["时间窗毫秒"] or 1
    self["取当前时间"] = _____53C2_6570["取当前时间"] or getServerTime
end
_____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0.prototype["记录"] = function(self, _____4E3B_4F53, skillKey, _____76EE_6807, nowMs)
    if self["已销毁"] or skillKey == "" then
        return nil
    end
    local _____72B6_6001Key = self["取状态Key"](self, _____4E3B_4F53, _____76EE_6807)
    if _____72B6_6001Key == "" then
        return nil
    end
    local now = nowMs == nil and self["取当前时间"]() or nowMs
    local _____72B6_6001 = self["读取运行时"](self, _____72B6_6001Key, now)
    local _____56E0_91CD_590D_800C_91CD_7F6E = false
    if _____72B6_6001 ~= nil and _____72B6_6001["已就绪"] then
        return self["创建记录结果"](
            self,
            _____72B6_6001,
            false,
            false,
            false
        )
    end
    if _____72B6_6001 ~= nil and _____72B6_6001["技能表"][skillKey] ~= nil then
        if (self["参数"]["重复策略"] or "忽略") == "忽略" then
            return self["创建记录结果"](
                self,
                _____72B6_6001,
                false,
                false,
                false
            )
        end
        self["移除状态"](self, _____72B6_6001)
        _____72B6_6001 = nil
        _____56E0_91CD_590D_800C_91CD_7F6E = true
    end
    if _____72B6_6001 == nil then
        _____72B6_6001 = self["创建状态"](
            self,
            _____72B6_6001Key,
            _____4E3B_4F53,
            _____76EE_6807,
            now
        )
    end
    _____72B6_6001["技能表"][skillKey] = true
    local ____72B6_6001__6280_80FD_987A_5E8F_2 = _____72B6_6001["技能顺序"]
    ____72B6_6001__6280_80FD_987A_5E8F_2[#____72B6_6001__6280_80FD_987A_5E8F_2 + 1] = skillKey
    local _____521A_521A_5C31_7EEA = not _____72B6_6001["已就绪"] and #_____72B6_6001["技能顺序"] >= self["需要不同技能数"]
    if _____521A_521A_5C31_7EEA then
        _____72B6_6001["已就绪"] = true
        if self["参数"]["on就绪"] ~= nil then
            self["参数"]["on就绪"](self["创建快照"](self, _____72B6_6001))
        end
    end
    return self["创建记录结果"](
        self,
        _____72B6_6001,
        true,
        _____521A_521A_5C31_7EEA,
        _____56E0_91CD_590D_800C_91CD_7F6E
    )
end
_____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0.prototype["读取"] = function(self, _____4E3B_4F53, _____76EE_6807, nowMs)
    if self["已销毁"] then
        return nil
    end
    local _____72B6_6001Key = self["取状态Key"](self, _____4E3B_4F53, _____76EE_6807)
    if _____72B6_6001Key == "" then
        return nil
    end
    local now = nowMs == nil and self["取当前时间"]() or nowMs
    local _____72B6_6001 = self["读取运行时"](self, _____72B6_6001Key, now)
    local ____temp_3
    if _____72B6_6001 == nil then
        ____temp_3 = nil
    else
        ____temp_3 = self["创建快照"](self, _____72B6_6001)
    end
    return ____temp_3
end
_____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0.prototype["消耗"] = function(self, _____4E3B_4F53, _____76EE_6807, nowMs)
    if self["已销毁"] then
        return nil
    end
    local _____72B6_6001Key = self["取状态Key"](self, _____4E3B_4F53, _____76EE_6807)
    if _____72B6_6001Key == "" then
        return nil
    end
    local now = nowMs == nil and self["取当前时间"]() or nowMs
    local _____72B6_6001 = self["读取运行时"](self, _____72B6_6001Key, now)
    if _____72B6_6001 == nil or not _____72B6_6001["已就绪"] then
        return nil
    end
    local _____5FEB_7167 = self["创建快照"](self, _____72B6_6001)
    self["移除状态"](self, _____72B6_6001)
    return _____5FEB_7167
end
_____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0.prototype["清空"] = function(self, _____4E3B_4F53, _____76EE_6807)
    if self["已销毁"] then
        return false
    end
    local _____72B6_6001Key = self["取状态Key"](self, _____4E3B_4F53, _____76EE_6807)
    if _____72B6_6001Key == "" then
        return false
    end
    local _____72B6_6001 = self["状态表"][_____72B6_6001Key]
    if _____72B6_6001 == nil then
        return false
    end
    self["移除状态"](self, _____72B6_6001)
    return true
end
_____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0.prototype["清空全部"] = function(self)
    for key in pairs(self["状态表"]) do
        local _____72B6_6001 = self["状态表"][key]
        if _____72B6_6001 ~= nil then
            self["移除状态"](self, _____72B6_6001)
        end
    end
    self["状态表"] = {}
end
_____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0.prototype["销毁"] = function(self)
    if self["已销毁"] then
        return
    end
    self["清空全部"](self)
    self["已销毁"] = true
end
_____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0.prototype["处理到期"] = function(self, _____72B6_6001Key, token)
    local _____72B6_6001 = self["状态表"][_____72B6_6001Key]
    if _____72B6_6001 == nil or _____72B6_6001.token ~= token then
        return
    end
    _____72B6_6001["到期回调ID"] = 0
    __TS__Delete(self["状态表"], _____72B6_6001Key)
    if self["参数"]["on过期"] ~= nil then
        self["参数"]["on过期"](self["创建快照"](self, _____72B6_6001))
    end
end
_____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0.prototype["创建状态"] = function(self, _____72B6_6001Key, _____4E3B_4F53, _____76EE_6807, nowMs)
    local ____self_4, _____4E0B_4E00_4E2AToken_5 = self, "下一个Token"
    local ____self__4E0B_4E00_4E2AToken_6 = ____self_4[_____4E0B_4E00_4E2AToken_5] + 1
    ____self_4[_____4E0B_4E00_4E2AToken_5] = ____self__4E0B_4E00_4E2AToken_6
    local _____72B6_6001 = {
        token = ____self__4E0B_4E00_4E2AToken_6,
        ["状态Key"] = _____72B6_6001Key,
        ["主体"] = _____4E3B_4F53,
        ["目标"] = _____76EE_6807,
        ["技能顺序"] = {},
        ["技能表"] = {},
        ["开始毫秒"] = nowMs,
        ["到期毫秒"] = nowMs + self["时间窗毫秒"],
        ["已就绪"] = false,
        ["到期回调ID"] = 0
    }
    _____72B6_6001["到期回调ID"] = addDelayedCallback(self["时间窗毫秒"], ____on_4E0D_540C_6280_80FD_5E8F_5217_5230_671F, {["管理器"] = self, ["状态Key"] = _____72B6_6001Key, token = _____72B6_6001.token})
    self["状态表"][_____72B6_6001Key] = _____72B6_6001
    return _____72B6_6001
end
_____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0.prototype["读取运行时"] = function(self, _____72B6_6001Key, nowMs)
    local _____72B6_6001 = self["状态表"][_____72B6_6001Key]
    if _____72B6_6001 == nil then
        return nil
    end
    if _____72B6_6001["到期毫秒"] > nowMs then
        return _____72B6_6001
    end
    self["处理到期"](self, _____72B6_6001Key, _____72B6_6001.token)
    return nil
end
_____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0.prototype["移除状态"] = function(self, _____72B6_6001)
    if _____72B6_6001["到期回调ID"] ~= 0 then
        removeDelayedCallback(_____72B6_6001["到期回调ID"])
    end
    if self["状态表"][_____72B6_6001["状态Key"]] == _____72B6_6001 then
        __TS__Delete(self["状态表"], _____72B6_6001["状态Key"])
    end
end
_____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0.prototype["取状态Key"] = function(self, _____4E3B_4F53, _____76EE_6807)
    local _____4E3B_4F53Value = self["参数"]["取主体Key"] == nil and _____9ED8_8BA4_53D6_53E5_67C4Key(_____4E3B_4F53) or self["参数"]["取主体Key"](_____4E3B_4F53)
    local _____4E3B_4F53Key = _____8F6C_6362Key(_____4E3B_4F53Value)
    if _____4E3B_4F53Key == "" or _____4E3B_4F53Key == "0" then
        return ""
    end
    if (self["参数"]["作用域"] or "主体") == "主体" then
        return "S:" .. _____4E3B_4F53Key
    end
    if _____76EE_6807 == nil then
        return ""
    end
    local _____76EE_6807Value = self["参数"]["取目标Key"] == nil and _____9ED8_8BA4_53D6_53E5_67C4Key(_____76EE_6807) or self["参数"]["取目标Key"](_____76EE_6807)
    local _____76EE_6807Key = _____8F6C_6362Key(_____76EE_6807Value)
    if _____76EE_6807Key == "" or _____76EE_6807Key == "0" then
        return ""
    end
    return (("ST:" .. _____4E3B_4F53Key) .. ":") .. _____76EE_6807Key
end
_____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0.prototype["创建快照"] = function(self, _____72B6_6001)
    local _____6280_80FD_987A_5E8F = {}
    do
        local i = 0
        while i < #_____72B6_6001["技能顺序"] do
            _____6280_80FD_987A_5E8F[#_____6280_80FD_987A_5E8F + 1] = _____72B6_6001["技能顺序"][i + 1]
            i = i + 1
        end
    end
    return {
        ["状态Key"] = _____72B6_6001["状态Key"],
        ["主体"] = _____72B6_6001["主体"],
        ["目标"] = _____72B6_6001["目标"],
        ["技能顺序"] = _____6280_80FD_987A_5E8F,
        ["当前数量"] = #_____6280_80FD_987A_5E8F,
        ["需要数量"] = self["需要不同技能数"],
        ["开始毫秒"] = _____72B6_6001["开始毫秒"],
        ["到期毫秒"] = _____72B6_6001["到期毫秒"],
        ["已就绪"] = _____72B6_6001["已就绪"]
    }
end
_____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0.prototype["创建记录结果"] = function(self, _____72B6_6001, _____5DF2_65B0_589E, _____521A_521A_5C31_7EEA, _____56E0_91CD_590D_800C_91CD_7F6E)
    return __TS__ObjectAssign(
        {},
        self["创建快照"](self, _____72B6_6001),
        {["已新增"] = _____5DF2_65B0_589E, ["刚刚就绪"] = _____521A_521A_5C31_7EEA, ["因重复而重置"] = _____56E0_91CD_590D_800C_91CD_7F6E}
    )
end
____exports["创建不同技能序列状态"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____4E0D_540C_6280_80FD_5E8F_5217_72B6_6001_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_7 = _____53C2_6570["清理"]
        ____self_7["登记清理"](
            ____self_7,
            _____53C2_6570["名称"] .. "-不同技能序列",
            function()
                _____5B9E_4F8B["销毁"](_____5B9E_4F8B)
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
