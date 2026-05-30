--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668.addPeriodicCallback
local removePeriodicCallback = ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668.removePeriodicCallback
local ____01_FF0E_80CC_666F_6846_521B_5EFA = require("系统.09．表现系统.11．背景框.01．背景框创建")
local _____521B_5EFA_80CC_666F_6846 = ____01_FF0E_80CC_666F_6846_521B_5EFA["创建背景框"]
local _____8BBE_7F6E_6BB5_843D_6587_5B57 = ____01_FF0E_80CC_666F_6846_521B_5EFA["设置段落文字"]
local _____8BBE_7F6E_80CC_666F_6846_900F_660E_5EA6 = ____01_FF0E_80CC_666F_6846_521B_5EFA["设置背景框透明度"]
local _____663E_793A_80CC_666F_6846 = ____01_FF0E_80CC_666F_6846_521B_5EFA["显示背景框"]
local _____9690_85CF_80CC_666F_6846 = ____01_FF0E_80CC_666F_6846_521B_5EFA["隐藏背景框"]
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.11．背景框.00．常量定义")
local _____5F02_754C_6BB5_843D_6587_5B57 = ____00_FF0E_5E38_91CF_5B9A_4E49["异界段落文字"]
local _____5F02_754C_7B2C_4E8C_53E5_968F_673A = ____00_FF0E_5E38_91CF_5B9A_4E49["异界第二句随机"]
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
local registerStesListener = ____require_result_0.registerStesListener
local ydlStes_syncTriggerStep = ____require_result_0.ydlStes_syncTriggerStep
local ydlStes_finishChildCleanup = ____require_result_0.ydlStes_finishChildCleanup
local GetRandomInt = jass.GetRandomInt
local R2I = jass.R2I
local _____5F02_754C_6BB5_843D_6570_91CF = 4
local _____6587_5B57_95F4_9694_6BEB_79D2 = 1660
local _____6DE1_51FA_95F4_9694_6BEB_79D2 = 30
local _____6DE1_51FA_603B_5E27_6570 = 100
local _____6700_5927_900F_660E_5EA6 = 255
local _____80CC_666F_5E27_7EC4 = nil
local _____6587_5B57tick_8FDB_5EA6 = 0
local _____6DE1_51FAtick_8FDB_5EA6 = 0
local _____6587_5B57_5B9A_65F6_5668ID = 0
local _____6DE1_51FA_5B9A_65F6_5668ID = 0
local function _____6E05_9664_6587_5B57_5B9A_65F6_5668()
    if _____6587_5B57_5B9A_65F6_5668ID ~= 0 then
        removePeriodicCallback(_____6587_5B57_5B9A_65F6_5668ID)
        _____6587_5B57_5B9A_65F6_5668ID = 0
    end
end
local function _____6E05_9664_6DE1_51FA_5B9A_65F6_5668()
    if _____6DE1_51FA_5B9A_65F6_5668ID ~= 0 then
        removePeriodicCallback(_____6DE1_51FA_5B9A_65F6_5668ID)
        _____6DE1_51FA_5B9A_65F6_5668ID = 0
    end
end
local function _____5F02_754C_80CC_666F_6846_6DE1_51FATick()
    _____6DE1_51FAtick_8FDB_5EA6 = _____6DE1_51FAtick_8FDB_5EA6 + 1
    if _____6DE1_51FAtick_8FDB_5EA6 >= _____6DE1_51FA_603B_5E27_6570 then
        if _____80CC_666F_5E27_7EC4 ~= nil then
            _____9690_85CF_80CC_666F_6846(_____80CC_666F_5E27_7EC4)
        end
        _____6E05_9664_6DE1_51FA_5B9A_65F6_5668()
        return
    end
    if _____80CC_666F_5E27_7EC4 ~= nil then
        local alpha = R2I(_____6700_5927_900F_660E_5EA6 * (1 - 0.01 * _____6DE1_51FAtick_8FDB_5EA6))
        _____8BBE_7F6E_80CC_666F_6846_900F_660E_5EA6(_____80CC_666F_5E27_7EC4, alpha)
    end
