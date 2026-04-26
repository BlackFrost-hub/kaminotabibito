--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local runtime = require("jass.runtime")
runtime.console = true
runtime.handle_level = 0
local jassConsole = require("jass.console")
require("jass.japi")
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
local _____6838_5FC3_7CFB_7EDF = require("系统.00．核心系统.index")
if type(_____6838_5FC3_7CFB_7EDF.init) == "function" then
    _____6838_5FC3_7CFB_7EDF:init()
end
local _____6269_5C55_51FD_6570 = require("lib.扩展函数.index")
if type(_____6269_5C55_51FD_6570.init) == "function" then
    _____6269_5C55_51FD_6570:init()
end
local _____5355_4F4D_7CFB_7EDF = require("系统.01．单位系统.index")
if type(_____5355_4F4D_7CFB_7EDF.init) == "function" then
    _____5355_4F4D_7CFB_7EDF:init()
end
local _____7269_54C1_7CFB_7EDF = require("系统.02．物品系统.index")
if type(_____7269_54C1_7CFB_7EDF.init) == "function" then
    _____7269_54C1_7CFB_7EDF:init()
end
local _____6280_80FD_7CFB_7EDF = require("系统.03．技能系统.index")
if type(_____6280_80FD_7CFB_7EDF.init) == "function" then
    _____6280_80FD_7CFB_7EDF:init()
end
local _____4F24_5BB3_7CFB_7EDF = require("系统.04．伤害系统.index")
if type(_____4F24_5BB3_7CFB_7EDF.init) == "function" then
    _____4F24_5BB3_7CFB_7EDF:init()
end
local _____5730_5F62_7CFB_7EDF = require("系统.07．地形系统.index")
if type(_____5730_5F62_7CFB_7EDF.init) == "function" then
    _____5730_5F62_7CFB_7EDF:init()
end
local _____7ECF_6D4E_7CFB_7EDF = require("系统.06．经济系统.index")
if type(_____7ECF_6D4E_7CFB_7EDF.init) == "function" then
    _____7ECF_6D4E_7CFB_7EDF:init()
end
local _____4EFB_52A1_7CFB_7EDF = require("系统.08．任务系统.10．index")
if type(_____4EFB_52A1_7CFB_7EDF.init) == "function" then
    _____4EFB_52A1_7CFB_7EDF:init()
end
local _____8868_73B0_7CFB_7EDF = require("系统.09．表现系统.index")
if type(_____8868_73B0_7CFB_7EDF.init) == "function" then
    _____8868_73B0_7CFB_7EDF:init()
end
require("系统.12．测试系统.index")
return ____exports
