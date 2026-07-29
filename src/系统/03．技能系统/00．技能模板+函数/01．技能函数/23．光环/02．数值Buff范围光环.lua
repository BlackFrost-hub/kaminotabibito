local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____24_FF0E_53E5_67C4_4E0A_4E0B_6587_6258_7BA1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.24．句柄上下文托管")
local _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668 = ____24_FF0E_53E5_67C4_4E0A_4E0B_6587_6258_7BA1["创建句柄上下文托管器"]
local ____01_FF0E_8303_56F4_5149_73AF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.23．光环.01．范围光环")
local _____521B_5EFA_624B_52A8_8303_56F4_5149_73AF = ____01_FF0E_8303_56F4_5149_73AF["创建手动范围光环"]
local _____6CE8_518C_6301_6709_578B_8303_56F4_5149_73AF = ____01_FF0E_8303_56F4_5149_73AF["注册持有型范围光环"]
local _____540C_6B65_624B_52A8_8303_56F4_5149_73AF = ____01_FF0E_8303_56F4_5149_73AF["同步手动范围光环"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local function _____53D6_53E5_67C4ID(handle)
    if handle == nil or handle == 0 then
        return 0
    end
    return GetHandleId(handle) or 0
end
local function _____521B_5EFA_6570_503CBuff_8303_56F4_5149_73AF(_____53C2_6570, _____6CE8_518C_8303_56F4_5149_73AF)
    local _____6258_7BA1_5668 = _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668(_____53C2_6570["状态ID"])
    local function _____53D6_6216_5EFA_72B6_6001(target)
        local old = _____6258_7BA1_5668["读取"](target)
        if old ~= nil then
            return old
        end
        local next = {["总层数"] = 0, ["持有者贡献表"] = {}, ["持有者表"] = {}, ["已应用值表"] = {}}
        _____6258_7BA1_5668["写入"](target, next)
        return next
    end
    local function _____53D6_6765_6E90(_____72B6_6001, _____4F18_5148_6765_6E90)
        local preferredId = _____53D6_53E5_67C4ID(_____4F18_5148_6765_6E90)
        if preferredId ~= 0 and (_____72B6_6001["持有者贡献表"][preferredId] or 0) > 0 then
            return _____4F18_5148_6765_6E90
        end
        for key in pairs(_____72B6_6001["持有者表"]) do
            local holder = _____72B6_6001["持有者表"][key]
            if holder ~= nil and holder ~= 0 and (_____72B6_6001["持有者贡献表"][key] or 0) > 0 then
                return holder
            end
        end
        return nil
    end
    local function _____8BA1_7B97_603B_5C42_6570(_____72B6_6001)
        local total = 0
        for key in pairs(_____72B6_6001["持有者贡献表"]) do
            total = total + (_____72B6_6001["持有者贡献表"][key] or 0)
        end
        if _____53C2_6570["最大层数"] ~= nil and total > _____53C2_6570["最大层数"] then
            return _____53C2_6570["最大层数"]
        end
        return total
    end
    local function _____540C_6B65Buff(target, _____72B6_6001, _____6765_6E90)
        local buff = _____53C2_6570.Buff
        if buff == nil then
            return
        end
        if _____72B6_6001["总层数"] <= 0 then
            if buff["自定义移除"] ~= nil then
                buff["自定义移除"](target)
            elseif buff["归零移除"] ~= false then
                _____79FB_9664_5355_4F4D_6307_5B9ABuff(target, buff.BuffID)
            end
            return
        end
        if buff["自定义同步"] ~= nil then
            buff["自定义同步"](target, _____72B6_6001["总层数"], _____6765_6E90, _____72B6_6001["已应用值表"])
            return
        end
        if buff["持续秒"] <= 0 then
            return
        end
        local effectValue = buff["取显示值"] == nil and _____72B6_6001["总层数"] or buff["取显示值"](target, _____72B6_6001["总层数"], _____6765_6E90, _____72B6_6001["已应用值表"])
        local ____temp_1
        if buff["取附加参数"] == nil then
            ____temp_1 = nil
        else
            ____temp_1 = buff["取附加参数"](target, _____72B6_6001["总层数"], _____6765_6E90, _____72B6_6001["已应用值表"])
        end
        local extras = ____temp_1
        registerManualBuff(
            target,
            buff.BuffID,
            buff["持续秒"],
            effectValue,
            extras
        )
    end
    local function _____540C_6B65_76EE_6807(target, _____4F18_5148_6765_6E90)
        local _____72B6_6001 = _____6258_7BA1_5668["读取"](target)
        if _____72B6_6001 == nil then
            return
        end
        _____72B6_6001["总层数"] = _____8BA1_7B97_603B_5C42_6570(_____72B6_6001)
        local _____6765_6E90 = _____53D6_6765_6E90(_____72B6_6001, _____4F18_5148_6765_6E90)
        do
            local i = 0
            while i < #_____53C2_6570["数值效果列表"] do
                local effect = _____53C2_6570["数值效果列表"][i + 1]
                local oldValue = _____72B6_6001["已应用值表"][effect.key] or 0
                local nextValue = _____72B6_6001["总层数"] > 0 and effect["计算总值"](target, _____72B6_6001["总层数"], oldValue, _____6765_6E90) or 0
                local delta = nextValue - oldValue
                if delta ~= 0 then
                    effect["应用差值"](target, delta)
                end
                _____72B6_6001["已应用值表"][effect.key] = nextValue
                i = i + 1
            end
        end
        _____540C_6B65Buff(target, _____72B6_6001, _____6765_6E90)
        if _____72B6_6001["总层数"] <= 0 then
            _____6258_7BA1_5668["清空"](target)
        else
            _____6258_7BA1_5668["写入"](target, _____72B6_6001)
        end
    end
    local function _____8BBE_7F6E_6301_6709_8005_8D21_732E(target, holder, count)
        local holderId = _____53D6_53E5_67C4ID(holder)
        if holderId == 0 then
            return
        end
        local _____72B6_6001 = _____53D6_6216_5EFA_72B6_6001(target)
        _____72B6_6001["持有者贡献表"][holderId] = count > 0 and count or 1
        _____72B6_6001["持有者表"][holderId] = holder
        _____540C_6B65_76EE_6807(target, holder)
    end
    local function _____79FB_9664_6301_6709_8005_8D21_732E(target, holder)
        local holderId = _____53D6_53E5_67C4ID(holder)
        local _____72B6_6001 = _____6258_7BA1_5668["读取"](target)
        if holderId == 0 or _____72B6_6001 == nil then
            return
        end
        __TS__Delete(_____72B6_6001["持有者贡献表"], holderId)
        __TS__Delete(_____72B6_6001["持有者表"], holderId)
        _____540C_6B65_76EE_6807(target)
    end
    return _____6CE8_518C_8303_56F4_5149_73AF({
        ["半径"] = _____53C2_6570["半径"],
        ["目标类型"] = _____53C2_6570["目标类型"],
        ["去重类型"] = _____53C2_6570["去重类型"],
        ["排除无敌"] = _____53C2_6570["排除无敌"],
        ["最小生命值"] = _____53C2_6570["最小生命值"],
        ["额外筛选"] = _____53C2_6570["额外筛选"],
        ["应用目标效果"] = _____8BBE_7F6E_6301_6709_8005_8D21_732E,
        ["同步目标效果"] = _____8BBE_7F6E_6301_6709_8005_8D21_732E,
        ["移除目标效果"] = _____79FB_9664_6301_6709_8005_8D21_732E
    })
end
local function _____6CE8_518C_624B_52A8_6570_503C_8303_56F4_5149_73AF(_____53C2_6570)
    return _____521B_5EFA_624B_52A8_8303_56F4_5149_73AF(_____53C2_6570)
end
____exports["注册数值Buff范围光环"] = function(_____53C2_6570)
    local function _____6CE8_518C_5F53_524D_6301_6709_578B_8303_56F4_5149_73AF(_____8303_56F4_53C2_6570)
        _____6CE8_518C_6301_6709_578B_8303_56F4_5149_73AF(__TS__ObjectAssign({}, _____8303_56F4_53C2_6570, {["物品类型ID"] = _____53C2_6570["物品类型ID"], ["间隔毫秒"] = _____53C2_6570["间隔毫秒"]}))
        return 0
    end
    _____521B_5EFA_6570_503CBuff_8303_56F4_5149_73AF(_____53C2_6570, _____6CE8_518C_5F53_524D_6301_6709_578B_8303_56F4_5149_73AF)
end
____exports["创建手动数值Buff范围光环"] = function(_____53C2_6570)
    return _____521B_5EFA_6570_503CBuff_8303_56F4_5149_73AF(_____53C2_6570, _____6CE8_518C_624B_52A8_6570_503C_8303_56F4_5149_73AF)
end
____exports["同步手动数值Buff范围光环"] = function(_____5149_73AFID, _____6301_6709_8005, _____751F_6548)
    _____540C_6B65_624B_52A8_8303_56F4_5149_73AF(_____5149_73AFID, _____6301_6709_8005, _____751F_6548)
end
return ____exports
