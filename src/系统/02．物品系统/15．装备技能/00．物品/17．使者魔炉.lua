local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____4F7F_8005_9B54_7089_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["使者魔炉物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____4F7F_8005_9B54_7089_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["使者魔炉配置"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local getServerTime = ____require_result_1.getServerTime
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
local _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA = ____require_result_2["获取坐标范围敌人"]
local _____5355_4F4D_662F_5426_6709_6548_4E14_654C_5BF9 = ____require_result_2["单位是否有效且敌对"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.23．光环.01．范围光环")
local _____6CE8_518C_6301_6709_578B_8303_56F4_5149_73AF = ____require_result_3["注册持有型范围光环"]
local ____require_result_4 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_4.YDUserDataGet
local YDUserDataSet = ____require_result_4.YDUserDataSet
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_5.YDUserDataGetSafe
local ____require_result_6 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_6["调整玩家属性"]
local GetItemTypeId = jass.GetItemTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local EXSetEffectSize = japi.EXSetEffectSize
local _____547D_4E2D_7387_5B57_6BB5 = "命中率"
local _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4_952E = "单位组"
local _____7279_6548_9A71_52A8_95F4_9694_6BEB_79D2 = 20
local _____6062_590D_9A71_52A8_95F4_9694_6BEB_79D2 = 50
local _____5149_73AF_540C_6B65_95F4_9694_6BEB_79D2 = 100
local _____4F7F_8005_9B54_7089_7279_6548_4E0A_4E0B_6587_5217_8868 = {}
local _____4F7F_8005_9B54_7089_6062_590D_4E0A_4E0B_6587_5217_8868 = {}
local _____5DF2_6CE8_518C_4F7F_8005_9B54_7089_7279_6548_9A71_52A8 = false
local _____5DF2_6CE8_518C_4F7F_8005_9B54_7089_6062_590D_9A71_52A8 = false
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
local function _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4()
    return YDUserDataGetSafe("string", "玩家英雄", _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4_952E, "group")
end
local function _____5355_4F4D_5C5E_4E8E_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    local _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 = _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4()
    if _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 == nil or _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 == 0 then
        return false
    end
    return jass.IsUnitInGroup(_____5355_4F4D, _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4) == true
end
local function _____79FB_9664_7279_6548_653E_5927_4E0A_4E0B_6587(_____7279_6548)
    if _____7279_6548 == nil or _____7279_6548 == 0 then
        return
    end
    do
        local i = #_____4F7F_8005_9B54_7089_7279_6548_4E0A_4E0B_6587_5217_8868 - 1
        while i >= 0 do
            if _____4F7F_8005_9B54_7089_7279_6548_4E0A_4E0B_6587_5217_8868[i + 1]["特效"] == _____7279_6548 then
                __TS__ArraySplice(_____4F7F_8005_9B54_7089_7279_6548_4E0A_4E0B_6587_5217_8868, i, 1)
            end
            i = i - 1
        end
    end
end
local function ____on_4F7F_8005_9B54_7089_7279_6548_9A71_52A8()
    local _____5F53_524D_65F6_95F4 = getServerTime()
    do
        local i = #_____4F7F_8005_9B54_7089_7279_6548_4E0A_4E0B_6587_5217_8868 - 1
        while i >= 0 do
            do
                local _____4E0A_4E0B_6587 = _____4F7F_8005_9B54_7089_7279_6548_4E0A_4E0B_6587_5217_8868[i + 1]
                if _____4E0A_4E0B_6587["特效"] == nil or _____4E0A_4E0B_6587["特效"] == 0 then
                    __TS__ArraySplice(_____4F7F_8005_9B54_7089_7279_6548_4E0A_4E0B_6587_5217_8868, i, 1)
                    goto __continue17
                end
                if _____5F53_524D_65F6_95F4 < _____4E0A_4E0B_6587["下次触发时间"] then
                    goto __continue17
                end
                _____4E0A_4E0B_6587["次数"] = _____4E0A_4E0B_6587["次数"] + 1
                if _____4E0A_4E0B_6587["次数"] >= _____4F7F_8005_9B54_7089_914D_7F6E["特效放大次数"] then
                    __TS__ArraySplice(_____4F7F_8005_9B54_7089_7279_6548_4E0A_4E0B_6587_5217_8868, i, 1)
                    goto __continue17
                end
                EXSetEffectSize(_____4E0A_4E0B_6587["特效"], _____4F7F_8005_9B54_7089_914D_7F6E["特效放大基值"] + _____4E0A_4E0B_6587["次数"])
                _____4E0A_4E0B_6587["下次触发时间"] = _____5F53_524D_65F6_95F4 + _____4F7F_8005_9B54_7089_914D_7F6E["特效放大周期"] * 1000
            end
            ::__continue17::
            i = i - 1
        end
    end
end
local function ____on_4F7F_8005_9B54_7089_6062_590D_9A71_52A8()
    local _____5F53_524D_65F6_95F4 = getServerTime()
    do
        local i = #_____4F7F_8005_9B54_7089_6062_590D_4E0A_4E0B_6587_5217_8868 - 1
        while i >= 0 do
            do
                local _____4E0A_4E0B_6587 = _____4F7F_8005_9B54_7089_6062_590D_4E0A_4E0B_6587_5217_8868[i + 1]
                if _____5F53_524D_65F6_95F4 < _____4E0A_4E0B_6587["到期时间"] then
                    goto __continue23
                end
                do
                    local j = 0
                    while j < #_____4E0A_4E0B_6587["目标列表"] do
                        _____8C03_6574_547D_4E2D_7387(_____4E0A_4E0B_6587["目标列表"][j + 1], _____4F7F_8005_9B54_7089_914D_7F6E["命中率削减"])
                        j = j + 1
                    end
                end
                _____79FB_9664_7279_6548_653E_5927_4E0A_4E0B_6587(_____4E0A_4E0B_6587["特效"])
                if _____4E0A_4E0B_6587["特效"] ~= nil and _____4E0A_4E0B_6587["特效"] ~= 0 then
                    DestroyEffect(_____4E0A_4E0B_6587["特效"])
                end
                __TS__ArraySplice(_____4F7F_8005_9B54_7089_6062_590D_4E0A_4E0B_6587_5217_8868, i, 1)
            end
            ::__continue23::
            i = i - 1
        end
    end
end
local function _____786E_4FDD_4F7F_8005_9B54_7089_7279_6548_9A71_52A8_5DF2_6CE8_518C()
    if _____5DF2_6CE8_518C_4F7F_8005_9B54_7089_7279_6548_9A71_52A8 then
        return
    end
    _____5DF2_6CE8_518C_4F7F_8005_9B54_7089_7279_6548_9A71_52A8 = true
    addPeriodicCallback(_____7279_6548_9A71_52A8_95F4_9694_6BEB_79D2, ____on_4F7F_8005_9B54_7089_7279_6548_9A71_52A8)
end
local function _____786E_4FDD_4F7F_8005_9B54_7089_6062_590D_9A71_52A8_5DF2_6CE8_518C()
    if _____5DF2_6CE8_518C_4F7F_8005_9B54_7089_6062_590D_9A71_52A8 then
        return
    end
    _____5DF2_6CE8_518C_4F7F_8005_9B54_7089_6062_590D_9A71_52A8 = true
    addPeriodicCallback(_____6062_590D_9A71_52A8_95F4_9694_6BEB_79D2, ____on_4F7F_8005_9B54_7089_6062_590D_9A71_52A8)
end
local function _____542F_52A8_7279_6548_653E_5927(_____7279_6548)
    if _____7279_6548 == nil or _____7279_6548 == 0 then
        return
    end
    _____786E_4FDD_4F7F_8005_9B54_7089_7279_6548_9A71_52A8_5DF2_6CE8_518C()
    _____4F7F_8005_9B54_7089_7279_6548_4E0A_4E0B_6587_5217_8868[#_____4F7F_8005_9B54_7089_7279_6548_4E0A_4E0B_6587_5217_8868 + 1] = {
        ["特效"] = _____7279_6548,
        ["次数"] = 0,
        ["下次触发时间"] = getServerTime() + _____4F7F_8005_9B54_7089_914D_7F6E["特效放大周期"] * 1000
    }
end
local function _____542F_52A8_547D_4E2D_6062_590D(_____7279_6548, _____76EE_6807_5217_8868)
    _____786E_4FDD_4F7F_8005_9B54_7089_6062_590D_9A71_52A8_5DF2_6CE8_518C()
    _____4F7F_8005_9B54_7089_6062_590D_4E0A_4E0B_6587_5217_8868[#_____4F7F_8005_9B54_7089_6062_590D_4E0A_4E0B_6587_5217_8868 + 1] = {
        ["特效"] = _____7279_6548,
        ["目标列表"] = _____76EE_6807_5217_8868,
        ["到期时间"] = getServerTime() + _____4F7F_8005_9B54_7089_914D_7F6E["恢复延迟"] * 1000
    }
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
        ["额外筛选"] = _____5355_4F4D_5C5E_4E8E_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4,
        ["应用目标效果"] = _____5E94_7528_4F7F_8005_9B54_7089_5149_73AF,
        ["移除目标效果"] = _____79FB_9664_4F7F_8005_9B54_7089_5149_73AF
    })
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
                    goto __continue44
                end
                _____8C03_6574_547D_4E2D_7387(_____654C_4EBA, -_____4F7F_8005_9B54_7089_914D_7F6E["命中率削减"])
                _____547D_4E2D_76EE_6807_5217_8868[#_____547D_4E2D_76EE_6807_5217_8868 + 1] = _____654C_4EBA
            end
            ::__continue44::
            i = i + 1
        end
    end
    _____542F_52A8_547D_4E2D_6062_590D(_____7279_6548, _____547D_4E2D_76EE_6807_5217_8868)
end
_____521D_59CB_5316_4F7F_8005_9B54_7089_5149_73AF()
return ____exports
