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
local jglobals = require("jass.globals")
local slk = require("jass.slk")
_G.slk = slk
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
require("系统.00．核心系统.00．核心系统入口")
require("系统.00．核心系统.06．UI函数")
require("lib.扩展函数.00．扩展函数入口")
require("系统.01．单位系统.单位狂暴")
require("系统.02．物品系统.00．物品系统入口")
local _____663E_793A_6280_80FD_540D_5B57 = require("系统.03．技能系统.01．显示技能名字")
if type(_____663E_793A_6280_80FD_540D_5B57.initShowSkillName) == "function" then
    _____663E_793A_6280_80FD_540D_5B57:initShowSkillName()
end
require("系统.04．伤害系统.01．伤害事件")
require("系统.04．伤害系统.02．DOT定义.00．DOT定义入口")
require("系统.04．伤害系统.02．dot伤害")
require("系统.04．伤害系统.03．伤害测试")
local buffPoolCore = require("系统.05．Buff系统.00．Buff系统")
if type(buffPoolCore.initBuffSystem) == "function" then
    buffPoolCore:initBuffSystem()
end
require("系统.05．Buff系统.03．BuffJASS桥接")
local _____533A_57DF_4F20_9001 = require("系统.07．地形系统.03．区域传送")
if type(_____533A_57DF_4F20_9001["init区域传送"]) == "function" then
    _____533A_57DF_4F20_9001["init区域传送"](_____533A_57DF_4F20_9001)
end
local _____6FC0_6D3B_4F20_9001_70B9 = require("系统.07．地形系统.05．激活传送点")
if type(_____6FC0_6D3B_4F20_9001_70B9["init激活传送点"]) == "function" then
    _____6FC0_6D3B_4F20_9001_70B9["init激活传送点"](_____6FC0_6D3B_4F20_9001_70B9)
end
local _____4EFB_52A1_7BA1_7406_5668 = require("系统.08．任务系统.02．任务管理器")
if type(_____4EFB_52A1_7BA1_7406_5668.init) == "function" then
    _____4EFB_52A1_7BA1_7406_5668:init()
end
require("系统.08．任务系统.05．任务STES桥接")
require("系统.08．任务系统.06．任务事件桥接")
require("系统.08．任务系统.08．任务目标更新")
require("系统.08．任务系统.10．主线配置驱动")
local _____539F_751FUI = require("系统.09．表现系统.00．初始化UI")
if type(_____539F_751FUI.initNativeUI) == "function" then
    _____539F_751FUI:initNativeUI()
end
require("系统.09．表现系统.01．UI工具.index")
require("系统.09．表现系统.02．垂直滚动条轨道")
require("系统.09．表现系统.02．对话框系统入口.00．对话框系统入口")
require("系统.08．任务系统.03．任务UI拆分.00．任务UI拆分入口")
local _____4EFB_52A1UI = require("系统.08．任务系统.03．任务UI")
if type(_____4EFB_52A1UI.init) == "function" then
    _____4EFB_52A1UI:init()
end
if type(_____4EFB_52A1UI.registerHotkey) == "function" then
    _____4EFB_52A1UI:registerHotkey()
end
local buffUI = require("系统.05．Buff系统.02．BuffUI")
if type(buffUI.init) == "function" then
    buffUI:init()
end
require("系统.12．测试系统.测试事件")
require("系统.12．测试系统.测试事件2")
require("系统.12．测试系统.测试233注册")
require("系统.12．测试系统.任务测试")
require("系统.12．测试系统.任意测试")
require("系统.12．测试系统.任意测试2")
return ____exports
