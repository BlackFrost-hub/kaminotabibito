local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.00．配置")
local _____914D_7F6E = ____00_FF0E_914D_7F6E["十六夜咲夜基础技能配置"]
local ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.01．飞刀与时间工具")
local _____4E24_70B9_89D2_5EA6 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["两点角度"]
local _____521B_5EFA_76F4_7EBF_98DE_5200 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["创建直线飞刀"]
local _____521B_5EFA_54B2_591C_5355_4F4D_58F3 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["创建咲夜单位壳"]
local _____5B89_5168_79FB_9664_5355_4F4D_58F3 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["安全移除单位壳"]
local _____6781_5750_6807X = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标Y"]
local _____5355_4F4D_5B58_6D3B = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["单位存活"]
local _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["播放咲夜单位音效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local _____7B26_5361_516C_5171 = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.符卡公共")
local _____8BBE_7F6E_5341_516D_591C_54B2_591C_7B26_5361_4E66_51B7_5374 = _____7B26_5361_516C_5171["设置十六夜咲夜符卡书冷却"]
local ____01_FF0E_5355_4F4D_4E0E_7279_6548_73AF_7ED5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.05．单位与特效环绕.01．单位与特效环绕")
local _____521B_5EFA_5355_4F4D_4E0E_7279_6548_73AF_7ED5 = ____01_FF0E_5355_4F4D_4E0E_7279_6548_73AF_7ED5["创建单位与特效环绕"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心")
local registerSyncHardwareKey = ____require_result_1.registerSyncHardwareKey
local ____require_result_2 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY = ____require_result_2.KEY
local KEY_STATE = ____require_result_2.KEY_STATE
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_3["造成单体技能伤害"]
local _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_3["结束独立技能伤害实例"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_4["读取单位攻击力"]
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_5.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_5["移除单位指定Buff"]
local ____require_result_6 = require("系统.05．Buff系统.03．Buff表.02．英雄.19．十六夜咲夜")
local _____5341_516D_591C_54B2_591CBuffID = ____require_result_6["十六夜咲夜BuffID"]
local ____RF_6D3B_52A8_8868 = {}
local function _____83B7_53D6RF_76D1_542C_4E0A_4E0B_6587(_caster)
    return {["占位"] = true}
end
local function _____6807_51C6_5316_89D2_5DEE(value)
    local result = value % 360
    if result > 180 then
        result = result - 360
    elseif result < -180 then
        result = result + 360
    end
    return result
end
local function ____RF_8BA1_7B97_4F24_5BB3_500D_7387(knife, target)
    local knifeFacing = _____4E24_70B9_89D2_5EA6(
        jass.GetUnitX(knife),
        jass.GetUnitY(knife),
        jass.GetUnitX(target),
        jass.GetUnitY(target)
    )
    local difference = math.abs(_____6807_51C6_5316_89D2_5DEE(jass.GetUnitFacing(target) - knifeFacing))
    if difference > _____914D_7F6E.RF["背刺边界角度"] then
        return {["倍率"] = _____914D_7F6E.RF["中心伤害攻击力倍率"], ["正中心"] = false}
    end
    local ratio = difference / _____914D_7F6E.RF["背刺边界角度"]
    return {["倍率"] = _____914D_7F6E.RF["中心伤害攻击力倍率"] - (_____914D_7F6E.RF["中心伤害攻击力倍率"] - _____914D_7F6E.RF["边缘伤害攻击力倍率"]) * ratio, ["正中心"] = difference <= _____914D_7F6E.RF["正中心背刺角度"]}
end
local function ____RF_8D2F_7A7F_547D_4E2D(target, state)
    local data = state["自定义数据"]
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = state["参数"]["施法者"],
        ["目标"] = target,
        ["伤害"] = data["伤害"],
        ["伤害类型"] = jass.DAMAGE_TYPE_ENHANCED,
        attack = true,
        ranged = true,
        attackType = jass.ATTACK_TYPE_NORMAL,
        weaponType = jass.WEAPON_TYPE_METAL_HEAVY_SLICE,
        ["来源类型"] = "单位技能",
        ["标签"] = "十六夜咲夜-RF-光速跃迁",
        ["技能ID"] = _____914D_7F6E["技能"].RF["类型ID"],
        ["技能实例ID"] = data["技能实例ID"]
    })
    return "继续"
