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
        icon = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
        effect = "Common\\Effect\\Form\\Shield\\TsubakiVFBarrier.mdx",
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
        tooltip = "VF 场按真实值吸收伤害；低于阈值进入残缺。"
    },
    [____exports["朱雀院椿BuffID"]["VF残缺"]] = {
        buffID = ____exports["朱雀院椿BuffID"]["VF残缺"],
        buffName = "VF残缺",
        icon = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
        effect = "Common\\Effect\\Form\\Shield\\TsubakiVFCracked.mdx",
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
        tooltip = "VF 场残缺，防护下降；恢复后可解除。"
    },
    [____exports["朱雀院椿BuffID"]["反击准备"]] = {
        buffID = ____exports["朱雀院椿BuffID"]["反击准备"],
        buffName = "反击准备",
        icon = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
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
        tooltip = "下一次普攻/Q/E 可转化为一次反击。"
    },
    [____exports["朱雀院椿BuffID"]["一刀守势"]] = {
        buffID = ____exports["朱雀院椿BuffID"]["一刀守势"],
        buffName = "一刀守势",
        icon = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
        effect = "Common\\Effect\\Form\\Rotate\\TsubakiIchiGuard.mdx",
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
        tooltip = "防守姿态：VF 恢复效率较高。"
    },
    [____exports["朱雀院椿BuffID"]["二刀攻势"]] = {
        buffID = ____exports["朱雀院椿BuffID"]["二刀攻势"],
        buffName = "二刀攻势",
        icon = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
        effect = "Common\\Effect\\Form\\Rotate\\TsubakiNitoAssault.mdx",
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
        tooltip = "攻势姿态：攻击强化但持续消耗 VF。"
    },
    [____exports["朱雀院椿BuffID"]["决斗距离"]] = {
        buffID = ____exports["朱雀院椿BuffID"]["决斗距离"],
        buffName = "决斗距离",
        icon = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
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
        priority = 73,
        canPurge = false,
        tooltip = "间合范围内可被 R 读取。"
    }
}
return ____exports
