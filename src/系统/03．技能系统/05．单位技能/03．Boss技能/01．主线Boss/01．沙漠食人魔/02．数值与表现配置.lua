--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["沙漠食人魔技能配置"] = {
    ["蓄力重击"] = {
        ["最大层数"] = 4,
        ["每层暴击率"] = 0.2,
        ["范围"] = 400,
        ["攻击力比例"] = 1,
        ["爆炸特效"] = "war3mapImported\\explosion.mdl"
    },
    ["食人魔"] = {["基础啃食秒"] = 2.6, ["每层难度减少秒"] = 0.2, ["动画编号"] = 7, ["特效"] = "Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl"},
    ["食人魔咒"] = {
        ["生效延迟秒"] = 1.5,
        ["多人基础持续秒"] = 5,
        ["单人基础持续秒"] = 3,
        ["每名玩家增加秒"] = 0.5,
        ["最大生命基础比例"] = 0.24,
        ["最大生命每层难度比例"] = 0.02,
        ["攻击力基础比例"] = 1.8,
        ["攻击力每层难度比例"] = 0.1,
        ["生效特效"] = "war3mapImported\\desecrate.mdl"
    },
    ["风暴之锤"] = {
        ["生命周期秒"] = 5,
        ["弹幕生命值"] = 500,
        ["速度"] = 400,
        ["命中半径"] = 100,
        ["爆炸范围"] = 500,
        ["攻击力比例"] = 5,
        ["眩晕秒"] = 2,
        ["非指定目标倍率"] = 0.6,
        ["单人倍率"] = 0.6,
        ["模型"] = "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl",
        ["爆炸特效"] = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
    },
    ["雷霆敲打"] = {
        ["轮数"] = 4,
        ["轮次间隔秒"] = 1.2,
        ["预警秒"] = 0.5,
        ["每轮转向角度"] = 82.5,
        ["弹幕速度"] = 528,
        ["弹幕持续秒"] = 1.2,
        ["命中半径"] = 195,
        ["攻击力比例"] = 2.2,
        ["减速比例"] = 0.25,
        ["减速秒"] = 1,
        ["动画编号"] = 6,
        ["预警特效"] = "war3mapImported\\bossjinggaoh.mdl",
        ["弹幕模型"] = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl",
        ["命中特效"] = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl"
    },
    ["雷霆震怒"] = {
        ["总硬直秒"] = 3.75,
        ["牵引开始秒"] = 0.8,
        ["结算秒"] = 1.9,
        ["牵引范围"] = 1700,
        ["爆心筛选范围"] = 2000,
        ["爆心范围"] = 600,
        ["牵引次数"] = 12,
        ["牵引间隔秒"] = 0.07,
        ["每次牵引距离"] = 32.5,
        ["攻击力比例"] = 2.8,
        ["目标最大生命比例"] = 0.25,
        ["起手动画编号"] = 3,
        ["敲击动画编号"] = 6,
        ["蓄力特效"] = "war3mapImported\\[AKE]war3AKE.com - 8146994216305873548723316.mdl",
        ["牵引结束特效"] = "war3mapImported\\[AKE]war3AKE.com - 8146994216305873548723316.mdl",
        ["结算特效"] = "war3mapImported\\SandWaveDamage.mdl",
        ["结算附加特效"] = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl",
        ["起手音效路径"] = "war3mapImported\\GWSY04.wav"
    },
    ["心脏掌握"] = {
        ["基础斩杀线比例"] = 0.25,
        ["每层难度斩杀线比例"] = 0.05,
        ["单人斩杀线倍率"] = 0.6,
        ["冷却秒"] = 12,
        ["预警秒"] = 3,
        ["第二段预警秒"] = 2,
        ["当前生命伤害比例"] = 2,
        ["分摊范围"] = 300,
        ["瞬移距离"] = 160,
        ["动作重播间隔秒"] = 1,
        ["动作编号"] = 3,
        ["吟唱条颜色ID"] = 1,
        ["吟唱条标题文本"] = "心脏掌握",
        ["吟唱条提示文本"] = "目标已被硬直，3秒后结算致命伤害。",
        ["第一段预警特效"] = "war3mapImported\\[AKE]war3AKE.com - 1716862506547375212002341.mdl",
        ["第二段预警特效"] = "war3mapImported\\[AKE]war3AKE.com - 1921116848165847633007217.mdl",
        ["结算特效"] = "war3mapImported\\desecrate.mdl",
        ["音效全局变量名"] = "gg_snd_GWSY06"
    }
}
____exports["沙漠食人魔音效配置"] = {["默认裁断距离"] = 2800, ["食人魔咒"] = {["生效"] = "Sound\\Boss\\Ogre\\SFX\\ogre_curse_cast_64k.mp3"}, ["蓄力重击"] = {["爆炸"] = "Sound\\Boss\\Ogre\\SFX\\ogre_charge_explosion_64k.mp3"}}
return ____exports
