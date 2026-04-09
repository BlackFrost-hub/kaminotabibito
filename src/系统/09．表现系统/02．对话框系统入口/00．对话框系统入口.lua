--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____NPC_751F_6210_5668 = require("系统.08．任务系统.00．配置表.04．NPC生成器")
if type(____NPC_751F_6210_5668.init) == "function" then
    ____NPC_751F_6210_5668:init()
end
require("系统.09．表现系统.04．NPC对话状态池")
local _____5BF9_8BDD_6846UI = require("系统.09．表现系统.03．对话框系统.00．对话框UI入口")
if type(_____5BF9_8BDD_6846UI.initDialogSystem) == "function" then
    _____5BF9_8BDD_6846UI:initDialogSystem()
end
do
    local ____export = require("系统.09．表现系统.02．对话框系统入口.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
return ____exports
