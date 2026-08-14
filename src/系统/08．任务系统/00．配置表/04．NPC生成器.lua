local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
local ____01_FF0E_652F_7EBFNPC_914D_7F6E_8868 = require("系统.11．剧情系统.02．支线任务.01．支线NPC配置表")
local _____652F_7EBFNPC_914D_7F6E_5217_8868 = ____01_FF0E_652F_7EBFNPC_914D_7F6E_8868["支线NPC配置列表"]
local ____02_FF0E_5267_60C5NPC_521B_5EFA = require("系统.11．剧情系统.00．公共.02．剧情NPC创建")
local _____521B_5EFA_5267_60C5NPC_5355_4F4D = ____02_FF0E_5267_60C5NPC_521B_5EFA["创建剧情NPC单位"]
local ____05_FF0ENPC_521D_59CB_5316_52A8_4F5C = require("系统.08．任务系统.00．配置表.05．NPC初始化动作")
local runNpcInitAction = ____05_FF0ENPC_521D_59CB_5316_52A8_4F5C.runNpcInitAction
local ____09_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548 = require("系统.09．表现系统.02．对话框系统.09．NPC头顶与气泡特效")
local tryAttachQuestMarkerForConfigNpc = ____09_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.tryAttachQuestMarkerForConfigNpc
--- NPC 生成器
-- 根据 NPC 配置表统一创建 NPC，并维护“配置 -> 已创建单位”的索引。
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("平台扩展API动作")
local _____8BBE_5355_4F4D_540D_5B57 = ____require_result_0["设单位名字"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local __pcallModelUnit = 0
local __pcallModelPath = ""
local function __pcallSetUnitModelBody(self)
    japi.DzSetUnitModel(__pcallModelUnit, __pcallModelPath)
end
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_2.debugLog
--- 维护已创建 NPC 的稳定查表，供同步入口按配置键回查真实单位。
local g_npcUnitByRequireId = __TS__New(Map)
local g_npcUnitByNpcNameId = __TS__New(Map)
local g_npcUnitByDisplayName = __TS__New(Map)
local g_npcConfigByUnitHandleId = __TS__New(Map)
local g_endNpcUnitByQuestId = __TS__New(Map)
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local RemoveUnit = jass.RemoveUnit
--- 顶部标记若在 SetUnitModel 前或同帧绑定，换模时可能被顶掉。
-- 有自定义模型时延后到换模之后；无模型时也与 CreateUnit 错开一帧。
local DELAY_QUEST_MARKER_NO_CUSTOM_MODEL = 0.01
local DELAY_QUEST_MARKER_AFTER_SET_MODEL = 0.02
local function registerCreatedNpcUnit(npcConfig, unit, registerQuestId)
    if registerQuestId == nil then
        registerQuestId = true
    end
    if not unit then
        return
    end
    local handleId = type(jass.GetHandleId) == "function" and jass.GetHandleId(unit) or 0
    if handleId > 0 then
        g_npcConfigByUnitHandleId:set(handleId, npcConfig)
    end
    if registerQuestId and npcConfig["任务ID"] ~= nil then
        g_npcUnitByRequireId:set(npcConfig["任务ID"], unit)
    end
    if npcConfig["NPC配置名"] and npcConfig["NPC配置名"] ~= "" then
        g_npcUnitByNpcNameId:set(npcConfig["NPC配置名"], unit)
    end
    if npcConfig["NPC名称"] and npcConfig["NPC名称"] ~= "" then
        g_npcUnitByDisplayName:set(npcConfig["NPC名称"], unit)
    end
end
local function unregisterCreatedNpcUnit(npcConfig, unit)
    if not unit or unit == 0 then
        return
    end
    local handleId = GetHandleId(unit)
    if handleId > 0 then
        g_npcConfigByUnitHandleId:delete(handleId)
    end
    if npcConfig["任务ID"] ~= nil and g_npcUnitByRequireId:get(npcConfig["任务ID"]) == unit then
        g_npcUnitByRequireId:delete(npcConfig["任务ID"])
    end
    if npcConfig["NPC配置名"] and g_npcUnitByNpcNameId:get(npcConfig["NPC配置名"]) == unit then
        g_npcUnitByNpcNameId:delete(npcConfig["NPC配置名"])
    end
    if npcConfig["NPC名称"] and g_npcUnitByDisplayName:get(npcConfig["NPC名称"]) == unit then
        g_npcUnitByDisplayName:delete(npcConfig["NPC名称"])
    end
end
local npcQuestMarkerNoModelQueue = {}
local npcQuestMarkerAfterModelQueue = {}
local npcSetModelQueue = {}
local function onNpcQuestMarkerNoModelDelayed()
    local ctx = table.remove(npcQuestMarkerNoModelQueue, 1)
    if ctx ~= nil then
        tryAttachQuestMarkerForConfigNpc(nil, ctx.unit, ctx.npcConfig)
    end
end
local function onNpcQuestMarkerAfterModelDelayed()
    local ctx = table.remove(npcQuestMarkerAfterModelQueue, 1)
    if ctx ~= nil then
        tryAttachQuestMarkerForConfigNpc(nil, ctx.unit, ctx.npcConfig)
    end
end
local function onNpcSetModelDelayed()
    local ctx = table.remove(npcSetModelQueue, 1)
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
    if npcConfig["模型路径"] then
        npcQuestMarkerAfterModelQueue[#npcQuestMarkerAfterModelQueue + 1] = {unit = unit, npcConfig = npcConfig}
        addDelayedCallback(DELAY_QUEST_MARKER_AFTER_SET_MODEL * 1000, onNpcQuestMarkerAfterModelDelayed)
    else
        npcQuestMarkerNoModelQueue[#npcQuestMarkerNoModelQueue + 1] = {unit = unit, npcConfig = npcConfig}
        addDelayedCallback(DELAY_QUEST_MARKER_NO_CUSTOM_MODEL * 1000, onNpcQuestMarkerNoModelDelayed)
    end
end
local function scheduleSetUnitModel(unit, modelPath, npcLabel)
    npcSetModelQueue[#npcSetModelQueue + 1] = {unit = unit, modelPath = modelPath, npcLabel = npcLabel}
    addDelayedCallback(10, onNpcSetModelDelayed)
end
local function createSingleNPC(npcConfig, registerQuestId)
    if registerQuestId == nil then
        registerQuestId = true
    end
    if not npcConfig["单位ID"] or npcConfig["坐标X"] == nil or npcConfig["坐标Y"] == nil then
        debugLog(
            nil,
            "NPC生成器",
            "配置不完整，跳过:",
            tostring(npcConfig["NPC配置名"])
        )
        return nil
    end
    local unitCode = npcConfig["单位ID"]
    if #unitCode ~= 4 then
        debugLog(nil, "NPC生成器", "单位代码无效:", unitCode)
        return nil
    end
    local unit = _____521B_5EFA_5267_60C5NPC_5355_4F4D({
        ["单位ID"] = unitCode,
        X = npcConfig["坐标X"],
        Y = npcConfig["坐标Y"],
        ["朝向"] = npcConfig["朝向"] or 270,
        ["登记死亡排泄"] = true
    })
    if not unit then
        debugLog(
            nil,
            "NPC生成器",
            "创建单位失败:",
            tostring(npcConfig["NPC配置名"]),
            ("(" .. unitCode) .. ")"
        )
        return nil
    end
    if npcConfig["NPC名称"] then
        _____8BBE_5355_4F4D_540D_5B57(unit, npcConfig["NPC名称"])
    end
    if npcConfig["模型路径"] then
        scheduleSetUnitModel(
            unit,
            npcConfig["模型路径"],
            tostring(npcConfig["NPC配置名"])
        )
    end
    runNpcInitAction(nil, unit, npcConfig["初始化动作"])
    scheduleTryAttachQuestMarker(unit, npcConfig)
    registerCreatedNpcUnit(npcConfig, unit, registerQuestId)
    debugLog(
        nil,
        "NPC生成器",
        "成功创建NPC:",
        tostring(npcConfig["NPC配置名"]),
        "at",
        ((("(" .. tostring(npcConfig["坐标X"])) .. ", ") .. tostring(npcConfig["坐标Y"])) .. ")"
    )
    return unit
end
____exports["初始化NPC"] = function()
    debugLog(nil, "NPC生成器", "开始初始化NPC...")
    g_npcUnitByRequireId:clear()
    g_npcUnitByNpcNameId:clear()
    g_npcUnitByDisplayName:clear()
    g_npcConfigByUnitHandleId:clear()
    g_endNpcUnitByQuestId:clear()
    for ____, npcConfig in ipairs(_____652F_7EBFNPC_914D_7F6E_5217_8868) do
        if npcConfig["启用"] == true and npcConfig["自动创建"] ~= false then
            createSingleNPC(npcConfig)
        end
    end
end
____exports["按名称创建NPC"] = function(____NPC_540D_79F0)
    local npcConfig = __TS__ArrayFind(
        _____652F_7EBFNPC_914D_7F6E_5217_8868,
        function(____, npc) return npc["NPC配置名"] == ____NPC_540D_79F0 or npc["NPC名称"] == ____NPC_540D_79F0 end
    )
    if not npcConfig then
        debugLog(nil, "NPC生成器", "未找到NPC配置:", ____NPC_540D_79F0)
        return nil
    end
    if npcConfig["启用"] ~= true then
        debugLog(nil, "NPC生成器", "NPC未启用:", ____NPC_540D_79F0)
        return nil
    end
    return createSingleNPC(npcConfig)
end
____exports["按任务ID创建NPC"] = function(_____4EFB_52A1ID)
    local npcConfig = __TS__ArrayFind(
        _____652F_7EBFNPC_914D_7F6E_5217_8868,
        function(____, npc) return npc["任务ID"] == _____4EFB_52A1ID end
    )
    if not npcConfig then
        debugLog(
            nil,
            "NPC生成器",
            "未找到任务ID对应的NPC:",
            tostring(_____4EFB_52A1ID)
        )
        return nil
    end
    if npcConfig["启用"] ~= true then
        debugLog(
            nil,
            "NPC生成器",
            "NPC未启用:",
            tostring(npcConfig["NPC配置名"]),
            "(任务ID:",
            tostring(_____4EFB_52A1ID) .. ")"
        )
        return nil
    end
    return createSingleNPC(npcConfig)
end
____exports["获取已启用NPC配置"] = function()
    return __TS__ArrayFilter(
        _____652F_7EBFNPC_914D_7F6E_5217_8868,
        function(____, npc) return npc["启用"] == true end
    )
end
____exports["获取全部NPC配置"] = function()
    return {table.unpack(_____652F_7EBFNPC_914D_7F6E_5217_8868)}
end
____exports["按任务ID查找已创建NPC"] = function(_____4EFB_52A1ID)
    local ____temp_3 = g_npcUnitByRequireId:get(_____4EFB_52A1ID)
    if ____temp_3 == nil then
        ____temp_3 = nil
    end
    return ____temp_3
end
____exports["按名称查找已创建NPC"] = function(____NPC_540D_79F0)
    if not ____NPC_540D_79F0 then
        return nil
    end
    local ____temp_4 = g_npcUnitByNpcNameId:get(____NPC_540D_79F0)
    if ____temp_4 == nil then
        ____temp_4 = g_npcUnitByDisplayName:get(____NPC_540D_79F0)
    end
    local ____temp_4_5 = ____temp_4
    if ____temp_4_5 == nil then
        ____temp_4_5 = nil
    end
    return ____temp_4_5
end
--- 按任务中的结构化配置创建唯一的提交 NPC，不覆盖开始 NPC 的任务 ID 索引。
____exports["创建任务结束NPC"] = function(_____4EFB_52A1)
    local _____4EFB_52A1ID = _____4EFB_52A1["任务ID"]
    local _____7ED3_675F_914D_7F6E = _____4EFB_52A1["结束NPC配置"]
    if _____4EFB_52A1ID == nil or _____7ED3_675F_914D_7F6E == nil then
        return nil
    end
    local _____5DF2_521B_5EFA_5355_4F4D = g_endNpcUnitByQuestId:get(_____4EFB_52A1ID)
    if _____5DF2_521B_5EFA_5355_4F4D and GetUnitTypeId(_____5DF2_521B_5EFA_5355_4F4D) > 0 then
        return _____5DF2_521B_5EFA_5355_4F4D
    end
    local npcConfig = {
        ["NPC名称"] = _____7ED3_675F_914D_7F6E["NPC名称"],
        ["任务ID"] = _____4EFB_52A1ID,
        ["NPC配置名"] = _____7ED3_675F_914D_7F6E["NPC配置名"] or _____7ED3_675F_914D_7F6E["NPC名称"],
        ["单位ID"] = _____7ED3_675F_914D_7F6E["单位ID"],
        ["类型"] = "任务",
        ["坐标X"] = _____7ED3_675F_914D_7F6E["坐标X"],
        ["坐标Y"] = _____7ED3_675F_914D_7F6E["坐标Y"],
        ["朝向"] = _____7ED3_675F_914D_7F6E["朝向"],
        ["模型路径"] = _____7ED3_675F_914D_7F6E["模型路径"],
        ["初始化动作"] = _____7ED3_675F_914D_7F6E["初始化动作"],
        ["自动创建"] = false,
        ["启用"] = true
    }
    local unit = createSingleNPC(npcConfig, false)
    if unit then
        g_endNpcUnitByQuestId:set(_____4EFB_52A1ID, unit)
    end
    return unit
end
--- 提交对白结束后移除动态目标 NPC，并清除对话查表。
____exports["清理任务结束NPC"] = function(_____4EFB_52A1)
    local _____4EFB_52A1ID = _____4EFB_52A1["任务ID"]
    local _____7ED3_675F_914D_7F6E = _____4EFB_52A1["结束NPC配置"]
    if _____4EFB_52A1ID == nil or _____7ED3_675F_914D_7F6E == nil then
        return
    end
    local unit = g_endNpcUnitByQuestId:get(_____4EFB_52A1ID)
    if not unit or unit == 0 then
        return
    end
    local npcConfig = {["NPC名称"] = _____7ED3_675F_914D_7F6E["NPC名称"], ["任务ID"] = _____4EFB_52A1ID, ["NPC配置名"] = _____7ED3_675F_914D_7F6E["NPC配置名"] or _____7ED3_675F_914D_7F6E["NPC名称"]}
    unregisterCreatedNpcUnit(npcConfig, unit)
    g_endNpcUnitByQuestId:delete(_____4EFB_52A1ID)
    if GetUnitTypeId(unit) > 0 then
        RemoveUnit(unit)
    end
end
--- 登记由其他出生系统创建的任务 NPC，并补齐对话查表与头顶任务标记。
____exports["登记外部任务NPC单位"] = function(_____4EFB_52A1ID, _____5355_4F4D)
    if not _____5355_4F4D or _____5355_4F4D == 0 then
        return false
    end
    local npcConfig = __TS__ArrayFind(
        _____652F_7EBFNPC_914D_7F6E_5217_8868,
        function(____, npc) return npc["任务ID"] == _____4EFB_52A1ID and npc["启用"] == true end
    )
    if not npcConfig then
        return false
    end
    local handleId = type(jass.GetHandleId) == "function" and jass.GetHandleId(_____5355_4F4D) or 0
    if handleId > 0 and g_npcConfigByUnitHandleId:get(handleId) == npcConfig then
        return true
    end
    registerCreatedNpcUnit(npcConfig, _____5355_4F4D)
    scheduleTryAttachQuestMarker(_____5355_4F4D, npcConfig)
    return true
end
--- 按真实单位句柄回查配置，避免编辑器显示名与配置展示名不一致导致对话入口失配。
____exports["按单位查找NPC配置"] = function(_____5355_4F4D)
    if not _____5355_4F4D or _____5355_4F4D == 0 then
        return nil
    end
    local handleId = type(jass.GetHandleId) == "function" and jass.GetHandleId(_____5355_4F4D) or 0
    if handleId <= 0 then
        return nil
    end
    return g_npcConfigByUnitHandleId:get(handleId) or nil
end
function ____exports.init()
    ____exports["初始化NPC"]()
end
return ____exports
