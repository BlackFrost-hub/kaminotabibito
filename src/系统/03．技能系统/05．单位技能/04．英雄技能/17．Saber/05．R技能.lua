--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____9500_6BC1R_805A_96C6_8868_73B0, ____R_521B_5EFA_80FD_91CF_8868_73B0, _____63A8_8FDBR_5149_70AE, ____R_80FD_91CF_4E0E_5149_70AE_542F_52A8, ____R_53D1_5C04_51C6_5907, addDelayedCallback, addPeriodicCallback, removePeriodicCallback, _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3, _____83B7_53D6_8303_56F4_654C_519B, _____79FB_9664_5355_4F4D_6682_505C, _____521B_5EFA_70B9_7279_6548, _____9500_6BC1_70B9_7279_6548, GetUnitFacing, GetHandleId, Cos, Sin, bj_DEGTORAD, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_DIVINE, WEAPON_TYPE_WHOKNOWS, _____914D_7F6E, ____R_7C7B_578BID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.17．Saber.00．配置")
local ____Saber_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["Saber技能配置"]
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.17．Saber.01．状态表")
local ____Saber_662F_5426_963F_74E6_9686 = ____01_FF0E_72B6_6001_8868["Saber是否阿瓦隆"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local ____24_FF0E_6574_6570_4E0E_65F6_95F4_6362_7B97 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.24．整数与时间换算")
local _____79D2_8F6C_6BEB_79D2 = ____24_FF0E_6574_6570_4E0E_65F6_95F4_6362_7B97["秒转毫秒"]
function _____9500_6BC1R_805A_96C6_8868_73B0(ctx)
    if ctx["聚集回调ID"] ~= 0 then
        removePeriodicCallback(ctx["聚集回调ID"])
        ctx["聚集回调ID"] = 0
    end
    for ____, p in ipairs(ctx["聚集列表"]) do
        if p["特效"] ~= nil and p["特效"] ~= 0 then
            _____9500_6BC1_70B9_7279_6548(p["特效"])
        end
    end
    ctx["聚集列表"] = {}
end
function ____R_521B_5EFA_80FD_91CF_8868_73B0(ctx, _____89D2_5EA6)
    local _____9762_5411_5F27_5EA6 = (_____89D2_5EA6 + 180) * bj_DEGTORAD
    local _____70B91X = ctx["Saber点X"] + _____914D_7F6E.R["发射"]["能量A"]["后方偏移"] * Cos(_____9762_5411_5F27_5EA6)
    local _____70B91Y = ctx["Saber点Y"] + _____914D_7F6E.R["发射"]["能量A"]["后方偏移"] * Sin(_____9762_5411_5F27_5EA6)
    local _____70B92X = ctx["Saber点X"] + _____914D_7F6E.R["发射"]["能量B"]["后方偏移"] * Cos(_____9762_5411_5F27_5EA6)
    local _____70B92Y = ctx["Saber点Y"] + _____914D_7F6E.R["发射"]["能量B"]["后方偏移"] * Sin(_____9762_5411_5F27_5EA6)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.R["发射"]["能量A"]["模型路径"],
        X = _____70B91X,
        Y = _____70B91Y,
        Z = _____914D_7F6E.R["发射"]["能量A"]["飞行高度"],
        ["面向角度"] = _____89D2_5EA6 + _____914D_7F6E.R["发射"]["能量A"]["朝向偏移"],
        ["缩放"] = _____914D_7F6E.R["发射"]["能量A"]["缩放"],
        ["动画速度"] = _____914D_7F6E.R["发射"]["能量A"]["动画速度"],
        ["持续秒"] = _____914D_7F6E.R["光炮"]["间隔秒"] * _____914D_7F6E.R["光炮"]["最大Tick数"] + 1
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.R["发射"]["能量B"]["模型路径"],
        X = _____70B92X,
        Y = _____70B92Y,
        ["面向角度"] = _____89D2_5EA6 + _____914D_7F6E.R["发射"]["能量B"]["朝向偏移"],
        ["缩放"] = _____914D_7F6E.R["发射"]["能量B"]["缩放"],
        ["动画速度"] = _____914D_7F6E.R["发射"]["能量B"]["动画速度"],
        ["蓝"] = _____914D_7F6E.R["发射"]["能量B"]["蓝"],
        ["持续秒"] = _____914D_7F6E.R["光炮"]["间隔秒"] * _____914D_7F6E.R["光炮"]["最大Tick数"] + 1
    })
