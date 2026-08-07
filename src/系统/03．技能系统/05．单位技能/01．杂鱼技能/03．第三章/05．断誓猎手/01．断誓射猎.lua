--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.05．断誓猎手.00．配置")
local _____65AD_8A93_730E_624B_914D_7F6E = ____00_FF0E_914D_7F6E["断誓猎手配置"]
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.00．封印守卫战公共.01．共享")
local _____547D_4EE4_653B_51FB_76EE_6807 = ____01_FF0E_5171_4EAB["命令攻击目标"]
local _____547D_4EE4_79FB_52A8_5230_70B9 = ____01_FF0E_5171_4EAB["命令移动到点"]
local _____53D6_5355_4F4DX = ____01_FF0E_5171_4EAB["取单位X"]
local _____53D6_5355_4F4DY = ____01_FF0E_5171_4EAB["取单位Y"]
local _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9 = ____01_FF0E_5171_4EAB["取单位距离平方"]
local _____53D6_6700_8FD1_73A9_5BB6_82F1_96C4 = ____01_FF0E_5171_4EAB["取最近玩家英雄"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_6838_5FC3 = ____01_FF0E_5171_4EAB["读取封印守卫战核心"]
local _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B = ____01_FF0E_5171_4EAB["封印守卫战单位存活"]
local jass = require("jass.common")
local ____require_result_0 = require("平台扩展API动作")
local _____5355_4F4D__8BBE_7F6E_6BCF_79D2_751F_547D_6062_590D = ____require_result_0["单位_设置每秒生命恢复"]
local ____require_result_1 = require("平台扩展API取值")
local _____5355_4F4D__83B7_53D6_6BCF_79D2_751F_547D_6062_590D = ____require_result_1["单位_获取每秒生命恢复"]
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("系统.05．Buff系统.03．Buff表.04．单位.01．封印守卫战")
local _____5C01_5370_5B88_536B_6218BuffID = ____require_result_3["封印守卫战BuffID"]
local SquareRoot = jass.SquareRoot
local _____538B_5236_6838_5FC3 = nil
local _____6838_5FC3_539F_751F_547D_6062_590D = 0
local _____6838_5FC3_6062_590D_538B_5236_7ED3_675F_6BEB_79D2 = 0
local _____6838_5FC3_6062_590D_5DF2_538B_5236 = false
local function _____6062_590D_6838_5FC3_751F_547D_6062_590D()
    if _____6838_5FC3_6062_590D_5DF2_538B_5236 and _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(_____538B_5236_6838_5FC3) then
        _____5355_4F4D__8BBE_7F6E_6BCF_79D2_751F_547D_6062_590D(_____538B_5236_6838_5FC3, _____6838_5FC3_539F_751F_547D_6062_590D)
    end
    if _____538B_5236_6838_5FC3 ~= nil and _____538B_5236_6838_5FC3 ~= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____538B_5236_6838_5FC3, _____5C01_5370_5B88_536B_6218BuffID["核心生命回复压制"])
    end
    _____538B_5236_6838_5FC3 = nil
    _____6838_5FC3_539F_751F_547D_6062_590D = 0
    _____6838_5FC3_6062_590D_538B_5236_7ED3_675F_6BEB_79D2 = 0
    _____6838_5FC3_6062_590D_5DF2_538B_5236 = false
end
local function _____5E94_7528_6838_5FC3_751F_547D_6062_590D_538B_5236(source, core, _____5F53_524D_6BEB_79D2)
    if _____6838_5FC3_6062_590D_5DF2_538B_5236 and _____538B_5236_6838_5FC3 ~= core then
        _____6062_590D_6838_5FC3_751F_547D_6062_590D()
    end
    if not _____6838_5FC3_6062_590D_5DF2_538B_5236 then
        _____538B_5236_6838_5FC3 = core
        _____6838_5FC3_539F_751F_547D_6062_590D = _____5355_4F4D__83B7_53D6_6BCF_79D2_751F_547D_6062_590D(core) or 0
        _____5355_4F4D__8BBE_7F6E_6BCF_79D2_751F_547D_6062_590D(core, _____6838_5FC3_539F_751F_547D_6062_590D * (1 - _____65AD_8A93_730E_624B_914D_7F6E["回血压制比例"]))
        _____6838_5FC3_6062_590D_5DF2_538B_5236 = true
    end
    _____6838_5FC3_6062_590D_538B_5236_7ED3_675F_6BEB_79D2 = _____5F53_524D_6BEB_79D2 + _____65AD_8A93_730E_624B_914D_7F6E["回血压制持续毫秒"]
    registerManualBuff(
        core,
        _____5C01_5370_5B88_536B_6218BuffID["核心生命回复压制"],
        _____65AD_8A93_730E_624B_914D_7F6E["回血压制持续毫秒"] / 1000,
        _____65AD_8A93_730E_624B_914D_7F6E["回血压制比例"],
        {sourceUnit = source, effectSourceName = "断誓猎手-断誓射猎", effectSourceType = "技能"}
    )
