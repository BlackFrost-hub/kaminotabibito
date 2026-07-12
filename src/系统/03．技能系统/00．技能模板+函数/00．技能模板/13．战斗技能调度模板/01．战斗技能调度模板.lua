local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器")
local _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668 = ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668["创建周期机制调度器"]
local ____18_FF0E_6280_80FD_4E92_65A5_9501 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.18．技能互斥锁")
local _____521B_5EFA_6280_80FD_4E92_65A5_9501 = ____18_FF0E_6280_80FD_4E92_65A5_9501["创建技能互斥锁"]
local jass = require("jass.common")
local GetRandomReal = jass.GetRandomReal
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local function _____53D6_914D_7F6E_6570_503C(value, context)
    if value == nil then
        return 0
    end
    return type(value) == "number" and value or value(context)
end
local function _____53D6_76EE_6807_914D_7F6E_6570_503C(value, context, target)
    if value == nil then
        return 0
    end
    return type(value) == "number" and value or value(context, target)
end
local _____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0 = __TS__Class()
_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.name = "战斗技能调度器实现"
function _____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["状态表"] = {}
    self["参数"] = _____53C2_6570
    self["互斥锁"] = _____53C2_6570["互斥锁"] or _____521B_5EFA_6280_80FD_4E92_65A5_9501({["名称"] = _____53C2_6570["名称"], ["清理"] = _____53C2_6570["清理"], ["取当前时间"] = _____53C2_6570["取当前时间"]})
    self["独占状态管理器"] = _____53C2_6570["独占状态管理器"]
    self["周期调度器"] = _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668({
        ["名称"] = _____53C2_6570["名称"] .. "-周期驱动",
        ["清理"] = _____53C2_6570["清理"],
        ["间隔毫秒"] = _____53C2_6570["间隔毫秒"],
        ["取上下文列表"] = _____53C2_6570["取上下文列表"],
        ["取当前时间"] = _____53C2_6570["取当前时间"] or getServerTime,
        ["自动启动"] = _____53C2_6570["自动启动"],
        ["执行"] = function(context, nowMs) return self["执行上下文"](self, context, nowMs) end
    })
end
_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.prototype["启动"] = function(self)
    local ____self_1 = self["周期调度器"]
    ____self_1["启动"](____self_1)
end
_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.prototype["停止"] = function(self)
    local ____self_2 = self["周期调度器"]
    ____self_2["停止"](____self_2)
end
_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.prototype["是否运行中"] = function(self)
    local ____self_3 = self["周期调度器"]
    return ____self_3["是否运行中"](____self_3)
end
_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.prototype["清空上下文"] = function(self, _____4E0A_4E0B_6587_952E)
    __TS__Delete(self["状态表"], _____4E0A_4E0B_6587_952E)
end
_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.prototype["设置忙碌到"] = function(self, _____4E0A_4E0B_6587_952E, _____5230_671F_6BEB_79D2)
    local _____72B6_6001 = self["状态表"][_____4E0A_4E0B_6587_952E]
    if _____72B6_6001 ~= nil then
        _____72B6_6001["忙碌到毫秒"] = _____5230_671F_6BEB_79D2
    end
end
_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.prototype["设置技能下次可用"] = function(self, _____4E0A_4E0B_6587_952E, skillKey, _____5230_671F_6BEB_79D2)
    local _____72B6_6001 = self["状态表"][_____4E0A_4E0B_6587_952E]
    if _____72B6_6001 ~= nil then
        _____72B6_6001["下次可用毫秒表"][skillKey] = _____5230_671F_6BEB_79D2
    end
end
_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.prototype["取运行状态"] = function(self, _____4E0A_4E0B_6587_952E)
    return self["状态表"][_____4E0A_4E0B_6587_952E]
end
_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.prototype["取互斥锁"] = function(self)
    return self["互斥锁"]
end
_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.prototype["取独占状态管理器"] = function(self)
    return self["独占状态管理器"]
