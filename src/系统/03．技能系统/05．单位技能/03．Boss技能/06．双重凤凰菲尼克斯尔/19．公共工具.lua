--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local SquareRoot, isValidUnit, _____83B7_53D6_5355_4F4DBuff_5C42_6570
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.00．配置")
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲尼克斯尔单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.02．数值与表现配置")
local _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔数值与表现配置"]
____exports["单位有效"] = function(unit)
    return unit ~= nil and unit ~= 0 and isValidUnit(unit)
end
____exports["两点距离"] = function(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return SquareRoot(dx * dx + dy * dy)
end
____exports["取菲尼克斯尔技能强度倍率"] = function(source)
    if not ____exports["单位有效"](source) then
        return 1
    end
    local layers = _____83B7_53D6_5355_4F4DBuff_5C42_6570(source, _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E.BuffID["导管破封"])
    if layers <= 0 then
        return 1
    end
    return 1 + layers * _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["机制"]["每根导管技能强度提高"]
end
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_0["造成技能伤害"]
local _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_0["创建独立技能伤害实例"]
local Player = jass.Player
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local Cos = jass.Cos
local Sin = jass.Sin
local Atan2 = jass.Atan2
SquareRoot = jass.SquareRoot
local R2I = jass.R2I
local GetRandomInt = jass.GetRandomInt
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD
local DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local DzSetUnitModel = japi.DzSetUnitModel
local DzSetUnitName = japi.DzSetUnitName
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_2.getRegisteredPlayerHero
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
isValidUnit = ____require_result_3.isValidUnit
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_4.getEnemyUnitsInRange
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_5["读取单位攻击力"]
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_6.registerManualBuff
local getBuffRuntime = ____require_result_6.getBuffRuntime
_____83B7_53D6_5355_4F4DBuff_5C42_6570 = ____require_result_6["获取单位Buff层数"]
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_6["移除单位指定Buff"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_7["创建技能提示圈"]
local ____require_result_8 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_8["显示常规技能吟唱条"]
local _____663E_793A_5927_62DB_541F_5531_6761 = ____require_result_8["显示大招吟唱条"]
local _____663E_793A_573A_5730_5E38_9A7BAOE_541F_5531_6761 = ____require_result_8["显示场地常驻AOE吟唱条"]
local _____663E_793A_81F4_547D_60E9_7F5A_541F_5531_6761 = ____require_result_8["显示致命惩罚吟唱条"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_9["开始硬直"]
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_9["施加快速减速Buff"]
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_9["施加快速控制Buff"]
local ____require_result_10 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.index")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_10["创建可攻击机制单位"]
local DEG_TO_RAD = 0.017453292519943295
local RAD_TO_DEG = 57.29577951308232
local _____5FEB_901F_63A7_5236__51FB_6655 = 1
____exports["创建菲尼克斯尔独立伤害上下文"] = function(_____6807_7B7E, _____6301_7EED_65F6_95F4_79D2)
    return {
        ["技能实例ID"] = _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["来源类型"] = "Boss技能", ["标签"] = _____6807_7B7E, ["持续时间秒"] = _____6301_7EED_65F6_95F4_79D2}),
        ["标签"] = _____6807_7B7E
    }
end
function ____exports.stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
____exports["单位存活"] = function(unit)
    return ____exports["单位有效"](unit) and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
____exports["取单位X"] = function(unit)
    return GetUnitX(unit)
end
____exports["取单位Y"] = function(unit)
    return GetUnitY(unit)
end
____exports["取最大生命"] = function(unit)
    return GetUnitState(unit, UNIT_STATE_MAX_LIFE)
end
____exports["取当前生命"] = function(unit)
    return GetUnitState(unit, UNIT_STATE_LIFE)
end
____exports["设置当前生命"] = function(unit, value)
    SetUnitState(unit, UNIT_STATE_LIFE, value)
end
____exports["取攻击力"] = function(unit)
    return _____8BFB_53D6_5355_4F4D_653B_51FB_529B(unit)
end
____exports["取菲尼克斯尔玩家英雄列表"] = function()
    local result = {}
    do
        local i = 0
        while i < 12 do
            local hero = getRegisteredPlayerHero(Player(i))
            if ____exports["单位存活"](hero) then
                result[#result + 1] = hero
            end
            i = i + 1
        end
    end
    return result
end
____exports["取随机玩家英雄"] = function()
    local heroes = ____exports["取菲尼克斯尔玩家英雄列表"]()
    if #heroes <= 0 then
        return nil
    end
    return heroes[GetRandomInt(1, #heroes)]
end
____exports["取最近玩家英雄"] = function(x, y)
    local heroes = ____exports["取菲尼克斯尔玩家英雄列表"]()
    local best = nil
    local bestDist = 999999999
    do
        local i = 0
        while i < #heroes do
            local hero = heroes[i + 1]
            local d = ____exports["两点距离"](
                x,
                y,
                GetUnitX(hero),
                GetUnitY(hero)
            )
            if d < bestDist then
                best = hero
                bestDist = d
            end
            i = i + 1
        end
    end
    return best
end
____exports["取目标或随机玩家"] = function(boss, target)
    if ____exports["单位存活"](target) then
        return target
    end
    local nearest = ____exports["取最近玩家英雄"](
        GetUnitX(boss),
        GetUnitY(boss)
    )
    local _____5355_4F4D_5B58_6D3B_result_11
    if ____exports["单位存活"](nearest) then
        _____5355_4F4D_5B58_6D3B_result_11 = nearest
    else
        _____5355_4F4D_5B58_6D3B_result_11 = ____exports["取随机玩家英雄"]()
    end
    return _____5355_4F4D_5B58_6D3B_result_11
end
____exports["面向单位"] = function(source, target)
    if not ____exports["单位有效"](source) or not ____exports["单位有效"](target) then
        return
    end
    local angle = Atan2(
        GetUnitY(target) - GetUnitY(source),
        GetUnitX(target) - GetUnitX(source)
    ) * RAD_TO_DEG
    SetUnitFacing(source, angle)
end
____exports["面向坐标"] = function(source, x, y)
    if not ____exports["单位有效"](source) then
        return
    end
    local angle = Atan2(
        y - GetUnitY(source),
        x - GetUnitX(source)
    ) * RAD_TO_DEG
    SetUnitFacing(source, angle)
end
____exports["设置单位动画"] = function(unit, index, speed)
    if speed == nil then
        speed = 1
    end
    if not ____exports["单位有效"](unit) then
        return
    end
    SetUnitAnimationByIndex(unit, index)
    SetUnitTimeScale(unit, speed)
end
____exports["延迟"] = function(ms, callback)
    return addDelayedCallback(ms, callback)
end
____exports["周期"] = function(ms, callback)
    return addPeriodicCallback(ms, callback)
end
____exports["停止周期"] = function(id)
    if id ~= 0 then
        removePeriodicCallback(id)
    end
end
____exports["播放点特效"] = function(model, x, y, lifeMs)
    if lifeMs == nil then
        lifeMs = 1200
    end
    if model == nil or model == "" then
        return nil
    end
    local effect = AddSpecialEffect(model, x, y)
    if effect ~= nil and effect ~= 0 and lifeMs > 0 then
        addDelayedCallback(
            lifeMs,
            function()
                DestroyEffect(effect)
            end
        )
    end
    return effect
end
____exports["播放单位特效"] = function(model, unit, attach, lifeMs)
    if attach == nil then
        attach = "origin"
    end
    if lifeMs == nil then
        lifeMs = 1200
    end
    if model == nil or model == "" or not ____exports["单位有效"](unit) then
        return nil
    end
    local effect = AddSpecialEffectTarget(model, unit, attach)
    if effect ~= nil and effect ~= 0 and lifeMs > 0 then
        addDelayedCallback(
            lifeMs,
            function()
                DestroyEffect(effect)
            end
        )
    end
    return effect
end
____exports["显示常规读条"] = function(_____79D2, _____989C_8272ID, _____6807_9898_6587_672C, _____63D0_793A_6587_672C)
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({["总时长"] = _____79D2, ["颜色ID"] = _____989C_8272ID, ["标题文本"] = _____6807_9898_6587_672C, ["提示文本"] = _____63D0_793A_6587_672C})
end
____exports["显示大招读条"] = function(_____79D2, _____989C_8272ID, _____6807_9898_6587_672C, _____63D0_793A_6587_672C)
    _____663E_793A_5927_62DB_541F_5531_6761({["总时长"] = _____79D2, ["颜色ID"] = _____989C_8272ID, ["标题文本"] = _____6807_9898_6587_672C, ["提示文本"] = _____63D0_793A_6587_672C})
end
____exports["显示场地读条"] = function(_____79D2, _____989C_8272ID, _____6807_9898_6587_672C, _____63D0_793A_6587_672C)
    _____663E_793A_573A_5730_5E38_9A7BAOE_541F_5531_6761({["总时长"] = _____79D2, ["颜色ID"] = _____989C_8272ID, ["标题文本"] = _____6807_9898_6587_672C, ["提示文本"] = _____63D0_793A_6587_672C})
end
____exports["显示致命读条"] = function(_____79D2, _____989C_8272ID, _____6807_9898_6587_672C, _____63D0_793A_6587_672C)
    _____663E_793A_81F4_547D_60E9_7F5A_541F_5531_6761({["总时长"] = _____79D2, ["颜色ID"] = _____989C_8272ID, ["标题文本"] = _____6807_9898_6587_672C, ["提示文本"] = _____63D0_793A_6587_672C})
end
____exports["创建预警圆"] = function(x, y, radius, duration)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "渐变圆形",
        X = x,
        Y = y,
        ["半径"] = radius,
        ["持续时间"] = duration
    })
end
____exports["创建安全圆"] = function(x, y, radius, duration)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "白色安全圆",
        X = x,
        Y = y,
        ["半径"] = radius,
        ["持续时间"] = duration
    })
