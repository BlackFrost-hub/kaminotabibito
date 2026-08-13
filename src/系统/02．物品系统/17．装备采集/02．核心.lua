local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____6784_5EFA_91C7_96C6_914D_7F6E_7D22_5F15_8868, _____83B7_53D6_91C7_96C6_914D_7F6E, _____5220_9664_91C7_96C6_7269_54C1_8BB0_5F55, _____53D6_6D88_91C7_96C6_7269_54C1_5237_65B0_4EFB_52A1, _____83B7_53D6_533A_57DF_968F_673A_5750_6807, _____751F_6210_91C7_96C6_7269_54C1_8BB0_5F55, _____521B_5EFA_5E76_767B_8BB0_91C7_96C6_7269_54C1, ____on_91C7_96C6_7269_54C1_5237_65B0_5230_671F, _____83B7_53D6_77E9_5F62_533A_57DF, _____91C7_96C6_914D_7F6E_5217_8868, _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C, removeDelayedCallback, getServerTime, GetHandleId, GetRectMinX, GetRectMaxX, GetRectMinY, GetRectMaxY, GetRandomReal, _____91C7_96C6_914D_7F6E_7D22_5F15_8868, _____91C7_96C6_7269_54C1_8BB0_5F55_8868, _____91C7_96C6_7269_54C1_8BB0_5F55_5217_8868
function _____6784_5EFA_91C7_96C6_914D_7F6E_7D22_5F15_8868()
    local _____7D22_5F15_8868 = {}
    do
        local i = 0
        while i < #_____91C7_96C6_914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____91C7_96C6_914D_7F6E_5217_8868[i + 1]
            if _____914D_7F6E["物品ID"] > 0 then
                _____7D22_5F15_8868[_____914D_7F6E["物品ID"]] = _____914D_7F6E
            end
            i = i + 1
        end
    end
    return _____7D22_5F15_8868
end
function _____83B7_53D6_91C7_96C6_914D_7F6E(_____7269_54C1_7C7B_578BID)
    if _____91C7_96C6_914D_7F6E_7D22_5F15_8868 == nil then
        _____91C7_96C6_914D_7F6E_7D22_5F15_8868 = _____6784_5EFA_91C7_96C6_914D_7F6E_7D22_5F15_8868()
    end
    return _____91C7_96C6_914D_7F6E_7D22_5F15_8868[_____7269_54C1_7C7B_578BID]
end
function _____5220_9664_91C7_96C6_7269_54C1_8BB0_5F55(_____8BB0_5F55)
    local _____53E5_67C4ID = GetHandleId(_____8BB0_5F55["物品"])
    if _____53E5_67C4ID > 0 and _____91C7_96C6_7269_54C1_8BB0_5F55_8868[_____53E5_67C4ID] == _____8BB0_5F55 then
        __TS__Delete(_____91C7_96C6_7269_54C1_8BB0_5F55_8868, _____53E5_67C4ID)
    end
    do
        local i = 0
        while i < #_____91C7_96C6_7269_54C1_8BB0_5F55_5217_8868 do
            do
                if _____91C7_96C6_7269_54C1_8BB0_5F55_5217_8868[i + 1] ~= _____8BB0_5F55 then
                    goto __continue14
                end
                __TS__ArraySplice(_____91C7_96C6_7269_54C1_8BB0_5F55_5217_8868, i, 1)
                return
            end
            ::__continue14::
            i = i + 1
        end
    end
end
function _____53D6_6D88_91C7_96C6_7269_54C1_5237_65B0_4EFB_52A1(_____8BB0_5F55)
    if _____8BB0_5F55["刷新任务ID"] == nil then
        return
    end
    removeDelayedCallback(_____8BB0_5F55["刷新任务ID"])
    _____8BB0_5F55["刷新任务ID"] = nil
end
function _____83B7_53D6_533A_57DF_968F_673A_5750_6807(_____533A_57DF_540D_79F0)
    local _____533A_57DF = _____83B7_53D6_77E9_5F62_533A_57DF(_____533A_57DF_540D_79F0)
    if _____533A_57DF == nil or _____533A_57DF == 0 then
        return nil
    end
    return {
        X = GetRandomReal(
            GetRectMinX(_____533A_57DF),
            GetRectMaxX(_____533A_57DF)
        ),
        Y = GetRandomReal(
            GetRectMinY(_____533A_57DF),
            GetRectMaxY(_____533A_57DF)
        )
    }
