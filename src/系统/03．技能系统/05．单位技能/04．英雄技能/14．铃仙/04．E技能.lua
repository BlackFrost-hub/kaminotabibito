local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____6E05_7406E_4E0A_4E0B_6587, _____63A8_8FDBE_4E0B_964D, _____5F00_59CB_8DF3_8DC3_4E0B_964D, addPeriodicCallback, removePeriodicCallback, _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0, _____5355_4F4D_5B58_6D3B, SU_SetUnitFlyHeight, cfg, GetHandleId, GetUnitFlyHeight, GetUnitDefaultFlyHeight, ____E_4E0A_4E0B_6587_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00．配置")
local _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["铃仙单位技能配置"]
local ____12_FF0E_94C3_4ED9 = require("系统.05．Buff系统.03．Buff表.02．英雄.12．铃仙")
local _____94C3_4ED9BuffID = ____12_FF0E_94C3_4ED9["铃仙BuffID"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00A．表现工具")
local _____64AD_653E_94C3_4ED9_5355_4F4D_7ED1_5B9A_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放铃仙单位绑定音效"]
local _____64AD_653E_94C3_4ED9_914D_7F6E_52A8_4F5C = ____00A_FF0E_8868_73B0_5DE5_5177["播放铃仙配置动作"]
local ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00B．分身与状态管理")
local _____662F_94C3_4ED9_672C_4F53 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是铃仙本体"]
local _____662F_6709_6548_654C_5BF9_76EE_6807 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是有效敌对目标"]
function _____6E05_7406E_4E0A_4E0B_6587(ctx)
    if ctx["已结束"] then
        return
    end
    ctx["已结束"] = true
    if ctx["上升回调ID"] ~= 0 then
        removePeriodicCallback(ctx["上升回调ID"])
        ctx["上升回调ID"] = 0
    end
    if ctx["下降回调ID"] ~= 0 then
        removePeriodicCallback(ctx["下降回调ID"])
        ctx["下降回调ID"] = 0
    end
    if ctx["发射回调ID"] ~= 0 then
        removePeriodicCallback(ctx["发射回调ID"])
        ctx["发射回调ID"] = 0
    end
    if ctx["推进回调ID"] ~= 0 then
        removePeriodicCallback(ctx["推进回调ID"])
        ctx["推进回调ID"] = 0
    end
    do
        local i = 0
        while i < #ctx["子弹列表"] do
            local b = ctx["子弹列表"][i + 1]
            if b ~= nil and b["单位"] ~= nil and b["单位"] ~= 0 then
                _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(b["单位"])
            end
            i = i + 1
        end
    end
    ctx["子弹列表"] = {}
    do
        local i = 0
        while i < #ctx["爆炸列表"] do
            local b = ctx["爆炸列表"][i + 1]
            if b ~= nil and b["单位"] ~= nil and b["单位"] ~= 0 then
                _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(b["单位"])
            end
            i = i + 1
        end
    end
    ctx["爆炸列表"] = {}
    local _____65BD_6CD5_8005 = ctx["施法者"]
    if _____65BD_6CD5_8005 ~= nil and _____65BD_6CD5_8005 ~= 0 and _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        SU_SetUnitFlyHeight(
            _____65BD_6CD5_8005,
            GetUnitDefaultFlyHeight(_____65BD_6CD5_8005),
            0
        )
    end
    if _____65BD_6CD5_8005 ~= nil and _____65BD_6CD5_8005 ~= 0 and ____E_4E0A_4E0B_6587_8868[GetHandleId(_____65BD_6CD5_8005)] == ctx then
        __TS__Delete(
            ____E_4E0A_4E0B_6587_8868,
            GetHandleId(_____65BD_6CD5_8005)
        )
    end
end
function _____63A8_8FDBE_4E0B_964D(variable)
    local ctx = variable
    if ctx["已结束"] then
        return
    end
    local _____65BD_6CD5_8005 = ctx["施法者"]
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        _____6E05_7406E_4E0A_4E0B_6587(ctx)
        return
    end
    local _____5F53_524D_9AD8_5EA6 = GetUnitFlyHeight(_____65BD_6CD5_8005)
    local _____9ED8_8BA4_9AD8_5EA6 = GetUnitDefaultFlyHeight(_____65BD_6CD5_8005)
    if _____5F53_524D_9AD8_5EA6 <= _____9ED8_8BA4_9AD8_5EA6 then
        removePeriodicCallback(ctx["下降回调ID"])
        ctx["下降回调ID"] = 0
        SU_SetUnitFlyHeight(_____65BD_6CD5_8005, _____9ED8_8BA4_9AD8_5EA6, 0)
        return
    end
    SU_SetUnitFlyHeight(_____65BD_6CD5_8005, _____5F53_524D_9AD8_5EA6 - cfg.E["飞行高度变化"], 0)
end
function _____5F00_59CB_8DF3_8DC3_4E0B_964D(ctx)
    if ctx["下降回调ID"] ~= 0 then
        return
    end
    ctx["下降回调ID"] = addPeriodicCallback(20, _____63A8_8FDBE_4E0B_964D, ctx)
end
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local registerSpellEndcastListener = ____require_result_1.registerSpellEndcastListener
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
addPeriodicCallback = ____require_result_2.addPeriodicCallback
removePeriodicCallback = ____require_result_2.removePeriodicCallback
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_3["造成技能伤害"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____6781_5750_6807X = ____require_result_5["极坐标X"]
local _____6781_5750_6807Y = ____require_result_5["极坐标Y"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.24．整数与时间换算")
local _____79D2_8F6C_6BEB_79D2 = ____require_result_6["秒转毫秒"]
local ____require_result_7 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_7["创建单位并登记排泄安全"]
local ____require_result_8 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
_____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_8["立即移除单位并取消排泄登记"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_9["施加眩晕"]
local ____require_result_10 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_10.registerManualBuff
local ____require_result_11 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_11.getUnitsInRange
local ____require_result_12 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_654F_6377 = ____require_result_12["读取单位敏捷"]
_____5355_4F4D_5B58_6D3B = ____require_result_12["单位存活"]
local ____require_result_13 = require("lib.扩展函数.Star扩展函数.Star扩展库.09．单位基础与生命周期函数")
SU_SetUnitFlyHeight = ____require_result_13.SU_SetUnitFlyHeight
local ____require_result_14 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
local ____SFB__65BD_52A0_901A_7528Buff = ____require_result_14["SFB_施加通用Buff"]
local ____require_result_15 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_15.registerDamageModifier
local unregisterDamageModifier = ____require_result_15.unregisterDamageModifier
cfg = _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E
local ____E_6280_80FDID_6570_503C = stringToFourCCSafe(cfg["E技能ID"])
local _____5F39_5E55_9A6C_7532ID = stringToFourCCSafe("e07O")
local _____8757_866B_6280_80FDID = stringToFourCCSafe("Aloc")
local _____9650_65F6_751F_547DBuffID = stringToFourCCSafe("BHwe")
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
GetUnitFlyHeight = jass.GetUnitFlyHeight
GetUnitDefaultFlyHeight = jass.GetUnitDefaultFlyHeight
local GetOwningPlayer = jass.GetOwningPlayer
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitPosition = jass.SetUnitPosition
local UnitAddAbility = jass.UnitAddAbility
local UnitApplyTimedLife = jass.UnitApplyTimedLife
____E_4E0A_4E0B_6587_8868 = {}
local function _____521B_5EFAE_4E0A_4E0B_6587(_____65BD_6CD5_8005)
    return {
        ["施法者"] = _____65BD_6CD5_8005,
        ["上升回调ID"] = 0,
        ["下降回调ID"] = 0,
        ["发射回调ID"] = 0,
        ["推进回调ID"] = 0,
        ["波次"] = 0,
        over = false,
        ["子弹列表"] = {},
        ["爆炸列表"] = {},
        ["已爆炸"] = false,
        ["已结束"] = false
    }
end
local function _____63A8_8FDBE_4E0A_5347(variable)
    local ctx = variable
    if ctx["已结束"] then
        return
    end
    local _____65BD_6CD5_8005 = ctx["施法者"]
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        _____6E05_7406E_4E0A_4E0B_6587(ctx)
        return
    end
    local _____5F53_524D_9AD8_5EA6 = GetUnitFlyHeight(_____65BD_6CD5_8005)
    if _____5F53_524D_9AD8_5EA6 >= cfg.E["最大飞行高度"] then
        removePeriodicCallback(ctx["上升回调ID"])
        ctx["上升回调ID"] = 0
        _____5F00_59CB_8DF3_8DC3_4E0B_964D(ctx)
        return
    end
    SU_SetUnitFlyHeight(_____65BD_6CD5_8005, _____5F53_524D_9AD8_5EA6 + cfg.E["飞行高度变化"], 0)
end
local function _____5F00_59CB_8DF3_8DC3_4E0A_5347(ctx)
    if ctx["上升回调ID"] ~= 0 then
        return
    end
    ctx["上升回调ID"] = addPeriodicCallback(20, _____63A8_8FDBE_4E0A_5347, ctx)
end
local function _____53D1_5C04_4E00_6CE2_5F39_5E55(ctx)
    local _____65BD_6CD5_8005 = ctx["施法者"]
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        _____6E05_7406E_4E0A_4E0B_6587(ctx)
        return
    end
    ctx["波次"] = ctx["波次"] + 1
    local _____6CE2_6B21 = ctx["波次"]
    local _____4E2D_5FC3X = GetUnitX(_____65BD_6CD5_8005)
    local _____4E2D_5FC3Y = GetUnitY(_____65BD_6CD5_8005)
    local _____9762_671D = GetUnitFacing(_____65BD_6CD5_8005)
    local _____73A9_5BB6 = GetOwningPlayer(_____65BD_6CD5_8005)
    local _____6700_8FDC_8DDD_79BB = cfg.E["弹幕单位距离"] * _____6CE2_6B21
    do
        local i = 1
        while i <= cfg.E["每波弹幕数"] do
            do
                local _____89D2_5EA6 = _____9762_671D + cfg.E["弹幕角度间隔"] * i
                local _____5F39_5E55_5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
                    _____73A9_5BB6,
                    _____5F39_5E55_9A6C_7532ID,
                    _____4E2D_5FC3X,
                    _____4E2D_5FC3Y,
                    _____89D2_5EA6
                )
                if _____5F39_5E55_5355_4F4D == nil or _____5F39_5E55_5355_4F4D == 0 then
                    goto __continue32
                end
                UnitAddAbility(_____5F39_5E55_5355_4F4D, _____8757_866B_6280_80FDID)
                UnitApplyTimedLife(_____5F39_5E55_5355_4F4D, _____9650_65F6_751F_547DBuffID, 5)
                local _____8BB0_5F55 = {
                    ["单位"] = _____5F39_5E55_5355_4F4D,
                    ["角度"] = _____89D2_5EA6,
                    ["已飞行距离"] = 0,
                    ["最远距离"] = _____6700_8FDC_8DDD_79BB,
                    X = _____4E2D_5FC3X,
                    Y = _____4E2D_5FC3Y
                }
                local ____ctx__5B50_5F39_5217_8868_16 = ctx["子弹列表"]
                ____ctx__5B50_5F39_5217_8868_16[#____ctx__5B50_5F39_5217_8868_16 + 1] = _____8BB0_5F55
            end
            ::__continue32::
            i = i + 1
        end
    end
end
local function _____63A8_8FDB_6240_6709_5F39_5E55(ctx)
    if ctx["已结束"] then
        return
    end
    local _____65BD_6CD5_8005 = ctx["施法者"]
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        _____6E05_7406E_4E0A_4E0B_6587(ctx)
        return
    end
    local _____6BCFtick_8DDD_79BB = cfg.E["弹幕每tick距离"]
    do
        local i = #ctx["子弹列表"] - 1
        while i >= 0 do
            do
                local _____5B50_5F39 = ctx["子弹列表"][i + 1]
                if _____5B50_5F39 == nil then
                    __TS__ArraySplice(ctx["子弹列表"], i, 1)
                    goto __continue38
                end
                local _____5F39_5E55_5355_4F4D = _____5B50_5F39["单位"]
                if _____5F39_5E55_5355_4F4D == nil or _____5F39_5E55_5355_4F4D == 0 then
                    __TS__ArraySplice(ctx["子弹列表"], i, 1)
                    goto __continue38
                end
                _____5B50_5F39["已飞行距离"] = _____5B50_5F39["已飞行距离"] + _____6BCFtick_8DDD_79BB
                _____5B50_5F39.X = _____6781_5750_6807X(_____5B50_5F39.X, _____5B50_5F39["角度"], _____6BCFtick_8DDD_79BB)
                _____5B50_5F39.Y = _____6781_5750_6807Y(_____5B50_5F39.Y, _____5B50_5F39["角度"], _____6BCFtick_8DDD_79BB)
                SetUnitPosition(_____5F39_5E55_5355_4F4D, _____5B50_5F39.X, _____5B50_5F39.Y)
                if _____5B50_5F39["已飞行距离"] >= _____5B50_5F39["最远距离"] then
                    __TS__ArraySplice(ctx["子弹列表"], i, 1)
                    local ____ctx__7206_70B8_5217_8868_17 = ctx["爆炸列表"]
                    ____ctx__7206_70B8_5217_8868_17[#____ctx__7206_70B8_5217_8868_17 + 1] = _____5B50_5F39
                end
            end
            ::__continue38::
            i = i - 1
        end
    end
end
local function _____79FB_9664E_65E0_654C_4FEE_6B63(variable)
    local _____4FEE_6B63ID = variable
    if _____4FEE_6B63ID ~= 0 then
        unregisterDamageModifier(_____4FEE_6B63ID)
    end
end
local function _____6267_884C_7206_70B8(ctx)
    if ctx["已爆炸"] then
        return
    end
    ctx["已爆炸"] = true
    local _____65BD_6CD5_8005 = ctx["施法者"]
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        _____6E05_7406E_4E0A_4E0B_6587(ctx)
        return
    end
    do
        local i = 0
        while i < #ctx["子弹列表"] do
            local ____ctx__7206_70B8_5217_8868_18 = ctx["爆炸列表"]
            ____ctx__7206_70B8_5217_8868_18[#____ctx__7206_70B8_5217_8868_18 + 1] = ctx["子弹列表"][i + 1]
            i = i + 1
        end
    end
    ctx["子弹列表"] = {}
    local _____654F_6377 = _____8BFB_53D6_5355_4F4D_654F_6377(_____65BD_6CD5_8005)
    local _____4F24_5BB3_503C = _____654F_6377 * cfg.E["敏捷倍率"]
    local ____E_914D_7F6E = cfg.E
    do
        local i = 0
        while i < #ctx["爆炸列表"] do
            do
                local _____5B50_5F39 = ctx["爆炸列表"][i + 1]
                if _____5B50_5F39 == nil then
                    goto __continue50
                end
                local _____5F39_5E55_5355_4F4D = _____5B50_5F39["单位"]
                local _____7206X = _____5B50_5F39.X
                local _____7206Y = _____5B50_5F39.Y
                _____521B_5EFA_70B9_7279_6548({
                    ["模型路径"] = ____E_914D_7F6E["爆炸模型"],
                    X = _____7206X,
                    Y = _____7206Y,
                    Z = ____E_914D_7F6E["爆炸高度"],
                    ["缩放"] = ____E_914D_7F6E["爆炸缩放"],
                    ["持续秒"] = ____E_914D_7F6E["爆炸寿命秒"]
                })
                local _____5355_4F4D_5217_8868 = getUnitsInRange(_____7206X, _____7206Y, ____E_914D_7F6E["爆炸半径"])
                do
                    local j = 0
                    while j < #_____5355_4F4D_5217_8868 do
                        do
                            local _____76EE_6807 = _____5355_4F4D_5217_8868[j + 1]
                            if not _____662F_6709_6548_654C_5BF9_76EE_6807(_____65BD_6CD5_8005, _____76EE_6807) then
                                goto __continue53
                            end
                            if not (_____4F24_5BB3_503C > 0) then
                                goto __continue53
                            end
                            _____9020_6210_6280_80FD_4F24_5BB3({
                                ["来源"] = _____65BD_6CD5_8005,
                                ["目标"] = _____76EE_6807,
                                ["伤害"] = _____4F24_5BB3_503C,
                                ["伤害类型"] = DAMAGE_TYPE_LIGHTNING,
                                attack = true,
                                attackType = ATTACK_TYPE_NORMAL,
                                weaponType = WEAPON_TYPE_WHOKNOWS,
                                ["来源类型"] = "单位技能",
                                ["技能ID"] = ____E_6280_80FDID_6570_503C,
                                ["标签"] = "铃仙-E-幻爆近眼花火",
                                ["伤害形态"] = "AOE",
                                ["参与技能伤害加成"] = true
                            })
                            _____65BD_52A0_7729_6655(
                                _____65BD_6CD5_8005,
                                _____76EE_6807,
                                ____E_914D_7F6E["眩晕秒"],
                                _____94C3_4ED9BuffID["E爆炸眩晕"],
                                "技能"
                            )
                        end
                        ::__continue53::
                        j = j + 1
                    end
                end
                if _____5F39_5E55_5355_4F4D ~= nil and _____5F39_5E55_5355_4F4D ~= 0 then
                    _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____5F39_5E55_5355_4F4D)
                end
            end
            ::__continue50::
            i = i + 1
        end
    end
    ctx["爆炸列表"] = {}
    _____6E05_7406E_4E0A_4E0B_6587(ctx)
end
local function _____63A8_8FDBE_53D1_5C04(variable)
    local ctx = variable
    if ctx["已结束"] then
        return
    end
    if ctx["波次"] >= cfg.E["波数"] then
        removePeriodicCallback(ctx["发射回调ID"])
        ctx["发射回调ID"] = 0
        ctx.over = true
        addDelayedCallback(
            _____79D2_8F6C_6BEB_79D2(cfg.E["爆炸延迟秒"]),
            _____6267_884C_7206_70B8,
            ctx
        )
        return
    end
    _____53D1_5C04_4E00_6CE2_5F39_5E55(ctx)
end
local function ____on_94C3_4ED9E_751F_6548(_____65BD_6CD5_5355_4F4D, _____6280_80FDID_6570_503C)
    if _____6280_80FDID_6570_503C ~= ____E_6280_80FDID_6570_503C then
        return
    end
    if not _____662F_94C3_4ED9_672C_4F53(_____65BD_6CD5_5355_4F4D) then
        return
    end
    local _____82F1_96C4 = _____65BD_6CD5_5355_4F4D
    local _____65E7ctx = ____E_4E0A_4E0B_6587_8868[GetHandleId(_____82F1_96C4)]
    if _____65E7ctx ~= nil and not _____65E7ctx["已结束"] then
        _____6E05_7406E_4E0A_4E0B_6587(_____65E7ctx)
    end
    local ctx = _____521B_5EFAE_4E0A_4E0B_6587(_____82F1_96C4)
    ____E_4E0A_4E0B_6587_8868[GetHandleId(_____82F1_96C4)] = ctx
    _____64AD_653E_94C3_4ED9_5355_4F4D_7ED1_5B9A_97F3_6548(_____82F1_96C4, "gg_snd_LX_E", 100)
    SetUnitAnimation(_____82F1_96C4, "spell five")
    _____64AD_653E_94C3_4ED9_914D_7F6E_52A8_4F5C(_____82F1_96C4, -1, 1)
    ____SFB__65BD_52A0_901A_7528Buff(_____82F1_96C4, _____82F1_96C4, 21, cfg.E["施法硬直秒"])
    local _____65E0_654C_4FEE_6B63ID = registerDamageModifier(
        function(_____4F24_5BB3_4E0A_4E0B_6587)
            if _____4F24_5BB3_4E0A_4E0B_6587 ~= nil and _____4F24_5BB3_4E0A_4E0B_6587.target == _____82F1_96C4 then
                return 0
            end
            local ____temp_19
            if _____4F24_5BB3_4E0A_4E0B_6587 ~= nil and type(_____4F24_5BB3_4E0A_4E0B_6587.currentDamage) == "number" then
                ____temp_19 = _____4F24_5BB3_4E0A_4E0B_6587.currentDamage
            else
                ____temp_19 = 0
            end
            return ____temp_19
        end,
        2000
    )
    addDelayedCallback(
        _____79D2_8F6C_6BEB_79D2(cfg.E["无敌秒"]),
        _____79FB_9664E_65E0_654C_4FEE_6B63,
        _____65E0_654C_4FEE_6B63ID
    )
    _____5F00_59CB_8DF3_8DC3_4E0A_5347(ctx)
    ctx["发射回调ID"] = addPeriodicCallback(50, _____63A8_8FDBE_53D1_5C04, ctx)
    ctx["推进回调ID"] = addPeriodicCallback(
        _____79D2_8F6C_6BEB_79D2(cfg.E["弹幕tick秒"]),
        _____63A8_8FDB_6240_6709_5F39_5E55,
        ctx
    )
end
registerSpellEffectListener(____on_94C3_4ED9E_751F_6548)
--- 施法中断清理（SPELL_ENDCAST 触发，正常爆炸后已结束=true 幂等跳过）。
-- 复用 `清理E上下文`：移除上升/下降/发射/推进全部回调、清理弹幕马甲、恢复飞行高度、
-- 从 E上下文表 摘除（带 === ctx 校验）。旧实例中断后不能创建新阶段/移除新实例单位。
-- 施法硬直（SFB_施加通用Buff）与 0.3 秒无敌修正（registerDamageModifier）均有独立到期路径，不在此触碰。
local function _____94C3_4ED9E_4E2D_65AD_6E05_7406(_____65BD_6CD5_5355_4F4D, _____6280_80FDID_6570_503C)
    if _____6280_80FDID_6570_503C ~= ____E_6280_80FDID_6570_503C then
        return
    end
    local ctx = ____E_4E0A_4E0B_6587_8868[GetHandleId(_____65BD_6CD5_5355_4F4D)]
    if ctx == nil or ctx["已结束"] then
        return
    end
    _____6E05_7406E_4E0A_4E0B_6587(ctx)
end
registerSpellEndcastListener(_____94C3_4ED9E_4E2D_65AD_6E05_7406)
return ____exports
