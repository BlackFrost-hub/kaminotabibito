local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.BJ函数.05A．电影函数")
local CinematicModeBJ = ____require_result_0.CinematicModeBJ
local ____require_result_1 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_1.GetPlayersAll
local ____require_result_2 = require("lib.扩展函数.封装函数.07．镜头函数.03．镜头预设")
local _____5E73_79FB_5E76_5E94_7528_955C_5934_9884_8BBE_5230_5168_90E8_73A9_5BB6 = ____require_result_2["平移并应用镜头预设到全部玩家"]
local _____91CD_7F6E_73A9_5BB6_955C_5934_5E76_5E73_79FB_5230_5355_4F4D = ____require_result_2["重置玩家镜头并平移到单位"]
local ____require_result_3 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_3.getRegisteredPlayerHero
local GetLocalPlayer = jass.GetLocalPlayer
local GetPlayerId = jass.GetPlayerId
local GetCameraField = jass.GetCameraField
local SetCameraField = jass.SetCameraField
local CAMERA_FIELD_TARGET_DISTANCE = jass.CAMERA_FIELD_TARGET_DISTANCE
local CAMERA_FIELD_ZOFFSET = jass.CAMERA_FIELD_ZOFFSET
local _____5267_60C5_7535_5F71_6A21_5F0F_5DF2_5F00_542F = false
local _____5267_60C5_7535_5F71_6A21_5F0F_524D_955C_5934_72B6_6001_8868 = {}
local function _____8BB0_5F55_672C_5730_73A9_5BB6_955C_5934_72B6_6001()
    local localPlayer = GetLocalPlayer()
    local playerId = GetPlayerId(localPlayer)
    _____5267_60C5_7535_5F71_6A21_5F0F_524D_955C_5934_72B6_6001_8868[playerId] = {
        ["目标距离"] = GetCameraField(CAMERA_FIELD_TARGET_DISTANCE),
        ["高度偏移"] = GetCameraField(CAMERA_FIELD_ZOFFSET)
    }
end
local function _____6062_590D_672C_5730_73A9_5BB6_955C_5934_72B6_6001()
    local localPlayer = GetLocalPlayer()
    local playerId = GetPlayerId(localPlayer)
    local _____72B6_6001 = _____5267_60C5_7535_5F71_6A21_5F0F_524D_955C_5934_72B6_6001_8868[playerId]
    if _____72B6_6001 == nil then
        return
    end
    SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, _____72B6_6001["目标距离"], 0)
    SetCameraField(CAMERA_FIELD_ZOFFSET, _____72B6_6001["高度偏移"], 0)
    __TS__Delete(_____5267_60C5_7535_5F71_6A21_5F0F_524D_955C_5934_72B6_6001_8868, playerId)
end
____exports["进入剧情电影模式"] = function()
    if _____5267_60C5_7535_5F71_6A21_5F0F_5DF2_5F00_542F then
        return
    end
    _____8BB0_5F55_672C_5730_73A9_5BB6_955C_5934_72B6_6001()
    _____5267_60C5_7535_5F71_6A21_5F0F_5DF2_5F00_542F = true
    CinematicModeBJ(
        true,
        GetPlayersAll()
    )
end
____exports["应用剧情电影镜头"] = function(_____9884_8BBE, duration)
    _____5E73_79FB_5E76_5E94_7528_955C_5934_9884_8BBE_5230_5168_90E8_73A9_5BB6(_____9884_8BBE, duration)
end
____exports["退出剧情电影模式并恢复镜头"] = function()
    if not _____5267_60C5_7535_5F71_6A21_5F0F_5DF2_5F00_542F then
        return
    end
    _____5267_60C5_7535_5F71_6A21_5F0F_5DF2_5F00_542F = false
    CinematicModeBJ(
        false,
        GetPlayersAll()
    )
    local localPlayer = GetLocalPlayer()
    local hero = getRegisteredPlayerHero(localPlayer)
    _____91CD_7F6E_73A9_5BB6_955C_5934_5E76_5E73_79FB_5230_5355_4F4D(localPlayer, hero, 0)
    _____6062_590D_672C_5730_73A9_5BB6_955C_5934_72B6_6001()
end
return ____exports