end
function _____63A8_8FDBR_5149_70AE(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx.caster
    local function _____6536_5C3E()
        if ctx["光炮回调ID"] ~= 0 then
            removePeriodicCallback(ctx["光炮回调ID"])
        end
        ctx["光炮回调ID"] = 0
        ctx["已启动"] = false
    end
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        _____6536_5C3E()
        return
    end
    ctx["光炮Tick数"] = ctx["光炮Tick数"] + 1
    if ctx["光炮Tick数"] > _____914D_7F6E.R["光炮"]["最大Tick数"] then
        _____6536_5C3E()
        return
    end
    for ____, tick in ipairs(_____914D_7F6E.R["发射"]["能量重现Tick"]) do
        if ctx["光炮Tick数"] == tick then
            ____R_521B_5EFA_80FD_91CF_8868_73B0(
                ctx,
                GetUnitFacing(caster)
            )
        end
    end
    local _____5F27_5EA6 = ctx["方向角度"] * bj_DEGTORAD
    local _____70B9X = ctx["Saber点X"] + _____914D_7F6E.R["光炮"]["每Tick距离"] * ctx["光炮Tick数"] * Cos(_____5F27_5EA6)
    local _____70B9Y = ctx["Saber点Y"] + _____914D_7F6E.R["光炮"]["每Tick距离"] * ctx["光炮Tick数"] * Sin(_____5F27_5EA6)
    if _____914D_7F6E.R["光炮"]["每Tick距离"] * ctx["光炮Tick数"] > _____914D_7F6E.R["光炮"]["最大距离"] then
        _____6536_5C3E()
        return
    end
    local _____654C_519B_5217_8868 = _____83B7_53D6_8303_56F4_654C_519B(caster, _____70B9X, _____70B9Y, _____914D_7F6E.R["光炮"]["伤害半径"])
    local _____65B0_76EE_6807 = {}
    for ____, target in ipairs(_____654C_519B_5217_8868) do
        do
            if target == nil or target == 0 then
                goto __continue58
            end
            if ctx["命中组"][GetHandleId(target)] == true then
                goto __continue58
            end
            ctx["命中组"][GetHandleId(target)] = true
            _____65B0_76EE_6807[#_____65B0_76EE_6807 + 1] = target
        end
        ::__continue58::
    end
    if #_____65B0_76EE_6807 > 0 then
        local _____500D_7387 = ctx["阿瓦隆快照"] and _____914D_7F6E.R["光炮"]["阿瓦隆伤害攻击力倍率"] or _____914D_7F6E.R["光炮"]["伤害攻击力倍率"]
        _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
            ["来源"] = caster,
            ["目标列表"] = _____65B0_76EE_6807,
            ["伤害"] = ctx["伤害快照"] * _____500D_7387,
            ["伤害类型"] = DAMAGE_TYPE_DIVINE,
            attackType = ATTACK_TYPE_NORMAL,
            weaponType = WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = "单位技能",
            ["标签"] = ctx["阿瓦隆快照"] and "Saber-R-光炮-阿瓦隆" or "Saber-R-光炮",
            ["技能ID"] = ____R_7C7B_578BID,
            ["技能实例ID"] = ctx["技能实例ID"]
        })
    end
