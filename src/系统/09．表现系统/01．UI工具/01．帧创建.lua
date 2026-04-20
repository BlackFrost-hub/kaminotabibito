--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_7C7B_578B_5B9A_4E49 = require("系统.09．表现系统.01．UI工具.00．类型定义")
local FrameType = ____00_FF0E_7C7B_578B_5B9A_4E49.FrameType
local japi = require("jass.japi")
function ____exports.createFrame(self, config)
    local ____config_0 = config
    local ____type = ____config_0.type
    local name = ____config_0.name
    local parent = ____config_0.parent
    if parent == nil then
        parent = 0
    end
    local template = ____config_0.template
    if template == nil then
        template = "template"
    end
    local id = ____config_0.id
    if id == nil then
        id = 0
    end
    if ____type == FrameType.SIMPLEFRAME then
        return nil
    end
    local frame = japi.DzCreateFrameByTagName(
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
        pcall(function () return japi.DzFrameShow(frame, config.visible) end
        )
    end
    if config.enable == false then
        pcall(function () return japi.DzFrameSetEnable(frame, false) end
        )
    end
    if config.alpha ~= nil then
        pcall(function () return japi.DzFrameSetAlpha(frame, config.alpha) end
        )
    end
    if config.level ~= nil then
        pcall(function () return japi.DzFrameSetLevel(frame, config.level) end
        )
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
        local ok = pcall(function () return japi.DzLoadToc(p) end
        )
        if not ok then
            local pr = _G.print
            pr((("[" .. debugPrefix) .. "] DzLoadToc fail: ") .. p)
        end
    end
end
function ____exports.tryCreateFromFdfSafe(self, frameName, parent, fallback, opts)
    ____exports.loadTocOnce(nil, opts.tocLoadKey, opts.tocPaths, opts.debugPrefix or "UI")
    local f = 0
    local ok = pcall(function ()
            f = japi.DzCreateFrame(frameName, parent, 0)
        end
    )
    if ok and f ~= nil and f ~= 0 then
        return f
    end
    return fallback(nil)
end
return ____exports
