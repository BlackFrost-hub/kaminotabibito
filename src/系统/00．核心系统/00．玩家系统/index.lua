--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 玩家系统 - 统一初始化入口
local mgr = require("系统.00．核心系统.00．玩家系统.01．玩家单位管理器")
if type(mgr.initPlayerUnitManager) == "function" then
    mgr:initPlayerUnitManager()
end
return ____exports
