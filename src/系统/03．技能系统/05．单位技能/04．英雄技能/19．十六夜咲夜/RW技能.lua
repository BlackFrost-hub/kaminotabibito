--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.00．配置")
local _____914D_7F6E = ____00_FF0E_914D_7F6E["十六夜咲夜基础技能配置"]
local ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.01．飞刀与时间工具")
local _____521B_5EFA_76F4_7EBF_98DE_5200 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["创建直线飞刀"]
local _____521B_5EFA_54B2_591C_5355_4F4D_58F3 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["创建咲夜单位壳"]
local _____5B89_5168_79FB_9664_5355_4F4D_58F3 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["安全移除单位壳"]
local _____4E24_70B9_89D2_5EA6 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["两点角度"]
local _____6781_5750_6807X = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标Y"]
local _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["播放咲夜单位音效"]
local _____65BD_52A0_77ED_786C_76F4_5E76_64AD_653E_52A8_4F5C = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["施加短硬直并播放动作"]
local _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["注册咲夜周期任务"]
local _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["移除咲夜周期任务"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local _____7B26_5361_516C_5171 = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.符卡公共")
local _____8BBE_7F6E_5341_516D_591C_54B2_591C_7B26_5361_4E66_51B7_5374 = _____7B26_5361_516C_5171["设置十六夜咲夜符卡书冷却"]
local ____RR_6280_80FD = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.RR技能")
local _____5341_516D_591C_54B2_591C_5904_4E8E_54B2_591C_4E16_754C = ____RR_6280_80FD["十六夜咲夜处于咲夜世界"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_0["造成单体技能伤害"]
local _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_0["结束独立技能伤害实例"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local function _____83B7_53D6RW_76D1_542C_4E0A_4E0B_6587(_caster)
    return {["占位"] = true}
end
local function _____5C1D_8BD5_7ED3_675FRW(cast)
    if cast["已结束"] or cast["已发射"] < _____914D_7F6E.RW["数量"] or cast["活动飞刀"] > 0 then
        return
    end
    cast["已结束"] = true
    _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(cast["技能实例ID"])
    _____5B89_5168_79FB_9664_5355_4F4D_58F3(cast["分身"])
    cast["分身"] = nil
end
local function ____RW_98DE_5200_7ED3_675F(state)
    local cast = state["自定义数据"]
    cast["活动飞刀"] = cast["活动飞刀"] - 1
    _____5C1D_8BD5_7ED3_675FRW(cast)
end
local function ____RW_98DE_5200_547D_4E2D(target, state)
    local cast = state["自定义数据"]
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = cast["施法者"],
        ["目标"] = target,
        ["伤害"] = cast["伤害"],
        ["伤害类型"] = jass.DAMAGE_TYPE_NORMAL,
        attack = false,
        ranged = true,
        attackType = jass.ATTACK_TYPE_NORMAL,
        weaponType = jass.WEAPON_TYPE_METAL_HEAVY_SLICE,
        ["来源类型"] = "单位技能",
        ["标签"] = "十六夜咲夜-RW-Eternal Meek",
        ["技能ID"] = _____914D_7F6E["技能"].RW["类型ID"],
        ["技能实例ID"] = cast["技能实例ID"]
    })
    return "结束"
end
local function _____53D1_5C04RW_98DE_5200(variable)
    local cast = variable
    if cast == nil or cast["已结束"] then
        return
    end
    if cast["已发射"] >= _____914D_7F6E.RW["数量"] then
        if cast["发射周期ID"] ~= 0 then
            _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(cast["发射周期ID"])
        end
        cast["发射周期ID"] = 0
        _____5C1D_8BD5_7ED3_675FRW(cast)
        return
    end
    local x = jass:GetUnitX(cast["施法者"])
    local y = jass:GetUnitY(cast["施法者"])
    local baseAngle = _____4E24_70B9_89D2_5EA6(x, y, cast["目标X"], cast["目标Y"])
    local angle = baseAngle + jass:GetRandomReal(-_____914D_7F6E.RW["随机角度"], _____914D_7F6E.RW["随机角度"])
    local state = _____521B_5EFA_76F4_7EBF_98DE_5200({
        ["施法者"] = cast["施法者"],
        ["单位类型ID"] = _____914D_7F6E["单位壳"]["蓝刀"],
        X = _____6781_5750_6807X(x, _____914D_7F6E.RW["创建距离"], angle),
        Y = _____6781_5750_6807Y(y, _____914D_7F6E.RW["创建距离"], angle),
        ["角度"] = angle,
        ["周期毫秒"] = _____914D_7F6E.RW["周期毫秒"],
        ["每Tick位移"] = _____914D_7F6E.RW["每Tick位移"],
        ["最大距离"] = _____914D_7F6E.RW["最大距离"],
        ["命中半径"] = _____914D_7F6E.RW["命中半径"],
        ["命中回调"] = ____RW_98DE_5200_547D_4E2D,
        ["结束回调"] = ____RW_98DE_5200_7ED3_675F
    })
    cast["已发射"] = cast["已发射"] + 1
    if state ~= nil then
        state["自定义数据"] = cast
        cast["活动飞刀"] = cast["活动飞刀"] + 1
    end
end
local function _____91CA_653E_5341_516D_591C_54B2_591CRW(_listener, caster, _____6280_80FD_5B9E_4F8BID)
    _____8BBE_7F6E_5341_516D_591C_54B2_591C_7B26_5361_4E66_51B7_5374(caster, _____914D_7F6E["符卡间隔秒"].RW)
    local cast = {
        ["施法者"] = caster,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["目标X"] = jass:GetSpellTargetX(),
        ["目标Y"] = jass:GetSpellTargetY(),
        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____914D_7F6E.RW["伤害攻击力倍率"],
        ["已发射"] = 0,
        ["活动飞刀"] = 0,
        ["发射周期ID"] = 0,
        ["分身"] = nil,
        ["已结束"] = false
    }
    local x = jass:GetUnitX(caster)
    local y = jass:GetUnitY(caster)
    local angle = _____4E24_70B9_89D2_5EA6(x, y, cast["目标X"], cast["目标Y"])
    if _____5341_516D_591C_54B2_591C_5904_4E8E_54B2_591C_4E16_754C(caster) then
        cast["分身"] = _____521B_5EFA_54B2_591C_5355_4F4D_58F3(
            caster,
            _____914D_7F6E["单位壳"]["正常分身"],
            _____6781_5750_6807X(x, 50, angle),
            _____6781_5750_6807Y(y, 50, angle),
            angle
        )
        if cast["分身"] ~= nil and cast["分身"] ~= 0 then
            jass:SetUnitFlyHeight(
                cast["分身"],
                jass:GetUnitDefaultFlyHeight(cast["分身"]),
                0
            )
            jass:SetUnitAnimation(cast["分身"], "channel")
        end
    end
    if not _____5341_516D_591C_54B2_591C_5904_4E8E_54B2_591C_4E16_754C(caster) then
        _____65BD_52A0_77ED_786C_76F4_5E76_64AD_653E_52A8_4F5C(
            caster,
            "十六夜咲夜-RW:" .. tostring(_____6280_80FD_5B9E_4F8BID or jass:GetHandleId(caster)),
            _____914D_7F6E.RW["硬直秒"],
            "channel"
        )
    end
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_IzayoiSakuya_RW", caster)
    _____53D1_5C04RW_98DE_5200(cast)
    cast["发射周期ID"] = _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1(_____914D_7F6E.RW["周期毫秒"], _____53D1_5C04RW_98DE_5200, cast)
end
____exports["注册十六夜咲夜RW"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "十六夜咲夜-Eternal Meek（RW）",
        ["单位类型ID"] = _____914D_7F6E["英雄单位类型ID"],
        ["技能ID"] = _____914D_7F6E["技能"].RW["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6RW_76D1_542C_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5341_516D_591C_54B2_591CRW,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 5
    })
end
____exports["注册十六夜咲夜RW"]()
return ____exports
