local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____7834_8840_4E4B_6212_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["破血之戒物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____7834_8840_4E4B_6212_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["破血之戒配置"]
local ____01_FF0E_7269_54C1_4F7F_7528_89E6_53D1_5E38_91CF = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.01．物品使用触发常量")
local _____7834_8840_4E4B_6212_7279_6548_952E = ____01_FF0E_7269_54C1_4F7F_7528_89E6_53D1_5E38_91CF["破血之戒特效键"]
local _____7834_8840_4E4B_6212_7ED1_5B9A_9644_7740_70B9 = ____01_FF0E_7269_54C1_4F7F_7528_89E6_53D1_5E38_91CF["破血之戒绑定附着点"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local jass = require("jass.common")
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_1.createTimedEffect
local _____521B_5EFADz_7ED1_5B9A_5355_4F4D_7279_6548 = ____require_result_1["创建Dz绑定单位特效"]
local _____9500_6BC1Dz_7ED1_5B9A_5355_4F4D_7279_6548 = ____require_result_1["销毁Dz绑定单位特效"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_2["开始充能"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
local _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA = ____require_result_3["获取坐标范围敌人"]
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local UnitDamageTarget = jass.UnitDamageTarget
local ConvertUnitState = jass.ConvertUnitState
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local _____7834_8840_4E4B_6212_4E0A_4E0B_6587_8868 = {}
local function _____662F_5426_4E3A_7834_8840_4E4B_6212(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return jass.GetItemTypeId(_____7269_54C1) == _____7834_8840_4E4B_6212_7269_54C1ID
end
local function _____83B7_53D6_7834_8840_4E4B_6212_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return jass.GetHandleId(_____5355_4F4D)
end
local function _____6E05_7406_7834_8840_4E4B_6212_4E0A_4E0B_6587(_____5355_4F4D)
    local _____5355_4F4DID = _____83B7_53D6_7834_8840_4E4B_6212_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4DID <= 0 then
        return
    end
    __TS__Delete(_____7834_8840_4E4B_6212_4E0A_4E0B_6587_8868, _____5355_4F4DID)
end
local function _____7ED3_7B97_7834_8840_4E4B_6212(_____65BD_6CD5_5355_4F4D)
    local _____5355_4F4DID = _____83B7_53D6_7834_8840_4E4B_6212_5355_4F4DID(_____65BD_6CD5_5355_4F4D)
    if _____5355_4F4DID <= 0 then
        return
    end
    local _____4E0A_4E0B_6587 = _____7834_8840_4E4B_6212_4E0A_4E0B_6587_8868[_____5355_4F4DID]
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    local _____4F24_5BB3_503C = _____7834_8840_4E4B_6212_914D_7F6E["基础伤害"] + GetUnitState(
        _____65BD_6CD5_5355_4F4D,
        ConvertUnitState(21)
    ) * 3
    local _____654C_4EBA_5217_8868 = _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA(_____65BD_6CD5_5355_4F4D, _____4E0A_4E0B_6587["目标X"], _____4E0A_4E0B_6587["目标Y"], _____7834_8840_4E4B_6212_914D_7F6E["作用范围"])
    createTimedEffect(
        _____7834_8840_4E4B_6212_914D_7F6E["选取特效路径"],
        _____4E0A_4E0B_6587["目标X"],
        _____4E0A_4E0B_6587["目标Y"],
        0,
        1
    )
    do
        local i = 0
        while i < #_____654C_4EBA_5217_8868 do
            do
                local _____654C_4EBA = _____654C_4EBA_5217_8868[i + 1]
                if _____654C_4EBA == nil or _____654C_4EBA == 0 then
                    goto __continue12
                end
                UnitDamageTarget(
                    _____65BD_6CD5_5355_4F4D,
                    _____654C_4EBA,
                    _____4F24_5BB3_503C,
                    false,
                    true,
                    ATTACK_TYPE_NORMAL,
                    DAMAGE_TYPE_ENHANCED,
                    WEAPON_TYPE_WHOKNOWS
                )
            end
            ::__continue12::
            i = i + 1
        end
    end
end
local function _____5F00_59CB_7834_8840_4E4B_6212_5145_80FD(_____65BD_6CD5_5355_4F4D)
    _____521B_5EFADz_7ED1_5B9A_5355_4F4D_7279_6548(_____65BD_6CD5_5355_4F4D, _____7834_8840_4E4B_6212_7ED1_5B9A_9644_7740_70B9, _____7834_8840_4E4B_6212_914D_7F6E["施法特效路径"], _____7834_8840_4E4B_6212_7279_6548_952E)
    _____5F00_59CB_5145_80FD(
        _____65BD_6CD5_5355_4F4D,
        {
            ["持续时间"] = _____7834_8840_4E4B_6212_914D_7F6E["充能时间"],
            ["主单位"] = _____65BD_6CD5_5355_4F4D,
            ["主单位死亡时中断"] = true,
            ["显示进度条特效"] = true,
            ["充能完成回调"] = function(_____5355_4F4D, ______5145_80FDID)
                _____7ED3_7B97_7834_8840_4E4B_6212(_____5355_4F4D)
            end,
            ["结束回调"] = function(_____5355_4F4D, ______539F_56E0, ______5145_80FDID)
                _____9500_6BC1Dz_7ED1_5B9A_5355_4F4D_7279_6548(_____5355_4F4D, _____7834_8840_4E4B_6212_7279_6548_952E)
                _____6E05_7406_7834_8840_4E4B_6212_4E0A_4E0B_6587(_____5355_4F4D)
            end
        }
    )
end
____exports["处理破血之戒使用"] = function(_____4E0A_4E0B_6587)
    debugLogForce("05．破血之戒", "进入", "处理破血之戒使用")
    if not _____662F_5426_4E3A_7834_8840_4E4B_6212(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    if _____4E0A_4E0B_6587["目标单位"] == nil or _____4E0A_4E0B_6587["目标单位"] == 0 then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    local _____5355_4F4DID = _____83B7_53D6_7834_8840_4E4B_6212_5355_4F4DID(_____65BD_6CD5_5355_4F4D)
    if _____5355_4F4DID <= 0 then
        return
    end
    _____7834_8840_4E4B_6212_4E0A_4E0B_6587_8868[_____5355_4F4DID] = {["施法单位"] = _____65BD_6CD5_5355_4F4D, ["目标X"] = _____4E0A_4E0B_6587["目标X"], ["目标Y"] = _____4E0A_4E0B_6587["目标Y"], ["目标单位"] = _____4E0A_4E0B_6587["目标单位"]}
    local _____5F53_524D_751F_547D = GetUnitState(_____65BD_6CD5_5355_4F4D, UNIT_STATE_LIFE)
    SetUnitState(_____65BD_6CD5_5355_4F4D, UNIT_STATE_LIFE, _____5F53_524D_751F_547D - 1000)
    _____5F00_59CB_7834_8840_4E4B_6212_5145_80FD(_____65BD_6CD5_5355_4F4D)
end
return ____exports
