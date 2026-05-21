--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetItemTypeId = jass.GetItemTypeId
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local fourCCToString = ____require_result_0.fourCCToString
local itemsData = require("系统.02．物品系统.01．装备数据").default
____exports.STAT_CONFIG = {
    {name = "生命值", key = "hp"},
    {name = "魔法值", key = "mp"},
    {name = "攻击力", key = "dmg"},
    {name = "护甲", key = "armor"},
    {name = "攻速", key = "atkSpeed"},
    {name = "叠加移动速度", key = "movespeed"},
    {name = "力量", key = "str"},
    {name = "敏捷", key = "agi"},
    {name = "智力", key = "int"},
    {name = "全属性", key = "all"},
    {name = "暴击率", key = "critRate"},
    {name = "暴击伤害", key = "critDmg"},
    {name = "魔抗", key = "magicResist"},
    {name = "生命恢复", key = "hpRegen"},
    {name = "生命恢复%", key = "hpRegenPct"},
    {name = "生命恢复效率", key = "hpRegenEff"},
    {name = "技能治疗率", key = "skillHeal"},
    {name = "受到的治疗率", key = "healReceived"},
    {name = "重伤", key = "wound"},
    {name = "魔法恢复", key = "mpRegen"},
    {name = "魔法恢复%", key = "mpRegenPct"},
    {name = "魔法消耗", key = "mpCost"},
    {name = "冷却缩减", key = "cdReduction"},
    {name = "命中率", key = "accuracy"},
    {name = "闪避率", key = "dodge"},
    {name = "护甲穿透", key = "armorPierce"},
    {name = "魔法穿透", key = "magicPierce"},
    {name = "技能伤害", key = "skillDmg"},
    {name = "技能抗性", key = "skillResist"},
    {name = "魔法伤害", key = "magicDmg"},
    {name = "物理伤害", key = "physDmg"},
    {name = "物理抗性", key = "physResist"},
    {name = "强化伤害", key = "enhanceDmg"},
    {name = "普攻伤害", key = "atkDmg"},
    {name = "普攻抗性", key = "atkResist"},
    {name = "光属性伤害", key = "lightDmg"},
    {name = "光属性抗性", key = "lightResist"},
    {name = "暗属性伤害", key = "darkDmg"},
    {name = "暗属性抗性", key = "darkResist"},
    {name = "木属性伤害", key = "woodDmg"},
    {name = "木属性抗性", key = "woodResist"},
    {name = "火属性伤害", key = "fireDmg"},
    {name = "火属性抗性", key = "fireResist"},
    {name = "雷属性伤害", key = "thunderDmg"},
    {name = "雷属性抗性", key = "thunderResist"},
    {name = "水属性伤害", key = "waterDmg"},
    {name = "水属性抗性", key = "waterResist"},
    {name = "金属性抗性", key = "MetalResist"},
    {name = "金属性伤害", key = "metalDmg"},
    {name = "召唤物伤害", key = "summonDmg"},
    {name = "召唤物抗性", key = "summonResist"},
    {name = "伤害减少", key = "dmgReduction"},
    {name = "伤害减少%", key = "dmgReductionPct"},
    {name = "伤害吸血", key = "lifeSteal"},
    {name = "魔法伤害吸血", key = "magicLifeSteal"},
    {name = "普攻伤害吸血", key = "atkLifeSteal"},
    {name = "被暴击率", key = "critRateTaken"},
    {name = "被暴击伤害", key = "critDmgTaken"},
    {name = "眩晕抗性", key = "stunResist"},
    {name = "魔法普攻伤害", key = "magicAtkDmg"},
    {name = "蝼蚁专精", key = "antMastery"},
    {name = "移动速度", key = "movespeed2"},
    {name = "伤害%", key = "dmgBonus"},
    {name = "最终伤害%", key = "finalDmgBonus"},
    {name = "经验获取率", key = "expGainRate"},
    {name = "最大生命值%", key = "hpPct"},
    {name = "最大法力值%", key = "mpPct"},
    {name = "基础生命值%", key = "baseHpPct"},
    {name = "基础攻击力%", key = "baseDmgPct"},
    {name = "基础护甲%", key = "baseArmorPct"},
    {name = "生命值%", key = "hpPercent"},
    {name = "法力值%", key = "mpPercent"},
    {name = "攻击力%", key = "dmgPercent"},
    {name = "护甲%", key = "armorPercent"},
    {name = "受到技伤减少", key = "SpellReduce"},
    {name = "受到物伤减少", key = "PhysReduce"}
}
____exports.KEY_TO_NAME = {}
____exports.NAME_TO_KEY = {}
for ____, e in ipairs(____exports.STAT_CONFIG) do
    ____exports.KEY_TO_NAME[e.key] = e.name
    ____exports.NAME_TO_KEY[e.name] = e.key
end
if not ____exports.NAME_TO_KEY["移速"] then
    ____exports.NAME_TO_KEY["移速"] = "moveSpeed"
end
function ____exports.findStatKey(raw)
    if ____exports.KEY_TO_NAME[raw] ~= nil then
        return raw
    end
    local rl = string.lower(raw)
    for k in pairs(____exports.KEY_TO_NAME) do
        if string.lower(k) == rl then
            return k
        end
    end
    return ""
end
function ____exports.getItemDataEntry(item)
    if item == nil or item == 0 then
        return nil
    end
    local itemId = GetItemTypeId(item)
    if itemId == nil or itemId == 0 then
        return nil
    end
    local idStr = fourCCToString(itemId)
    local entry = itemsData[idStr]
    if not entry then
        return nil
    end
    return entry
end
function ____exports.getItemDataEntryByIdStr(idStr)
    if not idStr then
        return nil
    end
    local entry = itemsData[idStr]
    if not entry then
        return nil
    end
    return entry
end
function ____exports.getItemDataEntryByTypeId(itemTypeId)
    if itemTypeId == nil or itemTypeId == 0 then
        return nil
    end
    local idStr = fourCCToString(itemTypeId)
    return ____exports.getItemDataEntryByIdStr(idStr)
end
return ____exports
