--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建安兹运行时上下文"]
local _____6807_8BB0_5B89_5179_666E_901A_673A_5236_5FD9_788C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["标记安兹普通机制忙碌"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.00．配置")
local _____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["安兹乌尔恭单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_6A21_578B_52A8_753B_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹模型动画配置"]
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____08_FF0E_6B21_6570_578B_4F24_5BB3_514D_75AB = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.08．次数型伤害免疫")
local _____521B_5EFA_6B21_6570_578B_4F24_5BB3_514D_75AB = ____08_FF0E_6B21_6570_578B_4F24_5BB3_514D_75AB["创建次数型伤害免疫"]
local _____51FB_9000_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____5F00_59CB_51FB_9000 = _____51FB_9000_7CFB_7EDF["开始击退"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_0["启动基础施法时间线"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local DzSetEffectVertexColor = japi.DzSetEffectVertexColor
local _____5B89_5179_5355_4F4D_7C7B_578BID = stringToFourCC(_____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["正式单位ID"])
local _____5149_8F89_7FE0_7EFF_4F53_6280_80FDID = stringToFourCC(_____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["光辉翠绿体"])
local _____5149_8F89_7FE0_7EFF_4F53_5DF2_6CE8_518C = false
local function _____91CA_653E_7FE0_7EFF_51B2_51FB(boss)
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["普通技能"]
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    local radius2 = config["光辉翠绿体击退半径"] * config["光辉翠绿体击退半径"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue5
                end
                local dx = GetUnitX(hero) - x
                local dy = GetUnitY(hero) - y
                if dx * dx + dy * dy > radius2 then
                    goto __continue5
                end
                _____5F00_59CB_51FB_9000(hero, {
                    ["来源单位"] = boss,
                    ["距离"] = config["光辉翠绿体击退距离"],
                    ["持续时间"] = config["光辉翠绿体击退持续秒"],
                    ["检查地形"] = true,
                    ["暂停单位"] = true,
                    ["禁用碰撞"] = true,
                    ["主单位死亡时中断"] = false
                })
            end
            ::__continue5::
            i = i + 1
        end
    end
end
local function _____521B_5EFA_7FE0_7EFF_9632_62A4(context)
    local boss = context["安兹单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local effect = AddSpecialEffectTarget(config["表现资源"]["光辉翠绿体特效路径"], boss, "origin")
    if effect ~= nil and effect ~= 0 then
        DzSetEffectVertexColor(effect, 80 * 65536 + 255 * 256 + 120)
    end
    local effectDestroyed = false
    local function _____9500_6BC1_7FE0_7EFF_9632_62A4_7279_6548()
        if effectDestroyed or effect == nil or effect == 0 then
            return
        end
        effectDestroyed = true
        DestroyEffect(effect)
    end
    _____521B_5EFA_6B21_6570_578B_4F24_5BB3_514D_75AB({
        ["名称"] = "安兹·光辉翠绿体",
        ["单位"] = boss,
        ["免疫类型"] = "物理伤害",
        ["免疫次数"] = 1,
        ["持续秒"] = config["普通技能"]["光辉翠绿体持续秒"],
        ["最低伤害占最大生命比例"] = config["普通技能"]["光辉翠绿体最低伤害最大生命比例"],
        ["清理"] = context["清理"],
        ["过滤伤害"] = function(damageContext)
            return damageContext.isDotDamage ~= true and damageContext.isReflectDamage ~= true and damageContext.isTransferredDamage ~= true and damageContext.isDamageTransfer ~= true
        end,
        ["on抵挡"] = function()
            _____9500_6BC1_7FE0_7EFF_9632_62A4_7279_6548()
            _____91CA_653E_7FE0_7EFF_51B2_51FB(boss)
        end,
        ["on结束"] = function(_unit, _____539F_56E0)
            _____9500_6BC1_7FE0_7EFF_9632_62A4_7279_6548()
            if _____539F_56E0 == "到期" then
                _____91CA_653E_7FE0_7EFF_51B2_51FB(boss)
            end
        end
    })
end
____exports["释放安兹光辉翠绿体"] = function(context)
    local boss = context["安兹单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["当前大型技能"] ~= nil then
        return
    end
    local config = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["普通技能"]
    _____6807_8BB0_5B89_5179_666E_901A_673A_5236_5FD9_788C(context, config["光辉翠绿体施法硬直秒"] + config["光辉翠绿体持续秒"])
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["硬直秒"] = config["光辉翠绿体施法硬直秒"],
        ["动画编号"] = config["光辉翠绿体动画编号"],
        ["动画速度"] = config["光辉翠绿体动画速度"],
        ["恢复动画编号"] = _____5B89_5179_6A21_578B_52A8_753B_914D_7F6E["待机编号"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = config["光辉翠绿体施法硬直秒"],
            ["颜色ID"] = 3,
            ["标题文本"] = "光辉翠绿体",
            ["提示文本"] = "下一次直接物理攻击将被完全抵挡"
        },
        ["on生效"] = function()
            _____521B_5EFA_7FE0_7EFF_9632_62A4(context)
        end
    })
end
____exports["注册安兹光辉翠绿体"] = function()
    if _____5149_8F89_7FE0_7EFF_4F53_5DF2_6CE8_518C then
        return
    end
    _____5149_8F89_7FE0_7EFF_4F53_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "安兹·光辉翠绿体",
        ["单位类型ID"] = _____5B89_5179_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____5149_8F89_7FE0_7EFF_4F53_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587,
        ["释放技能"] = function(context)
            ____exports["释放安兹光辉翠绿体"](context)
        end
    })
end
____exports["光辉翠绿体技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "无直接伤害",
    ["包含战斗自身位移"] = false,
    ["语义"] = "无效化下一次达到条件的直接物理伤害；DOT、反伤和极小伤害不消耗防护。"
}
return ____exports
