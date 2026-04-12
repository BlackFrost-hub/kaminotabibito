--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.01．单位系统.00．单位初始化创建.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.01．单位系统.单位狂暴")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
require("系统.01．单位系统.00．单位初始化创建.index")
require("系统.01．单位系统.单位狂暴")
--- 初始化单位系统
function ____exports.init(self)
    local p = _G.print
    if type(p) == "function" then
        p(nil, "[单位系统] 初始化完成")
    end
end
return ____exports
