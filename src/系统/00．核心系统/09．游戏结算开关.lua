--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("系统.00．核心系统.07．联机安全工具")
local safeForForce = ____require_result_1.safeForForce
local EndGame = jass.EndGame
local GetEnumPlayer = jass.GetEnumPlayer
local RemovePlayer = jass.RemovePlayer
local _____6E38_620F_7ED3_7B97_672A_89E6_53D1 = 0
local _____6E38_620F_7ED3_7B97_80DC_5229 = 1
local _____6E38_620F_7ED3_7B97_5931_8D25 = 2
local _____5F53_524D_6E38_620F_7ED3_7B97_72B6_6001 = _____6E38_620F_7ED3_7B97_672A_89E6_53D1
local _____5F85_679A_4E3E_73A9_5BB6_7ED3_7B97_7ED3_679C = nil
local function ____on_7ED3_7B97_679A_4E3E_73A9_5BB6()
    local player = GetEnumPlayer()
    if player == nil or player == 0 or _____5F85_679A_4E3E_73A9_5BB6_7ED3_7B97_7ED3_679C == nil then
        return
    end
    RemovePlayer(player, _____5F85_679A_4E3E_73A9_5BB6_7ED3_7B97_7ED3_679C)
end
local function _____7ED3_7B97YD_73A9_5BB6_7EC4(_____72B6_6001, _____7ED3_679C)
    if _____5F53_524D_6E38_620F_7ED3_7B97_72B6_6001 ~= _____6E38_620F_7ED3_7B97_672A_89E6_53D1 then
        return false
    end
    local _____73A9_5BB6_7EC4 = YDUserDataGetSafe("string", "玩家", "玩家组", "force")
    if _____73A9_5BB6_7EC4 == nil or _____73A9_5BB6_7EC4 == 0 then
        return false
    end
    _____5F53_524D_6E38_620F_7ED3_7B97_72B6_6001 = _____72B6_6001
    _____5F85_679A_4E3E_73A9_5BB6_7ED3_7B97_7ED3_679C = _____7ED3_679C
    safeForForce(_____73A9_5BB6_7EC4, ____on_7ED3_7B97_679A_4E3E_73A9_5BB6)
    _____5F85_679A_4E3E_73A9_5BB6_7ED3_7B97_7ED3_679C = nil
    EndGame(true)
    return true
end
____exports["设置全体玩家游戏胜利"] = function()
    return _____7ED3_7B97YD_73A9_5BB6_7EC4(_____6E38_620F_7ED3_7B97_80DC_5229, jass.PLAYER_GAME_RESULT_VICTORY)
end
____exports["设置全体玩家游戏失败"] = function()
    return _____7ED3_7B97YD_73A9_5BB6_7EC4(_____6E38_620F_7ED3_7B97_5931_8D25, jass.PLAYER_GAME_RESULT_DEFEAT)
end
____exports["读取游戏结算状态"] = function()
    return _____5F53_524D_6E38_620F_7ED3_7B97_72B6_6001
end
return ____exports