end
function _____751F_6210_91C7_96C6_7269_54C1_8BB0_5F55(_____7269_54C1, _____7269_54C1_7C7B_578BID, _____5237_65B0_533A_57DF_540D_79F0)
    local _____914D_7F6E = _____83B7_53D6_91C7_96C6_914D_7F6E(_____7269_54C1_7C7B_578BID)
    if _____914D_7F6E == nil or _____7269_54C1 == nil or _____7269_54C1 == 0 or _____5237_65B0_533A_57DF_540D_79F0 == "" then
        return nil
    end
    local _____91C7_6458_5237_65B0_5EF6_8FDF_6BEB_79D2 = _____914D_7F6E["采摘刷新延迟秒"] > 0 and _____914D_7F6E["采摘刷新延迟秒"] * 1000 or 0
    local _____968F_673A_6362_70B9_95F4_9694_6BEB_79D2 = _____914D_7F6E["随机换点间隔秒"] > 0 and _____914D_7F6E["随机换点间隔秒"] * 1000 or 0
    return {
        ["物品"] = _____7269_54C1,
        ["物品类型ID"] = _____7269_54C1_7C7B_578BID,
        ["刷新区域名称"] = _____5237_65B0_533A_57DF_540D_79F0,
        ["采摘刷新延迟毫秒"] = _____91C7_6458_5237_65B0_5EF6_8FDF_6BEB_79D2,
        ["随机换点间隔毫秒"] = _____968F_673A_6362_70B9_95F4_9694_6BEB_79D2,
        ["状态"] = "地面",
        ["下次随机换点时间"] = getServerTime() + _____968F_673A_6362_70B9_95F4_9694_6BEB_79D2
    }
