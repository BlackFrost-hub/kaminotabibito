local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_0.onItemPickup
local onItemDrop = ____require_result_0.onItemDrop
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetItemTypeId = jass.GetItemTypeId
local UnitItemInSlot = jass.UnitItemInSlot
local _____6307_5B9A_7269_54C1_76D1_542C_5217_8868 = {}
local _____5355_4F4D_7269_54C1_6301_6709_6570_91CF_8868 = {}
local _____5DF2_521D_59CB_5316_83B7_53D6_4E22_5F03_76D1_542C = false
local function _____83B7_53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____83B7_53D6_5355_4F4D_6307_5B9A_7269_54C1_6301_6709_6570_91CF(unit, itemTypeId)
    if unit == nil or unit == 0 or itemTypeId == 0 then
        return 0
    end
    local count = 0
    do
        local slot = 0
        while slot < 6 do
            local item = UnitItemInSlot(unit, slot)
            if item ~= nil and item ~= 0 and GetItemTypeId(item) == itemTypeId then
                count = count + 1
            end
            slot = slot + 1
        end
    end
    return count
end
local function _____8BFB_53D6_7F13_5B58_6301_6709_6570_91CF(unit, itemTypeId)
    local unitId = _____83B7_53D6_5355_4F4DID(unit)
    if unitId == 0 then
        return -1
    end
    local ____opt_1 = _____5355_4F4D_7269_54C1_6301_6709_6570_91CF_8868[unitId]
    return ____opt_1 and ____opt_1[itemTypeId] or -1
end
local function _____5199_5165_7F13_5B58_6301_6709_6570_91CF(unit, itemTypeId, count)
    local unitId = _____83B7_53D6_5355_4F4DID(unit)
    if unitId == 0 then
        return
    end
    local unitState = _____5355_4F4D_7269_54C1_6301_6709_6570_91CF_8868[unitId] or ({})
    if count > 0 then
        unitState[itemTypeId] = count
        _____5355_4F4D_7269_54C1_6301_6709_6570_91CF_8868[unitId] = unitState
        return
    end
    __TS__Delete(unitState, itemTypeId)
    local hasAny = false
    for key in pairs(unitState) do
        if unitState[key] ~= nil then
            hasAny = true
            break
        end
    end
    if hasAny then
        _____5355_4F4D_7269_54C1_6301_6709_6570_91CF_8868[unitId] = unitState
    else
        __TS__Delete(_____5355_4F4D_7269_54C1_6301_6709_6570_91CF_8868, unitId)
    end
end
local function _____5206_53D1_6307_5B9A_7269_54C1_53D8_5316(unit, item, itemTypeId, currentCount, previousCount, isPickup)
    do
        local i = 0
        while i < #_____6307_5B9A_7269_54C1_76D1_542C_5217_8868 do
            do
                local listener = _____6307_5B9A_7269_54C1_76D1_542C_5217_8868[i + 1]
                if listener["物品类型ID"] ~= itemTypeId then
                    goto __continue21
                end
                if isPickup then
                    local ____opt_3 = listener["获取回调"]
                    if ____opt_3 ~= nil then
                        ____opt_3(unit, item, currentCount, previousCount)
                    end
                else
                    local ____opt_5 = listener["丢弃回调"]
                    if ____opt_5 ~= nil then
                        ____opt_5(unit, item, currentCount, previousCount)
                    end
                end
            end
            ::__continue21::
            i = i + 1
        end
    end
end
local function _____540C_6B65_5E76_5206_53D1_7269_54C1_53D8_5316(unit, item, isPickup)
    if unit == nil or unit == 0 or item == nil or item == 0 then
        return
    end
    local itemTypeId = GetItemTypeId(item)
    if itemTypeId == 0 then
        return
    end
    local currentCount = _____83B7_53D6_5355_4F4D_6307_5B9A_7269_54C1_6301_6709_6570_91CF(unit, itemTypeId)
    local previousCount = _____8BFB_53D6_7F13_5B58_6301_6709_6570_91CF(unit, itemTypeId)
    if previousCount < 0 then
        previousCount = isPickup and currentCount - 1 or currentCount + 1
        if previousCount < 0 then
            previousCount = 0
        end
    end
    _____5199_5165_7F13_5B58_6301_6709_6570_91CF(unit, itemTypeId, currentCount)
    if isPickup then
        if currentCount > previousCount then
            _____5206_53D1_6307_5B9A_7269_54C1_53D8_5316(
                unit,
                item,
                itemTypeId,
                currentCount,
                previousCount,
                true
            )
        end
        return
    end
    if currentCount < previousCount then
        _____5206_53D1_6307_5B9A_7269_54C1_53D8_5316(
            unit,
            item,
            itemTypeId,
            currentCount,
            previousCount,
            false
        )
    end
end
local function ____on_7269_54C1_83B7_53D6_76D1_542C(unit, item)
    _____540C_6B65_5E76_5206_53D1_7269_54C1_53D8_5316(unit, item, true)
end
local function ____on_7269_54C1_4E22_5F03_76D1_542C(unit, item)
    _____540C_6B65_5E76_5206_53D1_7269_54C1_53D8_5316(unit, item, false)
end
local function _____521D_59CB_5316_83B7_53D6_4E22_5F03_76D1_542C()
    if _____5DF2_521D_59CB_5316_83B7_53D6_4E22_5F03_76D1_542C then
        return
    end
    _____5DF2_521D_59CB_5316_83B7_53D6_4E22_5F03_76D1_542C = true
    onItemPickup(____on_7269_54C1_83B7_53D6_76D1_542C)
    onItemDrop(____on_7269_54C1_4E22_5F03_76D1_542C)
end
____exports["监听指定物品获取丢弃"] = function(itemTypeId, _____83B7_53D6_56DE_8C03, _____4E22_5F03_56DE_8C03)
    if itemTypeId == 0 then
        return
    end
    _____521D_59CB_5316_83B7_53D6_4E22_5F03_76D1_542C()
    _____6307_5B9A_7269_54C1_76D1_542C_5217_8868[#_____6307_5B9A_7269_54C1_76D1_542C_5217_8868 + 1] = {["物品类型ID"] = itemTypeId, ["获取回调"] = _____83B7_53D6_56DE_8C03, ["丢弃回调"] = _____4E22_5F03_56DE_8C03}
end
____exports["获取单位当前持有指定物品数量"] = function(unit, itemTypeId)
    local count = _____83B7_53D6_5355_4F4D_6307_5B9A_7269_54C1_6301_6709_6570_91CF(unit, itemTypeId)
    _____5199_5165_7F13_5B58_6301_6709_6570_91CF(unit, itemTypeId, count)
    return count
end
____exports["单位当前是否持有指定物品"] = function(unit, itemTypeId)
    return ____exports["获取单位当前持有指定物品数量"](unit, itemTypeId) > 0
end
return ____exports
