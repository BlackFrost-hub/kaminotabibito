--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0EBoss_5F31_70B9_97E7_6027_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.02．Boss弱点韧性配置表")
local ____Boss_662F_5426_542F_7528_5F31_70B9_97E7_6027_673A_5236 = ____02_FF0EBoss_5F31_70B9_97E7_6027_914D_7F6E_8868["Boss是否启用弱点韧性机制"]
local _____67E5_627EBoss_5F31_70B9_97E7_6027_914D_7F6E = ____02_FF0EBoss_5F31_70B9_97E7_6027_914D_7F6E_8868["查找Boss弱点韧性配置"]
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.01．常量定义")
local ____Boss_62A4_536B_8840_6761UI_5E38_91CF = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss护卫血条UI常量"]
local ____03_FF0EBoss_8840_6761UI = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.03．Boss血条UI")
local _____6CE8_518CBoss_8840_6761UI = ____03_FF0EBoss_8840_6761UI["注册Boss血条UI"]
local _____6CE8_9500Boss_8840_6761UI = ____03_FF0EBoss_8840_6761UI["注销Boss血条UI"]
local ____04_FF0EBoss_5F31_70B9UI = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.04．Boss弱点UI")
local _____6CE8_518CBoss_5F31_70B9UI = ____04_FF0EBoss_5F31_70B9UI["注册Boss弱点UI"]
local _____6CE8_9500Boss_5F31_70B9UI = ____04_FF0EBoss_5F31_70B9UI["注销Boss弱点UI"]
local ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.05．Boss弱点运行状态")
local _____521B_5EFABoss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001["创建Boss血条弱点韧性运行状态"]
local _____6E05_7406Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001["清理Boss血条弱点韧性运行状态"]
local _____8BFB_53D6Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001["读取Boss血条弱点韧性运行状态"]
local _____83B7_53D6_5168_90E8Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001["获取全部Boss血条弱点韧性运行状态"]
local ____06_FF0EBoss_5F31_70B9_4F24_5BB3_7ED3_7B97 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.06．Boss弱点伤害结算")
local _____6CE8_518CBoss_5F31_70B9_4F24_5BB3_7ED3_7B97 = ____06_FF0EBoss_5F31_70B9_4F24_5BB3_7ED3_7B97["注册Boss弱点伤害结算"]
local _____6CE8_9500Boss_5F31_70B9_4F24_5BB3_7ED3_7B97 = ____06_FF0EBoss_5F31_70B9_4F24_5BB3_7ED3_7B97["注销Boss弱点伤害结算"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
____exports["启动Boss血条弱点韧性"] = function(context)
    if context["是否已结束"] then
        return
    end
    local oldState = _____8BFB_53D6Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(context["Boss句柄ID"])
    if oldState ~= nil and not oldState["是否已结束"] then
        return
    end
    local config = _____67E5_627EBoss_5F31_70B9_97E7_6027_914D_7F6E(context["Boss单位"])
    local state = _____521B_5EFABoss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(context, config)
    _____6CE8_518CBoss_8840_6761UI(state)
    if ____Boss_662F_5426_542F_7528_5F31_70B9_97E7_6027_673A_5236(config) then
        _____6CE8_518CBoss_5F31_70B9UI(state)
        _____6CE8_518CBoss_5F31_70B9_4F24_5BB3_7ED3_7B97(state)
    end
end
local function _____83B7_53D6_5F53_524D_62A4_536B_8840_6761_6570_91CF(context, _____62A4_536B_8840_6761_5F52_5C5E_7C7B_578B)
    local states = _____83B7_53D6_5168_90E8Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001()
    local count = 0
    do
        local i = 0
        while i < #states do
            do
                local state = states[i + 1]
                if state["显示类型"] ~= "护卫" then
                    goto __continue8
                end
                if state["是否已结束"] or not state["是否血条已注册"] then
                    goto __continue8
                end
                if state["护卫血条归属类型"] ~= _____62A4_536B_8840_6761_5F52_5C5E_7C7B_578B then
                    goto __continue8
                end
                if _____62A4_536B_8840_6761_5F52_5C5E_7C7B_578B == "独立" and state["所属主Boss句柄ID"] ~= context["Boss句柄ID"] then
                    goto __continue8
                end
                count = count + 1
            end
            ::__continue8::
            i = i + 1
        end
    end
    return count
end
____exports["启动Boss护卫血条弱点韧性"] = function(context, guardUnit, _____62A4_536B_8840_6761_5F52_5C5E_7C7B_578B)
    if _____62A4_536B_8840_6761_5F52_5C5E_7C7B_578B == nil then
        _____62A4_536B_8840_6761_5F52_5C5E_7C7B_578B = "独立"
    end
    if context["是否已结束"] or guardUnit == nil or guardUnit == 0 then
        return false
    end
    if _____83B7_53D6_5F53_524D_62A4_536B_8840_6761_6570_91CF(context, _____62A4_536B_8840_6761_5F52_5C5E_7C7B_578B) >= ____Boss_62A4_536B_8840_6761UI_5E38_91CF["最大显示数量"] then
        return false
    end
    local guardHandleId = GetHandleId(guardUnit) or 0
    if guardHandleId == 0 then
        return false
    end
    local oldState = _____8BFB_53D6Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(guardHandleId)
    if oldState ~= nil and not oldState["是否已结束"] then
        return true
    end
    local config = _____67E5_627EBoss_5F31_70B9_97E7_6027_914D_7F6E(guardUnit)
    local state = _____521B_5EFABoss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(
        context,
        config,
        guardUnit,
        "护卫",
        context["Boss句柄ID"],
        nil,
        _____62A4_536B_8840_6761_5F52_5C5E_7C7B_578B
    )
    _____6CE8_518CBoss_8840_6761UI(state)
    if ____Boss_662F_5426_542F_7528_5F31_70B9_97E7_6027_673A_5236(config) then
        _____6CE8_518CBoss_5F31_70B9UI(state)
        _____6CE8_518CBoss_5F31_70B9_4F24_5BB3_7ED3_7B97(state)
    end
    return true
end
____exports["结束Boss护卫血条弱点韧性"] = function(guardUnit)
    if guardUnit == nil or guardUnit == 0 then
        return
    end
    local guardHandleId = GetHandleId(guardUnit) or 0
    local state = _____8BFB_53D6Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(guardHandleId)
    if state == nil or state["显示类型"] ~= "护卫" or state["是否已结束"] then
        return
    end
    state["是否已结束"] = true
    _____6CE8_9500Boss_5F31_70B9_4F24_5BB3_7ED3_7B97(state)
    _____6CE8_9500Boss_5F31_70B9UI(state)
    _____6CE8_9500Boss_8840_6761UI(state)
    _____6E05_7406Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(guardHandleId)
end
____exports["结束Boss血条弱点韧性"] = function(context)
    local state = _____8BFB_53D6Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(context["Boss句柄ID"])
    if state == nil or state["是否已结束"] then
        return
    end
    state["是否已结束"] = true
    _____6CE8_9500Boss_5F31_70B9_4F24_5BB3_7ED3_7B97(state)
    _____6CE8_9500Boss_5F31_70B9UI(state)
    _____6CE8_9500Boss_8840_6761UI(state)
    _____6E05_7406Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(context["Boss句柄ID"])
end
return ____exports
