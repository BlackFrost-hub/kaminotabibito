--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 伊蕾娜 - 英雄 Buff 表（执行计划 A1/A9 登记）
-- 
-- Rawcode 取 E01D-E01F、E025-E027：英雄 Buff 段 E00D-E01C 已被既有英雄占用，
-- E01D-E01F 为既有状态，E025-E027 为三种互斥变式状态的专用编号。
-- 登记不等于实现：旅途见闻/魔法弹强化/镜界结界/三种魔法变式的真实效果分别由
-- 23．伊蕾娜 的 02/04/07 号文件接入伤害、保护与变式消费逻辑。
____exports["伊蕾娜BuffID"] = {
    ["旅途见闻"] = "E01D",
    ["魔法弹强化"] = "E01E",
    ["镜界结界"] = "E01F",
    ["迅行变式"] = "E025",
    ["镜界变式"] = "E026",
    ["灰烬变式"] = "E027"
}
____exports["伊蕾娜Buff表"] = {
    [____exports["伊蕾娜BuffID"]["旅途见闻"]] = {
        buffID = ____exports["伊蕾娜BuffID"]["旅途见闻"],
        buffName = "旅途见闻",
        icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Irena\\BTNIrenaLvTuJianWen.blp",
        effect = "",
        type = "Buff:magic:skill",
        interval = 0,
        maxStack = 3,
        stackRule = "stack",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 80,
        canPurge = false,
        tooltip = "记录最近的施法见闻（风行/镜界/远行），最多 3 条，每条 12 秒。"
    },
    [____exports["伊蕾娜BuffID"]["魔法弹强化"]] = {
        buffID = ____exports["伊蕾娜BuffID"]["魔法弹强化"],
        buffName = "魔法弹强化",
        icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Irena\\BTNIrenaMoFaDanQiangHua.blp",
        effect = "",
        type = "Buff:magic:skill",
        interval = 0,
        maxStack = 3,
        stackRule = "stack",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 80,
        canPurge = false,
        tooltip = "强化魔法弹（最多 3 条见闻，每条 12 秒）：下一次普攻追加魔法伤害。"
    },
    [____exports["伊蕾娜BuffID"]["镜界结界"]] = {
        buffID = ____exports["伊蕾娜BuffID"]["镜界结界"],
        buffName = "镜界结界",
        icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Irena\\BTNIrenaJingJieJieJie.blp",
        effect = "",
        type = "Buff:magic:skill",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 90,
        canPurge = false,
        tooltip = "镜界护符 4 秒：偏折一次主要攻击；结束时使周围敌人减速 35%、1.5 秒。"
    },
    [____exports["伊蕾娜BuffID"]["迅行变式"]] = {
        buffID = ____exports["伊蕾娜BuffID"]["迅行变式"],
        buffName = "迅行变式",
        icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Irena\\BTNIrenaVariantRapid.blp",
        effect = "",
        type = "Buff:magic:skill",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 85,
        canPurge = false,
        tooltip = "迅行变式：下一次 Q/W/E/R 采用迅行效果，保留 30 秒。"
    },
    [____exports["伊蕾娜BuffID"]["镜界变式"]] = {
        buffID = ____exports["伊蕾娜BuffID"]["镜界变式"],
        buffName = "镜界变式",
        icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Irena\\BTNIrenaVariantMirror.blp",
        effect = "",
        type = "Buff:magic:skill",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 85,
        canPurge = false,
        tooltip = "镜界变式：下一次 Q/W/E/R 采用镜界效果，保留 30 秒。"
    },
    [____exports["伊蕾娜BuffID"]["灰烬变式"]] = {
        buffID = ____exports["伊蕾娜BuffID"]["灰烬变式"],
        buffName = "灰烬变式",
        icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Irena\\BTNIrenaVariantAsh.blp",
        effect = "",
        type = "Buff:magic:skill",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 85,
        canPurge = false,
        tooltip = "灰烬变式：下一次 Q/W/E/R 采用灰烬效果，保留 30 秒。"
    }
}
return ____exports
