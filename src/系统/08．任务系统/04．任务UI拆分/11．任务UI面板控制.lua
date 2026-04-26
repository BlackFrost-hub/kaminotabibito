--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.08．任务系统.02．任务管理器.index")
local questManager = ____index.questManager
function ____exports.registerTaskUIRefreshCallback(self, rebuildPages)
    if not questManager or type(questManager.registerUIRefreshCallback) ~= "function" then
        return
    end
    questManager:registerUIRefreshCallback(function(____, _playerId, _questId)
        pcall(function () return rebuildPages(nil) end
        )
    end)
end
return ____exports
