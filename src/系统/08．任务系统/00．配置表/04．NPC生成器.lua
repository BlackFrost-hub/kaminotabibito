local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
local ____03_FF0ENPC_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.03．NPC配置表")
local NPC_CONFIGS = ____03_FF0ENPC_914D_7F6E_8868.NPC_CONFIGS
local ____00_FF0E_5355_4F4D_76F8_5173 = require("lib.扩展函数.自定义扩展函数.00．单位相关")
local createUnitWithOptions = ____00_FF0E_5355_4F4D_76F8_5173.createUnitWithOptions
local ____05_FF0ENPC_521D_59CB_5316_52A8_4F5C = require("系统.08．任务系统.00．配置表.05．NPC初始化动作")
local runNpcInitAction = ____05_FF0ENPC_521D_59CB_5316_52A8_4F5C.runNpcInitAction
local ____15_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548 = require("系统.09．表现系统.02．对话框系统.15．NPC头顶与气泡特效")
local tryAttachQuestMarkerForConfigNpc = ____15_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.tryAttachQuestMarkerForConfigNpc
--- NPC 生成器
-- 根据 NPC 配置表统一创建 NPC，并维护“配置 -> 已创建单位”的索引。
local jass = require("jass.common")
local japi = require("jass.japi")
local BJ_DEGTORAD = 0.017453292519943295
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
local safeDestroyTimer = ____require_result_0.safeDestroyTimer
local __pcallModelUnit = 0
local __pcallModelPath = ""
local function __pcallSetUnitModelBody(self)
    japi.DzSetUnitModel(__pcallModelUnit, __pcallModelPath)
end
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_1.debugLog
--- 维护已创建 NPC 的稳定查表，供同步入口按配置键回查真实单位。
local g_npcUnitByRequireId = __TS__New(Map)
local g_npcUnitByNpcNameId = __TS__New(Map)
local g_npcUnitByDisplayName = __TS__New(Map)
--- 顶部标记若在 SetUnitModel 前或同帧绑定，换模时可能被顶掉。
-- 有自定义模型时延后到换模之后；无模型时也与 CreateUnit 错开一帧。
local DELAY_QUEST_MARKER_NO_CUSTOM_MODEL = 0.01
local DELAY_QUEST_MARKER_AFTER_SET_MODEL = 0.02
local function registerCreatedNpcUnit(npcConfig, unit)
    if not unit then
        return
    end
    if npcConfig.requireID ~= nil then
        g_npcUnitByRequireId:set(npcConfig.requireID, unit)
    end
    if npcConfig.NpcNameID and npcConfig.NpcNameID ~= "" then
        g_npcUnitByNpcNameId:set(npcConfig.NpcNameID, unit)
    end
    if npcConfig.NPCrequireName and npcConfig.NPCrequireName ~= "" then
        g_npcUnitByDisplayName:set(npcConfig.NPCrequireName, unit)
    end
end
local npcQuestMarkerCtxByTimerHid = {}
local npcSetModelCtxByTimerHid = {}
local function onNpcQuestMarkerTimerExpire()
    local t = jass.GetExpiredTimer()
    if not t then
        return
    end
    local hid = jass.GetHandleId(t)
    local ctx = npcQuestMarkerCtxByTimerHid[hid]
    __TS__Delete(npcQuestMarkerCtxByTimerHid, hid)
    safeDestroyTimer(nil, t)
    if ctx then
        tryAttachQuestMarkerForConfigNpc(nil, ctx.unit, ctx.npcConfig)
    end
end
local function onNpcSetModelTimerExpire()
    local t = jass.GetExpiredTimer()
    if not t then
        return
    end
    local hid = jass.GetHandleId(t)
    local ctx = npcSetModelCtxByTimerHid[hid]
    __TS__Delete(npcSetModelCtxByTimerHid, hid)
    safeDestroyTimer(nil, t)
    if not ctx then
        return
    end
    __pcallModelUnit = ctx.unit
    __pcallModelPath = ctx.modelPath
    local ok = pcall(__pcallSetUnitModelBody)
    if not ok then
        debugLog(
            nil,
            "NPC生成器",
            "设置单位模型失败（已忽略）",
            ctx.npcLabel,
            "model=" .. tostring(ctx.modelPath)
        )
    end
end
local function scheduleTryAttachQuestMarker(unit, npcConfig)
    local delaySec = npcConfig.modelFIle and DELAY_QUEST_MARKER_AFTER_SET_MODEL or DELAY_QUEST_MARKER_NO_CUSTOM_MODEL
    local t = jass.CreateTimer()
    if t then
        npcQuestMarkerCtxByTimerHid[jass.GetHandleId(t)] = {unit = unit, npcConfig = npcConfig}
        safeTimerStart(
            nil,
            t,
            delaySec,
            false,
            onNpcQuestMarkerTimerExpire
        )
    end
