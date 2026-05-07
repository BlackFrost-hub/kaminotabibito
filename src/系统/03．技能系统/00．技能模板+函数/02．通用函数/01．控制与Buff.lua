--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local GS_Suspend = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_Suspend
local GS_IsUnitSuspending = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_IsUnitSuspending
local GS_LoadSuspend = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_LoadSuspend
local GS_UnitSuspend = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_UnitSuspend
local ____04_FF0E_5FEB_901FBuff_7CFB_7EDF = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local SFB_Init = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_Init
local SFB_setBuff = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setBuff
local SFB_setSlow = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setSlow
do
    local ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
    ____exports.GS_Suspend = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_Suspend
    ____exports.GS_IsUnitSuspending = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_IsUnitSuspending
    ____exports.GS_LoadSuspend = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_LoadSuspend
    ____exports.GS_UnitSuspend = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_UnitSuspend
end
do
    local ____04_FF0E_5FEB_901FBuff_7CFB_7EDF = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
    ____exports.SFB_Init = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_Init
    ____exports.SFB_setBuff = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setBuff
    ____exports.SFB_setSlow = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setSlow
end
____exports["开始硬直"] = GS_Suspend
____exports["单位是否硬直中"] = GS_IsUnitSuspending
____exports["获取单位硬直剩余时间"] = GS_LoadSuspend
____exports["调整单位硬直时间"] = GS_UnitSuspend
____exports["初始化快速Buff系统"] = SFB_Init
____exports["施加快速控制Buff"] = SFB_setBuff
____exports["施加快速减速Buff"] = SFB_setSlow
return ____exports
