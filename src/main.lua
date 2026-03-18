--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local runtime = require("jass.runtime")
runtime.console = true
local jassConsole = require("jass.console")
require("jass.japi");
(function()
    local g = _G
    local japi = nil
    do
        local function ____catch(_e)
            japi = nil
        end
        local ____try, ____hasReturned = pcall(function()
            japi = require("jass.japi")
        end)
        if not ____try then
            ____catch(____hasReturned)
        end
    end
    if not japi then
        return
    end
    for k in pairs(japi) do
        do
            local __continue6
            repeat
                if type(k) ~= "string" then
                    __continue6 = true
                    break
                end
                if (string.find(k, "Dz", nil, true) or 0) - 1 ~= 0 then
                    __continue6 = true
                    break
                end
                local v = japi[k]
                if type(v) ~= "function" then
                    __continue6 = true
                    break
                end
                if type(g[k]) == "function" then
                    __continue6 = true
                    break
                end
                g[k] = v
                __continue6 = true
            until true
            if not __continue6 then
                break
            end
        end
    end
end)(nil)
local jass = require("jass.common")
local g = require("jass.globals")
local slk = require("jass.slk")
_G.slk = slk
if g.YDUserDataGet2 and not jass.YDUserDataGet2 then
    jass.YDUserDataGet2 = g.YDUserDataGet2
end
if g.YDUserDataGet and not jass.YDUserDataGet then
    jass.YDUserDataGet = g.YDUserDataGet
end
if g.Ir_GetUnitAttackType and not jass.Ir_GetUnitAttackType then
    jass.Ir_GetUnitAttackType = g.Ir_GetUnitAttackType
end
if g.Ir_SetUnitAttackType and not jass.Ir_SetUnitAttackType then
    jass.Ir_SetUnitAttackType = g.Ir_SetUnitAttackType
end
_G.print = function(...)
    local args = {...}
    local str = ""
    do
        local i = 0
        while i < #args do
            str = str .. tostring(args[i + 1])
            if i < #args - 1 then
                str = str .. "\t"
            end
            i = i + 1
        end
    end
    jassConsole.write(str .. "\n")
end
require("系统.装备.装备提取")
require("系统.装备.装备掉落")
require("系统.单位.单位狂暴")
require("系统.装备.装备限制")
require("系统.00_核心.封装函数")
require("系统.00_核心.音效函数")
require("系统.00_核心.漂浮文字函数")
require("系统.00_核心.硬件函数")
require("系统.00_核心.泄露审计")
require("系统.07_任务.任务接受")
require("系统.07_任务.任务完成")
require("系统.测试.测试事件")
require("系统.测试.测试事件2")
require("系统.测试.测试233注册")
local ok, err = pcall(function () return require("系统.装备.装备系统") end
    )
if not ok then
    _G.print(
        "装备系统加载失败:",
        tostring(err)
    )
end
require("系统.装备.装备移速")
require("系统.装备.装备回复")
require("系统.装备.装备成长")
require("系统.装备.物品加工")
require("系统.伤害.伤害事件")
require("系统.伤害.伤害测试")
require("系统.伤害.dot伤害")
local _____533A_57DF_4F20_9001 = require("系统.地形.区域传送")
if type(_____533A_57DF_4F20_9001["init区域传送"]) == "function" then
    _____533A_57DF_4F20_9001["init区域传送"](_____533A_57DF_4F20_9001)
end
local _____6FC0_6D3B_4F20_9001_70B9 = require("系统.地形.激活传送点")
if type(_____6FC0_6D3B_4F20_9001_70B9["init激活传送点"]) == "function" then
    _____6FC0_6D3B_4F20_9001_70B9["init激活传送点"](_____6FC0_6D3B_4F20_9001_70B9)
end
return ____exports
