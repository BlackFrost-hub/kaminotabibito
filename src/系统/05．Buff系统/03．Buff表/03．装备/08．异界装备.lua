--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
____exports["异界装备Buff表"] = {
    [_____5E38_89C4BuffID["光辉翠绿宝石_翠绿防护"]] = {
        buffID = _____5E38_89C4BuffID["光辉翠绿宝石_翠绿防护"],
        buffName = "翠绿防护",
        icon = "Equipment\\Icon\\Item\\ainz_radiant_green_gemstone.blp",
        effect = "",
        type = "Buff:equipment:immunity",
        interval = 0,
        maxStack = 2,
        stackRule = "stack",
        stackRefresh = false,
        dispelLevel = 0,
        priority = 5,
        canPurge = false,
        ["data2属性名"] = "最大生命值%",
        tooltip = "当前拥有stack层翠绿防护；每层独立免疫一次至少data点且不低于最大生命值data2%的非装备直接物理伤害。0层时，图标倒计时表示距离下一层刷新还剩time秒。"
    },
    [_____5E38_89C4BuffID["黑翼守护重盾_守护者契约"]] = {
        buffID = _____5E38_89C4BuffID["黑翼守护重盾_守护者契约"],
        buffName = "黑翼守誓",
        icon = "Equipment\\Icon\\SubWeapon\\ainz_black_wing_guard_heavy_shield.blp",
        effect = "",
        type = "Buff:equipment:guardian-link",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 0,
        priority = 5,
        canPurge = false,
        tooltip = "正在守护契约目标：为其承受data%的直接伤害；自身生命不高于20%、距离超过900码或任意一方死亡时，契约提前结束。剩余time秒。"
    },
    [_____5E38_89C4BuffID["黑翼守护重盾_受护者契约"]] = {
        buffID = _____5E38_89C4BuffID["黑翼守护重盾_受护者契约"],
        buffName = "黑翼受护",
        icon = "Equipment\\Icon\\SubWeapon\\ainz_black_wing_guard_heavy_shield.blp",
        effect = "",
        type = "Buff:equipment:guardian-link",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 0,
        priority = 5,
        canPurge = false,
        tooltip = "受到黑翼契约守护：所受直接伤害的data%转移给守护者；双方距离超过900码、守护者生命不高于20%或任意一方死亡时，契约提前结束。剩余time秒。"
    },
    [_____5E38_89C4BuffID["滴管长枪投影_鲜血枯竭"]] = {
        buffID = _____5E38_89C4BuffID["滴管长枪投影_鲜血枯竭"],
        buffName = "鲜血枯竭",
        icon = "BuffIcon\\Boss\\Shalltear\\blood_exhaustion.blp",
        effect = "Common\\Effect\\Form\\Debuff\\ShalltearBloodExhaustionMark.mdx",
        effectMode = "attach",
        effectAttachPoint = "overhead",
        effectScale = 0.85,
        type = "Buff:equipment:mechanic:cooldown",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = false,
        dispelLevel = 0,
        priority = 5,
        canPurge = false,
        tooltip = "滴管汲血正在冷却。持续期间，施加者对该目标的纯普通攻击不累计滴管汲血次数，也不能再次触发；其他攻击者独立计算。剩余time秒。"
    },
    [_____5E38_89C4BuffID["真祖女武神血铠_血晶"]] = {
        buffID = _____5E38_89C4BuffID["真祖女武神血铠_血晶"],
        buffName = "血晶",
        icon = "Equipment\\Icon\\Clothes\\shalltear_true_vampire_valkyrie_blood_armor.blp",
        effect = "",
        type = "Buff:equipment:resource:stack",
        interval = 0,
        maxStack = 3,
        stackRule = "stack",
        stackRefresh = true,
        dispelLevel = 0,
        priority = 5,
        canPurge = false,
        tooltip = "当前拥有stack枚血晶（最多3枚）。每次成功获得血晶时，全部血晶的剩余持续时间刷新至12秒。生命不高于35%时消耗全部血晶：获得最大生命5%+每枚血晶4%的护盾，并且每枚血晶提供18%攻击速度，均持续6秒。血晶剩余time秒。"
    }
}
____exports.default = ____exports["异界装备Buff表"]
return ____exports
