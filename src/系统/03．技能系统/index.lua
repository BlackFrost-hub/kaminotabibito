--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.03．技能系统.01．显示技能名字")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.02．显示技能名字2")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local _____663E_793A_6280_80FD_540D_5B57 = require("系统.03．技能系统.01．显示技能名字")
if type(_____663E_793A_6280_80FD_540D_5B57.initShowSkillName) == "function" then
    _____663E_793A_6280_80FD_540D_5B57:initShowSkillName()
end
local _____663E_793A_6280_80FD_540D_5B572 = require("系统.03．技能系统.02．显示技能名字2")
if type(_____663E_793A_6280_80FD_540D_5B572.initShowSkillName2) == "function" then
    _____663E_793A_6280_80FD_540D_5B572:initShowSkillName2()
end
--- 初始化技能系统
function ____exports.init(self)
    local p = _G.print
    if type(p) == "function" then
        p(nil, "[技能系统] 初始化完成")
    end
end
return ____exports
