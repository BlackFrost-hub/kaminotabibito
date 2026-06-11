local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____9996_9886_5956_52B1_9886_53D6_8BB0_5F55_8868 = {}
local function _____67E5_627E_9886_53D6_8BB0_5F55_5E8F_53F7(_____5956_52B1_6C60ID, _____73A9_5BB6ID)
    do
        local _____5E8F_53F7 = 0
        while _____5E8F_53F7 < #_____9996_9886_5956_52B1_9886_53D6_8BB0_5F55_8868 do
            local _____8BB0_5F55 = _____9996_9886_5956_52B1_9886_53D6_8BB0_5F55_8868[_____5E8F_53F7 + 1]
            if _____8BB0_5F55["奖励池ID"] == _____5956_52B1_6C60ID and _____8BB0_5F55["玩家ID"] == _____73A9_5BB6ID then
                return _____5E8F_53F7
            end
            _____5E8F_53F7 = _____5E8F_53F7 + 1
        end
    end
    return -1
end
____exports["是否已领取首领奖励"] = function(_____5956_52B1_6C60ID, _____73A9_5BB6ID)
    return _____67E5_627E_9886_53D6_8BB0_5F55_5E8F_53F7(_____5956_52B1_6C60ID, _____73A9_5BB6ID) >= 0
end
____exports["标记首领奖励已领取"] = function(_____5956_52B1_6C60ID, _____73A9_5BB6ID, _____5DF2_9009_88C5_5907_540D)
    if ____exports["是否已领取首领奖励"](_____5956_52B1_6C60ID, _____73A9_5BB6ID) then
        return false
    end
    _____9996_9886_5956_52B1_9886_53D6_8BB0_5F55_8868[#_____9996_9886_5956_52B1_9886_53D6_8BB0_5F55_8868 + 1] = {["奖励池ID"] = _____5956_52B1_6C60ID, ["玩家ID"] = _____73A9_5BB6ID, ["已选装备名"] = _____5DF2_9009_88C5_5907_540D}
    return true
end
____exports["获取首领奖励领取记录"] = function(_____5956_52B1_6C60ID, _____73A9_5BB6ID)
    local _____5E8F_53F7 = _____67E5_627E_9886_53D6_8BB0_5F55_5E8F_53F7(_____5956_52B1_6C60ID, _____73A9_5BB6ID)
    if _____5E8F_53F7 < 0 then
        return nil
    end
    return _____9996_9886_5956_52B1_9886_53D6_8BB0_5F55_8868[_____5E8F_53F7 + 1]
end
____exports["清除首领奖励领取记录"] = function(_____5956_52B1_6C60ID, _____73A9_5BB6ID)
    local _____5E8F_53F7 = _____67E5_627E_9886_53D6_8BB0_5F55_5E8F_53F7(_____5956_52B1_6C60ID, _____73A9_5BB6ID)
    if _____5E8F_53F7 < 0 then
        return false
    end
    __TS__ArraySplice(_____9996_9886_5956_52B1_9886_53D6_8BB0_5F55_8868, _____5E8F_53F7, 1)
    return true
end
return ____exports