end
_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.prototype["执行上下文"] = function(self, context, nowMs)
    if self["参数"]["可调度"] ~= nil and not self["参数"]["可调度"](context, nowMs) then
        return
    end
    local contextKey = self["参数"]["取上下文键"](context)
    if contextKey == 0 then
        return
    end
    local _____72B6_6001 = self["取或建状态"](self, contextKey, context, nowMs)
    if nowMs < _____72B6_6001["忙碌到毫秒"] then
        return
    end
    local _____5019_9009_5217_8868 = self["收集候选"](
        self,
        context,
        contextKey,
        _____72B6_6001,
        nowMs
    )
    local _____5019_9009 = self["选择候选"](self, _____5019_9009_5217_8868)
    if _____5019_9009 == nil then
        return
    end
    self["执行候选"](
        self,
        context,
        contextKey,
        _____72B6_6001,
        _____5019_9009,
        nowMs
    )
end
_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.prototype["取或建状态"] = function(self, contextKey, context, nowMs)
    local _____72B6_6001 = self["状态表"][contextKey]
    if _____72B6_6001 ~= nil then
        return _____72B6_6001
    end
    _____72B6_6001 = {["已初始化"] = true, ["忙碌到毫秒"] = 0, ["上次释放技能"] = "", ["下次可用毫秒表"] = {}}
    do
        local i = 0
        while i < #self["参数"]["技能列表"] do
            local _____5B9A_4E49 = self["参数"]["技能列表"][i + 1]
            _____72B6_6001["下次可用毫秒表"][_____5B9A_4E49.key] = nowMs + _____53D6_914D_7F6E_6570_503C(_____5B9A_4E49["首次延迟毫秒"], context)
            i = i + 1
        end
    end
    self["状态表"][contextKey] = _____72B6_6001
    return _____72B6_6001
