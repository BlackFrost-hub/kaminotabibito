local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
local ____03_FF0ENPC_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.03．NPC配置表")
local NPC_CONFIGS = ____03_FF0ENPC_914D_7F6E_8868.NPC_CONFIGS
--- NPC生成器 - 根据NPC配置表统一创建NPC
local jass = require("jass.common")
local _print = _G.print
--- 创建单个NPC
-- 
-- @param npcConfig NPC配置数据
-- @returns 创建的单位，失败返回null
local function createSingleNPC(self, npcConfig)
    if not npcConfig.unitCode or not npcConfig.X or not npcConfig.Y then
        _print(
            nil,
            "[NPC生成器] 配置不完整，跳过: " .. tostring(npcConfig.NpcName)
        )
        return nil
    end
    local unitCode = npcConfig.unitCode
    if #unitCode ~= 4 then
        _print(nil, "[NPC生成器] 单位代码无效: " .. unitCode)
        return nil
    end
    local bytes = {
        string.byte(unitCode, 1) or 0 / 0,
        string.byte(unitCode, 2) or 0 / 0,
        string.byte(unitCode, 3) or 0 / 0,
        string.byte(unitCode, 4) or 0 / 0
    }
    local unitId = bytes[1] * 16777216 + bytes[2] * 65536 + bytes[3] * 256 + bytes[4]
    local neutralPlayer = jass.Player(15)
    local unit = jass.CreateUnit(
        neutralPlayer,
        unitId,
        npcConfig.X,
        npcConfig.Y,
        npcConfig.Facing or 270
    )
    if not unit then
        _print(
            nil,
            ((("[NPC生成器] 创建单位失败: " .. tostring(npcConfig.NpcName)) .. " (") .. unitCode) .. ")"
        )
        return nil
    end
    if npcConfig.NpcName and type(jass.SetUnitName) == "function" then
        jass.SetUnitName(unit, npcConfig.NpcName)
    end
    if npcConfig.modelFIle and type(jass.SetUnitModel) == "function" then
        jass.SetUnitModel(unit, npcConfig.modelFIle)
    end
    _print(
        nil,
        ((((("[NPC生成器] 成功创建NPC: " .. tostring(npcConfig.NpcName)) .. " at (") .. tostring(npcConfig.X)) .. ", ") .. tostring(npcConfig.Y)) .. ")"
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
    _print(
        nil,
        ((("[NPC生成器] 初始化完成: 创建了 " .. tostring(createdCount)) .. " 个NPC, 跳过了 ") .. tostring(skippedCount)) .. " 个未启用的NPC"
    )
end
--- 根据NPC名称查找并创建特定NPC（用于测试）
-- 
-- @param npcName NPC名称
-- @returns 创建的单位，失败返回null
function ____exports.createNPCByName(self, npcName)
    local npcConfig = __TS__ArrayFind(
        NPC_CONFIGS,
        function(____, npc) return npc.NpcName == npcName end
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
            ((("[NPC生成器] NPC未启用: " .. tostring(npcConfig.NpcName)) .. " (任务ID: ") .. tostring(requireID)) .. ")"
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
    return {unpack(NPC_CONFIGS)}
end
function ____exports.init(self)
    ____exports.initializeNPCs(nil)
end
return ____exports
