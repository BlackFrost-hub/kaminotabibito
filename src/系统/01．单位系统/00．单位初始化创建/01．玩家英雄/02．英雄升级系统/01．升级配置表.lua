--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["通用升级额外属性配置"] = {{level = 3, attackBonus = 12, onlyMelee = true, note = "旧JASS通用规则：3级近战英雄额外攻击+12"}, {level = 3, attackBonus = 7, onlyRanged = true, note = "旧JASS通用规则：3级远程英雄额外攻击+7"}}
____exports["英雄升级配置列表"] = {
    {heroId = "E05V", heroName = "cloud", properName = "最终幻想", awakeningSkills = {
        {level = 2, abilityId = "A0CJ"},
        {level = 5, abilityId = "A0CG"},
        {level = 10, abilityId = "A0CF"},
        {level = 15, abilityId = "A0CK"},
        {level = 30, abilityId = "A0DL"}
    }},
    {heroId = "H00J", heroName = "恩赐解脱", properName = "问题儿童", awakeningSkills = {{level = 2, abilityId = "A0E3"}, {level = 5, abilityId = "A0E4"}, {level = 10, abilityId = "A0E5"}, {level = 15, abilityId = "A0E1"}}},
    {heroId = "H00M", heroName = "U2", properName = "祭祀之蛇", awakeningSkills = {
        {level = 2, abilityId = "A0E8"},
        {level = 5, abilityId = "A0E9"},
        {level = 10, abilityId = "A0EA"},
        {level = 15, abilityId = "A0ED"},
        {level = 30, abilityId = "A0EB"}
    }},
    {
        heroId = "H00I",
        heroName = "LV6",
        properName = "矢量操作",
        extraAttrs = {{level = 1, repeatEveryLevel = true, skillDamageBonus = 0.01, note = "一方通行每次英雄升级额外提高1%技能伤害。"}},
        awakeningSkills = {{level = 2, abilityId = "A0DU"}, {level = 5, abilityId = "A0DV"}, {level = 10, abilityId = "A0DW"}, {level = 15, abilityId = "A0DX"}}
    },
    {heroId = "H00S", heroName = "无名武士", properName = "无名的武士", awakeningSkills = {{level = 2, abilityId = "A0GS"}, {level = 5, abilityId = "A0GQ"}, {level = 10, abilityId = "A0GV"}, {level = 15, abilityId = "A0GP"}}},
    {heroId = "E001", heroName = "女仆", properName = "完美潇洒的女仆", awakeningSkills = {{level = 2, abilityId = "A00Q"}, {level = 5, abilityId = "A00U"}, {level = 10, abilityId = "A00Z"}, {level = 15, abilityId = "A00Y"}}},
    {heroId = "H00P", heroName = "永远17岁的少女", properName = "妖怪の贤者", awakeningSkills = {{level = 2, abilityId = "A0FV"}, {level = 5, abilityId = "A0FU"}, {level = 10, abilityId = "A0FW"}, {level = 15, abilityId = "A0FT"}}},
    {heroId = "H00H", heroName = "亚瑟王", properName = "圣剑骑士", awakeningSkills = {{level = 2, abilityId = "A0DB"}, {level = 5, abilityId = "A0DE"}, {level = 10, abilityId = "A0DG"}, {level = 15, abilityId = "A0DF"}}},
    {heroId = "H00R", heroName = "|cffff0000炎|r|cffff7f7f杀|r姬", properName = "红红红", awakeningSkills = {
        {level = 2, abilityId = "A0GB"},
        {level = 5, abilityId = "A0G6"},
        {level = 10, abilityId = "A0GG"},
        {level = 15, abilityId = "A0G7"},
        {level = 25, abilityId = "A0G9"}
    }},
    {heroId = "E004", heroName = "馒头卡", properName = "圆环之理", awakeningSkills = {{level = 2, abilityId = "A01U"}, {level = 5, abilityId = "A0LU"}, {level = 10, abilityId = "A01T"}, {level = 15, abilityId = "A0FR"}}},
    {heroId = "E07R", heroName = "月兔", properName = "狂气の月兔", awakeningSkills = {{level = 2, abilityId = "A0GK"}, {level = 5, abilityId = "A0GI"}, {level = 10, abilityId = "A0GH"}, {level = 15, abilityId = "A0GL"}}},
    {heroId = "E006", heroName = "死神", properName = "黑崎一护", awakeningSkills = {{level = 2, abilityId = "A01G"}, {level = 5, abilityId = "A01K"}, {level = 10, abilityId = "A01L"}, {level = 15, abilityId = "A01H"}}},
    {heroId = "H00Q", heroName = "爱德华·艾尔利克", properName = "钢之炼金术师", extraAttrs = {{level = 2, repeatEveryLevel = true, manaRegenBonus = 0.3, note = "旧JASS逻辑：爱德华从2级开始，每次升级额外增加0.30法力回复。"}}},
    {
        heroId = "E0L0",
        heroName = "爱蜜莉雅",
        properName = "冰之精灵术士",
        learnedSkills = {{level = 2, abilityId = "AEQ1", note = "2级学习Q：冰之矢"}, {level = 5, abilityId = "AEW1", note = "5级学习W：冰花绽放"}, {level = 10, abilityId = "AEE1", note = "10级学习E：冰晶护身"}, {level = 15, abilityId = "AER1", note = "15级学习R：永冻之庭"}},
        pendingNotes = {"D：帕克显现为天赋技能，英雄创建时已放入普通技能栏。"}
    },
    {
        heroId = "E0L1",
        heroName = "朱雀院红叶",
        properName = "朱雀院红叶",
        learnedSkills = {{level = 2, abilityId = "AMQ1", note = "2级学习Q：飞燕·穿"}, {level = 5, abilityId = "AMW1", note = "5级学习W：水镜·返刃"}, {level = 10, abilityId = "AME1", note = "10级学习E：三叶·散华"}, {level = 15, abilityId = "AMR1", note = "15级学习R：奥义·红叶一闪"}},
        pendingNotes = {"D：朱雀流·秘传三式为天赋技能，英雄创建时已放入普通技能栏。"}
    },
    {
        heroId = "E0L2",
        heroName = "朱雀院椿",
        properName = "朱雀院椿",
        learnedSkills = {{level = 2, abilityId = "ATQ1", note = "2级学习Q：居合·返"}, {level = 5, abilityId = "ATW1", note = "5级学习W：VF场·后之先"}, {level = 10, abilityId = "ATE1", note = "10级学习E：刃道·间合"}, {level = 15, abilityId = "ATR1", note = "15级学习R：炎姬·黄泉凤凰"}},
        pendingNotes = {"D：浴火鸟·二刀解放为天赋技能，英雄创建时已放入普通技能栏。"}
    },
    {
        heroId = "E0L3",
        heroName = "伊蕾娜",
        properName = "灰之魔女",
        learnedSkills = {{level = 2, abilityId = "AIQ1", note = "2级学习Q：旅风·追迹"}, {level = 5, abilityId = "AIW1", note = "5级学习W：镜界护符"}, {level = 10, abilityId = "AIE1", note = "10级学习E：扫帚·远行"}, {level = 15, abilityId = "AIR1", note = "15级学习R：万法回廊"}},
        pendingNotes = {"D：旅途魔法变式为天赋技能，英雄创建时已放入普通技能栏。"}
    },
    {
        heroId = "E0L4",
        heroName = "塞莉亚·克莱尔",
        properName = "天才魔术师",
        learnedSkills = {{level = 2, abilityId = "AKQ1", note = "2级学习Q：棱晶魔弹"}, {level = 5, abilityId = "AKW1", note = "5级学习W：解析结界"}, {level = 10, abilityId = "AKE1", note = "10级学习E：锚定魔法阵"}, {level = 15, abilityId = "AKR1", note = "15级学习R：高阶术式·闭锁"}},
        pendingNotes = {"D：术式转写为天赋技能，英雄创建时已放入普通技能栏。"}
    },
    {
        heroId = "E0L5",
        heroName = "芙莉莲",
        properName = "精灵魔法使",
        learnedSkills = {{level = 2, abilityId = "AFQ1", note = "2级学习Q：普通攻击魔法·Zoltraak"}, {level = 5, abilityId = "AFW1", note = "5级学习W：防御魔法·魔力护壁"}, {level = 10, abilityId = "AFE1", note = "10级学习E：飞行魔法·高处观察"}, {level = 15, abilityId = "AFR1", note = "15级学习R：解析魔法·贯穿射杀"}},
        pendingNotes = {"D：创造花田的魔法为天赋技能，英雄创建时已放入普通技能栏。"}
    }
}
____exports["英雄升级配置表"] = (function()
    local map = {}
    do
        local i = 0
        while i < #____exports["英雄升级配置列表"] do
            local config = ____exports["英雄升级配置列表"][i + 1]
            map[config.heroId] = config
            i = i + 1
        end
    end
    return map
end)()
____exports["获取英雄升级配置"] = function(heroRawcode)
    return ____exports["英雄升级配置表"][heroRawcode] or nil
end
return ____exports
