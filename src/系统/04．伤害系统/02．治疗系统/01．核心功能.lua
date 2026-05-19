local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.04．伤害系统.02．治疗系统.00．常量定义")
local HEAL_SYSTEM_ENABLED = ____00_FF0E_5E38_91CF_5B9A_4E49.HEAL_SYSTEM_ENABLED
local HEAL_EVENTS = ____00_FF0E_5E38_91CF_5B9A_4E49.HEAL_EVENTS
local HEAL_RESULT_KEYS = ____00_FF0E_5E38_91CF_5B9A_4E49.HEAL_RESULT_KEYS
local HEAL_STATS_KEYS = ____00_FF0E_5E38_91CF_5B9A_4E49.HEAL_STATS_KEYS
local DEFAULT_HEAL_EFFECT_PATH = ____00_FF0E_5E38_91CF_5B9A_4E49.DEFAULT_HEAL_EFFECT_PATH
local DEFAULT_MANA_HEAL_EFFECT_PATH = ____00_FF0E_5E38_91CF_5B9A_4E49.DEFAULT_MANA_HEAL_EFFECT_PATH
local HEAL_TEXT_COLOR = ____00_FF0E_5E38_91CF_5B9A_4E49.HEAL_TEXT_COLOR
local MANA_TEXT_COLOR = ____00_FF0E_5E38_91CF_5B9A_4E49.MANA_TEXT_COLOR
local ATTR_HEAL_RATE = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_HEAL_RATE
local ATTR_RECEIVED_HEAL_RATE = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_RECEIVED_HEAL_RATE
--- 治疗系统 - 核心功能
-- 
-- 功能：执行治疗、触发事件、回调系统、治疗率存储
-- 公式：治疗量 = 基础量 × (1 + 来源治疗率 + 目标受到治疗率)
-- 限制：不超过已损失生命值
-- 
-- 后续接手者注意：
-- 1. 开关 HEAL_SYSTEM_ENABLED 在常量文件
-- 2. STES事件参数通过 YDLocal5Set 传递，变量名须与JASS一致
local jass = require("jass.common")
local japi = require("jass.japi")
--- 当前生命/魔法：jass；最大生命/魔法及扩展属性：japi（与 SGSS / 物编面板一致）
local GetUnitStateJass = jass.GetUnitState
local SetUnitStateJass = jass.SetUnitState
local GetUnitStateJapi = japi.GetUnitState
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local YDUserDataSet = ____require_result_0.YDUserDataSet
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_FireWithParams = ____require_result_1.STES_FireWithParams
local ____require_result_2 = require("lib.扩展函数.封装函数.03．漂浮文字.05．数值漂浮文字")
local _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57 = ____require_result_2["显示单位数值漂浮文字"]
local healCallbacks = {}
local healEventListeners = {}
local totalHealStats = __TS__New(Map)
--- 设置单位治疗率（治疗别人时生效）
function ____exports.setHealRate(unit, rate)
    if unit == nil then
        return
    end
    YDUserDataSet(
        nil,
        "unit",
        unit,
        ATTR_HEAL_RATE,
        rate
    )
end
--- 获取单位治疗率
function ____exports.getHealRate(unit)
    if unit == nil then
        return 0
    end
    local v = YDUserDataGet(
        nil,
        "unit",
        unit,
        ATTR_HEAL_RATE,
        "real"
    )
    return type(v) == "number" and v or 0
end
--- 设置单位受到治疗率（被治疗时生效）
function ____exports.setReceivedHealRate(unit, rate)
    if unit == nil then
        return
    end
    YDUserDataSet(
        nil,
        "unit",
        unit,
        ATTR_RECEIVED_HEAL_RATE,
        rate
    )
end
--- 获取单位受到治疗率
function ____exports.getReceivedHealRate(unit)
    if unit == nil then
        return 0
    end
    local v = YDUserDataGet(
        nil,
        "unit",
        unit,
        ATTR_RECEIVED_HEAL_RATE,
        "real"
    )
    return type(v) == "number" and v or 0
