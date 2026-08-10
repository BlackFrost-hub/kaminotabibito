--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 装备采集 - 核心
-- 
-- 功能：监听配置表中定义的采集物品，丢弃/拾取后在指定区域延迟刷新。
-- 扩展：只需在配置表追加条目，无需改核心逻辑。
local jass = require("jass.common")
local ____require_result_0 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
local _____83B7_53D6_77E9_5F62_533A_57DF = ____require_result_0["获取矩形区域"]
local ____require_result_1 = require("系统.02．物品系统.17．装备采集.00．公共.01．配置表")
local _____91C7_96C6_914D_7F6E_5217_8868 = ____require_result_1["采集配置列表"]
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_2.onItemPickup
local onItemDrop = ____require_result_2.onItemDrop
local ____require_result_3 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_3["创建物品并注册排泄监听"]
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local GetItemTypeId = jass.GetItemTypeId
local GetRectMinX = jass.GetRectMinX
local GetRectMaxX = jass.GetRectMaxX
local GetRectMinY = jass.GetRectMinY
local GetRectMaxY = jass.GetRectMaxY
local GetRandomReal = jass.GetRandomReal
local function _____53D6_7269_54C1_7C7B_578BID(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return 0
    end
    return GetItemTypeId(_____7269_54C1)
end
local _____91C7_96C6_914D_7F6E_7D22_5F15_8868 = nil
local function _____6784_5EFA_914D_7F6E_7D22_5F15_8868()
    local _____8868 = {}
    do
        local i = 0
        while i < #_____91C7_96C6_914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____91C7_96C6_914D_7F6E_5217_8868[i + 1]
            if _____914D_7F6E["物品ID"] ~= 0 then
                _____8868[_____914D_7F6E["物品ID"]] = _____914D_7F6E
            end
            i = i + 1
        end
    end
    return _____8868
end
local function _____53D6_91C7_96C6_914D_7F6E(_____7269_54C1ID)
    if _____91C7_96C6_914D_7F6E_7D22_5F15_8868 == nil then
        _____91C7_96C6_914D_7F6E_7D22_5F15_8868 = _____6784_5EFA_914D_7F6E_7D22_5F15_8868()
    end
    return _____91C7_96C6_914D_7F6E_7D22_5F15_8868[_____7269_54C1ID]
end
local function _____83B7_53D6_533A_57DFrect(____rect_540D)
    return _____83B7_53D6_77E9_5F62_533A_57DF(____rect_540D)
end
local function _____5728_533A_57DF_968F_673A_4F4D_7F6E_5237_65B0_91C7_96C6_7269_54C1(_____7269_54C1ID, ____rect_540D)
    local rect = _____83B7_53D6_533A_57DFrect(____rect_540D)
    if rect == nil or rect == 0 then
        return
    end
    local minX = GetRectMinX(rect)
    local maxX = GetRectMaxX(rect)
    local minY = GetRectMinY(rect)
    local maxY = GetRectMaxY(rect)
    local x = GetRandomReal(minX, maxX)
    local y = GetRandomReal(minY, maxY)
    _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(_____7269_54C1ID, x, y)
end
local function _____5904_7406_91C7_96C6_7269_54C1_62FE_53D6(_____5355_4F4D, _____7269_54C1)
    local _____7269_54C1ID = _____53D6_7269_54C1_7C7B_578BID(_____7269_54C1)
    local _____914D_7F6E = _____53D6_91C7_96C6_914D_7F6E(_____7269_54C1ID)
    if _____914D_7F6E == nil then
        return
    end
    addDelayedCallback(
        _____914D_7F6E["刷新延迟秒"] * 1000,
        function() return _____5728_533A_57DF_968F_673A_4F4D_7F6E_5237_65B0_91C7_96C6_7269_54C1(_____7269_54C1ID, _____914D_7F6E["刷新区域名称"]) end
    )
end
local function _____5904_7406_91C7_96C6_7269_54C1_4E22_5F03(_____5355_4F4D, _____7269_54C1)
    local _____7269_54C1ID = _____53D6_7269_54C1_7C7B_578BID(_____7269_54C1)
    local _____914D_7F6E = _____53D6_91C7_96C6_914D_7F6E(_____7269_54C1ID)
    if _____914D_7F6E == nil then
        return
    end
    addDelayedCallback(
        _____914D_7F6E["刷新延迟秒"] * 1000,
        function() return _____5728_533A_57DF_968F_673A_4F4D_7F6E_5237_65B0_91C7_96C6_7269_54C1(_____7269_54C1ID, _____914D_7F6E["刷新区域名称"]) end
    )
end
____exports["初始化装备采集"] = function()
    if #_____91C7_96C6_914D_7F6E_5217_8868 == 0 then
        return
    end
    onItemPickup(_____5904_7406_91C7_96C6_7269_54C1_62FE_53D6)
    onItemDrop(_____5904_7406_91C7_96C6_7269_54C1_4E22_5F03)
end
____exports["初始化装备采集"]()
return ____exports
