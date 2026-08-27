local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____Math_6700_5C0F_503C
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.24．塞莉亚·克莱尔.00．配置")
local _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔技能配置"]
local _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔E配置"]
local _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_5B50_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔表现子配置"]
local ____24_FF0E_585E_8389_4E9A_B7_514B_83B1_5C14 = require("系统.05．Buff系统.03．Buff表.02．英雄.24．塞莉亚·克莱尔")
local _____585E_8389_4E9ABuffID = ____24_FF0E_585E_8389_4E9A_B7_514B_83B1_5C14["塞莉亚BuffID"]
local ____02_FF0E_88AB_52A8_6548_679C = require("系统.03．技能系统.05．单位技能.04．英雄技能.24．塞莉亚·克莱尔.02．被动效果")
local _____521B_5EFA_585E_8389_4E9A_8282_70B9 = ____02_FF0E_88AB_52A8_6548_679C["创建塞莉亚节点"]
local _____6388_4E88_585E_8389_4E9A_6F14_7B97_7A97_53E3 = ____02_FF0E_88AB_52A8_6548_679C["授予塞莉亚演算窗口"]
local _____767B_8BB0_585E_8389_4E9A_6280_80FD_6E05_7406 = ____02_FF0E_88AB_52A8_6548_679C["登记塞莉亚技能清理"]
local _____6807_8BB0_76EE_6807_5728_585E_8389_4E9AE_533A_57DF = ____02_FF0E_88AB_52A8_6548_679C["标记目标在塞莉亚E区域"]
local _____53D6_6D88_6807_8BB0_76EE_6807_5728_585E_8389_4E9AE_533A_57DF = ____02_FF0E_88AB_52A8_6548_679C["取消标记目标在塞莉亚E区域"]
local _____76EE_6807_5728_585E_8389_4E9AE_533A_57DF = ____02_FF0E_88AB_52A8_6548_679C["目标在塞莉亚E区域"]
function ____Math_6700_5C0F_503C(a, b)
    return a < b and a or b
