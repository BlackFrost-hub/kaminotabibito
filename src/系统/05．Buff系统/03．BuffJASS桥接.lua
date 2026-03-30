local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local ____exports = {}
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
--- Buff 系统 — JASS / STES → TS 桥接：由地图触发器写入全局变量后，发固定 STES 事件，Lua 侧读参、**立刻清空槽位**、再给目标单位注册 Buff 池条目。
-- 
-- =============================================================================
-- 地图侧流程（JASS / GUI）
-- =============================================================================
-- 1. 在「单位组 udg_TempUnit」「字符串数组 udg_TempString」「实数数组 udg_TempReal」中写入下表对应下标；
-- 2. 调用 STES 自定义事件，事件名必须与本文件常量 `BUFF_ADD_STES_EVENT` 完全一致（建议复制粘贴，避免全角空格）；
-- 3. 本模块已在启动时 `STES_Register(trigger, BUFF_ADD_STES_EVENT)`（或经 `Bridge_STES_Register`），回调内会先**快照**再**清空**，再 `registerManualBuff`。
-- 
-- =============================================================================
-- 全局变量槽位约定（与 `dot伤害` 使用 [3]/[4] 语义对齐：本桥接为 Buff 专用含义）
-- =============================================================================
-- | 变量 | 下标 | 含义 |
-- |------|------|------|
-- | udg_TempUnit | **3** | Buff **来源**单位（可选，用于提示「buff来源为某某」） |
-- | udg_TempUnit | **4** | Buff **目标**单位（必填，接收 Buff 池条目） |
-- | udg_TempString | **21** | buffID 字符串（须与 `01．Buff表` 中 id 一致，如 D002） |
-- | udg_TempString | **22** | 特效模型路径（可选；非空时在目标身上播一次性 overhead 附加特效） |
-- | udg_TempString | **23** | 图标路径（可选；非空则覆盖表内 icon，供 Buff 条显示） |
-- | udg_TempReal | **5** | 持续时间（秒，>0） |
-- | udg_TempReal | **6** | 单次/每秒伤害等**数值**，写入 Buff 池的 `effect`（与 UI 提示里 damage 占位一致） |
-- 
-- 清空策略：回调**一开始**把上述槽位读入局部变量后，立即将 Unit 置空、String 置 `""`、Real 置 `0`，
-- 避免同帧重复触发或后续误读旧数据。（若目标无效或 buffID 为空，同样清空。）
-- 
-- =============================================================================
-- 与 `04．伤害系统` 共用 udg_TempUnit 的说明
-- =============================================================================
-- `[5]`/`[6]` 等仍可能被伤害事件使用；本桥接**只改写 [3][4]** 及 TempString/Real 指定下标。请勿在同一时刻混用两套逻辑写同一单位槽。
local jass = require("jass.common")
local g = require("jass.globals")
--- 地图 STES / 触发器里填写的事件名须与此字符串完全一致
____exports.BUFF_ADD_STES_EVENT = "单位添加Buff"
local function readTempString(self, idx)
    local ts = g.udg_TempString
    if ts == nil then
        return ""
    end
    local v = ts[idx]
    if type(v) == "string" then
        return v
    end
    if v == nil then
        return ""
    end
    return tostring(v)
end
local function readTempReal(self, idx)
    local ____temp_0
    if jass.udg_TempReal ~= nil then
        ____temp_0 = jass.udg_TempReal
    else
        ____temp_0 = g.udg_TempReal
    end
    local tr = ____temp_0
    if tr == nil then
        return 0
    end
    local v = tr[idx]
    return type(v) == "number" and __TS__NumberIsFinite(__TS__Number(v)) and v or 0
end
local function readTempUnit(self, idx)
    local ____temp_1
    if jass.udg_TempUnit ~= nil then
        ____temp_1 = jass.udg_TempUnit
    else
        ____temp_1 = g.udg_TempUnit
    end
    local tu = ____temp_1
    if tu == nil then
        return nil
    end
    return tu[idx]
end
--- 将桥接占用的全局槽位清零（Unit → null，String → ""，Real → 0）。
-- 使用 jass 与 jass.globals 上可能存在的两份 udg 引用，尽量与伤害模块一致。
local function clearBuffBridgeGlobals(self)
    local ____temp_2
    if jass.udg_TempUnit ~= nil then
        ____temp_2 = jass.udg_TempUnit
    else
        ____temp_2 = g.udg_TempUnit
    end
    local tu = ____temp_2
    if tu ~= nil then
        tu[3] = nil
        tu[4] = nil
    end
    local ts = g.udg_TempString
    if ts ~= nil then
        ts[21] = ""
        ts[22] = ""
        ts[23] = ""
    end
    local ____temp_3
    if jass.udg_TempReal ~= nil then
        ____temp_3 = jass.udg_TempReal
    else
        ____temp_3 = g.udg_TempReal
    end
    local tr = ____temp_3
    if tr ~= nil then
        tr[5] = 0
        tr[6] = 0
    end
end
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
    if type(jass.YDWETimerDestroyEffect) == "function" then
        jass.YDWETimerDestroyEffect(2, eff)
    elseif type(jass.DestroyEffect) == "function" then
        jass.DestroyEffect(eff)
    end
end
local function registerOneStesEvent(self, trigger, eventName)
    local ____jass_STES_Register_4 = jass.STES_Register
    if ____jass_STES_Register_4 == nil then
        ____jass_STES_Register_4 = g.STES_Register
    end
    local ____jass_STES_Register_4_5 = ____jass_STES_Register_4
    if ____jass_STES_Register_4_5 == nil then
        ____jass_STES_Register_4_5 = _G.STES_Register
    end
    local STES_Reg = ____jass_STES_Register_4_5
    if type(STES_Reg) == "function" then
        STES_Reg(nil, trigger, eventName)
    else
        g.udg_RegTrigger = trigger
        g.udg_RegEventStr = eventName
        if type(jass.ExecuteFunc) == "function" then
            jass.ExecuteFunc("Bridge_STES_Register")
        end
    end
end
--- 供 STES 回调调用：从全局快照 → 清空 → 注册 Buff；也可在 Lua 调试时直接 require 后调用（需先设好全局）。
function ____exports.buffBridgeApplyFromGlobals(self)
    local source = readTempUnit(nil, 3)
    local target = readTempUnit(nil, 4)
    local buffID = readTempString(nil, 21)
    local effectPath = readTempString(nil, 22)
    local iconPath = readTempString(nil, 23)
    local duration = readTempReal(nil, 5)
    local effectVal = readTempReal(nil, 6)
    clearBuffBridgeGlobals(nil)
    if target == nil or target == 0 then
        return
    end
    if buffID == "" then
        return
    end
    if duration <= 0 then
        return
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
end
local function init(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" then
        return
    end
    local trig = jass.CreateTrigger()
    jass.TriggerAddAction(
        trig,
        function()
            do
                local function ____catch(_e)
                    clearBuffBridgeGlobals(nil)
                end
                local ____try, ____hasReturned = pcall(function()
                    ____exports.buffBridgeApplyFromGlobals(nil)
                end)
                if not ____try then
                    ____catch(____hasReturned)
                end
            end
        end
    )
    registerOneStesEvent(nil, trig, ____exports.BUFF_ADD_STES_EVENT)
end
init(nil)
return ____exports
