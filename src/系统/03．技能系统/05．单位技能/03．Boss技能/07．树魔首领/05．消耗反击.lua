local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local stringToFourCC, _____5355_4F4D_6709_6548, _____6E05_9664_6D88_8017_53CD_51FB_72B6_6001, _____64AD_653E_9632_5FA1_59FF_6001_7279_6548, ____on_6811_9B54_9996_9886_6D88_8017_53CD_51FB_751F_6548, GetUnitTypeId, GetUnitX, GetUnitY, GetHandleId, SetUnitAnimationByIndex, SetUnitTimeScale, IsUnitType, UNIT_TYPE_DEAD, addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback, getServerTime, _____5F00_59CB_786C_76F4, createTimedEffect, _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID, _____6D88_8017_53CD_51FB_6280_80FDID, _____6D88_8017_53CD_51FB_72B6_6001_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.00．配置")
local _____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["树魔首领单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建树魔首领上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.02．数值与表现配置")
local _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔首领数值与表现配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.08．台词播放")
local _____64AD_653E_6811_9B54_9996_9886_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放树魔首领台词"]
local ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.08．方位判定工具")
local _____4E24_70B9_65B9_5411_89D2 = ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177["两点方向角"]
local _____5355_4F4D_662F_5426_5728_6765_6E90_6B63_9762_6247_533A = ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177["单位是否在来源正面扇区"]
local _____5355_4F4D_662F_5426_5728_6765_6E90_80CC_540E_6247_533A = ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177["单位是否在来源背后扇区"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
function _____6E05_9664_6D88_8017_53CD_51FB_72B6_6001(boss)
    local hid = GetHandleId(boss) or 0
    local state = _____6D88_8017_53CD_51FB_72B6_6001_8868[hid]
    if state == nil then
        return
    end
    if state["动画回调ID"] ~= 0 then
        removePeriodicCallback(state["动画回调ID"])
    end
    if state["特效回调ID"] ~= 0 then
        removePeriodicCallback(state["特效回调ID"])
    end
    if state["结束回调ID"] ~= 0 then
        removeDelayedCallback(state["结束回调ID"])
    end
    __TS__Delete(_____6D88_8017_53CD_51FB_72B6_6001_8868, hid)
    if _____5355_4F4D_6709_6548(boss) then
        SetUnitTimeScale(boss, 1)
    end
end
function _____64AD_653E_9632_5FA1_59FF_6001_7279_6548(boss)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    createTimedEffect(
        cfg["防御特效路径"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        cfg["防御特效持续秒"]
    )
end
____exports["释放树魔首领消耗反击"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    local hid = GetHandleId(boss) or 0
    if hid == 0 then
        return
    end
    _____6E05_9664_6D88_8017_53CD_51FB_72B6_6001(boss)
    _____64AD_653E_6811_9B54_9996_9886_53F0_8BCD(boss, "消耗反击")
    _____5F00_59CB_786C_76F4(boss, cfg["持续秒"])
    SetUnitTimeScale(boss, cfg["动画速度"])
    SetUnitAnimationByIndex(boss, cfg["动画编号"])
    _____64AD_653E_9632_5FA1_59FF_6001_7279_6548(boss)
    local state = {
        Boss = boss,
        ["上下文"] = context,
        ["到期Ms"] = getServerTime() + cfg["持续秒"] * 1000,
        ["动画回调ID"] = 0,
        ["结束回调ID"] = 0,
        ["特效回调ID"] = 0
    }
    state["动画回调ID"] = addPeriodicCallback(
        cfg["动画重播间隔毫秒"],
        function()
            if not _____5355_4F4D_6709_6548(boss) or getServerTime() >= state["到期Ms"] then
                return
            end
            SetUnitAnimationByIndex(boss, cfg["动画编号"])
        end
    )
    state["特效回调ID"] = addPeriodicCallback(
        cfg["防御特效刷新毫秒"],
        function()
            if not _____5355_4F4D_6709_6548(boss) or getServerTime() >= state["到期Ms"] then
                return
            end
            _____64AD_653E_9632_5FA1_59FF_6001_7279_6548(boss)
        end
    )
    state["结束回调ID"] = addDelayedCallback(
        cfg["持续秒"] * 1000,
        function()
            _____6E05_9664_6D88_8017_53CD_51FB_72B6_6001(boss)
        end
    )
    _____6D88_8017_53CD_51FB_72B6_6001_8868[hid] = state
end
function ____on_6811_9B54_9996_9886_6D88_8017_53CD_51FB_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6D88_8017_53CD_51FB_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放树魔首领消耗反击"](context)
end
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local jass = require("jass.common")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local SetUnitFacing = jass.SetUnitFacing
SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
SetUnitTimeScale = jass.SetUnitTimeScale
IsUnitType = jass.IsUnitType
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local AddLightning = jass.AddLightning
local DestroyLightning = jass.DestroyLightning
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_2.registerDamageModifier
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_3.addDelayedCallback
removeDelayedCallback = ____require_result_3.removeDelayedCallback
addPeriodicCallback = ____require_result_3.addPeriodicCallback
removePeriodicCallback = ____require_result_3.removePeriodicCallback
getServerTime = ____require_result_3.getServerTime
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____5F00_59CB_786C_76F4 = ____require_result_4["开始硬直"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.02．线段危险区")
local _____521B_5EFA_7EBF_6BB5_5371_9669_533A = ____require_result_5["创建线段危险区"]
local ____require_result_6 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_6["获取Boss技能敌对英雄列表"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
createTimedEffect = ____require_result_7.createTimedEffect
local _____521B_5EFA_70B9_7279_6548 = ____require_result_7["创建点特效"]
local ____require_result_8 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_8.YDWETimerDestroyEffectSafe
local ____require_result_9 = require("lib.扩展函数.BJ函数.12．数学函数")
local CosBJ = ____require_result_9.CosBJ
local SinBJ = ____require_result_9.SinBJ
_____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID = stringToFourCC(_____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____6D88_8017_53CD_51FB_6280_80FDID = stringToFourCC(_____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]["技能槽位"])
_____6D88_8017_53CD_51FB_72B6_6001_8868 = {}
local _____6D88_8017_53CD_51FB_5DF2_6CE8_518C = false
local function _____53D6_65B9_5411_89D2(from, to)
    return _____4E24_70B9_65B9_5411_89D2(
        GetUnitX(from),
        GetUnitY(from),
        GetUnitX(to),
        GetUnitY(to)
    )
end
local function _____662F_80CC_540E_7834_62DB_89D2_5EA6(boss, attacker)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    return _____5355_4F4D_662F_5426_5728_6765_6E90_80CC_540E_6247_533A(boss, attacker, cfg["背后判定角度"])
end
local function _____662F_6B63_9762_53CD_51FB_89D2_5EA6(boss, attacker)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    return _____5355_4F4D_662F_5426_5728_6765_6E90_6B63_9762_6247_533A(boss, attacker, cfg["正面判定角度"])
end
local function _____8BBE_7F6E_9B54_6CD5_503C_4E0B_9650(unit, value)
    SetUnitState(unit, UNIT_STATE_MANA, value > 0 and value or 0)
end
local function _____64AD_653E_62BD_9B54_7279_6548(target)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    local effect = AddSpecialEffectTarget(cfg["抽魔特效路径"], target, "origin")
    if effect ~= nil and effect ~= 0 then
        YDWETimerDestroyEffectSafe(1, effect)
    end
end
local function _____64AD_653E_53CD_51FB_8FDE_7EBF(boss, target)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    local lightning = AddLightning(
        cfg["抽魔连线代码"],
        false,
        GetUnitX(boss),
        GetUnitY(boss),
        GetUnitX(target),
        GetUnitY(target)
    )
    if lightning == nil or lightning == 0 then
        return
    end
    addDelayedCallback(
        600,
        function()
            DestroyLightning(lightning)
        end
    )
end
local function _____521B_5EFA_53CD_51FB_5F39_9053_8868_73B0(boss, angle)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    local x = GetUnitX(boss) + CosBJ(angle) * 160
    local y = GetUnitY(boss) + SinBJ(angle) * 160
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["反击弹道特效路径"],
        X = x,
        Y = y,
        Z = 0,
        ["持续秒"] = cfg["反击弹道特效持续秒"]
    })
end
local function _____6267_884C_53CD_51FB(state, attacker, _____89E6_53D1_4F24_5BB3)
    local boss = state.Boss
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(attacker) then
        return
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    local angle = _____53D6_65B9_5411_89D2(boss, attacker)
    SetUnitFacing(boss, angle)
    SetUnitAnimationByIndex(boss, 4)
    _____521B_5EFA_53CD_51FB_5F39_9053_8868_73B0(boss, angle)
    _____64AD_653E_62BD_9B54_7279_6548(attacker)
    _____64AD_653E_53CD_51FB_8FDE_7EBF(boss, attacker)
    _____8BBE_7F6E_9B54_6CD5_503C_4E0B_9650(
        attacker,
        GetUnitState(attacker, UNIT_STATE_MANA) - _____89E6_53D1_4F24_5BB3 * cfg["抽魔伤害比例"]
    )
    _____521B_5EFA_7EBF_6BB5_5371_9669_533A({
        ["清理"] = state["上下文"]["清理"],
        ["名称"] = "树魔首领-消耗反击冲击波",
        ["起点X"] = GetUnitX(boss),
        ["起点Y"] = GetUnitY(boss),
        ["方向角"] = angle,
        ["长度"] = cfg["反击射程"],
        ["宽度"] = cfg["反击宽度"],
        ["持续秒"] = cfg["反击持续秒"],
        ["Tick间隔毫秒"] = cfg["反击Tick毫秒"],
        ["单位列表"] = function()
            return _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
        end,
        ["提示圈"] = false,
        ["on进入"] = function(unit)
            if not _____5355_4F4D_6709_6548(unit) then
                return
            end
            local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["反击Boss攻击力比例"]
            _____9020_6210AOE_6280_80FD_4F24_5BB3({
                ["来源"] = boss,
                ["目标"] = unit,
                ["伤害"] = damage,
                attack = true,
                ranged = false,
                attackType = ATTACK_TYPE_NORMAL,
                ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
                ["来源类型"] = "Boss技能"
            })
        end
    })
end
local function _____6811_9B54_9996_9886_6D88_8017_53CD_51FB_4F24_5BB3_4FEE_6B63(damageContext)
    local target = damageContext.target
    local attacker = damageContext.attacker
    if not _____5355_4F4D_6709_6548(target) or not _____5355_4F4D_6709_6548(attacker) then
        return damageContext.currentDamage
    end
    if GetUnitTypeId(target) ~= _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID then
        return damageContext.currentDamage
    end
    local state = _____6D88_8017_53CD_51FB_72B6_6001_8868[GetHandleId(target) or 0]
    if state == nil then
        return damageContext.currentDamage
    end
    if getServerTime() >= state["到期Ms"] then
        _____6E05_9664_6D88_8017_53CD_51FB_72B6_6001(target)
        return damageContext.currentDamage
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    if _____662F_80CC_540E_7834_62DB_89D2_5EA6(target, attacker) then
        _____6E05_9664_6D88_8017_53CD_51FB_72B6_6001(target)
        _____5F00_59CB_786C_76F4(target, cfg["硬直秒"])
        return damageContext.currentDamage * (1 + cfg["背后增伤比例"])
    end
    if not _____662F_6B63_9762_53CD_51FB_89D2_5EA6(target, attacker) then
        return damageContext.currentDamage
    end
    _____6E05_9664_6D88_8017_53CD_51FB_72B6_6001(target)
    _____6267_884C_53CD_51FB(state, attacker, damageContext.currentDamage)
    return damageContext.currentDamage * (1 - cfg["正面减伤比例"])
end
____exports["注册树魔首领消耗反击"] = function()
    if _____6D88_8017_53CD_51FB_5DF2_6CE8_518C then
        return
    end
    _____6D88_8017_53CD_51FB_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "树魔首领-消耗反击",
        ["单位类型ID"] = _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____6D88_8017_53CD_51FB_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_6811_9B54_9996_9886_6D88_8017_53CD_51FB_751F_6548(boss, _____6D88_8017_53CD_51FB_6280_80FDID)
        end
    })
    registerDamageModifier(_____6811_9B54_9996_9886_6D88_8017_53CD_51FB_4F24_5BB3_4FEE_6B63, 65)
end
return ____exports
