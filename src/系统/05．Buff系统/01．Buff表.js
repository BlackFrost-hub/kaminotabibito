// 自动生成 - Buff数据表
// 生成时间: 2026/3/29 17:41:20
export const buffs = {
    "D001": {
        buffID: "D001",
        buffName: "反恢复",
        icon: "ReplaceableTextures\\CommandButtons\\BTNLifeDrain.blp",
        effect: "Abilities\\Spells\\NightElf\\CorrosiveBreath\\ChimaeraAcidTargetArt.mdl",
        type: "Debuff:dot",
        interval: 1,
        maxStack: 1,
        stackRule: 'highest',
        stackRefresh: true,
        dispelLevel: 1,
        priority: 7,
        canPurge: true,
        tooltip: "该单位受到了『反恢复』，在持续时间秒内每1秒造成damage点精神伤害。"
    },
    "D002": {
        buffID: "D002",
        buffName: "燃烧",
        icon: "BuffIcon\\DotRanShao.blp",
        effect: "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeDamageTarget.mdl",
        type: "Debuff:dot",
        interval: 1,
        maxStack: 1,
        stackRule: 'highest',
        stackRefresh: true,
        dispelLevel: 1,
        priority: 5,
        canPurge: true,
        tooltip: "该单位受到了『燃烧』，在持续时间秒内每1秒造成damage点火属性伤害。"
    },
    "D003": {
        buffID: "D003",
        buffName: "中毒",
        icon: "BuffIcon\\Dotzhongdu.blp",
        effect: "Abilities\\Weapons\\PoisonSting\\PoisonStingTarget.mdl",
        type: "Debuff:dot",
        interval: 1,
        maxStack: 1,
        stackRule: 'highest',
        stackRefresh: true,
        dispelLevel: 1,
        priority: 5,
        canPurge: true,
        tooltip: "该单位受到了『中毒』，在持续时间秒内每1秒造成damage点金属性伤害。"
    },
    "D004": {
        buffID: "D004",
        buffName: "巨魔头颅诅咒",
        icon: "BuffIcon\\Dot3jumotoulu.blp",
        effect: "Abilities\\Weapons\\PoisonSting\\PoisonStingTarget.mdl",
        type: "Debuff:dot",
        interval: 1,
        maxStack: 1,
        stackRule: 'highest',
        stackRefresh: true,
        dispelLevel: 1,
        priority: 5,
        canPurge: true,
        tooltip: "该单位受到了『巨魔头颅诅咒』，在持续时间秒内每1秒造成damage点物理伤害。"
    },
};
export default buffs;
