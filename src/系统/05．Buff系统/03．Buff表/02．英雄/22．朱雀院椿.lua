--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 朱雀院椿 - 英雄 Buff 表（B1 登记）
-- 图标：椿技能图标仍为魔兽原生临时占位（执行计划固定基线），Buff 图标沿用原生占位，不得写 PNG 路径。
-- VF 吸收/姿态规则由私有状态容器与伤害修改入口精确管理；Buff 负责玩家识别与状态查询。
____exports["朱雀院椿BuffID"] = {
    ["VF场"] = "E017",
    ["VF残缺"] = "E018",
    ["反击准备"] = "E019",
    ["一刀守势"] = "E01A",
    ["二刀攻势"] = "E01B",
    ["决斗距离"] = "E01C"
}
____exports["朱雀院椿Buff表"] = {
    [____exports["朱雀院椿BuffID"]["VF场"]] = {
        buffID = ____exports["朱雀院椿BuffID"]["VF场"],
        buffName = "VF场",
        icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Tsubaki\\BTNTsubakiVFChang.blp",
        effect = "",
        effectMode = "attach",
        effectAttachPoint = "origin",
        effectScale = 1,
        type = "Buff:physical:shield",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 70,
        canPurge = false,
        tooltip = "VF 场按真实值吸收伤害（上限 250）；低于阈值进入 VF 残缺。"
    },
    [____exports["朱雀院椿BuffID"]["VF残缺"]] = {
        buffID = ____exports["朱雀院椿BuffID"]["VF残缺"],
        buffName = "VF残缺",
        icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Tsubaki\\BTNTsubakiVFCanQue.blp",
        effect = "",
        effectMode = "attach",
        effectAttachPoint = "origin",
        effectScale = 1,
        type = "Debuff:physical:shield",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = false,
        dispelLevel = 3,
        priority = 75,
        canPurge = false,
        tooltip = "VF 场残缺：当前 VF 低于 30% 上限；VF 恢复至阈值后解除。"
    },
    [____exports["朱雀院椿BuffID"]["反击准备"]] = {
        buffID = ____exports["朱雀院椿BuffID"]["反击准备"],
        buffName = "反击准备",
        icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Tsubaki\\BTNTsubakiFanJiZhunBei.blp",
        effect = "",
        effectMode = "attach",
        effectAttachPoint = "origin",
        effectScale = 1,
        type = "Buff:physical:skill",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 72,
        canPurge = false,
        tooltip = "下一次普攻/Q/E 触发后转化为反击：普攻附带反击斩（实际伤害60%），Q/E 转为返刃。"
    },
    [____exports["朱雀院椿BuffID"]["一刀守势"]] = {
        buffID = ____exports["朱雀院椿BuffID"]["一刀守势"],
        buffName = "一刀守势",
        icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Tsubaki\\BTNTsubakiYiDaoShouShi.blp",
        effect = "",
        effectMode = "attach",
        effectAttachPoint = "origin",
        effectScale = 1,
        type = "Buff:physical:stance",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 80,
        canPurge = false,
        tooltip = "守势姿态：VF 由招架、收刀、返刃、反击斩、间合与后之先等恢复（见各技能说明）。"
    },
    [____exports["朱雀院椿BuffID"]["二刀攻势"]] = {
        buffID = ____exports["朱雀院椿BuffID"]["二刀攻势"],
        buffName = "二刀攻势",
        icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Tsubaki\\BTNTsubakiErDaoGongShi.blp",
        effect = "",
        effectMode = "attach",
        effectAttachPoint = "origin",
        effectScale = 1,
        type = "Buff:physical:stance",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 80,
        canPurge = false,
        tooltip = "攻势：攻击强化，每秒消耗 4 点 VF，归零自动回一刀守势。"
    }
}
return ____exports
