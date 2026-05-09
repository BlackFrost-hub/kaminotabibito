--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 背包切换功能
-- 
-- 按Ctrl键切换英雄背包与辅助背包
local jass = require("jass.common")
local japi = require("jass.japi")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local ____require_result_1 = require("lib.扩展函数.BJ函数.index")
local UnitItemInSlotBJ = ____require_result_1.UnitItemInSlotBJ
local ____require_result_2 = require("lib.扩展函数.BJ函数.index")
local UnitRemoveItemSwapped = ____require_result_2.UnitRemoveItemSwapped
local ____require_result_3 = require("lib.扩展函数.KK扩展API.index")
local DzTriggerRegisterKeyEventTrg = ____require_result_3.DzTriggerRegisterKeyEventTrg
--- 触发器
local switchBagTrigger = nil
--- 交换两个单位的物品
-- 
-- @param unit1 单位1
-- @param unit2 单位2
-- @param slot 物品栏位置（1-6）
local function swapItems(self, unit1, unit2, slot)
    local item1 = UnitItemInSlotBJ(nil, unit1, slot)
    local item2 = UnitItemInSlotBJ(nil, unit2, slot)
    if item1 ~= nil then
        UnitRemoveItemSwapped(nil, item1, unit1)
    end
    if item2 ~= nil then
        UnitRemoveItemSwapped(nil, item2, unit2)
    end
    if item1 ~= nil then
        jass:UnitAddItem(unit2, item1)
    end
    if item2 ~= nil then
        jass:UnitAddItem(unit1, item2)
    end
end
--- 按Ctrl切换背包事件处理
local function onCtrlSwitchBag(self)
    local player = japi:DzGetTriggerKeyPlayer()
    local hero = YDUserDataGet(
        nil,
        "player",
        player,
        "英雄",
        "unit"
    )
    if hero == nil then
        return
    end
    if not jass:IsUnitSelected(hero, player) then
        return
    end
    local helperUnit = YDUserDataGet(
        nil,
        "player",
        jass:GetOwningPlayer(hero),
        "切换背包辅助",
        "unit"
    )
    if helperUnit == nil then
        return
    end
    if g.udg_Itmeboolean ~= nil then
        g.udg_Itmeboolean = true
    end
    do
        local slot = 1
        while slot <= 6 do
            swapItems(nil, hero, helperUnit, slot)
            slot = slot + 1
        end
    end
    if g.udg_Itmeboolean ~= nil then
        g.udg_Itmeboolean = false
    end
end
--- 初始化背包切换功能
function ____exports.initSwitchBag(self)
    if switchBagTrigger ~= nil then
        return
    end
    switchBagTrigger = jass:CreateTrigger()
    DzTriggerRegisterKeyEventTrg(nil, switchBagTrigger, 0, 17)
    jass:TriggerAddAction(switchBagTrigger, onCtrlSwitchBag)
end
return ____exports
