--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____jglobals_bj_QUESTMESSAGE_DISCOVERED_0 = jglobals.bj_QUESTMESSAGE_DISCOVERED
if ____jglobals_bj_QUESTMESSAGE_DISCOVERED_0 == nil then
    ____jglobals_bj_QUESTMESSAGE_DISCOVERED_0 = 0
end
local bj_QUESTMESSAGE_DISCOVERED = ____jglobals_bj_QUESTMESSAGE_DISCOVERED_0
local ____jglobals_bj_QUESTMESSAGE_UPDATED_1 = jglobals.bj_QUESTMESSAGE_UPDATED
if ____jglobals_bj_QUESTMESSAGE_UPDATED_1 == nil then
    ____jglobals_bj_QUESTMESSAGE_UPDATED_1 = 1
end
local bj_QUESTMESSAGE_UPDATED = ____jglobals_bj_QUESTMESSAGE_UPDATED_1
local ____jglobals_bj_QUESTMESSAGE_COMPLETED_2 = jglobals.bj_QUESTMESSAGE_COMPLETED
if ____jglobals_bj_QUESTMESSAGE_COMPLETED_2 == nil then
    ____jglobals_bj_QUESTMESSAGE_COMPLETED_2 = 2
end
local bj_QUESTMESSAGE_COMPLETED = ____jglobals_bj_QUESTMESSAGE_COMPLETED_2
local ____jglobals_bj_QUESTMESSAGE_FAILED_3 = jglobals.bj_QUESTMESSAGE_FAILED
if ____jglobals_bj_QUESTMESSAGE_FAILED_3 == nil then
    ____jglobals_bj_QUESTMESSAGE_FAILED_3 = 3
end
local bj_QUESTMESSAGE_FAILED = ____jglobals_bj_QUESTMESSAGE_FAILED_3
local ____jglobals_bj_QUESTMESSAGE_REQUIREMENT_4 = jglobals.bj_QUESTMESSAGE_REQUIREMENT
if ____jglobals_bj_QUESTMESSAGE_REQUIREMENT_4 == nil then
    ____jglobals_bj_QUESTMESSAGE_REQUIREMENT_4 = 4
end
local bj_QUESTMESSAGE_REQUIREMENT = ____jglobals_bj_QUESTMESSAGE_REQUIREMENT_4
local ____jglobals_bj_QUESTMESSAGE_MISSIONFAILED_5 = jglobals.bj_QUESTMESSAGE_MISSIONFAILED
if ____jglobals_bj_QUESTMESSAGE_MISSIONFAILED_5 == nil then
    ____jglobals_bj_QUESTMESSAGE_MISSIONFAILED_5 = 5
end
local bj_QUESTMESSAGE_MISSIONFAILED = ____jglobals_bj_QUESTMESSAGE_MISSIONFAILED_5
local ____jglobals_bj_QUESTMESSAGE_HINT_6 = jglobals.bj_QUESTMESSAGE_HINT
if ____jglobals_bj_QUESTMESSAGE_HINT_6 == nil then
    ____jglobals_bj_QUESTMESSAGE_HINT_6 = 6
end
local bj_QUESTMESSAGE_HINT = ____jglobals_bj_QUESTMESSAGE_HINT_6
local ____jglobals_bj_QUESTMESSAGE_ALWAYSHINT_7 = jglobals.bj_QUESTMESSAGE_ALWAYSHINT
if ____jglobals_bj_QUESTMESSAGE_ALWAYSHINT_7 == nil then
    ____jglobals_bj_QUESTMESSAGE_ALWAYSHINT_7 = 7
end
local bj_QUESTMESSAGE_ALWAYSHINT = ____jglobals_bj_QUESTMESSAGE_ALWAYSHINT_7
local ____jglobals_bj_QUESTMESSAGE_SECRET_8 = jglobals.bj_QUESTMESSAGE_SECRET
if ____jglobals_bj_QUESTMESSAGE_SECRET_8 == nil then
    ____jglobals_bj_QUESTMESSAGE_SECRET_8 = 8
end
local bj_QUESTMESSAGE_SECRET = ____jglobals_bj_QUESTMESSAGE_SECRET_8
local ____jglobals_bj_QUESTMESSAGE_UNITACQUIRED_9 = jglobals.bj_QUESTMESSAGE_UNITACQUIRED
if ____jglobals_bj_QUESTMESSAGE_UNITACQUIRED_9 == nil then
    ____jglobals_bj_QUESTMESSAGE_UNITACQUIRED_9 = 9
