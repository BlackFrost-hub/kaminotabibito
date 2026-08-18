--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____Q_5355_5200_7ED3_675F, _____5207_6362Q_8FFD_8E2A_5200, _____767B_8BB0Q_98DE_5200, _____63A8_8FDBQ_98DE_5200, jass, _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3, _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B, _____5355_4F4D_662F_5426_6682_505C, GetUnitX, GetUnitY, GetUnitFlyHeight, SetUnitX, SetUnitY, SetUnitFacing, SetUnitFlyHeight, SetUnitScale, IsUnitEnemy, GetOwningPlayer, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_METAL_HEAVY_SLICE
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.00．配置")
local _____914D_7F6E = ____00_FF0E_914D_7F6E["十六夜咲夜基础技能配置"]
local ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.01．飞刀与时间工具")
local _____4E24_70B9_89D2_5EA6 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["两点角度"]
local _____5355_4F4D_5B58_6D3B = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["单位存活"]
local _____521B_5EFA_54B2_591C_5355_4F4D_58F3 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["创建咲夜单位壳"]
local _____5B89_5168_79FB_9664_5355_4F4D_58F3 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["安全移除单位壳"]
local _____6781_5750_6807X = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标Y"]
local _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["播放咲夜单位音效"]
local _____65BD_52A0_77ED_786C_76F4_5E76_64AD_653E_52A8_4F5C = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["施加短硬直并播放动作"]
local _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["注册咲夜周期任务"]
local _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["移除咲夜周期任务"]
local _____767B_8BB0_54B2_591C_98DE_5200 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["登记咲夜飞刀"]
local _____6CE8_9500_54B2_591C_98DE_5200 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["注销咲夜飞刀"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function ____Q_5355_5200_7ED3_675F(state)
    if state["已结束"] then
        return
    end
    state["已结束"] = true
    if state["周期ID"] ~= 0 then
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(state["周期ID"])
    end
    state["周期ID"] = 0
    _____6CE8_9500_54B2_591C_98DE_5200(state["单位"])
    _____5B89_5168_79FB_9664_5355_4F4D_58F3(state["单位"])
    local cast = state["上下文"]
    cast["剩余飞刀"] = cast["剩余飞刀"] - 1
    if cast["剩余飞刀"] <= 0 and not cast["已结束"] then
        cast["已结束"] = true
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(cast["技能实例ID"])
    end
end
function _____5207_6362Q_8FFD_8E2A_5200(state)
    local old = state["单位"]
    local x = jass.GetUnitX(old)
    local y = jass.GetUnitY(old)
    local target = state["上下文"]["目标"]
    local angle = target ~= nil and target ~= 0 and _____4E24_70B9_89D2_5EA6(
        x,
        y,
        GetUnitX(target),
        GetUnitY(target)
    ) or state["角度"]
    _____6CE8_9500_54B2_591C_98DE_5200(old)
    _____5B89_5168_79FB_9664_5355_4F4D_58F3(old)
    local replacement = _____521B_5EFA_54B2_591C_5355_4F4D_58F3(
        state["上下文"]["施法者"],
        _____914D_7F6E["单位壳"]["蓝刀"],
        x,
        y,
        angle
    )
    if replacement == nil or replacement == 0 then
        state["单位"] = nil
        ____Q_5355_5200_7ED3_675F(state)
        return
    end
    SetUnitScale(replacement, 1, 1, 1)
    state["单位"] = replacement
    state["角度"] = angle
    state["阶段"] = "追踪"
    _____767B_8BB0Q_98DE_5200(state)
    if state["周期ID"] ~= 0 then
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(state["周期ID"])
    end
    state["周期ID"] = _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1(_____914D_7F6E.Q["追踪周期毫秒"], _____63A8_8FDBQ_98DE_5200, state)
end
function _____767B_8BB0Q_98DE_5200(state)
    _____767B_8BB0_54B2_591C_98DE_5200({
        ["单位"] = state["单位"],
        ["主人"] = state["上下文"]["施法者"],
        ["取角度"] = function()
            return state["角度"]
        end,
        ["设置角度"] = function(value)
            state["角度"] = value
            SetUnitFacing(state["单位"], value)
        end,
        ["取每Tick位移"] = function()
            return state["阶段"] == "外扩" and _____914D_7F6E.Q["外扩步长"] or _____914D_7F6E.Q["追踪步长"]
        end,
        ["设置每Tick位移"] = function(_value)
        end,
        ["取已飞行距离"] = function()
            return state["已飞行距离"]
        end,
        ["设置已飞行距离"] = function(value)
            state["已飞行距离"] = value
        end,
        ["取最大距离"] = function()
            return _____914D_7F6E.Q["追踪步长"] * _____914D_7F6E.Q["追踪最大Tick"]
        end,
        ["设置最大距离"] = function(value)
            state["追踪Tick"] = math.max(
                0,
                _____914D_7F6E.Q["追踪最大Tick"] - math.floor(value / _____914D_7F6E.Q["追踪步长"])
            )
        end,
        ["结束"] = function()
            ____Q_5355_5200_7ED3_675F(state)
        end
    })
end
function _____63A8_8FDBQ_98DE_5200(variable)
    local state = variable
    if state == nil or state["已结束"] then
        return
    end
    local shell = state["单位"]
    if not _____5355_4F4D_5B58_6D3B(shell) or not _____5355_4F4D_5B58_6D3B(state["上下文"]["施法者"]) then
        ____Q_5355_5200_7ED3_675F(state)
        return
    end
    if _____5355_4F4D_662F_5426_6682_505C(shell) then
        return
    end
    if state["阶段"] == "外扩" then
        if state["已飞行距离"] >= _____914D_7F6E.Q["外扩距离"] then
            _____5207_6362Q_8FFD_8E2A_5200(state)
            return
        end
        SetUnitX(
            shell,
            _____6781_5750_6807X(
                GetUnitX(shell),
                _____914D_7F6E.Q["外扩步长"],
                state["角度"]
            )
        )
        SetUnitY(
            shell,
            _____6781_5750_6807Y(
                GetUnitY(shell),
                _____914D_7F6E.Q["外扩步长"],
                state["角度"]
            )
        )
        state["已飞行距离"] = state["已飞行距离"] + _____914D_7F6E.Q["外扩步长"]
        return
    end
    state["追踪Tick"] = state["追踪Tick"] + 1
    if state["追踪Tick"] >= _____914D_7F6E.Q["追踪最大Tick"] then
        ____Q_5355_5200_7ED3_675F(state)
        return
    end
    local target = state["上下文"]["目标"]
    if target == nil or target == 0 then
        ____Q_5355_5200_7ED3_675F(state)
        return
    end
    local angle = _____4E24_70B9_89D2_5EA6(
        GetUnitX(shell),
        GetUnitY(shell),
        GetUnitX(target),
        GetUnitY(target)
    )
    state["角度"] = angle
    SetUnitFacing(shell, angle)
    local nextX = _____6781_5750_6807X(
        GetUnitX(shell),
        _____914D_7F6E.Q["追踪步长"],
        angle
    )
    local nextY = _____6781_5750_6807Y(
        GetUnitY(shell),
        _____914D_7F6E.Q["追踪步长"],
        angle
    )
    SetUnitX(shell, nextX)
    SetUnitY(shell, nextY)
    if GetUnitFlyHeight(shell) > GetUnitFlyHeight(target) then
        SetUnitFlyHeight(
            shell,
            GetUnitFlyHeight(shell) - 5,
            0
        )
    end
    local dx = nextX - GetUnitX(target)
    local dy = nextY - GetUnitY(target)
    if dx * dx + dy * dy > _____914D_7F6E.Q["命中半径"] * _____914D_7F6E.Q["命中半径"] then
        return
    end
    if _____5355_4F4D_5B58_6D3B(target) and IsUnitEnemy(
        target,
        GetOwningPlayer(state["上下文"]["施法者"])
    ) then
        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = state["上下文"]["施法者"],
            ["目标"] = target,
            ["伤害"] = state["上下文"]["伤害"],
            ["伤害类型"] = DAMAGE_TYPE_NORMAL,
            attack = false,
            ranged = false,
            attackType = ATTACK_TYPE_NORMAL,
            weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
            ["来源类型"] = "单位技能",
            ["标签"] = "十六夜咲夜-Q-杀人玩偶",
            ["技能ID"] = _____914D_7F6E["技能"].Q["类型ID"],
            ["技能实例ID"] = state["上下文"]["技能实例ID"]
        })
    end
    ____Q_5355_5200_7ED3_675F(state)
