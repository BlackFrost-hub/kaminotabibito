--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5199_6D4B_8BD5_65E5_5FD7, _____53D1_9001_9ED8_8BA4_5934_50CF_8D85_957F_6D88_606F, _____53D1_9001_5355_4F4D_5934_50CF_5355_64AD, _____53D1_9001_5355_4F4D_5934_50CF_5168_4F53_5E7F_64AD, _____6267_884C_8FDE_7EED_77ED_6D88_606F_7B2C1_6761, _____6267_884C_8FDE_7EED_77ED_6D88_606F_7B2C2_6761, _____6267_884C_8FDE_7EED_77ED_6D88_606F_7B2C3_6761, _____6267_884C_8FDE_7EED_77ED_6D88_606F_7B2C4_6761, _____6267_884C_8FDE_7EED_77ED_6D88_606F_7B2C5_6761, _____5E7F_64AD_6D4B_8BD5_5168_5957__6B65_9AA43, _____5E7F_64AD_6D4B_8BD5_5168_5957__6B65_9AA44, _____5E7F_64AD_6D4B_8BD5_5168_5957__6B65_9AA45, _____5E7F_64AD_6D4B_8BD5_5168_5957__6B65_9AA46, _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6, _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6, _____5E7F_64AD_5355_4F4D_63D0_793A, centerTimer, debugLogForce, _____5E7F_64AD_6D4B_8BD5_6A21_5757_540D, _____9ED8_8BA4_6D4B_8BD5_5934_50CF, _____5F53_524D_5E7F_64AD_6D4B_8BD5_5957_4EF6
function _____5199_6D4B_8BD5_65E5_5FD7(...)
    debugLogForce(_____5E7F_64AD_6D4B_8BD5_6A21_5757_540D, ...)
end
function _____53D1_9001_9ED8_8BA4_5934_50CF_8D85_957F_6D88_606F(player)
    _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(player, _____9ED8_8BA4_6D4B_8BD5_5934_50CF, "超长消息测试：这条广播会模拟剧情里比较长的说明文本，用来验证自动换行、较高背景、较长停留时长，以及在文本带颜色码时仍然不会把整条广播直接冲出背景区域。", nil)
end
function _____53D1_9001_5355_4F4D_5934_50CF_5355_64AD(player, hero)
    if hero == nil or hero == 0 then
        _____5199_6D4B_8BD5_65E5_5FD7("未找到已注册玩家英雄，单位头像单播改用默认头像")
        _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(player, _____9ED8_8BA4_6D4B_8BD5_5934_50CF, "单位头像单播测试：当前未找到注册英雄，已退回默认头像。", 3000)
        return
    end
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(player, hero, "单位头像单播测试：这条消息应该使用你当前英雄的头像。", 3200)
end
function _____53D1_9001_5355_4F4D_5934_50CF_5168_4F53_5E7F_64AD(player, hero)
    if hero == nil or hero == 0 then
        _____5199_6D4B_8BD5_65E5_5FD7("未找到已注册玩家英雄，无法执行全体单位头像广播")
        _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(player, _____9ED8_8BA4_6D4B_8BD5_5934_50CF, "全体广播测试失败：当前未找到注册英雄。", 3000)
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(hero, "全体广播测试：这条消息应使用英雄头像，并向所有测试玩家槽广播。", 3600)
end
function _____6267_884C_8FDE_7EED_77ED_6D88_606F_7B2C1_6761()
    local ctx = _____5F53_524D_5E7F_64AD_6D4B_8BD5_5957_4EF6
    if ctx == nil then
        return
    end
    ctx.burstIndex = 1
    _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(ctx.player, _____9ED8_8BA4_6D4B_8BD5_5934_50CF, "连续短消息 1/5", 2600)
    centerTimer.addDelayedCallback(180, _____6267_884C_8FDE_7EED_77ED_6D88_606F_7B2C2_6761)
end
function _____6267_884C_8FDE_7EED_77ED_6D88_606F_7B2C2_6761()
    local ctx = _____5F53_524D_5E7F_64AD_6D4B_8BD5_5957_4EF6
    if ctx == nil then
        return
    end
    ctx.burstIndex = 2
    _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(ctx.player, _____9ED8_8BA4_6D4B_8BD5_5934_50CF, "连续短消息 2/5", 2600)
    centerTimer.addDelayedCallback(180, _____6267_884C_8FDE_7EED_77ED_6D88_606F_7B2C3_6761)
