local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_1["创建单位并登记排泄安全"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local IssuePointOrder = jass.IssuePointOrder
local Player = jass.Player
local SetUnitOwner = jass.SetUnitOwner
local SetUnitPosition = jass.SetUnitPosition
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local function _____8BFB_53D6_536B_961F_957F()
    return YDUserDataGetSafe("string", "主线NPC", "蛇人族卫队长", "unit")
end
____exports["执行蛇人族卫队长入场"] = function(_____53C2_6570)
    local _____961F_957F = _____8BFB_53D6_536B_961F_957F()
    if _____961F_957F == nil or _____961F_957F == 0 then
        local _____961F_957F_7C7B_578BID = stringToFourCCSafe("h01D")
        if not (_____961F_957F_7C7B_578BID > 0) then
            return
        end
        _____961F_957F = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
            Player(6),
            _____961F_957F_7C7B_578BID,
            __TS__Number(_____53C2_6570["出生X"]) or -22935.9,
            __TS__Number(_____53C2_6570["出生Y"]) or 3154.3,
            0
        )
        if _____961F_957F ~= nil and _____961F_957F ~= 0 then
            YDUserDataSetSafe(
                "string",
                "主线NPC",
                "蛇人族卫队长",
                "unit",
                _____961F_957F
            )
        end
    end
    if _____961F_957F == nil or _____961F_957F == 0 then
        return
    end
    IssuePointOrder(
        _____961F_957F,
        "move",
        __TS__Number(_____53C2_6570["目标X"]) or -21023.4,
        __TS__Number(_____53C2_6570["目标Y"]) or 3259.5
    )
end
____exports["执行蛇人族护卫对战目标刷新"] = function(_____53C2_6570)
    local _____961F_957F = _____8BFB_53D6_536B_961F_957F()
    if _____961F_957F == nil or _____961F_957F == 0 then
        return
    end
    SetUnitOwner(
        _____961F_957F,
        Player(PLAYER_NEUTRAL_PASSIVE),
        true
    )
    SetUnitPosition(
        _____961F_957F,
        __TS__Number(_____53C2_6570["目标X"]) or -21023.4,
        __TS__Number(_____53C2_6570["目标Y"]) or 3259.5
    )
end
____exports["蛇人族卫队长试炼剧情动作注册表"] = {["SRZ蛇人族_卫队长入场"] = ____exports["执行蛇人族卫队长入场"], ["SRZ蛇人族_护卫对战目标刷新"] = ____exports["执行蛇人族护卫对战目标刷新"]}
return ____exports