end
____exports["刷新断誓猎手核心压制"] = function(_____5F53_524D_6BEB_79D2)
    if not _____6838_5FC3_6062_590D_5DF2_538B_5236 then
        return
    end
    if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(_____538B_5236_6838_5FC3) or _____5F53_524D_6BEB_79D2 >= _____6838_5FC3_6062_590D_538B_5236_7ED3_675F_6BEB_79D2 then
        _____6062_590D_6838_5FC3_751F_547D_6062_590D()
    end
end
____exports["修正断誓猎手核心普攻"] = function(record, context, _____5F53_524D_6BEB_79D2)
    local core = _____8BFB_53D6_5C01_5370_5B88_536B_6218_6838_5FC3()
    local ____opt_result_6
    if context ~= nil then
        ____opt_result_6 = context.isNormalAttack
    end
    if ____opt_result_6 ~= true or context.target ~= core or not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(core) then
        return context.currentDamage
    end
    record["普攻计数"] = record["普攻计数"] + 1
    if record["普攻计数"] < 4 then
        return context.currentDamage
    end
    record["普攻计数"] = 0
    _____5E94_7528_6838_5FC3_751F_547D_6062_590D_538B_5236(record["单位"], core, _____5F53_524D_6BEB_79D2)
    return context.currentDamage * _____65AD_8A93_730E_624B_914D_7F6E["第四击伤害倍率"]
end
____exports["刷新断誓猎手AI"] = function(record, _____5F53_524D_6BEB_79D2)
    if _____5F53_524D_6BEB_79D2 < record["下次AI毫秒"] then
        return
    end
    record["下次AI毫秒"] = _____5F53_524D_6BEB_79D2 + _____65AD_8A93_730E_624B_914D_7F6E["AI刷新毫秒"]
    local closeHero = _____53D6_6700_8FD1_73A9_5BB6_82F1_96C4(record["单位"], _____65AD_8A93_730E_624B_914D_7F6E["转火玩家范围"])
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(closeHero) then
        record["当前目标"] = closeHero
        _____547D_4EE4_653B_51FB_76EE_6807(record["单位"], closeHero)
        return
    end
    local core = _____8BFB_53D6_5C01_5370_5B88_536B_6218_6838_5FC3()
    if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(core) then
        return
    end
    local distanceSq = _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9(record["单位"], core)
    if distanceSq < _____65AD_8A93_730E_624B_914D_7F6E["核心最小站位距离"] * _____65AD_8A93_730E_624B_914D_7F6E["核心最小站位距离"] then
        local ux = _____53D6_5355_4F4DX(record["单位"])
        local uy = _____53D6_5355_4F4DY(record["单位"])
        local cx = _____53D6_5355_4F4DX(core)
        local cy = _____53D6_5355_4F4DY(core)
        local dx = ux - cx
        local dy = uy - cy
        local distance = SquareRoot(distanceSq)
        if distance > 0 then
            _____547D_4EE4_79FB_52A8_5230_70B9(record["单位"], cx + dx / distance * _____65AD_8A93_730E_624B_914D_7F6E["核心理想站位距离"], cy + dy / distance * _____65AD_8A93_730E_624B_914D_7F6E["核心理想站位距离"])
            return
        end
    end
    record["当前目标"] = core
    _____547D_4EE4_653B_51FB_76EE_6807(record["单位"], core)
end
____exports["清理断誓猎手全局机制"] = function()
    _____6062_590D_6838_5FC3_751F_547D_6062_590D()
end
return ____exports
