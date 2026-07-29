--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.12．测试系统.00．Boss测试系统.02．Boss测试单位")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_1["Boss测试单位存活"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_1["获取Boss测试玩家基准英雄"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_2["创建点特效"]
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_3.debugLogForce
local _____6D4B_8BD5_547D_4EE4 = "66"
local _____6D4B_8BD5_6A21_578B = "Common\\Effect\\Element\\Fantasy\\file_002480.mdx"
local _____6D4B_8BD5_9AD8_5EA6 = 100
local _____6D4B_8BD5_7F29_653E = 1
local _____6D4B_8BD5_6301_7EED_79D2 = 10
local function ____on_51E4_51F0_633D_6B4C_5708_5916_547D_4E2D_7279_6548_6D4B_8BD5(player, _command)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(hero) then
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            8,
            "[凤凰挽歌圈外命中特效测试] 找不到大法师或已登记玩家英雄。"
        )
        debugLogForce("凤凰挽歌圈外命中特效测试", "创建失败：找不到测试英雄")
        return
    end
    local x = GetUnitX(hero)
    local y = GetUnitY(hero)
    local effect = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____6D4B_8BD5_6A21_578B,
        X = x,
        Y = y,
        Z = _____6D4B_8BD5_9AD8_5EA6,
        ["缩放"] = _____6D4B_8BD5_7F29_653E,
        ["持续秒"] = _____6D4B_8BD5_6301_7EED_79D2
    })
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        8,
        "[凤凰挽歌圈外命中特效测试] 已在大法师坐标创建命中特效，Z=100、缩放=1.0、持续10秒。"
    )
    debugLogForce(
        "凤凰挽歌圈外命中特效测试",
        "命令",
        _____6D4B_8BD5_547D_4EE4,
        "模型",
        _____6D4B_8BD5_6A21_578B,
        "X",
        x,
        "Y",
        y,
        "Z",
        _____6D4B_8BD5_9AD8_5EA6,
        "缩放",
        _____6D4B_8BD5_7F29_653E,
        "特效句柄ID",
        effect ~= nil and effect ~= 0 and GetHandleId(effect) or 0
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_51E4_51F0_633D_6B4C_5708_5916_547D_4E2D_7279_6548_6D4B_8BD5)
return ____exports
