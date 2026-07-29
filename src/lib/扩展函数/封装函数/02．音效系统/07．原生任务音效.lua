--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local GetLocalPlayer = jass.GetLocalPlayer
local StartSound = jass.StartSound
local function _____83B7_53D6_539F_751F_4EFB_52A1_97F3_6548_53E5_67C4(_____7C7B_578B)
    repeat
        local ____switch3 = _____7C7B_578B
        local ____cond3 = ____switch3 == "发现任务"
        if ____cond3 then
            return jglobals.bj_questDiscoveredSound
        end
        ____cond3 = ____cond3 or ____switch3 == "任务更新"
        if ____cond3 then
            return jglobals.bj_questUpdatedSound
        end
        ____cond3 = ____cond3 or ____switch3 == "任务完成"
        if ____cond3 then
            return jglobals.bj_questCompletedSound
        end
        ____cond3 = ____cond3 or (____switch3 == "任务失败" or ____switch3 == "关卡失败")
        if ____cond3 then
            return jglobals.bj_questFailedSound
        end
        ____cond3 = ____cond3 or (____switch3 == "提示" or ____switch3 == "简单提示" or ____switch3 == "获得新单位" or ____switch3 == "新单位可用")
        if ____cond3 then
            return jglobals.bj_questHintSound
        end
        ____cond3 = ____cond3 or ____switch3 == "秘密"
        if ____cond3 then
            return jglobals.bj_questSecretSound
        end
        ____cond3 = ____cond3 or ____switch3 == "警告"
        if ____cond3 then
            return jglobals.bj_questWarningSound
        end
        ____cond3 = ____cond3 or ____switch3 == "收到新物品"
        if ____cond3 then
            return jglobals.bj_questItemAcquiredSound
        end
        ____cond3 = ____cond3 or ____switch3 == "任务要求"
        if ____cond3 then
            return nil
        end
    until true
end
--- 只播放任务消息所对应的魔兽原生音效，不显示任务文本。
-- whichPlayer 为空时全体客户端播放；传玩家时只在该玩家本机播放。
____exports["播放原生任务音效"] = function(_____7C7B_578B, whichPlayer)
    if whichPlayer ~= nil and whichPlayer ~= 0 and GetLocalPlayer() ~= whichPlayer then
        return
    end
    local soundHandle = _____83B7_53D6_539F_751F_4EFB_52A1_97F3_6548_53E5_67C4(_____7C7B_578B)
    if soundHandle == nil or soundHandle == 0 then
        return
    end
    StartSound(soundHandle)
end
return ____exports
