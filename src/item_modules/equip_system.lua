local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local ____exports = {}
_G.print("【调试】equip_system 开始加载")
local jass = require("jass.common")
local g = require("jass.globals")
local items = require("item_modules.equip_data").default
local function fourCCToString(self, fourcc)
    local c1 = string.char(fourcc % 256)
    local c2 = string.char(math.floor(fourcc / 256) % 256)
    local c3 = string.char(math.floor(fourcc / 65536) % 256)
    local c4 = string.char(math.floor(fourcc / 16777216) % 256)
    return ((c4 .. c3) .. c2) .. c1
end
local percentNames = {
    "暴击率",
    "暴击伤害",
    "命中率",
    "护甲穿透",
    "魔法穿透",
    "技能伤害",
    "闪避率",
    "魔抗",
    "冷却缩减",
    "伤害吸血",
    "魔法伤害吸血",
    "普通攻击吸血",
    "攻速",
    "移速"
}
local function initEvents(self)
    local trig = jass.CreateTrigger()
    do
        local i = 0
        while i <= 7 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                jass.EVENT_PLAYER_UNIT_PICKUP_ITEM,
                nil
            )
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                jass.EVENT_PLAYER_UNIT_DROP_ITEM,
                nil
            )
            i = i + 1
        end
    end
    jass.TriggerRegisterPlayerUnitEvent(
        trig,
        jass.Player(12),
        jass.EVENT_PLAYER_UNIT_PICKUP_ITEM,
        nil
    )
    jass.TriggerRegisterPlayerUnitEvent(
        trig,
        jass.Player(12),
        jass.EVENT_PLAYER_UNIT_DROP_ITEM,
        nil
    )
    jass.TriggerAddAction(
        trig,
        function()
            local item = jass.GetManipulatedItem()
            local unit = jass.GetManipulatingUnit()
            local player = jass.GetOwningPlayer(unit)
            local itemId = jass.GetItemTypeId(item)
            local event = jass.GetTriggerEventId()
            local idStr = fourCCToString(nil, itemId)
            local itemData = items[idStr]
            if not itemData then
                return
            end
            g.udg_TempUnit = unit
            g.udg_TempIsAdd = event == jass.EVENT_PLAYER_UNIT_PICKUP_ITEM
            g.udg_TempHp = itemData.hp or 0
            g.udg_TempMp = itemData.mp or 0
            g.udg_TempDmg = itemData.dmg or 0
            g.udg_TempArmor = itemData.armor or 0
            g.udg_TempAtkSpeed = itemData.atkSpeed or 0
            g.udg_TempMoveSpeed = itemData.moveSpeed or 0
            g.udg_TempStr = itemData.str or 0
            g.udg_TempAgi = itemData.agi or 0
            g.udg_TempInt = itemData.int or 0
            g.udg_TempAll = itemData.all or 0
            local playerStats = {}
            local isAdd = g.udg_TempIsAdd
            local function addStat(____, val, name)
                if val == nil or val == 0 then
                    return
                end
                local value = val
                if not isAdd then
                    value = -value
                end
                playerStats[#playerStats + 1] = {name = name, value = value}
            end
            addStat(nil, itemData.hp, "生命")
            addStat(nil, itemData.mp, "魔法")
            addStat(nil, itemData.dmg, "攻击")
            addStat(nil, itemData.armor, "护甲")
            addStat(nil, itemData.atkSpeed, "攻速")
            addStat(nil, itemData.moveSpeed, "移速")
            addStat(nil, itemData.str, "力量")
            addStat(nil, itemData.agi, "敏捷")
            addStat(nil, itemData.int, "智力")
            addStat(nil, itemData.all, "全属性")
            addStat(nil, itemData.critRate, "暴击率")
            addStat(nil, itemData.critDamage, "暴击伤害")
            jass.ExecuteFunc("ApplyItemBonus")
            local actionText = g.udg_TempIsAdd and "获得" or "丢弃"
            local levelText = itemData.level or ""
            local levelColor
            if levelText == "E-" or levelText == "E" then
                levelColor = "|cFF808080"
            elseif levelText == "D" then
                levelColor = "|cFF00FF00"
            elseif levelText == "C" then
                levelColor = "|cFF0000FF"
            elseif levelText == "B" then
                levelColor = "|cFF800080"
            elseif levelText == "A" then
                levelColor = "|cFFFFA500"
            elseif levelText == "S" then
                levelColor = "|cFFFF0000"
            else
                levelColor = "|cFFFFFFFF"
            end
            local coloredLevel = (levelColor .. levelText) .. "|r"
            local coloredName = ("|cFFFFD700" .. (itemData.name or "未知")) .. "|r"
            local msg = ((((((("|cFF87CEEB【装备】|r " .. actionText) .. "[") .. coloredLevel) .. "]") .. "级") .. "『") .. coloredName) .. "』"
            for ____, stat in ipairs(playerStats) do
                local sign = stat.value > 0 and "+" or ""
                if __TS__ArrayIndexOf(percentNames, stat.name) >= 0 then
                    msg = msg .. (((" " .. stat.name) .. sign) .. tostring(stat.value * 100)) .. "%"
                else
                    msg = msg .. ((" " .. stat.name) .. sign) .. tostring(stat.value)
                end
            end
            jass.DisplayTimedTextToPlayer(
                player,
                0,
                0,
                5,
                msg
            )
        end
    )
    _G.print("【调试】事件监听器创建完成")
end
initEvents(nil)
_G.print("【调试】equip_system 加载完成")
return ____exports
