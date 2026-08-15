--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置")
local _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID = ____require_result_1["按名字反查玩家英雄单位ID"]
local ____require_result_2 = require("系统.03．技能系统.08．技能数据表.01．技能名反查")
local _____6309_540D_5B57_53CD_67E5_6280_80FDID = ____require_result_2["按名字反查技能ID"]
local _____82F1_96C4_540D = "塞拉斯"
local _____82F1_96C4_5355_4F4DID = _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID(_____82F1_96C4_540D) or "H014"
local ____D_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID("1天赋技-调查") or "A0JP"
local ____Q_5165_53E3_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID("塞拉斯-魔法知识（Q）") or "A0JT"
local _____706B_7130_9B54_6CD5_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID("1塞拉斯-火焰魔法（W）") or "A0JQ"
local _____51B0_51BB_9B54_6CD5_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID("1塞拉斯-冰冻魔法（E）") or "A0JR"
local _____96F7_51FB_9B54_6CD5_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID("1塞拉斯-雷击魔法（R）") or "A0JS"
local _____5173_95ED_5165_53E3_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID("1塞拉斯魔法知识-关闭") or "A0JV"
local ____W_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID("塞拉斯-大魔法化（W）") or "A0JW"
local ____E_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID("塞拉斯-属性提升（E）") or "A0JX"
local ____R_6280_80FDID = _____6309_540D_5B57_53CD_67E5_6280_80FDID("塞拉斯-知识与旅行的学者（R）") or "A0JY"
____exports["塞拉斯技能配置"] = {
    ["英雄名"] = _____82F1_96C4_540D,
    ["单位ID"] = _____82F1_96C4_5355_4F4DID,
    ["单位类型ID"] = stringToFourCCSafe(_____82F1_96C4_5355_4F4DID),
    D = {
        ["快捷键序号"] = 5,
        ["技能ID"] = ____D_6280_80FDID,
        ["技能类型ID"] = stringToFourCCSafe(____D_6280_80FDID),
        ["施法距离"] = 800,
        ["冷却秒"] = 45,
        ["魔耗"] = "统一百分比魔耗系统处理（介绍 5%），技能文件不扣魔",
        ["音效"] = {["路径"] = "Sound\\SLD_D.wav", ["裁断距离"] = 1250},
        ["错误提示"] = "目标不是当前 Boss 战单位",
        ["提示持续秒"] = 15
    },
    ["Q入口"] = {
        ["快捷键序号"] = 1,
        ["技能ID"] = ____Q_5165_53E3_6280_80FDID,
        ["技能类型ID"] = stringToFourCCSafe(____Q_5165_53E3_6280_80FDID),
        ["切换延迟秒"] = 0.15
    },
    ["关闭入口"] = {
        ["技能ID"] = _____5173_95ED_5165_53E3_6280_80FDID,
        ["技能类型ID"] = stringToFourCCSafe(_____5173_95ED_5165_53E3_6280_80FDID),
        ["切换延迟秒"] = 0.15,
        ["重置Q入口冷却"] = true
    },
    ["元素魔法"] = {
        ["火焰技能ID"] = _____706B_7130_9B54_6CD5_6280_80FDID,
        ["冰冻技能ID"] = _____51B0_51BB_9B54_6CD5_6280_80FDID,
        ["雷击技能ID"] = _____96F7_51FB_9B54_6CD5_6280_80FDID,
        ["火焰技能类型ID"] = stringToFourCCSafe(_____706B_7130_9B54_6CD5_6280_80FDID),
        ["冰冻技能类型ID"] = stringToFourCCSafe(_____51B0_51BB_9B54_6CD5_6280_80FDID),
        ["雷击技能类型ID"] = stringToFourCCSafe(_____96F7_51FB_9B54_6CD5_6280_80FDID),
        ["范围"] = 500,
        ["tick间隔秒"] = 0.21,
        ["普通结算次数"] = 1,
        ["大魔法结算次数"] = 2,
        ["火焰"] = {
            ["元素"] = "火",
            ["基础倍率"] = 1.4,
            ["每级成长"] = 0.1,
            ["灼烧持续秒"] = 2,
            ["灼烧每秒已损失生命比例"] = 0.015,
            ["灼烧每次命中加层"] = 2,
            ["特效"] = {{["模型路径"] = "war3mapImported\\fire.mdl", ["缩放"] = 1.45, ["持续秒"] = 1.2}, {["模型路径"] = "war3mapImported\\FireImpact.mdl", ["缩放"] = 1.45, ["持续秒"] = 1.2}, {["模型路径"] = "Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl", ["缩放"] = 1, ["持续秒"] = 1.2}},
            ["灼烧特效"] = {["模型路径"] = "war3mapImported\\Fire2.mdl", ["挂点"] = "origin", ["持续秒"] = 2},
            ["音效普通"] = {["路径"] = "Sound\\SLS_W.wav", ["裁断距离"] = 1250},
            ["音效大魔法"] = {["路径"] = "Sound\\SLS_W2.wav", ["裁断距离"] = 1250}
        },
        ["冰冻"] = {
            ["元素"] = "冰",
            ["基础倍率"] = 1.2,
            ["每级成长"] = 0.1,
            ["冻结秒"] = 0.6,
            ["特效"] = {{["模型路径"] = "war3mapImported\\FrostNova.mdl", ["缩放"] = 0.66, ["持续秒"] = 1.2}, {["模型路径"] = "war3mapImported\\ICE.mdl", ["缩放"] = 4, ["持续秒"] = 1.2}},
            ["音效普通"] = {["路径"] = "Sound\\SLS_E.wav", ["裁断距离"] = 1250},
            ["音效大魔法"] = {["路径"] = "Sound\\SLS_E2.wav", ["裁断距离"] = 1250}
        },
        ["雷击"] = {
            ["元素"] = "雷",
            ["基础倍率"] = 1.4,
            ["每级成长"] = 0.1,
            ["减速秒"] = 1.4,
            ["减速比例"] = 0.99,
            ["目标特效"] = {["模型路径"] = "Abilities\\Spells\\Orc\\Purge\\PurgeBuffTarget.mdl", ["缩放"] = 1.25, ["持续秒"] = 1},
            ["落点特效"] = {["模型路径"] = "war3mapImported\\OrbOfLightning.mdl", ["缩放"] = 7, ["持续秒"] = 1.2},
            ["目标音效"] = {["路径"] = "Sound\\CorrosiveBreathMissileLaunch1.wav", ["裁断距离"] = 1250},
            ["音效普通"] = {["路径"] = "Sound\\SLS_R.wav", ["裁断距离"] = 1250},
            ["音效大魔法"] = {["路径"] = "Sound\\SLS_R2.wav", ["裁断距离"] = 1250}
        }
    },
    W = {
        ["快捷键序号"] = 2,
        ["技能ID"] = ____W_6280_80FDID,
        ["技能类型ID"] = stringToFourCCSafe(____W_6280_80FDID),
        ["魔耗"] = "统一百分比魔耗系统处理（介绍 20%），技能文件不扣魔",
        ["冷却基础秒"] = 20,
        ["冷却每级递减秒"] = 0.5,
        ["特效"] = {{["模型路径"] = "war3mapImported\\[AKE]war3AKE.com - 4824137662399555907875383.mdl", ["缩放"] = 2, ["持续秒"] = 1.2}, {["模型路径"] = "war3mapImported\\Teleport.mdl", ["缩放"] = 3, ["持续秒"] = 1.2}},
        ["音效"] = {{["路径"] = "Sound\\SLS_ZW.wav", ["裁断距离"] = 1500}, {["路径"] = "Sound\\Tranquility01.wav", ["裁断距离"] = 1500}}
    },
    E = {
        ["快捷键序号"] = 3,
        ["技能ID"] = ____E_6280_80FDID,
        ["技能类型ID"] = stringToFourCCSafe(____E_6280_80FDID),
        ["每级魔法伤害基础增幅百分比"] = 10,
        ["每级魔法伤害成长百分比"] = 3
    },
    R = {
        ["快捷键序号"] = 4,
        ["技能ID"] = ____R_6280_80FDID,
        ["技能类型ID"] = stringToFourCCSafe(____R_6280_80FDID),
        ["智力"] = {["低段每级加值"] = 8, ["低段上限等级"] = 10, ["高段每级加值"] = 15},
        ["魔法穿透"] = "待查：项目暂无魔法穿透接口，不生效",
        ["旅行经验"] = "待查：项目暂无旅行经验公共系统，按迁移计划暂停该分支，不写私有城镇检测"
    },
    ["被动"] = {
        ["触发距离"] = 500,
        ["延迟秒"] = 0.12,
        ["附加伤害范围"] = 350,
        ["当前魔法值伤害比例"] = 0.4,
        ["火焰特效"] = {["模型路径"] = "war3mapImported\\minitype flame02.mdx", ["缩放"] = 1, ["持续秒"] = 1},
        ["雷击特效"] = {["模型路径"] = "war3mapImported\\lightningwrath.mdx", ["缩放"] = 1, ["持续秒"] = 1},
        ["冰冻特效"] = {["模型路径"] = "Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl", ["缩放"] = 1.75, ["持续秒"] = 1}
    }
}
return ____exports
