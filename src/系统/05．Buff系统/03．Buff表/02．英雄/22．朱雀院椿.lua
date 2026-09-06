--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.22．朱雀院椿.00．配置")
local _____6731_96C0_9662_693F_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿表现配置"]
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
        effect = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["VF完整"]["模型路径"],
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
        effect = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["VF残缺"]["模型路径"],
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
        tooltip = "VF 场残缺，防护下降；一刀守势下 VF 恢复（每秒 15 点）到阈值后解除。"
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
        tooltip = "下一次普攻/Q/E 触发后转化为反击（攻击力100%物理伤害）。"
    },
    [____exports["朱雀院椿BuffID"]["一刀守势"]] = {
        buffID = ____exports["朱雀院椿BuffID"]["一刀守势"],
        buffName = "一刀守势",
        icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Tsubaki\\BTNTsubakiYiDaoShouShi.blp",
        effect = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["D一刀守势"]["模型路径"],
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
        tooltip = "守势：VF 每秒恢复 15 点，受击减半。"
    },
    [____exports["朱雀院椿BuffID"]["二刀攻势"]] = {
        buffID = ____exports["朱雀院椿BuffID"]["二刀攻势"],
        buffName = "二刀攻势",
        icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Tsubaki\\BTNTsubakiErDaoGongShi.blp",
        effect = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["D二刀攻势"]["模型路径"],
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
