local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____00_FF0E_6280_80FD_914D_7F6E = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.00．技能配置")
local _____6742_9C7C_6280_80FD_914D_7F6E_8868 = ____00_FF0E_6280_80FD_914D_7F6E["杂鱼技能配置表"]
local ____00_FF0E_6280_80FD_914D_7F6E = require("系统.03．技能系统.05．单位技能.02．精英技能.00．技能配置")
local _____7CBE_82F1_6280_80FD_914D_7F6E_8868 = ____00_FF0E_6280_80FD_914D_7F6E["精英技能配置表"]
local ____00_FF0E_6280_80FD_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.00．技能配置")
local _____82F1_96C4_6280_80FD_914D_7F6E_8868 = ____00_FF0E_6280_80FD_914D_7F6E["英雄技能配置表"]
local ____01_FF0E_6280_80FD_914D_7F6E_5DE5_5177 = require("系统.03．技能系统.05．单位技能.00．公共.01．技能配置工具")
local _____6784_5EFA_5355_4F4D_6280_80FD_914D_7F6E_7D22_5F15 = ____01_FF0E_6280_80FD_914D_7F6E_5DE5_5177["构建单位技能配置索引"]
local ____array_0 = __TS__SparseArrayNew(table.unpack(_____6742_9C7C_6280_80FD_914D_7F6E_8868))
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(_____7CBE_82F1_6280_80FD_914D_7F6E_8868)
)
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(_____82F1_96C4_6280_80FD_914D_7F6E_8868)
)
____exports["全部单位技能配置表"] = {__TS__SparseArraySpread(____array_0)}
____exports["全部单位技能配置索引"] = _____6784_5EFA_5355_4F4D_6280_80FD_914D_7F6E_7D22_5F15(____exports["全部单位技能配置表"])
return ____exports
