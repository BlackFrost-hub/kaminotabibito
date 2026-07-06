--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7 = ____20_FF0E_7269_54C1_8F85_52A9["主动物品调试日志"]
local ____10_FF0E_88C5_5907_6218_6597_6267_884C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行")
local _____9020_6210_88C5_5907_4F24_5BB3 = ____10_FF0E_88C5_5907_6218_6597_6267_884C["造成装备伤害"]
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____53F2_8BD7_8FDC_53E4_9B54_5203_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["史诗远古魔刃物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["史诗远古魔刃配置"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_0.createTimedEffect
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_1["施加扩展控制"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.03．路径技能模板.index")
local _____521B_5EFA_7EBF_6027_626B_63A0_547D_4E2D = ____require_result_2["创建线性扫掠命中"]
local GetItemTypeId = jass.GetItemTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ConvertUnitState = jass.ConvertUnitState
local Atan2 = jass.Atan2
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local GetUnitStateJapi = japi.GetUnitState
local function _____662F_5426_4E3A_53F2_8BD7_8FDC_53E4_9B54_5203(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____53F2_8BD7_8FDC_53E4_9B54_5203_7269_54C1ID
end
____exports["处理史诗远古魔刃使用"] = function(_____4E0A_4E0B_6587)
    _____4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7("22．史诗远古魔刃", "进入", "处理史诗远古魔刃使用")
    if not _____662F_5426_4E3A_53F2_8BD7_8FDC_53E4_9B54_5203(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return
    end
    local _____8D77_70B9X = GetUnitX(_____65BD_6CD5_5355_4F4D)
    local _____8D77_70B9Y = GetUnitY(_____65BD_6CD5_5355_4F4D)
    _____521B_5EFA_7EBF_6027_626B_63A0_547D_4E2D({
        ["施法单位"] = _____65BD_6CD5_5355_4F4D,
        ["起点X"] = _____8D77_70B9X,
        ["起点Y"] = _____8D77_70B9Y,
        ["方向弧度"] = Atan2(_____4E0A_4E0B_6587["目标Y"] - _____8D77_70B9Y, _____4E0A_4E0B_6587["目标X"] - _____8D77_70B9X),
        ["周期秒"] = _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["周期"],
        ["最大次数"] = _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["最大次数"],
        ["每次距离"] = _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["每次距离"],
        ["作用范围"] = _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["作用范围"],
        ["on步进"] = function(_____626B_63A0_4E0A_4E0B_6587)
            createTimedEffect(
                _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["特效路径"],
                _____626B_63A0_4E0A_4E0B_6587["当前X"],
                _____626B_63A0_4E0A_4E0B_6587["当前Y"],
                0,
                _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["特效持续时间"]
            )
        end,
        ["on命中"] = function(_____654C_4EBA, _____626B_63A0_4E0A_4E0B_6587)
            local _____4F24_5BB3_503C = GetUnitStateJapi(
                _____626B_63A0_4E0A_4E0B_6587["施法单位"],
                ConvertUnitState(21)
            ) * _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["力量系数"]
            _____9020_6210_88C5_5907_4F24_5BB3(
                _____626B_63A0_4E0A_4E0B_6587["施法单位"],
                _____654C_4EBA,
                _____4F24_5BB3_503C,
                DAMAGE_TYPE_NORMAL,
                false,
                nil,
                {["伤害形态"] = "AOE"}
            )
            _____65BD_52A0_6269_5C55_63A7_5236(_____626B_63A0_4E0A_4E0B_6587["施法单位"], _____654C_4EBA, "stun", {["持续时间"] = _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["眩晕时间"]})
        end
    })
end
return ____exports
