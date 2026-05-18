--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____7194_5CA9_6743_6756_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["熔岩权杖物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____7194_5CA9_6743_6756_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["熔岩权杖配置"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local jass = require("jass.common")
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_1["创建原生弹幕"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_2["施加扩展控制"]
local ____require_result_3 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local _____5EF6_540E_4E00_5E27_6267_884C_4F24_5BB3_6D3E_751F_6548_679C = ____require_result_3["延后一帧执行伤害派生效果"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetItemTypeId = jass.GetItemTypeId
local UnitDamageTarget = jass.UnitDamageTarget
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local function _____662F_5426_4E3A_7194_5CA9_6743_6756(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____7194_5CA9_6743_6756_7269_54C1ID
end
local function _____53D1_5C04_7194_5CA9_5F39_5E55(_____65BD_6CD5_8005, _____76EE_6807_5355_4F4D)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = _____65BD_6CD5_8005,
        X = GetUnitX(_____65BD_6CD5_8005),
        Y = GetUnitY(_____65BD_6CD5_8005),
        ["速度"] = _____7194_5CA9_6743_6756_914D_7F6E["速度"],
        ["轨迹类型"] = "追踪",
        ["指定目标"] = _____76EE_6807_5355_4F4D,
        ["命中半径"] = 100,
        ["生命周"] = 8,
        ["碰撞消失"] = true,
        ["最大总命中次数"] = 1,
        ["每单位最大命中次数"] = 1,
        ["最大总距离"] = 5000,
        ["模型"] = _____7194_5CA9_6743_6756_914D_7F6E["弹幕模型"],
        ["on命中单位"] = function(_____547D_4E2D_5355_4F4D)
            if _____547D_4E2D_5355_4F4D == nil or _____547D_4E2D_5355_4F4D == 0 then
                return
            end
            UnitDamageTarget(
                _____65BD_6CD5_8005,
                _____547D_4E2D_5355_4F4D,
                _____7194_5CA9_6743_6756_914D_7F6E["伤害值"],
                false,
                false,
                ATTACK_TYPE_NORMAL,
                DAMAGE_TYPE_FIRE,
                WEAPON_TYPE_WHOKNOWS
            )
            _____65BD_52A0_6269_5C55_63A7_5236(_____65BD_6CD5_8005, _____547D_4E2D_5355_4F4D, "stun", {["持续时间"] = _____7194_5CA9_6743_6756_914D_7F6E["控制时间"]})
        end
    })
end
____exports["处理熔岩权杖使用"] = function(_____4E0A_4E0B_6587)
    debugLogForce("04．熔岩权杖", "进入", "处理熔岩权杖使用")
    if not _____662F_5426_4E3A_7194_5CA9_6743_6756(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    _____5EF6_540E_4E00_5E27_6267_884C_4F24_5BB3_6D3E_751F_6548_679C(function()
        debugLogForce("04．熔岩权杖", "延后一帧发射熔岩弹幕")
        _____53D1_5C04_7194_5CA9_5F39_5E55(_____4E0A_4E0B_6587["施法单位"], _____4E0A_4E0B_6587["目标单位"])
    end)
end
return ____exports