end
function ____R_80FD_91CF_4E0E_5149_70AE_542F_52A8(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    ctx["能量回调ID"] = 0
    local caster = ctx.caster
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        ctx["已启动"] = false
        return
    end
    local _____89D2_5EA6 = GetUnitFacing(caster)
    ____R_521B_5EFA_80FD_91CF_8868_73B0(ctx, _____89D2_5EA6)
    _____79FB_9664_5355_4F4D_6682_505C(caster, _____914D_7F6E["暂停来源"]["R蓄力"])
    ctx["光炮Tick数"] = 0
    ctx["命中组"] = {}
    ctx["光炮回调ID"] = addPeriodicCallback(
        _____79D2_8F6C_6BEB_79D2(_____914D_7F6E.R["光炮"]["间隔秒"]),
        _____63A8_8FDBR_5149_70AE,
        ctx
    )
end
function ____R_53D1_5C04_51C6_5907(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    ctx["准备回调ID"] = 0
    _____9500_6BC1R_805A_96C6_8868_73B0(ctx)
    local caster = ctx.caster
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        ctx["已启动"] = false
        return
    end
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.R["发射"]["光束"]["模型路径"],
        X = ctx["Saber点X"],
        Y = ctx["Saber点Y"],
        ["面向角度"] = ctx["方向角度"] + _____914D_7F6E.R["发射"]["光束"]["朝向偏移"],
        ["缩放"] = _____914D_7F6E.R["发射"]["光束"]["缩放"],
        ["持续秒"] = _____914D_7F6E.R["发射"]["光束"]["持续秒"]
    })
    ctx["能量回调ID"] = addDelayedCallback(
        _____79D2_8F6C_6BEB_79D2(_____914D_7F6E.R["发射"]["能量准备延迟秒"]),
        ____R_80FD_91CF_4E0E_5149_70AE_542F_52A8,
        ctx
    )
