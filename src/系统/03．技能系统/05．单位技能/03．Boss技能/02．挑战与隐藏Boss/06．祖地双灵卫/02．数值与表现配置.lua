--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 当前只登记设计稿中已经明确的时间与数量关系。
-- 伤害倍率、单位 ID、动画和特效路径等待模型与实际场地确认后填写。
____exports["祖地双灵卫数值与表现配置"] = {
    ["公共"] = {
        ["双灵同誓触发生命差"] = 0.15,
        ["双灵同誓解除生命差"] = 0.1,
        ["大型技能最小错开秒"] = 2.5,
        ["普通技能最小间隔秒"] = 8,
        ["普通技能最大间隔秒"] = 11,
        ["同誓低血减伤比例"] = 0.55,
        ["同誓高血分担比例"] = 0.25,
        ["同誓检查间隔秒"] = 0.2,
        ["P2最短持续秒"] = 20,
        ["P2首名变异者推进P3生命比例"] = 0.35,
        ["P3每层共鸣减伤比例"] = 0.08,
        ["同息回灌恢复比例"] = 0.22
    },
    P1 = {
        ["灵印折步"] = {
            ["冷却秒"] = 9,
            ["前摇秒"] = 0.55,
            ["位移距离"] = 420,
            ["镇魂印半径"] = 250,
            ["镇魂印持续秒"] = 4,
            ["动画编号"] = 4,
            ["恢复动画编号"] = 7,
            ["伤害攻击力比例"] = 0.3,
            ["伤害目标最大生命比例"] = 0.01
        },
        ["月纹缚魂"] = {
            ["冷却秒"] = 11,
            ["预警秒"] = 1.2,
            ["半径"] = 260,
            ["动画编号"] = 4,
            ["恢复动画编号"] = 7,
            ["伤害攻击力比例"] = 0.8,
            ["伤害目标最大生命比例"] = 0.03,
            ["硬直秒"] = 0.7
        },
        ["誓锋壁进"] = {
            ["冷却秒"] = 9,
            ["前摇秒"] = 0.8,
            ["最大推进场地比例"] = 0.5,
            ["最大推进距离"] = 650,
            ["路径宽度"] = 190,
            ["推进秒"] = 0.65,
            ["誓盾持续秒"] = 3,
            ["誓盾宽度"] = 380,
            ["动画编号"] = 8,
            ["举盾动画编号"] = 7,
            ["恢复动画编号"] = 0,
            ["伤害攻击力比例"] = 1.05,
            ["伤害目标最大生命比例"] = 0.03
        },
        ["盾刃裁决"] = {
            ["冷却秒"] = 10,
            ["两段间隔秒"] = 0.7,
            ["扇形半径"] = 430,
            ["扇形角度"] = 85,
            ["直线长度"] = 560,
            ["直线宽度"] = 140,
            ["盾击动画编号"] = 11,
            ["重斩动画编号"] = 5,
            ["恢复动画编号"] = 0,
            ["盾击伤害攻击力比例"] = 0.8,
            ["重斩伤害攻击力比例"] = 1.15,
            ["单段目标最大生命比例"] = 0.025
        },
        ["封门校验"] = {["最小周期秒"] = 22, ["最大周期秒"] = 26}
    },
    P2 = {
        ["断誓践踏"] = {
            ["冷却秒"] = 10,
            ["踏步次数"] = 2,
            ["每步距离"] = 360,
            ["落点半径"] = 280,
            ["两步间隔秒"] = 0.7,
            ["第二步预警秒"] = 0.85,
            ["压制硬直秒"] = 4,
            ["魂裂持续秒"] = 2,
            ["动画编号"] = 5,
            ["恢复动画编号"] = 1,
            ["伤害攻击力比例"] = 1.15,
            ["伤害目标最大生命比例"] = 0.035
        },
        ["裂魂坠斩"] = {
            ["冷却秒"] = 11,
            ["前摇秒"] = 1,
            ["余震延迟秒"] = 0.8,
            ["扇形半径"] = 480,
            ["扇形角度"] = 90,
            ["余震长度"] = 620,
            ["余震宽度"] = 150,
            ["动画编号"] = 5,
            ["恢复动画编号"] = 1,
            ["重斩伤害攻击力比例"] = 1.25,
            ["余震伤害攻击力比例"] = 0.8,
            ["单段目标最大生命比例"] = 0.03
        },
        ["失名祷潮"] = {
            ["冷却秒"] = 10,
            ["预警秒"] = 1.1,
            ["长度"] = 850,
            ["宽度"] = 230,
            ["压制硬直秒"] = 4,
            ["动画编号"] = 7,
            ["恢复动画编号"] = 1,
            ["伤害攻击力比例"] = 1.1,
            ["伤害目标最大生命比例"] = 0.04
        },
        ["记忆剥落"] = {
            ["冷却秒"] = 11,
            ["预警秒"] = 1.2,
            ["持续秒"] = 3,
            ["同时存在上限"] = 2,
            ["半径"] = 280,
            ["检查间隔秒"] = 0.25,
            ["动画编号"] = 7,
            ["恢复动画编号"] = 1,
            ["每跳攻击力比例"] = 0.18,
            ["每跳目标最大生命比例"] = 0.006
        },
        ["压制组合最小周期秒"] = 16,
        ["压制组合最大周期秒"] = 20
    },
    P3 = {
        ["净化节点数量"] = 3,
        ["节点中心偏移半径"] = 720,
        ["节点判定半径"] = 260,
        ["校准阶段窗口秒"] = 8,
        ["净化成功硬直秒"] = 4,
        ["失败重试冷却秒"] = 2.5,
        ["封门误判预警秒"] = 1.4,
        ["封门误判安全通道半宽"] = 180,
        ["封门误判伤害攻击力比例"] = 1.4,
        ["封门误判目标最大生命比例"] = 0.08,
        ["净化后易伤比例"] = 0.12,
        ["净化后易伤秒"] = 5
    },
    ["动作"] = {
        ["赤誓正常待机"] = 7,
        ["赤誓消散"] = 11,
        ["苍影正常待机"] = 0,
        ["苍影举盾"] = 7,
        ["苍影举盾行走"] = 8,
        ["苍影举盾攻击"] = 11,
        ["裂誓待机"] = 1,
        ["裂誓横斩"] = 4,
        ["裂誓下劈"] = 5,
        ["裂誓举剑"] = 8,
        ["裂誓持续引导"] = 9,
        ["裂誓消散"] = 10,
        ["无面待机"] = 1,
        ["无面突刺"] = 5,
        ["无面劈砍"] = 6,
        ["无面施法"] = 7
    },
    ["表现资源"] = {
        ["誓约主色"] = {R = 220, G = 174, B = 78},
        ["灵识主色"] = {R = 105, G = 185, B = 235},
        ["净化主色"] = {R = 225, G = 240, B = 255},
        ["侵蚀主色"] = {R = 45, G = 66, B = 78},
        ["路径规则"] = "填写游戏内模型路径，不带imports前缀；形状预警默认走提示圈工厂。",
        ["公共"] = {
            ["双灵同誓连线特效路径"] = "Common\\Effect\\Form\\Line\\AinzAlbedoGuardianLink.mdx",
            ["低血守卫保护特效路径"] = "Common\\Effect\\Form\\Shield\\holyshield_state.mdx",
            ["赤誓变异转化特效路径"] = "Common\\Effect\\Form\\Explosion\\AlbedoDarkGoldBarrierBreak.mdx",
            ["苍影变异转化特效路径"] = "Common\\Effect\\Form\\Spread\\AronkosAwakeningSoulWave.mdx",
            ["P3污染共鸣连线特效路径"] = "Common\\Effect\\Form\\Line\\DeathWave.mdx",
            ["灵魂崩解特效路径"] = "Common\\Effect\\Form\\RiseFall\\AronkosDefeatDissolve.mdx",
            ["最终净化归静特效路径"] = "Common\\Effect\\Form\\RiseFall\\AronkosSoulReleasePillar.mdx"
        },
        ["誓锋壁进"] = {["推进拖尾特效路径"] = "Common\\Effect\\Form\\Aura\\long.MDX", ["定向誓盾特效路径"] = "Common\\Effect\\Form\\Shield\\AlbedoDarkGoldBarrier.mdx", ["冲锋命中特效路径"] = "Common\\Effect\\Form\\Explosion\\AlbedoDarkGoldHeavyImpact.mdx"},
        ["盾刃裁决"] = {["盾击命中特效路径"] = "Common\\Effect\\Form\\Explosion\\AlbedoDarkGoldHeavyImpact.mdx", ["剑刃重斩特效路径"] = "Common\\Effect\\Form\\Line\\AronkosSoulSlashImpact.mdx"},
        ["灵印折步"] = {["消失特效路径"] = "Common\\Effect\\Form\\Spread\\AronkosAwakeningSoulWave.mdx", ["出现特效路径"] = "Common\\Effect\\Form\\RiseFall\\AronkosSoulRiseRing.mdx", ["镇魂印地面特效路径"] = "Common\\Effect\\Form\\MagicCircle\\SpiritGuardSoulSeal.mdx"},
        ["月纹缚魂"] = {["月纹地面特效路径"] = "Common\\Effect\\Form\\Debuff\\SpiritGuardMoonBind.mdx", ["禁锢生效特效路径"] = "Common\\Effect\\Form\\RiseFall\\AronkosSoulLightPillar.mdx"},
        ["封门校验"] = {["半场灵魂潮特效路径"] = "Common\\Effect\\Form\\Line\\DeathWave.mdx", ["誓盾阻挡特效路径"] = "Common\\Effect\\Form\\Explosion\\AlbedoDarkGoldBarrierBreak.mdx"},
        ["断誓践踏"] = {["践踏落地特效路径"] = "Common\\Effect\\Form\\Explosion\\dustwave.mdx", ["短时魂裂特效路径"] = "Common\\Effect\\Form\\Explosion\\AronkosGraveDustWhirl.mdx", ["镇魂压制特效路径"] = "Common\\Effect\\Form\\MagicCircle\\SpiritGuardSoulSeal.mdx"},
        ["裂魂坠斩"] = {["重斩拖尾特效路径"] = "Common\\Effect\\Form\\Line\\AronkosSoulSlashVolley.mdx", ["扇形落地特效路径"] = "Common\\Effect\\Form\\Explosion\\dustwave.mdx", ["直线余震特效路径"] = "Common\\Effect\\Form\\Line\\BansheeGrayShockwave.mdx"},
        ["失名祷潮"] = {["牵魂连线特效路径"] = "Common\\Effect\\Form\\Line\\AinzAlbedoGuardianLink.mdx", ["祷潮蓄势特效路径"] = "Common\\Effect\\Form\\Aura\\AronkosGraveSoulField.mdx", ["定向灵魂潮特效路径"] = "Common\\Effect\\Form\\Line\\DeathWave.mdx", ["断线与挡潮特效路径"] = "Common\\Effect\\Form\\Explosion\\AlbedoDarkGoldBarrierBreak.mdx"},
        ["记忆剥落"] = {["褪色预警特效路径"] = "Common\\Effect\\Form\\MagicCircle\\SpiritGuardSoulSeal.mdx", ["空白灵域地面特效路径"] = "Common\\Effect\\Form\\Aura\\AronkosGraveSoulField.mdx", ["空白灵域动态层特效路径"] = "Common\\Effect\\Form\\Spread\\AronkosAwakeningSoulWave.mdx"},
        ["双钥净化"] = {["节点污染外壳特效路径"] = "Common\\Effect\\Form\\Shield\\YellowOrbShield.mdx", ["节点破壳特效路径"] = "Common\\Effect\\Form\\Explosion\\CorruptionShieldBreak.mdx", ["节点校准特效路径"] = "Common\\Effect\\Form\\MagicCircle\\SpiritGuardSoulSeal.mdx", ["节点净化完成特效路径"] = "Common\\Effect\\Form\\RiseFall\\AronkosSoulReleasePillar.mdx"},
        ["封门误判"] = {["入侵区域覆盖特效路径"] = "Common\\Effect\\Form\\Aura\\AronkosGraveSoulField.mdx", ["月白安全通道特效路径"] = "Common\\Effect\\Form\\Line\\AronkosSoulSlashTrail.mdx", ["封门中心砸击特效路径"] = "Common\\Effect\\Form\\Explosion\\dustwave.mdx", ["净化反射特效路径"] = "Common\\Effect\\Form\\RiseFall\\AronkosSoulReleaseAux.mdx"},
        ["特效资源已填完整"] = true,
        ["音效路径待填"] = true
    }
}
return ____exports
