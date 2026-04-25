--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.08．任务系统.02．任务管理器.index")
local questManager = ____index.questManager
local jass = require("jass.common")
local japi = require("jass.japi")
function ____exports.registerTaskUIRefreshCallback(self, rebuildPages)
    if not questManager or type(questManager.registerUIRefreshCallback) ~= "function" then
        return
    end
    questManager:registerUIRefreshCallback(function(____, _playerId, _questId)
        pcall(function () return rebuildPages(nil) end
        )
    end)
end
function ____exports.showTaskUITabTooltip(self, msg)
    local ____temp_0
    if type(japi.DzGetTriggerUIEventPlayer) == "function" then
        ____temp_0 = japi.DzGetTriggerUIEventPlayer()
    else
        ____temp_0 = nil
    end
    local p = ____temp_0
    if p then
        jass.DisplayTextToPlayer(p, 0, 0, msg)
    end
end
return ____exports