end
local function _____7ED3_675FRF_4E0A_4E0B_6587(context)
    if context["已结束"] then
        return
    end
    context["已结束"] = true
    local ownerId = jass.GetPlayerId(jass.GetOwningPlayer(context["施法者"]))
    if ____RF_6D3B_52A8_8868[ownerId] == context then
        __TS__Delete(____RF_6D3B_52A8_8868, ownerId)
    end
    if context["环绕实例"] ~= nil and not context["环绕实例"]["已结束"] then
        context["环绕实例"]["结束"]("手动")
    end
    if context["目标"] ~= nil and context["目标"] ~= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["目标"], _____5341_516D_591C_54B2_591CBuffID["光速跃迁锁定"])
    end
end
local function ____RF_6267_884C_8D2F_7A7F(variable)
    local context = variable
    if context == nil or context["已结束"] or context["环绕实例"] == nil or context["环绕实例"]["已结束"] then
        return
    end
    local orbitNode = context["环绕实例"]["节点"][1]
    if orbitNode == nil or orbitNode["句柄"] == nil or orbitNode["句柄"] == 0 or not _____5355_4F4D_5B58_6D3B(context["目标"]) then
        _____7ED3_675FRF_4E0A_4E0B_6587(context)
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
        return
    end
    local knife = orbitNode["句柄"]
    local startX = jass.GetUnitX(knife)
    local startY = jass.GetUnitY(knife)
    local angle = _____4E24_70B9_89D2_5EA6(
        startX,
        startY,
        jass.GetUnitX(context["目标"]),
        jass.GetUnitY(context["目标"])
    )
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(context["施法者"]) * ____RF_8BA1_7B97_4F24_5BB3_500D_7387(knife, context["目标"])["倍率"]
    _____7ED3_675FRF_4E0A_4E0B_6587(context)
    local state = _____521B_5EFA_76F4_7EBF_98DE_5200({
        ["施法者"] = context["施法者"],
        ["单位类型ID"] = _____914D_7F6E["单位壳"]["光速红刀"],
        X = startX,
        Y = startY,
        ["角度"] = angle,
        ["周期毫秒"] = _____914D_7F6E.RF["贯穿周期毫秒"],
        ["每Tick位移"] = _____914D_7F6E.RF["贯穿每Tick位移"],
        ["最大距离"] = _____914D_7F6E.RF["贯穿每Tick位移"] * _____914D_7F6E.RF["贯穿Tick"],
        ["命中半径"] = _____914D_7F6E.RF["贯穿命中半径"],
        ["命中去重"] = true,
        ["命中回调"] = ____RF_8D2F_7A7F_547D_4E2D,
        ["结束回调"] = function()
            _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
        end
    })
    if state == nil then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
    else
        state["自定义数据"] = {["伤害"] = damage, ["技能实例ID"] = context["技能实例ID"]}
    end
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_IzayoiSakuya_RF", context["施法者"])
end
local function ____RF_5F00_653E_63D0_524D_8D2F_7A7F(variable)
    local context = variable
    if context ~= nil and not context["已结束"] then
        context["可提前贯穿"] = true
    end
