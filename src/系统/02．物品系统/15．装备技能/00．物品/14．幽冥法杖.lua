--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7 = ____20_FF0E_7269_54C1_8F85_52A9["主动物品调试日志"]
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____5E7D_51A5_6CD5_6756_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["幽冥法杖物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____5E7D_51A5_6CD5_6756_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["幽冥法杖配置"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createUnitEffect = ____require_result_0.createUnitEffect
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local getObjectPropertyRealSafe = ____require_result_1.getObjectPropertyRealSafe
local ObjectType = ____require_result_1.ObjectType
local GetItemTypeId = jass.GetItemTypeId
local GetUnitState = jass.GetUnitState
local GetUnitTypeId = jass.GetUnitTypeId
local KillUnit = jass.KillUnit
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local EXSetEffectSize = japi.EXSetEffectSize
local function _____662F_5426_4E3A_5E7D_51A5_6CD5_6756(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____5E7D_51A5_6CD5_6756_7269_54C1ID
end
____exports["处理幽冥法杖使用"] = function(_____4E0A_4E0B_6587)
    _____4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7("15．幽冥法杖", "进入", "处理幽冥法杖使用")
    if not _____662F_5426_4E3A_5E7D_51A5_6CD5_6756(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____76EE_6807_5355_4F4D = _____4E0A_4E0B_6587["目标单位"]
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    if GetUnitState(_____76EE_6807_5355_4F4D, UNIT_STATE_MAX_LIFE) * _____5E7D_51A5_6CD5_6756_914D_7F6E["斩杀生命比例"] < GetUnitState(_____76EE_6807_5355_4F4D, UNIT_STATE_LIFE) then
        return
    end
    KillUnit(_____76EE_6807_5355_4F4D)
    local _____7279_6548 = createUnitEffect(
        _____76EE_6807_5355_4F4D,
        _____5E7D_51A5_6CD5_6756_914D_7F6E["特效挂点"],
        _____5E7D_51A5_6CD5_6756_914D_7F6E["特效路径"],
        _____5E7D_51A5_6CD5_6756_914D_7F6E["特效持续时间"],
        "幽冥法杖"
    )
    if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
        EXSetEffectSize(
            _____7279_6548,
            getObjectPropertyRealSafe(
                ObjectType.UNIT,
                GetUnitTypeId(_____76EE_6807_5355_4F4D),
                "modelScale"
            )
        )
    end
end
return ____exports
