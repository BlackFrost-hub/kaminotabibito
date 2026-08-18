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
local _____82F1_96C4_540D = "云端"
local ____Q_6280_80FD_540D = "YD-冰火魔剑(Q)"
local ____W_6280_80FD_540D = "YD-光暗魔剑(W)"
local ____E_6280_80FD_540D = "YD-无双剑法（E）"
local ____R_6280_80FD_540D = "YD-暗黑制裁魔剑(R)"
local _____82F1_96C4_5355_4F4DID = _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID(_____82F1_96C4_540D)
local ____Q_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID(____Q_6280_80FD_540D) or "A0KN"
local ____W_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID(____W_6280_80FD_540D) or "A0KO"
local ____E_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID(____E_6280_80FD_540D) or "A0KP"
local ____R_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID(____R_6280_80FD_540D) or "A0KM"
if _____82F1_96C4_5355_4F4DID == nil or _____82F1_96C4_5355_4F4DID == "" then
    error(
        __TS__New(Error, "无法反查英雄单位ID：" .. _____82F1_96C4_540D),
        0
    )
end
____exports["云端技能配置"] = {
    ["英雄名"] = _____82F1_96C4_540D,
    ["单位ID"] = _____82F1_96C4_5355_4F4DID,
    ["单位类型ID"] = stringToFourCCSafe(_____82F1_96C4_5355_4F4DID),
    Q = {
        ["技能ID"] = ____Q_6280_80FDID,
        ["技能类型ID"] = stringToFourCCSafe(____Q_6280_80FDID),
        ["物编冷却秒"] = 12,
        ["施法距离码"] = 500,
        ["伤害公式"] = {["基础倍率"] = 1.5, ["每级加成"] = 0.1},
        ["硬直秒"] = 0.75,
        ["动作名"] = "Spell One",
        ["护场特效"] = {["模型"] = "war3mapImported\\finalfield.mdx", ["缩放"] = 3, ["持续秒"] = 1.5},
        ["火"] = {
            ["颜色"] = {["红"] = 255, ["绿"] = 0, ["蓝"] = 0, ["透明度"] = 255},
            ["音效"] = {["全局音效键"] = "gg_snd_effect_sound"},
            ["移动特效"] = {["模型"] = "Abilities\\Spells\\Other\\Doom\\DoomTarget.mdl", ["缩放"] = 5, ["高度"] = 25, ["持续秒"] = 0.5},
            ["命中特效"] = {["模型"] = "war3mapImported\\123.mdx", ["缩放"] = 2, ["高度"] = 25, ["持续秒"] = 2},
            ["灼烧"] = {["次数"] = 3, ["间隔秒"] = 1, ["单次比例"] = 0.1},
            ["灼烧挂点模型"] = "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeEmbers.mdl",
            ["灼烧挂点持续秒"] = 3
        },
        ["冰"] = {
            ["颜色"] = {["红"] = 20, ["绿"] = 20, ["蓝"] = 255, ["透明度"] = 255},
            ["移动特效"] = {["模型"] = "war3mapImported\\bluestrikearray.mdx", ["缩放"] = 2.5, ["高度"] = 25, ["持续秒"] = 2},
            ["命中特效"] = {["模型"] = "war3mapImported\\plazma_boom.mdx", ["缩放"] = 1.25, ["高度"] = 25, ["持续秒"] = 2},
            ["减速比例"] = 0.5,
            ["减速持续秒"] = 2
        },
        ["冲锋"] = {
            ["每Tick距离"] = 40,
            ["Tick间隔秒"] = 0.02,
            ["命中距离码"] = 85,
            ["动作索引"] = 2,
            ["移动音效"] = {["全局音效键"] = "gg_snd_effect_sound13"}
        },
        ["目标跳跃"] = {["距离"] = 1, ["持续时间秒"] = 0.4, ["跳跃高度"] = 400},
        ["摄像机震动强度"] = 30,
        ["震动清除延迟秒"] = 0.5
    },
    W = {
        ["技能ID"] = ____W_6280_80FDID,
        ["技能类型ID"] = stringToFourCCSafe(____W_6280_80FDID),
        ["物编冷却秒"] = 15,
        ["施法距离码"] = 800,
        ["伤害公式"] = {["攻击力倍率"] = 1.5, ["智力每级系数"] = 0.4},
        ["硬直秒"] = 0.75,
        ["时间流速"] = 1.75,
        ["动作名"] = "Spell Throw",
        ["路径"] = {
            ["启动延迟秒"] = 0.1,
            ["Tick间隔秒"] = 0.02,
            ["每Tick距离"] = 40,
            ["最大Tick数"] = 20,
            ["结算半径码"] = 350
        },
        ["光剑"] = {["起手特效"] = {["模型"] = "war3mapImported\\infernoarmor.mdx", ["缩放"] = 2.5, ["持续秒"] = 1.5}, ["护场颜色"] = {["红"] = 255, ["绿"] = 80, ["蓝"] = 0, ["透明度"] = 255}, ["路径特效"] = {{["模型"] = "war3mapImported\\skybomb.mdx", ["缩放"] = 3, ["高度"] = 25, ["持续秒"] = 1.5}, {["模型"] = "war3mapImported\\theholybomb.mdx", ["缩放"] = 2.5, ["高度"] = 25, ["持续秒"] = 1.5}, {["模型"] = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", ["缩放"] = 2, ["高度"] = 25, ["持续秒"] = 1.5}}, ["治疗比例"] = 0.35},
        ["暗剑"] = {["起手特效"] = {["模型"] = "war3mapImported\\arcanewave.mdx", ["缩放"] = 3, ["持续秒"] = 1.5}, ["护场颜色"] = {["红"] = 20, ["绿"] = 20, ["蓝"] = 255, ["透明度"] = 255}, ["路径特效"] = {{["模型"] = "war3mapImported\\darkpillar.mdx", ["缩放"] = 3, ["高度"] = 25, ["持续秒"] = 1.5}, {["模型"] = "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", ["缩放"] = 3, ["高度"] = 25, ["持续秒"] = 1.5}, {["模型"] = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", ["缩放"] = 2, ["高度"] = 25, ["持续秒"] = 1.5}}, ["眩晕秒"] = 1},
        ["护场特效"] = {["模型"] = "war3mapImported\\finalfield.mdx", ["缩放"] = 3, ["持续秒"] = 1.5}
    },
    E = {
        ["技能ID"] = ____E_6280_80FDID,
        ["技能类型ID"] = stringToFourCCSafe(____E_6280_80FDID),
        ["触发冷却秒"] = 8,
        ["增益持续秒"] = 4,
        ["音效"] = {["全局音效键"] = "gg_snd_effect_sound18"},
        ["洞察"] = {["每级暴击提升"] = 0.02, ["漂浮字"] = "无双一击"},
        ["破势"] = {["每级敏捷系数"] = 0.4, ["漂浮字"] = "趁胜追击"},
        ["御势"] = {["每级护甲提升"] = 3, ["漂浮字"] = "无所畏惧"},
        ["高生命阈值"] = 95,
        ["低生命阈值"] = 50,
        ["漂浮字"] = {["尺寸"] = 12, ["透明度"] = 51, ["上浮速度"] = 0.05, ["持续秒"] = 3}
    },
    R = {
        ["技能ID"] = ____R_6280_80FDID,
        ["技能类型ID"] = stringToFourCCSafe(____R_6280_80FDID),
        ["物编冷却秒"] = 36,
        ["施法距离码"] = 500,
        ["伤害公式"] = {["基础倍率"] = 2.5, ["每级加成"] = 0.5},
        ["硬直秒"] = 3,
        ["起手音效"] = {["全局音效键"] = "gg_snd_YD_R"},
        ["起手动作名"] = "Spell Channel",
        ["起手漂浮字"] = {
            ["文本"] = "魔攻↑",
            ["高度"] = 40,
            ["尺寸"] = 15,
            ["透明度"] = 51,
            ["上浮速度"] = 0.05,
            ["持续秒"] = 3
        },
        ["阶段"] = {
            ["第一段延迟秒"] = 0.75,
            ["第二段延迟秒"] = 0.5,
            ["升空准备延迟秒"] = 0.5,
            ["结算延迟秒"] = 0.5,
            ["敏捷保留秒"] = 5
        },
        ["冲刺"] = {
            ["第一段"] = {["距离"] = 400, ["持续时间秒"] = 0.4},
            ["第二段"] = {["基础距离"] = 200, ["持续时间秒"] = 0.4},
            ["动作名"] = "Spell Throw",
            ["第一段流速"] = 1.5,
            ["尾迹模型"] = "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl"
        },
        ["升空"] = {
            ["Tick间隔秒"] = 0.05,
            ["最大Tick数"] = 25,
            ["每Tick高度"] = 20,
            ["特效基础高度"] = 25,
            ["特效"] = {{["模型"] = "war3mapImported\\darkpillar.mdx", ["缩放"] = 3, ["高度"] = 25, ["持续秒"] = 1.5}, {["模型"] = "war3mapImported\\arcdirve02b.mdx", ["缩放"] = 3, ["持续秒"] = 2, ["跟随SS"] = true}, {["模型"] = "Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayTarget.mdl", ["缩放"] = 3, ["持续秒"] = 2, ["跟随SS"] = true}},
            ["震屏强度"] = 10
        },
        ["坠落"] = {
            ["表现模型"] = "Abilities\\Spells\\Other\\Doom\\DoomTarget.mdl",
            ["表现缩放"] = 1.5,
            ["表现高度"] = 400,
            ["表现持续秒"] = 2,
            ["跳跃"] = {["距离"] = 100, ["持续时间秒"] = 0.45, ["跳跃高度"] = 500},
            ["震屏强度"] = 45
        },
        ["眩晕秒"] = 1,
        ["飞行技能ID"] = "Amrf"
    },
    ["暂停来源"] = {["Q施法硬直"] = "云端-Q冰火魔剑-施法硬直", ["W施法硬直"] = "云端-W光暗魔剑-施法硬直", ["R施法硬直"] = "云端-R暗黑制裁-施法硬直"}
}
____exports.default = ____exports["云端技能配置"]
return ____exports
