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
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local DestroyEffect = jass.DestroyEffect
local Cos = jass.Cos
local Sin = jass.Sin
local _____6A21_5757_540D = "火球模型测试"
local _____6D4B_8BD5_547D_4EE4 = "lock"
local _____706B_7403_8DEF_5F84 = "Common\\Effect\\Element\\Fire\\OrbFireX.mdx"
local _____706B_7403_6D4B_8BD5_7279_6548 = nil
local function ____on_804A_5929Lock_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到预设大法师 gg_unit_Hamg_0002")
        return
    end
    if _____706B_7403_6D4B_8BD5_7279_6548 ~= nil and _____706B_7403_6D4B_8BD5_7279_6548 ~= 0 then
        DestroyEffect(_____706B_7403_6D4B_8BD5_7279_6548)
        _____706B_7403_6D4B_8BD5_7279_6548 = nil
    end
    local facing = GetUnitFacing(_____5927_6CD5_5E08)
    local radians = facing * math.pi / 180
    local x = GetUnitX(_____5927_6CD5_5E08) + 100 * Cos(radians)
    local y = GetUnitY(_____5927_6CD5_5E08) + 100 * Sin(radians)
    _____706B_7403_6D4B_8BD5_7279_6548 = EC_CreateEffect(
        _____706B_7403_8DEF_5F84,
        x,
        y,
        0,
        facing,
        3,
        1,
        -1
    )
    if _____706B_7403_6D4B_8BD5_7279_6548 == nil or _____706B_7403_6D4B_8BD5_7279_6548 == 0 then
        debugLogForce(_____6A21_5757_540D, "创建失败：", _____706B_7403_8DEF_5F84)
        return
    end
    debugLogForce(_____6A21_5757_540D, "已在大法师面前100码创建 OrbFireX，缩放3.0，使用模型默认动画")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_5929Lock_6D4B_8BD5)
return ____exports
