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
local _____53D6_6D88_5341_516D_591C_54B2_591C_7B26_5361_754C_9762 = _____7B26_5361_516C_5171["取消十六夜咲夜符卡界面"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_2["造成单体技能伤害"]
local _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_2["结束独立技能伤害实例"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_3["读取单位攻击力"]
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_4["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_4["移除单位暂停"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807 = ____require_result_5["执行战斗自身传送到坐标"]
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_6.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_6["移除单位指定Buff"]
local ____require_result_7 = require("系统.05．Buff系统.03．Buff表.02．英雄.19．十六夜咲夜")
local _____5341_516D_591C_54B2_591CBuffID = ____require_result_7["十六夜咲夜BuffID"]
local ____RX_6D3B_52A8_8868 = {}
local ____RX_5E8F_53F7 = 0
local ____RX_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = false
local function _____83B7_53D6RX_76D1_542C_4E0A_4E0B_6587(_caster)
    return {["占位"] = true}
end
local function _____6E05_7406RX(context, _____7ED3_675F_4F24_5BB3_5B9E_4F8B)
    if context["已结束"] then
        return
    end
    context["已结束"] = true
    local casterId = jass:GetHandleId(context["施法者"])
    if ____RX_6D3B_52A8_8868[casterId] == context then
        __TS__Delete(____RX_6D3B_52A8_8868, casterId)
    end
    do
        local i = 0
        while i < #context["预备飞刀"] do
            _____5B89_5168_79FB_9664_5355_4F4D_58F3(context["预备飞刀"][i + 1]["单位"])
            i = i + 1
        end
    end
    context["预备飞刀"] = {}
    if context["目标"] ~= nil and context["目标"] ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(context["目标"], context["暂停来源"])
        jass:SetUnitVertexColor(
            context["目标"],
            255,
            255,
            255,
            255
        )
    end
    if context["反击特效"] ~= nil and context["反击特效"] ~= 0 then
        jass:DestroyEffect(context["反击特效"])
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["施法者"], _____5341_516D_591C_54B2_591CBuffID["完美女仆反击窗口"])
    if _____7ED3_675F_4F24_5BB3_5B9E_4F8B then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
    end
end
local function ____RX_98DE_5200_547D_4E2D(target, state)
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
        ["标签"] = "十六夜咲夜-RX-完美女仆",
        ["技能ID"] = _____914D_7F6E["技能"].RX["类型ID"],
        ["技能实例ID"] = data["技能实例ID"]
    })
    return "继续"
end
local function ____RX_91CA_653E_4E09_5708_98DE_5200(variable)
    local context = variable
    if context == nil or context["已结束"] or not context["已触发"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) or not _____5355_4F4D_5B58_6D3B(context["目标"]) then
        _____6E05_7406RX(context, true)
        return
    end
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(context["施法者"]) * _____914D_7F6E.RX["伤害攻击力倍率"]
    local remaining = #context["预备飞刀"]
    local records = context["预备飞刀"]
    context["预备飞刀"] = {}
    do
        local i = 0
        while i < #records do
            local record = records[i + 1]
            _____5B89_5168_79FB_9664_5355_4F4D_58F3(record["单位"])
            local state = _____521B_5EFA_76F4_7EBF_98DE_5200({
                ["施法者"] = context["施法者"],
                ["单位类型ID"] = _____914D_7F6E["单位壳"]["蓝刀"],
                X = record.X,
                Y = record.Y,
                ["角度"] = _____4E24_70B9_89D2_5EA6(
                    record.X,
                    record.Y,
                    jass:GetUnitX(context["目标"]),
                    jass:GetUnitY(context["目标"])
                ),
                ["周期毫秒"] = _____914D_7F6E.RX["飞刀周期毫秒"],
                ["每Tick位移"] = _____914D_7F6E.RX["飞刀每Tick位移"],
                ["最大距离"] = _____914D_7F6E.RX["飞刀最大距离"],
                ["命中半径"] = _____914D_7F6E.RX["命中半径"],
                ["命中去重"] = true,
                ["命中回调"] = ____RX_98DE_5200_547D_4E2D,
                ["结束回调"] = function()
                    remaining = remaining - 1
                    if remaining <= 0 then
                        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
                    end
                end
            })
            if state == nil then
                remaining = remaining - 1
            else
                state["自定义数据"] = {["伤害"] = damage, ["技能实例ID"] = context["技能实例ID"]}
            end
            i = i + 1
        end
    end
    _____79FB_9664_5355_4F4D_6682_505C(context["目标"], context["暂停来源"])
    jass:SetUnitVertexColor(
        context["目标"],
        255,
        255,
        255,
        255
    )
    context["目标"] = nil
    local casterId = jass:GetHandleId(context["施法者"])
    if ____RX_6D3B_52A8_8868[casterId] == context then
        __TS__Delete(____RX_6D3B_52A8_8868, casterId)
    end
    context["已结束"] = true
    if context["反击特效"] ~= nil and context["反击特效"] ~= 0 then
        jass:DestroyEffect(context["反击特效"])
    end
    if remaining <= 0 then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
    end
