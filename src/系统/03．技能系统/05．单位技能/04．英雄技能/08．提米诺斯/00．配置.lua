--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["提米诺斯单位技能配置"] = {
    ["英雄名"] = "提米诺斯",
    ["单位类型ID"] = "H015",
    ["Q技能ID"] = "A0K0",
    ["W技能ID"] = "A0K1",
    ["E技能ID"] = "A0K2",
    ["R技能ID"] = "A0K3",
    ["D技能ID"] = "A0K5",
    Q = {
        ["快捷键序号"] = 1,
        ["动作编号"] = -1,
        ["动作速度"] = 1,
        ["硬直秒"] = 0,
        ["全局音效键"] = "gg_snd_TMNS_Q",
        ["范围"] = 750,
        ["实际魔耗治疗倍率"] = 2.25,
        ["主体特效模型"] = "war3mapImported\\ancientexplode.mdl",
        ["主体特效Z"] = 100,
        ["主体特效缩放"] = 2,
        ["主体特效持续秒"] = 3,
        ["特效"] = {{["模型"] = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl", ["挂点"] = "overhead"}, {["模型"] = "Abilities\\Spells\\Orc\\HealingWave\\HealingWaveTarget.mdl", ["挂点"] = "origin"}},
        ["特效持续秒"] = 1
    },
    W = {
        ["快捷键序号"] = 2,
        ["动作编号"] = -1,
        ["动作速度"] = 1,
        ["硬直秒"] = 0,
        ["全局音效键"] = {"gg_snd_TMNS_W", "gg_snd_TMNS_W2"},
        ["基础攻击力倍率"] = 1.7,
        ["每级攻击力倍率"] = 0.08,
        ["溅射范围"] = 350,
        ["溅射倍率"] = 0.8,
        ["特效模型"] = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl",
        ["特效Z"] = 10,
        ["特效Z轴角度"] = 270,
        ["特效缩放"] = 2,
        ["特效持续秒"] = 1
    },
    E = {["快捷键序号"] = 3, ["每级光伤"] = 0.02, ["每级暴击率"] = 0.02, ["光弱点额外增伤"] = 0.02},
    R = {
        ["快捷键序号"] = 4,
        ["动作编号"] = -1,
        ["动作速度"] = 1,
        ["硬直秒"] = 0,
        ["全局音效键"] = "gg_snd_TMNS_R",
        ["持续秒"] = 5,
        ["刷新次数"] = 2,
        ["最大基础魔耗"] = 350,
        BuffID = "C068",
        ["原生状态技能ID"] = "S00G",
        ["特效"] = {{["模型"] = "war3mapImported\\[AKE]war3AKE.com - 6738594390437618540970331.mdl", Z = 10, ["缩放"] = 1}, {["模型"] = "war3mapImported\\Sunwell_BeamFX.mdl", Z = 0, ["缩放"] = 0.5}},
        ["特效持续秒"] = 1
    },
    D = {
        ["快捷键序号"] = 5,
        ["动作编号"] = 5,
        ["动作速度"] = 1.5,
        ["硬直秒"] = 0.5,
        ["动作延迟秒"] = 0.05,
        ["伤害延迟秒"] = 0.5,
        ["全局音效键"] = "gg_snd_TMNS_D",
        ["目标偏移距离"] = 100,
        ["伤害范围"] = 350,
        ["攻击力倍率"] = 2,
        ["实际伤害回魔比例"] = 0.5,
        ["返回特效模型"] = "Abilities\\Spells\\Items\\AIre\\AIreTarget.mdl",
        ["返回特效Z"] = 10,
        ["返回特效Z轴角度"] = 270,
        ["返回特效缩放"] = 1.2,
        ["返回特效持续秒"] = 1.5
    }
}
return ____exports
