--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.03．技能系统.06．AI自动使用技能.00．常量定义")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
--- 保留给技能系统总入口调用的占位初始化函数。
-- 新 Boss 自动通魔 AI 实现后，在这里接入真实初始化。
function ____exports.init()
end
return ____exports
