--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local itemStack = require("lib.扩展函数.物品相关函数.物品叠加函数")
local CreateTrigger = jass.CreateTrigger
local TriggerAddAction = jass.TriggerAddAction
local StarItem_GetTriggerUnit = itemStack.StarItem_GetTriggerUnit
local StarItem_GetTriggerItem = itemStack.StarItem_GetTriggerItem
local StarItem_TryPickUpItem = itemStack.StarItem_TryPickUpItem
local _____5C1D_8BD5_62FE_53D6_7269_54C1_56DE_8C03_5217_8868 = {}
local _____5DF2_521D_59CB_5316_5C1D_8BD5_62FE_53D6_7269_54C1_4E2D_5FC3 = false
local function _____5206_53D1_5C1D_8BD5_62FE_53D6_7269_54C1()
    local unit = StarItem_GetTriggerUnit()
    local item = StarItem_GetTriggerItem()
    if unit == nil or unit == 0 or item == nil or item == 0 then
        return
    end
    do
        local i = 0
        while i < #_____5C1D_8BD5_62FE_53D6_7269_54C1_56DE_8C03_5217_8868 do
            do
                local callback = _____5C1D_8BD5_62FE_53D6_7269_54C1_56DE_8C03_5217_8868[i + 1]
                if callback == nil then
                    goto __continue5
                end
                callback(unit, item)
            end
            ::__continue5::
            i = i + 1
        end
    end
end
local function _____521D_59CB_5316_5C1D_8BD5_62FE_53D6_7269_54C1_4E2D_5FC3()
    if _____5DF2_521D_59CB_5316_5C1D_8BD5_62FE_53D6_7269_54C1_4E2D_5FC3 then
        return
    end
    _____5DF2_521D_59CB_5316_5C1D_8BD5_62FE_53D6_7269_54C1_4E2D_5FC3 = true
    local trigger = CreateTrigger()
    TriggerAddAction(trigger, _____5206_53D1_5C1D_8BD5_62FE_53D6_7269_54C1)
    StarItem_TryPickUpItem(trigger)
end
function ____exports.onTryPickupItem(callback)
    _____521D_59CB_5316_5C1D_8BD5_62FE_53D6_7269_54C1_4E2D_5FC3()
    _____5C1D_8BD5_62FE_53D6_7269_54C1_56DE_8C03_5217_8868[#_____5C1D_8BD5_62FE_53D6_7269_54C1_56DE_8C03_5217_8868 + 1] = callback
    return #_____5C1D_8BD5_62FE_53D6_7269_54C1_56DE_8C03_5217_8868 - 1
end
function ____exports.offTryPickupItem(id)
    if id < 0 or id >= #_____5C1D_8BD5_62FE_53D6_7269_54C1_56DE_8C03_5217_8868 then
        return
    end
    _____5C1D_8BD5_62FE_53D6_7269_54C1_56DE_8C03_5217_8868[id + 1] = nil
end
return ____exports
