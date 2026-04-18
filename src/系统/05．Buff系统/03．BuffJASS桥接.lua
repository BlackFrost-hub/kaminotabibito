--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
--- Buff 系统 — STES 桥接：注册事件后，由地图 `STES_Fire("添加Buff")` / JASS 遍历触发
-- 
-- =============================================================================
-- 传参方式（与 `07．装备提取` 一致：YDLocal5 子触发传参区，中文变量名）
-- =============================================================================
-- 父触发在 `YDLocalExecuteTrigger` + `YDTriggerExecuteTrigger` 之前，对**子触发**写入：
-- 
-- | YDLocal 类型 | 变量名（须与地图 GUI/JASS 完全一致） | 说明 |
-- |--------------|--------------------------------------|------|
-- | unit | **Buff来源单位** | 来源单位，可选 |
-- | unit | **Buff目标单位** | 目标单位，必填 |
-- | string | **Buff编号** | 与 `01．Buff表` 中 id 一致 |
-- | string | **Buff特效路径** | 特效模型，可选 |
-- | string | **Buff图标路径** | 图标，可选 |
-- | real | **Buff持续时间** | 秒，须大于 0 |
-- | real | **Buff效果数值** | 单次/每秒伤害等 |
-- 
-- Lua 内共用逻辑见 `lib/扩展函数/YDWE函数/05．STES子触发公共工具.ts`。
-- 
-- （旧版 udg_TempUnit[3][4] / TempString[21]–[23] / TempReal[5][6] 已不再使用。）
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_Register = ____require_result_0.STES_Register
local ____require_result_1 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local YDWETimerDestroyEffect = ____require_result_1.YDWETimerDestroyEffect
local ____require_result_2 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
local ydlStes_syncTriggerStep = ____require_result_2.ydlStes_syncTriggerStep
local ydlStes_finishChildCleanup = ____require_result_2.ydlStes_finishChildCleanup
local ydlStes_readString5 = ____require_result_2.ydlStes_readString5
local ydlStes_readUnit5 = ____require_result_2.ydlStes_readUnit5
local ydlStes_readReal5 = ____require_result_2.ydlStes_readReal5
local ydlStes_registerAfterGetTable = ____require_result_2.ydlStes_registerAfterGetTable
____exports.BUFF_ADD_STES_EVENT = "添加Buff"
--- 与地图 YDLocal5Set 对齐的中文变量名
local YL_UNIT_SOURCE = "Buff来源单位"
local YL_UNIT_TARGET = "Buff目标单位"
local YL_STR_ID = "Buff编号"
local YL_STR_EFFECT = "Buff特效路径"
local YL_STR_ICON = "Buff图标路径"
local YL_REAL_DURATION = "Buff持续时间"
local YL_REAL_VALUE = "Buff效果数值"
local function resolveSourceDisplayName(self, source)
    if source == nil or source == 0 then
        return nil
    end
    if type(jass.GetUnitName) ~= "function" then
        return nil
    end
    local n = jass.GetUnitName(source)
    return type(n) == "string" and n ~= "" and n or nil
end
local function playOneShotEffectOnTarget(self, modelPath, target)
    if modelPath == "" or target == nil or target == 0 then
        return
    end
    if type(jass.AddSpecialEffectTarget) ~= "function" then
        return
    end
    local eff = jass.AddSpecialEffectTarget(modelPath, target, "overhead")
    if eff == nil or eff == 0 then
        return
    end
    YDWETimerDestroyEffect(nil, 2, eff)
end
--- 从 YDLocal5 读参并施加 Buff（地图须在触发子触发前写入上表所列变量名）
function ____exports.buffBridgeApplyFromYdlocal(self, _self)
    do
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            ydlStes_syncTriggerStep(nil, nil)
            local source = ydlStes_readUnit5(nil, nil, YL_UNIT_SOURCE)
            local target = ydlStes_readUnit5(nil, nil, YL_UNIT_TARGET)
            local buffID = ydlStes_readString5(nil, nil, YL_STR_ID)
            local effectPath = ydlStes_readString5(nil, nil, YL_STR_EFFECT)
            local iconPath = ydlStes_readString5(nil, nil, YL_STR_ICON)
            local duration = ydlStes_readReal5(nil, nil, YL_REAL_DURATION)
            local effectVal = ydlStes_readReal5(nil, nil, YL_REAL_VALUE)
            if target == nil or target == 0 then
                return true
            end
            if buffID == "" then
                return true
            end
            if duration <= 0 then
                return true
            end
            local srcName = resolveSourceDisplayName(nil, source)
            registerManualBuff(
                nil,
                target,
                buffID,
                duration,
                effectVal,
                {sourceName = srcName, iconOverride = iconPath ~= "" and iconPath or nil, effectModelOverride = effectPath ~= "" and effectPath or nil}
            )
            if effectPath ~= "" then
                playOneShotEffectOnTarget(nil, effectPath, target)
            end
        end)
        do
            ydlStes_finishChildCleanup(nil, nil)
        end
        if ____try and ____hasReturned then
            return ____returnValue
        end
    end
end
local function init(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" then
        return
    end
    if STES_Register == nil then
        return
    end
    local trig = jass.CreateTrigger()
    jass.TriggerAddAction(
        trig,
        function()
            ____exports.buffBridgeApplyFromYdlocal(nil, nil)
        end
    )
    ydlStes_registerAfterGetTable(nil, nil, trig, ____exports.BUFF_ADD_STES_EVENT)
end
init(nil)
return ____exports
