local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____00_FF0E_652F_7EBF_4EA4_4E92_914D_7F6E = require("系统.11．剧情系统.02．支线任务.00．支线交互配置")
local _____9759_6001_652F_7EBF_4EFB_52A1_914D_7F6E_5217_8868 = ____00_FF0E_652F_7EBF_4EA4_4E92_914D_7F6E["静态支线任务配置列表"]
local ____02_FF0E_5165_53E3_914D_7F6E = require("系统.11．剧情系统.02．支线任务.02．污染之猫米亚.02．入口配置")
local _____6C61_67D3_4E4B_732B_7C73_4E9A_4EFB_52A1_914D_7F6E_5217_8868 = ____02_FF0E_5165_53E3_914D_7F6E["污染之猫米亚任务配置列表"]
local ____array_0 = __TS__SparseArrayNew(table.unpack(_____9759_6001_652F_7EBF_4EFB_52A1_914D_7F6E_5217_8868))
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(_____6C61_67D3_4E4B_732B_7C73_4E9A_4EFB_52A1_914D_7F6E_5217_8868)
)
____exports["任务配置列表"] = {__TS__SparseArraySpread(____array_0)}
____exports.default = ____exports["任务配置列表"]
return ____exports
