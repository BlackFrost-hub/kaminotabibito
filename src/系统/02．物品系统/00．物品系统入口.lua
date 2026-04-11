--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
require("系统.02．物品系统.03．物品加工")
require("系统.02．物品系统.04．装备成长")
require("系统.02．物品系统.05．装备掉落")
require("系统.02．物品系统.06．装备回复")
local ok7, err7 = pcall(function () return require("系统.02．物品系统.07．装备提取") end
    )
if not ok7 then
    _G.print(
        "装备提取加载失败:",
        tostring(err7)
    )
end
require("系统.02．物品系统.08．装备移速")
require("系统.02．物品系统.10．装备限制")
local ok, err = pcall(function () return require("系统.02．物品系统.11．装备系统") end
    )
if not ok then
    _G.print(
        "装备系统加载失败:",
        tostring(err)
    )
end
return ____exports
