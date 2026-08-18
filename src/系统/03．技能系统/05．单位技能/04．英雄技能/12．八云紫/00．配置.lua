--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local function _____56DB_4F4D_7801(value)
    return stringToFourCCSafe(value)
end
____exports["八云紫单位技能配置"] = {
    ["英雄名"] = "八云紫",
    ["单位"] = {
        ["英雄ID"] = "H00P",
        ["英雄类型ID"] = _____56DB_4F4D_7801("H00P"),
        ["裂隙ID"] = "e07I",
        ["裂隙类型ID"] = _____56DB_4F4D_7801("e07I"),
        ["临时裂隙ID"] = "e07J",
        ["临时裂隙类型ID"] = _____56DB_4F4D_7801("e07J")
    },
    ["技能"] = {
        D = {
            ID = "A0FS",
            ["类型ID"] = _____56DB_4F4D_7801("A0FS")
        },
        R = {
            ID = "A0FT",
            ["类型ID"] = _____56DB_4F4D_7801("A0FT")
        },
        W = {
            ID = "A0FU",
            ["类型ID"] = _____56DB_4F4D_7801("A0FU")
        },
        Q = {
            ID = "A0FV",
            ["类型ID"] = _____56DB_4F4D_7801("A0FV")
        },
        E = {
            ID = "A0FW",
            ["类型ID"] = _____56DB_4F4D_7801("A0FW")
        },
        ["E出现"] = {
            ID = "A0FX",
            ["类型ID"] = _____56DB_4F4D_7801("A0FX")
        }
    },
    ["裂隙"] = {
        ["放置距离"] = 850,
        ["移动步长"] = 25,
        ["展开范围"] = 175,
        ["展开伤害攻击力比例"] = 0.6,
        ["二次命中窗口秒"] = 3,
        ["二次命中额外倍率"] = 2,
        ["二次命中眩晕秒"] = 1,
        ["附近检测范围"] = 1200,
        ["短期持续秒"] = 10,
        ["长期持续秒"] = 360,
        ["最多长期裂隙"] = 5,
        ["扩散触发半径"] = 75,
        ["扩散冷却秒"] = 0.8,
        ["扩散生命消耗比例"] = 0.2,
        ["出现特效"] = "war3mapImported\\Fireworkspurple.mdl",
        ["出现特效缩放"] = 3,
        ["出现特效高度"] = 26,
        ["出现特效持续秒"] = 1.5,
        ["冲击特效"] = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl",
        ["冲击特效持续秒"] = 1.5,
        ["二次特效"] = {"war3mapImported\\DarkSwirl.mdl", "war3mapImported\\DevilSlam.mdx"}
    },
    Q = {
        ["硬直秒"] = 1.1,
        ["普通弹幕数量"] = 6,
        ["普通角度偏移"] = {
            0,
            10,
            -10,
            20,
            -20,
            0
        },
        ["普通创建距离"] = {
            60,
            -10,
            -10,
            -70,
            -70,
            -70
        },
        ["普通速度"] = 1237.5,
        ["强化速度"] = 1320,
        ["飞行距离"] = 1200,
        ["生命周期秒"] = 0.96,
        ["普通半径"] = 95,
        ["强化半径"] = 150,
        ["指定裂隙强化半径"] = 140,
        ["强化判定延迟秒"] = 0.12,
        ["强化最短飞行距离"] = 160,
        ["普通高度"] = 120,
        ["强化高度"] = 135,
        ["普通缩放"] = 0.85,
        ["强化缩放"] = 1.5,
        ["基础伤害攻击力比例"] = 0.5,
        ["裂隙扩散倍率"] = 2.5,
        ["指定裂隙倍率"] = 2,
        ["指定裂隙波数"] = 3,
        ["指定裂隙波间隔秒"] = 0.5,
        ["模型"] = "Abilities\\Spells\\Undead\\OrbOfDeath\\OrbOfDeathMissile.mdl",
        ["自动追踪裂隙范围"] = 300,
        ["普通起手音效键"] = "gg_snd_tan2",
        ["普通语音键"] = {"gg_snd_YakumoYukari_Q1", "gg_snd_YakumoYukari_Q2", "gg_snd_YakumoYukari_Q3"},
        ["指定裂隙语音键"] = {"gg_snd_YakumoYukari_Q21", "gg_snd_YakumoYukari_Q22", "gg_snd_YakumoYukari_Q23"},
        ["裂隙爆发音效键"] = "gg_snd_tan",
        ["裂隙触发音效键"] = "gg_snd_tan2"
    },
    W = {
        ["裂隙数量"] = 4,
        ["每裂隙弹幕数"] = 5,
        ["发射间隔秒"] = 0.33,
        ["裂隙持续秒"] = 1.65,
        ["裂隙清理宽限秒"] = 0.05,
        ["无目标后方距离"] = 250,
        ["横向起点距离"] = 250,
        ["横向间距"] = 125,
        ["指定目标裂隙半径"] = 500,
        ["普通伤害攻击力比例"] = 0.3,
        ["指定目标已损失生命比例"] = 0.05,
        ["周围伤害范围"] = 500,
        ["周围伤害攻击力比例"] = 3,
        ["结算特效"] = "war3mapImported\\[AKE]war3AKE.com - 2384448388546355503762198.mdl",
        ["结算特效高度"] = 233,
        ["无目标语音键"] = {"gg_snd_YakumoYukari_W3", "gg_snd_YakumoYukari_W4", "gg_snd_YakumoYukari_W5"},
        ["指定目标语音键"] = {"gg_snd_YakumoYukari_W1", "gg_snd_YakumoYukari_W6", "gg_snd_YakumoYukari_W2"}
    },
    E = {
        ["最大间隙秒"] = 1.6,
        ["检查间隔毫秒"] = 50,
        ["裂隙搜索范围"] = 250,
        ["友方前置延迟秒"] = 0.15,
        ["友方消失延迟秒"] = 0.3,
        ["最终范围"] = 450,
        ["最终伤害攻击力比例"] = 4,
        ["敌方额外伤害攻击力比例"] = 2,
        ["敌方已损失生命比例"] = 0.05,
        ["敌方眩晕秒"] = 1,
        ["敌方背后距离"] = 100,
        ["敌方阻挡回退距离"] = 33,
        ["自身额外减冷却比例"] = 0.3,
        ["裂隙额外减冷却比例"] = 0.3,
        ["友方额外减冷却比例"] = 0.2,
        ["隐藏缩放"] = 0.01,
        ["恢复缩放"] = 1.1,
        ["恢复索敌范围"] = 650,
        ["消失特效"] = "war3mapImported\\ArcaneBurst.mdx",
        ["消失特效缩放"] = 1.5,
        ["消失特效高度"] = 35,
        ["出现特效"] = "war3mapImported\\ancientexplodeblue.mdx",
        ["敌方结算特效"] = "war3mapImported\\dark execution.mdx",
        ["敌方结算特效缩放"] = 2,
        ["敌方结算特效速度"] = 2,
        ["敌方结算特效高度"] = 30,
        ["敌方结算特效持续秒"] = 2.5,
        BuffID = "YKR1",
        ["友方出现语音键"] = {"gg_snd_YakumoYukari_E32", "gg_snd_YakumoYukari_E31"},
        ["敌方出现语音键"] = "gg_snd_YakumoYukari_E4",
        ["主动出现语音键"] = {"gg_snd_YakumoYukari_ECX2", "gg_snd_YakumoYukari_ECX1"}
    },
    R = {
        ["裂隙选择范围"] = 400,
        ["无合法裂隙失败冷却秒"] = 5,
        ["主动二段窗口秒"] = 2,
        ["列车Tick毫秒"] = 40,
        ["列车每Tick距离"] = 20,
        ["列车Tick数"] = 50,
        ["命中范围"] = 175,
        ["伤害攻击力比例"] = 0.6,
        ["眩晕秒"] = 0.6,
        ["推动距离"] = 10,
        ["自动裂隙身后距离"] = 250,
        ["列车模型"] = "war3mapImported\\train1.mdl",
        ["列车缩放"] = 4,
        ["列车颜色"] = {255, 100, 255, 255},
        ["路径特效A"] = "war3mapImported\\DevilSlam.mdl",
        ["路径特效A缩放"] = 1.5,
        ["路径特效B"] = "war3mapImported\\StallordBreathMissile.mdx",
        ["路径特效B缩放"] = 4,
        ["路径特效持续秒"] = 1.1
    },
    D = {["硬直秒"] = 1.2, ["施法动作"] = "attack,2", ["展开音效键"] = {"gg_snd_kira", "gg_snd_SpellShieldImpact1"}}
}
return ____exports
