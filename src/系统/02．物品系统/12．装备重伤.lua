--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
--- 装备重伤（wound）：不叠加，取当前装备中 wound 最大值
-- - 英雄单位：存储到玩家级 YDUserData
-- - 非英雄单位：存储到单位级 YDUserData
jass = require("jass.common")
GetItemTypeId = jass.GetItemTypeId
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
onItemPickup = ____require_result_0.onItemPickup
onItemDrop = ____require_result_0.onItemDrop
itemsData = require("系统.02．物品系统.01．装备数据").default
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.index")
fourCCToString = ____require_result_1.fourCCToString
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataSetSafe = ____require_result_2.YDUserDataSetSafe
local ____require_result_3 = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
IsUnitIllusionBJ = ____require_result_3.IsUnitIllusionBJ
____ATTR__91CD_4F24 = "重伤"
function _____5199_5165YD_7528_6237_6570_636E(tableType, tableKey, attr, valueType, value)
    YDUserDataSetSafe(
        tableType,
        tableKey,
        attr,
        valueType,
        value
    )
end
function getMaxWound(unit, ignoreItem)
    local max = 0
    do
        local slot = 0
        while slot <= 5 do
            do
                local item = jass:UnitItemInSlot(unit, slot)
                if not item then
                    goto __continue5
                end
                if ignoreItem and item == ignoreItem then
                    goto __continue5
                end
                local tid = GetItemTypeId(item)
                local idStr = fourCCToString(tid)
                local entry = itemsData[idStr]
                local typ = entry and entry.type
                if typ == "任务" or typ == "药剂" or typ == "食品" then
                    goto __continue5
                end
                local v = entry and entry.wound
                if type(v) == "number" and v > max then
                    max = v
                end
            end
            ::__continue5::
            slot = slot + 1
        end
    end
    return max
end
function applyWound(unit, newValue)
    local owner = jass:GetOwningPlayer(unit)
    local playerId = jass:GetPlayerId(owner)
    if playerId < 0 or playerId > 3 then
        return
    end
    if jass:IsUnitType(unit, jass.UNIT_TYPE_HERO) then
        _____5199_5165YD_7528_6237_6570_636E(
            "player",
            owner,
            ____ATTR__91CD_4F24,
            "real",
            newValue
        )
    else
        _____5199_5165YD_7528_6237_6570_636E(
            "unit",
            unit,
            ____ATTR__91CD_4F24,
            "real",
            newValue
        )
    end
end
function onItemChange(unit, item, isPickup)
    if unit == nil or unit == 0 then
        return
    end
    if jass:IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return
    end
    if IsUnitIllusionBJ(nil, unit) then
        return
    end
    local isDrop = not isPickup
    local newWound = isDrop and getMaxWound(unit, item) or getMaxWound(unit)
    applyWound(unit, newWound)
end
function init()
    onItemPickup(function(unit, item)
        onItemChange(unit, item, true)
    end)
    onItemDrop(function(unit, item)
        onItemChange(unit, item, false)
    end)
end
init()
