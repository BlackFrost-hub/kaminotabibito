--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____4F7F_8005_9B54_7089_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["使者魔炉物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____4F7F_8005_9B54_7089_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["使者魔炉配置"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local addDelayedCallback = ____require_result_1.addDelayedCallback
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
local _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA = ____require_result_2["获取坐标范围敌人"]
local _____5355_4F4D_662F_5426_6709_6548_4E14_654C_5BF9 = ____require_result_2["单位是否有效且敌对"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_3.YDUserDataGet
local YDUserDataSet = ____require_result_3.YDUserDataSet
local GetItemTypeId = jass.GetItemTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local EXSetEffectSize = japi.EXSetEffectSize
local _____547D_4E2D_7387_5B57_6BB5 = "命中率"
local function _____662F_5426_4E3A_4F7F_8005_9B54_7089(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____4F7F_8005_9B54_7089_7269_54C1ID
end
local function _____8C03_6574_547D_4E2D_7387(_____5355_4F4D, _____53D8_5316_503C)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local _____5DF2_5B58_503C = YDUserDataGet("unit", _____5355_4F4D, _____547D_4E2D_7387_5B57_6BB5, "real")
    local _____5F53_524D_503C = _____5DF2_5B58_503C == nil and 0 or _____5DF2_5B58_503C
    YDUserDataSet(
        "unit",
        _____5355_4F4D,
        _____547D_4E2D_7387_5B57_6BB5,
        "real",
        _____5F53_524D_503C + _____53D8_5316_503C
    )
end
local function ____on_4F7F_8005_9B54_7089_7279_6548_653E_5927(_____4E0A_4E0B_6587)
    _____4E0A_4E0B_6587["次数"] = _____4E0A_4E0B_6587["次数"] + 1
    if _____4E0A_4E0B_6587["次数"] >= _____4F7F_8005_9B54_7089_914D_7F6E["特效放大次数"] then
        removePeriodicCallback(_____4E0A_4E0B_6587.timerID)
        return
    end
    EXSetEffectSize(_____4E0A_4E0B_6587["特效"], _____4F7F_8005_9B54_7089_914D_7F6E["特效放大基值"] + _____4E0A_4E0B_6587["次数"])
end
local function _____542F_52A8_7279_6548_653E_5927(_____7279_6548)
    local _____4E0A_4E0B_6587 = {["特效"] = _____7279_6548, ["次数"] = 0, timerID = 0}
    _____4E0A_4E0B_6587.timerID = addPeriodicCallback(
        _____4F7F_8005_9B54_7089_914D_7F6E["特效放大周期"] * 1000,
        function() return ____on_4F7F_8005_9B54_7089_7279_6548_653E_5927(_____4E0A_4E0B_6587) end
    )
end
local function _____542F_52A8_547D_4E2D_6062_590D(_____7279_6548, _____76EE_6807_5217_8868)
    addDelayedCallback(
        _____4F7F_8005_9B54_7089_914D_7F6E["恢复延迟"] * 1000,
        function()
            do
                local i = 0
                while i < #_____76EE_6807_5217_8868 do
                    _____8C03_6574_547D_4E2D_7387(_____76EE_6807_5217_8868[i + 1], _____4F7F_8005_9B54_7089_914D_7F6E["命中率削减"])
                    i = i + 1
                end
            end
            if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
                DestroyEffect(_____7279_6548)
            end
        end
    )
end
____exports["处理使者魔炉使用"] = function(_____4E0A_4E0B_6587)
    debugLogForce("18．使者魔炉", "进入", "处理使者魔炉使用")
    if not _____662F_5426_4E3A_4F7F_8005_9B54_7089(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    local _____76EE_6807_5355_4F4D = _____4E0A_4E0B_6587["目标单位"]
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 or _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    local _____7279_6548 = AddSpecialEffectTarget(_____4F7F_8005_9B54_7089_914D_7F6E["特效路径"], _____76EE_6807_5355_4F4D, _____4F7F_8005_9B54_7089_914D_7F6E["特效挂点"])
    if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
        _____542F_52A8_7279_6548_653E_5927(_____7279_6548)
    end
    local _____547D_4E2D_76EE_6807_5217_8868 = {}
    local _____654C_4EBA_5217_8868 = _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA(
        _____65BD_6CD5_5355_4F4D,
        GetUnitX(_____76EE_6807_5355_4F4D),
        GetUnitY(_____76EE_6807_5355_4F4D),
        _____4F7F_8005_9B54_7089_914D_7F6E["作用范围"]
    )
    do
        local i = 0
        while i < #_____654C_4EBA_5217_8868 do
            do
                local _____654C_4EBA = _____654C_4EBA_5217_8868[i + 1]
                if not _____5355_4F4D_662F_5426_6709_6548_4E14_654C_5BF9(_____654C_4EBA, _____65BD_6CD5_5355_4F4D) then
                    goto __continue20
                end
                _____8C03_6574_547D_4E2D_7387(_____654C_4EBA, -_____4F7F_8005_9B54_7089_914D_7F6E["命中率削减"])
                _____547D_4E2D_76EE_6807_5217_8868[#_____547D_4E2D_76EE_6807_5217_8868 + 1] = _____654C_4EBA
            end
            ::__continue20::
            i = i + 1
        end
    end
    _____542F_52A8_547D_4E2D_6062_590D(_____7279_6548, _____547D_4E2D_76EE_6807_5217_8868)
end
return ____exports
