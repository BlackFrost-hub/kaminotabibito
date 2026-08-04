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
local ____require_result_0 = require("系统.01．单位系统.03．怪物刷新系统.02．怪物刷新核心")
local _____521D_59CB_5316_602A_7269_5237_65B0_7CFB_7EDF = ____require_result_0["初始化怪物刷新系统"]
local ____require_result_1 = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.index")
local _____542F_7528_4E16_754C_5730_56FE_5355_4F4DTS_521D_59CB_5316 = ____require_result_1["启用世界地图单位TS初始化"]
local _____542F_52A8_4E16_754C_5730_56FE_5168_90E8_5355_4F4D_7F13_6B65_521B_5EFA = ____require_result_1["启动世界地图全部单位缓步创建"]
local _____83B7_53D6_4E16_754C_5730_56FE_5168_90E8_5355_4F4D_521B_5EFA_72B6_6001 = ____require_result_1["获取世界地图全部单位创建状态"]
local _____521D_59CB_5316_4E16_754C_5730_56FE_4E2D_7ACB_751F_7269 = ____require_result_1["初始化世界地图中立生物"]
local _____521D_59CB_5316_4E16_754C_5730_56FE_690D_7269 = ____require_result_1["初始化世界地图植物"]
local _____521D_59CB_5316_4E16_754C_5730_56FE_5F02_754C_63CF_8FF0_77F3 = ____require_result_1["初始化世界地图异界描述石"]
local _____5EF6_8FDF_521D_59CB_5316_4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C = ____require_result_1["延迟初始化世界地图Boss初始注册"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
local removePeriodicCallback = ____require_result_2.removePeriodicCallback
local _____4E16_754C_5730_56FE_6742_9C7C_7CBE_82F1_521B_5EFA_5DF2_5B8C_6210 = false
local _____602A_7269_5237_65B0_7CFB_7EDF_5DF2_521D_59CB_5316 = false
local _____5237_602A_521D_59CB_5316_7B49_5F85_56DE_8C03ID
local _____5176_4ED6_4E16_754C_5730_56FE_914D_7F6E_5DF2_521D_59CB_5316 = false
local function _____521D_59CB_5316_5176_4ED6_4E16_754C_5730_56FE_914D_7F6E()
    if _____5176_4ED6_4E16_754C_5730_56FE_914D_7F6E_5DF2_521D_59CB_5316 then
        return
    end
    _____5176_4ED6_4E16_754C_5730_56FE_914D_7F6E_5DF2_521D_59CB_5316 = true
    if type(_____521D_59CB_5316_4E16_754C_5730_56FE_4E2D_7ACB_751F_7269) == "function" then
        _____521D_59CB_5316_4E16_754C_5730_56FE_4E2D_7ACB_751F_7269()
    end
    if type(_____521D_59CB_5316_4E16_754C_5730_56FE_690D_7269) == "function" then
        _____521D_59CB_5316_4E16_754C_5730_56FE_690D_7269()
    end
    if type(_____521D_59CB_5316_4E16_754C_5730_56FE_5F02_754C_63CF_8FF0_77F3) == "function" then
        _____521D_59CB_5316_4E16_754C_5730_56FE_5F02_754C_63CF_8FF0_77F3()
    end
end
local function _____5C1D_8BD5_521D_59CB_5316_602A_7269_5237_65B0_7CFB_7EDF()
    if _____602A_7269_5237_65B0_7CFB_7EDF_5DF2_521D_59CB_5316 then
        return
    end
    if _____542F_7528_4E16_754C_5730_56FE_5355_4F4DTS_521D_59CB_5316 == true and not _____4E16_754C_5730_56FE_6742_9C7C_7CBE_82F1_521B_5EFA_5DF2_5B8C_6210 then
        return
    end
    _____602A_7269_5237_65B0_7CFB_7EDF_5DF2_521D_59CB_5316 = true
    _____521D_59CB_5316_602A_7269_5237_65B0_7CFB_7EDF()
end
local function _____505C_6B62_7B49_5F85_6742_9C7C_7CBE_82F1_521B_5EFA_5B8C_6210()
    if _____5237_602A_521D_59CB_5316_7B49_5F85_56DE_8C03ID == nil then
        return
    end
    removePeriodicCallback(_____5237_602A_521D_59CB_5316_7B49_5F85_56DE_8C03ID)
    _____5237_602A_521D_59CB_5316_7B49_5F85_56DE_8C03ID = nil
end
local function ____on_4E16_754C_5730_56FE_6742_9C7C_7CBE_82F1_521B_5EFA_5B8C_6210()
    if _____4E16_754C_5730_56FE_6742_9C7C_7CBE_82F1_521B_5EFA_5DF2_5B8C_6210 then
        return
    end
    _____4E16_754C_5730_56FE_6742_9C7C_7CBE_82F1_521B_5EFA_5DF2_5B8C_6210 = true
    _____505C_6B62_7B49_5F85_6742_9C7C_7CBE_82F1_521B_5EFA_5B8C_6210()
    _____5C1D_8BD5_521D_59CB_5316_602A_7269_5237_65B0_7CFB_7EDF()
end
local function ____on_68C0_67E5_4E16_754C_5730_56FE_6742_9C7C_7CBE_82F1_521B_5EFA_72B6_6001()
    if type(_____83B7_53D6_4E16_754C_5730_56FE_5168_90E8_5355_4F4D_521B_5EFA_72B6_6001) ~= "function" then
        return
    end
    local _____72B6_6001 = _____83B7_53D6_4E16_754C_5730_56FE_5168_90E8_5355_4F4D_521B_5EFA_72B6_6001()
    if _____72B6_6001["当前阶段"] == "未启动" or _____72B6_6001["当前阶段"] == "杂鱼" or _____72B6_6001["当前阶段"] == "杂鱼+精英" then
        return
    end
    ____on_4E16_754C_5730_56FE_6742_9C7C_7CBE_82F1_521B_5EFA_5B8C_6210()
end
--- 初始化单位创建
function ____exports.init(self)
    if _____542F_7528_4E16_754C_5730_56FE_5355_4F4DTS_521D_59CB_5316 ~= true then
        _____5C1D_8BD5_521D_59CB_5316_602A_7269_5237_65B0_7CFB_7EDF()
        return
    end
    if type(_____542F_52A8_4E16_754C_5730_56FE_5168_90E8_5355_4F4D_7F13_6B65_521B_5EFA) == "function" then
        _____542F_52A8_4E16_754C_5730_56FE_5168_90E8_5355_4F4D_7F13_6B65_521B_5EFA({["完成回调"] = ____on_4E16_754C_5730_56FE_6742_9C7C_7CBE_82F1_521B_5EFA_5B8C_6210})
        _____5237_602A_521D_59CB_5316_7B49_5F85_56DE_8C03ID = addPeriodicCallback(100, ____on_68C0_67E5_4E16_754C_5730_56FE_6742_9C7C_7CBE_82F1_521B_5EFA_72B6_6001)
    else
        _____4E16_754C_5730_56FE_6742_9C7C_7CBE_82F1_521B_5EFA_5DF2_5B8C_6210 = true
    end
    _____521D_59CB_5316_5176_4ED6_4E16_754C_5730_56FE_914D_7F6E()
    if type(_____5EF6_8FDF_521D_59CB_5316_4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C) == "function" then
        _____5EF6_8FDF_521D_59CB_5316_4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C()
    end
    _____5C1D_8BD5_521D_59CB_5316_602A_7269_5237_65B0_7CFB_7EDF()
end
return ____exports