end
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local SetUnitFacing = jass.SetUnitFacing
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_1.getGameTime
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_2["注册单位技能壳监听"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂")
local _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_3["创建战斗技能实例"]
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_4["造成技能伤害"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
local _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA = ____require_result_5["获取坐标范围敌人"]
local _____5355_4F4D_662F_5426_654C_5BF9 = ____require_result_5["单位是否敌对"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____4E24_70B9_89D2_5EA6 = ____require_result_6["两点角度"]
local _____5355_4F4D_5B58_6D3B = ____require_result_6["单位存活"]
local _____53D6_5355_4F4DID = ____require_result_6["取单位ID"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_6["读取单位攻击力"]
local ____require_result_7 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_7["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_7["移除单位暂停"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local ____AOE_65BD_52A0_6269_5C55_63A7_5236 = ____require_result_8["AOE施加扩展控制"]
local _____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_8["施加扩展控制"]
local ____require_result_9 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_9.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_9["移除单位指定Buff"]
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_10["创建点特效"]
local _____9500_6BC1_70B9_7279_6548 = ____require_result_10["销毁点特效"]
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E["单位类型ID"]
local ____E_786C_76F4_6765_6E90 = "塞莉亚-E硬直"
local _____585E_8389_4E9A_951A_5B9A_533A_57DF_8868 = {}
____exports["查询塞莉亚锚定区域"] = function(_____82F1_96C4)
    local _____6570_636E = _____585E_8389_4E9A_951A_5B9A_533A_57DF_8868[_____53D6_5355_4F4DID(_____82F1_96C4)]
    if _____6570_636E == nil or getGameTime() >= _____6570_636E["到期时间"] then
        return nil
    end
    return {X = _____6570_636E.X, Y = _____6570_636E.Y, ["半径"] = _____6570_636E["半径"]}
end
--- 锚定区域内最近敌人（Q 追迹分支用；实时校验存活与敌对）。
____exports["取塞莉亚锚定区域内最近敌人"] = function(_____6765_6E90, X, Y, _____534A_5F84)
    local _____5217_8868 = _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA(_____6765_6E90, X, Y, _____534A_5F84)
    local _____6700_8FD1 = nil
    local _____6700_8FD1_5E73_65B9 = _____534A_5F84 * _____534A_5F84
    do
        local i = 0
        while i < #_____5217_8868 do
            do
                local _____654C_4EBA = _____5217_8868[i + 1]
                if not _____5355_4F4D_5B58_6D3B(_____654C_4EBA) then
                    goto __continue6
                end
                if not _____5355_4F4D_662F_5426_654C_5BF9(_____6765_6E90, _____654C_4EBA) then
                    goto __continue6
                end
                local dx = GetUnitX(_____654C_4EBA) - X
                local dy = GetUnitY(_____654C_4EBA) - Y
                local _____5E73_65B9 = dx * dx + dy * dy
                if _____5E73_65B9 <= _____6700_8FD1_5E73_65B9 then
                    _____6700_8FD1_5E73_65B9 = _____5E73_65B9
                    _____6700_8FD1 = _____654C_4EBA
                end
            end
            ::__continue6::
            i = i + 1
        end
    end
    return _____6700_8FD1
end
local function _____5173_95ED_951A_5B9A_533A_57DF(_____6570_636E)
    if _____6570_636E["已关闭"] then
        return
    end
    _____6570_636E["已关闭"] = true
    _____6570_636E["到期时间"] = 0
    if _____6570_636E["周期ID"] > 0 then
        removePeriodicCallback(_____6570_636E["周期ID"])
        _____6570_636E["周期ID"] = 0
    end
    if _____6570_636E["阵特效"] ~= nil and _____6570_636E["阵特效"] ~= 0 then
        _____9500_6BC1_70B9_7279_6548(_____6570_636E["阵特效"])
        _____6570_636E["阵特效"] = nil
    end
    for tid in pairs(_____6570_636E["上次内部成员"]) do
        local _____6210_5458 = _____6570_636E["上次内部成员"][tid]
        _____53D6_6D88_6807_8BB0_76EE_6807_5728_585E_8389_4E9AE_533A_57DF(_____6210_5458)
        if _____6210_5458 ~= nil and _____5355_4F4D_5B58_6D3B(_____6210_5458) and not _____76EE_6807_5728_585E_8389_4E9AE_533A_57DF(_____6210_5458) then
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____6210_5458, _____585E_8389_4E9ABuffID["锚定魔法阵"])
        end
        __TS__Delete(_____6570_636E["停留累计毫秒"], tid)
        __TS__Delete(_____6570_636E["已触发阈值"], tid)
        __TS__Delete(_____6570_636E["上次内部成员"], tid)
    end
    local _____8868 = _____585E_8389_4E9A_951A_5B9A_533A_57DF_8868[_____53D6_5355_4F4DID(_____6570_636E["英雄"])]
    if _____8868 == _____6570_636E then
        __TS__Delete(
            _____585E_8389_4E9A_951A_5B9A_533A_57DF_8868,
            _____53D6_5355_4F4DID(_____6570_636E["英雄"])
        )
    end
end
local function ____on_951A_5B9A_533A_57DF_5468_671F(_____6570_636E, _____6B65_957F_6BEB_79D2)
    if getGameTime() >= _____6570_636E["到期时间"] then
        _____5173_95ED_951A_5B9A_533A_57DF(_____6570_636E)
        return
    end
    local _____82F1_96C4 = _____6570_636E["英雄"]
    if not _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
        return
    end
    local _____5217_8868 = _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA(_____82F1_96C4, _____6570_636E.X, _____6570_636E.Y, _____6570_636E["半径"])
    local _____5728_5185_7D22_5F15 = {}
    do
        local i = 0
        while i < #_____5217_8868 do
            do
                local _____654C_4EBA = _____5217_8868[i + 1]
                if not _____5355_4F4D_5B58_6D3B(_____654C_4EBA) then
                    goto __continue22
                end
                local tid = _____53D6_5355_4F4DID(_____654C_4EBA)
                _____5728_5185_7D22_5F15[tid] = true
                if _____6570_636E["上次内部成员"][tid] == nil then
                    _____6807_8BB0_76EE_6807_5728_585E_8389_4E9AE_533A_57DF(_____654C_4EBA)
                    _____6570_636E["停留累计毫秒"][tid] = 0
                end
                registerManualBuff(
                    _____654C_4EBA,
                    _____585E_8389_4E9ABuffID["锚定魔法阵"],
                    ____Math_6700_5C0F_503C(
                        1.2,
                        (_____6570_636E["到期时间"] - getGameTime()) / 1000
                    ),
                    0
                )
                local _____539F = _____6570_636E["停留累计毫秒"][tid] or 0
                local _____65B0_7D2F_8BA1 = _____539F + _____6B65_957F_6BEB_79D2
                if _____65B0_7D2F_8BA1 >= _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E["停留阈值毫秒"] and _____6570_636E["已触发阈值"][tid] ~= true then
                    _____6570_636E["已触发阈值"][tid] = true
                    _____65BD_52A0_6269_5C55_63A7_5236(_____82F1_96C4, _____654C_4EBA, "roots", _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E["阈值定身秒"])
                end
                _____6570_636E["停留累计毫秒"][tid] = _____65B0_7D2F_8BA1 > 4000 and 4000 or _____65B0_7D2F_8BA1
            end
            ::__continue22::
            i = i + 1
        end
    end
    for tid in pairs(_____6570_636E["上次内部成员"]) do
        if _____5728_5185_7D22_5F15[__TS__Number(tid)] ~= true then
            local _____6210_5458 = _____6570_636E["上次内部成员"][tid]
            _____53D6_6D88_6807_8BB0_76EE_6807_5728_585E_8389_4E9AE_533A_57DF(_____6210_5458)
            if not _____76EE_6807_5728_585E_8389_4E9AE_533A_57DF(_____6210_5458) then
                _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____6210_5458, _____585E_8389_4E9ABuffID["锚定魔法阵"])
            end
            __TS__Delete(_____6570_636E["停留累计毫秒"], tid)
            __TS__Delete(_____6570_636E["上次内部成员"], tid)
        end
    end
    do
        local i = 0
        while i < #_____5217_8868 do
            do
                local _____654C_4EBA = _____5217_8868[i + 1]
                if not _____5355_4F4D_5B58_6D3B(_____654C_4EBA) then
                    goto __continue31
                end
                _____6570_636E["上次内部成员"][_____53D6_5355_4F4DID(_____654C_4EBA)] = _____654C_4EBA
            end
            ::__continue31::
            i = i + 1
        end
    end
end
local function _____91CA_653EE_951A_5B9A_9B54_6CD5_9635(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        return
    end
    local _____4E2D_5FC3X = GetSpellTargetX()
    local _____4E2D_5FC3Y = GetSpellTargetY()
    SetUnitFacing(
        _____65BD_6CD5_8005,
        _____4E24_70B9_89D2_5EA6(
            GetUnitX(_____65BD_6CD5_8005),
            GetUnitY(_____65BD_6CD5_8005),
            _____4E2D_5FC3X,
            _____4E2D_5FC3Y
        )
    )
    local _____5B9E_4F8B = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B({
        ["技能键"] = "E锚定魔法阵",
        ["施法者"] = _____65BD_6CD5_8005,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["结束回调"] = function(______539F_56E0, ______63A7_5236_5668)
            local ____ = ______539F_56E0
            local ____ = ______63A7_5236_5668
        end
    })
    local _____65E7_533A_57DF = _____585E_8389_4E9A_951A_5B9A_533A_57DF_8868[_____53D6_5355_4F4DID(_____65BD_6CD5_8005)]
    if _____65E7_533A_57DF ~= nil then
        _____5173_95ED_951A_5B9A_533A_57DF(_____65E7_533A_57DF)
    end
    local _____9884_8B66_7F29_653E = _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E["生效延迟秒"] <= 0 and 1 or _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_5B50_914D_7F6E["E锚定阵"]["预警缩放系数"]
    local _____9884_8B66 = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_5B50_914D_7F6E["E锚定阵"]["模型路径"],
        X = _____4E2D_5FC3X,
        Y = _____4E2D_5FC3Y,
        Z = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_5B50_914D_7F6E["E锚定阵"]["高度"],
        ["缩放"] = _____9884_8B66_7F29_653E * _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E["区域半径"] / _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_5B50_914D_7F6E["E锚定阵"]["基准半径"],
        ["持续秒"] = _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E["生效延迟秒"]
    })
    local ____ = _____9884_8B66
    _____6DFB_52A0_5355_4F4D_6682_505C(_____65BD_6CD5_8005, ____E_786C_76F4_6765_6E90)
    _____5B9E_4F8B["登记延迟回调"](
        _____5B9E_4F8B,
        addDelayedCallback(
            _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E["硬直秒"] * 1000,
            function()
                _____79FB_9664_5355_4F4D_6682_505C(_____65BD_6CD5_8005, ____E_786C_76F4_6765_6E90)
            end
        )
    )
    _____5B9E_4F8B["登记延迟回调"](
        _____5B9E_4F8B,
        addDelayedCallback(
            _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E["生效延迟秒"] * 1000,
            function()
                if _____5B9E_4F8B["已结束"](_____5B9E_4F8B) then
                    return
                end
                if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
                    return
                end
                local _____6570_636E = {
                    ["英雄"] = _____65BD_6CD5_8005,
                    X = _____4E2D_5FC3X,
                    Y = _____4E2D_5FC3Y,
                    ["半径"] = _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E["区域半径"],
                    ["到期时间"] = getGameTime() + _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E["阵持续秒"] * 1000,
                    ["阵特效"] = nil,
                    ["停留累计毫秒"] = {},
                    ["已触发阈值"] = {},
                    ["上次内部成员"] = {},
                    ["周期ID"] = 0,
                    ["已关闭"] = false
                }
                _____6570_636E["阵特效"] = _____521B_5EFA_70B9_7279_6548({
                    ["模型路径"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_5B50_914D_7F6E["E锚定阵"]["模型路径"],
                    X = _____4E2D_5FC3X,
                    Y = _____4E2D_5FC3Y,
                    Z = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_5B50_914D_7F6E["E锚定阵"]["高度"],
                    ["缩放"] = _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E["区域半径"] / _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_5B50_914D_7F6E["E锚定阵"]["基准半径"] * _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_5B50_914D_7F6E["E锚定阵"]["基准缩放"],
                    ["持续秒"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_5B50_914D_7F6E["E锚定阵"]["持续秒"]
                })
                _____585E_8389_4E9A_951A_5B9A_533A_57DF_8868[_____53D6_5355_4F4DID(_____65BD_6CD5_8005)] = _____6570_636E
                _____6388_4E88_585E_8389_4E9A_6F14_7B97_7A97_53E3(_____65BD_6CD5_8005)
                local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005)
                local _____5217_8868 = _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA(_____65BD_6CD5_8005, _____4E2D_5FC3X, _____4E2D_5FC3Y, _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E["区域半径"])
                do
                    local i = 0
                    while i < #_____5217_8868 do
                        do
                            local _____654C_4EBA = _____5217_8868[i + 1]
                            if not _____5355_4F4D_5B58_6D3B(_____654C_4EBA) then
                                goto __continue43
                            end
                            _____9020_6210_6280_80FD_4F24_5BB3({
                                ["来源"] = _____65BD_6CD5_8005,
                                ["目标"] = _____654C_4EBA,
                                ["伤害"] = _____653B_51FB_529B * _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E["生效伤害攻击力倍率"],
                                ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                                ["攻击类型"] = ATTACK_TYPE_NORMAL,
                                ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
                                ["来源类型"] = "单位技能",
                                ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                                ["标签"] = "塞莉亚-锚定冲击",
                                ["伤害形态"] = "AOE",
                                ["参与技能伤害加成"] = true
                            })
                            _____65BD_52A0_6269_5C55_63A7_5236(_____65BD_6CD5_8005, _____654C_4EBA, "slow", _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E["生效减速秒"])
                        end
                        ::__continue43::
                        i = i + 1
                    end
                end
                _____521B_5EFA_585E_8389_4E9A_8282_70B9(
                    _____65BD_6CD5_8005,
                    "锚定",
                    _____4E2D_5FC3X,
                    _____4E2D_5FC3Y,
                    _____6280_80FD_5B9E_4F8BID
                )
                local _____6B65_957F_6BEB_79D2 = 400
                _____6570_636E["周期ID"] = addPeriodicCallback(
                    _____6B65_957F_6BEB_79D2,
                    function()
                        ____on_951A_5B9A_533A_57DF_5468_671F(_____6570_636E, _____6B65_957F_6BEB_79D2)
                    end
                )
                local _____6CE8_9500 = _____767B_8BB0_585E_8389_4E9A_6280_80FD_6E05_7406(
                    _____65BD_6CD5_8005,
                    "E区域-" .. tostring(_____6280_80FD_5B9E_4F8BID or 0),
                    function()
                        _____5173_95ED_951A_5B9A_533A_57DF(_____6570_636E)
                        if not _____5B9E_4F8B["已结束"](_____5B9E_4F8B) then
                            _____5B9E_4F8B["结束"](_____5B9E_4F8B, "中断")
                        end
                    end
                )
                local ____ = _____6CE8_9500
                _____5B9E_4F8B["登记延迟回调"](
                    _____5B9E_4F8B,
                    addDelayedCallback(
                        _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E["阵持续秒"] * 1000,
                        function()
                            _____5173_95ED_951A_5B9A_533A_57DF(_____6570_636E)
                            if not _____5B9E_4F8B["已结束"](_____5B9E_4F8B) then
                                _____5B9E_4F8B["完成"](_____5B9E_4F8B)
                            end
                            _____6CE8_9500()
                        end
                    )
                )
            end
        )
    )
end
local _____5DF2_6CE8_518C = false
____exports["注册塞莉亚E"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "塞莉亚·克莱尔-锚定魔法阵（E）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.E["技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EE_951A_5B9A_9B54_6CD5_9635,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 10
    })
end
return ____exports