end
--- 创建方在物品落地后调用；区域由创建方提供，因此同一物品 ID 可跨多个区域复用。
____exports["登记采集物品实例"] = function(_____7269_54C1, _____7269_54C1_7C7B_578BID, _____5237_65B0_533A_57DF_540D_79F0)
    local _____65B0_8BB0_5F55 = _____751F_6210_91C7_96C6_7269_54C1_8BB0_5F55(_____7269_54C1, _____7269_54C1_7C7B_578BID, _____5237_65B0_533A_57DF_540D_79F0)
    if _____65B0_8BB0_5F55 == nil then
        return false
    end
    local _____53E5_67C4ID = GetHandleId(_____7269_54C1)
    local _____65E7_8BB0_5F55 = _____91C7_96C6_7269_54C1_8BB0_5F55_8868[_____53E5_67C4ID]
    if _____65E7_8BB0_5F55 ~= nil then
        _____53D6_6D88_91C7_96C6_7269_54C1_5237_65B0_4EFB_52A1(_____65E7_8BB0_5F55)
        _____5220_9664_91C7_96C6_7269_54C1_8BB0_5F55(_____65E7_8BB0_5F55)
    end
    _____91C7_96C6_7269_54C1_8BB0_5F55_8868[_____53E5_67C4ID] = _____65B0_8BB0_5F55
    _____91C7_96C6_7269_54C1_8BB0_5F55_5217_8868[#_____91C7_96C6_7269_54C1_8BB0_5F55_5217_8868 + 1] = _____65B0_8BB0_5F55
    return true
end
function _____521B_5EFA_5E76_767B_8BB0_91C7_96C6_7269_54C1(_____7269_54C1_7C7B_578BID, _____5237_65B0_533A_57DF_540D_79F0)
    local _____5750_6807 = _____83B7_53D6_533A_57DF_968F_673A_5750_6807(_____5237_65B0_533A_57DF_540D_79F0)
    if _____5750_6807 == nil then
        return nil
    end
    local _____7269_54C1 = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(_____7269_54C1_7C7B_578BID, _____5750_6807.X, _____5750_6807.Y)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return nil
    end
    ____exports["登记采集物品实例"](_____7269_54C1, _____7269_54C1_7C7B_578BID, _____5237_65B0_533A_57DF_540D_79F0)
    return _____7269_54C1
end
function ____on_91C7_96C6_7269_54C1_5237_65B0_5230_671F(_____53D8_91CF)
    local _____8BB0_5F55 = _____53D8_91CF
    if _____8BB0_5F55 == nil or _____8BB0_5F55["状态"] ~= "携带" then
        return
    end
    _____8BB0_5F55["刷新任务ID"] = nil
    local _____7269_54C1_7C7B_578BID = _____8BB0_5F55["物品类型ID"]
    local _____5237_65B0_533A_57DF_540D_79F0 = _____8BB0_5F55["刷新区域名称"]
    _____5220_9664_91C7_96C6_7269_54C1_8BB0_5F55(_____8BB0_5F55)
    _____521B_5EFA_5E76_767B_8BB0_91C7_96C6_7269_54C1(_____7269_54C1_7C7B_578BID, _____5237_65B0_533A_57DF_540D_79F0)
end
--- 装备采集 - 通用运行时
-- 
-- 采集物品由创建方登记“物品实例 + 刷新区域”，本模块只负责：
-- - 被采摘后按配置延迟，在原区域随机位置补回一份；
-- - 地面上的采集物品按配置周期随机换点；
-- - 同一物品 ID 可以同时存在于多个区域，不再依赖物品 ID 反查唯一区域。
local jass = require("jass.common")
local ____require_result_0 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
_____83B7_53D6_77E9_5F62_533A_57DF = ____require_result_0["获取矩形区域"]
local ____require_result_1 = require("系统.02．物品系统.17．装备采集.00．公共.01．配置表")
_____91C7_96C6_914D_7F6E_5217_8868 = ____require_result_1["采集配置列表"]
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_2.onItemPickup
local onItemDrop = ____require_result_2.onItemDrop
local ____require_result_3 = require("lib.扩展函数.物品相关函数.创建物品函数")
_____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_3["创建物品并注册排泄监听"]
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
removeDelayedCallback = ____require_result_4.removeDelayedCallback
local addPeriodicCallback = ____require_result_4.addPeriodicCallback
getServerTime = ____require_result_4.getServerTime
GetHandleId = jass.GetHandleId
GetRectMinX = jass.GetRectMinX
GetRectMaxX = jass.GetRectMaxX
GetRectMinY = jass.GetRectMinY
GetRectMaxY = jass.GetRectMaxY
GetRandomReal = jass.GetRandomReal
local SetItemPosition = jass.SetItemPosition
local GetItemTypeId = jass.GetItemTypeId
_____91C7_96C6_7269_54C1_8BB0_5F55_8868 = {}
_____91C7_96C6_7269_54C1_8BB0_5F55_5217_8868 = {}
local _____5DF2_521D_59CB_5316_88C5_5907_91C7_96C6 = false
local function _____83B7_53D6_91C7_96C6_7269_54C1_8BB0_5F55(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return nil
    end
    local _____53E5_67C4ID = GetHandleId(_____7269_54C1)
    if _____53E5_67C4ID <= 0 then
        return nil
    end
    return _____91C7_96C6_7269_54C1_8BB0_5F55_8868[_____53E5_67C4ID]
end
local function _____5904_7406_91C7_96C6_7269_54C1_62FE_53D6(______5355_4F4D, _____7269_54C1)
    local _____8BB0_5F55 = _____83B7_53D6_91C7_96C6_7269_54C1_8BB0_5F55(_____7269_54C1)
    if _____8BB0_5F55 == nil then
        return
    end
    _____53D6_6D88_91C7_96C6_7269_54C1_5237_65B0_4EFB_52A1(_____8BB0_5F55)
    _____8BB0_5F55["状态"] = "携带"
    _____8BB0_5F55["刷新任务ID"] = addDelayedCallback(_____8BB0_5F55["采摘刷新延迟毫秒"], ____on_91C7_96C6_7269_54C1_5237_65B0_5230_671F, _____8BB0_5F55)
end
local function _____5904_7406_91C7_96C6_7269_54C1_4E22_5F03(______5355_4F4D, _____7269_54C1)
    local _____8BB0_5F55 = _____83B7_53D6_91C7_96C6_7269_54C1_8BB0_5F55(_____7269_54C1)
    if _____8BB0_5F55 == nil or _____8BB0_5F55["状态"] ~= "携带" then
        return
    end
    _____53D6_6D88_91C7_96C6_7269_54C1_5237_65B0_4EFB_52A1(_____8BB0_5F55)
    _____8BB0_5F55["状态"] = "地面"
    _____8BB0_5F55["下次随机换点时间"] = getServerTime() + _____8BB0_5F55["随机换点间隔毫秒"]
end
local function ____on_91C7_96C6_7269_54C1_968F_673A_6362_70B9Tick()
    local _____5F53_524D_65F6_95F4 = getServerTime()
    do
        local i = 0
        while i < #_____91C7_96C6_7269_54C1_8BB0_5F55_5217_8868 do
            do
                local _____8BB0_5F55 = _____91C7_96C6_7269_54C1_8BB0_5F55_5217_8868[i + 1]
                if _____8BB0_5F55["状态"] ~= "地面" or _____8BB0_5F55["随机换点间隔毫秒"] <= 0 or _____5F53_524D_65F6_95F4 < _____8BB0_5F55["下次随机换点时间"] then
                    goto __continue36
                end
                local _____5750_6807 = _____83B7_53D6_533A_57DF_968F_673A_5750_6807(_____8BB0_5F55["刷新区域名称"])
                if _____5750_6807 ~= nil then
                    SetItemPosition(_____8BB0_5F55["物品"], _____5750_6807.X, _____5750_6807.Y)
                end
                _____8BB0_5F55["下次随机换点时间"] = _____5F53_524D_65F6_95F4 + _____8BB0_5F55["随机换点间隔毫秒"]
            end
            ::__continue36::
            i = i + 1
        end
    end
end
____exports["初始化装备采集"] = function()
    if _____5DF2_521D_59CB_5316_88C5_5907_91C7_96C6 or #_____91C7_96C6_914D_7F6E_5217_8868 <= 0 then
        return
    end
    _____5DF2_521D_59CB_5316_88C5_5907_91C7_96C6 = true
    onItemPickup(_____5904_7406_91C7_96C6_7269_54C1_62FE_53D6)
    onItemDrop(_____5904_7406_91C7_96C6_7269_54C1_4E22_5F03)
    addPeriodicCallback(1000, ____on_91C7_96C6_7269_54C1_968F_673A_6362_70B9Tick)
end
____exports["初始化装备采集"]()
return ____exports
