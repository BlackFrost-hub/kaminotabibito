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
local _____82F1_96C4_540D = "蕾米莉亚"
local ____D_6280_80FD_540D_79F0 = "A-蕾米莉亚-恶魔突袭（D）"
local ____W_6280_80FD_540D_79F0 = "蕾米莉亚-红符“Bloody Magic Square（W）"
local _____82F1_96C4_5355_4F4DID = _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID(_____82F1_96C4_540D)
local ____D_6280_80FD_539F_59CBID = _____6309_540D_5B57_53CD_67E5_6280_80FDID(____D_6280_80FD_540D_79F0)
local ____W_6280_80FD_539F_59CBID = _____6309_540D_5B57_53CD_67E5_6280_80FDID(____W_6280_80FD_540D_79F0)
if _____82F1_96C4_5355_4F4DID == nil or _____82F1_96C4_5355_4F4DID == "" then
    error(
        __TS__New(Error, "无法反查英雄单位ID：蕾米莉亚"),
        0
    )
end
if ____D_6280_80FD_539F_59CBID == nil or ____D_6280_80FD_539F_59CBID == "" then
    error(
        __TS__New(Error, "无法反查技能ID：A-蕾米莉亚-恶魔突袭（D）"),
        0
    )
end
if ____W_6280_80FD_539F_59CBID == nil or ____W_6280_80FD_539F_59CBID == "" then
    error(
        __TS__New(Error, "无法反查技能ID：蕾米莉亚-红符“Bloody Magic Square（W）"),
        0
    )
end
____exports["蕾米莉亚单位技能配置"] = {
    ["英雄名"] = _____82F1_96C4_540D,
    ["单位ID"] = _____82F1_96C4_5355_4F4DID,
    ["单位类型ID"] = stringToFourCCSafe(_____82F1_96C4_5355_4F4DID),
    ["被动"] = {["快捷键序号"] = 0},
    Q = {["快捷键序号"] = 1, ["技能ID"] = "0003"},
    W = {
        ["快捷键序号"] = 2,
        ["技能名称"] = ____W_6280_80FD_540D_79F0,
        ["技能ID"] = ____W_6280_80FD_539F_59CBID,
        ["技能类型ID"] = stringToFourCCSafe(____W_6280_80FD_539F_59CBID),
        ["延迟启动毫秒"] = 50,
        ["周期间隔毫秒"] = 1000,
        ["持续次数"] = 10,
        ["技能实例持续时间秒"] = 11,
        ["伤害范围"] = 600,
        ["伤害攻击力快照倍率"] = 1,
        ["伤害攻击力每级倍率"] = 0.2,
        ["单次伤害攻击力倍率"] = 0.1,
        ["单次伤害力量倍率"] = 0.3,
        ["基础生命值百分比增量"] = 0.1,
        ["力量增加比例"] = 0.1,
        ["百分比生命回复增量"] = 0.01,
        ["动作编号"] = -1,
        ["动作速度"] = 1,
        ["语音"] = {["路径"] = "HeroVoice\\REmilia\\FY0005.mp3", ["裁断距离"] = 2000},
        ["表现"] = {
            ["跟随高度"] = 50,
            ["顶点颜色"] = {["红"] = 255, ["绿"] = 50, ["蓝"] = 50, ["透明度"] = 255},
            ["审判"] = {["模型路径"] = "war3mapImported\\judgement.mdl", ["特效键"] = "蕾米莉亚-W-审判", ["缩放"] = 0.8},
            ["圣火"] = {["模型路径"] = "war3mapImported\\holy_fire_slam2.mdl", ["特效键"] = "蕾米莉亚-W-圣火", ["缩放"] = 0.7},
            ["周期特效"] = {
                ["模型路径"] = "war3mapImported\\Eraser.mdl",
                ["Z轴角度"] = 270,
                ["缩放"] = 0.5,
                ["动画速度"] = 1,
                ["持续秒"] = 1
            },
            ["火属性"] = {["伤害类型"] = "火", ["特效模型路径"] = "war3mapImported\\Fire2.mdl", ["特效持续秒"] = 1},
            ["暗属性"] = {["伤害类型"] = "暗", ["特效模型路径"] = "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", ["特效持续秒"] = 1}
        }
    },
    E = {["快捷键序号"] = 3, ["技能ID"] = "0002"},
    R = {["快捷键序号"] = 4, ["技能ID"] = "0001"},
    D = {
        ["快捷键序号"] = 5,
        ["技能名称"] = ____D_6280_80FD_540D_79F0,
        ["技能ID"] = ____D_6280_80FD_539F_59CBID,
        ["技能类型ID"] = stringToFourCCSafe(____D_6280_80FD_539F_59CBID)
    },
    ["说明"] = "蕾米莉亚技能组配置；W开启跟随魔法阵并持续造成随机火/暗属性伤害。"
}
return ____exports
