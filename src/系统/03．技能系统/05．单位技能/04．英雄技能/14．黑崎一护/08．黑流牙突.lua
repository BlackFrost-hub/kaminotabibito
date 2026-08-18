--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.00．配置")
local _____9ED1_5D0E_4E00_62A4_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["黑崎一护技能配置"]
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.01．状态表")
local _____83B7_53D6_9ED1_5D0E_4E00_62A4_72B6_6001 = ____01_FF0E_72B6_6001_8868["获取黑崎一护状态"]
local _____9ED1_5D0E_4E00_62A4_662F_5426_534D_89E3 = ____01_FF0E_72B6_6001_8868["黑崎一护是否卍解"]
local _____89E3_9664_9ED1_5D0E_4E00_62A4A_952E_6B66_88C5 = ____01_FF0E_72B6_6001_8868["解除黑崎一护A键武装"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.14．A键事件中心")
local _____6CE8_518CA_952E_76D1_542C = ____require_result_1["注册A键监听"]
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心")
local registerTargetOrderListener = ____require_result_2.registerTargetOrderListener
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_3["造成单体技能伤害"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_4["读取单位攻击力"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_5["创建点特效"]
local _____9500_6BC1_70B9_7279_6548 = ____require_result_5["销毁点特效"]
local ____require_result_6 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_6.registerDeathListener
local ____require_result_7 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_7.IsUnitAliveBJ
local SelectUnitForPlayerSingle = ____require_result_7.SelectUnitForPlayerSingle
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetHeroLevel = jass.GetHeroLevel
local IsUnitEnemy = jass.IsUnitEnemy
local ShowUnit = jass.ShowUnit
local SetUnitPosition = jass.SetUnitPosition
local SetUnitFacing = jass.SetUnitFacing
local Atan2 = jass.Atan2
local Cos = jass.Cos
local Sin = jass.Sin
local SquareRoot = jass.SquareRoot
local OrderId = jass.OrderId
local bj_RADTODEG = jass.bj_RADTODEG
local bj_DEGTORAD = jass.bj_DEGTORAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local DzSetEffectPos = japi.DzSetEffectPos
local _____914D_7F6E = _____9ED1_5D0E_4E00_62A4_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local _____653B_51FB_6307_4EE4ID = OrderId("attack")
local _____5DF2_6CE8_518CA_952E_7684_73A9_5BB6 = {}
local _____73A9_5BB6_9ED1_5D0E_4E00_62A4_8868 = {}
local function ____A_952E_56DE_8C03(event)
    if event == nil or event.player == nil or event.player == 0 then
        return
    end
    local playerId = GetPlayerId(event.player)
    local hero = _____73A9_5BB6_9ED1_5D0E_4E00_62A4_8868[playerId]
    if hero == nil or hero == 0 then
        return
    end
    if not _____9ED1_5D0E_4E00_62A4_662F_5426_534D_89E3(hero) then
        return
    end
    local record = _____83B7_53D6_9ED1_5D0E_4E00_62A4_72B6_6001(hero)
    if record ~= nil then
        record["A键已武装"] = true
    end
end
--- R 卍解启动时调用：按玩家注册一次 A 键监听，重复注册被中心忽略。
____exports["注册玩家黑流牙突A键"] = function(caster)
    if caster == nil or caster == 0 then
        return
    end
    local playerId = GetPlayerId(GetOwningPlayer(caster))
    _____73A9_5BB6_9ED1_5D0E_4E00_62A4_8868[playerId] = caster
    if _____5DF2_6CE8_518CA_952E_7684_73A9_5BB6[playerId] == true then
        return
    end
    _____5DF2_6CE8_518CA_952E_7684_73A9_5BB6[playerId] = true
    _____6CE8_518CA_952E_76D1_542C(playerId, ____A_952E_56DE_8C03)
end
local _____7A81_8FDB_4E0A_4E0B_6587_8868 = {}
local _____76EE_6807_72EC_7ACB_51B7_5374_8868 = {}
local function _____6062_590D_65BD_6CD5_8005(ctx)
    local caster = ctx["施法者"]
    if caster ~= nil and caster ~= 0 then
        ShowUnit(caster, true)
        SelectUnitForPlayerSingle(caster, ctx["玩家"])
    end
    if ctx["特效"] ~= nil and ctx["特效"] ~= 0 then
        _____9500_6BC1_70B9_7279_6548(ctx["特效"])
    end
    ctx["特效"] = nil
    ctx["进行中"] = false
    if ctx["回调ID"] ~= 0 then
        removePeriodicCallback(ctx["回调ID"])
    end
    ctx["回调ID"] = 0
end
local function _____6E05_9664_9ED1_6D41_7259_7A81_6807_8BB0(variable)
    local cooldown = variable
    if cooldown == nil or cooldown["目标ID"] == nil then
        return
    end
    _____76EE_6807_72EC_7ACB_51B7_5374_8868[cooldown["目标ID"]] = false
end
local function _____7ED3_7B97_9ED1_6D41_7259_7A81_547D_4E2D(ctx)
    local caster = ctx["施法者"]
    local target = ctx["目标"]
    local tx = GetUnitX(target)
    local ty = GetUnitY(target)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E["黑流牙突"]["命中特效"]["模型"],
        X = tx,
        Y = ty,
        Z = _____914D_7F6E["黑流牙突"]["命中特效"]["高度"],
        ["面向角度"] = _____914D_7F6E["黑流牙突"]["命中特效"]["面向角度"],
        ["缩放"] = _____914D_7F6E["黑流牙突"]["命中特效"]["缩放"],
        ["持续秒"] = _____914D_7F6E["黑流牙突"]["命中特效"]["持续秒"]
    })
    local _____4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * (_____914D_7F6E["黑流牙突"]["基础伤害倍率"] + _____914D_7F6E["黑流牙突"]["每级伤害加成"] * GetHeroLevel(caster))
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标"] = target,
        ["伤害"] = _____4F24_5BB3,
        ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
        attack = true,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["标签"] = "黑崎一护-黑流牙突"
    })
    local _____76EE_6807ID = GetHandleId(target)
    _____76EE_6807_72EC_7ACB_51B7_5374_8868[_____76EE_6807ID] = true
    local _____51B7_5374_4E0A_4E0B_6587 = {["目标"] = target, ["目标ID"] = _____76EE_6807ID}
    addDelayedCallback(
        math.floor(_____914D_7F6E["黑流牙突"]["标记持续秒"] * 1000 + 0.5),
        _____6E05_9664_9ED1_6D41_7259_7A81_6807_8BB0,
        _____51B7_5374_4E0A_4E0B_6587
    )
    _____6062_590D_65BD_6CD5_8005(ctx)
