--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 背包切换功能
-- 
-- 按Ctrl键切换英雄背包与辅助背包
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("lib.扩展函数.BJ函数.index")
local UnitItemInSlotBJ = ____require_result_1.UnitItemInSlotBJ
local ____require_result_2 = require("lib.扩展函数.BJ函数.index")
local UnitRemoveItemSwapped = ____require_result_2.UnitRemoveItemSwapped
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____5355_4F4D_662F_5426_6682_505C = ____require_result_3["单位是否暂停"]
local ____require_result_4 = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心")
local registerSyncHardwareKey = ____require_result_4.registerSyncHardwareKey
local ____require_result_5 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY_STATE = ____require_result_5.KEY_STATE
local DzGetTriggerKeyPlayer = require("jass.japi").DzGetTriggerKeyPlayer
local ____require_result_6 = require("系统.02．物品系统.11．装备系统")
local beginEquipItemMessageSilence = ____require_result_6.beginEquipItemMessageSilence
local endEquipItemMessageSilence = ____require_result_6.endEquipItemMessageSilence
local UnitAddItem = jass.UnitAddItem
local GetItemTypeId = jass.GetItemTypeId
local IsUnitSelected = jass.IsUnitSelected
local IsUnitPaused = jass.IsUnitPaused
local GetOwningPlayer = jass.GetOwningPlayer
local RemoveItem = jass.RemoveItem
local ____Ctrl_952E_7801 = 17
--- 触发器
local switchBagTrigger = nil
--- 交换两个单位的物品
-- 
-- @param unit1 单位1
-- @param unit2 单位2
-- @param slot 物品栏位置（1-6）
local function swapItems(unit1, unit2, slot)
    local item1 = UnitItemInSlotBJ(unit1, slot)
    local item2 = UnitItemInSlotBJ(unit2, slot)
    if item1 ~= nil then
        UnitRemoveItemSwapped(item1, unit1)
    end
    if item2 ~= nil then
        UnitRemoveItemSwapped(item2, unit2)
    end
    if item1 ~= nil then
        UnitAddItem(unit2, item1)
    end
    if item2 ~= nil then
        UnitAddItem(unit1, item2)
    end
end
--- 在单个单位的六个物品栏中查找指定 Raw ID 的物品。
local function _____67E5_627E_5355_4F4D_80CC_5305_7269_54C1(unit, itemTypeId)
    if unit == nil or unit == 0 or not (itemTypeId > 0) then
        return nil
    end
    do
        local slot = 1
        while slot <= 6 do
            local item = UnitItemInSlotBJ(unit, slot)
            if item ~= nil and item ~= 0 and GetItemTypeId(item) == itemTypeId then
                return item
            end
            slot = slot + 1
        end
    end
    return nil
end
--- 获取英雄对应的副背包马甲；与 Ctrl 切包使用同一份玩家数据。
local function _____83B7_53D6_526F_80CC_5305_9A6C_7532(hero)
    if hero == nil or hero == 0 then
        return nil
    end
    return YDUserDataGetSafe(
        "player",
        GetOwningPlayer(hero),
        "切换背包辅助",
        "unit"
    )
end
--- 在英雄主背包与副背包马甲的 12 个格子中查找指定物品。
-- 剧情物品交付、入口校验均应使用此函数，避免 Ctrl 切包后被误判为未携带。
____exports["查找玩家主副背包物品"] = function(hero, itemTypeId)
    local _____4E3B_80CC_5305_7269_54C1 = _____67E5_627E_5355_4F4D_80CC_5305_7269_54C1(hero, itemTypeId)
    if _____4E3B_80CC_5305_7269_54C1 ~= nil and _____4E3B_80CC_5305_7269_54C1 ~= 0 then
        return _____4E3B_80CC_5305_7269_54C1
    end
    local _____526F_80CC_5305_9A6C_7532 = _____83B7_53D6_526F_80CC_5305_9A6C_7532(hero)
    if _____526F_80CC_5305_9A6C_7532 == nil or _____526F_80CC_5305_9A6C_7532 == 0 or _____526F_80CC_5305_9A6C_7532 == hero then
        return nil
    end
    return _____67E5_627E_5355_4F4D_80CC_5305_7269_54C1(_____526F_80CC_5305_9A6C_7532, itemTypeId)
end
--- 检查英雄主背包与副背包马甲的 12 个格子是否持有指定物品。
____exports["玩家主副背包持有物品"] = function(hero, itemTypeId)
    local item = ____exports["查找玩家主副背包物品"](hero, itemTypeId)
    return item ~= nil and item ~= 0
end
--- 从英雄主背包或副背包马甲中移除一件指定物品。
____exports["移除玩家主副背包物品"] = function(hero, itemTypeId)
    local item = ____exports["查找玩家主副背包物品"](hero, itemTypeId)
    if item == nil or item == 0 then
        return false
    end
    RemoveItem(item)
    return true
end
--- 按Ctrl切换背包事件处理
local function onCtrlSwitchBag(event)
    local player = event.player or DzGetTriggerKeyPlayer()
    if player == nil or player == 0 then
        return
    end
    local hero = YDUserDataGetSafe("player", player, "英雄", "unit")
    if hero == nil or hero == 0 then
        return
    end
    if _____5355_4F4D_662F_5426_6682_505C(hero) or IsUnitPaused(hero) then
        return
    end
    local isHeroSelected = IsUnitSelected(hero, player)
    if not isHeroSelected then
        return
    end
    local heroOwner = GetOwningPlayer(hero)
    local helperUnit = YDUserDataGetSafe("player", heroOwner, "切换背包辅助", "unit")
    if helperUnit == nil or helperUnit == 0 then
        return
    end
    if g.udg_Itmeboolean ~= nil then
        g.udg_Itmeboolean = true
    end
    beginEquipItemMessageSilence()
    do
        local slot = 1
        while slot <= 6 do
            swapItems(hero, helperUnit, slot)
            slot = slot + 1
        end
    end
    endEquipItemMessageSilence()
    if g.udg_Itmeboolean ~= nil then
        g.udg_Itmeboolean = false
    end
end
--- 初始化背包切换功能
function ____exports.initSwitchBag()
    if switchBagTrigger ~= nil then
        return
    end
    switchBagTrigger = registerSyncHardwareKey(____Ctrl_952E_7801, KEY_STATE.UP, onCtrlSwitchBag)
end
return ____exports