end
____exports["创建预警扇形"] = function(source, radius, duration)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({["类型"] = "红色扇形", ["锚点单位"] = source, ["半径"] = radius, ["持续时间"] = duration})
end
____exports["极坐标X"] = function(x, distance, angleDeg)
    return x + distance * Cos(angleDeg * DEG_TO_RAD)
end
____exports["极坐标Y"] = function(y, distance, angleDeg)
    return y + distance * Sin(angleDeg * DEG_TO_RAD)
end
____exports["单位在扇形内"] = function(source, target, radius, angleDeg)
    if not ____exports["单位存活"](source) or not ____exports["单位存活"](target) then
        return false
    end
    local sx = GetUnitX(source)
    local sy = GetUnitY(source)
    local tx = GetUnitX(target)
    local ty = GetUnitY(target)
    local d = ____exports["两点距离"](sx, sy, tx, ty)
    if d > radius then
        return false
    end
    local facing = GetUnitFacing(source)
    local diff = Atan2(ty - sy, tx - sx) * RAD_TO_DEG - facing
    while diff > 180 do
        diff = diff - 360
    end
    while diff < -180 do
        diff = diff + 360
    end
    return diff <= angleDeg * 0.5 and diff >= -angleDeg * 0.5
end
____exports["线段到点距离"] = function(ax, ay, bx, by, px, py)
    local abx = bx - ax
    local aby = by - ay
    local apx = px - ax
    local apy = py - ay
    local abLenSq = abx * abx + aby * aby
    if abLenSq <= 0.01 then
        return ____exports["两点距离"](ax, ay, px, py)
    end
    local t = (apx * abx + apy * aby) / abLenSq
    if t < 0 then
        t = 0
    end
    if t > 1 then
        t = 1
    end
    return ____exports["两点距离"](ax + abx * t, ay + aby * t, px, py)