end
--- 注册治疗回调（可修改治疗量）
-- 用途：治疗加成Buff、护盾转换、治疗暴击
function ____exports.registerHealCallback(cb)
    if type(cb) == "function" then
        healCallbacks[#healCallbacks + 1] = cb
    end
end
--- 注册治疗事件监听（只读）
-- 用途：任务统计、成就、统计面板
function ____exports.registerHealEvent(cb)
    if type(cb) == "function" then
        healEventListeners[#healEventListeners + 1] = cb
    end
end
--- 计算治疗量：基础量 × (1 + 来源治疗率 + 目标受到治疗率)
local function calcHealAmount(source, target, baseAmount)
    if baseAmount <= 0 then
        return 0
    end
    local sourceRate = source ~= nil and ____exports.getHealRate(source) or 0
    local targetRate = ____exports.getReceivedHealRate(target)
    return baseAmount * (1 + sourceRate + targetRate)
end
--- 获取已损失生命值
local function getMissingLife(target)
    if target == nil then
        return 0
    end
    local maxLife = GetUnitStateJapi(target, jass.UNIT_STATE_MAX_LIFE)
    local curLife = GetUnitStateJass(target, jass.UNIT_STATE_LIFE)
    local missing = maxLife - curLife
    return missing > 0 and missing or 0
end
--- 播放治疗特效
local function playHealEffect(target, effectPath)
    if target == nil then
        return
    end
    local path = effectPath ~= nil and effectPath ~= "" and effectPath or DEFAULT_HEAL_EFFECT_PATH
    local x = jass.GetUnitX(target)
    local y = jass.GetUnitY(target)
    local eff = jass.AddSpecialEffect(path, x, y)
    if eff ~= nil then
        jass.DestroyEffect(eff)
    end
end
--- 获取已损失魔法值
local function getMissingMana(target)
    if target == nil then
        return 0
    end
    local maxMana = GetUnitStateJapi(target, jass.UNIT_STATE_MAX_MANA)
    local curMana = GetUnitStateJass(target, jass.UNIT_STATE_MANA)
    local missing = maxMana - curMana
    return missing > 0 and missing or 0
end
--- 播放魔法恢复特效
local function playManaEffect(target, effectPath)
    if target == nil then
        return
    end
    local path = effectPath ~= nil and effectPath ~= "" and effectPath or DEFAULT_MANA_HEAL_EFFECT_PATH
    local eff = jass.AddSpecialEffectTarget(path, target, "origin")
    if eff ~= nil then
        jass.DestroyEffect(eff)
    end
end
--- 显示魔法恢复漂浮字
local function fireManaShowEvent(target, amount)
    _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57(target, amount, {["红"] = MANA_TEXT_COLOR.red, ["绿"] = MANA_TEXT_COLOR.green, ["蓝"] = MANA_TEXT_COLOR.blue})
end
--- 执行魔法恢复（不超过已损失魔法）
local function applyManaRestore(target, baseAmount)
    if target == nil or baseAmount <= 0 then
        return 0
    end
    local missingMana = getMissingMana(target)
    local actualMana = baseAmount < missingMana and baseAmount or missingMana
    if actualMana <= 0 then
        return 0
    end
    local curMana = GetUnitStateJass(target, jass.UNIT_STATE_MANA)
    SetUnitStateJass(target, jass.UNIT_STATE_MANA, curMana + actualMana)
    return actualMana
end
--- 仅执行魔法恢复（供 doManaRegen 等便捷入口）
function ____exports.restoreMana(target, amount, manaEffect, manaEffectPath, manaShowText)
    if manaEffect == nil then
        manaEffect = false
    end
    if manaShowText == nil then
        manaShowText = true
    end
    if not HEAL_SYSTEM_ENABLED then
        return 0
    end
    if target == nil or amount <= 0 then
        return 0
    end
    if jass.IsUnitType(target, jass.UNIT_TYPE_DEAD) then
        return 0
    end
    local actualMana = applyManaRestore(target, amount)
    if actualMana <= 0 then
        return 0
    end
    if manaEffect then
        playManaEffect(target, manaEffectPath)
    end
    if manaShowText then
        fireManaShowEvent(target, actualMana)
    end
    return actualMana
end
--- 触发数值显示事件
-- 供Lua端/JASS端调用，显示治疗/伤害数值
-- 
-- @param target 目标单位
-- @param amount 数值
-- @param red 红色分量（可选，默认治疗颜色）
-- @param green 绿色分量（可选）
-- @param blue 蓝色分量（可选）
function ____exports.fireShowDamageEvent(target, amount, red, green, blue)
    _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57(target, amount, {["红"] = red or HEAL_TEXT_COLOR.red, ["绿"] = green or HEAL_TEXT_COLOR.green, ["蓝"] = blue or HEAL_TEXT_COLOR.blue})
end
--- 触发"任意单位被治疗"事件
-- 供Lua端/JASS端调用
-- 
-- @param source 治疗来源
-- @param target 治疗目标
-- @param amount 治疗量
function ____exports.fireHealEvent(source, target, amount)
    STES_FireWithParams(HEAL_EVENTS.HEAL, {{type = "real", name = HEAL_RESULT_KEYS.AMOUNT, value = amount}, {type = "unit", name = HEAL_RESULT_KEYS.TARGET, value = target}, {type = "unit", name = HEAL_RESULT_KEYS.SOURCE, value = source}})
end
--- 累计治疗统计
local function addHealStats(target, amount)
    if target == nil or amount <= 0 then
        return
    end
    local hid = jass.GetHandleId(target)
    if hid == nil or hid == 0 then
        return
    end
    totalHealStats:set(
        hid,
        (totalHealStats:get(hid) or 0) + amount
    )
end
--- 与旧 JASS 对齐：只在 Boss战 激活、目标属于玩家组且来源对目标友方时累计玩家治疗量
local function shouldRecordPlayerHeal(target, sourcePlayer)
    if target == nil or sourcePlayer == nil then
        return false
    end
    local bossBattleUnit = YDUserDataGet(
        nil,
        "string",
        HEAL_STATS_KEYS.BOSS_BATTLE_TABLE,
        HEAL_STATS_KEYS.BOSS_BATTLE_UNIT,
        "unit"
    )
    if bossBattleUnit == nil then
        return false
    end
    local playerForce = YDUserDataGet(
        nil,
        "string",
        HEAL_STATS_KEYS.PLAYER_GROUP_TABLE,
        HEAL_STATS_KEYS.PLAYER_GROUP_FORCE,
        "force"
    )
    if playerForce == nil then
        return false
    end
    local targetPlayer = jass.GetOwningPlayer(target)
    if not jass.IsPlayerInForce(targetPlayer, playerForce) then
        return false
    end
    return jass.IsUnitAlly(target, sourcePlayer) or sourcePlayer == targetPlayer
end
--- 与旧 JASS「治疗事件.j」对齐：直接按 HealSource 的所属玩家累计「治疗量」
local function addPlayerHealStats(target, source, amount)
    if source == nil or amount <= 0 then
        return
    end
    local sourcePlayer = jass.GetOwningPlayer(source)
    if not shouldRecordPlayerHeal(target, sourcePlayer) then
        return
    end
    local current = YDUserDataGet(
        nil,
        "player",
        sourcePlayer,
        HEAL_STATS_KEYS.PLAYER_TOTAL_HEAL,
        "real"
    )
    local base = type(current) == "number" and current or 0
    YDUserDataSet(
        nil,
        "player",
        sourcePlayer,
        HEAL_STATS_KEYS.PLAYER_TOTAL_HEAL,
        base + amount
    )
end
--- 执行治疗
-- 流程：校验 -> 计算加成 -> 回调修改 -> 限制溢出 -> 设置生命 -> 特效 -> 事件 -> 统计
-- 
-- @returns 实际治疗量（系统关闭或无效返回0）
function ____exports.doHeal(params)
    if not HEAL_SYSTEM_ENABLED then
        return 0
    end
    local ____params_ManaEffect_3 = params.ManaEffect
    if ____params_ManaEffect_3 == nil then
        ____params_ManaEffect_3 = (params.HealManaAmount or 0) > 0
    end
    local manaEffectEnabled = ____params_ManaEffect_3
    local ____params_4 = params
    local HealSource = ____params_4.HealSource
    local HealTarget = ____params_4.HealTarget
    local HealAmount = ____params_4.HealAmount
    local HealManaAmount = ____params_4.HealManaAmount
    if HealManaAmount == nil then
        HealManaAmount = 0
    end
    local ItemHeal = ____params_4.ItemHeal
    local HealEffect = ____params_4.HealEffect
    local HealEffectPath = ____params_4.HealEffectPath
    local ManaEffectPath = ____params_4.ManaEffectPath
    local ManaShowText = ____params_4.ManaShowText
    if ManaShowText == nil then
        ManaShowText = true
    end
    if HealTarget == nil then
        return 0
    end
    if jass.IsUnitType(HealTarget, jass.UNIT_TYPE_DEAD) then
        return 0
    end
    if HealAmount <= 0 and HealManaAmount <= 0 then
        return 0
    end
    local actualHeal = 0
    if HealAmount > 0 then
        local amount = calcHealAmount(HealSource, HealTarget, HealAmount)
        for ____, cb in ipairs(healCallbacks) do
            do
                pcall(function()
                    amount = cb(HealSource, HealTarget, amount, ItemHeal)
                end)
            end
        end
        if amount > 0 then
            local missingLife = getMissingLife(HealTarget)
            actualHeal = amount < missingLife and amount or missingLife
            if actualHeal > 0 then
                local curLife = GetUnitStateJass(HealTarget, jass.UNIT_STATE_LIFE)
                SetUnitStateJass(HealTarget, jass.UNIT_STATE_LIFE, curLife + actualHeal)
                if HealEffect then
                    playHealEffect(HealTarget, HealEffectPath)
                end
                ____exports.fireShowDamageEvent(HealTarget, actualHeal)
                ____exports.fireHealEvent(HealSource, HealTarget, actualHeal)
                addHealStats(HealTarget, actualHeal)
                addPlayerHealStats(HealTarget, HealSource, actualHeal)
                for ____, listener in ipairs(healEventListeners) do
                    do
                        pcall(function()
                            listener(HealSource, HealTarget, actualHeal, ItemHeal)
                        end)
                    end
                end
            end
        end
    end
    if HealManaAmount > 0 then
        local ____require_result_5 = require("系统.04．伤害系统.02．治疗系统.06．魔法恢复")
        local _____9B54_6CD5_589E_51CF = ____require_result_5["魔法增减"]
        _____9B54_6CD5_589E_51CF(HealTarget, HealManaAmount, ManaShowText, manaEffectEnabled)
    end
    return actualHeal
end
--- 技能治疗
function ____exports.spellHeal(source, target, amount, showEffect, effectPath, manaAmount, showManaEffect, manaEffectPath)
    if showEffect == nil then
        showEffect = true
    end
    if manaAmount == nil then
        manaAmount = 0
    end
    if showManaEffect == nil then
        showManaEffect = false
    end
    return ____exports.doHeal({
        HealSource = source,
        HealTarget = target,
        HealAmount = amount,
        HealManaAmount = manaAmount,
        ItemHeal = false,
        HealEffect = showEffect,
        HealEffectPath = effectPath,
        ManaEffect = showManaEffect,
        ManaEffectPath = manaEffectPath
    })
end
--- 物品治疗
function ____exports.itemHeal(source, target, amount, showEffect, effectPath, manaAmount, showManaEffect, manaEffectPath)
    if showEffect == nil then
        showEffect = true
    end
    if manaAmount == nil then
        manaAmount = 0
    end
    if showManaEffect == nil then
        showManaEffect = false
    end
    return ____exports.doHeal({
        HealSource = source,
        HealTarget = target,
        HealAmount = amount,
        HealManaAmount = manaAmount,
        ItemHeal = true,
        HealEffect = showEffect,
        HealEffectPath = effectPath,
        ManaEffect = showManaEffect,
        ManaEffectPath = manaEffectPath
    })
end
--- 生命恢复（无特效无来源）
function ____exports.regenHeal(target, amount)
    return ____exports.doHeal({
        HealSource = nil,
        HealTarget = target,
        HealAmount = amount,
        ItemHeal = false,
        HealEffect = false
    })
end
--- 获取累计被治疗量
function ____exports.getTotalHealed(unit)
    if unit == nil then
        return 0
    end
    local hid = jass.GetHandleId(unit)
    if hid == nil or hid == 0 then
        return 0
    end
    return totalHealStats:get(hid) or 0
end
--- 检查系统是否启用
function ____exports.isHealSystemEnabled()
    return HEAL_SYSTEM_ENABLED
end
return ____exports
