local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
____exports["安兹基础挑战奖励池ID"] = "chapter3.otherworld.ainz"
____exports["安兹守护者挑战奖励池ID"] = "chapter3.otherworld.ainz_guardian"
local _____5B89_5179_57FA_7840_5956_52B1_9009_9879 = {{
    ["装备名"] = "超位魔法残章·天空坠落",
    ["排序"] = 1,
    ["图标"] = "Equipment\\Icon\\SubWeapon\\ainz_super_tier_fragment_fallen_down.blp",
    ["描述"] = "超位法术法典，强化智力、魔法伤害、穿透、魔法值与冷却缩减。",
    ["特效"] = "天空坠落主动装备技能后续单独接入。"
}, {
    ["装备名"] = "光辉翠绿宝石",
    ["排序"] = 2,
    ["图标"] = "Equipment\\Icon\\Item\\ainz_radiant_green_gemstone.blp",
    ["描述"] = "通用生存宝石，强化生命值、护甲、魔抗与全属性。",
    ["特效"] = "光辉翠绿体装备技能后续单独接入。"
}}
____exports["异界_安兹乌尔恭基础战利品配置"] = {["奖励池ID"] = ____exports["安兹基础挑战奖励池ID"], ["标题"] = "安兹·乌尔·恭的战利品", ["可选数量"] = 1, ["选项"] = _____5B89_5179_57FA_7840_5956_52B1_9009_9879}
local ____array_0 = __TS__SparseArrayNew(table.unpack(_____5B89_5179_57FA_7840_5956_52B1_9009_9879))
__TS__SparseArrayPush(____array_0, {
    ["装备名"] = "黑翼守护重盾",
    ["排序"] = 3,
    ["图标"] = "Equipment\\Icon\\SubWeapon\\ainz_black_wing_guard_heavy_shield.blp",
    ["描述"] = "守护者模式专属重盾，强化生命、护甲、物理抗性与控制抗性。",
    ["特效"] = "守护者之职责主动装备技能后续单独接入。"
})
____exports["异界_安兹乌尔恭守护者战利品配置"] = {
    ["奖励池ID"] = ____exports["安兹守护者挑战奖励池ID"],
    ["标题"] = "安兹·乌尔·恭与守护者的战利品",
    ["可选数量"] = 1,
    ["选项"] = {__TS__SparseArraySpread(____array_0)}
}
return ____exports