end
____exports["范围敌人"] = function(boss, x, y, radius)
    return getEnemyUnitsInRange(boss, x, y, radius)
end
local function _____9020_6210_83F2_5C3C_514B_65AF_5C14Boss_4F24_5BB3(source, target, amount, attackType, damageType, _____4F24_5BB3_5F62_6001, _____4E0A_4E0B_6587)
    if amount > 0 and ____exports["单位存活"](source) and ____exports["单位存活"](target) then
        _____9020_6210_6280_80FD_4F24_5BB3({
            ["技能ID"] = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["技能ID"],
            ["技能实例ID"] = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["技能实例ID"],
            ["标签"] = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["标签"],
            ["来源"] = source,
            ["目标"] = target,
            ["伤害"] = amount,
            ranged = true,
            attackType = attackType,
            ["伤害类型"] = damageType,
            weaponType = WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = "Boss技能",
            ["伤害形态"] = _____4F24_5BB3_5F62_6001
        })
    end
end
____exports["造成火焰伤害"] = function(source, target, amount, _____4F24_5BB3_5F62_6001, _____4E0A_4E0B_6587)
    if _____4F24_5BB3_5F62_6001 == nil then
        _____4F24_5BB3_5F62_6001 = "单体"
    end
    _____9020_6210_83F2_5C3C_514B_65AF_5C14Boss_4F24_5BB3(
        source,
        target,
        amount,
        ATTACK_TYPE_MAGIC,
        DAMAGE_TYPE_FIRE,
        _____4F24_5BB3_5F62_6001,
        _____4E0A_4E0B_6587
    )
