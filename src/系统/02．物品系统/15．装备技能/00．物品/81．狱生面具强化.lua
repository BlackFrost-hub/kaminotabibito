local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.07．获得物品.00．公共.00．获得物品配置表")
local _____72F1_751F_9762_5177_914D_7F6E = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["狱生面具配置"]
local _____83B7_5F97_7269_54C1_88C5_5907ID = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["获得物品装备ID"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果")
local _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C = ____require_result_0["注册持有型周期效果"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_2["减少魔法值"]
local ____require_result_3 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____83B7_53D6_8303_56F4_654C_4EBA = ____require_result_3["获取范围敌人"]
local _____53D6_5355_4F4DX = ____require_result_3["取单位X"]
local _____53D6_5355_4F4DY = ____require_result_3["取单位Y"]
local _____53D6_6700_5927_9B54_6CD5 = ____require_result_3["取最大魔法"]
local _____53D6_6700_5927_751F_547D = ____require_result_3["取最大生命"]
local _____53D6_5F53_524D_751F_547D = ____require_result_3["取当前生命"]
local _____53D6_5F53_524D_9B54_6CD5 = ____require_result_3["取当前魔法"]
local _____9020_6210_6697_5F71_4F24_5BB3 = ____require_result_3["造成暗影伤害"]
local _____6267_884C_6CBB_7597 = ____require_result_3["执行治疗"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____5F3A_5316_72F1_751F_9762_5177_5EF6_8FDF_961F_5217 = {}
local _____5DF2_6CE8_518C_5F3A_5316_72F1_751F_9762_5177_5EF6_8FDF_5904_7406 = false
local function _____5355_4F4D_5DF2_6B7B_4EA1(unit)
    return unit == nil or unit == 0 or IsUnitType(unit, UNIT_TYPE_DEAD) == true
end
local function _____521B_5EFA_5F3A_5316_72F1_751F_9762_5177_5EF6_8FDF_8BB0_5F55(source, target)
    _____5F3A_5316_72F1_751F_9762_5177_5EF6_8FDF_961F_5217[#_____5F3A_5316_72F1_751F_9762_5177_5EF6_8FDF_961F_5217 + 1] = {
        ["来源单位"] = source,
        ["目标单位"] = target,
        ["到期时间"] = getServerTime() + _____72F1_751F_9762_5177_914D_7F6E["强化延迟毫秒"]
    }
end
local function ____on_5F3A_5316_72F1_751F_9762_5177_5EF6_8FDF_7ED3_7B97()
    local now = getServerTime()
    do
        local i = #_____5F3A_5316_72F1_751F_9762_5177_5EF6_8FDF_961F_5217 - 1
        while i >= 0 do
            do
                local record = _____5F3A_5316_72F1_751F_9762_5177_5EF6_8FDF_961F_5217[i + 1]
                if record == nil or now < record["到期时间"] then
                    goto __continue6
                end
                __TS__ArraySplice(_____5F3A_5316_72F1_751F_9762_5177_5EF6_8FDF_961F_5217, i, 1)
                if record["来源单位"] == nil or record["来源单位"] == 0 or _____5355_4F4D_5DF2_6B7B_4EA1(record["来源单位"]) then
                    goto __continue6
                end
                if not _____5355_4F4D_5DF2_6B7B_4EA1(record["目标单位"]) then
                    goto __continue6
                end
                local heal = (_____53D6_6700_5927_751F_547D(record["来源单位"]) - _____53D6_5F53_524D_751F_547D(record["来源单位"])) * _____72F1_751F_9762_5177_914D_7F6E["强化恢复比例"]
                local mana = (_____53D6_6700_5927_9B54_6CD5(record["来源单位"]) - _____53D6_5F53_524D_9B54_6CD5(record["来源单位"])) * _____72F1_751F_9762_5177_914D_7F6E["强化恢复比例"]
                _____6267_884C_6CBB_7597(record["来源单位"], record["来源单位"], heal, mana)
            end
            ::__continue6::
            i = i - 1
        end
    end
end
local function _____786E_4FDD_6CE8_518C_5F3A_5316_72F1_751F_9762_5177_5EF6_8FDF_5904_7406()
    if _____5DF2_6CE8_518C_5F3A_5316_72F1_751F_9762_5177_5EF6_8FDF_5904_7406 then
        return
    end
    _____5DF2_6CE8_518C_5F3A_5316_72F1_751F_9762_5177_5EF6_8FDF_5904_7406 = true
    addPeriodicCallback(100, ____on_5F3A_5316_72F1_751F_9762_5177_5EF6_8FDF_7ED3_7B97)
end
local function ____on_72F1_751F_9762_5177_5F3A_5316_5468_671F(unit)
    local consumed = -_____51CF_5C11_9B54_6CD5_503C(
        unit,
        _____53D6_6700_5927_9B54_6CD5(unit) * _____72F1_751F_9762_5177_914D_7F6E["最大魔法消耗比例"],
        false,
        false
    )
    if not (consumed > 0) then
        return
    end
    local damage = consumed * _____72F1_751F_9762_5177_914D_7F6E["强化伤害倍率"]
    local targets = _____83B7_53D6_8303_56F4_654C_4EBA(
        unit,
        _____53D6_5355_4F4DX(unit),
        _____53D6_5355_4F4DY(unit),
        _____72F1_751F_9762_5177_914D_7F6E["作用范围"]
    )
    do
        local i = 0
        while i < #targets do
            local target = targets[i + 1]
            _____9020_6210_6697_5F71_4F24_5BB3(unit, target, damage)
            _____521B_5EFA_5F3A_5316_72F1_751F_9762_5177_5EF6_8FDF_8BB0_5F55(unit, target)
            i = i + 1
        end
    end
end
local function _____521D_59CB_5316_72F1_751F_9762_5177_5F3A_5316()
    if _____83B7_5F97_7269_54C1_88C5_5907ID["狱生面具强化"] == 0 then
        return
    end
    _____786E_4FDD_6CE8_518C_5F3A_5316_72F1_751F_9762_5177_5EF6_8FDF_5904_7406()
    _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C({["物品类型ID"] = _____83B7_5F97_7269_54C1_88C5_5907ID["狱生面具强化"], ["间隔毫秒"] = _____72F1_751F_9762_5177_914D_7F6E["间隔毫秒"], ["周期回调"] = ____on_72F1_751F_9762_5177_5F3A_5316_5468_671F})
end
_____521D_59CB_5316_72F1_751F_9762_5177_5F3A_5316()
return ____exports
