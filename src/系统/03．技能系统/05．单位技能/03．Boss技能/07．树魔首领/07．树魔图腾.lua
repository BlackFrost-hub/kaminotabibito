--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stringToFourCC, _____5355_4F4D_6709_6548, _____8DDD_79BB_5E73_65B9XY, _____53D6_96BE_5EA6, _____53D6_56FE_817E_4E2D_5FC3, _____9009_62E9_56FE_817E_5206_652F, _____521B_5EFA_56FE_817E_5355_4F4D, _____5BF9_6240_6709_73A9_5BB6_65BD_52A0_9759_6B62_7729_6655, _____521B_5EFA_9759_6B62_9677_9631, _____521B_5EFA_751F_547D_9677_9631, _____7206_70B8_9677_9631_9020_6210_4F24_5BB3, _____8C03_5EA6_7206_70B8_9677_9631_7206_70B8, _____521B_5EFA_7206_70B8_9677_9631, _____521B_5EFA_6811_9B54_56FE_817E_5206_652F, ____on_6811_9B54_9996_9886_6811_9B54_56FE_817E_751F_6548, _____9020_6210AOE_6280_80FD_4F24_5BB3, GetUnitTypeId, GetUnitX, GetUnitY, GetUnitState, GetOwningPlayer, IsUnitType, IssuePointOrder, SetUnitMoveSpeed, SetUnitPosition, SetUnitAnimationByIndex, GetRandomInt, GetRandomReal, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE, UNIT_TYPE_DEAD, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, _____521B_5EFA_6280_80FD_63D0_793A_5708, _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4Ex, addDelayedCallback, addPeriodicCallback, removePeriodicCallback, getGameDifficulty, registerManualBuff, _____6811_9B54_9996_9886BuffID, _____65BD_52A0_5FEB_901F_63A7_5236Buff, createTimedEffect, CosBJ, SinBJ, _____5FEB_901F_63A7_5236__51FB_6655, _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID, _____6811_9B54_56FE_817E_6280_80FDID, _____730E_5934_8005_5355_4F4D_7C7B_578BID, _____5DEB_533B_5355_4F4D_7C7B_578BID, _____6295_63B7_8005_5355_4F4D_7C7B_578BID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.00．配置")
local _____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["树魔首领单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建树魔首领上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.02．数值与表现配置")
local _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔首领数值与表现配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.08．台词播放")
local _____64AD_653E_6811_9B54_9996_9886_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放树魔首领台词"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
function _____8DDD_79BB_5E73_65B9XY(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return dx * dx + dy * dy
end
function _____53D6_96BE_5EA6()
    local n = getGameDifficulty()
    return n > 0 and n or 1
end
function _____53D6_56FE_817E_4E2D_5FC3(boss)
    return {
        x = GetUnitX(boss),
        y = GetUnitY(boss)
    }
end
function _____9009_62E9_56FE_817E_5206_652F(context)
    local candidates = {}
    local ____self_12 = context["随从组"]
    local list = ____self_12["取单位列表"](____self_12)
    do
        local i = 0
        while i < #list do
            do
                local unit = list[i + 1]
                if not _____5355_4F4D_6709_6548(unit) then
                    goto __continue9
                end
                local typeId = GetUnitTypeId(unit)
                if typeId == _____5DEB_533B_5355_4F4D_7C7B_578BID then
                    candidates[#candidates + 1] = 1
                elseif typeId == _____730E_5934_8005_5355_4F4D_7C7B_578BID then
                    candidates[#candidates + 1] = 2
                elseif typeId == _____6295_63B7_8005_5355_4F4D_7C7B_578BID then
                    candidates[#candidates + 1] = 3
                end
            end
            ::__continue9::
            i = i + 1
        end
    end
    if #candidates <= 0 then
        return GetRandomInt(1, 3)
    end
    return candidates[GetRandomInt(0, #candidates - 1) + 1]
end
function _____521B_5EFA_56FE_817E_5355_4F4D(context, _____540D_79F0, _____6A21_578B_8DEF_5F84, _____6700_5927_751F_547D, _____6301_7EED_79D2, ____on_6B7B_4EA1)
    local boss = context["Boss单位"]
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔图腾"]
    local center = _____53D6_56FE_817E_4E2D_5FC3(boss)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "渐变圆形",
        X = center.x,
        Y = center.y,
        ["半径"] = cfg["图腾落点提示半径"],
        ["持续时间"] = 0.6,
        ["来源单位"] = boss
    })
    return _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = _____540D_79F0,
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["模型路径"] = _____6A21_578B_8DEF_5F84,
        X = center.x,
        Y = center.y,
        ["最大生命"] = _____6700_5927_751F_547D,
        ["生命值受小怪倍率"] = false,
        ["飞行高度"] = cfg["图腾飞行高度"],
        ["缩放"] = cfg["图腾缩放"],
        ["持续时间"] = _____6301_7EED_79D2,
        ["on死亡"] = ____on_6B7B_4EA1
    })
end
function _____5BF9_6240_6709_73A9_5BB6_65BD_52A0_9759_6B62_7729_6655(boss)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔图腾"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue18
                end
                _____65BD_52A0_5FEB_901F_63A7_5236Buff(boss, hero, _____5FEB_901F_63A7_5236__51FB_6655, cfg["静止陷阱眩晕秒"])
                registerManualBuff(
                    hero,
                    _____6811_9B54_9996_9886BuffID["静止陷阱眩晕"],
                    cfg["静止陷阱眩晕秒"],
                    0,
                    {sourceName = "树魔首领-静止陷阱"}
                )
            end
            ::__continue18::
            i = i + 1
        end
    end
end
function _____521B_5EFA_9759_6B62_9677_9631(context)
    local boss = context["Boss单位"]
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔图腾"]
    local duration = cfg["静止陷阱基础持续秒"] + cfg["静止陷阱每难度追加秒"] * _____53D6_96BE_5EA6()
    local trap = _____521B_5EFA_56FE_817E_5355_4F4D(
        context,
        "树魔首领-静止陷阱",
        cfg["静止陷阱模型路径"],
        GetUnitState(boss, UNIT_STATE_MAX_LIFE) * cfg["静止陷阱生命Boss最大生命比例"],
        duration
    )
    if trap == nil then
        return
    end
    SetUnitMoveSpeed(trap["单位"], cfg["静止陷阱移动速度"])
    local _____63D0_793A_7D2F_8BA1_6BEB_79D2 = cfg["静止陷阱范围提示间隔毫秒"]
    local tickID
    tickID = addPeriodicCallback(
        cfg["静止陷阱Tick毫秒"],
        function()
            if not _____5355_4F4D_6709_6548(boss) or not trap["是否存活"](trap) then
                removePeriodicCallback(tickID)
                return
            end
            _____63D0_793A_7D2F_8BA1_6BEB_79D2 = _____63D0_793A_7D2F_8BA1_6BEB_79D2 + cfg["静止陷阱Tick毫秒"]
            if _____63D0_793A_7D2F_8BA1_6BEB_79D2 >= cfg["静止陷阱范围提示间隔毫秒"] then
                _____63D0_793A_7D2F_8BA1_6BEB_79D2 = 0
                _____521B_5EFA_6280_80FD_63D0_793A_5708({["类型"] = "圆形", ["锚点单位"] = trap["单位"], ["半径"] = cfg["静止陷阱触发半径"], ["持续时间"] = cfg["静止陷阱范围提示间隔毫秒"] / 1000 + 0.1})
            end
            local nearest = _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4Ex(boss, trap["单位"])
            if _____5355_4F4D_6709_6548(nearest) then
                local distance2 = _____8DDD_79BB_5E73_65B9XY(
                    GetUnitX(trap["单位"]),
                    GetUnitY(trap["单位"]),
                    GetUnitX(nearest),
                    GetUnitY(nearest)
                )
                SetUnitMoveSpeed(trap["单位"], distance2 >= cfg["静止陷阱远距加速阈值"] * cfg["静止陷阱远距加速阈值"] and cfg["静止陷阱远距移动速度"] or cfg["静止陷阱移动速度"])
                IssuePointOrder(
                    trap["单位"],
                    "move",
                    GetUnitX(nearest),
                    GetUnitY(nearest)
                )
            end
            local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
            local radius2 = cfg["静止陷阱触发半径"] * cfg["静止陷阱触发半径"]
            do
                local i = 0
                while i < #heroes do
                    do
                        local hero = heroes[i + 1]
                        if not _____5355_4F4D_6709_6548(hero) then
                            goto __continue27
                        end
                        if _____8DDD_79BB_5E73_65B9XY(
                            GetUnitX(trap["单位"]),
                            GetUnitY(trap["单位"]),
                            GetUnitX(hero),
                            GetUnitY(hero)
                        ) > radius2 then
                            goto __continue27
                        end
                        SetUnitAnimationByIndex(trap["单位"], 3)
                        _____5BF9_6240_6709_73A9_5BB6_65BD_52A0_9759_6B62_7729_6655(boss)
                        trap["销毁"](trap)
                        removePeriodicCallback(tickID)
                        return
                    end
                    ::__continue27::
                    i = i + 1
                end
            end
        end
    )
    local ____self_13 = context["清理"]
    ____self_13["登记周期回调"](____self_13, "树魔首领-静止陷阱Tick", tickID)
end
function _____521B_5EFA_751F_547D_9677_9631(context)
    local boss = context["Boss单位"]
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔图腾"]
    local trap = _____521B_5EFA_56FE_817E_5355_4F4D(
        context,
        "树魔首领-生命陷阱",
        cfg["生命陷阱模型路径"],
        GetUnitState(boss, UNIT_STATE_MAX_LIFE) * cfg["生命陷阱生命Boss最大生命比例"],
        cfg["生命陷阱持续秒"]
    )
    if trap == nil then
        return
    end
    local healReduce = cfg["生命陷阱治疗降低基础比例"] + cfg["生命陷阱治疗降低每难度追加比例"] * _____53D6_96BE_5EA6()
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "渐变圆形",
        ["锚点单位"] = trap["单位"],
        ["半径"] = cfg["生命陷阱影响半径"],
        ["持续时间"] = cfg["生命陷阱持续秒"],
        ["来源单位"] = boss
    })
    local tickID
    tickID = addPeriodicCallback(
        cfg["生命陷阱Tick秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or not trap["是否存活"](trap) then
                removePeriodicCallback(tickID)
                return
            end
            local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
            do
                local i = 0
                while i < #heroes do
                    do
                        local hero = heroes[i + 1]
                        if not _____5355_4F4D_6709_6548(hero) then
                            goto __continue35
                        end
                        _____9020_6210AOE_6280_80FD_4F24_5BB3({
                            ["来源"] = boss,
                            ["目标"] = hero,
                            ["伤害"] = GetUnitState(hero, UNIT_STATE_MAX_LIFE) * cfg["生命陷阱伤害目标最大生命比例"],
                            attack = false,
                            ranged = false,
                            attackType = ATTACK_TYPE_NORMAL,
                            ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
                            weaponType = WEAPON_TYPE_WHOKNOWS,
                            ["来源类型"] = "Boss技能"
                        })
                        registerManualBuff(
                            hero,
                            _____6811_9B54_9996_9886BuffID["治疗枯竭"],
                            cfg["生命陷阱Tick秒"] + 0.4,
                            healReduce,
                            {sourceName = "树魔首领-生命陷阱"}
                        )
                    end
                    ::__continue35::
                    i = i + 1
                end
            end
        end
    )
    local ____self_14 = context["清理"]
    ____self_14["登记周期回调"](____self_14, "树魔首领-生命陷阱Tick", tickID)
end
function _____7206_70B8_9677_9631_9020_6210_4F24_5BB3(boss, x, y)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔图腾"]
    createTimedEffect(
        cfg["爆炸陷阱爆炸特效路径"],
        x,
        y,
        0,
        cfg["爆炸陷阱爆炸特效持续秒"]
    )
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue39
                end
                local damage = GetUnitState(hero, UNIT_STATE_LIFE) * cfg["爆炸陷阱当前生命伤害比例"] + cfg["爆炸陷阱每难度固定伤害"] * _____53D6_96BE_5EA6()
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = hero,
                    ["伤害"] = damage,
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能"
                })
            end
            ::__continue39::
            i = i + 1
        end
    end
