--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local _____82F1_96C4_5347_7EA7_7CFB_7EDF = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.index")
if type(_____82F1_96C4_5347_7EA7_7CFB_7EDF.init) == "function" then
    _____82F1_96C4_5347_7EA7_7CFB_7EDF:init()
end
local ____require_result_0 = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.index")
local _____542F_7528_4E16_754C_5730_56FE_5355_4F4DTS_521D_59CB_5316 = ____require_result_0["启用世界地图单位TS初始化"]
local _____542F_52A8_4E16_754C_5730_56FE_5168_90E8_5355_4F4D_7F13_6B65_521B_5EFA = ____require_result_0["启动世界地图全部单位缓步创建"]
local _____5EF6_8FDF_521D_59CB_5316_4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C = ____require_result_0["延迟初始化世界地图Boss初始注册"]
--- 初始化单位创建
function ____exports.init(self)
    if _____542F_7528_4E16_754C_5730_56FE_5355_4F4DTS_521D_59CB_5316 ~= true then
        return
    end
    if type(_____542F_52A8_4E16_754C_5730_56FE_5168_90E8_5355_4F4D_7F13_6B65_521B_5EFA) == "function" then
        _____542F_52A8_4E16_754C_5730_56FE_5168_90E8_5355_4F4D_7F13_6B65_521B_5EFA()
    end
    if type(_____5EF6_8FDF_521D_59CB_5316_4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C) == "function" then
        _____5EF6_8FDF_521D_59CB_5316_4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C()
    end
end
return ____exports
