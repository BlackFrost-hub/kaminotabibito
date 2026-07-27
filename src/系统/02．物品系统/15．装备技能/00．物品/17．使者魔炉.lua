--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7 = ____20_FF0E_7269_54C1_8F85_52A9["主动物品调试日志"]
local _____5EF6_8FDF_6267_884C = ____20_FF0E_7269_54C1_8F85_52A9["延迟执行"]
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____4F7F_8005_9B54_7089_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["使者魔炉物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____4F7F_8005_9B54_7089_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["使者魔炉配置"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____20_FF0E_7269_54C1_8F85_52A9["调整玩家属性"]
local _____8C03_6574_5355_4F4D_5C5E_6027 = ____20_FF0E_7269_54C1_8F85_52A9["调整单位属性"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
local _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA = ____require_result_0["获取坐标范围敌人"]
local _____5355_4F4D_662F_5426_6709_6548_4E14_654C_5BF9 = ____require_result_0["单位是否有效且敌对"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效")
local _____542F_52A8_7279_6548_6B65_8FDB_7F29_653E = ____require_result_1["启动特效步进缩放"]
local _____79FB_9664_7279_6548_6B65_8FDB_7F29_653E = ____require_result_1["移除特效步进缩放"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.23．光环.01．范围光环")
local _____6CE8_518C_6301_6709_578B_8303_56F4_5149_73AF = ____require_result_2["注册持有型范围光环"]
local ____require_result_3 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_3["是玩家英雄组单位"]
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_4.registerManualBuff
local GetItemTypeId = jass.GetItemTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local _____547D_4E2D_7387_5B57_6BB5 = "命中率"
local _____4F7F_8005_9B54_7089_81F4_76F2BuffID = "C042"
local _____5149_73AF_540C_6B65_95F4_9694_6BEB_79D2 = 100
local function _____662F_5426_4E3A_4F7F_8005_9B54_7089(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____4F7F_8005_9B54_7089_7269_54C1ID
end
local function _____8C03_6574_547D_4E2D_7387(_____5355_4F4D, _____53D8_5316_503C)
    _____8C03_6574_5355_4F4D_5C5E_6027(_____5355_4F4D, _____547D_4E2D_7387_5B57_6BB5, _____53D8_5316_503C)
end
local function _____542F_52A8_7279_6548_653E_5927(_____7279_6548)
    if _____7279_6548 == nil or _____7279_6548 == 0 then
        return
    end
    _____542F_52A8_7279_6548_6B65_8FDB_7F29_653E(_____7279_6548, _____4F7F_8005_9B54_7089_914D_7F6E["特效放大基值"], _____4F7F_8005_9B54_7089_914D_7F6E["特效放大次数"], _____4F7F_8005_9B54_7089_914D_7F6E["特效放大周期"])
end
local function _____542F_52A8_547D_4E2D_6062_590D(_____7279_6548, _____76EE_6807_5217_8868)
    _____5EF6_8FDF_6267_884C(
        _____4F7F_8005_9B54_7089_914D_7F6E["恢复延迟"] * 1000,
        function()
            do
                local j = 0
                while j < #_____76EE_6807_5217_8868 do
                    _____8C03_6574_547D_4E2D_7387(_____76EE_6807_5217_8868[j + 1], _____4F7F_8005_9B54_7089_914D_7F6E["命中率削减"])
                    j = j + 1
                end
            end
            _____79FB_9664_7279_6548_6B65_8FDB_7F29_653E(_____7279_6548)
            if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
                DestroyEffect(_____7279_6548)
            end
        end
    )
end
local function _____5E94_7528_4F7F_8005_9B54_7089_5149_73AF(_____76EE_6807_5355_4F4D, ______6301_6709_8005, currentCount)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____76EE_6807_5355_4F4D, "魔法伤害", _____4F7F_8005_9B54_7089_914D_7F6E["光环魔法伤害提升"] * currentCount)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____76EE_6807_5355_4F4D, "魔法恢复", _____4F7F_8005_9B54_7089_914D_7F6E["光环魔法恢复提升"] * currentCount)
end
local function _____79FB_9664_4F7F_8005_9B54_7089_5149_73AF(_____76EE_6807_5355_4F4D, ______6301_6709_8005, currentCount)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____76EE_6807_5355_4F4D, "魔法伤害", -_____4F7F_8005_9B54_7089_914D_7F6E["光环魔法伤害提升"] * currentCount)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____76EE_6807_5355_4F4D, "魔法恢复", -_____4F7F_8005_9B54_7089_914D_7F6E["光环魔法恢复提升"] * currentCount)
end
local function _____521D_59CB_5316_4F7F_8005_9B54_7089_5149_73AF()
    if _____4F7F_8005_9B54_7089_7269_54C1ID == 0 then
        return
    end
    _____6CE8_518C_6301_6709_578B_8303_56F4_5149_73AF({
        ["物品类型ID"] = _____4F7F_8005_9B54_7089_7269_54C1ID,
        ["间隔毫秒"] = _____5149_73AF_540C_6B65_95F4_9694_6BEB_79D2,
        ["半径"] = _____4F7F_8005_9B54_7089_914D_7F6E["光环半径"],
        ["目标类型"] = "友军含自己",
        ["去重类型"] = "玩家",
        ["额外筛选"] = _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D,
        ["应用目标效果"] = _____5E94_7528_4F7F_8005_9B54_7089_5149_73AF,
        ["移除目标效果"] = _____79FB_9664_4F7F_8005_9B54_7089_5149_73AF
    })
end
____exports["处理使者魔炉使用"] = function(_____4E0A_4E0B_6587)
    _____4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7("18．使者魔炉", "进入", "处理使者魔炉使用")
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
                    goto __continue21
                end
                _____8C03_6574_547D_4E2D_7387(_____654C_4EBA, -_____4F7F_8005_9B54_7089_914D_7F6E["命中率削减"])
                registerManualBuff(
                    _____654C_4EBA,
                    _____4F7F_8005_9B54_7089_81F4_76F2BuffID,
                    _____4F7F_8005_9B54_7089_914D_7F6E["恢复延迟"],
                    _____4F7F_8005_9B54_7089_914D_7F6E["命中率削减"] * 100,
                    {sourceUnit = _____65BD_6CD5_5355_4F4D, effectSourceName = "使者魔炉", effectSourceType = "装备", iconOverride = "ReplaceableTextures\\CommandButtons\\BTN000230.blp"}
                )
                _____547D_4E2D_76EE_6807_5217_8868[#_____547D_4E2D_76EE_6807_5217_8868 + 1] = _____654C_4EBA
            end
            ::__continue21::
            i = i + 1
        end
    end
    _____542F_52A8_547D_4E2D_6062_590D(_____7279_6548, _____547D_4E2D_76EE_6807_5217_8868)
end
_____521D_59CB_5316_4F7F_8005_9B54_7089_5149_73AF()
return ____exports
