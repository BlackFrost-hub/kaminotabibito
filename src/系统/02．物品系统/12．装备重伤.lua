--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
--- 装备重伤（wound）：不叠加，取当前装备中 wound 最大值
-- - 英雄单位：存储到玩家级 YDUserData
-- - 非英雄单位：存储到单位级 YDUserData
jass = require("jass.common")
itemEventCenter = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
itemsData = require("系统.02．物品系统.01．装备数据").default
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
fourCCToString = ____require_result_0.fourCCToString
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_2.debugLogForce
local ____require_result_3 = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
IsUnitIllusionBJ = ____require_result_3.IsUnitIllusionBJ
____ATTR__91CD_4F24 = "重伤"
_____6A21_5757_540D = "装备重伤"
function _____5199_5165YD_7528_6237_6570_636E(tableType, tableKey, attr, valueType, value)
    debugLogForce(
        _____6A21_5757_540D,
        "写入YD用户数据：tableType=",
        tableType,
        "tableKey=",
        tostring(tableKey),
        "attr=",
        attr,
        "valueType=",
        valueType,
        "value=",
        value
    )
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
                local item = jass.UnitItemInSlot(unit, slot)
                if not item then
                    goto __continue5
                end
                if ignoreItem and item == ignoreItem then
                    goto __continue5
                end
                local tid = jass.GetItemTypeId(item)
                local idStr = fourCCToString(nil, tid)
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
    local owner = jass.GetOwningPlayer(unit)
    local playerId = jass.GetPlayerId(owner)
    debugLogForce(
        _____6A21_5757_540D,
        "applyWound：unit=",
        tostring(unit),
        "owner=",
        tostring(owner),
        "playerId=",
        playerId,
        "newValue=",
        newValue
    )
    if playerId < 0 or playerId > 3 then
        return
    end
    if jass.IsUnitType(unit, jass.UNIT_TYPE_HERO) then
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
    if jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return
    end
    if IsUnitIllusionBJ(nil, unit) then
        return
    end
    local isDrop = not isPickup
    local newWound = isDrop and getMaxWound(unit, item) or getMaxWound(unit)
    debugLogForce(
        _____6A21_5757_540D,
        "onItemChange：unit=",
        tostring(unit),
        "item=",
        tostring(item),
        "isPickup=",
        isPickup,
        "newWound=",
        newWound
    )
    applyWound(unit, newWound)
end
function init()
    itemEventCenter:onItemPickup(function(unit, item)
        onItemChange(unit, item, true)
    end)
    itemEventCenter:onItemDrop(function(unit, item)
        onItemChange(unit, item, false)
    end)
end
init()
