--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["树魔首领BuffID"] = {
    ["兽群号令"] = "BTL1",
    ["无从暴怒"] = "BTL2",
    ["古树衰弱"] = "BTL3",
    ["远古诅咒"] = "BTL4",
    ["治疗枯竭"] = "BTL5",
    ["静止陷阱眩晕"] = "BTL6"
}
____exports["树魔首领Buff表"] = {
    [____exports["树魔首领BuffID"]["兽群号令"]] = {
        buffID = ____exports["树魔首领BuffID"]["兽群号令"],
        buffName = "兽群号令",
        icon = "BuffIcon\\Boss\\TreeLord\\pack_command.blp",
        effect = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl",
        effectMode = "attach",
        effectAttachPoint = "origin",
        type = "Buff:boss:stack",
        interval = 0,
        maxStack = 4,
        stackRule = "stack",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 84,
        canPurge = false,
        tooltip = "每1个存活的树魔首领随从使Boss按基准攻击力（当前攻击力减去本Buff已有增量）额外增加20%攻击力；最多4层=80%，每1.5秒按存活数量重算，随从死亡或入场会同步增减层数。"
    },
    [____exports["树魔首领BuffID"]["无从暴怒"]] = {
        buffID = ____exports["树魔首领BuffID"]["无从暴怒"],
        buffName = "无从暴怒",
        icon = "BuffIcon\\Boss\\TreeLord\\minionless_rage.blp",
        effect = "",
        type = "Buff:boss:rage",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 88,
        canPurge = false,
        tooltip = "场上没有任何自身随从时，树魔首领获得额外攻速+100%，并获得等于默认移动速度×50%的额外移速；新随从入场后立即移除，Buff每1.5秒刷新。"
    },
    [____exports["树魔首领BuffID"]["古树衰弱"]] = {
        buffID = ____exports["树魔首领BuffID"]["古树衰弱"],
        buffName = "古树衰弱",
        icon = "BuffIcon\\Boss\\TreeLord\\ancient_weakness.blp",
        effect = "",
        type = "Debuff:attack",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 2,
        priority = 62,
        canPurge = true,
        tooltip = "被扩散冲击波命中后，普通攻击造成的最终伤害降低40%，持续7秒；技能伤害不受此效果影响。"
    },
    [____exports["树魔首领BuffID"]["远古诅咒"]] = {
        buffID = ____exports["树魔首领BuffID"]["远古诅咒"],
        buffName = "远古诅咒",
        icon = "BuffIcon\\Boss\\TreeLord\\ancient_curse.blp",
        effect = "Common\\Effect\\Form\\Aura\\LightningAura.mdx",
        effectMode = "attach",
        effectAttachPoint = "origin",
        effectScale = 2,
        type = "Debuff:magic",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 2,
        priority = 78,
        canPurge = true,
        tooltip = "点名后持续3秒；结算时第一段总伤害=点名目标当前生命值×（60%+20%×N），N为当前有效玩家人数且至少按1人计算。点名目标与其400码内有效玩家均分总伤害，无其他玩家时由点名目标独自承受；第一段后每名有效玩家恢复等于该总伤害的生命值。N≥2时，1.8秒后在玩家中心650码内受到Boss当前攻击力×300%+目标最大生命值×10%的第二段伤害。"
    },
    [____exports["树魔首领BuffID"]["治疗枯竭"]] = {
        buffID = ____exports["树魔首领BuffID"]["治疗枯竭"],
        buffName = "治疗枯竭",
        icon = "BuffIcon\\Boss\\TreeLord\\healing_exhaustion.blp",
        effect = "",
        type = "Debuff:magic:heal",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 2,
        priority = 66,
        canPurge = true,
        tooltip = "生命陷阱每1秒刷新一次；每次获得1.4秒治疗修正，受到的治疗量降低50%+难度等级×5%（难度1/2/3分别为55%/60%/65%，更高难度继续按公式增加）。"
    },
    [____exports["树魔首领BuffID"]["静止陷阱眩晕"]] = {
        buffID = ____exports["树魔首领BuffID"]["静止陷阱眩晕"],
        buffName = "静止陷阱眩晕",
        icon = "BuffIcon\\Boss\\TreeLord\\stasis_stun.blp",
        effect = "Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl",
        effectMode = "attach",
        effectAttachPoint = "overhead",
        type = "Debuff:control",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 82,
        canPurge = false,
        tooltip = "进入静止陷阱600码范围后等待0.75秒触发；触发后所有有效玩家获得无视韧性的眩晕8秒。"
    }
}
____exports.default = ____exports["树魔首领Buff表"]
return ____exports
