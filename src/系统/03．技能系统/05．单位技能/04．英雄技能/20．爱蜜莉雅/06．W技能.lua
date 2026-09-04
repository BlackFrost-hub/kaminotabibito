local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____W_53D6_5B9E_65F6_533A_57DF_654C_4EBA, ____W_533A_57DF_5185_76EE_6807_7ED3_7B97, _____65BD_52A0W_5BD2_610F, _____4E8C_6BB5_5F15_7206W, jass, fourCCToStringSafe, GetOwningPlayer, GetPlayerId, DAMAGE_TYPE_COLD, _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3, _____53D1_5C04_5F39_9053, Sound3DII_CooPlayReuse, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____4E24_70B9_89D2_5EA6, _____5355_4F4D_5B58_6D3B, _____786E_8BA4_9650_65F6_4E8C_6BB5_6280_80FD_58F3, _____521B_5EFA_7231_871C_8389_96C5_573A_4E0A_51B0_6676, _____6D88_8D39_7231_871C_8389_96C5D_5F3A_5316, debugLogForce, ____W_6280_80FD_7C7B_578BID, _____65BD_52A0_7231_871C_8389_96C5_5BD2_610F
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.00．配置")
local _____7231_871C_8389_96C5_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅技能配置"]
local _____7231_871C_8389_96C5W_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅W配置"]
local _____7231_871C_8389_96C5_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅表现配置"]
local _____7231_871C_8389_96C5_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅音效配置"]
local ____27_FF0E_6218_6597_6280_80FD_5B9E_4F8B_751F_547D_5468_671F_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂")
local _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B = ____27_FF0E_6218_6597_6280_80FD_5B9E_4F8B_751F_547D_5468_671F_5DE5_5382["创建战斗技能实例"]
local _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B = ____27_FF0E_6218_6597_6280_80FD_5B9E_4F8B_751F_547D_5468_671F_5DE5_5382["查询战斗技能实例"]
local ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676 = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.02．公共状态与冰晶")
local _____64AD_653E_7231_871C_8389_96C5_52A8_4F5C = ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676["播放爱蜜莉雅动作"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.00．配置")
local _____7231_871C_8389_96C5_52A8_4F5C_69FD = ____00_FF0E_914D_7F6E["爱蜜莉雅动作槽"]
local ____04_FF0E_666E_653B_8054_52A8 = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.04．普攻联动")
local _____6807_8BB0_76EE_6807_5728_7231_871C_8389_96C5_533A_57DF = ____04_FF0E_666E_653B_8054_52A8["标记目标在爱蜜莉雅区域"]
local _____53D6_6D88_6807_8BB0_76EE_6807_5728_7231_871C_8389_96C5_533A_57DF = ____04_FF0E_666E_653B_8054_52A8["取消标记目标在爱蜜莉雅区域"]
function ____W_53D6_5B9E_65F6_533A_57DF_654C_4EBA(_____65BD_6CD5_8005, X, Y, _____534A_5F84)
    local _____7ED3_679C = {}
    local _____7EC4 = jass.CreateGroup()
    jass.GroupEnumUnitsInRange(
        _____7EC4,
        X,
        Y,
        _____534A_5F84,
        nil
    )
    while true do
        do
            local u = jass.FirstOfGroup(_____7EC4)
            if u == nil or u == 0 then
                break
            end
            jass.GroupRemoveUnit(_____7EC4, u)
            if u == _____65BD_6CD5_8005 or not _____5355_4F4D_5B58_6D3B(u) then
                goto __continue11
            end
            if not jass.IsUnitEnemy(
                u,
                jass.GetOwningPlayer(_____65BD_6CD5_8005)
            ) then
                goto __continue11
            end
            _____7ED3_679C[#_____7ED3_679C + 1] = u
        end
        ::__continue11::
    end
    jass.DestroyGroup(_____7EC4)
    return _____7ED3_679C
end
function ____W_533A_57DF_5185_76EE_6807_7ED3_7B97(_____65BD_6CD5_8005, _____533A_57DF_5185_5355_4F4D, _____6280_80FD_5B9E_4F8BID, _____4F24_5BB3_503C, _____65BD_52A0_5BD2_610F)
    if _____533A_57DF_5185_5355_4F4D == nil or #_____533A_57DF_5185_5355_4F4D <= 0 then
        return
    end
    local _____76EE_6807_5217_8868 = {}
    do
        local i = 0
        while i < #_____533A_57DF_5185_5355_4F4D do
            _____76EE_6807_5217_8868[#_____76EE_6807_5217_8868 + 1] = _____533A_57DF_5185_5355_4F4D[i + 1]
            i = i + 1
        end
    end
    debugLogForce(
        "爱蜜莉雅-W",
        "伤害",
        "标签",
        "爱蜜莉雅-W冰花",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____W_6280_80FD_7C7B_578BID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "目标数",
        #_____76EE_6807_5217_8868,
        "数值",
        _____4F24_5BB3_503C
    )
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = _____65BD_6CD5_8005,
        ["目标列表"] = _____76EE_6807_5217_8868,
        ["伤害"] = _____4F24_5BB3_503C,
        ["伤害类型"] = DAMAGE_TYPE_COLD,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____W_6280_80FD_7C7B_578BID,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["标签"] = "爱蜜莉雅-W冰花",
        ["参与技能伤害加成"] = true
    })
    if _____65BD_52A0_5BD2_610F then
        do
            local i = 0
            while i < #_____76EE_6807_5217_8868 do
                _____65BD_52A0W_5BD2_610F(_____65BD_6CD5_8005, _____76EE_6807_5217_8868[i + 1], _____6280_80FD_5B9E_4F8BID)
                i = i + 1
            end
        end
    end
end
function _____65BD_52A0W_5BD2_610F(_____65BD_6CD5_8005, _____76EE_6807, _____6280_80FD_5B9E_4F8BID)
    _____65BD_52A0_7231_871C_8389_96C5_5BD2_610F(
        _____65BD_6CD5_8005,
        _____76EE_6807,
        "W:" .. tostring(_____6280_80FD_5B9E_4F8BID or 0)
    )
end
function _____4E8C_6BB5_5F15_7206W(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____7784_51C6X, _____7784_51C6Y)
    local _____6570_636E = _____63A7_5236_5668["数据"]
    if _____6570_636E == nil or _____6570_636E["已二段"] then
        return
    end
    debugLogForce(
        "爱蜜莉雅-W",
        "状态",
        "二段引爆",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____W_6280_80FD_7C7B_578BID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "X",
        math.floor(_____6570_636E["目标X"]),
        "Y",
        math.floor(_____6570_636E["目标Y"]),
        "瞄准X",
        math.floor(_____7784_51C6X),
        "瞄准Y",
        math.floor(_____7784_51C6Y)
    )
    _____6570_636E["已二段"] = true
    local _____65B9_5411 = _____4E24_70B9_89D2_5EA6(_____6570_636E["目标X"], _____6570_636E["目标Y"], _____7784_51C6X, _____7784_51C6Y)
    local _____4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____7231_871C_8389_96C5W_914D_7F6E["二段伤害攻击力倍率"]
    local _____51B0_7247_4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____7231_871C_8389_96C5W_914D_7F6E["冰片伤害攻击力倍率"]
    local _____533A_57DF_5185_5355_4F4D = ____W_53D6_5B9E_65F6_533A_57DF_654C_4EBA(_____65BD_6CD5_8005, _____6570_636E["目标X"], _____6570_636E["目标Y"], _____7231_871C_8389_96C5W_914D_7F6E["半径"])
    ____W_533A_57DF_5185_76EE_6807_7ED3_7B97(
        _____65BD_6CD5_8005,
        _____533A_57DF_5185_5355_4F4D,
        _____6280_80FD_5B9E_4F8BID,
        _____4F24_5BB3,
        true
    )
    Sound3DII_CooPlayReuse(
        _____7231_871C_8389_96C5_97F3_6548_914D_7F6E["W引爆"]["路径"],
        _____6570_636E["目标X"],
        _____6570_636E["目标Y"],
        _____7231_871C_8389_96C5_97F3_6548_914D_7F6E["W引爆"]["高度"],
        _____7231_871C_8389_96C5_97F3_6548_914D_7F6E["W引爆"]["裁断距离"]
    )
    if _____6D88_8D39_7231_871C_8389_96C5D_5F3A_5316(_____65BD_6CD5_8005) then
        _____521B_5EFA_7231_871C_8389_96C5_573A_4E0A_51B0_6676(
            _____65BD_6CD5_8005,
            "D强化",
            _____6570_636E["目标X"],
            _____6570_636E["目标Y"],
            _____7231_871C_8389_96C5W_914D_7F6E["D强化冰晶持续秒"]
        )
    end
    if _____6570_636E["二段壳"] ~= nil then
        _____786E_8BA4_9650_65F6_4E8C_6BB5_6280_80FD_58F3(_____6570_636E["二段壳"])
    end
    local _____6570_91CF = _____7231_871C_8389_96C5W_914D_7F6E["冰片数量"]
    do
        local i = 0
        while i < _____6570_91CF do
            local _____504F_79FB = (i - (_____6570_91CF - 1) / 2) * 12
            _____53D1_5C04_5F39_9053({
                ["名称"] = "爱蜜莉雅-W冰片",
                ["所有者"] = _____65BD_6CD5_8005,
                ["发射X"] = _____6570_636E["目标X"],
                ["发射Y"] = _____6570_636E["目标Y"],
                ["发射方向角"] = _____65B9_5411 + _____504F_79FB,
                ["速度"] = _____7231_871C_8389_96C5W_914D_7F6E["冰片速度"],
                ["轨迹"] = {["类型"] = "直线", ["距离"] = 500},
                ["命中半径"] = 80,
                ["影响目标"] = "敌方",
                ["碰撞消失"] = true,
                ["每单位最大命中次数"] = 1,
                ["伤害值"] = _____51B0_7247_4F24_5BB3,
                ["伤害类型"] = DAMAGE_TYPE_COLD,
                ["来源类型"] = "单位技能",
                ["技能ID"] = ____W_6280_80FD_7C7B_578BID,
                ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                ["技能标签"] = "爱蜜莉雅-W冰片",
                ["伤害形态"] = "单体",
                ["参与技能伤害加成"] = true,
                ["模型"] = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["冰片"]["模型路径"],
                RGB = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["冰片"].RGB,
                ["缩放"] = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["冰片"]["缩放"]
            })
            i = i + 1
        end
    end
    if _____6570_636E["区域"] ~= nil then
        local ____self_17 = _____6570_636E["区域"]
        ____self_17["销毁"](____self_17)
        _____6570_636E["区域"] = nil
    end
    _____63A7_5236_5668["完成"](_____63A7_5236_5668)
end
local ____require_result_0 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_0["播放英雄技能喊话"]
jass = require("jass.common")
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
fourCCToStringSafe = ____require_result_1.fourCCToStringSafe
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitName = jass.GetUnitName
GetOwningPlayer = jass.GetOwningPlayer
GetPlayerId = jass.GetPlayerId
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域")
local _____521B_5EFA_6301_7EED_5371_9669_533A_57DF = ____require_result_2["创建持续危险区域"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_3["施加快速减速Buff"]
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_4["造成批量AOE技能伤害"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.05．弹道编排工厂")
_____53D1_5C04_5F39_9053 = ____require_result_5["发射弹道"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_6["创建点特效"]
local ____require_result_7 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
Sound3DII_CooPlayReuse = ____require_result_7.Sound3DII_CooPlayReuse
local ____require_result_8 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_8.addDelayedCallback
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_9["注册单位技能壳监听"]
local ____require_result_10 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_10["读取单位攻击力"]
_____4E24_70B9_89D2_5EA6 = ____require_result_10["两点角度"]
_____5355_4F4D_5B58_6D3B = ____require_result_10["单位存活"]
local ____require_result_11 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.25．限时二段技能壳")
local _____521B_5EFA_9650_65F6_4E8C_6BB5_6280_80FD_58F3 = ____require_result_11["创建限时二段技能壳"]
_____786E_8BA4_9650_65F6_4E8C_6BB5_6280_80FD_58F3 = ____require_result_11["确认限时二段技能壳"]
local _____6E05_7406_9650_65F6_4E8C_6BB5_6280_80FD_58F3 = ____require_result_11["清理限时二段技能壳"]
local _____901A_7528_4E8C_6BB5_6280_80FD_58F3ID = ____require_result_11["通用二段技能壳ID"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.03．被动效果")
_____521B_5EFA_7231_871C_8389_96C5_573A_4E0A_51B0_6676 = ____require_result_12["创建爱蜜莉雅场上冰晶"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.02．公共状态与冰晶")
_____6D88_8D39_7231_871C_8389_96C5D_5F3A_5316 = ____require_result_13["消费爱蜜莉雅D强化"]
local ____require_result_14 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_14.debugLogForce
local ____W_4E8C_6BB5_540C_6B65_524D_7F00 = "EMW2"
local GetLocalPlayer = jass.GetLocalPlayer
local R2S = jass.R2S
local CreateTrigger = jass.CreateTrigger
local TriggerAddAction = jass.TriggerAddAction
local japiAny = require("jass.japi")
local DzGetMouseTerrainX = japiAny.DzGetMouseTerrainX
local DzGetMouseTerrainY = japiAny.DzGetMouseTerrainY
local ____require_result_15 = require("lib.扩展函数.KK扩展API.02．事件注册函数")
local DzSyncData = ____require_result_15.DzSyncData
local DzTriggerRegisterSyncDataTrg = ____require_result_15.DzTriggerRegisterSyncDataTrg
local DzGetTriggerSyncPlayer = ____require_result_15.DzGetTriggerSyncPlayer
local DzGetTriggerSyncData = ____require_result_15.DzGetTriggerSyncData
local S2R = jass.S2R
--- 待引爆队列：施法时各端登记（对称），同步数据到达后按施法者主人匹配消费
local ____W_4E8C_6BB5_5F85_5F15_7206_5217_8868 = {}
local ____W_4E8C_6BB5_540C_6B65_5DF2_6CE8_518C = false
local function _____6CE8_518CW_4E8C_6BB5_9F20_6807_540C_6B65()
    if ____W_4E8C_6BB5_540C_6B65_5DF2_6CE8_518C then
        return
    end
    ____W_4E8C_6BB5_540C_6B65_5DF2_6CE8_518C = true
    local trig = CreateTrigger()
    TriggerAddAction(
        trig,
        function()
            local player = DzGetTriggerSyncPlayer()
            local syncData = DzGetTriggerSyncData()
            if player == nil or player == 0 then
                return
            end
            local parts = __TS__StringSplit(syncData, "|")
            if #parts < 2 then
                return
            end
            local _____9F20_6807X = S2R(parts[1] or "0")
            local _____9F20_6807Y = S2R(parts[2] or "0")
            do
                local i = 0
                while i < #____W_4E8C_6BB5_5F85_5F15_7206_5217_8868 do
                    local _____5F85 = ____W_4E8C_6BB5_5F85_5F15_7206_5217_8868[i + 1]
                    if _____5F85["施法者"] ~= nil and _____5F85["施法者"] ~= 0 and jass.GetOwningPlayer(_____5F85["施法者"]) == player then
                        __TS__ArraySplice(____W_4E8C_6BB5_5F85_5F15_7206_5217_8868, i, 1)
                        _____4E8C_6BB5_5F15_7206W(
                            _____5F85["施法者"],
                            _____5F85["控制器"],
                            _____5F85["技能实例ID"],
                            _____9F20_6807X,
                            _____9F20_6807Y
                        )
                        return
                    end
                    i = i + 1
                end
            end
            debugLogForce(
                "爱蜜莉雅-W",
                "二段同步",
                "警告",
                "无匹配的待引爆实例",
                "玩家",
                GetPlayerId(player) + 1,
                "X",
                _____9F20_6807X,
                "Y",
                _____9F20_6807Y
            )
        end
    )
    DzTriggerRegisterSyncDataTrg(trig, ____W_4E8C_6BB5_540C_6B65_524D_7F00, false)
end
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____7231_871C_8389_96C5_6280_80FD_914D_7F6E["单位类型ID"])
____W_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____7231_871C_8389_96C5_6280_80FD_914D_7F6E.W["技能ID"])
local ____require_result_16 = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.03．被动效果")
_____65BD_52A0_7231_871C_8389_96C5_5BD2_610F = ____require_result_16["施加爱蜜莉雅寒意"]
local function _____91CA_653EW_51B0_82B1(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 then
        debugLogForce(
            "爱蜜莉雅-W",
            "释放被拒",
            "原因",
            "施法者无效",
            "分支",
            "冰花"
        )
        return
    end
    debugLogForce(
        "爱蜜莉雅-W",
        "释放",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____W_6280_80FD_7C7B_578BID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "目标",
        "点施放",
        "目标X",
        math.floor(GetSpellTargetX()),
        "目标Y",
        math.floor(GetSpellTargetY())
    )
    _____64AD_653E_7231_871C_8389_96C5_52A8_4F5C(_____65BD_6CD5_8005, _____7231_871C_8389_96C5_52A8_4F5C_69FD.W)
    local _____6D3B_8DC3_5217_8868 = _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B(_____65BD_6CD5_8005, "W冰花")
    do
        local i = 0
        while i < #_____6D3B_8DC3_5217_8868 do
            local _____6D3B_8DC3 = _____6D3B_8DC3_5217_8868[i + 1]
            local _____6570_636E = _____6D3B_8DC3["数据"]
            if _____6570_636E ~= nil and not _____6570_636E["已二段"] then
                _____6CE8_518CW_4E8C_6BB5_9F20_6807_540C_6B65()
                ____W_4E8C_6BB5_5F85_5F15_7206_5217_8868[#____W_4E8C_6BB5_5F85_5F15_7206_5217_8868 + 1] = {["施法者"] = _____65BD_6CD5_8005, ["控制器"] = _____6D3B_8DC3, ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID}
                local _____672C_5730_73A9_5BB6 = GetLocalPlayer()
                if _____672C_5730_73A9_5BB6 ~= nil and _____672C_5730_73A9_5BB6 ~= 0 and GetOwningPlayer(_____65BD_6CD5_8005) == _____672C_5730_73A9_5BB6 then
                    DzSyncData(
                        ____W_4E8C_6BB5_540C_6B65_524D_7F00,
                        (R2S(DzGetMouseTerrainX()) .. "|") .. R2S(DzGetMouseTerrainY())
                    )
                end
                return
            end
            i = i + 1
        end
    end
    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "爱蜜莉雅", _____7231_871C_8389_96C5_6280_80FD_914D_7F6E.W["技能ID"])
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____6570_636E = {
        ["区域"] = nil,
        ["目标X"] = _____76EE_6807X,
        ["目标Y"] = _____76EE_6807Y,
        ["已二段"] = false,
        ["二段壳"] = nil,
        ["结束原因"] = nil
    }
    local _____63A7_5236_5668 = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B({
        ["技能键"] = "W冰花",
        ["施法者"] = _____65BD_6CD5_8005,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["数据"] = _____6570_636E,
        ["结束回调"] = function(_____539F_56E0, ______63A7_5236_5668)
            _____6570_636E["结束原因"] = _____539F_56E0
            if _____6570_636E["区域"] ~= nil then
                local ____self_18 = _____6570_636E["区域"]
                ____self_18["销毁"](____self_18)
                _____6570_636E["区域"] = nil
            end
        end
    })
    local _____533A_57DF
    _____533A_57DF = _____521B_5EFA_6301_7EED_5371_9669_533A_57DF({
        X = _____76EE_6807X,
        Y = _____76EE_6807Y,
        ["半径"] = _____7231_871C_8389_96C5W_914D_7F6E["半径"],
        ["持续时间"] = _____7231_871C_8389_96C5W_914D_7F6E["持续秒"],
        ["检测间隔"] = _____7231_871C_8389_96C5W_914D_7F6E["周期秒"],
        ["影响目标"] = "敌方",
        ["所有者"] = _____65BD_6CD5_8005,
        ["首次扫描触发进入"] = true,
        ["防抖间隔"] = 0,
        ["on进入"] = function(_____5355_4F4D)
            _____6807_8BB0_76EE_6807_5728_7231_871C_8389_96C5_533A_57DF(_____5355_4F4D)
            _____65BD_52A0_5FEB_901F_51CF_901FBuff(
                _____65BD_6CD5_8005,
                _____5355_4F4D,
                0,
                _____7231_871C_8389_96C5W_914D_7F6E["减速百分比"],
                _____7231_871C_8389_96C5W_914D_7F6E["周期秒"],
                "爱蜜莉雅-W",
                "技能"
            )
        end,
        ["on离开"] = function(_____5355_4F4D)
            _____53D6_6D88_6807_8BB0_76EE_6807_5728_7231_871C_8389_96C5_533A_57DF(_____5355_4F4D)
        end,
        ["on周期"] = function(_____533A_57DF_5185_5355_4F4D)
            if _____7231_871C_8389_96C5W_914D_7F6E["周期施加寒意"] then
                do
                    local i = 0
                    while i < #_____533A_57DF_5185_5355_4F4D do
                        _____65BD_52A0W_5BD2_610F(_____65BD_6CD5_8005, _____533A_57DF_5185_5355_4F4D[i + 1], _____6280_80FD_5B9E_4F8BID)
                        i = i + 1
                    end
                end
            end
        end,
        ["on销毁"] = function()
            if _____6570_636E["二段壳"] ~= nil then
                _____6E05_7406_9650_65F6_4E8C_6BB5_6280_80FD_58F3(_____6570_636E["二段壳"])
            end
            local ____self_19 = _____533A_57DF["区域效果"]
            local _____6B8B_7559_5355_4F4D = ____self_19["获取当前区域内单位"](____self_19)
            do
                local i = 0
                while i < #_____6B8B_7559_5355_4F4D do
                    _____53D6_6D88_6807_8BB0_76EE_6807_5728_7231_871C_8389_96C5_533A_57DF(_____6B8B_7559_5355_4F4D[i + 1])
                    i = i + 1
                end
            end
            _____6570_636E["区域"] = nil
            if not _____6570_636E["已二段"] and _____6570_636E["结束原因"] == nil then
                local _____533A_57DF_5185_5355_4F4D = ____W_53D6_5B9E_65F6_533A_57DF_654C_4EBA(_____65BD_6CD5_8005, _____6570_636E["目标X"], _____6570_636E["目标Y"], _____7231_871C_8389_96C5W_914D_7F6E["半径"])
                ____W_533A_57DF_5185_76EE_6807_7ED3_7B97(
                    _____65BD_6CD5_8005,
                    _____533A_57DF_5185_5355_4F4D,
                    _____6280_80FD_5B9E_4F8BID,
                    _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____7231_871C_8389_96C5W_914D_7F6E["自然结束伤害攻击力倍率"],
                    true
                )
                if _____6D88_8D39_7231_871C_8389_96C5D_5F3A_5316(_____65BD_6CD5_8005) then
                    _____521B_5EFA_7231_871C_8389_96C5_573A_4E0A_51B0_6676(
                        _____65BD_6CD5_8005,
                        "D强化",
                        _____6570_636E["目标X"],
                        _____6570_636E["目标Y"],
                        _____7231_871C_8389_96C5W_914D_7F6E["D强化冰晶持续秒"]
                    )
                end
                _____63A7_5236_5668["完成"]()
            else
                _____6570_636E["区域"] = nil
            end
        end
    })
    _____6570_636E["区域"] = _____533A_57DF
    Sound3DII_CooPlayReuse(
        _____7231_871C_8389_96C5_97F3_6548_914D_7F6E["W展开"]["路径"],
        _____76EE_6807X,
        _____76EE_6807Y,
        _____7231_871C_8389_96C5_97F3_6548_914D_7F6E["W展开"]["高度"],
        _____7231_871C_8389_96C5_97F3_6548_914D_7F6E["W展开"]["裁断距离"]
    )
    local _____521B_5EFA_4F24_5BB3_5EF6_8FDF = addDelayedCallback(
        250,
        function()
            if _____6570_636E["已二段"] then
                return
            end
            local _____533A_57DF_5F53_524D = ____W_53D6_5B9E_65F6_533A_57DF_654C_4EBA(_____65BD_6CD5_8005, _____6570_636E["目标X"], _____6570_636E["目标Y"], _____7231_871C_8389_96C5W_914D_7F6E["半径"])
            ____W_533A_57DF_5185_76EE_6807_7ED3_7B97(
                _____65BD_6CD5_8005,
                _____533A_57DF_5F53_524D,
                _____6280_80FD_5B9E_4F8BID,
                _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____7231_871C_8389_96C5W_914D_7F6E["创建伤害攻击力倍率"],
                true
            )
        end
    )
    _____63A7_5236_5668["登记延迟回调"](_____521B_5EFA_4F24_5BB3_5EF6_8FDF)
    _____6570_636E["二段壳"] = _____521B_5EFA_9650_65F6_4E8C_6BB5_6280_80FD_58F3({
        ["名称"] = "冰花绽放·引爆（W）",
        ["单位"] = _____65BD_6CD5_8005,
        ["一段技能ID"] = ____W_6280_80FD_7C7B_578BID,
        ["二段技能ID"] = stringToFourCCSafe(_____7231_871C_8389_96C5W_914D_7F6E["二段技能ID"]),
        ["持续秒"] = _____7231_871C_8389_96C5W_914D_7F6E["持续秒"],
        ["二段说明"] = ("|cffffcc00技能说明：|r从冰花中心向鼠标位置扇形发射冰片并立即引爆。|n" .. "|cffffcc00伤害：|r提前引爆造成攻击力|cff87ceeb120%|r的|cff66ccff冰魔法伤害|r；每枚冰片造成攻击力|cff87ceeb30%|r的|cff66ccff冰魔法伤害|r。|n") .. "|cffffcc00不做任何操作：|r冰花自然结束（伤害降为攻击力|cff87ceeb90%|r），按钮自动恢复。"
    })
    debugLogForce(
        "爱蜜莉雅-W",
        "特效",
        "类型",
        "创建",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____W_6280_80FD_7C7B_578BID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "路径",
        _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["冰花主体"]["模型路径"]
    )
    local _____51B0_82B1_7279_6548 = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["冰花主体"]["模型路径"],
        RGB = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["冰花主体"].RGB,
        X = _____76EE_6807X,
        Y = _____76EE_6807Y,
        Z = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["冰花主体"]["高度"],
        ["缩放"] = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["冰花主体"]["缩放"],
        ["持续秒"] = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["冰花主体"]["持续秒"]
    })
    if _____51B0_82B1_7279_6548 ~= nil and _____51B0_82B1_7279_6548 ~= 0 then
        _____63A7_5236_5668["登记自定义清理"](
            "W冰花主体",
            function()
                jass.DestroyEffect(_____51B0_82B1_7279_6548)
            end
        )
    end
    local _____5BD2_6C14_7279_6548 = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["寒气边界"]["模型路径"],
        RGB = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["寒气边界"].RGB,
        X = _____76EE_6807X,
        Y = _____76EE_6807Y,
        Z = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["寒气边界"]["高度"],
        ["缩放"] = _____7231_871C_8389_96C5W_914D_7F6E["半径"] / _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["寒气边界"]["基准半径"] * _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["寒气边界"]["基准缩放"],
        ["持续秒"] = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["寒气边界"]["持续秒"]
    })
    if _____5BD2_6C14_7279_6548 ~= nil and _____5BD2_6C14_7279_6548 ~= 0 then
        _____63A7_5236_5668["登记自定义清理"](
            "W寒气主体",
            function()
                jass.DestroyEffect(_____5BD2_6C14_7279_6548)
            end
        )
    end
end
local function _____91CA_653EW_4E8C_6BB5_8F93_5165(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 then
        debugLogForce(
            "爱蜜莉雅-W",
            "释放被拒",
            "原因",
            "施法者无效",
            "分支",
            "二段输入"
        )
        return
    end
    debugLogForce(
        "爱蜜莉雅-W",
        "释放",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____W_6280_80FD_7C7B_578BID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "目标",
        "点施放",
        "分支",
        "二段输入"
    )
    local _____6D3B_8DC3_5217_8868 = _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B(_____65BD_6CD5_8005, "W冰花")
    do
        local i = 0
        while i < #_____6D3B_8DC3_5217_8868 do
            local _____6D3B_8DC3 = _____6D3B_8DC3_5217_8868[i + 1]
            local _____6570_636E = _____6D3B_8DC3["数据"]
            if _____6570_636E ~= nil and not _____6570_636E["已二段"] then
                _____6CE8_518CW_4E8C_6BB5_9F20_6807_540C_6B65()
                ____W_4E8C_6BB5_5F85_5F15_7206_5217_8868[#____W_4E8C_6BB5_5F85_5F15_7206_5217_8868 + 1] = {["施法者"] = _____65BD_6CD5_8005, ["控制器"] = _____6D3B_8DC3, ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID}
                local _____672C_5730_73A9_5BB6 = GetLocalPlayer()
                if _____672C_5730_73A9_5BB6 ~= nil and _____672C_5730_73A9_5BB6 ~= 0 and jass.GetOwningPlayer(_____65BD_6CD5_8005) == _____672C_5730_73A9_5BB6 then
                    DzSyncData(
                        ____W_4E8C_6BB5_540C_6B65_524D_7F00,
                        (R2S(japiAny:DzGetMouseTerrainX()) .. "|") .. R2S(japiAny:DzGetMouseTerrainY())
                    )
                end
                return
            end
            i = i + 1
        end
    end
end
____exports["注册爱蜜莉雅W"] = function()
    debugLogForce("爱蜜莉雅-W", "注册", "名称", "注册爱蜜莉雅W")
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "爱蜜莉雅-冰花绽放（W）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____7231_871C_8389_96C5_6280_80FD_914D_7F6E.W["技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EW_51B0_82B1,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____7231_871C_8389_96C5W_914D_7F6E["持续秒"] + 1
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "爱蜜莉雅-W二段输入（ASW2）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____7231_871C_8389_96C5W_914D_7F6E["二段技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EW_4E8C_6BB5_8F93_5165,
        ["创建独立技能实例"] = false
    })
end
return ____exports