end
local function _____63A8_8FDB_9ED1_6D41_7259_7A81(variable)
    local ctx = variable
    if ctx == nil or ctx["进行中"] ~= true then
        return
    end
    local caster = ctx["施法者"]
    local target = ctx["目标"]
    if caster == nil or caster == 0 or not IsUnitAliveBJ(caster) then
        _____6062_590D_65BD_6CD5_8005(ctx)
        return
    end
    if target == nil or target == 0 or not IsUnitAliveBJ(target) then
        _____6062_590D_65BD_6CD5_8005(ctx)
        return
    end
    if ctx["Tick数"] >= _____914D_7F6E["黑流牙突"]["最大推进次数"] then
        _____6062_590D_65BD_6CD5_8005(ctx)
        return
    end
    ctx["Tick数"] = ctx["Tick数"] + 1
    local cx = GetUnitX(caster)
    local cy = GetUnitY(caster)
    local tx = GetUnitX(target)
    local ty = GetUnitY(target)
    local _____89D2_5EA6 = Atan2(ty - cy, tx - cx) * bj_RADTODEG
    local rad = _____89D2_5EA6 * bj_DEGTORAD
    local nx = cx + Cos(rad) * _____914D_7F6E["黑流牙突"]["每Tick距离"]
    local ny = cy + Sin(rad) * _____914D_7F6E["黑流牙突"]["每Tick距离"]
    SetUnitPosition(caster, nx, ny)
    SetUnitFacing(caster, _____89D2_5EA6)
    if ctx["特效"] ~= nil and ctx["特效"] ~= 0 then
        DzSetEffectPos(ctx["特效"], nx, ny, _____914D_7F6E["黑流牙突"]["特效高度"])
    end
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E["黑流牙突"]["推进特效"]["模型"],
        X = nx,
        Y = ny,
        Z = 0,
        ["持续秒"] = _____914D_7F6E["黑流牙突"]["推进特效"]["持续秒"]
    })
    local dx = nx - tx
    local dy = ny - ty
    if SquareRoot(dx * dx + dy * dy) <= _____914D_7F6E["黑流牙突"]["命中半径码"] then
        _____7ED3_7B97_9ED1_6D41_7259_7A81_547D_4E2D(ctx)
    end
