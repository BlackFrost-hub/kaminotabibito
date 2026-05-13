--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_7C7B_578B_5B9A_4E49 = require("系统.09．表现系统.01．UI工具.00．类型定义")
local FrameType = ____00_FF0E_7C7B_578B_5B9A_4E49.FrameType
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_0.debugLog
local __safeFrame = 0
local __safeVisible = false
local __safeAlpha = 0
local __safeLevel = 0
local __safeTocPath = ""
local function __safeShowFramePcallBody(self)
    japi:DzFrameShow(__safeFrame, __safeVisible)
end
local function __safeSetEnableFalsePcallBody(self)
    japi:DzFrameSetEnable(__safeFrame, false)
end
local function __safeSetAlphaPcallBody(self)
    japi:DzFrameSetAlpha(__safeFrame, __safeAlpha)
end
local function __safeSetLevelPcallBody(self)
    japi:DzFrameSetPriority(__safeFrame, __safeLevel)
end
local function __safeLoadTocPcallBody(self)
    japi:DzLoadToc(__safeTocPath)
end
function ____exports.createFrame(self, config)
    local ____config_1 = config
    local ____type = ____config_1.type
    local name = ____config_1.name
    local parent = ____config_1.parent
    if parent == nil then
        parent = 0
    end
    local template = ____config_1.template
    if template == nil then
        template = "template"
    end
    local id = ____config_1.id
    if id == nil then
        id = 0
    end
    if ____type == FrameType.SIMPLEFRAME then
        return nil
    end
    local frame = japi:DzCreateFrameByTagName(
        ____type,
        name,
        parent,
        template,
        id
    )
    if frame == nil or frame == 0 then
        return nil
    end
    if config.visible ~= nil then
        __safeFrame = frame
        __safeVisible = config.visible
        pcall(__safeShowFramePcallBody)
    end
    if config.enable == false then
        __safeFrame = frame
        pcall(__safeSetEnableFalsePcallBody)
    end
    if config.alpha ~= nil then
        __safeFrame = frame
        __safeAlpha = config.alpha
        pcall(__safeSetAlphaPcallBody)
    end
    if config.level ~= nil then
        __safeFrame = frame
        __safeLevel = config.level
        pcall(__safeSetLevelPcallBody)
    end
    return frame
end
local __tocLoadedOnce = {}
function ____exports.loadTocOnce(self, tocLoadKey, tocPaths, debugPrefix)
    if debugPrefix == nil then
        debugPrefix = "UI"
    end
    if __tocLoadedOnce[tocLoadKey] then
        return
    end
    __tocLoadedOnce[tocLoadKey] = true
    for ____, p in ipairs(tocPaths) do
        __safeTocPath = p
        local ok = pcall(__safeLoadTocPcallBody)
        if not ok then
            debugLog(nil, debugPrefix, "DzLoadToc fail:", p)
        end
    end
end
local __fdfSafeFrameName = ""
local __fdfSafeParent = 0
local __fdfSafeContextId = 0
local __fdfSafeOutFrame = 0
local function __fdfSafeCreateFramePcallBody(self)
    __fdfSafeOutFrame = japi:DzCreateFrame(__fdfSafeFrameName, __fdfSafeParent, __fdfSafeContextId)
end
function ____exports.tryCreateFromFdfSafe(self, frameName, parent, fallback, opts)
    ____exports.loadTocOnce(nil, opts.tocLoadKey, opts.tocPaths, opts.debugPrefix or "UI")
    __fdfSafeFrameName = frameName
    __fdfSafeParent = parent
    __fdfSafeContextId = opts.contextId or 0
    local ok = pcall(__fdfSafeCreateFramePcallBody)
    local f = __fdfSafeOutFrame
    if ok and f ~= nil and f ~= 0 then
        return f
    end
    return fallback(nil)
end
return ____exports
