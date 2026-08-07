--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.02．精英技能.03．第三章.02．裂誓重卫.00．配置")
local _____88C2_8A93_91CD_536B_914D_7F6E = ____00_FF0E_914D_7F6E["裂誓重卫配置"]
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.00．封印守卫战公共.01．共享")
local _____521B_5EFA_5C01_5370_5B88_536B_6218_5355_4F4D_5E38_9A7B_7279_6548 = ____01_FF0E_5171_4EAB["创建封印守卫战单位常驻特效"]
local _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548 = ____01_FF0E_5171_4EAB["创建封印守卫战点特效"]
local _____53D6_4E24_70B9_65B9_5411_89D2 = ____01_FF0E_5171_4EAB["取两点方向角"]
local _____53D6_5355_4F4DX = ____01_FF0E_5171_4EAB["取单位X"]
local _____53D6_5355_4F4DY = ____01_FF0E_5171_4EAB["取单位Y"]
local _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9 = ____01_FF0E_5171_4EAB["取单位距离平方"]
local _____53D6_5355_4F4D_9762_5411 = ____01_FF0E_5171_4EAB["取单位面向"]
local _____53D6_6700_8FD1_73A9_5BB6_82F1_96C4 = ____01_FF0E_5171_4EAB["取最近玩家英雄"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____01_FF0E_5171_4EAB["读取单位攻击力"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_5217_8868 = ____01_FF0E_5171_4EAB["读取封印守卫战敌人列表"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55 = ____01_FF0E_5171_4EAB["读取封印守卫战敌人记录"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_6838_5FC3 = ____01_FF0E_5171_4EAB["读取封印守卫战核心"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868 = ____01_FF0E_5171_4EAB["读取封印守卫战玩家英雄列表"]
local _____547D_4EE4_653B_51FB_76EE_6807 = ____01_FF0E_5171_4EAB["命令攻击目标"]
local _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B = ____01_FF0E_5171_4EAB["封印守卫战单位存活"]
local _____9500_6BC1_5C01_5370_5B88_536B_6218_5355_4F4D_5E38_9A7B_7279_6548 = ____01_FF0E_5171_4EAB["销毁封印守卫战单位常驻特效"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51FB_9000 = ____require_result_1["开始击退"]
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local ____require_result_3 = require("系统.05．Buff系统.03．Buff表.04．单位.01．封印守卫战")
local _____5C01_5370_5B88_536B_6218BuffID = ____require_result_3["封印守卫战BuffID"]
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local _____91CD_536B_62A4_76FE_7279_6548_952E = "封印守卫战-裂誓重卫护盾"
local function _____89D2_5EA6_5DEE(first, second)
    local diff = first - second
    while diff < -180 do
        diff = diff + 360
    end
    while diff > 180 do
        diff = diff - 360
    end
    return diff < 0 and -diff or diff
end
____exports["初始化裂誓重卫机制"] = function(record)
    _____521B_5EFA_5C01_5370_5B88_536B_6218_5355_4F4D_5E38_9A7B_7279_6548(record["单位"], _____88C2_8A93_91CD_536B_914D_7F6E["护盾特效"], _____91CD_536B_62A4_76FE_7279_6548_952E)
end
____exports["修正裂誓重卫减伤"] = function(context)
    local ____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55_7 = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55
    local ____opt_result_6
    if context ~= nil then
        ____opt_result_6 = context.target
    end
    local targetRecord = ____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55_7(____opt_result_6)
    if targetRecord == nil then
        return context.currentDamage
    end
    if targetRecord["类型"] == "裂誓重卫" then
        if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(context.attacker) then
            return context.currentDamage
        end
        local attackAngle = _____53D6_4E24_70B9_65B9_5411_89D2(
            _____53D6_5355_4F4DX(targetRecord["单位"]),
            _____53D6_5355_4F4DY(targetRecord["单位"]),
            _____53D6_5355_4F4DX(context.attacker),
            _____53D6_5355_4F4DY(context.attacker)
        )
        if _____89D2_5EA6_5DEE(
            attackAngle,
            _____53D6_5355_4F4D_9762_5411(targetRecord["单位"])
        ) <= _____88C2_8A93_91CD_536B_914D_7F6E["正面角度"] * 0.5 then
            return context.currentDamage * (1 - _____88C2_8A93_91CD_536B_914D_7F6E["正面减伤比例"])
        end
        return context.currentDamage
    end
    local list = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_5217_8868()
    do
        local i = 0
        while i < #list do
            do
                local protector = list[i + 1]
                if protector["类型"] ~= "裂誓重卫" or not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(protector["单位"]) then
                    goto __continue12
                end
                if _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9(protector["单位"], targetRecord["单位"]) <= _____88C2_8A93_91CD_536B_914D_7F6E["保护范围"] * _____88C2_8A93_91CD_536B_914D_7F6E["保护范围"] then
                    return context.currentDamage * (1 - _____88C2_8A93_91CD_536B_914D_7F6E["保护减伤比例"])
                end
            end
            ::__continue12::
            i = i + 1
        end
    end
    return context.currentDamage
end
local function _____5237_65B0_88C2_8A93_4FDD_62A4Buff(protector)
    local list = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_5217_8868()
    local duration = (_____88C2_8A93_91CD_536B_914D_7F6E["AI刷新毫秒"] + 300) / 1000
    do
        local i = 0
        while i < #list do
            do
                local target = list[i + 1]
                if target["类型"] == "裂誓重卫" or not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target["单位"]) then
                    goto __continue17
                end
                if _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9(protector["单位"], target["单位"]) > _____88C2_8A93_91CD_536B_914D_7F6E["保护范围"] * _____88C2_8A93_91CD_536B_914D_7F6E["保护范围"] then
                    goto __continue17
                end
                registerManualBuff(
                    target["单位"],
                    _____5C01_5370_5B88_536B_6218BuffID["裂誓保护"],
                    duration,
                    _____88C2_8A93_91CD_536B_914D_7F6E["保护减伤比例"],
                    {sourceUnit = protector["单位"], effectSourceName = "裂誓重卫-裂誓保护", effectSourceType = "技能"}
                )
            end
            ::__continue17::
            i = i + 1
        end
    end
end
local function _____91CA_653E_88C2_8A93_91CD_536B_76FE_51FB(record)
    local heroes = _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868()
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(record["单位"]) * _____88C2_8A93_91CD_536B_914D_7F6E["盾击攻击力比例"]
    local hitCount = 0
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(hero) then
                    goto __continue22
                end
                if _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9(record["单位"], hero) > _____88C2_8A93_91CD_536B_914D_7F6E["盾击范围"] * _____88C2_8A93_91CD_536B_914D_7F6E["盾击范围"] then
                    goto __continue22
                end
                if _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = record["单位"],
                    ["目标"] = hero,
                    ["伤害"] = damage,
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    ["来源类型"] = "单位技能",
                    ["标签"] = "封印守卫战-裂誓重卫盾击",
                    ["参与技能伤害加成"] = false
                }) then
                    hitCount = hitCount + 1
                end
                _____5F00_59CB_51FB_9000(hero, {
                    ["来源单位"] = record["单位"],
                    ["主单位"] = record["单位"],
                    ["距离"] = _____88C2_8A93_91CD_536B_914D_7F6E["击退距离"],
                    ["持续时间"] = _____88C2_8A93_91CD_536B_914D_7F6E["击退持续秒"],
                    ["检查地形"] = true,
                    ["暂停单位"] = false,
                    ["禁用碰撞"] = true
                })
            end
            ::__continue22::
            i = i + 1
        end
    end
    _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548({
        ["模型路径"] = _____88C2_8A93_91CD_536B_914D_7F6E["盾击特效"],
        X = _____53D6_5355_4F4DX(record["单位"]),
        Y = _____53D6_5355_4F4DY(record["单位"]),
        Z = 0,
        ["缩放"] = 0.8,
        ["持续秒"] = 2
    })
    return hitCount
end
____exports["刷新裂誓重卫AI"] = function(record, _____5F53_524D_6BEB_79D2)
    if _____5F53_524D_6BEB_79D2 < record["下次AI毫秒"] then
        return
    end
    record["下次AI毫秒"] = _____5F53_524D_6BEB_79D2 + _____88C2_8A93_91CD_536B_914D_7F6E["AI刷新毫秒"]
    _____5237_65B0_88C2_8A93_4FDD_62A4Buff(record)
    local hero = _____53D6_6700_8FD1_73A9_5BB6_82F1_96C4(record["单位"], 700)
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(hero) then
        record["当前目标"] = hero
        if _____5F53_524D_6BEB_79D2 >= record["下次技能毫秒"] and _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9(record["单位"], hero) <= _____88C2_8A93_91CD_536B_914D_7F6E["盾击范围"] * _____88C2_8A93_91CD_536B_914D_7F6E["盾击范围"] then
            _____91CA_653E_88C2_8A93_91CD_536B_76FE_51FB(record)
            record["下次技能毫秒"] = _____5F53_524D_6BEB_79D2 + _____88C2_8A93_91CD_536B_914D_7F6E["盾击冷却毫秒"]
        end
        _____547D_4EE4_653B_51FB_76EE_6807(record["单位"], hero)
        return
    end
    local core = _____8BFB_53D6_5C01_5370_5B88_536B_6218_6838_5FC3()
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(core) then
        record["当前目标"] = core
        _____547D_4EE4_653B_51FB_76EE_6807(record["单位"], core)
    end
end
____exports["清理裂誓重卫机制"] = function(record)
    _____9500_6BC1_5C01_5370_5B88_536B_6218_5355_4F4D_5E38_9A7B_7279_6548(record["单位"], _____91CD_536B_62A4_76FE_7279_6548_952E)
end
return ____exports
