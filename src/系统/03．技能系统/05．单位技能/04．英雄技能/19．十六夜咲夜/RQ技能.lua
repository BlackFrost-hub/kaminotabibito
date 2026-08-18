local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.00．配置")
local _____914D_7F6E = ____00_FF0E_914D_7F6E["十六夜咲夜基础技能配置"]
local ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.01．飞刀与时间工具")
local _____4E24_70B9_89D2_5EA6 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["两点角度"]
local _____521B_5EFA_54B2_591C_5355_4F4D_58F3 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["创建咲夜单位壳"]
local _____5B89_5168_79FB_9664_5355_4F4D_58F3 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["安全移除单位壳"]
local _____6781_5750_6807X = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标Y"]
local _____5355_4F4D_5B58_6D3B = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["单位存活"]
local _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["播放咲夜单位音效"]
local _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["注册咲夜周期任务"]
local _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["移除咲夜周期任务"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_1["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_1["移除单位暂停"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807 = ____require_result_2["执行战斗自身传送到坐标"]
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
local ____RQ_5E8F_53F7 = 0
local function _____83B7_53D6RQ_76D1_542C_4E0A_4E0B_6587(_caster)
    return {["占位"] = true}
end
local function ____RQ_6E05_7406(context)
    if context["已结束"] then
        return
    end
    context["已结束"] = true
    if context["追踪周期ID"] ~= 0 then
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["追踪周期ID"])
    end
    do
        local i = 0
        while i < #context["飞刀"] do
            _____5B89_5168_79FB_9664_5355_4F4D_58F3(context["飞刀"][i + 1])
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #context["分身"] do
            _____5B89_5168_79FB_9664_5355_4F4D_58F3(context["分身"][i + 1])
            i = i + 1
        end
    end
    context["飞刀"] = {}
    context["分身"] = {}
    if context["目标"] ~= nil and context["目标"] ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(context["目标"], context["来源"])
        jass.SetUnitTimeScale(context["目标"], 1)
        jass.SetUnitVertexColor(
            context["目标"],
            255,
            255,
            255,
            255
        )
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["目标"], _____5341_516D_591C_54B2_591CBuffID["夜雾幻影目标封锁"])
    end
    if context["施法者"] ~= nil and context["施法者"] ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(context["施法者"], context["来源"])
        jass.SetUnitInvulnerable(context["施法者"], false)
        jass.SetUnitTimeScale(context["施法者"], 1)
        jass.ShowUnit(context["施法者"], true)
        jass.SetUnitAnimation(context["施法者"], "stand")
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["施法者"], _____5341_516D_591C_54B2_591CBuffID["夜雾幻影无敌免控"])
    end
    _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