end
local function scheduleSetUnitModel(unit, modelPath, npcLabel)
    local t = jass.CreateTimer()
    if t then
        npcSetModelCtxByTimerHid[jass.GetHandleId(t)] = {unit = unit, modelPath = modelPath, npcLabel = npcLabel}
        safeTimerStart(
            nil,
            t,
            0.01,
            false,
            onNpcSetModelTimerExpire
        )
    end
end
local function createSingleNPC(npcConfig)
    if not npcConfig.unitcode or npcConfig.X == nil or npcConfig.Y == nil then
        debugLog(
            nil,
            "NPC生成器",
            "配置不完整，跳过:",
            tostring(npcConfig.NpcNameID)
        )
        return nil
    end
    local unitCode = npcConfig.unitcode
    if #unitCode ~= 4 then
        debugLog(nil, "NPC生成器", "单位代码无效:", unitCode)
        return nil
    end
    local facingDeg = npcConfig.Facing or 270
    local facingRad = facingDeg * BJ_DEGTORAD
    local unit = createUnitWithOptions(
        nil,
        15,
        unitCode,
        npcConfig.X,
        npcConfig.Y,
        facingRad
    )
    if not unit then
        debugLog(
            nil,
            "NPC生成器",
            "创建单位失败:",
            tostring(npcConfig.NpcNameID),
            ("(" .. unitCode) .. ")"
        )
        return nil
    end
    if npcConfig.modelFIle then
        scheduleSetUnitModel(
            unit,
            npcConfig.modelFIle,
            tostring(npcConfig.NpcNameID)
        )
    end
    runNpcInitAction(nil, unit, npcConfig.initAction)
    scheduleTryAttachQuestMarker(unit, npcConfig)
    registerCreatedNpcUnit(npcConfig, unit)
    debugLog(
        nil,
        "NPC生成器",
        "成功创建NPC:",
        tostring(npcConfig.NpcNameID),
        "at",
        ((("(" .. tostring(npcConfig.X)) .. ", ") .. tostring(npcConfig.Y)) .. ")"
    )
    return unit
end
function ____exports.initializeNPCs()
    debugLog(nil, "NPC生成器", "开始初始化NPC...")
    g_npcUnitByRequireId:clear()
    g_npcUnitByNpcNameId:clear()
    g_npcUnitByDisplayName:clear()
    for ____, npcConfig in ipairs(NPC_CONFIGS) do
        if npcConfig.enabled == true then
            createSingleNPC(npcConfig)
        end
    end
end
function ____exports.createNPCByName(npcName)
    local npcConfig = __TS__ArrayFind(
        NPC_CONFIGS,
        function(____, npc) return npc.NpcNameID == npcName or npc.NPCrequireName == npcName end
    )
    if not npcConfig then
        debugLog(nil, "NPC生成器", "未找到NPC配置:", npcName)
        return nil
    end
    if npcConfig.enabled ~= true then
        debugLog(nil, "NPC生成器", "NPC未启用:", npcName)
        return nil
    end
    return createSingleNPC(npcConfig)
end
function ____exports.createNPCByQuestId(requireID)
    local npcConfig = __TS__ArrayFind(
        NPC_CONFIGS,
        function(____, npc) return npc.requireID == requireID end
    )
    if not npcConfig then
        debugLog(
            nil,
            "NPC生成器",
            "未找到任务ID对应的NPC:",
            tostring(requireID)
        )
        return nil
    end
    if npcConfig.enabled ~= true then
        debugLog(
            nil,
            "NPC生成器",
            "NPC未启用:",
            tostring(npcConfig.NpcNameID),
            "(任务ID:",
            tostring(requireID) .. ")"
        )
        return nil
    end
    return createSingleNPC(npcConfig)
end
function ____exports.getEnabledNPCs()
    return __TS__ArrayFilter(
        NPC_CONFIGS,
        function(____, npc) return npc.enabled == true end
    )
end
function ____exports.getAllNPCs()
    return {table.unpack(NPC_CONFIGS)}
end
function ____exports.findExistingNpcByRequireId(requireID)
    local ____temp_2 = g_npcUnitByRequireId:get(requireID)
    if ____temp_2 == nil then
        ____temp_2 = nil
    end
    return ____temp_2
end
function ____exports.findExistingNpcByName(npcName)
    if not npcName then
        return nil
    end
    local ____temp_3 = g_npcUnitByNpcNameId:get(npcName)
    if ____temp_3 == nil then
        ____temp_3 = g_npcUnitByDisplayName:get(npcName)
    end
    local ____temp_3_4 = ____temp_3
    if ____temp_3_4 == nil then
        ____temp_3_4 = nil
    end
    return ____temp_3_4
end
function ____exports.init()
    ____exports.initializeNPCs()
end
return ____exports