end
function _____8C03_5EA6_7206_70B8_9677_9631_7206_70B8(context, x, y)
    local boss = context["Boss单位"]
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔图腾"]
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "渐变圆形",
        X = x,
        Y = y,
        ["半径"] = cfg["爆炸陷阱爆炸提示半径"],
        ["持续时间"] = cfg["爆炸陷阱被摧毁爆炸延迟秒"],
        ["来源单位"] = boss
    })
    local delayedID = addDelayedCallback(
        cfg["爆炸陷阱被摧毁爆炸延迟秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) then
                return
            end
            _____7206_70B8_9677_9631_9020_6210_4F24_5BB3(boss, x, y)
        end
    )
    local ____self_15 = context["清理"]
    ____self_15["登记延迟回调"](____self_15, "树魔首领-爆炸陷阱爆炸", delayedID)
end
function _____521B_5EFA_7206_70B8_9677_9631(context)
    local boss = context["Boss单位"]
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔图腾"]
    local naturalEnd = false
    local exploded = false
    local trap = _____521B_5EFA_56FE_817E_5355_4F4D(
        context,
        "树魔首领-爆炸陷阱",
        cfg["爆炸陷阱模型路径"],
        GetUnitState(boss, UNIT_STATE_MAX_LIFE) * cfg["爆炸陷阱生命Boss最大生命比例"],
        cfg["爆炸陷阱持续秒"],
        function(unit)
            if naturalEnd or exploded then
                return
            end
            exploded = true
            _____8C03_5EA6_7206_70B8_9677_9631_7206_70B8(
                context,
                GetUnitX(unit),
                GetUnitY(unit)
            )
        end
    )
    if trap == nil then
        return
    end
    local naturalEndID = addDelayedCallback(
        cfg["爆炸陷阱持续秒"] * 1000,
        function()
            naturalEnd = true
            if trap["是否存活"](trap) then
                trap["销毁"](trap)
            end
        end
    )
    local ____self_16 = context["清理"]
    ____self_16["登记延迟回调"](____self_16, "树魔首领-爆炸陷阱自然结束", naturalEndID)
    local interval = math.max(
        1.2,
        cfg["爆炸陷阱传送基础间隔秒"] - cfg["爆炸陷阱传送每难度减少秒"] * _____53D6_96BE_5EA6()
    )
    local teleportID
    teleportID = addPeriodicCallback(
        interval * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or not trap["是否存活"](trap) or naturalEnd then
                removePeriodicCallback(teleportID)
                return
            end
            local angle = GetRandomReal(0, 360)
            local distance = GetRandomReal(cfg["爆炸陷阱传送最近距离"], cfg["爆炸陷阱传送最远距离"])
            local x = GetUnitX(boss) + CosBJ(angle) * distance
            local y = GetUnitY(boss) + SinBJ(angle) * distance
            SetUnitPosition(trap["单位"], x, y)
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "圆形",
                X = x,
                Y = y,
                ["半径"] = cfg["图腾落点提示半径"],
                ["持续时间"] = 0.8,
                ["来源单位"] = boss
            })
        end
    )
    local ____self_17 = context["清理"]
    ____self_17["登记周期回调"](____self_17, "树魔首领-爆炸陷阱传送", teleportID)
