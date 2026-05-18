--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["回沙之书累计配置"] = {
    ["物品名"] = "回沙之书",
    ["累计阈值"] = 400,
    ["法力恢复倍率"] = 0.12,
    ["特效路径"] = "war3mapImported\\SandAura.mdl",
    ["特效持续时间"] = 2.5,
    ["冷却时间"] = 8
}
____exports["女妖头饰累计配置"] = {
    ["物品名"] = "女妖头饰",
    ["累计阈值"] = 1500,
    ["追踪速度"] = 1500,
    ["追踪模型"] = "Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl",
    ["命中半径"] = 80,
    ["生命周期"] = 4,
    ["每秒毒伤"] = 500,
    ["毒伤持续时间"] = 2,
    ["减速攻速"] = 30,
    ["减速移速"] = 30,
    ["毒影BuffID"] = "C025"
}
____exports["女妖头饰强化累计配置"] = {["物品名"] = "女妖头饰-强化", ["命中次数阈值"] = 5}
____exports["累计伤害物品名表"] = {["回沙之书"] = ____exports["回沙之书累计配置"]["物品名"], ["女妖头饰"] = ____exports["女妖头饰累计配置"]["物品名"], ["女妖头饰强化"] = ____exports["女妖头饰强化累计配置"]["物品名"]}
return ____exports
