--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.01．运行时上下文")
local _____83B7_53D6_5168_90E8_91CC_79D1_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部里科特上下文"]
local _____5237_65B0_91CC_79D1_7279_9636_6BB5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["刷新里科特阶段"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.02．数值与表现配置")
local _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["里科特数值与表现配置"]
local ____13_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.13．公共工具")
local _____5355_4F4D_6709_6548 = ____13_FF0E_516C_5171_5DE5_5177["单位有效"]
local jass = require("jass.common")
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____6E05_9664_5355_4F4D_8F6F_63A7_5236Buff_5408_96C6 = ____require_result_3["清除单位软控制Buff合集"]
local ____require_result_4 = require("系统.05．Buff系统.03．Buff表.01．Boss.07．里科特")
local _____91CC_79D1_7279BuffID = ____require_result_4["里科特BuffID"]
local _____5DF2_6CE8_518C = false
local function ____on_91CC_79D1_7279_88AB_52A8Tick()
    local contexts = _____83B7_53D6_5168_90E8_91CC_79D1_7279_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #contexts do
            do
                local context = contexts[i + 1]
                local boss = context["Boss单位"]
                local ____temp_6 = not _____5355_4F4D_6709_6548(boss)
                if not ____temp_6 then
                    local ____self_5 = context["清理"]
                    ____temp_6 = ____self_5["已清理"](____self_5)
                end
                if ____temp_6 then
                    goto __continue4
                end
                _____5237_65B0_91CC_79D1_7279_9636_6BB5(context)
                _____6E05_9664_5355_4F4D_8F6F_63A7_5236Buff_5408_96C6(boss)
                registerManualBuff(
                    boss,
                    _____91CC_79D1_7279BuffID["精灵之风"],
                    2,
                    1,
                    {sourceName = "里科特-精灵之风"}
                )
                registerManualBuff(
                    boss,
                    _____91CC_79D1_7279BuffID["神明祝福"],
                    2,
                    1,
                    {sourceName = "里科特-神明祝福"}
                )
                local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
                local life = GetUnitState(boss, UNIT_STATE_LIFE)
                local heal = maxLife * _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["被动"]["每秒回血比例"]
                if maxLife > 0 and heal > 0 and life < maxLife then
                    SetUnitState(boss, UNIT_STATE_LIFE, life + heal > maxLife and maxLife or life + heal)
                end
            end
            ::__continue4::
            i = i + 1
        end
    end
end
local function ____on_91CC_79D1_7279_795E_660E_795D_798F_4F24_5BB3_4E0A_9650(damageContext)
    local contexts = _____83B7_53D6_5168_90E8_91CC_79D1_7279_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #contexts do
            do
                local context = contexts[i + 1]
                if damageContext.target ~= context["Boss单位"] or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
                    goto __continue9
                end
                local maxLife = GetUnitState(context["Boss单位"], UNIT_STATE_MAX_LIFE)
                if not (maxLife > 0) then
                    return damageContext.currentDamage
                end
                local capRatio = 0.19
                local cap = maxLife * capRatio
                return damageContext.currentDamage > cap and cap or damageContext.currentDamage
            end
            ::__continue9::
            i = i + 1
        end
    end
    return damageContext.currentDamage
end
____exports["注册里科特被动机制"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    addPeriodicCallback(1000, ____on_91CC_79D1_7279_88AB_52A8Tick)
    registerDamageModifier(____on_91CC_79D1_7279_795E_660E_795D_798F_4F24_5BB3_4E0A_9650, 80)
end
return ____exports
