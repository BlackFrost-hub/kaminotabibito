--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0EBoss_5F31_70B9_97E7_6027_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.02．Boss弱点韧性配置表")
local _____67E5_627EBoss_5F31_70B9_97E7_6027_914D_7F6E = ____02_FF0EBoss_5F31_70B9_97E7_6027_914D_7F6E_8868["查找Boss弱点韧性配置"]
local ____03_FF0EBoss_8840_6761UI = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.03．Boss血条UI")
local _____6CE8_518CBoss_8840_6761UI = ____03_FF0EBoss_8840_6761UI["注册Boss血条UI"]
local _____6CE8_9500Boss_8840_6761UI = ____03_FF0EBoss_8840_6761UI["注销Boss血条UI"]
local ____04_FF0EBoss_5F31_70B9UI = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.04．Boss弱点UI")
local _____6CE8_518CBoss_5F31_70B9UI = ____04_FF0EBoss_5F31_70B9UI["注册Boss弱点UI"]
local _____6CE8_9500Boss_5F31_70B9UI = ____04_FF0EBoss_5F31_70B9UI["注销Boss弱点UI"]
local ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.05．Boss弱点运行状态")
local _____521B_5EFABoss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001["创建Boss血条弱点韧性运行状态"]
local _____6E05_7406Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001["清理Boss血条弱点韧性运行状态"]
local _____8BFB_53D6Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001["读取Boss血条弱点韧性运行状态"]
local ____06_FF0EBoss_5F31_70B9_4F24_5BB3_7ED3_7B97 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.06．Boss弱点伤害结算")
local _____6CE8_518CBoss_5F31_70B9_4F24_5BB3_7ED3_7B97 = ____06_FF0EBoss_5F31_70B9_4F24_5BB3_7ED3_7B97["注册Boss弱点伤害结算"]
local _____6CE8_9500Boss_5F31_70B9_4F24_5BB3_7ED3_7B97 = ____06_FF0EBoss_5F31_70B9_4F24_5BB3_7ED3_7B97["注销Boss弱点伤害结算"]
____exports["启动Boss血条弱点韧性"] = function(context)
    if context["是否已结束"] then
        return
    end
    local oldState = _____8BFB_53D6Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(context["Boss句柄ID"])
    if oldState ~= nil and not oldState["是否已结束"] then
        return
    end
    local state = _____521B_5EFABoss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(
        context,
        _____67E5_627EBoss_5F31_70B9_97E7_6027_914D_7F6E(context["Boss单位"])
    )
    _____6CE8_518CBoss_8840_6761UI(state)
    _____6CE8_518CBoss_5F31_70B9UI(state)
    _____6CE8_518CBoss_5F31_70B9_4F24_5BB3_7ED3_7B97(state)
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