end
local function ____RX_521B_5EFA_4E00_5708(variable)
    local params = variable
    if params == nil or params["上下文"]["已结束"] or not params["上下文"]["已触发"] or not _____5355_4F4D_5B58_6D3B(params["上下文"]["目标"]) then
        return
    end
    local context = params["上下文"]
    local centerX = jass:GetUnitX(context["目标"])
    local centerY = jass:GetUnitY(context["目标"])
    local radius = _____914D_7F6E.RX["第一圈半径"] + params["圈序号"] * _____914D_7F6E.RX["圈半径增量"]
    do
        local i = 0
        while i < _____914D_7F6E.RX["每圈飞刀数"] do
            do
                local angle = i * (360 / _____914D_7F6E.RX["每圈飞刀数"])
                local x = _____6781_5750_6807X(centerX, radius, angle)
                local y = _____6781_5750_6807Y(centerY, radius, angle)
                local shell = _____521B_5EFA_54B2_591C_5355_4F4D_58F3(
                    context["施法者"],
                    _____914D_7F6E["单位壳"]["蓝刀"],
                    x,
                    y,
                    _____4E24_70B9_89D2_5EA6(x, y, centerX, centerY)
                )
                if shell == nil or shell == 0 then
                    goto __continue27
                end
                jass:SetUnitVertexColor(
                    shell,
                    255,
                    255,
                    255,
                    122
                )
                local ____context__9884_5907_98DE_5200_8 = context["预备飞刀"]
                ____context__9884_5907_98DE_5200_8[#____context__9884_5907_98DE_5200_8 + 1] = {["单位"] = shell, X = x, Y = y, ["角度"] = angle}
            end
            ::__continue27::
            i = i + 1
        end
    end
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_PossessionMissileHit1", context["施法者"])
end
local function ____RX_89E3_9664_653B_51FB_8005_6682_505C(variable)
    local context = variable
    if context ~= nil and not context["已结束"] and context["目标"] ~= nil and context["目标"] ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(context["目标"], context["暂停来源"])
    end
end
local function ____RX_6267_884C_53CD_51FB(variable)
    local context = variable
    if context == nil or context["已结束"] or not context["已触发"] or not _____5355_4F4D_5B58_6D3B(context["施法者"]) or not _____5355_4F4D_5B58_6D3B(context["目标"]) then
        if context ~= nil then
            _____6E05_7406RX(context, true)
        end
        return
    end
    local attacker = context["目标"]
    local facing = jass:GetUnitFacing(attacker)
    _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(
        context["施法者"],
        _____6781_5750_6807X(
            jass:GetUnitX(attacker),
            _____914D_7F6E.RX["瞬移偏移"],
            facing + 180
        ),
        _____6781_5750_6807Y(
            jass:GetUnitY(attacker),
            _____914D_7F6E.RX["瞬移偏移"],
            facing + 180
        )
    )
    _____6DFB_52A0_5355_4F4D_6682_505C(attacker, context["暂停来源"])
    jass:SetUnitVertexColor(
        attacker,
        255,
        255,
        255,
        120
    )
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_IzayoiSakuya_RX", context["施法者"])
    do
        local circle = 0
        while circle < _____914D_7F6E.RX["圈数"] do
            addDelayedCallback((circle + 1) * _____914D_7F6E.RX["圈延迟秒"] * 1000, ____RX_521B_5EFA_4E00_5708, {["上下文"] = context, ["圈序号"] = circle})
            circle = circle + 1
        end
    end
    addDelayedCallback(_____914D_7F6E.RX["攻击者时停秒"] * 1000, ____RX_89E3_9664_653B_51FB_8005_6682_505C, context)
    addDelayedCallback((_____914D_7F6E.RX["圈数"] * _____914D_7F6E.RX["圈延迟秒"] + 0.02) * 1000, ____RX_91CA_653E_4E09_5708_98DE_5200, context)
end
local function ____RX_4F24_5BB3_4FEE_6B63(damage)
    local ____temp_9
    if damage ~= nil then
        ____temp_9 = damage.target
    else
        ____temp_9 = nil
    end
    local target = ____temp_9
    if target == nil or target == 0 then
        local ____temp_10
        if damage ~= nil then
            ____temp_10 = damage.currentDamage
        else
            ____temp_10 = 0
        end
        return ____temp_10
    end
    local context = ____RX_6D3B_52A8_8868[jass:GetHandleId(target)]
    if context == nil or context["已结束"] or context["已触发"] or damage.attacker == nil or damage.attacker == 0 then
        return damage.currentDamage
    end
    local dx = jass:GetUnitX(target) - jass:GetUnitX(damage.attacker)
    local dy = jass:GetUnitY(target) - jass:GetUnitY(damage.attacker)
    if dx * dx + dy * dy < _____914D_7F6E.RX["最小触发距离"] * _____914D_7F6E.RX["最小触发距离"] then
        return damage.currentDamage
    end
    context["已触发"] = true
    context["目标"] = damage.attacker
    _____8BBE_7F6E_5341_516D_591C_54B2_591C_7B26_5361_4E66_51B7_5374(context["施法者"], _____914D_7F6E["符卡间隔秒"]["RX成功"], false)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["施法者"], _____5341_516D_591C_54B2_591CBuffID["完美女仆反击窗口"])
    addDelayedCallback(1, ____RX_6267_884C_53CD_51FB, context)
    return 0
