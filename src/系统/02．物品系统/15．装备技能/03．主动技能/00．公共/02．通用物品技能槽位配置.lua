--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4E3B_52A8_6280_80FD_88C5_5907_540D = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.00．主动技能装备名")
local _____4E3B_52A8_6280_80FD_88C5_5907_540D_79F0 = ____00_FF0E_4E3B_52A8_6280_80FD_88C5_5907_540D["主动技能装备名称"]
____exports["通用物品技能槽位可用命令ID表"] = {["单位目标"] = {
    "acidbomb",
    "banish",
    "chainlightning",
    "cripple",
    "curse",
    "cyclone",
    "deathcoil",
    "entanglingroots",
    "faeriefire",
    "firebolt",
    "frostnova",
    "soulburn",
    "heal",
    "innerfire",
    "purge"
}, ["点目标"] = {
    "flamestrike",
    "blizzard",
    "carrionswarm",
    "breathoffire",
    "shockwave",
    "impale",
    "monsoon",
    "rainoffire",
    "silence",
    "stampede",
    "volcano",
    "clusterrockets",
    "earthquake",
    "tornado",
    "forceofnature"
}, ["无目标"] = {
    "thunderclap",
    "warstomp",
    "roar",
    "howlofterror",
    "polymorph",
    "hex",
    "fingerofdeath",
    "forkedlightning",
    "manaburn",
    "thunderbolt",
    "holybolt",
    "drunkenhaze",
    "shadowstrike",
    "parasite",
    "possession"
}}
____exports["通用物品技能槽位配置表"] = {{
    ["装备名称"] = _____4E3B_52A8_6280_80FD_88C5_5907_540D_79F0["瑟兰迪尔的决心"],
    ["物编ID"] = "I0E4",
    ["技能ID"] = "IN00",
    ["目标类型"] = "无目标",
    ["命令ID"] = "thunderclap",
    ["冷却间隔组"] = "IN00",
    ["冷却时间"] = 120,
    ["魔法消耗"] = 0,
    ["施法距离"] = 0,
    ["施法区域"] = 0,
    ["说明"] = "使用：召唤瑟兰迪尔幻影协助战斗30秒，仅精灵城内可用。"
}, {
    ["装备名称"] = _____4E3B_52A8_6280_80FD_88C5_5907_540D_79F0["影骨披风"],
    ["物编ID"] = "I0FF",
    ["技能ID"] = "IN01",
    ["目标类型"] = "无目标",
    ["命令ID"] = "warstomp",
    ["冷却间隔组"] = "IN01",
    ["冷却时间"] = 90,
    ["魔法消耗"] = 0,
    ["施法距离"] = 0,
    ["施法区域"] = 0,
    ["说明"] = "使用：进入潜行6秒。"
}, {
    ["装备名称"] = _____4E3B_52A8_6280_80FD_88C5_5907_540D_79F0["阴影陷阱装置"],
    ["物编ID"] = "I0FI",
    ["技能ID"] = "IP00",
    ["目标类型"] = "点目标",
    ["命令ID"] = "flamestrike",
    ["冷却间隔组"] = "IP00",
    ["冷却时间"] = 30,
    ["魔法消耗"] = 0,
    ["施法距离"] = 600,
    ["施法区域"] = 220,
    ["说明"] = "使用：放置阴影陷阱，触发后禁锢敌人2秒，最多3次。"
}}
return ____exports
