--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["地精祭祀技能配置"] = {["破坏死光"] = {
    ["通魔施法秒"] = 1.33,
    ["读条通道"] = "常规技能",
    ["读条颜色ID"] = 1,
    ["动作名称"] = "attack",
    ["作用半径"] = 500,
    ["最大飞行高度"] = 250,
    ["Boss攻击力比例"] = 3.5,
    ["目标最大生命比例"] = 0.1,
    ["目标特效路径"] = "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl",
    ["目标特效挂点"] = "origin",
    ["目标特效持续秒"] = 2,
    ["读条标题"] = "破坏死光",
    ["读条提示"] = "暗影死光即将贯穿目标区域"
}, ["血爆"] = {
    ["预警秒"] = 1,
    ["施法硬直秒"] = 1,
    ["读条通道"] = "常规技能",
    ["读条颜色ID"] = 1,
    ["动作名称"] = "spell",
    ["作用半径"] = 250,
    ["最大飞行高度"] = 400,
    ["Boss攻击力比例"] = 1,
    ["目标最大生命比例"] = 0.2,
    ["眩晕秒"] = 0.8,
    ["预警特效"] = {
        ["路径"] = "Abilities\\Spells\\Orc\\CommandAura\\CommandAuraTarget.mdl",
        Z = 200,
        ["朝向"] = 270,
        ["缩放"] = 2.5,
        ["动画速度"] = 1,
        ["持续秒"] = 1
    },
    ["爆炸特效"] = {
        ["路径"] = "Objects\\Spawnmodels\\Undead\\UDeathMedium\\UDeath.mdl",
        Z = 200,
        ["朝向"] = 270,
        ["缩放"] = 1.33,
        ["动画速度"] = 1,
        ["持续秒"] = 2
    },
    ["音效全局变量名"] = "gg_snd_GWSY03",
    ["读条标题"] = "血爆",
    ["读条提示"] = "锁定位置即将发生血爆"
}, ["毒蕴"] = {
    ["预警秒"] = 1,
    ["施法硬直秒"] = 1,
    ["读条通道"] = "常规技能",
    ["读条颜色ID"] = 1,
    ["动作名称"] = "spell",
    ["随机落点半径"] = 850,
    ["最小落点间距"] = 240,
    ["随机取点最大尝试次数"] = 64,
    ["暗伤落点数"] = 4,
    ["酸伤落点数"] = 3,
    ["作用半径"] = 320,
    ["最大飞行高度"] = 400,
    ["Boss攻击力比例"] = 2.4,
    ["酸性基础伤害"] = 300,
    ["酸性每难度N伤害"] = 150,
    ["预警特效"] = {
        ["路径"] = "Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl",
        Z = 50,
        ["朝向"] = 270,
        ["缩放"] = 1,
        ["动画速度"] = 1,
        ["持续秒"] = 1
    },
    ["爆炸特效"] = {
        ["路径"] = "Objects\\Spawnmodels\\Undead\\UDeathMedium\\UDeath.mdl",
        Z = 200,
        ["朝向"] = 270,
        ["缩放"] = 1.33,
        ["动画速度"] = 1,
        ["持续秒"] = 2
    },
    ["音效全局变量名"] = "gg_snd_GWSY0101",
    ["读条标题"] = "毒蕴",
    ["读条提示"] = "Boss周围随机毒蕴落点即将爆发"
}, ["受击召唤"] = {["召唤单位ID"] = "n008", ["原生持续秒"] = 25, ["原生冷却秒"] = 15}}
____exports["地精祭祀音效配置"] = {
    ["默认裁断距离"] = 2800,
    ["破坏死光"] = {["蓄力"] = "Sound\\Boss\\GoblinPriest\\SFX\\goblinpriest_destroy_light_charge_64k.mp3", ["命中"] = "Sound\\Boss\\GoblinPriest\\SFX\\goblinpriest_destroy_light_hit_64k.mp3"},
    ["血爆"] = {["爆炸命中"] = "Sound\\Boss\\GoblinPriest\\SFX\\goblinpriest_blood_explosion_64k.mp3"},
    ["毒蕴"] = {["暗伤爆炸"] = "Sound\\Boss\\GoblinPriest\\SFX\\goblinpriest_poison_shadow_hit_64k.mp3", ["酸伤爆炸"] = "Sound\\Boss\\GoblinPriest\\SFX\\goblinpriest_poison_acid_hit_64k.mp3"},
    ["受击召唤"] = {["召唤出现"] = "Sound\\Boss\\GoblinPriest\\SFX\\goblinpriest_summon_appear_64k.mp3"},
    ["通用"] = {["Boss受击"] = "Sound\\Boss\\GoblinPriest\\SFX\\goblinpriest_boss_hit_64k.mp3", ["Boss死亡"] = "Sound\\Boss\\GoblinPriest\\SFX\\goblinpriest_boss_death_64k.mp3"}
}
return ____exports
