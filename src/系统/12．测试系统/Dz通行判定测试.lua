--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local japi = require("jass.japi")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数")
local X_IsTerrainWalkable = ____require_result_2.X_IsTerrainWalkable
local X_IsUnitTerrainWalkable = ____require_result_2.X_IsUnitTerrainWalkable
local DzPositionCanPlaceAround = japi.DzPositionCanPlaceAround
local DzUnitCanPlaceAround = japi.DzUnitCanPlaceAround
local _____6A21_5757_540D = "Dz通行判定测试"
local _____6D4B_8BD5_547D_4EE4 = "dzcp"
local _____6D4B_8BD5X = 845.1
local _____6D4B_8BD5Y = -2446.4
local _____6D4B_8BD5_78B0_649E_5927_5C0F = 32
local _____6D4B_8BD5_78B0_649E_7C7B_578B = 2
local function onChatDzCanPlaceTest()
    local unit = g.gg_unit_Hamg_0002
    if unit == nil or unit == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到 gg_unit_Hamg_0002")
        return
    end
    local posResult = DzPositionCanPlaceAround(_____6D4B_8BD5X, _____6D4B_8BD5Y, _____6D4B_8BD5_78B0_649E_5927_5C0F, _____6D4B_8BD5_78B0_649E_7C7B_578B)
    local unitResult = DzUnitCanPlaceAround(unit, _____6D4B_8BD5X, _____6D4B_8BD5Y)
    local terrainResult = X_IsTerrainWalkable(_____6D4B_8BD5X, _____6D4B_8BD5Y)
    local xUnitResult = X_IsUnitTerrainWalkable(unit, _____6D4B_8BD5X, _____6D4B_8BD5Y)
    debugLogForce(
        _____6A21_5757_540D,
        "坐标=(",
        _____6D4B_8BD5X,
        ",",
        _____6D4B_8BD5Y,
        ")"
    )
    debugLogForce(_____6A21_5757_540D, "DzPositionCanPlaceAround(size=32,type=2)=", posResult)
    debugLogForce(_____6A21_5757_540D, "DzUnitCanPlaceAround(unit,x,y)=", unitResult)
    debugLogForce(_____6A21_5757_540D, "X_IsTerrainWalkable(x,y)=", terrainResult)
    debugLogForce(_____6A21_5757_540D, "X_IsUnitTerrainWalkable(unit,x,y)=", xUnitResult)
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, onChatDzCanPlaceTest)
debugLogForce(
    _____6A21_5757_540D,
    "已注册测试，输入",
    _____6D4B_8BD5_547D_4EE4,
    "检测坐标",
    _____6D4B_8BD5X,
    _____6D4B_8BD5Y
)
return ____exports
