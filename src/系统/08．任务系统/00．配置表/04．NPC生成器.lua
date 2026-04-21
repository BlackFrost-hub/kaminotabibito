local ____lualib = require("lualib_bundle")
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
--- NPC生成器 - 根据NPC配置表统一创建NPC
local jass = require("jass.common")
local japi = require("jass.japi")
local _print = _G.print
--- 头顶叹号/问号：`AddSpecialEffectTarget` 若在 `DzSetUnitModel` 之前或同帧绑定，换模常会顶掉特效（见 jass-pitfalls §15）。
-- 有自定义模型时延后到换模之后（0.02s）；无模型时 0.01s 再挂，与 CreateUnit 错开一帧。
local DELAY_QUEST_MARKER_NO_CUSTOM_MODEL = 0.01
local DELAY_QUEST_MARKER_AFTER_SET_MODEL = 0.02
local function scheduleTryAttachQuestMarkerForConfigNpc(self, unit, npcConfig)
    local delaySec = npcConfig.modelFIle and DELAY_QUEST_MARKER_AFTER_SET_MODEL or DELAY_QUEST_MARKER_NO_CUSTOM_MODEL
    local t = jass.CreateTimer()
    if not t then
        tryAttachQuestMarkerForConfigNpc(nil, unit, npcConfig)
        return
    end
    jass.TimerStart(
        t,
        delaySec,
        false,
        function()
            jass.DestroyTimer(t)
            tryAttachQuestMarkerForConfigNpc(nil, unit, npcConfig)
        end
    )
end
--- 设置单位模型：`SetUnitModel` 非 jass.common 原生，仅 BzAPI：`japi.DzSetUnitModel`（点号直调）。
-- 延后 0.01s 再调，减轻同栈紧跟 CreateUnit 时 JAPI::Plus / hook 桩（DzCallback0）问题。
local function scheduleSetUnitModel(self, unit, modelPath, npcLabel)
    local t = jass.CreateTimer()
    if not t then
        return
    end
    jass.TimerStart(
        t,
        0.01,
        false,
        function()
            jass.DestroyTimer(t)
            local ok = pcall(function ()
                    japi.DzSetUnitModel(unit, modelPath)
                end
            )
            if not ok then
                _print(
                    nil,
                    (("[NPC生成器] 设置单位模型失败（已忽略）: " .. npcLabel) .. " model=") .. tostring(modelPath)
                )
            end
        end
    )
end
--- 创建单个NPC
-- 
-- @param npcConfig NPC配置数据
-- @returns 创建的单位，失败返回null
local function createSingleNPC(self, npcConfig)
    if not npcConfig.unitcode or npcConfig.X == nil or npcConfig.Y == nil then
        _print(
            nil,
            "[NPC生成器] 配置不完整，跳过: " .. tostring(npcConfig.NpcNameID)
        )
        return nil
    end
    local unitCode = npcConfig.unitcode
    if #unitCode ~= 4 then
        _print(nil, "[NPC生成器] 单位代码无效: " .. unitCode)
        return nil
    end
    local facingDeg = npcConfig.Facing or 270
    local facingRad = facingDeg * math.pi / 180
    local unit = createUnitWithOptions(
        nil,
        15,
        unitCode,
        npcConfig.X,
        npcConfig.Y,
        facingRad
    )
    if not unit then
        _print(
            nil,
            ((("[NPC生成器] 创建单位失败: " .. tostring(npcConfig.NpcNameID)) .. " (") .. unitCode) .. ")"
        )
        return nil
    end
    if npcConfig.modelFIle then
        scheduleSetUnitModel(
            nil,
            unit,
            npcConfig.modelFIle,
            tostring(npcConfig.NpcNameID)
        )
    end
    runNpcInitAction(nil, unit, npcConfig.initAction)
    scheduleTryAttachQuestMarkerForConfigNpc(nil, unit, npcConfig)
    _print(
        nil,
        ((((("[NPC生成器] 成功创建NPC: " .. tostring(npcConfig.NpcNameID)) .. " at (") .. tostring(npcConfig.X)) .. ", ") .. tostring(npcConfig.Y)) .. ")"
    )
    return unit
end
--- 初始化所有启用的NPC
-- 在游戏开始时调用此函数
function ____exports.initializeNPCs(self)
    _print(nil, "[NPC生成器] 开始初始化NPC...")
    local createdCount = 0
    local skippedCount = 0
    for ____, npcConfig in ipairs(NPC_CONFIGS) do
        if npcConfig.enabled == true then
            local unit = createSingleNPC(nil, npcConfig)
            if unit then
                createdCount = createdCount + 1
            end
        else
            skippedCount = skippedCount + 1
        end
    end
end
--- 根据NPC名称查找并创建特定NPC（用于测试）
-- 
-- @param npcName NPC名称
-- @returns 创建的单位，失败返回null
function ____exports.createNPCByName(self, npcName)
    local npcConfig = __TS__ArrayFind(
        NPC_CONFIGS,
        function(____, npc) return npc.NpcNameID == npcName or npc.NPCrequireName == npcName end
    )
    if not npcConfig then
        _print(nil, "[NPC生成器] 未找到NPC配置: " .. npcName)
        return nil
    end
    if npcConfig.enabled ~= true then
        _print(nil, "[NPC生成器] NPC未启用: " .. npcName)
        return nil
    end
    return createSingleNPC(nil, npcConfig)
end
--- 根据任务ID查找并创建对应NPC
-- 
-- @param requireID 任务ID
-- @returns 创建的单位，失败返回null
function ____exports.createNPCByQuestId(self, requireID)
    local npcConfig = __TS__ArrayFind(
        NPC_CONFIGS,
        function(____, npc) return npc.requireID == requireID end
    )
    if not npcConfig then
        _print(
            nil,
            "[NPC生成器] 未找到任务ID对应的NPC: " .. tostring(requireID)
        )
        return nil
    end
    if npcConfig.enabled ~= true then
        _print(
            nil,
            ((("[NPC生成器] NPC未启用: " .. tostring(npcConfig.NpcNameID)) .. " (任务ID: ") .. tostring(requireID)) .. ")"
        )
        return nil
    end
    return createSingleNPC(nil, npcConfig)
end
--- 获取所有已启用的NPC配置列表
function ____exports.getEnabledNPCs(self)
    return __TS__ArrayFilter(
        NPC_CONFIGS,
        function(____, npc) return npc.enabled == true end
    )
end
--- 获取所有NPC配置列表（包括未启用的）
function ____exports.getAllNPCs(self)
    return {table.unpack(NPC_CONFIGS)}
end
function ____exports.init(self)
    ____exports.initializeNPCs(nil)
end
return ____exports