end
____exports["造成冰霜伤害"] = function(source, target, amount, _____4F24_5BB3_5F62_6001, _____4E0A_4E0B_6587)
    if _____4F24_5BB3_5F62_6001 == nil then
        _____4F24_5BB3_5F62_6001 = "单体"
    end
    _____9020_6210_83F2_5C3C_514B_65AF_5C14Boss_4F24_5BB3(
        source,
        target,
        amount,
        ATTACK_TYPE_MAGIC,
        DAMAGE_TYPE_COLD,
        _____4F24_5BB3_5F62_6001,
        _____4E0A_4E0B_6587
    )
end
____exports["造成毒火伤害"] = function(source, target, amount, _____4F24_5BB3_5F62_6001, _____4E0A_4E0B_6587)
    if _____4F24_5BB3_5F62_6001 == nil then
        _____4F24_5BB3_5F62_6001 = "单体"
    end
    _____9020_6210_83F2_5C3C_514B_65AF_5C14Boss_4F24_5BB3(
        source,
        target,
        amount,
        ATTACK_TYPE_MAGIC,
        DAMAGE_TYPE_POISON,
        _____4F24_5BB3_5F62_6001,
        _____4E0A_4E0B_6587
    )
end
____exports["造成暗火伤害"] = function(source, target, amount, _____4F24_5BB3_5F62_6001, _____4E0A_4E0B_6587)
    if _____4F24_5BB3_5F62_6001 == nil then
        _____4F24_5BB3_5F62_6001 = "单体"
    end
    _____9020_6210_83F2_5C3C_514B_65AF_5C14Boss_4F24_5BB3(
        source,
        target,
        amount,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_SHADOW_STRIKE,
        _____4F24_5BB3_5F62_6001,
        _____4E0A_4E0B_6587
    )
end
____exports["造成普通伤害"] = function(source, target, amount, _____4F24_5BB3_5F62_6001, _____4E0A_4E0B_6587)
    if _____4F24_5BB3_5F62_6001 == nil then
        _____4F24_5BB3_5F62_6001 = "单体"
    end
    _____9020_6210_83F2_5C3C_514B_65AF_5C14Boss_4F24_5BB3(
        source,
        target,
        amount,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        _____4F24_5BB3_5F62_6001,
        _____4E0A_4E0B_6587
    )
end
____exports["计算攻击最大生命伤害"] = function(source, target, attackRate, maxLifeRate)
    return (____exports["取攻击力"](source) * attackRate + ____exports["取最大生命"](target) * maxLifeRate) * ____exports["取菲尼克斯尔技能强度倍率"](source)
end
____exports["计算攻击已损失伤害"] = function(source, target, attackRate, lostLifeRate)
    local lost = ____exports["取最大生命"](target) - ____exports["取当前生命"](target)
    return (____exports["取攻击力"](source) * attackRate + lost * lostLifeRate) * ____exports["取菲尼克斯尔技能强度倍率"](source)
end
____exports["开始施法硬直"] = function(unit, duration)
    _____5F00_59CB_786C_76F4(unit, duration)
end
____exports["施加减速"] = function(source, target, ratio, duration)
    _____65BD_52A0_5FEB_901F_51CF_901FBuff(
        source,
        target,
        ratio,
        ratio,
        duration
    )
end
____exports["施加短眩晕"] = function(source, target, duration)
    _____65BD_52A0_5FEB_901F_63A7_5236Buff(source, target, _____5FEB_901F_63A7_5236__51FB_6655, duration)
end
local function _____53D6_5143_7D20BuffID(_____5143_7D20)
    if _____5143_7D20 == "冰" then
        return _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E.BuffID["冷焰印记"]
    end
    if _____5143_7D20 == "毒" then
        return _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E.BuffID["毒火蚀痕"]
    end
    if _____5143_7D20 == "暗" then
        return _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E.BuffID["怨火烙印"]
    end
    return _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E.BuffID["凤凰火印"]
