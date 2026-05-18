--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____7130_865A_5B9D_73E0_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["焰虚宝珠物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____7130_865A_5B9D_73E0_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["焰虚宝珠配置"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createUnitEffect = ____require_result_1.createUnitEffect
local GetItemTypeId = jass.GetItemTypeId
local UnitRemoveBuffsEx = jass.UnitRemoveBuffsEx
local EXSetEffectSize = japi.EXSetEffectSize
local function _____662F_5426_4E3A_7130_865A_5B9D_73E0(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____7130_865A_5B9D_73E0_7269_54C1ID
end
____exports["处理焰虚宝珠使用"] = function(_____4E0A_4E0B_6587)
    debugLogForce("23．焰虚宝珠", "进入", "处理焰虚宝珠使用")
    if not _____662F_5426_4E3A_7130_865A_5B9D_73E0(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    local _____76EE_6807_5355_4F4D = _____4E0A_4E0B_6587["目标单位"]
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 or _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    local _____7279_6548 = createUnitEffect(
        _____65BD_6CD5_5355_4F4D,
        _____7130_865A_5B9D_73E0_914D_7F6E["特效挂点"],
        _____7130_865A_5B9D_73E0_914D_7F6E["特效路径"],
        _____7130_865A_5B9D_73E0_914D_7F6E["特效持续时间"],
        "焰虚宝珠"
    )
    if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
        EXSetEffectSize(_____7279_6548, _____7130_865A_5B9D_73E0_914D_7F6E["特效大小"])
    end
    UnitRemoveBuffsEx(
        _____76EE_6807_5355_4F4D,
        false,
        true,
        false,
        false,
        false,
        false,
        true
    )
end
return ____exports
