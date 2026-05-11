--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local g = require("jass.globals")
local Player = jass.Player
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitName = jass.GetUnitName
local GetHandleId = jass.GetHandleId
local CreateTimer = jass.CreateTimer
local DestroyTimer = jass.DestroyTimer
local GetExpiredTimer = jass.GetExpiredTimer
local TimerStart = jass.TimerStart
local R2SW = jass.R2SW
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local ____SFB__65BD_52A0_901A_7528Buff = ____require_result_0["SFB_施加通用Buff"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local _____542F_7528_6D4B_8BD5 = false
local function _____8C03_8BD5_8F93_51FA(message, duration)
    if duration == nil then
        duration = 5
    end
    debugLogForce("快速Buff测试", message)
    do
        local pi = 0
        while pi < 4 do
            DisplayTimedTextToPlayer(
                Player(pi),
                0,
                0,
                duration,
                "[快速Buff测试] " .. message
            )
            pi = pi + 1
        end
    end
end
local function _____6D4B_8BD5__7729_6655_76EE_6807()
    local _____76EE_6807_5355_4F4D = g.gg_unit_Hamg_0002
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        _____8C03_8BD5_8F93_51FA("错误: gg_unit_Hamg_0002 不存在！请检查地图中是否有该预置单位。", 10)
        return
    end
    local _____5355_4F4D_540D = GetUnitName(_____76EE_6807_5355_4F4D)
    local hid = GetHandleId(_____76EE_6807_5355_4F4D)
    local x = GetUnitX(_____76EE_6807_5355_4F4D)
    local y = GetUnitY(_____76EE_6807_5355_4F4D)
    _____8C03_8BD5_8F93_51FA(((((((("目标单位: " .. _____5355_4F4D_540D) .. " (handleId=") .. tostring(hid)) .. ", x=") .. R2SW(x, 0, 1)) .. ", y=") .. R2SW(y, 0, 1)) .. ")")
    _____8C03_8BD5_8F93_51FA("正在施加眩晕Buff (id=0, 持续3秒)...")
    ____SFB__65BD_52A0_901A_7528Buff(_____76EE_6807_5355_4F4D, _____76EE_6807_5355_4F4D, 0, 3)
    _____8C03_8BD5_8F93_51FA("眩晕Buff已施加！请观察单位是否被眩晕。")
end
local function _____542F_52A8_5FEB_901FBuff_6D4B_8BD5()
    local t = GetExpiredTimer()
    if t ~= nil then
        DestroyTimer(t)
    end
    _____8C03_8BD5_8F93_51FA("=== 快速Buff系统测试开始 ===")
    _____8C03_8BD5_8F93_51FA("正在对 gg_unit_Hamg_0002 施加眩晕...")
    _____6D4B_8BD5__7729_6655_76EE_6807()
end
if _____542F_7528_6D4B_8BD5 then
    local _____542F_52A8_8BA1_65F6_5668 = CreateTimer()
    TimerStart(_____542F_52A8_8BA1_65F6_5668, 1, false, _____542F_52A8_5FEB_901FBuff_6D4B_8BD5)
end
return ____exports
