--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 物品治疗效果系统
-- 
-- 功能：根据技能ID执行不同类型的治疗效果
-- - A002: 单体瞬间回复生命值
-- - A0LF: 单体瞬间回复魔法值
-- - A015: 单体瞬间回复生命值和魔法值
-- - A0B8: 群体瞬间回复生命值和魔法值（范围1000）
-- - A08C: 单体缓慢回复生命值和魔法值（HOT，10秒）
-- 
-- 后续接手者注意：
-- 1. 直接调用 doHeal 和 startHot，不需要通过STES事件
-- 2. 技能ID使用FourCC整数比较
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isValidUnit = ____require_result_0.isValidUnit
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_1.stringToFourCC
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_2.doHeal
local ____require_result_3 = require("系统.04．伤害系统.02．治疗系统.04．持续治疗效果")
local startHot = ____require_result_3.startHot
local isHotActive = ____require_result_3.isHotActive
local ____require_result_4 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_4.YDUserDataGet
--- 技能ID
local ABIL_A002 = stringToFourCC(nil, "A002")
local ABIL_A0LF = stringToFourCC(nil, "A0LF")
local ABIL_A015 = stringToFourCC(nil, "A015")
local ABIL_A0B8 = stringToFourCC(nil, "A0B8")
local ABIL_A08C = stringToFourCC(nil, "A08C")
--- 群体治疗范围
local GROUP_HEAL_RADIUS = 1000
--- HOT持续时间
local HOT_DURATION = 10
--- HOT每秒恢复比例
local HOT_TICK_RATIO = 0.1
--- 系统开关
local HEAL_ITEM_SYSTEM_ENABLED = true
--- 检查单位是否可以被治疗（有效单位 + 友方或自身）
local function canBeHealed(unit, sourcePlayer, source)
    if not isValidUnit(unit) then
        return false
    end
    if not jass.IsUnitAlly(unit, sourcePlayer) and unit ~= source then
        return false
    end
    return true
end
--- 执行物品治疗效果
-- 
-- @param abilId 技能ID（FourCC整数）
-- @param target 目标单位
-- @param healHP 治疗HP量
-- @param healMP 治疗MP量
function ____exports.doHealItemEffect(abilId, target, healHP, healMP)
    if not HEAL_ITEM_SYSTEM_ENABLED then
        return
    end
    if target == nil then
        return
    end
    local sourcePlayer = jass.GetOwningPlayer(target)
    if abilId == ABIL_A002 then
        doHeal(nil, {
            HealSource = target,
            HealTarget = target,
            HealAmount = healHP,
            ItemHeal = true,
            HealEffect = true
        })
        return
    end
    if abilId == ABIL_A0LF then
        doHeal(nil, {
            HealSource = target,
            HealTarget = target,
            HealAmount = 0,
            HealManaAmount = healMP,
            ItemHeal = true,
            HealEffect = false,
            ManaEffect = true
        })
        return
    end
    if abilId == ABIL_A015 then
        doHeal(nil, {
            HealSource = target,
            HealTarget = target,
            HealAmount = healHP,
            HealManaAmount = healMP,
            ItemHeal = true,
            HealEffect = true,
            ManaEffect = true
        })
        return
    end
    if abilId == ABIL_A0B8 then
        local x = jass.GetUnitX(target)
        local y = jass.GetUnitY(target)
        local group = jass.CreateGroup()
        jass.GroupEnumUnitsInRange(
            group,
            x,
            y,
            GROUP_HEAL_RADIUS,
            nil
        )
        local unit = jass.FirstOfGroup(group)
        while unit ~= nil do
            jass.GroupRemoveUnit(group, unit)
            if canBeHealed(unit, sourcePlayer, target) then
                doHeal(nil, {
                    HealSource = target,
                    HealTarget = unit,
                    HealAmount = healHP,
                    HealManaAmount = healMP,
                    ItemHeal = true,
                    HealEffect = true,
                    ManaEffect = true
                })
            end
            unit = jass.FirstOfGroup(group)
        end
        jass.DestroyGroup(group)
        return
    end
    if abilId == ABIL_A08C then
        if isHotActive(nil, target) then
            local currentTickHP = YDUserDataGet(
                nil,
                "unit",
                target,
                "hotTickHP",
                "real"
            )
            local currentTickMP = YDUserDataGet(
                nil,
                "unit",
                target,
                "hotTickMP",
                "real"
            )
            local currentCountdown = YDUserDataGet(
                nil,
                "unit",
                target,
                "持续恢复倒计时",
                "real"
            )
            local currentTotalHP = currentTickHP * currentCountdown
            local currentTotalMP = currentTickMP * currentCountdown
            if healHP < currentTotalHP and healMP < currentTotalMP then
                return
            end
        end
        local tickHP = healHP * HOT_TICK_RATIO
        local tickMP = healMP * HOT_TICK_RATIO
        startHot(
            nil,
            target,
            target,
            tickHP,
            tickMP,
            HOT_DURATION
        )
        return
    end
end
--- 通过技能ID字符串执行物品治疗效果
-- 
-- @param abilIdStr 技能ID字符串（如 "A002"）
-- @param target 目标单位
-- @param healHP 治疗HP量
-- @param healMP 治疗MP量
function ____exports.doHealItemEffectById(abilIdStr, target, healHP, healMP)
    if type(abilIdStr) ~= "string" or #abilIdStr ~= 4 then
        return
    end
    local abilId = stringToFourCC(nil, abilIdStr)
    ____exports.doHealItemEffect(abilId, target, healHP, healMP)
end
--- 检查技能ID是否为物品治疗技能
function ____exports.isHealItemAbility(abilId)
    return abilId == ABIL_A002 or abilId == ABIL_A0LF or abilId == ABIL_A015 or abilId == ABIL_A0B8 or abilId == ABIL_A08C
end
return ____exports
