--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.02．失控英灵.00．配置")
local _____5931_63A7_82F1_7075_914D_7F6E = ____00_FF0E_914D_7F6E["失控英灵配置"]
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.00．封印守卫战公共.01．共享")
local _____547D_4EE4_653B_51FB_76EE_6807 = ____01_FF0E_5171_4EAB["命令攻击目标"]
local _____53D6_6700_8FD1_73A9_5BB6_82F1_96C4 = ____01_FF0E_5171_4EAB["取最近玩家英雄"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_6838_5FC3 = ____01_FF0E_5171_4EAB["读取封印守卫战核心"]
local _____662F_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4 = ____01_FF0E_5171_4EAB["是封印守卫战玩家英雄"]
local _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B = ____01_FF0E_5171_4EAB["封印守卫战单位存活"]
local _____64AD_653E_5C01_5370_5B88_536B_6218_5355_4F4D_4E34_65F6_7279_6548 = ____01_FF0E_5171_4EAB["播放封印守卫战单位临时特效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_0["施加快速减速Buff"]
local _____6E05_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["清除单位指定Buff"]
local ____require_result_1 = require("系统.05．Buff系统.03．Buff表.04．单位.01．封印守卫战")
local _____5C01_5370_5B88_536B_6218BuffID = ____require_result_1["封印守卫战BuffID"]
____exports["刷新失控英灵AI"] = function(record, _____5F53_524D_6BEB_79D2)
    if _____5F53_524D_6BEB_79D2 < record["下次AI毫秒"] then
        return
    end
    record["下次AI毫秒"] = _____5F53_524D_6BEB_79D2 + _____5931_63A7_82F1_7075_914D_7F6E["AI刷新毫秒"]
    local hero = _____53D6_6700_8FD1_73A9_5BB6_82F1_96C4(record["单位"])
    local _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B_result_2
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(hero) then
        _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B_result_2 = hero
    else
        _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B_result_2 = _____8BFB_53D6_5C01_5370_5B88_536B_6218_6838_5FC3()
    end
    local target = _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B_result_2
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        record["当前目标"] = target
        _____547D_4EE4_653B_51FB_76EE_6807(record["单位"], target)
    end
end
____exports["处理失控英灵普攻命中"] = function(record, target, applied, snapshot, _____5F53_524D_6BEB_79D2)
    local ____temp_6 = not (applied > 0)
    if not ____temp_6 then
        local ____opt_result_5
        if snapshot ~= nil then
            ____opt_result_5 = snapshot.isNormalAttack
        end
        ____temp_6 = ____opt_result_5 ~= true
    end
    if ____temp_6 or not _____662F_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4(target) then
        return
    end
    if _____5F53_524D_6BEB_79D2 < record["上次被动毫秒"] + _____5931_63A7_82F1_7075_914D_7F6E["被动冷却毫秒"] then
        return
    end
    record["上次被动毫秒"] = _____5F53_524D_6BEB_79D2
    _____6E05_9664_5355_4F4D_6307_5B9ABuff(target, _____5C01_5370_5B88_536B_6218BuffID["暗影侵蚀减速"])
    _____65BD_52A0_5FEB_901F_51CF_901FBuff(
        record["单位"],
        target,
        0,
        _____5931_63A7_82F1_7075_914D_7F6E["减速比例"],
        _____5931_63A7_82F1_7075_914D_7F6E["减速持续秒"],
        "封印守卫战-失控英灵缚魂斩",
        "技能",
        _____5C01_5370_5B88_536B_6218BuffID["缚魂减速"]
    )
    _____64AD_653E_5C01_5370_5B88_536B_6218_5355_4F4D_4E34_65F6_7279_6548(target, _____5931_63A7_82F1_7075_914D_7F6E["减速特效"], _____5931_63A7_82F1_7075_914D_7F6E["减速持续秒"])
end
return ____exports