end
function _____6267_884C_8FDE_7EED_77ED_6D88_606F_7B2C3_6761()
    local ctx = _____5F53_524D_5E7F_64AD_6D4B_8BD5_5957_4EF6
    if ctx == nil then
        return
    end
    ctx.burstIndex = 3
    _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(ctx.player, _____9ED8_8BA4_6D4B_8BD5_5934_50CF, "连续短消息 3/5", 2600)
    centerTimer.addDelayedCallback(180, _____6267_884C_8FDE_7EED_77ED_6D88_606F_7B2C4_6761)
end
function _____6267_884C_8FDE_7EED_77ED_6D88_606F_7B2C4_6761()
    local ctx = _____5F53_524D_5E7F_64AD_6D4B_8BD5_5957_4EF6
    if ctx == nil then
        return
    end
    ctx.burstIndex = 4
    _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(ctx.player, _____9ED8_8BA4_6D4B_8BD5_5934_50CF, "连续短消息 4/5", 2600)
    centerTimer.addDelayedCallback(180, _____6267_884C_8FDE_7EED_77ED_6D88_606F_7B2C5_6761)
end
function _____6267_884C_8FDE_7EED_77ED_6D88_606F_7B2C5_6761()
    local ctx = _____5F53_524D_5E7F_64AD_6D4B_8BD5_5957_4EF6
    if ctx == nil then
        return
    end
    ctx.burstIndex = 5
    _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(ctx.player, _____9ED8_8BA4_6D4B_8BD5_5934_50CF, "连续短消息 5/5", 2600)
end
function _____5E7F_64AD_6D4B_8BD5_5168_5957__6B65_9AA43()
    local ctx = _____5F53_524D_5E7F_64AD_6D4B_8BD5_5957_4EF6
    if ctx == nil then
        return
    end
    _____53D1_9001_9ED8_8BA4_5934_50CF_8D85_957F_6D88_606F(ctx.player)
    centerTimer.addDelayedCallback(700, _____5E7F_64AD_6D4B_8BD5_5168_5957__6B65_9AA44)
end
function _____5E7F_64AD_6D4B_8BD5_5168_5957__6B65_9AA44()
    local ctx = _____5F53_524D_5E7F_64AD_6D4B_8BD5_5957_4EF6
    if ctx == nil then
        return
    end
    _____53D1_9001_5355_4F4D_5934_50CF_5355_64AD(ctx.player, ctx.hero)
    centerTimer.addDelayedCallback(700, _____5E7F_64AD_6D4B_8BD5_5168_5957__6B65_9AA45)
end
function _____5E7F_64AD_6D4B_8BD5_5168_5957__6B65_9AA45()
    local ctx = _____5F53_524D_5E7F_64AD_6D4B_8BD5_5957_4EF6
    if ctx == nil then
        return
    end
    _____53D1_9001_5355_4F4D_5934_50CF_5168_4F53_5E7F_64AD(ctx.player, ctx.hero)
    centerTimer.addDelayedCallback(700, _____5E7F_64AD_6D4B_8BD5_5168_5957__6B65_9AA46)
end
function _____5E7F_64AD_6D4B_8BD5_5168_5957__6B65_9AA46()
    local ctx = _____5F53_524D_5E7F_64AD_6D4B_8BD5_5957_4EF6
    if ctx == nil then
        return
    end
    _____6267_884C_8FDE_7EED_77ED_6D88_606F_7B2C1_6761()
end
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.09．表现系统.06．广播提示消息.index")
_____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6 = ____require_result_1["发送头像提示给玩家"]
_____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6 = ____require_result_1["发送单位提示给玩家"]
_____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_1["广播单位提示"]
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_2.getRegisteredPlayerHero
centerTimer = require("系统.00．核心系统.05．中心计时器")
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_3.debugLogForce
local GetPlayerId = jass.GetPlayerId
_____5E7F_64AD_6D4B_8BD5_6A21_5757_540D = "广播提示消息测试"
_____9ED8_8BA4_6D4B_8BD5_5934_50CF = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"
local function _____53D6_547D_4EE4_89E6_53D1_82F1_96C4(player)
    return getRegisteredPlayerHero(player)