end
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_0.addDelayedCallback
addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_1["造成批量AOE技能伤害"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____83B7_53D6_8303_56F4_654C_519B = ____require_result_2["获取范围敌军"]
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_3["添加单位暂停"]
_____79FB_9664_5355_4F4D_6682_505C = ____require_result_3["移除单位暂停"]
local ____require_result_4 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundOnUnitBJ = ____require_result_4.PlaySoundOnUnitBJ
local StopSoundBJ = ____require_result_4.StopSoundBJ
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_5["创建点特效"]
_____9500_6BC1_70B9_7279_6548 = ____require_result_5["销毁点特效"]
local ____require_result_6 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_6.registerDeathListener
local ____require_result_7 = require("lib.扩展函数.BJ函数.07．杂项")
local GetRandomDirectionDeg = ____require_result_7.GetRandomDirectionDeg
local japi = require("jass.japi")
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
GetUnitFacing = jass.GetUnitFacing
local GetUnitFlyHeight = jass.GetUnitFlyHeight
GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local GetRandomReal = jass.GetRandomReal
Cos = jass.Cos
Sin = jass.Sin
bj_DEGTORAD = jass.bj_DEGTORAD
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_DIVINE = jass.DAMAGE_TYPE_DIVINE
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local DzSetEffectPos = japi.DzSetEffectPos
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_8.stringToFourCCSafe
local stringToFourCC = stringToFourCCSafe
_____914D_7F6E = ____Saber_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
____R_7C7B_578BID = stringToFourCC(_____914D_7F6E.R["技能ID"])
local ____R_4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAR_4E0A_4E0B_6587(caster)
    local id = GetHandleId(caster)
    local record = ____R_4E0A_4E0B_6587_8868[id]
    if record == nil then
        record = {
            caster = caster,
            ["已启动"] = false,
            ["伤害快照"] = 0,
            ["Saber点X"] = 0,
            ["Saber点Y"] = 0,
            ["方向角度"] = 0,
            ["飞行高度快照"] = 0,
            ["阿瓦隆快照"] = false,
            ["蓄力回调ID"] = 0,
            ["蓄力Tick数"] = 0,
            ["聚集列表"] = {},
            ["聚集回调ID"] = 0,
            ["准备回调ID"] = 0,
            ["能量回调ID"] = 0,
            ["光炮回调ID"] = 0,
            ["光炮Tick数"] = 0,
            ["命中组"] = {}
        }
        ____R_4E0A_4E0B_6587_8868[id] = record
    end
    return record
end
local function _____6E05_7406R_5168_90E8(ctx)
    local caster = ctx.caster
    if ctx["蓄力回调ID"] ~= 0 then
        removePeriodicCallback(ctx["蓄力回调ID"])
    end
    if ctx["准备回调ID"] ~= 0 then
        removeDelayedCallback(ctx["准备回调ID"])
    end
    if ctx["能量回调ID"] ~= 0 then
        removeDelayedCallback(ctx["能量回调ID"])
    end
    if ctx["光炮回调ID"] ~= 0 then
        removePeriodicCallback(ctx["光炮回调ID"])
    end
    ctx["蓄力回调ID"] = 0
    ctx["准备回调ID"] = 0
    ctx["能量回调ID"] = 0
    ctx["光炮回调ID"] = 0
    _____9500_6BC1R_805A_96C6_8868_73B0(ctx)
    if caster ~= nil and caster ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(caster, _____914D_7F6E["暂停来源"]["R蓄力"])
    end
    ctx["已启动"] = false
end
local function ____R_53EF_91CA_653E(context, _caster)
    return not context["已启动"]
end
local SquareRoot = jass.SquareRoot
local function _____63A8_8FDBR_805A_96C6_56DE_6536(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx.caster
    if #ctx["聚集列表"] == 0 or caster == nil or caster == 0 then
        _____9500_6BC1R_805A_96C6_8868_73B0(ctx)
        return
    end
    local cfg = _____914D_7F6E.R["蓄力结束"]["聚集回收"]
    local _____76EE_6807X = GetUnitX(caster)
    local _____76EE_6807Y = GetUnitY(caster)
    local _____76EE_6807_9AD8_5EA6 = GetUnitFlyHeight(caster)
    local _____5269_4F59 = {}
    for ____, p in ipairs(ctx["聚集列表"]) do
        do
            local dx = _____76EE_6807X - p.X
            local dy = _____76EE_6807Y - p.Y
            local _____8DDD_79BB = SquareRoot(dx * dx + dy * dy)
            if _____8DDD_79BB <= cfg["到达距离"] then
                if p["特效"] ~= nil and p["特效"] ~= 0 then
                    _____9500_6BC1_70B9_7279_6548(p["特效"])
                end
                goto __continue19
            end
            local _____6B65_957F = _____8DDD_79BB < cfg["每次移动距离"] and _____8DDD_79BB or cfg["每次移动距离"]
            p.X = p.X + dx / _____8DDD_79BB * _____6B65_957F
            p.Y = p.Y + dy / _____8DDD_79BB * _____6B65_957F
            local _____9AD8_5DEE = _____76EE_6807_9AD8_5EA6 - p["高度"]
            local _____9650_5E45_9AD8_5DEE = _____9AD8_5DEE > cfg["每次高度变化"] and cfg["每次高度变化"] or (_____9AD8_5DEE < -cfg["每次高度变化"] and -cfg["每次高度变化"] or _____9AD8_5DEE)
            p["高度"] = p["高度"] + _____9650_5E45_9AD8_5DEE
            if p["特效"] ~= nil and p["特效"] ~= 0 then
                DzSetEffectPos(p["特效"], p.X, p.Y, p["高度"])
            end
            _____5269_4F59[#_____5269_4F59 + 1] = p
        end
        ::__continue19::
    end
    ctx["聚集列表"] = _____5269_4F59
    if #ctx["聚集列表"] == 0 and ctx["聚集回调ID"] ~= 0 then
        removePeriodicCallback(ctx["聚集回调ID"])
        ctx["聚集回调ID"] = 0
    end
end
local function _____542F_52A8R_805A_96C6_56DE_6536(ctx)
    if #ctx["聚集列表"] == 0 then
        return
    end
    if ctx["聚集回调ID"] ~= 0 then
        removePeriodicCallback(ctx["聚集回调ID"])
    end
    ctx["聚集回调ID"] = addPeriodicCallback(
        _____79D2_8F6C_6BEB_79D2(_____914D_7F6E.R["蓄力结束"]["聚集回收"]["Tick间隔秒"]),
        _____63A8_8FDBR_805A_96C6_56DE_6536,
        ctx
    )
end
local function ____R_84C4_529B_7ED3_675F(ctx)
    local caster = ctx.caster
    if ctx["蓄力回调ID"] ~= 0 then
        removePeriodicCallback(ctx["蓄力回调ID"])
    end
    ctx["蓄力回调ID"] = 0
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        _____6E05_7406R_5168_90E8(ctx)
        return
    end
    if ctx["阿瓦隆快照"] then
        local ____r_963F_74E6_9686_97F3_6548_53E5_67C4 = jglobals[_____914D_7F6E.R["蓄力"]["音效"]["全局音效键"]]
        if ____r_963F_74E6_9686_97F3_6548_53E5_67C4 ~= nil then
            PlaySoundOnUnitBJ(____r_963F_74E6_9686_97F3_6548_53E5_67C4, 100, caster)
        end
        _____9500_6BC1R_805A_96C6_8868_73B0(ctx)
    else
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____914D_7F6E.R["蓄力结束"]["法阵特效"]["模型路径"],
            X = ctx["Saber点X"],
            Y = ctx["Saber点Y"],
            ["面向角度"] = ctx["方向角度"] + _____914D_7F6E.R["蓄力结束"]["法阵特效"]["朝向偏移"],
            ["缩放"] = _____914D_7F6E.R["蓄力结束"]["法阵特效"]["缩放"],
            ["持续秒"] = _____914D_7F6E.R["蓄力结束"]["法阵特效"]["持续秒"]
        })
        _____542F_52A8R_805A_96C6_56DE_6536(ctx)
    end
    SetUnitAnimationByIndex(caster, _____914D_7F6E.R["蓄力结束"]["动作索引"])
    ctx["准备回调ID"] = addDelayedCallback(
        _____79D2_8F6C_6BEB_79D2(_____914D_7F6E.R["蓄力结束"]["发射准备延迟秒"]),
        ____R_53D1_5C04_51C6_5907,
        ctx
    )
end
local function _____63A8_8FDBR_84C4_529B(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx.caster
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) or ctx["阿瓦隆快照"] or ctx["蓄力Tick数"] >= _____914D_7F6E.R["蓄力"]["最大Tick数"] then
        ____R_84C4_529B_7ED3_675F(ctx)
        return
    end
    ctx["蓄力Tick数"] = ctx["蓄力Tick数"] + 1
    if ctx["蓄力Tick数"] == _____914D_7F6E.R["蓄力"]["音效Tick"] then
        local ____r_84C4_529B_97F3_6548_53E5_67C4 = jglobals[_____914D_7F6E.R["蓄力"]["音效"]["全局音效键"]]
        if ____r_84C4_529B_97F3_6548_53E5_67C4 ~= nil then
            PlaySoundOnUnitBJ(____r_84C4_529B_97F3_6548_53E5_67C4, 100, caster)
        end
    end
    local cfg = _____914D_7F6E.R["蓄力"]["聚集粒子"]
    do
        local i = 0
        while i < cfg["每Tick数量"] do
            local _____534A_5F84 = GetRandomReal(0, cfg["随机半径上限"])
            local _____89D2_5EA6 = GetRandomDirectionDeg() * bj_DEGTORAD
            local X = ctx["Saber点X"] + _____534A_5F84 * Cos(_____89D2_5EA6)
            local Y = ctx["Saber点Y"] + _____534A_5F84 * Sin(_____89D2_5EA6)
            local ____ctx__805A_96C6_5217_8868_9 = ctx["聚集列表"]
            ____ctx__805A_96C6_5217_8868_9[#____ctx__805A_96C6_5217_8868_9 + 1] = {
                X = X,
                Y = Y,
                ["高度"] = ctx["飞行高度快照"],
                ["特效"] = _____521B_5EFA_70B9_7279_6548({
                    ["模型路径"] = cfg["模型路径"],
                    X = X,
                    Y = Y,
                    Z = ctx["飞行高度快照"],
                    ["持续秒"] = -1
                })
            }
            i = i + 1
        end
    end
    local _____5269_4F59 = {}
    for ____, p in ipairs(ctx["聚集列表"]) do
        do
            if p["高度"] >= cfg["移除高度"] then
                if p["特效"] ~= nil and p["特效"] ~= 0 then
                    _____9500_6BC1_70B9_7279_6548(p["特效"])
                end
                goto __continue41
            end
            p["高度"] = p["高度"] + (ctx["蓄力Tick数"] >= cfg["上升段Tick数"] and cfg["下降每次高度"] or cfg["上升每次高度"])
            if p["高度"] < 0 then
                p["高度"] = 0
            end
            if p["特效"] ~= nil and p["特效"] ~= 0 then
                DzSetEffectPos(p["特效"], p.X, p.Y, p["高度"])
            end
            _____5269_4F59[#_____5269_4F59 + 1] = p
        end
        ::__continue41::
    end
    ctx["聚集列表"] = _____5269_4F59
end
local function _____91CA_653ER_6280_80FD(context, caster, _____6280_80FD_5B9E_4F8BID)
    if context["已启动"] then
        return
    end
    context["已启动"] = true
    context.caster = caster
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["伤害快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    context["Saber点X"] = GetUnitX(caster)
    context["Saber点Y"] = GetUnitY(caster)
    context["方向角度"] = _____4E24_70B9_89D2_5EA6(
        context["Saber点X"],
        context["Saber点Y"],
        GetSpellTargetX(),
        GetSpellTargetY()
    )
    context["飞行高度快照"] = GetUnitFlyHeight(caster)
    context["阿瓦隆快照"] = ____Saber_662F_5426_963F_74E6_9686(caster)
    context["蓄力Tick数"] = 0
    context["光炮Tick数"] = 0
    context["命中组"] = {}
    context["聚集列表"] = {}
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, _____914D_7F6E["暂停来源"]["R蓄力"])
    SetUnitAnimationByIndex(caster, _____914D_7F6E.R["起手"]["动作索引"])
    context["蓄力回调ID"] = addPeriodicCallback(
        _____79D2_8F6C_6BEB_79D2(_____914D_7F6E.R["蓄力"]["间隔秒"]),
        _____63A8_8FDBR_84C4_529B,
        context
    )
end
local ____R_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function ____R_5355_4F4D_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    if GetUnitTypeId(dyingUnit) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    local ctx = ____R_4E0A_4E0B_6587_8868[GetHandleId(dyingUnit)]
    if ctx == nil or not ctx["已启动"] then
        return
    end
    local ____excalibur_53E5_67C4 = jglobals[_____914D_7F6E.R["蓄力"]["音效"]["全局音效键"]]
    if ____excalibur_53E5_67C4 ~= nil then
        StopSoundBJ(____excalibur_53E5_67C4, true)
    end
    _____6E05_7406R_5168_90E8(ctx)
end
____exports["注册SaberR"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "Saber-誓约胜利之剑（R）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.R["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAR_4E0A_4E0B_6587,
        ["可释放"] = ____R_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653ER_6280_80FD,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 12
    })
    if not ____R_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        ____R_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(____R_5355_4F4D_6B7B_4EA1_6E05_7406)
    end
end
____exports["注册SaberR"]()
return ____exports