end
local bj_QUESTMESSAGE_UNITACQUIRED = ____jglobals_bj_QUESTMESSAGE_UNITACQUIRED_9
local ____jglobals_bj_QUESTMESSAGE_UNITAVAILABLE_10 = jglobals.bj_QUESTMESSAGE_UNITAVAILABLE
if ____jglobals_bj_QUESTMESSAGE_UNITAVAILABLE_10 == nil then
    ____jglobals_bj_QUESTMESSAGE_UNITAVAILABLE_10 = 10
end
local bj_QUESTMESSAGE_UNITAVAILABLE = ____jglobals_bj_QUESTMESSAGE_UNITAVAILABLE_10
local ____jglobals_bj_QUESTMESSAGE_ITEMACQUIRED_11 = jglobals.bj_QUESTMESSAGE_ITEMACQUIRED
if ____jglobals_bj_QUESTMESSAGE_ITEMACQUIRED_11 == nil then
    ____jglobals_bj_QUESTMESSAGE_ITEMACQUIRED_11 = 11
end
local bj_QUESTMESSAGE_ITEMACQUIRED = ____jglobals_bj_QUESTMESSAGE_ITEMACQUIRED_11
local ____jglobals_bj_QUESTMESSAGE_WARNING_12 = jglobals.bj_QUESTMESSAGE_WARNING
if ____jglobals_bj_QUESTMESSAGE_WARNING_12 == nil then
    ____jglobals_bj_QUESTMESSAGE_WARNING_12 = 12
end
local bj_QUESTMESSAGE_WARNING = ____jglobals_bj_QUESTMESSAGE_WARNING_12
local ____jglobals_bj_TEXT_DELAY_QUEST_13 = jglobals.bj_TEXT_DELAY_QUEST
if ____jglobals_bj_TEXT_DELAY_QUEST_13 == nil then
    ____jglobals_bj_TEXT_DELAY_QUEST_13 = 10
end
local bj_TEXT_DELAY_QUEST = ____jglobals_bj_TEXT_DELAY_QUEST_13
local ____jglobals_bj_TEXT_DELAY_QUESTUPDATE_14 = jglobals.bj_TEXT_DELAY_QUESTUPDATE
if ____jglobals_bj_TEXT_DELAY_QUESTUPDATE_14 == nil then
    ____jglobals_bj_TEXT_DELAY_QUESTUPDATE_14 = 10
end
local bj_TEXT_DELAY_QUESTUPDATE = ____jglobals_bj_TEXT_DELAY_QUESTUPDATE_14
local ____jglobals_bj_TEXT_DELAY_QUESTDONE_15 = jglobals.bj_TEXT_DELAY_QUESTDONE
if ____jglobals_bj_TEXT_DELAY_QUESTDONE_15 == nil then
    ____jglobals_bj_TEXT_DELAY_QUESTDONE_15 = 10
end
local bj_TEXT_DELAY_QUESTDONE = ____jglobals_bj_TEXT_DELAY_QUESTDONE_15
local ____jglobals_bj_TEXT_DELAY_QUESTFAILED_16 = jglobals.bj_TEXT_DELAY_QUESTFAILED
if ____jglobals_bj_TEXT_DELAY_QUESTFAILED_16 == nil then
    ____jglobals_bj_TEXT_DELAY_QUESTFAILED_16 = 10
end
local bj_TEXT_DELAY_QUESTFAILED = ____jglobals_bj_TEXT_DELAY_QUESTFAILED_16
local ____jglobals_bj_TEXT_DELAY_QUESTREQUIREMENT_17 = jglobals.bj_TEXT_DELAY_QUESTREQUIREMENT
if ____jglobals_bj_TEXT_DELAY_QUESTREQUIREMENT_17 == nil then
    ____jglobals_bj_TEXT_DELAY_QUESTREQUIREMENT_17 = 10
end
local bj_TEXT_DELAY_QUESTREQUIREMENT = ____jglobals_bj_TEXT_DELAY_QUESTREQUIREMENT_17
local ____jglobals_bj_TEXT_DELAY_MISSIONFAILED_18 = jglobals.bj_TEXT_DELAY_MISSIONFAILED
if ____jglobals_bj_TEXT_DELAY_MISSIONFAILED_18 == nil then
    ____jglobals_bj_TEXT_DELAY_MISSIONFAILED_18 = 10
end
local bj_TEXT_DELAY_MISSIONFAILED = ____jglobals_bj_TEXT_DELAY_MISSIONFAILED_18
local ____jglobals_bj_TEXT_DELAY_HINT_19 = jglobals.bj_TEXT_DELAY_HINT
if ____jglobals_bj_TEXT_DELAY_HINT_19 == nil then
    ____jglobals_bj_TEXT_DELAY_HINT_19 = 10