end
local function _____53D1_9001_9ED8_8BA4_5934_50CF_77ED_6D88_606F(player)
    _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(player, _____9ED8_8BA4_6D4B_8BD5_5934_50CF, "短消息测试：这是一条紧凑广播。", 3000)
end
local function _____53D1_9001_9ED8_8BA4_5934_50CF_957F_6D88_606F(player)
    _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(player, _____9ED8_8BA4_6D4B_8BD5_5934_50CF, "长消息测试：这条广播用于验证两行布局、停留时长拉长，以及短消息槽位间距不会被整体撑开。", nil)
end
local function _____542F_52A8_8FDE_7EED_77ED_6D88_606F_6D4B_8BD5(player)
    _____5F53_524D_5E7F_64AD_6D4B_8BD5_5957_4EF6 = {
        player = player,
        hero = _____53D6_547D_4EE4_89E6_53D1_82F1_96C4(player),
        burstIndex = 0
    }
    _____6267_884C_8FDE_7EED_77ED_6D88_606F_7B2C1_6761()
end
local function _____5E7F_64AD_6D4B_8BD5_5168_5957__6B65_9AA42()
    local ctx = _____5F53_524D_5E7F_64AD_6D4B_8BD5_5957_4EF6
    if ctx == nil then
        return
    end
    _____53D1_9001_9ED8_8BA4_5934_50CF_957F_6D88_606F(ctx.player)
    centerTimer.addDelayedCallback(700, _____5E7F_64AD_6D4B_8BD5_5168_5957__6B65_9AA43)
end
local function _____8FD0_884C_5E7F_64AD_6D4B_8BD5_5168_5957(player)
    _____5F53_524D_5E7F_64AD_6D4B_8BD5_5957_4EF6 = {
        player = player,
        hero = _____53D6_547D_4EE4_89E6_53D1_82F1_96C4(player),
        burstIndex = 0
    }
    _____5199_6D4B_8BD5_65E5_5FD7(
        "开始广播测试全套",
        "playerId=",
        GetPlayerId(player),
        "hero=",
        _____5F53_524D_5E7F_64AD_6D4B_8BD5_5957_4EF6.hero
    )
    _____53D1_9001_9ED8_8BA4_5934_50CF_77ED_6D88_606F(player)
    centerTimer.addDelayedCallback(700, _____5E7F_64AD_6D4B_8BD5_5168_5957__6B65_9AA42)
end
local function onChatBmsg1(player)
    _____53D1_9001_9ED8_8BA4_5934_50CF_77ED_6D88_606F(player)
end
local function onChatBmsg2(player)
    _____53D1_9001_9ED8_8BA4_5934_50CF_957F_6D88_606F(player)
end
local function onChatBmsg3(player)
    _____53D1_9001_9ED8_8BA4_5934_50CF_8D85_957F_6D88_606F(player)
end
local function onChatBmsg4(player)
    _____542F_52A8_8FDE_7EED_77ED_6D88_606F_6D4B_8BD5(player)
end
local function onChatBmsg5(player)
    _____53D1_9001_5355_4F4D_5934_50CF_5355_64AD(
        player,
        _____53D6_547D_4EE4_89E6_53D1_82F1_96C4(player)
    )
end
local function onChatBmsg6(player)
    _____53D1_9001_5355_4F4D_5934_50CF_5168_4F53_5E7F_64AD(
        player,
        _____53D6_547D_4EE4_89E6_53D1_82F1_96C4(player)
    )
end
local function onChatBmsgAll(player)
    _____8FD0_884C_5E7F_64AD_6D4B_8BD5_5168_5957(player)
end
local function _____6CE8_518C_5E7F_64AD_63D0_793A_6D88_606F_6D4B_8BD5_547D_4EE4()
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bmsg1", onChatBmsg1)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bmsg2", onChatBmsg2)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bmsg3", onChatBmsg3)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bmsg4", onChatBmsg4)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bmsg5", onChatBmsg5)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bmsg6", onChatBmsg6)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("bmsgall", onChatBmsgAll)
    _____5199_6D4B_8BD5_65E5_5FD7("已注册测试命令", "bmsg1/bmsg2/bmsg3/bmsg4/bmsg5/bmsg6/bmsgall")
end
_____6CE8_518C_5E7F_64AD_63D0_793A_6D88_606F_6D4B_8BD5_547D_4EE4()
return ____exports
