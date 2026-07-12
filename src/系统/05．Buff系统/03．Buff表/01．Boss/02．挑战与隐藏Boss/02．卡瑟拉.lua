--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["卡瑟拉BuffID"] = {
    ["触手缠绕"] = "BKS1",
    ["墨汁遮蔽"] = "BKS2",
    ["触手残片"] = "BKS3",
    ["触手精华"] = "BKS4",
    ["麻痹电流"] = "BKS5",
    ["绝缘庇护"] = "BKS6"
}
____exports["卡瑟拉Buff表"] = {
    [____exports["卡瑟拉BuffID"]["触手缠绕"]] = {
        buffID = ____exports["卡瑟拉BuffID"]["触手缠绕"],
        buffName = "触手缠绕",
        icon = "BuffIcon\\Boss\\Kasela\\tentacle_bind.blp",
        effect = "",
        type = "Debuff:control",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 2,
        priority = 72,
        canPurge = true,
        ["禁止位移"] = true,
        tooltip = "被触手鞭笞命中后缠绕，移动速度降低40%，必要时附加短暂无法移动。"
    },
    [____exports["卡瑟拉BuffID"]["墨汁遮蔽"]] = {
        buffID = ____exports["卡瑟拉BuffID"]["墨汁遮蔽"],
        buffName = "墨汁遮蔽",
        icon = "BuffIcon\\Boss\\Kasela\\ink_shroud.blp",
        effect = "",
        type = "Debuff:control:dot:magic",
        interval = 1,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 2,
        priority = 76,
        canPurge = true,
        tooltip = "站在墨汁区域中，视野降低并被沉默，每秒受到水属性魔法伤害；水属性抗性达标时效果大幅减弱。"
    },
    [____exports["卡瑟拉BuffID"]["触手残片"]] = {
        buffID = ____exports["卡瑟拉BuffID"]["触手残片"],
        buffName = "触手残片",
        icon = "BuffIcon\\Boss\\Kasela\\tentacle_fragment.blp",
        effect = "",
        type = "Buff:stack",
        interval = 0,
        maxStack = 5,
        stackRule = "stack",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 82,
        canPurge = false,
        tooltip = "持有触手残片。每片提高水属性抗性并可在特定条件下恢复生命；共生电击无法躲避时会自动消耗3片抵消。"
    },
    [____exports["卡瑟拉BuffID"]["触手精华"]] = {
        buffID = ____exports["卡瑟拉BuffID"]["触手精华"],
        buffName = "触手精华",
        icon = "BuffIcon\\Boss\\Kasela\\tentacle_essence.blp",
        effect = "",
        type = "Buff:boss:stack",
        interval = 0,
        maxStack = 99,
        stackRule = "stack",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 88,
        canPurge = false,
        tooltip = "卡瑟拉吸收触手残片后获得触手精华。每层提升攻击力3%，持续20秒，可叠加。"
    },
    [____exports["卡瑟拉BuffID"]["麻痹电流"]] = {
        buffID = ____exports["卡瑟拉BuffID"]["麻痹电流"],
        buffName = "麻痹电流",
        icon = "BuffIcon\\Boss\\Kasela\\paralyzing_current.blp",
        effect = "Common\\Effect\\Element\\Thunder\\ThunderParalyzeHit.mdx",
        effectMode = "attach",
        effectAttachPoint = "origin",
        type = "Debuff:control",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 2,
        priority = 86,
        canPurge = true,
        tooltip = "被共生电击命中后进入麻痹状态3秒；站在绝缘珊瑚安全半径内或消耗触手残片可抵消。"
    },
    [____exports["卡瑟拉BuffID"]["绝缘庇护"]] = {
        buffID = ____exports["卡瑟拉BuffID"]["绝缘庇护"],
        buffName = "绝缘庇护",
        icon = "BuffIcon\\Boss\\Kasela\\insulated_shelter.blp",
        effect = "",
        type = "Buff:safe",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 80,
        canPurge = false,
        tooltip = "处于绝缘珊瑚安全半径内，免疫共生电击；离开安全区后立即失效。"
    }
}
____exports.default = ____exports["卡瑟拉Buff表"]
return ____exports