end
local function _____53D1_8D77_9ED1_6D41_7259_7A81(caster, target)
    local cx = GetUnitX(caster)
    local cy = GetUnitY(caster)
    local tx = GetUnitX(target)
    local ty = GetUnitY(target)
    local _____89D2_5EA6 = Atan2(ty - cy, tx - cx) * bj_RADTODEG
    local rad = _____89D2_5EA6 * bj_DEGTORAD
    ShowUnit(caster, false)
    local bx = cx - Cos(rad) * _____914D_7F6E["黑流牙突"]["出生偏移码"]
    local by = cy - Sin(rad) * _____914D_7F6E["黑流牙突"]["出生偏移码"]
    local effect = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E["黑流牙突"]["特效模型"],
        X = bx,
        Y = by,
        Z = _____914D_7F6E["黑流牙突"]["特效高度"],
        ["面向角度"] = _____89D2_5EA6,
        ["缩放"] = _____914D_7F6E["黑流牙突"]["特效缩放"],
        ["持续秒"] = 2
    })
    local ctx = {
        ["施法者"] = caster,
        ["玩家"] = GetOwningPlayer(caster),
        ["目标"] = target,
        ["特效"] = effect,
        ["Tick数"] = 0,
        ["回调ID"] = 0,
        ["进行中"] = true
    }
    _____7A81_8FDB_4E0A_4E0B_6587_8868[GetHandleId(caster)] = ctx
    ctx["回调ID"] = addPeriodicCallback(
        math.floor(_____914D_7F6E["黑流牙突"]["推进间隔秒"] * 1000 + 0.5),
        _____63A8_8FDB_9ED1_6D41_7259_7A81,
        ctx
    )
end
local function _____76EE_6807_6307_4EE4_56DE_8C03(unit, orderId, targetUnit, _targetItem, _targetDestructable)
    if unit == nil or unit == 0 then
        return
    end
    if GetUnitTypeId(unit) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    if orderId ~= _____653B_51FB_6307_4EE4ID then
        return
    end
    local record = _____83B7_53D6_9ED1_5D0E_4E00_62A4_72B6_6001(unit)
    if record == nil or record["A键已武装"] ~= true then
        return
    end
    _____89E3_9664_9ED1_5D0E_4E00_62A4A_952E_6B66_88C5(unit)
    if record["卍解"] ~= true then
        return
    end
    if targetUnit == nil or targetUnit == 0 or not IsUnitAliveBJ(targetUnit) then
        return
    end
    if not IsUnitEnemy(
        targetUnit,
        GetOwningPlayer(unit)
    ) then
        return
    end
    local _____76EE_6807ID = GetHandleId(targetUnit)
    local _____76EE_6807_51B7_5374_4E2D = _____76EE_6807_72EC_7ACB_51B7_5374_8868[_____76EE_6807ID] == true
    if _____76EE_6807_51B7_5374_4E2D then
        return
    end
    local dx = GetUnitX(targetUnit) - GetUnitX(unit)
    local dy = GetUnitY(targetUnit) - GetUnitY(unit)
    local _____8DDD_79BB = SquareRoot(dx * dx + dy * dy)
    if _____8DDD_79BB < _____914D_7F6E["黑流牙突"]["最小距离码"] or _____8DDD_79BB > _____914D_7F6E["黑流牙突"]["最大距离码"] then
        return
    end
    local _____65E7_4E0A_4E0B_6587 = _____7A81_8FDB_4E0A_4E0B_6587_8868[GetHandleId(unit)]
    if _____65E7_4E0A_4E0B_6587 ~= nil and _____65E7_4E0A_4E0B_6587["进行中"] == true then
        return
    end
    _____53D1_8D77_9ED1_6D41_7259_7A81(unit, targetUnit)
end
local _____5DF2_521D_59CB_5316 = false
local function _____9ED1_6D41_7259_7A81_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    if GetUnitTypeId(dyingUnit) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    local ctx = _____7A81_8FDB_4E0A_4E0B_6587_8868[GetHandleId(dyingUnit)]
    if ctx ~= nil and ctx["进行中"] == true then
        _____6062_590D_65BD_6CD5_8005(ctx)
    end
end
____exports["注册黑流牙突"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    registerTargetOrderListener(_____76EE_6807_6307_4EE4_56DE_8C03)
    registerDeathListener(_____9ED1_6D41_7259_7A81_6B7B_4EA1_6E05_7406)
end
____exports["注册黑流牙突"]()
return ____exports
