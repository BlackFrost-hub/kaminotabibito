--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local globals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_2.debugLogForce
local Player = jass.Player
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local CreateUnit = jass.CreateUnit
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local _____6A21_5757_540D = "塞拉裸创建测试"
local _____6D4B_8BD5_547D_4EE4 = "123"
local _____73A9_5BB6_4E00 = Player(0)
local _____585E_62C9_7269_7F16ID = "N03K"
local _____585E_62C9_5355_4F4DID = stringToFourCCSafe(_____585E_62C9_7269_7F16ID)
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function ____on_585E_62C9_88F8_521B_5EFA_547D_4EE4(player, _command)
    if not _____53E5_67C4_6709_6548(player) or GetPlayerId(player) ~= 0 then
        return
    end
    local _____5927_6CD5_5E08 = globals.gg_unit_Hamg_0002
    if not _____53E5_67C4_6709_6548(_____5927_6CD5_5E08) then
        debugLogForce(_____6A21_5757_540D, "创建失败", "原因=找不到 gg_unit_Hamg_0002")
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            5,
            "[塞拉测试] 创建失败：找不到大法师预设单位。"
        )
        return
    end
    local x = GetUnitX(_____5927_6CD5_5E08)
    local y = GetUnitY(_____5927_6CD5_5E08)
    local facing = GetUnitFacing(_____5927_6CD5_5E08)
    local _____585E_62C9 = CreateUnit(
        _____73A9_5BB6_4E00,
        _____585E_62C9_5355_4F4DID,
        x,
        y,
        facing
    )
    if not _____53E5_67C4_6709_6548(_____585E_62C9) then
        debugLogForce(
            _____6A21_5757_540D,
            "创建失败",
            "物编ID=",
            _____585E_62C9_7269_7F16ID,
            "x=",
            x,
            "y=",
            y,
            "facing=",
            facing
        )
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            5,
            "[塞拉测试] 创建失败：CreateUnit 未返回有效单位。"
        )
        return
    end
    debugLogForce(
        _____6A21_5757_540D,
        "创建成功",
        "owner=Player1",
        "物编ID=",
        _____585E_62C9_7269_7F16ID,
        "x=",
        x,
        "y=",
        y,
        "facing=",
        facing
    )
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        5,
        "[塞拉测试] 已在大法师预设位置裸创建玩家1塞拉。"
    )
end
local function _____521D_59CB_5316_585E_62C9_88F8_521B_5EFA_6D4B_8BD5()
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_585E_62C9_88F8_521B_5EFA_547D_4EE4)
    debugLogForce(_____6A21_5757_540D, "已注册命令", _____6D4B_8BD5_547D_4EE4)
end
_____521D_59CB_5316_585E_62C9_88F8_521B_5EFA_6D4B_8BD5()
return ____exports
