local ____lualib = require("lualib_bundle")
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置")
local _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID = ____require_result_1["按名字反查玩家英雄单位ID"]
local ____require_result_2 = require("系统.03．技能系统.08．技能数据表.01．技能名反查")
local _____6309_540D_5B57_53CD_67E5_6280_80FDID = ____require_result_2["按名字反查技能ID"]
local _____82F1_96C4_540D = "黑崎一护"
local ____Q_6280_80FD_540D = "YH-月牙天冲（Q）"
local ____R_6280_80FD_540D = "YH-解放（R）"
local ____D_6280_80FD_540D = "YH瞬步（D）"
local ____T_6280_80FD_540D = "YH地蹦裂击（T）"
local ____W_6280_80FD_540D = "YH灵压爆发（W）"
local ____E_6280_80FD_540D = "YH瞬步斩（E）"
local _____82F1_96C4_5355_4F4DID = _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID(_____82F1_96C4_540D) or _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID("死神")
local ____Q_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID(____Q_6280_80FD_540D) or "A01G"
local ____R_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID(____R_6280_80FD_540D) or "A01H"
local ____D_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID(____D_6280_80FD_540D) or "A01I"
local ____T_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID(____T_6280_80FD_540D) or "A01J"
local ____W_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID(____W_6280_80FD_540D) or "A01K"
local ____E_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID(____E_6280_80FD_540D) or "A01L"
if _____82F1_96C4_5355_4F4DID == nil or _____82F1_96C4_5355_4F4DID == "" then
    error(
        __TS__New(Error, "无法反查英雄单位ID：" .. _____82F1_96C4_540D),
        0
    )