end
local function ____RX_7A97_53E3_7ED3_675F(variable)
    local context = variable
    if context ~= nil and not context["已触发"] then
        _____8BBE_7F6E_5341_516D_591C_54B2_591C_7B26_5361_4E66_51B7_5374(context["施法者"], _____914D_7F6E["符卡间隔秒"]["RX失败"], false)
        _____6E05_7406RX(context, true)
    end
end
local function _____91CA_653E_5341_516D_591C_54B2_591CRX(_listener, caster, _____6280_80FD_5B9E_4F8BID)
    _____53D6_6D88_5341_516D_591C_54B2_591C_7B26_5361_754C_9762(caster)
    ____RX_5E8F_53F7 = ____RX_5E8F_53F7 + 1
    local old = ____RX_6D3B_52A8_8868[jass:GetHandleId(caster)]
    if old ~= nil then
        _____6E05_7406RX(old, true)
    end
    local context = {
        ["施法者"] = caster,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["序号"] = ____RX_5E8F_53F7,
        ["已触发"] = false,
        ["已结束"] = false,
        ["预备飞刀"] = {},
        ["目标"] = nil,
        ["暂停来源"] = "十六夜咲夜-RX:" .. tostring(____RX_5E8F_53F7),
        ["反击特效"] = jass:AddSpecialEffectTarget("war3mapImported\\Time Rune.mdx", caster, "origin")
    }
    ____RX_6D3B_52A8_8868[jass:GetHandleId(caster)] = context
    registerManualBuff(
        caster,
        _____5341_516D_591C_54B2_591CBuffID["完美女仆反击窗口"],
        _____914D_7F6E.RX["反击窗口秒"],
        0,
        {sourceUnit = caster}
    )
    addDelayedCallback(_____914D_7F6E.RX["反击窗口秒"] * 1000, ____RX_7A97_53E3_7ED3_675F, context)
end
____exports["注册十六夜咲夜RX"] = function()
    if not ____RX_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C then
        ____RX_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = true
        registerDamageModifier(____RX_4F24_5BB3_4FEE_6B63, 2000)
    end
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "十六夜咲夜-完美女仆（RX）",
        ["单位类型ID"] = _____914D_7F6E["英雄单位类型ID"],
        ["技能ID"] = _____914D_7F6E["技能"].RX["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6RX_76D1_542C_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5341_516D_591C_54B2_591CRX,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 6
    })
end
____exports["注册十六夜咲夜RX"]()
return ____exports
