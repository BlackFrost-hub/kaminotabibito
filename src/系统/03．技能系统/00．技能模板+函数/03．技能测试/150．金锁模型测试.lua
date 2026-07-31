--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_2.EC_CreateEffect
local ____require_result_3 = require("lib.扩展函数.BJ函数.12．数学函数")
local CosBJ = ____require_result_3.CosBJ
local SinBJ = ____require_result_3.SinBJ
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local DestroyEffect = jass.DestroyEffect
local _____6A21_5757_540D = "火球模型测试"
local _____6D4B_8BD5_547D_4EE4 = "lock"
local _____91D1_9501_8DEF_5F84 = "Common\\Effect\\Form\\Line\\file_001295.mdx"
local _____91D1_9501_6D4B_8BD5_7279_6548 = nil
local function ____on_804A_5929Lock_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到预设大法师 gg_unit_Hamg_0002")
        return
    end
    if _____91D1_9501_6D4B_8BD5_7279_6548 ~= nil and _____91D1_9501_6D4B_8BD5_7279_6548 ~= 0 then
        DestroyEffect(_____91D1_9501_6D4B_8BD5_7279_6548)
        _____91D1_9501_6D4B_8BD5_7279_6548 = nil
    end
    local facing = GetUnitFacing(_____5927_6CD5_5E08)
    local x = GetUnitX(_____5927_6CD5_5E08) + 180 * CosBJ(facing)
    local y = GetUnitY(_____5927_6CD5_5E08) + 180 * SinBJ(facing)
    _____91D1_9501_6D4B_8BD5_7279_6548 = EC_CreateEffect(
        _____91D1_9501_8DEF_5F84,
        x,
        y,
        0,
        facing,
        1,
        1,
        1
    )
    if _____91D1_9501_6D4B_8BD5_7279_6548 == nil or _____91D1_9501_6D4B_8BD5_7279_6548 == 0 then
        debugLogForce(_____6A21_5757_540D, "创建失败：", _____91D1_9501_8DEF_5F84)
        return
    end
    debugLogForce(_____6A21_5757_540D, "已沿大法师技能方向前移180码创建金锁特效，按朝向旋转，1秒后隐藏")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_5929Lock_6D4B_8BD5)
return ____exports