end
____exports["取元素层数"] = function(unit, _____5143_7D20)
    if not ____exports["单位有效"](unit) then
        return 0
    end
    return _____83B7_53D6_5355_4F4DBuff_5C42_6570(
        unit,
        _____53D6_5143_7D20BuffID(_____5143_7D20)
    )
end
____exports["添加元素层数"] = function(unit, _____5143_7D20, count, duration)
    if duration == nil then
        duration = 30
    end
    if not ____exports["单位有效"](unit) or count <= 0 then
        return 0
    end
    local buffID = _____53D6_5143_7D20BuffID(_____5143_7D20)
    local next = _____83B7_53D6_5355_4F4DBuff_5C42_6570(unit, buffID) + count
    if next > _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["机制"]["元素层数上限"] then
        next = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["机制"]["元素层数上限"]
    end
    registerManualBuff(
        unit,
        buffID,
        duration,
        next,
        {stack = next, sourceName = _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位名称"]}
    )
    return next
end
____exports["减少元素层数"] = function(unit, _____5143_7D20, count)
    if not ____exports["单位有效"](unit) or count <= 0 then
        return
    end
    local buffID = _____53D6_5143_7D20BuffID(_____5143_7D20)
    local current = _____83B7_53D6_5355_4F4DBuff_5C42_6570(unit, buffID)
    local next = current - count
    if next <= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, buffID)
        return
    end
    local runtime = getBuffRuntime(unit, buffID)
    local ____registerManualBuff_23 = registerManualBuff
    local ____unit_22 = unit
    local ____opt_result_20
    if runtime ~= nil then
        ____opt_result_20 = runtime.remaining
    end
    local ____opt_result_20_21 = ____opt_result_20
    if ____opt_result_20_21 == nil then
        ____opt_result_20_21 = 30
    end
    ____registerManualBuff_23(
        ____unit_22,
        buffID,
        ____opt_result_20_21,
        next,
        {stack = next, sourceName = _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位名称"]}
    )
end
____exports["取最高元素"] = function(unit)
    local _____706B = ____exports["取元素层数"](unit, "火")
    local _____51B0 = ____exports["取元素层数"](unit, "冰")
    local _____6BD2 = ____exports["取元素层数"](unit, "毒")
    local _____6697 = ____exports["取元素层数"](unit, "暗")
    local _____5143_7D20 = "火"
    local _____5C42_6570 = _____706B
    if _____51B0 > _____5C42_6570 then
        _____5143_7D20 = "冰"
        _____5C42_6570 = _____51B0
    end
    if _____6BD2 > _____5C42_6570 then
        _____5143_7D20 = "毒"
        _____5C42_6570 = _____6BD2
    end
    if _____6697 > _____5C42_6570 then
        _____5143_7D20 = "暗"
        _____5C42_6570 = _____6697
    end
    return {["元素"] = _____5143_7D20, ["层数"] = _____5C42_6570}
end
____exports["创建菲尼克斯尔机制单位"] = function(context, id, name, model, x, y, maxLife, ____on_6B7B_4EA1)
    local inst = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = name,
        ["主人单位"] = context.Boss,
        ["所属玩家"] = GetOwningPlayer(context.Boss),
        ["单位类型"] = id,
        ["模型路径"] = model,
        X = x,
        Y = y,
        ["朝向"] = 270,
        ["最大生命"] = maxLife,
        ["生命值受小怪倍率"] = false,
        ["飞行高度"] = 80,
        ["缩放"] = 1,
        ["on死亡"] = ____on_6B7B_4EA1
    })
    if inst == nil then
        return nil
    end
    if type(DzSetUnitName) == "function" then
        DzSetUnitName(inst["单位"], name)
    end
    return inst["单位"]
end
____exports["设置单位模型"] = function(unit, model)
    if type(DzSetUnitModel) == "function" and ____exports["单位有效"](unit) then
        DzSetUnitModel(unit, model)
    end
end
____exports["移动单位到"] = function(unit, x, y)
    if ____exports["单位有效"](unit) then
        SetUnitPosition(unit, x, y)
    end
end
____exports["整数"] = function(value)
    return R2I(value)
end
return ____exports
