--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 广播提示消息测试
-- 
-- 输入 1025：只给触发玩家发送单位头像提示。
-- 输入 1026：给全体玩家广播单位头像提示。
-- 输入 1027：给触发玩家连续发送多条自定义头像提示，测试槽位队列和覆盖。
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local _____5E7F_64AD_63D0_793A = require("系统.09．表现系统.06．广播提示消息.index")
local _____6A21_5757_540D = "广播提示消息测试"
local _____5355_4EBA_547D_4EE4 = "1025"
local _____5168_4F53_547D_4EE4 = "1026"
local _____8FDE_53D1_547D_4EE4 = "1027"
local _____5907_7528_5934_50CF_8DEF_5F84 = "UI\\xiaoxi\\UInotice.tga"
local _____5E7F_64AD_5355_4F4D_63D0_793A = _____5E7F_64AD_63D0_793A["广播单位提示"]
local _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6 = _____5E7F_64AD_63D0_793A["发送单位提示给玩家"]
local _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6 = _____5E7F_64AD_63D0_793A["发送头像提示给玩家"]
local function _____53D6_6D4B_8BD5_5355_4F4D()
    return g.gg_unit_Hamg_0002
end
local function _____6D4B_8BD5_5355_4F4D_6709_6548()
    local _____5927_6CD5_5E08 = _____53D6_6D4B_8BD5_5355_4F4D()
    if _____5927_6CD5_5E08 ~= nil and _____5927_6CD5_5E08 ~= 0 then
        return true
    end
    debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002，无法测试单位头像提示")
    return false
end
local function ____on_804A_59291025_6D4B_8BD5(player)
    if not _____6D4B_8BD5_5355_4F4D_6709_6548() then
        return
    end
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        player,
        _____53D6_6D4B_8BD5_5355_4F4D(),
        "|cffffcc33单人单位头像提示：只有你应该看到这条。|r",
        3000
    )
    debugLogForce(_____6A21_5757_540D, "已触发单人广播提示测试")
end
local function ____on_804A_59291026_6D4B_8BD5()
    if not _____6D4B_8BD5_5355_4F4D_6709_6548() then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(
        _____53D6_6D4B_8BD5_5355_4F4D(),
        "|cff66ccff全体广播提示：所有玩家都应该看到这条。|r",
        3000
    )
    debugLogForce(_____6A21_5757_540D, "已触发全体广播提示测试")
end
local function ____on_804A_59291027_6D4B_8BD5(player)
    do
        local i = 1
        while i <= 7 do
            _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(
                player,
                _____5907_7528_5934_50CF_8DEF_5F84,
                ("|cff99ff99连续头像提示 #" .. tostring(i)) .. "|r",
                1800
            )
            i = i + 1
        end
    end
    debugLogForce(_____6A21_5757_540D, "已触发连续广播提示测试")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____5355_4EBA_547D_4EE4, ____on_804A_59291025_6D4B_8BD5)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____5168_4F53_547D_4EE4, ____on_804A_59291026_6D4B_8BD5)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____8FDE_53D1_547D_4EE4, ____on_804A_59291027_6D4B_8BD5)
debugLogForce(
    _____6A21_5757_540D,
    "已注册测试：输入",
    _____5355_4EBA_547D_4EE4,
    "单人；",
    _____5168_4F53_547D_4EE4,
    "全体；",
    _____8FDE_53D1_547D_4EE4,
    "连发"
)
return ____exports
