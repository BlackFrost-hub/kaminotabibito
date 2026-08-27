--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
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
local _____767B_8BB0_54B2_591C_98DE_5200 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["登记咲夜飞刀"]
local _____6CE8_9500_54B2_591C_98DE_5200 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["注销咲夜飞刀"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local _____7B26_5361_516C_5171 = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.符卡公共")
local _____8BBE_7F6E_5341_516D_591C_54B2_591C_7B26_5361_4E66_51B7_5374 = _____7B26_5361_516C_5171["设置十六夜咲夜符卡书冷却"]
local ____02_FF0E_5355_4F4D_4E0E_8303_56F4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
local _____83B7_53D6_5750_6807_8303_56F4_5355_4F4D_6309_7B5B_9009 = ____02_FF0E_5355_4F4D_4E0E_8303_56F4["获取坐标范围单位按筛选"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_1["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_1["移除单位暂停"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_2["造成单体技能伤害"]
local _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_2["结束独立技能伤害实例"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_3["读取单位攻击力"]
local function _____83B7_53D6RE_76D1_542C_4E0A_4E0B_6587(_caster)
    return {["占位"] = true}
end
local function ____RE_89E3_9664_77ED_6682_505C(variable)
    local data = variable
    if data == nil then
        return
    end
    _____79FB_9664_5355_4F4D_6682_505C(data["单位"], data["来源"])
    if _____5355_4F4D_5B58_6D3B(data["单位"]) then
        jass:SetUnitVertexColor(
            data["单位"],
            255,
            255,
            255,
            255
        )
    end
end
--- 目标枚举。源规则：存活 + 敌对 + 排除 Ancient + 排除已命中（放行建筑/机械/古树/无敌），
-- 返回全部合法目标。配置型筛选逐项等价：要求有效单位=false 跳过四重过滤、
-- 允许死亡=false 排除死亡、允许无敌=true 保持源语义、仅敌人 排除非敌对（含施法者自身）、
-- 自定义条件 排除 Ancient 与已命中。
local function ____RE_679A_4E3E_76EE_6807(state, x, y, radius)
    return _____83B7_53D6_5750_6807_8303_56F4_5355_4F4D_6309_7B5B_9009(
        x,
        y,
        radius,
        state["施法者"],
        {
            ["要求有效单位"] = false,
            ["允许死亡"] = false,
            ["允许建筑"] = true,
            ["允许机械"] = true,
            ["允许古树"] = true,
            ["允许无敌"] = true,
            ["仅敌人"] = true,
            ["自定义条件"] = function(____, u) return not jass:IsUnitType(u, jass.UNIT_TYPE_ANCIENT) and state["已命中"][jass:GetHandleId(u)] ~= true end
        }
    )
end
local function _____7ED3_675FRE(state)
    if state["已结束"] then
        return
    end
    state["已结束"] = true
    if state["周期ID"] ~= 0 then
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(state["周期ID"])
    end
    _____6CE8_9500_54B2_591C_98DE_5200(state["飞刀"])
    _____5B89_5168_79FB_9664_5355_4F4D_58F3(state["飞刀"])
    _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(state["技能实例ID"])
end
local function ____RE_547D_4E2D(state, target)
    state["已命中"][jass:GetHandleId(target)] = true
    state["命中次数"] = state["命中次数"] + 1
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = state["施法者"],
        ["目标"] = target,
        ["伤害"] = state["伤害"],
        ["伤害类型"] = jass.DAMAGE_TYPE_ENHANCED,
        attack = false,
        ranged = false,
        attackType = jass.ATTACK_TYPE_NORMAL,
        weaponType = jass.WEAPON_TYPE_METAL_HEAVY_SLICE,
        ["来源类型"] = "单位技能",
        ["标签"] = "十六夜咲夜-RE-Silver Acute 360",
        ["技能ID"] = _____914D_7F6E["技能"].RE["类型ID"],
        ["技能实例ID"] = state["技能实例ID"]
    })
    local source = (("十六夜咲夜-RE:" .. tostring(state["技能实例ID"] or jass:GetHandleId(state["飞刀"]))) .. ":") .. tostring(state["命中次数"])
    _____6DFB_52A0_5355_4F4D_6682_505C(target, source)
    jass:SetUnitVertexColor(
        target,
        255,
        255,
        255,
        122
    )
    addDelayedCallback(_____914D_7F6E.RE["单次时停秒"] * 1000, ____RE_89E3_9664_77ED_6682_505C, {["单位"] = target, ["来源"] = source})
    if state["命中次数"] >= _____914D_7F6E.RE["最大命中次数"] then
        _____7ED3_675FRE(state)
        return
    end
    local candidates = ____RE_679A_4E3E_76EE_6807(
        state,
        jass:GetUnitX(target),
        jass:GetUnitY(target),
        _____914D_7F6E.RE["搜索半径"]
    )
    if #candidates <= 0 then
        _____7ED3_675FRE(state)
        return
    end
    state["当前目标"] = candidates[jass:GetRandomInt(0, #candidates - 1) + 1]
    state["角度"] = _____4E24_70B9_89D2_5EA6(
        jass:GetUnitX(state["飞刀"]),
        jass:GetUnitY(state["飞刀"]),
        jass:GetUnitX(state["当前目标"]),
        jass:GetUnitY(state["当前目标"])
    )
    state["每Tick位移"] = _____914D_7F6E.RE["锁定后步长"]
    jass:SetUnitFacing(state["飞刀"], state["角度"])
end
local function _____63A8_8FDBRE(variable)
    local state = variable
    if state == nil or state["已结束"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(state["施法者"]) or not _____5355_4F4D_5B58_6D3B(state["飞刀"]) or state["已飞行距离"] >= state["最大距离"] then
        _____7ED3_675FRE(state)
        return
    end
    if state["当前目标"] ~= nil and state["当前目标"] ~= 0 and _____5355_4F4D_5B58_6D3B(state["当前目标"]) then
        state["角度"] = _____4E24_70B9_89D2_5EA6(
            jass:GetUnitX(state["飞刀"]),
            jass:GetUnitY(state["飞刀"]),
            jass:GetUnitX(state["当前目标"]),
            jass:GetUnitY(state["当前目标"])
        )
        jass:SetUnitFacing(state["飞刀"], state["角度"])
    end
    local x = _____6781_5750_6807X(
        jass:GetUnitX(state["飞刀"]),
        state["每Tick位移"],
        state["角度"]
    )
    local y = _____6781_5750_6807Y(
        jass:GetUnitY(state["飞刀"]),
        state["每Tick位移"],
        state["角度"]
    )
    jass:SetUnitX(state["飞刀"], x)
    jass:SetUnitY(state["飞刀"], y)
    state["已飞行距离"] = state["已飞行距离"] + state["每Tick位移"]
    local targets = ____RE_679A_4E3E_76EE_6807(state, x, y, _____914D_7F6E.RE["命中半径"])
    if #targets > 0 then
        ____RE_547D_4E2D(state, targets[1])
    end
end
local function _____91CA_653E_5341_516D_591C_54B2_591CRE(_listener, caster, _____6280_80FD_5B9E_4F8BID)
    _____8BBE_7F6E_5341_516D_591C_54B2_591C_7B26_5361_4E66_51B7_5374(caster, _____914D_7F6E["符卡间隔秒"].RE)
    local x = jass:GetUnitX(caster)
    local y = jass:GetUnitY(caster)
    local angle = _____4E24_70B9_89D2_5EA6(
        x,
        y,
        jass:GetSpellTargetX(),
        jass:GetSpellTargetY()
    )
    local knife = _____521B_5EFA_54B2_591C_5355_4F4D_58F3(
        caster,
        _____914D_7F6E["单位壳"]["光速红刀"],
        _____6781_5750_6807X(x, _____914D_7F6E.RE["创建距离"], angle),
        _____6781_5750_6807Y(y, _____914D_7F6E.RE["创建距离"], angle),
        angle
    )
    if knife == nil or knife == 0 then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____6280_80FD_5B9E_4F8BID)
        return
    end
    local state = {
        ["施法者"] = caster,
        ["飞刀"] = knife,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____914D_7F6E.RE["伤害攻击力倍率"],
        ["角度"] = angle,
        ["每Tick位移"] = _____914D_7F6E.RE["首段步长"],
        ["已飞行距离"] = 0,
        ["最大距离"] = 12000,
        ["当前目标"] = nil,
        ["已命中"] = {},
        ["命中次数"] = 0,
        ["周期ID"] = 0,
        ["已结束"] = false
    }
    _____767B_8BB0_54B2_591C_98DE_5200({
        ["单位"] = knife,
        ["主人"] = caster,
        ["取角度"] = function()
            return state["角度"]
        end,
        ["设置角度"] = function(value)
            state["角度"] = value
            jass:SetUnitFacing(knife, value)
        end,
        ["取每Tick位移"] = function()
            return state["每Tick位移"]
        end,
        ["设置每Tick位移"] = function(value)
            state["每Tick位移"] = value
        end,
        ["取已飞行距离"] = function()
            return state["已飞行距离"]
        end,
        ["设置已飞行距离"] = function(value)
            state["已飞行距离"] = value
        end,
        ["取最大距离"] = function()
            return state["最大距离"]
        end,
        ["设置最大距离"] = function(value)
            state["最大距离"] = value
        end,
        ["结束"] = function()
            _____7ED3_675FRE(state)
        end
    })
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_IzayoiSakuya_RE", caster)
    state["周期ID"] = _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1(_____914D_7F6E.RE["周期毫秒"], _____63A8_8FDBRE, state)
end
____exports["注册十六夜咲夜RE"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "十六夜咲夜-Silver Acute 360（RE）",
        ["单位类型ID"] = _____914D_7F6E["英雄单位类型ID"],
        ["技能ID"] = _____914D_7F6E["技能"].RE["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6RE_76D1_542C_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5341_516D_591C_54B2_591CRE,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 8
    })
end
____exports["注册十六夜咲夜RE"]()
return ____exports
