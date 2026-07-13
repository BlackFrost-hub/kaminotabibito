local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____01_FF0EBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.01．Boss战斗启动属性配置表.index")
local ____Boss_5206_7C7B_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868 = ____01_FF0EBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868["Boss分类战斗启动护卫配置表"]
local ____02_FF0E_82F1_96C4Boss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.02．英雄Boss战斗启动属性配置表.index")
local _____82F1_96C4Boss_5206_7C7B_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868 = ____02_FF0E_82F1_96C4Boss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868["英雄Boss分类战斗启动护卫配置表"]
local ____03_FF0E_5F02_754CBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.03．异界Boss战斗启动属性配置表.index")
local _____5F02_754CBoss_5206_7C7B_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868 = ____03_FF0E_5F02_754CBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868["异界Boss分类战斗启动护卫配置表"]
local ____array_0 = __TS__SparseArrayNew(table.unpack(____Boss_5206_7C7B_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868))
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(_____82F1_96C4Boss_5206_7C7B_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868)
)
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(_____5F02_754CBoss_5206_7C7B_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868)
)
____exports["Boss战斗启动护卫配置表"] = {__TS__SparseArraySpread(____array_0)}
return ____exports