end
____exports["黑崎一护技能配置"] = {
    ["英雄名"] = _____82F1_96C4_540D,
    ["单位ID"] = _____82F1_96C4_5355_4F4DID,
    ["单位类型ID"] = stringToFourCCSafe(_____82F1_96C4_5355_4F4DID),
    Q = {
        ["技能ID"] = ____Q_6280_80FDID,
        ["技能类型ID"] = stringToFourCCSafe(____Q_6280_80FDID),
        ["物编冷却秒"] = 8,
        ["射程码"] = 1500,
        ["推进间隔秒"] = 0.02,
        ["每Tick距离"] = 30,
        ["最大推进次数"] = 50,
        ["碰撞半径"] = 200,
        ["未解放"] = {
            ["伤害攻击力倍率"] = 2.5,
            ["音效"] = {["路径"] = "war3mapImported\\yueyatianchongyinxiao.mp3", ["裁断距离"] = 2000},
            ["弹道模型"] = "Abilities\\Weapons\\WingedSerpentMissile\\WingedSerpentMissile.mdl",
            ["弹道缩放"] = 5,
            ["弹道高度"] = 220,
            ["弹道X轴角度"] = -90,
            ["拖尾模型"] = "Abilities\\Weapons\\Bolt\\BoltImpact.mdl",
            ["拖尾缩放"] = 2,
            ["拖尾高度"] = 160,
            ["拖尾持续秒"] = 0.3,
            ["拖尾副模型"] = "Abilities\\Weapons\\GryphonRiderMissile\\GryphonRiderMissile.mdl",
            ["拖尾副持续秒"] = 0.02
        },
        ["解放后"] = {
            ["伤害攻击力倍率"] = 3.5,
            ["音效"] = {["路径"] = "war3mapImported\\YH-yueya.mp3", ["裁断距离"] = 2000},
            ["弹道模型"] = "war3mapImported\\!blackgetsuga!.mdl",
            ["弹道缩放"] = 2,
            ["弹道高度"] = 240,
            ["弹道X轴角度"] = -90,
            ["拖尾模型"] = "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosDone.mdl",
            ["拖尾缩放"] = 1.8,
            ["拖尾高度"] = 160,
            ["拖尾持续秒"] = 0.3,
            ["拖尾副模型"] = "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl",
            ["拖尾副缩放"] = 1.8,
            ["拖尾副持续秒"] = 0.3,
            ["虚影模型"] = "Abilities\\Spells\\Undead\\CarrionSwarm\\CarrionSwarmDamage.mdl",
            ["虚影缩放"] = 1.5,
            ["虚影高度"] = 240,
            ["无视护甲"] = true
        }
    },
    W = {
        ["技能ID"] = ____W_6280_80FDID,
        ["技能类型ID"] = stringToFourCCSafe(____W_6280_80FDID),
        ["物编冷却秒"] = 10,
        ["半径码"] = 400,
        ["伤害攻击力倍率"] = 1.75,
        ["音效"] = {["路径"] = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.wav", ["裁断距离"] = 2000},
        ["主特效"] = {["模型"] = "war3mapImported\\Whine.mdl", ["缩放"] = 2, ["持续秒"] = 2},
        ["爆发特效"] = {["模型"] = "war3mapImported\\TX25.mdl", ["缩放"] = 0.15, ["持续秒"] = 2},
        ["普通"] = {["眩晕秒"] = 2, ["击退总距离"] = 300},
        ["连携"] = {["眩晕秒"] = 3, ["击退总距离"] = 500, ["击退持续时间秒"] = 0.4, ["附加特效"] = {["模型"] = "war3mapImported\\!orbitalray2!.mdl", ["缩放"] = 4, ["持续秒"] = 2}}
    },
    E = {
        ["技能ID"] = ____E_6280_80FDID,
        ["技能类型ID"] = stringToFourCCSafe(____E_6280_80FDID),
        ["物编冷却秒"] = 13,
        ["音效"] = {["路径"] = "HeroVoice\\ichigo\\yh-w.mp3", ["裁断距离"] = 1500},
        ["金属音效"] = {["路径"] = "Sound\\Units\\Combat\\MetalMediumSliceWood1.wav", ["裁断距离"] = 1500},
        ["普通"] = {
            ["斩击间隔秒"] = 0.15,
            ["斩击次数"] = 10,
            ["斩击半径"] = 425,
            ["单次伤害攻击力倍率"] = 0.1,
            ["减速比例"] = 0.2,
            ["减速持续秒"] = 0.4,
            ["斩击特效"] = {["模型"] = "Common\\Effect\\Form\\Line\\coarse slash blue.mdx", ["缩放"] = 1.75, ["持续秒"] = 1},
            ["斩击音效"] = {["路径"] = "YX\\DJYX01.wav", ["裁断距离"] = 1500},
            ["结束"] = {
                ["伤害攻击力倍率"] = 1.2,
                ["眩晕秒"] = 1.5,
                ["特效模型"] = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",
                ["特效缩放"] = 2,
                ["特效持续秒"] = 1,
                ["音效"] = {["路径"] = "war3mapImported\\shenlei01.mp3", ["裁断距离"] = 2000}
            }
        },
        ["连携"] = {
            ["目标选取半径"] = 200,
            ["幻影半径"] = 240,
            ["幻影数量"] = 6,
            ["幻影模型"] = "war3mapImported\\Ichigo.mdl",
            ["幻影缩放"] = 1.3,
            ["幻影高度"] = 135,
            ["幻影透明度"] = 125,
            ["幻影施法动画索引"] = 4,
            ["起手眩晕秒"] = 2,
            ["冲锋延迟秒"] = 0.2,
            ["推进间隔秒"] = 0.03,
            ["每Tick距离"] = 30,
            ["最大推进次数"] = 20,
            ["命中判定半径"] = 150,
            ["单次伤害攻击力倍率"] = 0.6,
            ["命中特效解放前"] = {["模型"] = "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", ["缩放"] = 1.5, ["持续秒"] = 2, ["高度"] = 50},
            ["命中特效解放后"] = {["模型"] = "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl", ["缩放"] = 1.5, ["持续秒"] = 2, ["高度"] = 50},
            ["起手特效"] = {["模型"] = "Abilities\\Spells\\Items\\AIvi\\AIviTarget.mdl", ["缩放"] = 1, ["持续秒"] = 1},
            ["结束"] = {["魔法扣除最大比例"] = 0.2, ["鲜血爆炸模型"] = "war3mapImported\\CrimsonWake.mdl", ["鲜血爆炸持续秒"] = 1.2}
        }
    },
    D = {
        ["技能ID"] = ____D_6280_80FDID,
        ["技能类型ID"] = stringToFourCCSafe(____D_6280_80FDID),
        ["物编冷却秒"] = 5,
        ["音效"] = {["路径"] = "YX\\DJ10.mp3", ["裁断距离"] = 2000},
        ["基础距离"] = 450,
        ["每千魔法加成距离"] = 50,
        ["冲锋持续时间秒"] = 0.05,
        ["连携窗口秒"] = 2
    },
    T = {
        ["技能ID"] = ____T_6280_80FDID,
        ["技能类型ID"] = stringToFourCCSafe(____T_6280_80FDID),
        ["物编冷却秒"] = 30,
        ["半径码"] = 500,
        ["准备第一延迟秒"] = 0.15,
        ["准备第二延迟秒"] = 0.6,
        ["硬直持续秒"] = 3.5,
        ["动作索引"] = 8,
        ["受伤减少比例"] = 0.5,
        ["周期"] = {
            ["间隔秒"] = 0.5,
            ["次数"] = 6,
            ["减速比例"] = 0.9,
            ["减速持续秒"] = 1,
            ["踩地特效"] = {["模型"] = "war3mapImported\\stomp.mdl", ["缩放"] = 3, ["持续秒"] = 2},
            ["裂地特效"] = {["模型"] = "war3mapImported\\~t_cleave.mdl", ["缩放"] = 2, ["持续秒"] = 2}
        },
        ["卍解免打断血量阈值"] = 0.5
    },
    R = {
        ["技能ID"] = ____R_6280_80FDID,
        ["技能类型ID"] = stringToFourCCSafe(____R_6280_80FDID),
        ["物编冷却秒"] = 65,
        ["持续秒"] = 30,
        ["移速"] = 666,
        ["起手音效"] = {["路径"] = "war3mapImported\\0000YHR1.mp3", ["裁断距离"] = 2500},
        ["卍解延迟秒"] = 0.98,
        ["卍解音效"] = {["路径"] = "war3mapImported\\0000YHR2.mp3", ["裁断距离"] = 2500},
        ["卍解特效"] = {["模型"] = "war3mapImported\\chaosexplosion.mdl", ["缩放"] = 1.1, ["持续秒"] = 2, ["高度"] = 40}
    },
    ["黑流牙突"] = {
        ["最小距离码"] = 500,
        ["最大距离码"] = 1200,
        ["标记持续秒"] = 5,
        ["出生偏移码"] = 75,
        ["特效模型"] = "Abilities\\Spells\\Other\\BlackArrow\\BlackArrowMissile.mdl",
        ["特效缩放"] = 3,
        ["特效高度"] = 135,
        ["推进间隔秒"] = 0.02,
        ["每Tick距离"] = 30,
        ["最大推进次数"] = 50,
        ["命中半径码"] = 150,
        ["推进特效"] = {["模型"] = "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl", ["持续秒"] = 0.05},
        ["命中特效"] = {
            ["模型"] = "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl",
            ["缩放"] = 1.5,
            ["持续秒"] = 2,
            ["高度"] = 135,
            ["面向角度"] = 270
        },
        ["基础伤害倍率"] = 1.2,
        ["每级伤害加成"] = 0.02
    },
    ["被动"] = {["Q冷却缩减秒"] = 0.55, ["Q冷却剩余阈值秒"] = 0.5},
    ["暂停来源"] = {["T施法硬直"] = "黑崎一护-T地蹦裂击-施法硬直"}
}
____exports.default = ____exports["黑崎一护技能配置"]
return ____exports