end
local function ____RF_521D_59CB_547D_4E2D(target, state)
    state["自定义数据"]["已锁定"] = true
    local context = {
        ["施法者"] = state["参数"]["施法者"],
        ["目标"] = target,
        ["技能实例ID"] = state["自定义数据"]["技能实例ID"],
        ["环绕实例"] = nil,
        ["可提前贯穿"] = false,
        ["已结束"] = false
    }
    local shell = _____521B_5EFA_54B2_591C_5355_4F4D_58F3(
        context["施法者"],
        _____914D_7F6E["单位壳"]["光速红刀"],
        jass.GetUnitX(target) + _____914D_7F6E.RF["环绕半径"],
        jass.GetUnitY(target),
        90
    )
    if shell == nil or shell == 0 then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
        return "结束"
    end
    context["环绕实例"] = _____521B_5EFA_5355_4F4D_4E0E_7279_6548_73AF_7ED5({
        ["中心单位"] = target,
        ["节点"] = {{
            ["类型"] = "单位",
            ["单位"] = shell,
            ["半径"] = _____914D_7F6E.RF["环绕半径"],
            ["朝向模式"] = "沿切线",
            ["自动销毁"] = true
        }},
        ["半径"] = _____914D_7F6E.RF["环绕半径"],
        ["角速度"] = _____914D_7F6E.RF["环绕角速度"],
        ["周期毫秒"] = _____914D_7F6E.RF["初始周期毫秒"],
        ["持续秒"] = _____914D_7F6E.RF["自动贯穿秒"] + 0.2
    })
    if context["环绕实例"] == nil then
        _____5B89_5168_79FB_9664_5355_4F4D_58F3(shell)
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
        return "结束"
    end
    ____RF_6D3B_52A8_8868[jass.GetPlayerId(jass.GetOwningPlayer(context["施法者"]))] = context
    registerManualBuff(
        target,
        _____5341_516D_591C_54B2_591CBuffID["光速跃迁锁定"],
        _____914D_7F6E.RF["自动贯穿秒"],
        0,
        {sourceUnit = context["施法者"]}
    )
    addDelayedCallback(_____914D_7F6E.RF["可提前贯穿秒"] * 1000, ____RF_5F00_653E_63D0_524D_8D2F_7A7F, context)
    addDelayedCallback(_____914D_7F6E.RF["自动贯穿秒"] * 1000, ____RF_6267_884C_8D2F_7A7F, context)
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_IzayoiSakuya_RF2", context["施法者"])
    return "结束"
end
local function ____onRF_540C_6B65F_952E(event)
    if event.player == nil or event.player == 0 then
        return
    end
    local context = ____RF_6D3B_52A8_8868[jass.GetPlayerId(event.player)]
    if context ~= nil and context["可提前贯穿"] and jass.GetOwningPlayer(context["施法者"]) == event.player then
        ____RF_6267_884C_8D2F_7A7F(context)
    end
end
local function _____91CA_653E_5341_516D_591C_54B2_591CRF(_listener, caster, _____6280_80FD_5B9E_4F8BID)
    _____8BBE_7F6E_5341_516D_591C_54B2_591C_7B26_5361_4E66_51B7_5374(caster, _____914D_7F6E["符卡间隔秒"].RF)
    local x = jass.GetUnitX(caster)
    local y = jass.GetUnitY(caster)
    local angle = _____4E24_70B9_89D2_5EA6(
        x,
        y,
        jass.GetSpellTargetX(),
        jass.GetSpellTargetY()
    )
    local state = _____521B_5EFA_76F4_7EBF_98DE_5200({
        ["施法者"] = caster,
        ["单位类型ID"] = _____914D_7F6E["单位壳"]["光速红刀"],
        X = _____6781_5750_6807X(x, _____914D_7F6E.RF["初始创建距离"], angle),
        Y = _____6781_5750_6807Y(y, _____914D_7F6E.RF["初始创建距离"], angle),
        ["角度"] = angle,
        ["周期毫秒"] = _____914D_7F6E.RF["初始周期毫秒"],
        ["每Tick位移"] = _____914D_7F6E.RF["初始每Tick位移"],
        ["最大距离"] = _____914D_7F6E.RF["初始最大距离"],
        ["命中半径"] = _____914D_7F6E.RF["命中半径"],
        ["命中去重"] = true,
        ["命中回调"] = ____RF_521D_59CB_547D_4E2D,
        ["结束回调"] = function(ended)
            if ended["自定义数据"] ~= nil and ended["自定义数据"]["已锁定"] ~= true then
                _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____6280_80FD_5B9E_4F8BID)
            end
        end
    })
    if state == nil then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____6280_80FD_5B9E_4F8BID)
        return
    end
    state["自定义数据"] = {["技能实例ID"] = _____6280_80FD_5B9E_4F8BID, ["已锁定"] = false}
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_feidaoYX", caster)
end
____exports["注册十六夜咲夜RF"] = function()
    registerSyncHardwareKey(KEY.F, KEY_STATE.DOWN, ____onRF_540C_6B65F_952E)
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "十六夜咲夜-光速跃迁（RF）",
        ["单位类型ID"] = _____914D_7F6E["英雄单位类型ID"],
        ["技能ID"] = _____914D_7F6E["技能"].RF["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6RF_76D1_542C_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5341_516D_591C_54B2_591CRF,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 9
    })
end
____exports["注册十六夜咲夜RF"]()
return ____exports