end
local bj_TEXT_DELAY_HINT = ____jglobals_bj_TEXT_DELAY_HINT_19
local ____jglobals_bj_TEXT_DELAY_ALWAYSHINT_20 = jglobals.bj_TEXT_DELAY_ALWAYSHINT
if ____jglobals_bj_TEXT_DELAY_ALWAYSHINT_20 == nil then
    ____jglobals_bj_TEXT_DELAY_ALWAYSHINT_20 = 10
end
local bj_TEXT_DELAY_ALWAYSHINT = ____jglobals_bj_TEXT_DELAY_ALWAYSHINT_20
local ____jglobals_bj_TEXT_DELAY_SECRET_21 = jglobals.bj_TEXT_DELAY_SECRET
if ____jglobals_bj_TEXT_DELAY_SECRET_21 == nil then
    ____jglobals_bj_TEXT_DELAY_SECRET_21 = 10
end
local bj_TEXT_DELAY_SECRET = ____jglobals_bj_TEXT_DELAY_SECRET_21
local ____jglobals_bj_TEXT_DELAY_UNITACQUIRED_22 = jglobals.bj_TEXT_DELAY_UNITACQUIRED
if ____jglobals_bj_TEXT_DELAY_UNITACQUIRED_22 == nil then
    ____jglobals_bj_TEXT_DELAY_UNITACQUIRED_22 = 10
end
local bj_TEXT_DELAY_UNITACQUIRED = ____jglobals_bj_TEXT_DELAY_UNITACQUIRED_22
local ____jglobals_bj_TEXT_DELAY_UNITAVAILABLE_23 = jglobals.bj_TEXT_DELAY_UNITAVAILABLE
if ____jglobals_bj_TEXT_DELAY_UNITAVAILABLE_23 == nil then
    ____jglobals_bj_TEXT_DELAY_UNITAVAILABLE_23 = 10
end
local bj_TEXT_DELAY_UNITAVAILABLE = ____jglobals_bj_TEXT_DELAY_UNITAVAILABLE_23
local ____jglobals_bj_TEXT_DELAY_ITEMACQUIRED_24 = jglobals.bj_TEXT_DELAY_ITEMACQUIRED
if ____jglobals_bj_TEXT_DELAY_ITEMACQUIRED_24 == nil then
    ____jglobals_bj_TEXT_DELAY_ITEMACQUIRED_24 = 10
end
local bj_TEXT_DELAY_ITEMACQUIRED = ____jglobals_bj_TEXT_DELAY_ITEMACQUIRED_24
local ____jglobals_bj_TEXT_DELAY_WARNING_25 = jglobals.bj_TEXT_DELAY_WARNING
if ____jglobals_bj_TEXT_DELAY_WARNING_25 == nil then
    ____jglobals_bj_TEXT_DELAY_WARNING_25 = 10
end
local bj_TEXT_DELAY_WARNING = ____jglobals_bj_TEXT_DELAY_WARNING_25
local ____jglobals_bj_questDiscoveredSound_26 = jglobals.bj_questDiscoveredSound
if ____jglobals_bj_questDiscoveredSound_26 == nil then
    ____jglobals_bj_questDiscoveredSound_26 = nil
end
local bj_questDiscoveredSound = ____jglobals_bj_questDiscoveredSound_26
local ____jglobals_bj_questUpdatedSound_27 = jglobals.bj_questUpdatedSound
if ____jglobals_bj_questUpdatedSound_27 == nil then
    ____jglobals_bj_questUpdatedSound_27 = nil
end
local bj_questUpdatedSound = ____jglobals_bj_questUpdatedSound_27
local ____jglobals_bj_questCompletedSound_28 = jglobals.bj_questCompletedSound
if ____jglobals_bj_questCompletedSound_28 == nil then
    ____jglobals_bj_questCompletedSound_28 = nil
end
local bj_questCompletedSound = ____jglobals_bj_questCompletedSound_28
local ____jglobals_bj_questFailedSound_29 = jglobals.bj_questFailedSound
if ____jglobals_bj_questFailedSound_29 == nil then
    ____jglobals_bj_questFailedSound_29 = nil
end
local bj_questFailedSound = ____jglobals_bj_questFailedSound_29
local ____jglobals_bj_questHintSound_30 = jglobals.bj_questHintSound
if ____jglobals_bj_questHintSound_30 == nil then
    ____jglobals_bj_questHintSound_30 = nil
