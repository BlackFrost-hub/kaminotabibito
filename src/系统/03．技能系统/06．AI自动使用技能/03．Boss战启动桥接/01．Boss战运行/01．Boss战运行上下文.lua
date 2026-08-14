local ____lualib = require("lualib_bundle")
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____6309_77E9_5F62_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868
local ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668.getServerTime
____exports["清理矩形当前Boss战上下文"] = function(rectHandleId, expectedGeneration)
    if rectHandleId == 0 then
        return
    end
    local context = _____6309_77E9_5F62_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868[rectHandleId]
    if context == nil then
        return
    end
    if expectedGeneration ~= nil and context["运行代次"] ~= expectedGeneration then
        return
    end
    _____6309_77E9_5F62_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868[rectHandleId] = nil
end
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local _____6309Boss_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868 = {}
_____6309_77E9_5F62_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868 = {}
local _____77E9_5F62_73A9_5BB6_53EF_89C1_5EA6_7F13_5B58_8868 = {}
local _____5168_5C40_8FD0_884C_4EE3_6B21 = 0
local function _____83B7_53D6_53E5_67C4ID(handle)
    if handle == nil or handle == 0 then
        return 0
    end
    return GetHandleId(handle) or 0
end
local function _____83B7_53D6_6709_5E8F_53E5_67C4ID_5217_8868(____table)
    local result = {}
    local keys = __TS__ObjectKeys(____table)
    do
        local i = 0
        while i < #keys do
            local handleId = __TS__Number(keys[i + 1]) or 0
            if handleId > 0 and ____table[handleId] ~= nil then
                result[#result + 1] = handleId
            end
            i = i + 1
        end
    end
    do
        local i = 1
        while i < #result do
            local current = result[i + 1]
            local insertIndex = i - 1
            while insertIndex >= 0 and result[insertIndex + 1] > current do
                result[insertIndex + 1 + 1] = result[insertIndex + 1]
                insertIndex = insertIndex - 1
            end
            result[insertIndex + 1 + 1] = current
            i = i + 1
        end
    end
    return result
end
____exports["创建Boss战运行上下文"] = function(bossUnit, _____5730_70B9_77E9_5F62, _____6218_6597_97F3_4E50, _____80DC_5229_97F3_4E50, _____5730_70B9_77E9_5F62_662F_5426_52A8_6001)
    if _____5730_70B9_77E9_5F62_662F_5426_52A8_6001 == nil then
        _____5730_70B9_77E9_5F62_662F_5426_52A8_6001 = false
    end
    local bossHandleId = _____83B7_53D6_53E5_67C4ID(bossUnit)
    if bossHandleId == 0 then
        return nil
    end
    _____5168_5C40_8FD0_884C_4EE3_6B21 = _____5168_5C40_8FD0_884C_4EE3_6B21 + 1
    return {
        ["Boss单位"] = bossUnit,
        ["Boss句柄ID"] = bossHandleId,
        ["地点矩形"] = _____5730_70B9_77E9_5F62,
        ["地点句柄ID"] = _____83B7_53D6_53E5_67C4ID(_____5730_70B9_77E9_5F62),
        ["地点矩形是否动态"] = _____5730_70B9_77E9_5F62_662F_5426_52A8_6001,
        ["战斗音乐"] = _____6218_6597_97F3_4E50,
        ["胜利音乐"] = _____80DC_5229_97F3_4E50,
        ["运行代次"] = _____5168_5C40_8FD0_884C_4EE3_6B21,
        ["启动时间"] = getServerTime(),
        ["是否已激活"] = false,
        ["等待激活截止时间"] = 0,
        ["转场提示时间"] = 0,
        ["下次兜底搜敌时间"] = 0,
        ["胜利音乐移除时间"] = 0,
        ["是否已结束"] = false
    }
end
____exports["记录Boss战运行上下文"] = function(context)
    _____6309Boss_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868[context["Boss句柄ID"]] = context
    if context["地点句柄ID"] > 0 then
        _____6309_77E9_5F62_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868[context["地点句柄ID"]] = context
    end
end
____exports["读取Boss战运行上下文"] = function(bossUnit)
    return _____6309Boss_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868[_____83B7_53D6_53E5_67C4ID(bossUnit)]
end
____exports["获取全部Boss战运行上下文"] = function()
    local result = {}
    local handleIds = _____83B7_53D6_6709_5E8F_53E5_67C4ID_5217_8868(_____6309Boss_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868)
    do
        local i = 0
        while i < #handleIds do
            local context = _____6309Boss_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868[handleIds[i + 1]]
            if context ~= nil then
                result[#result + 1] = context
            end
            i = i + 1
        end
    end
    return result
end
--- 返回最近启动且尚未结束的 TS Boss 战。
____exports["读取当前Boss战运行上下文"] = function()
    local contexts = ____exports["获取全部Boss战运行上下文"]()
    local current
    do
        local i = 0
        while i < #contexts do
            do
                local context = contexts[i + 1]
                if context == nil or context["是否已结束"] then
                    goto __continue22
                end
                if current == nil or context["运行代次"] > current["运行代次"] then
                    current = context
                end
            end
            ::__continue22::
            i = i + 1
        end
    end
    return current
end
____exports["读取当前Boss战运行单位"] = function()
    local context = ____exports["读取当前Boss战运行上下文"]()
    local ____temp_0
    if context == nil then
        ____temp_0 = nil
    else
        ____temp_0 = context["Boss单位"]
    end
    return ____temp_0
end
____exports["清理Boss战运行上下文"] = function(bossUnit)
    local bossHandleId = _____83B7_53D6_53E5_67C4ID(bossUnit)
    if bossHandleId == 0 then
        return
    end
    local context = _____6309Boss_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868[bossHandleId]
    _____6309Boss_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868[bossHandleId] = nil
    if context ~= nil then
        ____exports["清理矩形当前Boss战上下文"](context["地点句柄ID"], context["运行代次"])
    end
end
____exports["读取矩形当前Boss战上下文"] = function(rectHandleId)
    if rectHandleId == 0 then
        return nil
    end
    return _____6309_77E9_5F62_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868[rectHandleId]
end
____exports["设置矩形当前Boss战上下文"] = function(rectHandleId, context)
    if rectHandleId == 0 then
        return
    end
    _____6309_77E9_5F62_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868[rectHandleId] = context
end
____exports["获取全部矩形当前Boss战上下文"] = function()
    local result = {}
    local handleIds = _____83B7_53D6_6709_5E8F_53E5_67C4ID_5217_8868(_____6309_77E9_5F62_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868)
    do
        local i = 0
        while i < #handleIds do
            local context = _____6309_77E9_5F62_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868[handleIds[i + 1]]
            if context ~= nil then
                result[#result + 1] = context
            end
            i = i + 1
        end
    end
    return result
end
____exports["读取矩形玩家可见度修整器"] = function(rectHandleId, playerId)
    if rectHandleId == 0 or playerId < 0 then
        return nil
    end
    local playerMap = _____77E9_5F62_73A9_5BB6_53EF_89C1_5EA6_7F13_5B58_8868[rectHandleId]
    if playerMap == nil then
        return nil
    end
    return playerMap[playerId]
end
____exports["记录矩形玩家可见度修整器"] = function(rectHandleId, playerId, fogModifier)
    if rectHandleId == 0 or playerId < 0 or fogModifier == nil or fogModifier == 0 then
        return
    end
    local playerMap = _____77E9_5F62_73A9_5BB6_53EF_89C1_5EA6_7F13_5B58_8868[rectHandleId]
    if playerMap == nil then
        playerMap = {}
        _____77E9_5F62_73A9_5BB6_53EF_89C1_5EA6_7F13_5B58_8868[rectHandleId] = playerMap
    end
    playerMap[playerId] = fogModifier
end
____exports["当前是否存在Boss战运行上下文"] = function()
    local handleIds = _____83B7_53D6_6709_5E8F_53E5_67C4ID_5217_8868(_____6309Boss_53E5_67C4_7D22_5F15_7684_8FD0_884C_4E0A_4E0B_6587_8868)
    return #handleIds > 0
end
return ____exports
