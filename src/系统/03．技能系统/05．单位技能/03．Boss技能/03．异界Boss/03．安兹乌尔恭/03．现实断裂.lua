--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建安兹运行时上下文"]
local _____6807_8BB0_5B89_5179_666E_901A_673A_5236_5FD9_788C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["标记安兹普通机制忙碌"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.00．配置")
local _____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["安兹乌尔恭单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local ____12_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.12．台词播放")
local _____64AD_653E_5B89_5179_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放安兹台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____require_result_0["计算组合技能伤害"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_1["启动基础施法时间线"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.02．线段危险区")
local _____521B_5EFA_7EBF_6BB5_5371_9669_533A = ____require_result_3["创建线段危险区"]
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_4["造成AOE技能伤害"]
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_6700_9AD8_4EC7_6068_76EE_6807 = ____require_result_5["获取Boss技能最高仇恨目标"]
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_5["获取Boss技能随机敌对英雄"]
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_5["获取Boss技能敌对英雄列表"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_6["创建点特效"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local Atan2 = jass.Atan2
local ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local BJ_RADTODEG = 57.29577951308232
local _____5B89_5179_5355_4F4D_7C7B_578BID = stringToFourCC(_____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["正式单位ID"])
local _____73B0_5B9E_65AD_88C2_6280_80FDID = stringToFourCC(_____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["现实断裂"])
local _____73B0_5B9E_65AD_88C2_5DF2_6CE8_518C = false
____exports["现实断裂技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["包含战斗自身位移"] = false,
    ["语义"] = "预告一条狭长空间切面，延迟后按固定方向爆发并保留可识别安全区。"
}
local function _____53D6_76EE_6807(boss)
    local entry = _____83B7_53D6Boss_6280_80FD_6700_9AD8_4EC7_6068_76EE_6807(boss)
    if entry ~= nil and _____5355_4F4D_6709_6548(entry.targetRef) then
        return entry.targetRef
    end
    return _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss)
end
local function _____53D6_65B9_5411_89D2(boss, target)
    return Atan2(
        GetUnitY(target) - GetUnitY(boss),
        GetUnitX(target) - GetUnitX(boss)
    ) * BJ_RADTODEG
end
local function _____8BA1_7B97_4F24_5BB3(boss, target)
    local config = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["普通技能"]
    return _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, target, {["来源攻击力比例"] = config["现实断裂伤害Boss攻击力比例"], ["目标最大生命比例"] = config["现实断裂伤害目标最大生命比例"]})
end
local function _____64AD_653E_73B0_5B9E_65AD_88C2_7279_6548(x, y, angle)
    local config = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = config["表现资源"]["现实断裂特效路径"],
        X = x,
        Y = y,
        ["缩放"] = config["普通技能"]["现实断裂特效缩放"],
        ["Z轴角度"] = angle,
        ["持续秒"] = config["普通技能"]["现实断裂特效持续秒"]
    })
end
local function _____521B_5EFA_73B0_5B9E_65AD_88C2_5224_5B9A(context, angle, originX, originY)
    local config = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["普通技能"]
    local boss = context["安兹单位"]
    _____64AD_653E_73B0_5B9E_65AD_88C2_7279_6548(
        _____6781_5750_6807X(originX, angle, config["现实断裂路径长度"] * 0.5),
        _____6781_5750_6807Y(originY, angle, config["现实断裂路径长度"] * 0.5),
        angle
    )
    _____521B_5EFA_7EBF_6BB5_5371_9669_533A({
        ["清理"] = context["清理"],
        ["名称"] = "安兹·现实断裂",
        ["起点X"] = originX,
        ["起点Y"] = originY,
        ["方向角"] = angle,
        ["长度"] = config["现实断裂路径长度"],
        ["宽度"] = config["现实断裂路径宽度"],
        ["持续秒"] = config["现实断裂危险持续秒"],
        ["Tick间隔毫秒"] = config["现实断裂危险Tick毫秒"],
        ["单位列表"] = function()
            return _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
        end,
        ["提示圈"] = {["类型"] = "方向直线", ["来源单位"] = boss},
        ["on进入"] = function(unit)
            if not _____5355_4F4D_6709_6548(unit) or unit == boss then
                return
            end
            _____9020_6210AOE_6280_80FD_4F24_5BB3({
                ["技能ID"] = _____73B0_5B9E_65AD_88C2_6280_80FDID,
                ["来源"] = boss,
                ["目标"] = unit,
                ["伤害"] = _____8BA1_7B97_4F24_5BB3(boss, unit),
                attack = false,
                ranged = true,
                attackType = ATTACK_TYPE_MAGIC,
                ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                weaponType = WEAPON_TYPE_WHOKNOWS,
                ["来源类型"] = "Boss技能"
            })
        end
    })
end
____exports["释放安兹现实断裂"] = function(context)
    local boss = context["安兹单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["当前大型技能"] ~= nil then
        return
    end
    local target = _____53D6_76EE_6807(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["现实断裂"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    _____64AD_653E_5B89_5179_53F0_8BCD(boss, "现实断裂")
    local config = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["普通技能"]
    _____6807_8BB0_5B89_5179_666E_901A_673A_5236_5FD9_788C(context, config["现实断裂预警秒"] + config["现实断裂危险持续秒"])
    local angle = _____53D6_65B9_5411_89D2(boss, target)
    local originX = GetUnitX(boss)
    local originY = GetUnitY(boss)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "矩形",
        X = _____6781_5750_6807X(originX, angle, config["现实断裂路径长度"] * 0.5),
        Y = _____6781_5750_6807Y(originY, angle, config["现实断裂路径长度"] * 0.5),
        ["宽度"] = config["现实断裂路径宽度"],
        ["长度"] = config["现实断裂路径长度"],
        ["朝向"] = angle,
        ["持续时间"] = config["现实断裂预警秒"],
        ["来源单位"] = boss
    })
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标X"] = _____6781_5750_6807X(originX, angle, config["现实断裂路径长度"]),
        ["目标Y"] = _____6781_5750_6807Y(originY, angle, config["现实断裂路径长度"]),
        ["硬直秒"] = config["现实断裂预警秒"],
        ["动画编号"] = 3,
        ["动画速度"] = 1,
        ["生效前重新面向"] = false,
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = config["现实断裂预警秒"],
            ["颜色ID"] = 4,
            ["标题文本"] = "现实断裂",
            ["提示文本"] = "沿固定方向撕开空间切面"
        },
        ["on生效"] = function()
            _____521B_5EFA_73B0_5B9E_65AD_88C2_5224_5B9A(context, angle, originX, originY)
        end
    })
end
____exports["注册安兹现实断裂"] = function()
    if _____73B0_5B9E_65AD_88C2_5DF2_6CE8_518C then
        return
    end
    _____73B0_5B9E_65AD_88C2_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "安兹·现实断裂",
        ["单位类型ID"] = _____5B89_5179_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____73B0_5B9E_65AD_88C2_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587,
        ["释放技能"] = function(context)
            ____exports["释放安兹现实断裂"](context)
        end
    })
end
return ____exports
