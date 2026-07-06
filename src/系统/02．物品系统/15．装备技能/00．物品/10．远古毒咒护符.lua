--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7 = ____20_FF0E_7269_54C1_8F85_52A9["主动物品调试日志"]
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____8FDC_53E4_6BD2_5492_62A4_7B26_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["远古毒咒护符物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____8FDC_53E4_6BD2_5492_62A4_7B26_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["远古毒咒护符配置"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_0.createTimedEffect
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
local _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA = ____require_result_1["获取坐标范围敌人"]
local _____5355_4F4D_662F_5426_6709_6548_4E14_654C_5BF9 = ____require_result_1["单位是否有效且敌对"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行")
local _____9020_6210_88C5_5907_4F24_5BB3 = ____require_result_2["造成装备伤害"]
local GetItemTypeId = jass.GetItemTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ConvertUnitState = jass.ConvertUnitState
local GetUnitStateJapi = japi.GetUnitState
local DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON
local function _____662F_5426_4E3A_8FDC_53E4_6BD2_5492_62A4_7B26(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____8FDC_53E4_6BD2_5492_62A4_7B26_7269_54C1ID
end
____exports["处理远古毒咒护符使用"] = function(_____4E0A_4E0B_6587)
    _____4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7("11．远古毒咒护符", "进入", "处理远古毒咒护符使用")
    if not _____662F_5426_4E3A_8FDC_53E4_6BD2_5492_62A4_7B26(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return
    end
    local x = GetUnitX(_____65BD_6CD5_5355_4F4D)
    local y = GetUnitY(_____65BD_6CD5_5355_4F4D)
    createTimedEffect(
        _____8FDC_53E4_6BD2_5492_62A4_7B26_914D_7F6E["特效路径"],
        x,
        y,
        0,
        _____8FDC_53E4_6BD2_5492_62A4_7B26_914D_7F6E["特效持续时间"]
    )
    local _____4F24_5BB3_503C = GetUnitStateJapi(
        _____65BD_6CD5_5355_4F4D,
        ConvertUnitState(21)
    ) * _____8FDC_53E4_6BD2_5492_62A4_7B26_914D_7F6E["力量系数"]
    local _____654C_4EBA_5217_8868 = _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA(_____65BD_6CD5_5355_4F4D, x, y, _____8FDC_53E4_6BD2_5492_62A4_7B26_914D_7F6E["作用范围"])
    do
        local i = 0
        while i < #_____654C_4EBA_5217_8868 do
            do
                local _____654C_4EBA = _____654C_4EBA_5217_8868[i + 1]
                if not _____5355_4F4D_662F_5426_6709_6548_4E14_654C_5BF9(_____654C_4EBA, _____65BD_6CD5_5355_4F4D) then
                    goto __continue8
                end
                _____9020_6210_88C5_5907_4F24_5BB3(
                    _____65BD_6CD5_5355_4F4D,
                    _____654C_4EBA,
                    _____4F24_5BB3_503C,
                    DAMAGE_TYPE_POISON,
                    false,
                    nil,
                    {["伤害形态"] = "AOE"}
                )
            end
            ::__continue8::
            i = i + 1
        end
    end
end
return ____exports
