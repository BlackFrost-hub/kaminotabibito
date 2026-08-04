local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面")
local _____6253_5F00_9996_9886_5956_52B1_9009_62E9_754C_9762 = ____require_result_1["打开首领奖励选择界面"]
local GetOwningPlayer = jass.GetOwningPlayer
local ForGroup = jass.ForGroup
local GetEnumUnit = jass.GetEnumUnit
local GetHandleId = jass.GetHandleId
local CreateDestructable = jass.CreateDestructable
local DestructableRestoreLife = jass.DestructableRestoreLife
____exports["通用首领奖励宝箱可破坏物ID"] = "BZX4"
____exports["通用首领奖励宝箱生命值"] = 9999
local _____5B9D_7BB1_5B9E_4F8B_5956_52B1_6C60 = __TS__New(Map)
local _____5F53_524D_5B9D_7BB1_9996_9886_5956_52B1_6C60ID = ""
local function stringToFourCC(s)
    local a = #s > 0 and (string.byte(s, 1) or 0 / 0) or 0
    local b = #s > 1 and (string.byte(s, 2) or 0 / 0) or 0
    local c = #s > 2 and (string.byte(s, 3) or 0 / 0) or 0
    local d = #s > 3 and (string.byte(s, 4) or 0 / 0) or 0
    return a * 16777216 + b * 65536 + c * 256 + d
end
local function ____on_6253_5F00_6240_6709_73A9_5BB6_82F1_96C4_9996_9886_5956_52B1()
    local _____82F1_96C4 = GetEnumUnit()
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____5F53_524D_5B9D_7BB1_9996_9886_5956_52B1_6C60ID == "" then
        return
    end
    _____6253_5F00_9996_9886_5956_52B1_9009_62E9_754C_9762(
        _____5F53_524D_5B9D_7BB1_9996_9886_5956_52B1_6C60ID,
        GetOwningPlayer(_____82F1_96C4)
    )
end
local function _____53D6_5B9E_4F8B_914D_7F6E(_____5B9D_7BB1)
    if _____5B9D_7BB1 == nil or _____5B9D_7BB1 == 0 then
        return nil
    end
    return _____5B9D_7BB1_5B9E_4F8B_5956_52B1_6C60:get(GetHandleId(_____5B9D_7BB1))
end
____exports["绑定宝箱首领奖励池"] = function(_____5B9D_7BB1, _____5956_52B1_6C60ID, _____6253_5F00_8303_56F4)
    if _____6253_5F00_8303_56F4 == nil then
        _____6253_5F00_8303_56F4 = "所有玩家英雄"
    end
    if _____5B9D_7BB1 == nil or _____5B9D_7BB1 == 0 or _____5956_52B1_6C60ID == nil or _____5956_52B1_6C60ID == "" then
        return
    end
    local handleId = GetHandleId(_____5B9D_7BB1)
    _____5B9D_7BB1_5B9E_4F8B_5956_52B1_6C60:set(handleId, {["奖励池ID"] = _____5956_52B1_6C60ID, ["打开范围"] = _____6253_5F00_8303_56F4})
    DestructableRestoreLife(_____5B9D_7BB1, ____exports["通用首领奖励宝箱生命值"], true)
end
____exports["创建首领奖励宝箱"] = function(_____5956_52B1_6C60ID, x, y, _____6253_5F00_8303_56F4)
    if _____6253_5F00_8303_56F4 == nil then
        _____6253_5F00_8303_56F4 = "所有玩家英雄"
    end
    local _____5B9D_7BB1 = CreateDestructable(
        stringToFourCC(____exports["通用首领奖励宝箱可破坏物ID"]),
        x,
        y,
        0,
        1,
        0
    )
    ____exports["绑定宝箱首领奖励池"](_____5B9D_7BB1, _____5956_52B1_6C60ID, _____6253_5F00_8303_56F4)
    return _____5B9D_7BB1
end
____exports["触发宝箱首领奖励"] = function(cfg, _____5F00_542F_8005, _____5B9D_7BB1)
    local _____5B9E_4F8B_914D_7F6E = _____53D6_5B9E_4F8B_914D_7F6E(_____5B9D_7BB1)
    local ____temp_7 = _____5B9E_4F8B_914D_7F6E and _____5B9E_4F8B_914D_7F6E["奖励池ID"]
    if ____temp_7 == nil then
        local ____opt_result_6
        if cfg ~= nil then
            ____opt_result_6 = cfg["首领奖励池ID"]
        end
        ____temp_7 = ____opt_result_6
    end
    local _____5956_52B1_6C60ID = ____temp_7
    if _____5956_52B1_6C60ID == nil or _____5956_52B1_6C60ID == "" then
        return false
    end
    if _____5B9D_7BB1 ~= nil and _____5B9D_7BB1 ~= 0 then
        _____5B9D_7BB1_5B9E_4F8B_5956_52B1_6C60:delete(GetHandleId(_____5B9D_7BB1))
    end
    local ____temp_13 = _____5B9E_4F8B_914D_7F6E and _____5B9E_4F8B_914D_7F6E["打开范围"]
    if ____temp_13 == nil then
        local ____opt_result_12
        if cfg ~= nil then
            ____opt_result_12 = cfg["首领奖励打开范围"]
        end
        ____temp_13 = ____opt_result_12
    end
    local _____6253_5F00_8303_56F4 = ____temp_13
    if _____6253_5F00_8303_56F4 == "所有玩家英雄" then
        local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
        if _____73A9_5BB6_82F1_96C4_7EC4 == nil or _____73A9_5BB6_82F1_96C4_7EC4 == 0 then
            return true
        end
        _____5F53_524D_5B9D_7BB1_9996_9886_5956_52B1_6C60ID = _____5956_52B1_6C60ID
        ForGroup(_____73A9_5BB6_82F1_96C4_7EC4, ____on_6253_5F00_6240_6709_73A9_5BB6_82F1_96C4_9996_9886_5956_52B1)
        _____5F53_524D_5B9D_7BB1_9996_9886_5956_52B1_6C60ID = ""
        return true
    end
    if _____5F00_542F_8005 ~= nil and _____5F00_542F_8005 ~= 0 then
        _____6253_5F00_9996_9886_5956_52B1_9009_62E9_754C_9762(
            _____5956_52B1_6C60ID,
            GetOwningPlayer(_____5F00_542F_8005)
        )
    end
    return true
end
____exports.bindBossRewardChestPool = ____exports["绑定宝箱首领奖励池"]
____exports.createBossRewardChest = ____exports["创建首领奖励宝箱"]
return ____exports
