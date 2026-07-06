--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____5355_4F4D_6301_6709_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["单位持有物品"]
local _____83B7_53D6_8303_56F4_654C_4EBA = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["获取范围敌人"]
local _____53D6_5355_4F4DX = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位Y"]
local _____53D6_5355_4F4D_653B_51FB = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位攻击"]
local _____9020_6210_666E_901A_4F24_5BB3 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["造成普通伤害"]
local _____62C9_5411_6765_6E90 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["拉向来源"]
local _____547D_4EE4_653B_51FB_6765_6E90 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["命令攻击来源"]
local _____65BD_52A0_51CF_901F = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["施加减速"]
local ____01_FF0E_653B_51FB_6548_679C_5DE5_5177 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.01．攻击效果工具")
local _____653B_51FB_8005_7C7B_578B_6EE1_8DB3 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["攻击者类型满足"]
local _____8DDD_79BB_6EE1_8DB3_9650_5236 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["距离满足限制"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____8BFB_53D6_73A9_5BB6_66B4_51FB_4F24_5BB3 = ____20_FF0E_7269_54C1_8F85_52A9["读取玩家暴击伤害"]
local _____9B54_53E4_6218_5203_88AB_52A8_6700_5927_653B_51FB_8DDD_79BB = 200
____exports["处理魔古战刃使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["魔古战刃"]) then
        return
    end
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["魔古战刃"]
    local unit = ctx["施法单位"]
    local enemies = _____83B7_53D6_8303_56F4_654C_4EBA(
        unit,
        _____53D6_5355_4F4DX(unit),
        _____53D6_5355_4F4DY(unit),
        cfg["主动半径"]
    )
    local critDmg = _____8BFB_53D6_73A9_5BB6_66B4_51FB_4F24_5BB3(unit)
    local damage = _____53D6_5355_4F4D_653B_51FB(unit) * (1 + critDmg)
    for ____, enemy in ipairs(enemies) do
        _____9020_6210_666E_901A_4F24_5BB3(unit, enemy, damage)
        _____547D_4EE4_653B_51FB_6765_6E90(enemy, unit)
        _____65BD_52A0_51CF_901F(unit, enemy, 0.3, 2)
        _____62C9_5411_6765_6E90(unit, enemy, cfg["拉拢距离"], cfg["拉拢时间"])
    end
end
____exports["处理魔古战刃伤害"] = function(target, attacker, applied, snapshot)
    if snapshot == nil or snapshot.isNormalAttack ~= true then
        return
    end
    if snapshot.isSkillDamage == true or snapshot.isSkillAttack == true or snapshot.isWrappedSkillDamage == true then
        return
    end
    if not _____653B_51FB_8005_7C7B_578B_6EE1_8DB3(attacker, "近战") then
        return
    end
    if not _____8DDD_79BB_6EE1_8DB3_9650_5236(attacker, target, nil, _____9B54_53E4_6218_5203_88AB_52A8_6700_5927_653B_51FB_8DDD_79BB) then
        return
    end
    if not _____5355_4F4D_6301_6709_7269_54C1(attacker, _____7269_54C1_4F7F_7528_88C5_5907ID["魔古战刃"]) then
        return
    end
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["魔古战刃"]
    local enemies = _____83B7_53D6_8303_56F4_654C_4EBA(
        attacker,
        _____53D6_5355_4F4DX(target),
        _____53D6_5355_4F4DY(target),
        cfg["扩散半径"]
    )
    for ____, enemy in ipairs(enemies) do
        do
            if enemy == target then
                goto __continue12
            end
            _____9020_6210_666E_901A_4F24_5BB3(attacker, enemy, applied * cfg["扩散比例"])
        end
        ::__continue12::
    end
end
return ____exports
