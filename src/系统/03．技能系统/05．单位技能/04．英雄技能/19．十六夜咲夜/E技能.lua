--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.00．配置")
local _____914D_7F6E = ____00_FF0E_914D_7F6E["十六夜咲夜基础技能配置"]
local ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.01．飞刀与时间工具")
local _____521B_5EFA_76F4_7EBF_98DE_5200 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["创建直线飞刀"]
local _____4E24_70B9_89D2_5EA6 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["两点角度"]
local _____6781_5750_6807X = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标Y"]
local _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["播放咲夜单位音效"]
local _____65BD_52A0_77ED_786C_76F4_5E76_64AD_653E_52A8_4F5C = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["施加短硬直并播放动作"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_0["造成单体技能伤害"]
local _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_0["结束独立技能伤害实例"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local function _____83B7_53D6E_76D1_542C_4E0A_4E0B_6587(_caster)
    return {["占位"] = true}
end
local function ____E_98DE_5200_7ED3_675F(state)
    local data = state["自定义数据"]
    local cast = data["施法"]
    cast["剩余飞刀"] = cast["剩余飞刀"] - 1
    if cast["剩余飞刀"] <= 0 and not cast["已结束"] then
        cast["已结束"] = true
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(cast["技能实例ID"])
    end
end
local function ____E_98DE_5200_547D_4E2D(target, state)
    local data = state["自定义数据"]
    local cast = data["施法"]
    local multiplier = data["已反弹"] and _____914D_7F6E.E["反弹伤害攻击力倍率"] or _____914D_7F6E.E["首段伤害攻击力倍率"]
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = cast["施法者"],
        ["目标"] = target,
        ["伤害"] = cast["攻击力"] * multiplier,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
        ["来源类型"] = "单位技能",
        ["标签"] = data["已反弹"] and "十六夜咲夜-E-反弹" or "十六夜咲夜-E-首段",
        ["技能ID"] = _____914D_7F6E["技能"].E["类型ID"],
        ["技能实例ID"] = cast["技能实例ID"]
    })
    if not data["已反弹"] then
        data["已反弹"] = true
        return "反弹"
    end
    return "结束"
end
local function _____91CA_653E_5341_516D_591C_54B2_591CE(_context, caster, _____6280_80FD_5B9E_4F8BID)
    local casterX = GetUnitX(caster)
    local casterY = GetUnitY(caster)
    local baseAngle = _____4E24_70B9_89D2_5EA6(
        casterX,
        casterY,
        GetSpellTargetX(),
        GetSpellTargetY()
    )
    local cast = {
        ["施法者"] = caster,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["攻击力"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster),
        ["剩余飞刀"] = _____914D_7F6E.E["数量"],
        ["已结束"] = false
    }
    local source = "十六夜咲夜-E:" .. tostring(_____6280_80FD_5B9E_4F8BID or jass.GetHandleId(caster))
    _____65BD_52A0_77ED_786C_76F4_5E76_64AD_653E_52A8_4F5C(caster, source, _____914D_7F6E.E["硬直秒"], "spell")
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548(
        "gg_snd_IzayoiSakuya_attack" .. tostring(jass.GetRandomInt(4, 8)),
        caster
    )
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_OrbOfCorruptionMissile", caster)
    local initialAngle = baseAngle + _____914D_7F6E.E["初始角度偏移"]
    do
        local i = 1
        while i <= _____914D_7F6E.E["数量"] do
            local angle = initialAngle - _____914D_7F6E.E["每刀角度间隔"] * i
            local state = _____521B_5EFA_76F4_7EBF_98DE_5200({
                ["施法者"] = caster,
                ["单位类型ID"] = _____914D_7F6E["单位壳"]["蓝刀"],
                X = _____6781_5750_6807X(casterX, _____914D_7F6E.E["创建距离"], angle),
                Y = _____6781_5750_6807Y(casterY, _____914D_7F6E.E["创建距离"], angle),
                ["角度"] = angle,
                ["周期毫秒"] = _____914D_7F6E.E["周期毫秒"],
                ["每Tick位移"] = _____914D_7F6E.E["每Tick位移"],
                ["最大距离"] = _____914D_7F6E.E["最大距离"],
                ["命中半径"] = _____914D_7F6E.E["命中半径"],
                ["命中去重"] = true,
                ["命中回调"] = ____E_98DE_5200_547D_4E2D,
                ["结束回调"] = ____E_98DE_5200_7ED3_675F
            })
            if state == nil then
                cast["剩余飞刀"] = cast["剩余飞刀"] - 1
            else
                state["自定义数据"] = {["施法"] = cast, ["已反弹"] = false}
            end
            i = i + 1
        end
    end
    if cast["剩余飞刀"] <= 0 then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____6280_80FD_5B9E_4F8BID)
    end
end
____exports["注册十六夜咲夜E"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "十六夜咲夜-Silver Bound（E）",
        ["单位类型ID"] = _____914D_7F6E["英雄单位类型ID"],
        ["技能ID"] = _____914D_7F6E["技能"].E["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6E_76D1_542C_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5341_516D_591C_54B2_591CE,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 6
    })
end
____exports["注册十六夜咲夜E"]()
return ____exports
