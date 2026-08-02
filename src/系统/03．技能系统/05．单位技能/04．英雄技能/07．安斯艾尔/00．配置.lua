--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["安斯艾尔单位技能配置"] = {
    ["英雄名"] = "安斯艾尔",
    ["单位类型ID"] = "Hart",
    ["被动技能ID"] = "A0KD",
    ["Q技能ID"] = "A0KE",
    ["W技能ID"] = "A0KF",
    ["被动"] = {
        ["快捷键序号"] = 0,
        ["目标最大生命比例"] = 0.1,
        ["攻击力倍率"] = 1,
        ["伤害特效"] = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl",
        ["特效挂点"] = "origin",
        ["特效持续秒"] = 1
    },
    Q = {
        ["快捷键序号"] = 1,
        ["动作编号"] = -1,
        ["动作速度"] = 1,
        ["全局音效键"] = "",
        ["附魔次数"] = 2,
        ["持续秒"] = 4,
        ["普攻吸血增加"] = 0.15,
        ["基础攻击力倍率"] = 0.15,
        ["每级攻击力倍率"] = 0.04,
        ["光属性特效"] = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl",
        ["雷属性特效"] = "Abilities\\Spells\\Orc\\LightningShield\\LightningShieldTarget.mdl",
        ["火属性特效"] = "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeDamageTarget.mdl",
        ["特效挂点"] = "origin",
        ["特效持续秒"] = 1
    },
    W = {
        ["快捷键序号"] = 2,
        ["动作编号"] = -1,
        ["动作速度"] = 1,
        ["全局音效键"] = "",
        ["基础攻击力倍率"] = 1.5,
        ["每级攻击力倍率"] = 0.4,
        ["击退距离"] = 350,
        ["击退持续秒"] = 0.25,
        ["减速比例"] = 0.3,
        ["减速持续秒"] = 0.8,
        ["连续特效模型"] = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl",
        ["连续特效次数"] = 3,
        ["连续特效间隔毫秒"] = 80,
        ["连续特效Z"] = 25,
        ["连续特效Z轴角度"] = 270,
        ["连续特效缩放"] = 1,
        ["连续特效动画速度"] = 1,
        ["连续特效持续秒"] = 1
    }
}
return ____exports
