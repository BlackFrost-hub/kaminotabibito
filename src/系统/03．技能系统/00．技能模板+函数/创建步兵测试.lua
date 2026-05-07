--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local Player = jass.Player
local CreateUnit = jass.CreateUnit
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.05．召唤物")
local _____5FEB_6377_521B_5EFA_53EC_5524_7269 = ____require_result_0["快捷创建召唤物"]
local _____542F_7528_6D4B_8BD5 = false
if _____542F_7528_6D4B_8BD5 then
    local _____73A9_5BB60 = Player(0)
    local _____4E3B_82F1_96C4 = CreateUnit(
        _____73A9_5BB60,
        1214869684,
        0,
        0,
        0
    )
    if _____4E3B_82F1_96C4 then
        local _____53EC_5524_7269 = _____5FEB_6377_521B_5EFA_53EC_5524_7269(
            nil,
            _____4E3B_82F1_96C4,
            "hfoo",
            100,
            100,
            30
        )
        if _____53EC_5524_7269 then
            DisplayTimedTextToPlayer(
                _____73A9_5BB60,
                0,
                0,
                10,
                "步兵召唤成功"
            )
        else
            DisplayTimedTextToPlayer(
                _____73A9_5BB60,
                0,
                0,
                10,
                "步兵召唤失败"
            )
        end
    else
        DisplayTimedTextToPlayer(
            _____73A9_5BB60,
            0,
            0,
            10,
            "英雄创建失败"
        )
    end
end
return ____exports
