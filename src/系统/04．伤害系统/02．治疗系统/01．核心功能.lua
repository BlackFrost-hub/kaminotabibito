local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.04．伤害系统.02．治疗系统.00．常量定义")
local HEAL_SYSTEM_ENABLED = ____00_FF0E_5E38_91CF_5B9A_4E49.HEAL_SYSTEM_ENABLED
local HEAL_EVENTS = ____00_FF0E_5E38_91CF_5B9A_4E49.HEAL_EVENTS
local HEAL_RESULT_KEYS = ____00_FF0E_5E38_91CF_5B9A_4E49.HEAL_RESULT_KEYS
local HEAL_SHOW_KEYS = ____00_FF0E_5E38_91CF_5B9A_4E49.HEAL_SHOW_KEYS
local HEAL_STATS_KEYS = ____00_FF0E_5E38_91CF_5B9A_4E49.HEAL_STATS_KEYS
local DEFAULT_HEAL_EFFECT_PATH = ____00_FF0E_5E38_91CF_5B9A_4E49.DEFAULT_HEAL_EFFECT_PATH
local HEAL_TEXT_COLOR = ____00_FF0E_5E38_91CF_5B9A_4E49.HEAL_TEXT_COLOR
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
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local YDUserDataSet = ____require_result_0.YDUserDataSet
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_Fire = ____require_result_1.STES_Fire
local ____require_result_2 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocal5Set = ____require_result_2.YDLocal5Set
local healCallbacks = {}
local healEventListeners = {}
local totalHealStats = __TS__New(Map)
--- 设置单位治疗率（治疗别人时生效）
function ____exports.setHealRate(self, unit, rate)
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
function ____exports.getHealRate(self, unit)
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
function ____exports.setReceivedHealRate(self, unit, rate)
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
function ____exports.getReceivedHealRate(self, unit)
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
function ____exports.registerHealCallback(self, cb)
    if type(cb) == "function" then
        healCallbacks[#healCallbacks + 1] = cb
    end
end
--- 注册治疗事件监听（只读）
-- 用途：任务统计、成就、统计面板
function ____exports.registerHealEvent(self, cb)
    if type(cb) == "function" then
        healEventListeners[#healEventListeners + 1] = cb
    end
end
--- 计算治疗量：基础量 × (1 + 来源治疗率 + 目标受到治疗率)
local function calcHealAmount(self, source, target, baseAmount)
    if baseAmount <= 0 then
        return 0
    end
    local sourceRate = source ~= nil and ____exports.getHealRate(nil, source) or 0
    local targetRate = ____exports.getReceivedHealRate(nil, target)
    return baseAmount * (1 + sourceRate + targetRate)
end
--- 获取已损失生命值
local function getMissingLife(self, target)
    if target == nil then
        return 0
    end
    local maxLife = jass:GetUnitState(target, jass.UNIT_STATE_MAX_LIFE)
    local curLife = jass:GetUnitState(target, jass.UNIT_STATE_LIFE)
    local missing = maxLife - curLife
    return missing > 0 and missing or 0
end
--- 播放治疗特效
local function playHealEffect(self, target, effectPath)
    if target == nil then
        return
    end
    local path = effectPath ~= nil and effectPath ~= "" and effectPath or DEFAULT_HEAL_EFFECT_PATH
    local x = jass:GetUnitX(target)
    local y = jass:GetUnitY(target)
    local eff = jass:AddSpecialEffect(path, x, y)
    if eff ~= nil then
        jass:DestroyEffect(eff)
    end
end
--- 触发数值显示事件
-- 供Lua端/JASS端调用，显示治疗/伤害数值
-- 
-- @param target 目标单位
-- @param amount 数值
-- @param red 红色分量（可选，默认治疗颜色）
-- @param green 绿色分量（可选）
-- @param blue 蓝色分量（可选）
function ____exports.fireShowDamageEvent(self, target, amount, red, green, blue)
    YDLocal5Set(nil, "real", HEAL_SHOW_KEYS.AMOUNT, amount)
    YDLocal5Set(nil, "unit", HEAL_SHOW_KEYS.TARGET, target)
    YDLocal5Set(nil, "integer", HEAL_SHOW_KEYS.RED, red or HEAL_TEXT_COLOR.red)
    YDLocal5Set(nil, "integer", HEAL_SHOW_KEYS.GREEN, green or HEAL_TEXT_COLOR.green)
    YDLocal5Set(nil, "integer", HEAL_SHOW_KEYS.BLUE, blue or HEAL_TEXT_COLOR.blue)
    STES_Fire(nil, nil, HEAL_EVENTS.SHOW_DAMAGE)
end
--- 触发"任意单位被治疗"事件
-- 供Lua端/JASS端调用
-- 
-- @param source 治疗来源
-- @param target 治疗目标
-- @param amount 治疗量
function ____exports.fireHealEvent(self, source, target, amount)
    YDLocal5Set(nil, "real", HEAL_RESULT_KEYS.AMOUNT, amount)
    YDLocal5Set(nil, "unit", HEAL_RESULT_KEYS.TARGET, target)
    YDLocal5Set(nil, "unit", HEAL_RESULT_KEYS.SOURCE, source)
    STES_Fire(nil, nil, HEAL_EVENTS.HEAL)
end
--- 累计治疗统计
local function addHealStats(self, target, amount)
    if target == nil or amount <= 0 then
        return
    end
    local hid = jass:GetHandleId(target)
    if hid == nil or hid == 0 then
        return
    end
    totalHealStats:set(
        hid,
        (totalHealStats:get(hid) or 0) + amount
    )
end
--- 与旧 JASS 对齐：只在 Boss战 激活、目标属于玩家组且来源对目标友方时累计玩家治疗量
local function shouldRecordPlayerHeal(self, target, sourcePlayer)
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
    local targetPlayer = jass:GetOwningPlayer(target)
    if not jass:IsPlayerInForce(targetPlayer, playerForce) then
        return false
    end
    return jass:IsUnitAlly(target, sourcePlayer) or sourcePlayer == targetPlayer
end
--- 与旧 JASS「治疗事件.j」对齐：直接按 HealSource 的所属玩家累计「治疗量」
local function addPlayerHealStats(self, target, source, amount)
    if source == nil or amount <= 0 then
        return
    end
    local sourcePlayer = jass:GetOwningPlayer(source)
    if not shouldRecordPlayerHeal(nil, target, sourcePlayer) then
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
function ____exports.doHeal(self, params)
    if not HEAL_SYSTEM_ENABLED then
        return 0
    end
    local ____params_3 = params
    local HealSource = ____params_3.HealSource
    local HealTarget = ____params_3.HealTarget
    local HealAmount = ____params_3.HealAmount
    local ItemHeal = ____params_3.ItemHeal
    local HealEffect = ____params_3.HealEffect
    local HealEffectPath = ____params_3.HealEffectPath
    if HealTarget == nil or HealAmount <= 0 then
        return 0
    end
    if jass:IsUnitType(HealTarget, jass.UNIT_TYPE_DEAD) then
        return 0
    end
    local amount = calcHealAmount(nil, HealSource, HealTarget, HealAmount)
    for ____, cb in ipairs(healCallbacks) do
        do
            pcall(function()
                amount = cb(
                    nil,
                    HealSource,
                    HealTarget,
                    amount,
                    ItemHeal
                )
            end)
        end
    end
    if amount <= 0 then
        return 0
    end
    local missingLife = getMissingLife(nil, HealTarget)
    local actualHeal = amount < missingLife and amount or missingLife
    if actualHeal <= 0 then
        return 0
    end
    local curLife = jass:GetUnitState(HealTarget, jass.UNIT_STATE_LIFE)
    jass:SetUnitState(HealTarget, jass.UNIT_STATE_LIFE, curLife + actualHeal)
    if HealEffect then
        playHealEffect(nil, HealTarget, HealEffectPath)
    end
    ____exports.fireShowDamageEvent(nil, HealTarget, actualHeal)
    ____exports.fireHealEvent(nil, HealSource, HealTarget, actualHeal)
    addHealStats(nil, HealTarget, actualHeal)
    addPlayerHealStats(nil, HealTarget, HealSource, actualHeal)
    for ____, listener in ipairs(healEventListeners) do
        do
            pcall(function()
                listener(
                    nil,
                    HealSource,
                    HealTarget,
                    actualHeal,
                    ItemHeal
                )
            end)
        end
    end
    return actualHeal
end
--- 技能治疗
function ____exports.spellHeal(self, source, target, amount, showEffect, effectPath)
    if showEffect == nil then
        showEffect = true
    end
    return ____exports.doHeal(nil, {
        HealSource = source,
        HealTarget = target,
        HealAmount = amount,
        ItemHeal = false,
        HealEffect = showEffect,
        HealEffectPath = effectPath
    })
end
--- 物品治疗
function ____exports.itemHeal(self, source, target, amount, showEffect, effectPath)
    if showEffect == nil then
        showEffect = true
    end
    return ____exports.doHeal(nil, {
        HealSource = source,
        HealTarget = target,
        HealAmount = amount,
        ItemHeal = true,
        HealEffect = showEffect,
        HealEffectPath = effectPath
    })
end
--- 生命恢复（无特效无来源）
function ____exports.regenHeal(self, target, amount)
    return ____exports.doHeal(nil, {
        HealSource = nil,
        HealTarget = target,
        HealAmount = amount,
        ItemHeal = false,
        HealEffect = false
    })
end
--- 获取累计被治疗量
function ____exports.getTotalHealed(self, unit)
    if unit == nil then
        return 0
    end
    local hid = jass:GetHandleId(unit)
    if hid == nil or hid == 0 then
        return 0
    end
    return totalHealStats:get(hid) or 0
end
--- 检查系统是否启用
function ____exports.isHealSystemEnabled(self)
    return HEAL_SYSTEM_ENABLED
end
return ____exports
