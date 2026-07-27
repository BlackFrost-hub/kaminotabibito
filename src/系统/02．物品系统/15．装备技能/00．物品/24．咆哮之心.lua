--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7 = ____20_FF0E_7269_54C1_8F85_52A9["主动物品调试日志"]
local ____10_FF0E_88C5_5907_6218_6597_6267_884C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行")
local _____9020_6210_88C5_5907_4F24_5BB3 = ____10_FF0E_88C5_5907_6218_6597_6267_884C["造成装备伤害"]
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____5486_54EE_4E4B_5FC3_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["咆哮之心物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____5486_54EE_4E4B_5FC3_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["咆哮之心配置"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____20_FF0E_7269_54C1_8F85_52A9["施加临时属性效果"]
local ____10_FF0E_5468_671F_6267_884C_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.10．周期执行模板.index")
local _____542F_52A8_8BA1_6570_5468_671F_6267_884C = ____10_FF0E_5468_671F_6267_884C_6A21_677F["启动计数周期执行"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_0.createTimedEffect
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local GetItemTypeId = jass.GetItemTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ConvertUnitState = jass.ConvertUnitState
local R2I = jass.R2I
local DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND
local GetUnitStateJapi = japi.GetUnitState
local function _____662F_5426_4E3A_5486_54EE_4E4B_5FC3(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____5486_54EE_4E4B_5FC3_7269_54C1ID
end
local function ____on_5486_54EE_4E4B_5FC3_5468_671F(_____4E0A_4E0B_6587, _____5F53_524D_6B21_6570)
    if _____5F53_524D_6B21_6570 > _____5486_54EE_4E4B_5FC3_914D_7F6E["次数"] then
        _____4E0A_4E0B_6587["属性效果"]["清除"]()
        return false
    end
    createTimedEffect(
        _____5486_54EE_4E4B_5FC3_914D_7F6E["特效路径"],
        GetUnitX(_____4E0A_4E0B_6587["目标单位"]),
        GetUnitY(_____4E0A_4E0B_6587["目标单位"]),
        0,
        _____5486_54EE_4E4B_5FC3_914D_7F6E["特效持续时间"]
    )
    _____9020_6210_88C5_5907_4F24_5BB3(
        _____4E0A_4E0B_6587["施法单位"],
        _____4E0A_4E0B_6587["目标单位"],
        _____5486_54EE_4E4B_5FC3_914D_7F6E["每跳伤害"],
        DAMAGE_TYPE_MIND,
        false,
        nil,
        {["伤害形态"] = "单体"}
    )
end
____exports["处理咆哮之心使用"] = function(_____4E0A_4E0B_6587)
    _____4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7("25．咆哮之心", "进入", "处理咆哮之心使用")
    if not _____662F_5426_4E3A_5486_54EE_4E4B_5FC3(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    local _____76EE_6807_5355_4F4D = _____4E0A_4E0B_6587["目标单位"]
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 or _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    local _____6301_7EED_6BEB_79D2 = _____5486_54EE_4E4B_5FC3_914D_7F6E["次数"] * _____5486_54EE_4E4B_5FC3_914D_7F6E["周期"] * 1000
    local _____9644_52A0_653B_51FB = R2I(GetUnitStateJapi(
        _____76EE_6807_5355_4F4D,
        ConvertUnitState(21)
    ) / _____5486_54EE_4E4B_5FC3_914D_7F6E["力量转攻击除数"])
    registerManualBuff(
        _____76EE_6807_5355_4F4D,
        "C028",
        _____6301_7EED_6BEB_79D2 / 1000,
        _____9644_52A0_653B_51FB,
        {sourceUnit = _____65BD_6CD5_5355_4F4D, effectSourceName = "咆哮之心", effectSourceType = "装备"}
    )
    local _____5C5E_6027_6548_679C = _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(_____76EE_6807_5355_4F4D, _____6301_7EED_6BEB_79D2, {{["类型"] = "攻击", ["数值"] = _____9644_52A0_653B_51FB}})
    local _____5468_671F_4E0A_4E0B_6587 = {["施法单位"] = _____65BD_6CD5_5355_4F4D, ["目标单位"] = _____76EE_6807_5355_4F4D, ["属性效果"] = _____5C5E_6027_6548_679C}
    _____542F_52A8_8BA1_6570_5468_671F_6267_884C({
        ["间隔毫秒"] = _____5486_54EE_4E4B_5FC3_914D_7F6E["周期"] * 1000,
        ["最大次数"] = _____5486_54EE_4E4B_5FC3_914D_7F6E["次数"],
        ["on周期"] = function(event)
            return ____on_5486_54EE_4E4B_5FC3_5468_671F(_____5468_671F_4E0A_4E0B_6587, event["当前次数"])
        end
    })
end
return ____exports
