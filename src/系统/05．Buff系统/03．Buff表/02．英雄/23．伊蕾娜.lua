--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 伊蕾娜 - 英雄 Buff 表（执行计划 A1/A9 登记）
-- 
-- Rawcode 取 E01D-E01G：英雄 Buff 段 E00D-E01C 已被既有英雄占用，本表为下一段空闲编号。
-- 图标尚未制作 BLP，统一使用魔兽原生占位图标；不得填写 output/imagegen PNG 路径。
-- 登记不等于实现：旅途见闻/魔法弹强化/镜界结界/魔法变式的真实效果分别由
-- 23．伊蕾娜 的 02/04/07 号文件接入伤害、保护与变式消费逻辑。
____exports["伊蕾娜BuffID"] = {["旅途见闻"] = "E01D", ["魔法弹强化"] = "E01E", ["镜界结界"] = "E01F", ["魔法变式"] = "E01G"}
____exports["伊蕾娜Buff表"] = {[____exports["伊蕾娜BuffID"]["旅途见闻"]] = {
    buffID = ____exports["伊蕾娜BuffID"]["旅途见闻"],
    buffName = "旅途见闻",
    icon = "ReplaceableTextures\\CommandButtons\\BTNTownBelly.blp",
    effect = "",
    type = "Buff:magic:skill",
    interval = 0,
    maxStack = 3,
    stackRule = "stack",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 80,
    canPurge = false,
    tooltip = "记录最近的施法见闻（风行/镜界/远行），最多三条。"
}, [____exports["伊蕾娜BuffID"]["魔法弹强化"]] = {
    buffID = ____exports["伊蕾娜BuffID"]["魔法弹强化"],
    buffName = "魔法弹强化",
    icon = "ReplaceableTextures\\CommandButtons\\BTNOrbOfCorruption.blp",
    effect = "",
    type = "Buff:magic:skill",
    interval = 0,
    maxStack = 3,
    stackRule = "stack",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 80,
    canPurge = false,
    tooltip = "下一次普攻将消费一条旅途见闻并转化为强化魔法弹。"
}, [____exports["伊蕾娜BuffID"]["镜界结界"]] = {
    buffID = ____exports["伊蕾娜BuffID"]["镜界结界"],
    buffName = "镜界结界",
    icon = "ReplaceableTextures\\CommandButtons\\BTNLoginRunes.blp",
    effect = "",
    type = "Buff:magic:skill",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 90,
    canPurge = false,
    tooltip = "镜界护符的保护窗口：偏折一次主要攻击。"
}, [____exports["伊蕾娜BuffID"]["魔法变式"]] = {
    buffID = ____exports["伊蕾娜BuffID"]["魔法变式"],
    buffName = "魔法变式",
    icon = "ReplaceableTextures\\CommandButtons\\BTNPointVanish.blp",
    effect = "",
    type = "Buff:magic:skill",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 85,
    canPurge = false,
    tooltip = "下一次技能将采用即兴变式：迅行页 / 镜界页 / 灰烬页。"
}}
return ____exports
