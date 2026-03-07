local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local ____exports = {}
local jass = require("jass.common")
local g = require("jass.globals")
local items = require("系统.装备.装备数据").default
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
    "攻速"
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
            local charges = jass.GetItemCharges(item)
            local mult = charges > 0 and charges or 1
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
            local ____itemData_score_0 = itemData.score
            if ____itemData_score_0 == nil then
                ____itemData_score_0 = 0
            end
            g.udg_TempScore = ____itemData_score_0
            local playerStats = {}
            local isAdd = g.udg_TempIsAdd
            local function addStat(____, val, name)
                if val == nil or val == 0 then
                    return
                end
                local value = val * mult
                if not isAdd then
                    value = -value
                end
                playerStats[#playerStats + 1] = {name = name, value = value}
            end
            addStat(nil, itemData.hp, "生命值")
            addStat(nil, itemData.mp, "魔法值")
            addStat(nil, itemData.dmg, "攻击力")
            addStat(nil, itemData.armor, "护甲")
            addStat(nil, itemData.atkSpeed, "攻速")
            addStat(nil, itemData.movespeed, "移速")
            addStat(nil, itemData.str, "力量")
            addStat(nil, itemData.agi, "敏捷")
            addStat(nil, itemData.int, "智力")
            addStat(nil, itemData.all, "全属性")
            addStat(nil, itemData.critRate, "暴击率")
            addStat(nil, itemData.critDmg, "暴击伤害")
            addStat(nil, itemData.magicResist, "魔抗")
            addStat(nil, itemData.hpRegen, "生命恢复")
            addStat(nil, itemData.hpRegenPct, "生命恢复%")
            addStat(nil, itemData.hpRegenEff, "生命恢复效率")
            addStat(nil, itemData.skillHeal, "技能治疗率")
            addStat(nil, itemData.healReceived, "受到的治疗率")
            addStat(nil, itemData.mpRegen, "魔法恢复")
            addStat(nil, itemData.mpRegenPct, "魔法恢复%")
            addStat(nil, itemData.mpCost, "魔法消耗")
            addStat(nil, itemData.cdReduction, "冷却缩减")
            addStat(nil, itemData.accuracy, "命中率")
            addStat(nil, itemData.dodge, "闪避率")
            addStat(nil, itemData.armorPierce, "护甲穿透")
            addStat(nil, itemData.magicPierce, "魔法穿透")
            addStat(nil, itemData.skillDmg, "技能伤害")
            addStat(nil, itemData.skillResist, "技能抗性")
            addStat(nil, itemData.magicDmg, "魔法伤害")
            addStat(nil, itemData.physDmg, "物理伤害")
            addStat(nil, itemData.physResist, "物理抗性")
            addStat(nil, itemData.enhanceDmg, "强化伤害")
            addStat(nil, itemData.atkDmg, "普攻伤害")
            addStat(nil, itemData.atkResist, "普攻抗性")
            addStat(nil, itemData.lightDmg, "光属性伤害")
            addStat(nil, itemData.lightResist, "光属性抗性")
            addStat(nil, itemData.darkDmg, "暗属性伤害")
            addStat(nil, itemData.darkResist, "暗属性抗性")
            addStat(nil, itemData.woodDmg, "木属性伤害")
            addStat(nil, itemData.woodResist, "木属性抗性")
            addStat(nil, itemData.fireDmg, "火属性伤害")
            addStat(nil, itemData.fireResist, "火属性抗性")
            addStat(nil, itemData.thunderDmg, "雷属性伤害")
            addStat(nil, itemData.thunderResist, "雷属性抗性")
            addStat(nil, itemData.waterDmg, "水属性伤害")
            addStat(nil, itemData.waterResist, "水属性抗性")
            addStat(nil, itemData.MetalResist, "金属性抗性")
            addStat(nil, itemData.summonDmg, "召唤物伤害")
            addStat(nil, itemData.summonResist, "召唤物抗性")
            addStat(nil, itemData.dmgReduction, "伤害减少")
            addStat(nil, itemData.dmgReductionPct, "伤害减少%")
            addStat(nil, itemData.lifeSteal, "伤害吸血")
            addStat(nil, itemData.magicLifeSteal, "魔法伤害吸血")
            addStat(nil, itemData.atkLifeSteal, "普攻伤害吸血")
            addStat(nil, itemData.critRateTaken, "被暴击率")
            addStat(nil, itemData.critDmgTaken, "被暴击伤害")
            addStat(nil, itemData.stunResist, "眩晕抗性")
            addStat(nil, itemData.magicAtkDmg, "魔法普攻伤害")
            addStat(nil, itemData.antMastery, "蝼蚁专精")
            addStat(nil, itemData.movespeed2, "移动速度")
            addStat(nil, itemData.dmgBonus, "伤害%")
            addStat(nil, itemData.finalDmgBonus, "最终伤害%")
            addStat(nil, itemData.expGainRate, "经验获取率")
            g.udg_TempString = {}
            g.udg_TempAmount = {}
            g.udg_TempStatCount = #playerStats
            do
                local i = 0
                while i < #playerStats do
                    g.udg_TempString[i + 1] = playerStats[i + 1].name
                    g.udg_TempAmount[i + 1] = playerStats[i + 1].value
                    i = i + 1
                end
            end
            local owner = jass.GetOwningPlayer(g.udg_TempUnit)
            local playerName = jass.GetPlayerName(owner)
            local tempRead = g.udg_TempReadValue
            local test5Parts = {}
            do
                local i = 0
                while i < #playerStats do
                    local idx = i + 1
                    local statName = g.udg_TempString[idx]
                    local val = tempRead ~= nil and tempRead[i + 1] ~= nil and tempRead[i + 1] or 0
                    local displayVal = val + playerStats[i + 1].value
                    local num = __TS__Number(displayVal)
                    local valStr = tostring(num)
                    test5Parts[#test5Parts + 1] = (tostring(statName) .. "为：") .. valStr
                    i = i + 1
                end
            end
            if #test5Parts > 0 then
                jass.DisplayTimedTextToPlayer(
                    owner,
                    0,
                    0.02,
                    5,
                    (("系统测试：" .. playerName) .. "的当前装备属性") .. table.concat(test5Parts, "，")
                )
            end
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
                0.01,
                5,
                msg
            )
            jass.ExecuteFunc("ApplyItemBonus")
        end
    )
    _G.print("【调试】事件监听器创建完成")
end
initEvents(nil)
_G.print("【调试】equip_system 加载完成")
return ____exports