end
function _____521B_5EFA_6811_9B54_56FE_817E_5206_652F(context)
    local branch = _____9009_62E9_56FE_817E_5206_652F(context)
    if branch == 1 then
        _____521B_5EFA_9759_6B62_9677_9631(context)
    elseif branch == 2 then
        _____521B_5EFA_751F_547D_9677_9631(context)
    else
        _____521B_5EFA_7206_70B8_9677_9631(context)
    end
end
____exports["释放树魔首领树魔图腾"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔图腾"]
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标X"] = GetUnitX(boss),
        ["目标Y"] = GetUnitY(boss),
        ["硬直秒"] = cfg["施法硬直秒"],
        ["动画编号"] = cfg["动画编号"],
        ["动画速度"] = cfg["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = cfg["施法硬直秒"],
            ["颜色ID"] = cfg["吟唱条颜色ID"],
            ["标题文本"] = cfg["吟唱条标题文本"],
            ["提示文本"] = cfg["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_6811_9B54_9996_9886_53F0_8BCD(boss, "树魔图腾")
        end,
        ["on生效"] = function()
            _____521B_5EFA_6811_9B54_56FE_817E_5206_652F(context)
        end
    })
end
function ____on_6811_9B54_9996_9886_6811_9B54_56FE_817E_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6811_9B54_56FE_817E_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放树魔首领树魔图腾"](context)
end
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local jass = require("jass.common")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitState = jass.GetUnitState
GetOwningPlayer = jass.GetOwningPlayer
IsUnitType = jass.IsUnitType
IssuePointOrder = jass.IssuePointOrder
SetUnitMoveSpeed = jass.SetUnitMoveSpeed
SetUnitPosition = jass.SetUnitPosition
SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
GetRandomInt = jass.GetRandomInt
GetRandomReal = jass.GetRandomReal
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
_____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_1["启动基础施法时间线"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
_____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
_____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_3["创建可攻击机制单位"]
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_4["获取Boss技能敌对英雄列表"]
_____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4Ex = ____require_result_4["获取Boss技能最近敌对英雄Ex"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_5.addDelayedCallback
addPeriodicCallback = ____require_result_5.addPeriodicCallback
removePeriodicCallback = ____require_result_5.removePeriodicCallback
getGameDifficulty = ____require_result_5.getGameDifficulty
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_6.registerManualBuff
local getBuffRuntime = ____require_result_6.getBuffRuntime
local ____require_result_7 = require("系统.05．Buff系统.03．Buff表.01．Boss.05．树魔首领")
_____6811_9B54_9996_9886BuffID = ____require_result_7["树魔首领BuffID"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_8["施加快速控制Buff"]
local ____require_result_9 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local registerHealCallback = ____require_result_9.registerHealCallback
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
createTimedEffect = ____require_result_10.createTimedEffect
local ____require_result_11 = require("lib.扩展函数.BJ函数.12．数学函数")
CosBJ = ____require_result_11.CosBJ
SinBJ = ____require_result_11.SinBJ
_____5FEB_901F_63A7_5236__51FB_6655 = 0
_____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID = stringToFourCC(_____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____6811_9B54_56FE_817E_6280_80FDID = stringToFourCC(_____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔图腾"]["技能槽位"])
_____730E_5934_8005_5355_4F4D_7C7B_578BID = stringToFourCC(_____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["召唤物ID"]["猎头者"])
_____5DEB_533B_5355_4F4D_7C7B_578BID = stringToFourCC(_____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["召唤物ID"]["巫医"])
_____6295_63B7_8005_5355_4F4D_7C7B_578BID = stringToFourCC(_____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["召唤物ID"]["投掷者"])
local _____6811_9B54_56FE_817E_5DF2_6CE8_518C = false
local _____6811_9B54_56FE_817E_6CBB_7597_56DE_8C03_5DF2_6CE8_518C = false
local function _____6CBB_7597_67AF_7AED_6CBB_7597_4FEE_6B63(_source, target, amount, _isItemHeal)
    local runtime = getBuffRuntime(target, _____6811_9B54_9996_9886BuffID["治疗枯竭"])
    if runtime == nil then
        return amount
    end
    local reduce = runtime.effect > 0 and runtime.effect or 0
    return amount * (1 - reduce)
end
____exports["注册树魔首领树魔图腾"] = function()
    if not _____6811_9B54_56FE_817E_6CBB_7597_56DE_8C03_5DF2_6CE8_518C then
        _____6811_9B54_56FE_817E_6CBB_7597_56DE_8C03_5DF2_6CE8_518C = true
        registerHealCallback(_____6CBB_7597_67AF_7AED_6CBB_7597_4FEE_6B63)
    end
    if _____6811_9B54_56FE_817E_5DF2_6CE8_518C then
        return
    end
    _____6811_9B54_56FE_817E_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "树魔首领-树魔图腾",
        ["单位类型ID"] = _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____6811_9B54_56FE_817E_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_6811_9B54_9996_9886_6811_9B54_56FE_817E_751F_6548(boss, _____6811_9B54_56FE_817E_6280_80FDID)
        end
    })
end
return ____exports