end
local function _____5F02_754C_80CC_666F_6846_6587_5B57Tick()
    _____6587_5B57tick_8FDB_5EA6 = _____6587_5B57tick_8FDB_5EA6 + 1
    if _____6587_5B57tick_8FDB_5EA6 > 4 then
        _____6E05_9664_6587_5B57_5B9A_65F6_5668()
        _____6DE1_51FAtick_8FDB_5EA6 = 0
        _____6DE1_51FA_5B9A_65F6_5668ID = addPeriodicCallback(_____6DE1_51FA_95F4_9694_6BEB_79D2, _____5F02_754C_80CC_666F_6846_6DE1_51FATick)
        return
    end
    if _____80CC_666F_5E27_7EC4 == nil then
        return
    end
    local _____6BB5_843D_7D22_5F15 = _____6587_5B57tick_8FDB_5EA6 - 1
    if _____6BB5_843D_7D22_5F15 < 0 or _____6BB5_843D_7D22_5F15 >= _____5F02_754C_6BB5_843D_6570_91CF then
        return
    end
    if _____6587_5B57tick_8FDB_5EA6 == 2 then
        local _____968F_673A_7D22_5F15 = GetRandomInt(0, #_____5F02_754C_7B2C_4E8C_53E5_968F_673A - 1)
        _____8BBE_7F6E_6BB5_843D_6587_5B57(_____80CC_666F_5E27_7EC4, _____6BB5_843D_7D22_5F15, _____5F02_754C_7B2C_4E8C_53E5_968F_673A[_____968F_673A_7D22_5F15 + 1])
    else
        _____8BBE_7F6E_6BB5_843D_6587_5B57(_____80CC_666F_5E27_7EC4, _____6BB5_843D_7D22_5F15, _____5F02_754C_6BB5_843D_6587_5B57[_____6BB5_843D_7D22_5F15 + 1])
    end
end
local function _____91CD_7F6E_72B6_6001()
    _____6E05_9664_6587_5B57_5B9A_65F6_5668()
    _____6E05_9664_6DE1_51FA_5B9A_65F6_5668()
    _____6587_5B57tick_8FDB_5EA6 = 0
    _____6DE1_51FAtick_8FDB_5EA6 = 0
end
local function ____on_5F02_754CBoss_80CC_666F_6846_89E6_53D1()
    ydlStes_syncTriggerStep(nil)
    _____91CD_7F6E_72B6_6001()
    if _____80CC_666F_5E27_7EC4 == nil then
        local _____914D_7F6E = {["段落数量"] = _____5F02_754C_6BB5_843D_6570_91CF}
        _____80CC_666F_5E27_7EC4 = _____521B_5EFA_80CC_666F_6846(_____914D_7F6E)
    end
    if _____80CC_666F_5E27_7EC4 == nil then
        ydlStes_finishChildCleanup(nil)
        return
    end
    _____8BBE_7F6E_80CC_666F_6846_900F_660E_5EA6(_____80CC_666F_5E27_7EC4, _____6700_5927_900F_660E_5EA6)
    _____663E_793A_80CC_666F_6846(_____80CC_666F_5E27_7EC4)
    do
        local i = 0
        while i < _____5F02_754C_6BB5_843D_6570_91CF do
            _____8BBE_7F6E_6BB5_843D_6587_5B57(_____80CC_666F_5E27_7EC4, i, "")
            i = i + 1
        end
    end
    _____6587_5B57_5B9A_65F6_5668ID = addPeriodicCallback(_____6587_5B57_95F4_9694_6BEB_79D2, _____5F02_754C_80CC_666F_6846_6587_5B57Tick)
    ydlStes_finishChildCleanup(nil)
end
____exports["init异界背景框"] = function()
    registerStesListener("异界Boss背景框", ____on_5F02_754CBoss_80CC_666F_6846_89E6_53D1)
end
return ____exports