end
_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.prototype["收集候选"] = function(self, context, contextKey, _____72B6_6001, nowMs)
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #self["参数"]["技能列表"] do
            do
                local _____5B9A_4E49 = self["参数"]["技能列表"][i + 1]
                if nowMs < (_____72B6_6001["下次可用毫秒表"][_____5B9A_4E49.key] or 0) then
                    goto __continue30
                end
                if _____5B9A_4E49["阶段允许"] ~= nil and not _____5B9A_4E49["阶段允许"](context, nowMs) then
                    goto __continue30
                end
                if _____5B9A_4E49["可释放"] ~= nil and not _____5B9A_4E49["可释放"](context, nowMs, _____72B6_6001) then
                    goto __continue30
                end
                local ____temp_5 = _____5B9A_4E49["互斥组"] ~= nil
                if ____temp_5 then
                    local ____self_4 = self["互斥锁"]
                    ____temp_5 = ____self_4["是否被占用"](____self_4, _____5B9A_4E49["互斥组"], nowMs)
                end
                if ____temp_5 then
                    goto __continue30
                end
                local ____temp_7 = self["独占状态管理器"] ~= nil and _____5B9A_4E49["跳过独占状态"] ~= true
                if ____temp_7 then
                    local ____self_6 = self["独占状态管理器"]
                    ____temp_7 = not ____self_6["可开始"](
                        ____self_6,
                        self["取独占状态Key"](self, contextKey, _____5B9A_4E49.key),
                        _____5B9A_4E49["独占优先级"] or self["参数"]["默认独占优先级"] or 10,
                        nowMs
                    )
                end
                if ____temp_7 then
                    goto __continue30
                end
                local ____temp_8
                if _____5B9A_4E49["选择目标"] == nil then
                    ____temp_8 = nil
                else
                    ____temp_8 = _____5B9A_4E49["选择目标"](context, nowMs)
                end
                local target = ____temp_8
                if _____5B9A_4E49["选择目标"] ~= nil and target == nil then
                    goto __continue30
                end
                if target ~= nil and _____5B9A_4E49["目标有效"] ~= nil and not _____5B9A_4E49["目标有效"](context, target, nowMs) then
                    goto __continue30
                end
                _____7ED3_679C[#_____7ED3_679C + 1] = {["定义"] = _____5B9A_4E49, ["目标"] = target}
            end
            ::__continue30::
            i = i + 1
        end
    end
    return _____7ED3_679C
end
_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.prototype["选择候选"] = function(self, _____5019_9009_5217_8868)
    if #_____5019_9009_5217_8868 <= 0 then
        return nil
    end
    local _____6700_9AD8_4F18_5148_7EA7 = _____5019_9009_5217_8868[1]["定义"]["优先级"] or 0
    do
        local i = 1
        while i < #_____5019_9009_5217_8868 do
            local _____4F18_5148_7EA7 = _____5019_9009_5217_8868[i + 1]["定义"]["优先级"] or 0
            if _____4F18_5148_7EA7 > _____6700_9AD8_4F18_5148_7EA7 then
                _____6700_9AD8_4F18_5148_7EA7 = _____4F18_5148_7EA7
            end
            i = i + 1
        end
    end
    local _____603B_6743_91CD = 0
    do
        local i = 0
        while i < #_____5019_9009_5217_8868 do
            do
                if (_____5019_9009_5217_8868[i + 1]["定义"]["优先级"] or 0) ~= _____6700_9AD8_4F18_5148_7EA7 then
                    goto __continue44
                end
                local _____6743_91CD = _____5019_9009_5217_8868[i + 1]["定义"]["权重"] or 1
                if _____6743_91CD > 0 then
                    _____603B_6743_91CD = _____603B_6743_91CD + _____6743_91CD
                end
            end
            ::__continue44::
            i = i + 1
        end
    end
    if _____603B_6743_91CD <= 0 then
        return nil
    end
    local _____968F_673A_503C = GetRandomReal(0, _____603B_6743_91CD)
    local _____6700_540E_5019_9009
    do
        local i = 0
        while i < #_____5019_9009_5217_8868 do
            do
                local _____5019_9009 = _____5019_9009_5217_8868[i + 1]
                if (_____5019_9009["定义"]["优先级"] or 0) ~= _____6700_9AD8_4F18_5148_7EA7 then
                    goto __continue49
                end
                local _____6743_91CD = _____5019_9009["定义"]["权重"] or 1
                if _____6743_91CD <= 0 then
                    goto __continue49
                end
                _____6700_540E_5019_9009 = _____5019_9009
                _____968F_673A_503C = _____968F_673A_503C - _____6743_91CD
                if _____968F_673A_503C <= 0 then
                    return _____5019_9009
                end
            end
            ::__continue49::
            i = i + 1
        end
    end
    return _____6700_540E_5019_9009
end
_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.prototype["执行候选"] = function(self, context, contextKey, _____72B6_6001, _____5019_9009, nowMs)
    local _____5B9A_4E49 = _____5019_9009["定义"]
    local busyMs = _____53D6_76EE_6807_914D_7F6E_6570_503C(_____5B9A_4E49["忙碌毫秒"], context, _____5019_9009["目标"])
    local mutexMs = _____53D6_76EE_6807_914D_7F6E_6570_503C(_____5B9A_4E49["互斥持续毫秒"], context, _____5019_9009["目标"])
    if mutexMs <= 0 then
        mutexMs = busyMs
    end
    local _____5360_7528_8005 = (tostring(contextKey) .. ":") .. _____5B9A_4E49.key
    local ____temp_10 = _____5B9A_4E49["互斥组"] ~= nil
    if ____temp_10 then
        local ____self_9 = self["互斥锁"]
        ____temp_10 = not ____self_9["尝试占用"](
            ____self_9,
            _____5B9A_4E49["互斥组"],
            _____5360_7528_8005,
            mutexMs,
            nowMs
        )
    end
    if ____temp_10 then
        return
    end
    local _____72EC_5360Token = 0
    if self["独占状态管理器"] ~= nil and _____5B9A_4E49["跳过独占状态"] ~= true then
        local _____72EC_5360_6301_7EED_6BEB_79D2 = _____53D6_76EE_6807_914D_7F6E_6570_503C(_____5B9A_4E49["独占持续毫秒"], context, _____5019_9009["目标"])
        if _____5B9A_4E49["独占持续毫秒"] == nil then
            _____72EC_5360_6301_7EED_6BEB_79D2 = busyMs
        end
        local _____72EC_5360_72B6_6001Key = self["取独占状态Key"](self, contextKey, _____5B9A_4E49.key)
        local ____on_72EC_5360_72B6_6001_7ED3_675F = _____5B9A_4E49["独占状态结束"]
        local ____self_15 = self["独占状态管理器"]
        local ____self_15__5F00_59CB_16 = ____self_15["开始"]
        local ____temp_12 = _____5B9A_4E49["独占优先级"] or self["参数"]["默认独占优先级"] or 10
        local ____72EC_5360_6301_7EED_6BEB_79D2_13 = _____72EC_5360_6301_7EED_6BEB_79D2
        local ____temp_14 = _____5B9A_4E49["独占状态可被抢占"] == true
        local ____temp_11
        if ____on_72EC_5360_72B6_6001_7ED3_675F == nil then
            ____temp_11 = nil
        else
            ____temp_11 = function(event)
                ____on_72EC_5360_72B6_6001_7ED3_675F(context, _____5019_9009["目标"], event)
            end
        end
        _____72EC_5360Token = ____self_15__5F00_59CB_16(____self_15, {
            key = _____72EC_5360_72B6_6001Key,
            ["优先级"] = ____temp_12,
            ["持续毫秒"] = ____72EC_5360_6301_7EED_6BEB_79D2_13,
            ["可被抢占"] = ____temp_14,
            ["on结束"] = ____temp_11
        }, nowMs)
        if _____72EC_5360Token == 0 then
            if _____5B9A_4E49["互斥组"] ~= nil then
                local ____self_17 = self["互斥锁"]
                ____self_17["释放"](____self_17, _____5B9A_4E49["互斥组"], _____5360_7528_8005)
            end
            return
        end
    end
    local _____6210_529F = _____5B9A_4E49["执行"](context, _____5019_9009["目标"], nowMs) ~= false
    if not _____6210_529F then
        if _____5B9A_4E49["互斥组"] ~= nil then
            local ____self_18 = self["互斥锁"]
            ____self_18["释放"](____self_18, _____5B9A_4E49["互斥组"], _____5360_7528_8005)
        end
        if _____72EC_5360Token ~= 0 then
            local ____opt_19 = self["独占状态管理器"]
            if ____opt_19 ~= nil then
                ____opt_19["结束"](____opt_19, _____72EC_5360Token, "取消", _____5B9A_4E49.key)
            end
        end
        return
    end
    _____72B6_6001["下次可用毫秒表"][_____5B9A_4E49.key] = nowMs + _____53D6_914D_7F6E_6570_503C(_____5B9A_4E49["冷却毫秒"], context)
    _____72B6_6001["忙碌到毫秒"] = nowMs + busyMs
    _____72B6_6001["上次释放技能"] = _____5B9A_4E49.key
    self["状态表"][contextKey] = _____72B6_6001
    if _____5B9A_4E49["成功后"] ~= nil then
        _____5B9A_4E49["成功后"](context, _____5019_9009["目标"], nowMs)
    end
    if self["参数"]["成功后"] ~= nil then
        self["参数"]["成功后"](context, _____5B9A_4E49.key, _____5019_9009["目标"], nowMs)
    end
end
_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0.prototype["取独占状态Key"] = function(self, contextKey, skillKey)
    return (((self["参数"]["名称"] .. ":") .. tostring(contextKey)) .. ":") .. skillKey
end
____exports["创建战斗技能调度器"] = function(_____53C2_6570)
    return __TS__New(_____6218_6597_6280_80FD_8C03_5EA6_5668_5B9E_73B0, _____53C2_6570)
end
return ____exports
