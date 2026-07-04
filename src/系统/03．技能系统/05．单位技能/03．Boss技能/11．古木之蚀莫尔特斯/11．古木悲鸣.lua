--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.00．配置")
local _____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["莫尔特斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建莫尔特斯上下文"]
local _____53D6_73A9_5BB6_8150_8D25_503C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["取玩家腐败值"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.02．数值与表现配置")
local _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯数值与表现配置"]
local ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.03．腐败值与根须领域")
local _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C = ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF["应用莫尔特斯腐败值"]
local ____13_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.13．台词播放")
local _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD = ____13_FF0E_53F0_8BCD_64AD_653E["播放莫尔特斯台词"]
local ____16_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.16．公共工具")
local _____5355_4F4D_6709_6548 = ____16_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9 = ____16_FF0E_516C_5171_5DE5_5177["点到线段距离平方"]
local stringToFourCC = ____16_FF0E_516C_5171_5DE5_5177.stringToFourCC
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddSpecialEffect = jass.AddSpecialEffect
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_0["获取Boss技能敌对英雄列表"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6050_60E7 = ____require_result_1["施加恐惧"]
local _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____53E4_6728_60B2_9E23_6280_80FDID = stringToFourCC(_____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["古木悲鸣"]["技能槽位"])
local _____5DF2_6CE8_518C = false
local function _____73A9_5BB6_88AB_8611_83C7_906E_6321(context, hero)
    local grid = context["根须宫格"]
    if grid == nil then
        return false
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["古木悲鸣"]
    local bx = GetUnitX(context["Boss单位"])
    local by = GetUnitY(context["Boss单位"])
    local hx = GetUnitX(hero)
    local hy = GetUnitY(hero)
    local cells = {
        grid["获取格子"](grid, 0, 1),
        grid["获取格子"](grid, 1, 0),
        grid["获取格子"](grid, 1, 2),
        grid["获取格子"](grid, 2, 1)
    }
    do
        local i = 0
        while i < #cells do
            do
                local cell = cells[i + 1]
                if cell == nil then
                    goto __continue5
                end
                local dxBoss = cell["中心X"] - bx
                local dyBoss = cell["中心Y"] - by
                local dxHero = hx - bx
                local dyHero = hy - by
                if dxBoss * dxHero + dyBoss * dyHero <= 0 then
                    goto __continue5
                end
                local heroDist2 = dxHero * dxHero + dyHero * dyHero
                local mushDist2 = dxBoss * dxBoss + dyBoss * dyBoss
                if mushDist2 >= heroDist2 then
                    goto __continue5
                end
                if _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9(
                    cell["中心X"],
                    cell["中心Y"],
                    bx,
                    by,
                    hx,
                    hy
                ) <= cfg["蘑菇遮挡半径"] * cfg["蘑菇遮挡半径"] then
                    return true
                end
            end
            ::__continue5::
            i = i + 1
        end
    end
    return false
end
local function _____786E_4FDD_60B2_9E23_8611_83C7_8868_73B0(context)
    local grid = context["根须宫格"]
    if grid == nil then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["古木悲鸣"]
    local cells = {
        grid["获取格子"](grid, 0, 1),
        grid["获取格子"](grid, 1, 0),
        grid["获取格子"](grid, 1, 2),
        grid["获取格子"](grid, 2, 1)
    }
    do
        local i = 0
        while i < #cells do
            do
                local cell = cells[i + 1]
                if cell == nil then
                    goto __continue13
                end
                local effect = AddSpecialEffect(cfg["巨型蘑菇模型列表"][i + 1], cell["中心X"], cell["中心Y"])
                local ____self_2 = context["清理"]
                ____self_2["登记特效"](____self_2, "莫尔特斯-古木悲鸣蘑菇", effect)
            end
            ::__continue13::
            i = i + 1
        end
    end
end
____exports["释放莫尔特斯古木悲鸣"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["古木悲鸣"]
    _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD(boss, "古木悲鸣")
    _____786E_4FDD_60B2_9E23_8611_83C7_8868_73B0(context)
    AddSpecialEffect(
        cfg["悲鸣特效路径"],
        GetUnitX(boss),
        GetUnitY(boss)
    )
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue18
                end
                if _____73A9_5BB6_88AB_8611_83C7_906E_6321(context, hero) then
                    goto __continue18
                end
                local before = _____53D6_73A9_5BB6_8150_8D25_503C(context, hero)
                _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C(context, hero, cfg["腐败值"])
                if before >= cfg["恐惧阈值"] then
                    _____65BD_52A0_6050_60E7(boss, hero, {["持续时间"] = cfg["恐惧秒"], ["模式"] = "随机乱跑", ["随机半径"] = 450, ["移动速度"] = 50})
                end
            end
            ::__continue18::
            i = i + 1
        end
    end
end
local function ____on_83AB_5C14_7279_65AF_53E4_6728_60B2_9E23_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____53E4_6728_60B2_9E23_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放莫尔特斯古木悲鸣"](context)
end
____exports["注册莫尔特斯古木悲鸣"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "11．古木悲鸣",
        ["单位类型ID"] = _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____53E4_6728_60B2_9E23_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_83AB_5C14_7279_65AF_53E4_6728_60B2_9E23_65BD_6CD5(boss, _____53E4_6728_60B2_9E23_6280_80FDID)
        end
    })
end
return ____exports