end
jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_0["造成单体技能伤害"]
_____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_0["结束独立技能伤害实例"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
_____5355_4F4D_662F_5426_6682_505C = ____require_result_2["单位是否暂停"]
local GetSpellTargetUnit = jass.GetSpellTargetUnit
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFlyHeight = jass.GetUnitFlyHeight
SetUnitX = jass.SetUnitX
SetUnitY = jass.SetUnitY
SetUnitFacing = jass.SetUnitFacing
SetUnitFlyHeight = jass.SetUnitFlyHeight
SetUnitScale = jass.SetUnitScale
IsUnitEnemy = jass.IsUnitEnemy
GetOwningPlayer = jass.GetOwningPlayer
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local function _____83B7_53D6Q_76D1_542C_4E0A_4E0B_6587(_caster)
    return {["占位"] = true}
end
local function _____91CA_653E_5341_516D_591C_54B2_591CQ(_context, caster, _____6280_80FD_5B9E_4F8BID)
    local target = GetSpellTargetUnit()
    if target == nil or target == 0 then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____6280_80FD_5B9E_4F8BID)
        return
    end
    local cast = {
        ["施法者"] = caster,
        ["目标"] = target,
        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____914D_7F6E.Q["伤害攻击力倍率"],
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["剩余飞刀"] = _____914D_7F6E.Q["数量"],
        ["已结束"] = false
    }
    local source = "十六夜咲夜-Q:" .. tostring(_____6280_80FD_5B9E_4F8BID or jass.GetHandleId(caster))
    _____65BD_52A0_77ED_786C_76F4_5E76_64AD_653E_52A8_4F5C(caster, source, _____914D_7F6E.Q["硬直秒"], "spell")
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_IzayoiSakuya_RQ3", caster)
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    do
        local i = 1
        while i <= _____914D_7F6E.Q["数量"] do
            do
                local angle = _____914D_7F6E.Q["初始角度间隔"] * i
                local shell = _____521B_5EFA_54B2_591C_5355_4F4D_58F3(
                    caster,
                    _____914D_7F6E["单位壳"]["环绕蓝刀"],
                    x,
                    y,
                    angle
                )
                if shell == nil or shell == 0 then
                    cast["剩余飞刀"] = cast["剩余飞刀"] - 1
                    goto __continue34
                end
                local state = {
                    ["上下文"] = cast,
                    ["单位"] = shell,
                    ["阶段"] = "外扩",
                    ["角度"] = angle,
                    ["已飞行距离"] = 0,
                    ["追踪Tick"] = 0,
                    ["周期ID"] = 0,
                    ["已结束"] = false
                }
                _____767B_8BB0Q_98DE_5200(state)
                state["周期ID"] = _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1(_____914D_7F6E.Q["外扩周期毫秒"], _____63A8_8FDBQ_98DE_5200, state)
            end
            ::__continue34::
            i = i + 1
        end
    end
    if cast["剩余飞刀"] <= 0 then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____6280_80FD_5B9E_4F8BID)
    end
end
____exports["注册十六夜咲夜Q"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "十六夜咲夜-杀人玩偶（Q）",
        ["单位类型ID"] = _____914D_7F6E["英雄单位类型ID"],
        ["技能ID"] = _____914D_7F6E["技能"].Q["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6Q_76D1_542C_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5341_516D_591C_54B2_591CQ,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 10
    })
end
____exports["注册十六夜咲夜Q"]()
return ____exports