end
local function ____RQ_521B_5EFA_98DE_5200_6392(context, centerX, centerY, facing, count, typeId)
    do
        local i = 0
        while i < count do
            local side = (i - (count - 1) * 0.5) * 15
            local x = _____6781_5750_6807X(
                _____6781_5750_6807X(centerX, 70, facing),
                side,
                facing + 90
            )
            local y = _____6781_5750_6807Y(
                _____6781_5750_6807Y(centerY, 70, facing),
                side,
                facing + 90
            )
            local knife = _____521B_5EFA_54B2_591C_5355_4F4D_58F3(
                context["施法者"],
                typeId,
                x,
                y,
                facing
            )
            if knife ~= nil and knife ~= 0 then
                local ____context__98DE_5200_7 = context["飞刀"]
                ____context__98DE_5200_7[#____context__98DE_5200_7 + 1] = knife
            end
            i = i + 1
        end
    end
end
local function ____RQ_7B2C_4E00_8F6E(variable)
    local context = variable
    if context == nil or context["已结束"] or not _____5355_4F4D_5B58_6D3B(context["施法者"]) or not _____5355_4F4D_5B58_6D3B(context["目标"]) then
        return
    end
    local facing = _____4E24_70B9_89D2_5EA6(
        jass.GetUnitX(context["施法者"]),
        jass.GetUnitY(context["施法者"]),
        jass.GetUnitX(context["目标"]),
        jass.GetUnitY(context["目标"])
    )
    ____RQ_521B_5EFA_98DE_5200_6392(
        context,
        jass.GetUnitX(context["施法者"]),
        jass.GetUnitY(context["施法者"]),
        facing,
        _____914D_7F6E.RQ["第一轮数量"],
        _____914D_7F6E["单位壳"]["蓝刀"]
    )
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_CharmTarget1", context["施法者"])
end
local function ____RQ_5C01_9501_76EE_6807(variable)
    local context = variable
    if context == nil or context["已结束"] or not _____5355_4F4D_5B58_6D3B(context["目标"]) then
        return
    end
    _____6DFB_52A0_5355_4F4D_6682_505C(context["目标"], context["来源"])
    jass.SetUnitTimeScale(context["目标"], 0)
    jass.SetUnitVertexColor(
        context["目标"],
        255,
        255,
        255,
        122
    )
    registerManualBuff(
        context["目标"],
        _____5341_516D_591C_54B2_591CBuffID["夜雾幻影目标封锁"],
        _____914D_7F6E.RQ["最终结算秒"],
        0,
        {sourceUnit = context["施法者"]}
    )
end
local function ____RQ_521B_5EFA_56DB_5411_5206_8EAB(variable)
    local params = variable
    if params == nil or params["上下文"]["已结束"] or not _____5355_4F4D_5B58_6D3B(params["上下文"]["目标"]) then
        return
    end
    local context = params["上下文"]
    local angle = 45 + params["序号"] * 90
    local targetX = jass.GetUnitX(context["目标"])
    local targetY = jass.GetUnitY(context["目标"])
    local x = _____6781_5750_6807X(targetX, _____914D_7F6E.RQ["分身距离"], angle)
    local y = _____6781_5750_6807Y(targetY, _____914D_7F6E.RQ["分身距离"], angle)
    local facing = _____4E24_70B9_89D2_5EA6(x, y, targetX, targetY)
    local clone = _____521B_5EFA_54B2_591C_5355_4F4D_58F3(
        context["施法者"],
        _____914D_7F6E["单位壳"]["侧向分身"],
        x,
        y,
        facing
    )
    if clone ~= nil and clone ~= 0 then
        jass.SetUnitTimeScale(clone, 2)
        jass.SetUnitAnimation(clone, "attack")
        local ____context__5206_8EAB_8 = context["分身"]
        ____context__5206_8EAB_8[#____context__5206_8EAB_8 + 1] = clone
    end
    ____RQ_521B_5EFA_98DE_5200_6392(
        context,
        x,
        y,
        facing,
        _____914D_7F6E.RQ["每分身飞刀数"],
        _____914D_7F6E["单位壳"]["飞行蓝刀"]
    )
end
local function ____RQ_521B_5EFA_4E0A_7A7A_5206_8EAB(variable)
    local context = variable
    if context == nil or context["已结束"] or not _____5355_4F4D_5B58_6D3B(context["目标"]) then
        return
    end
    local targetX = jass.GetUnitX(context["目标"])
    local targetY = jass.GetUnitY(context["目标"])
    local highClone = _____521B_5EFA_54B2_591C_5355_4F4D_58F3(
        context["施法者"],
        _____914D_7F6E["单位壳"]["高空分身"],
        targetX,
        targetY,
        jass.GetRandomReal(0, 360)
    )
    if highClone ~= nil and highClone ~= 0 then
        jass.SetUnitFlyHeight(
            highClone,
            jass.GetUnitFlyHeight(context["目标"]) + 500,
            0
        )
        jass.SetUnitTimeScale(highClone, 0.5)
        jass.SetUnitAnimation(highClone, "morph")
        local ____context__5206_8EAB_9 = context["分身"]
        ____context__5206_8EAB_9[#____context__5206_8EAB_9 + 1] = highClone
    end
    do
        local i = 0
        while i < _____914D_7F6E.RQ["上空飞刀数"] do
            local angle = i * 36
            local knife = _____521B_5EFA_54B2_591C_5355_4F4D_58F3(
                context["施法者"],
                _____914D_7F6E["单位壳"]["环绕蓝刀"],
                _____6781_5750_6807X(targetX, 250, angle),
                _____6781_5750_6807Y(targetY, 250, angle),
                angle + 180
            )
            if knife ~= nil and knife ~= 0 then
                jass.SetUnitFlyHeight(
                    knife,
                    jass.GetUnitFlyHeight(context["目标"]) + 500,
                    0
                )
                local ____context__98DE_5200_10 = context["飞刀"]
                ____context__98DE_5200_10[#____context__98DE_5200_10 + 1] = knife
            end
            i = i + 1
        end
    end
end
local function ____RQ_672C_4F53_79FB_4F4D(variable)
    local context = variable
    if context == nil or context["已结束"] or not _____5355_4F4D_5B58_6D3B(context["施法者"]) or not _____5355_4F4D_5B58_6D3B(context["目标"]) then
        return
    end
    local angle = jass.GetUnitFacing(context["目标"]) + 180
    local x = _____6781_5750_6807X(
        jass.GetUnitX(context["目标"]),
        _____914D_7F6E.RQ["分身距离"],
        angle
    )
    local y = _____6781_5750_6807Y(
        jass.GetUnitY(context["目标"]),
        _____914D_7F6E.RQ["分身距离"],
        angle
    )
    jass.ShowUnit(context["施法者"], true)
    _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(context["施法者"], x, y)
    jass.SetUnitFacing(context["施法者"], angle)
    jass.SetUnitAnimation(context["施法者"], "throw")
end
local function ____RQ_6062_590D_672C_4F53(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    _____79FB_9664_5355_4F4D_6682_505C(context["施法者"], context["来源"])
    jass.SetUnitTimeScale(context["施法者"], 1)
    jass.SetUnitAnimation(context["施法者"], "stand")
end
local function ____RQ_63A8_8FDB_98DE_5200(variable)
    local context = variable
    if context == nil or context["已结束"] or not context["已释放飞刀"] or not _____5355_4F4D_5B58_6D3B(context["目标"]) then
        return
    end
    do
        local i = #context["飞刀"] - 1
        while i >= 0 do
            do
                local knife = context["飞刀"][i + 1]
                if not _____5355_4F4D_5B58_6D3B(knife) then
                    __TS__ArraySplice(context["飞刀"], i, 1)
                    goto __continue36
                end
                local x = jass.GetUnitX(knife)
                local y = jass.GetUnitY(knife)
                local tx = jass.GetUnitX(context["目标"])
                local ty = jass.GetUnitY(context["目标"])
                local dx = tx - x
                local dy = ty - y
                if dx * dx + dy * dy <= _____914D_7F6E.RQ["飞刀追踪步长"] * _____914D_7F6E.RQ["飞刀追踪步长"] then
                    _____5B89_5168_79FB_9664_5355_4F4D_58F3(knife)
                    __TS__ArraySplice(context["飞刀"], i, 1)
                    goto __continue36
                end
                local angle = _____4E24_70B9_89D2_5EA6(x, y, tx, ty)
                jass.SetUnitX(
                    knife,
                    _____6781_5750_6807X(x, _____914D_7F6E.RQ["飞刀追踪步长"], angle)
                )
                jass.SetUnitY(
                    knife,
                    _____6781_5750_6807Y(y, _____914D_7F6E.RQ["飞刀追踪步长"], angle)
                )
                jass.SetUnitFacing(knife, angle)
                if jass.GetUnitFlyHeight(knife) > jass.GetUnitFlyHeight(context["目标"]) then
                    jass.SetUnitFlyHeight(
                        knife,
                        math.max(
                            jass.GetUnitFlyHeight(context["目标"]),
                            jass.GetUnitFlyHeight(knife) - 18
                        ),
                        0
                    )
                end
            end
            ::__continue36::
            i = i - 1
        end
    end
end
local function ____RQ_91CA_653E_98DE_5200(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    context["已释放飞刀"] = true
    do
        local i = 0
        while i < #context["分身"] do
            _____5B89_5168_79FB_9664_5355_4F4D_58F3(context["分身"][i + 1])
            i = i + 1
        end
    end
    context["分身"] = {}
    context["追踪周期ID"] = _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1(_____914D_7F6E.RQ["飞刀追踪周期毫秒"], ____RQ_63A8_8FDB_98DE_5200, context)
end
local function ____RQ_6700_7EC8_7ED3_7B97(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    if _____5355_4F4D_5B58_6D3B(context["施法者"]) and _____5355_4F4D_5B58_6D3B(context["目标"]) then
        local hitEffect = jass.AddSpecialEffect(
            "war3mapImported\\bloodex.mdx",
            jass.GetUnitX(context["目标"]),
            jass.GetUnitY(context["目标"])
        )
        if hitEffect ~= nil and hitEffect ~= 0 then
            jass.DestroyEffect(hitEffect)
        end
        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = context["施法者"],
            ["目标"] = context["目标"],
            ["伤害"] = context["攻击力快照"] * _____914D_7F6E.RQ["最终伤害攻击力倍率"],
            ["伤害类型"] = jass.DAMAGE_TYPE_NORMAL,
            attack = false,
            ranged = false,
            attackType = jass.ATTACK_TYPE_NORMAL,
            weaponType = jass.WEAPON_TYPE_METAL_HEAVY_SLICE,
            ["来源类型"] = "单位技能",
            ["标签"] = "十六夜咲夜-RQ-夜雾幻影杀人鬼",
            ["技能ID"] = _____914D_7F6E["技能"].RQ["类型ID"],
            ["技能实例ID"] = context["技能实例ID"]
        })
    end
    ____RQ_6E05_7406(context)
end
local function _____91CA_653E_5341_516D_591C_54B2_591CRQ(_listener, caster, _____6280_80FD_5B9E_4F8BID)
    local target = jass.GetSpellTargetUnit()
    if not _____5355_4F4D_5B58_6D3B(target) then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____6280_80FD_5B9E_4F8BID)
        return
    end
    ____RQ_5E8F_53F7 = ____RQ_5E8F_53F7 + 1
    local context = {
        ["施法者"] = caster,
        ["目标"] = target,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["来源"] = "十六夜咲夜-RQ:" .. tostring(____RQ_5E8F_53F7),
        ["攻击力快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster),
        ["飞刀"] = {},
        ["分身"] = {},
        ["追踪周期ID"] = 0,
        ["已释放飞刀"] = false,
        ["已结束"] = false
    }
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, context["来源"])
    jass.SetUnitInvulnerable(caster, true)
    jass.SetUnitAnimationByIndex(caster, 2)
    jass.SetUnitTimeScale(caster, 2.5)
    registerManualBuff(
        caster,
        _____5341_516D_591C_54B2_591CBuffID["夜雾幻影无敌免控"],
        _____914D_7F6E.RQ["最终结算秒"],
        0,
        {sourceUnit = caster}
    )
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_IzayoiSakuya_RQ1", caster)
    addDelayedCallback(_____914D_7F6E.RQ["第一轮延迟秒"] * 1000, ____RQ_7B2C_4E00_8F6E, context)
    addDelayedCallback(_____914D_7F6E.RQ["封锁延迟秒"] * 1000, ____RQ_5C01_9501_76EE_6807, context)
    do
        local i = 0
        while i < _____914D_7F6E.RQ["四向分身数"] do
            addDelayedCallback((_____914D_7F6E.RQ["四向开始秒"] + i * _____914D_7F6E.RQ["四向间隔秒"]) * 1000, ____RQ_521B_5EFA_56DB_5411_5206_8EAB, {["上下文"] = context, ["序号"] = i})
            i = i + 1
        end
    end
    addDelayedCallback(_____914D_7F6E.RQ["上空分身秒"] * 1000, ____RQ_521B_5EFA_4E0A_7A7A_5206_8EAB, context)
    addDelayedCallback(_____914D_7F6E.RQ["本体移位秒"] * 1000, ____RQ_672C_4F53_79FB_4F4D, context)
    addDelayedCallback(_____914D_7F6E.RQ["本体恢复秒"] * 1000, ____RQ_6062_590D_672C_4F53, context)
    addDelayedCallback(_____914D_7F6E.RQ["飞刀释放秒"] * 1000, ____RQ_91CA_653E_98DE_5200, context)
    addDelayedCallback(_____914D_7F6E.RQ["最终结算秒"] * 1000, ____RQ_6700_7EC8_7ED3_7B97, context)
end
____exports["注册十六夜咲夜RQ"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "十六夜咲夜-夜雾幻影杀人鬼（RQ）",
        ["单位类型ID"] = _____914D_7F6E["英雄单位类型ID"],
        ["技能ID"] = _____914D_7F6E["技能"].RQ["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6RQ_76D1_542C_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5341_516D_591C_54B2_591CRQ,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 12
    })
end
____exports["注册十六夜咲夜RQ"]()
return ____exports
