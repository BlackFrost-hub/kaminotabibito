local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
do
    local ____13_FF0E_86C7_4EBA_65CF_4EA4_8FD8_98DF_4EBA_9B54_51ED_8BC1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.13．蛇人族交还食人魔凭证")
    ____exports["蛇人族交凭证剧情片段"] = ____13_FF0E_86C7_4EBA_65CF_4EA4_8FD8_98DF_4EBA_9B54_51ED_8BC1["蛇人族交凭证剧情片段"]
end
local CreateUnit = jass.CreateUnit
local IssueImmediateOrder = jass.IssueImmediateOrder
local IssuePointOrder = jass.IssuePointOrder
local Player = jass.Player
____exports["执行蛇人族交还食人魔凭证"] = function(_____53C2_6570)
    local _____89E6_53D1_5355_4F4D = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"]
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        IssueImmediateOrder(_____89E6_53D1_5355_4F4D, "stop")
    end
    local _____961F_957F_7C7B_578BID = stringToFourCCSafe("h01D")
    if not (_____961F_957F_7C7B_578BID > 0) then
        return
    end
    local _____961F_957F = CreateUnit(
        Player(6),
        _____961F_957F_7C7B_578BID,
        -22935.9,
        3154.3,
        0
    )
    if _____961F_957F == nil or _____961F_957F == 0 then
        return
    end
    YDUserDataSetSafe(
        "string",
        "主线NPC",
        "蛇人族卫队长",
        "unit",
        _____961F_957F
    )
    IssuePointOrder(
        _____961F_957F,
        "move",
        __TS__Number(_____53C2_6570["目标X"]) or -21023.4,
        __TS__Number(_____53C2_6570["目标Y"]) or 3259.5
    )
end
____exports["蛇人族交还食人魔凭证剧情动作注册表"] = {["SRZ蛇人族_交还食人魔凭证"] = ____exports["执行蛇人族交还食人魔凭证"]}
return ____exports