end
local bj_questHintSound = ____jglobals_bj_questHintSound_30
local ____jglobals_bj_questSecretSound_31 = jglobals.bj_questSecretSound
if ____jglobals_bj_questSecretSound_31 == nil then
    ____jglobals_bj_questSecretSound_31 = nil
end
local bj_questSecretSound = ____jglobals_bj_questSecretSound_31
local ____jglobals_bj_questItemAcquiredSound_32 = jglobals.bj_questItemAcquiredSound
if ____jglobals_bj_questItemAcquiredSound_32 == nil then
    ____jglobals_bj_questItemAcquiredSound_32 = nil
end
local bj_questItemAcquiredSound = ____jglobals_bj_questItemAcquiredSound_32
local ____jglobals_bj_questWarningSound_33 = jglobals.bj_questWarningSound
if ____jglobals_bj_questWarningSound_33 == nil then
    ____jglobals_bj_questWarningSound_33 = nil
end
local bj_questWarningSound = ____jglobals_bj_questWarningSound_33
function ____exports.QuestMessageBJ(self, f, messageType, message)
    if type(jass.IsPlayerInForce) ~= "function" or type(jass.GetLocalPlayer) ~= "function" or not jass.IsPlayerInForce(
        jass.GetLocalPlayer(),
        f
    ) then
        return
    end
    local lp = jass.GetLocalPlayer()
    if type(jass.DisplayTimedTextToPlayer) ~= "function" then
        return
    end
    local function play(____, s)
        if s ~= nil and type(jass.StartSound) == "function" then
            jass.StartSound(s)
        end
    end
    local function flash()
        if type(jass.FlashQuestDialogButton) == "function" then
            jass.FlashQuestDialogButton()
        end
    end
    if messageType == bj_QUESTMESSAGE_DISCOVERED then
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_QUEST,
            " "
        )
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_QUEST,
            message
        )
        play(nil, bj_questDiscoveredSound)
        flash(nil)
        return
    end
    if messageType == bj_QUESTMESSAGE_UPDATED then
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_QUESTUPDATE,
            " "
        )
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_QUESTUPDATE,
            message
        )
        play(nil, bj_questUpdatedSound)
        flash(nil)
        return
    end
    if messageType == bj_QUESTMESSAGE_COMPLETED then
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_QUESTDONE,
            " "
        )
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_QUESTDONE,
            message
        )
        play(nil, bj_questCompletedSound)
        flash(nil)
        return
    end
    if messageType == bj_QUESTMESSAGE_FAILED then
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_QUESTFAILED,
            " "
        )
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_QUESTFAILED,
            message
        )
        play(nil, bj_questFailedSound)
        flash(nil)
        return
    end
    if messageType == bj_QUESTMESSAGE_REQUIREMENT then
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_QUESTREQUIREMENT,
            message
        )
        return
    end
    if messageType == bj_QUESTMESSAGE_MISSIONFAILED then
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_MISSIONFAILED,
            " "
        )
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_MISSIONFAILED,
            message
        )
        play(nil, bj_questFailedSound)
        return
    end
    if messageType == bj_QUESTMESSAGE_HINT then
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_HINT,
            " "
        )
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_HINT,
            message
        )
        play(nil, bj_questHintSound)
        return
    end
    if messageType == bj_QUESTMESSAGE_ALWAYSHINT then
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_ALWAYSHINT,
            " "
        )
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_ALWAYSHINT,
            message
        )
        play(nil, bj_questHintSound)
        return
    end
    if messageType == bj_QUESTMESSAGE_SECRET then
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_SECRET,
            " "
        )
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_SECRET,
            message
        )
        play(nil, bj_questSecretSound)
        return
    end
    if messageType == bj_QUESTMESSAGE_UNITACQUIRED then
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_UNITACQUIRED,
            " "
        )
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_UNITACQUIRED,
            message
        )
        play(nil, bj_questHintSound)
        return
    end
    if messageType == bj_QUESTMESSAGE_UNITAVAILABLE then
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_UNITAVAILABLE,
            " "
        )
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_UNITAVAILABLE,
            message
        )
        play(nil, bj_questHintSound)
        return
    end
    if messageType == bj_QUESTMESSAGE_ITEMACQUIRED then
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_ITEMACQUIRED,
            " "
        )
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_ITEMACQUIRED,
            message
        )
        play(nil, bj_questItemAcquiredSound)
        return
    end
    if messageType == bj_QUESTMESSAGE_WARNING then
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_WARNING,
            " "
        )
        jass.DisplayTimedTextToPlayer(
            lp,
            0,
            0,
            bj_TEXT_DELAY_WARNING,
            message
        )
        play(nil, bj_questWarningSound)
    end
end
return ____exports
