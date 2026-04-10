const jass = require("jass.common");
const jglobals = require("jass.globals");
const bj_QUESTMESSAGE_DISCOVERED = jglobals.bj_QUESTMESSAGE_DISCOVERED ?? 0;
const bj_QUESTMESSAGE_UPDATED = jglobals.bj_QUESTMESSAGE_UPDATED ?? 1;
const bj_QUESTMESSAGE_COMPLETED = jglobals.bj_QUESTMESSAGE_COMPLETED ?? 2;
const bj_QUESTMESSAGE_FAILED = jglobals.bj_QUESTMESSAGE_FAILED ?? 3;
const bj_QUESTMESSAGE_REQUIREMENT = jglobals.bj_QUESTMESSAGE_REQUIREMENT ?? 4;
const bj_QUESTMESSAGE_MISSIONFAILED = jglobals.bj_QUESTMESSAGE_MISSIONFAILED ?? 5;
const bj_QUESTMESSAGE_HINT = jglobals.bj_QUESTMESSAGE_HINT ?? 6;
const bj_QUESTMESSAGE_ALWAYSHINT = jglobals.bj_QUESTMESSAGE_ALWAYSHINT ?? 7;
const bj_QUESTMESSAGE_SECRET = jglobals.bj_QUESTMESSAGE_SECRET ?? 8;
const bj_QUESTMESSAGE_UNITACQUIRED = jglobals.bj_QUESTMESSAGE_UNITACQUIRED ?? 9;
const bj_QUESTMESSAGE_UNITAVAILABLE = jglobals.bj_QUESTMESSAGE_UNITAVAILABLE ?? 10;
const bj_QUESTMESSAGE_ITEMACQUIRED = jglobals.bj_QUESTMESSAGE_ITEMACQUIRED ?? 11;
const bj_QUESTMESSAGE_WARNING = jglobals.bj_QUESTMESSAGE_WARNING ?? 12;
const bj_TEXT_DELAY_QUEST = jglobals.bj_TEXT_DELAY_QUEST ?? 10;
const bj_TEXT_DELAY_QUESTUPDATE = jglobals.bj_TEXT_DELAY_QUESTUPDATE ?? 10;
const bj_TEXT_DELAY_QUESTDONE = jglobals.bj_TEXT_DELAY_QUESTDONE ?? 10;
const bj_TEXT_DELAY_QUESTFAILED = jglobals.bj_TEXT_DELAY_QUESTFAILED ?? 10;
const bj_TEXT_DELAY_QUESTREQUIREMENT = jglobals.bj_TEXT_DELAY_QUESTREQUIREMENT ?? 10;
const bj_TEXT_DELAY_MISSIONFAILED = jglobals.bj_TEXT_DELAY_MISSIONFAILED ?? 10;
const bj_TEXT_DELAY_HINT = jglobals.bj_TEXT_DELAY_HINT ?? 10;
const bj_TEXT_DELAY_ALWAYSHINT = jglobals.bj_TEXT_DELAY_ALWAYSHINT ?? 10;
const bj_TEXT_DELAY_SECRET = jglobals.bj_TEXT_DELAY_SECRET ?? 10;
const bj_TEXT_DELAY_UNITACQUIRED = jglobals.bj_TEXT_DELAY_UNITACQUIRED ?? 10;
const bj_TEXT_DELAY_UNITAVAILABLE = jglobals.bj_TEXT_DELAY_UNITAVAILABLE ?? 10;
const bj_TEXT_DELAY_ITEMACQUIRED = jglobals.bj_TEXT_DELAY_ITEMACQUIRED ?? 10;
const bj_TEXT_DELAY_WARNING = jglobals.bj_TEXT_DELAY_WARNING ?? 10;
const bj_questDiscoveredSound = jglobals.bj_questDiscoveredSound ?? null;
const bj_questUpdatedSound = jglobals.bj_questUpdatedSound ?? null;
const bj_questCompletedSound = jglobals.bj_questCompletedSound ?? null;
const bj_questFailedSound = jglobals.bj_questFailedSound ?? null;
const bj_questHintSound = jglobals.bj_questHintSound ?? null;
const bj_questSecretSound = jglobals.bj_questSecretSound ?? null;
const bj_questItemAcquiredSound = jglobals.bj_questItemAcquiredSound ?? null;
const bj_questWarningSound = jglobals.bj_questWarningSound ?? null;
export function QuestMessageBJ(f, messageType, message) {
    if (typeof jass.IsPlayerInForce !== "function" ||
        typeof jass.GetLocalPlayer !== "function" ||
        !jass.IsPlayerInForce(jass.GetLocalPlayer(), f)) {
        return;
    }
    const lp = jass.GetLocalPlayer();
    if (typeof jass.DisplayTimedTextToPlayer !== "function")
        return;
    const play = (s) => {
        if (s != null && typeof jass.StartSound === "function")
            jass.StartSound(s);
    };
    const flash = () => {
        if (typeof jass.FlashQuestDialogButton === "function")
            jass.FlashQuestDialogButton();
    };
    if (messageType === bj_QUESTMESSAGE_DISCOVERED) {
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_QUEST, " ");
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_QUEST, message);
        play(bj_questDiscoveredSound);
        flash();
        return;
    }
    if (messageType === bj_QUESTMESSAGE_UPDATED) {
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_QUESTUPDATE, " ");
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_QUESTUPDATE, message);
        play(bj_questUpdatedSound);
        flash();
        return;
    }
    if (messageType === bj_QUESTMESSAGE_COMPLETED) {
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_QUESTDONE, " ");
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_QUESTDONE, message);
        play(bj_questCompletedSound);
        flash();
        return;
    }
    if (messageType === bj_QUESTMESSAGE_FAILED) {
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_QUESTFAILED, " ");
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_QUESTFAILED, message);
        play(bj_questFailedSound);
        flash();
        return;
    }
    if (messageType === bj_QUESTMESSAGE_REQUIREMENT) {
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_QUESTREQUIREMENT, message);
        return;
    }
    if (messageType === bj_QUESTMESSAGE_MISSIONFAILED) {
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_MISSIONFAILED, " ");
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_MISSIONFAILED, message);
        play(bj_questFailedSound);
        return;
    }
    if (messageType === bj_QUESTMESSAGE_HINT) {
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_HINT, " ");
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_HINT, message);
        play(bj_questHintSound);
        return;
    }
    if (messageType === bj_QUESTMESSAGE_ALWAYSHINT) {
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_ALWAYSHINT, " ");
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_ALWAYSHINT, message);
        play(bj_questHintSound);
        return;
    }
    if (messageType === bj_QUESTMESSAGE_SECRET) {
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_SECRET, " ");
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_SECRET, message);
        play(bj_questSecretSound);
        return;
    }
    if (messageType === bj_QUESTMESSAGE_UNITACQUIRED) {
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_UNITACQUIRED, " ");
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_UNITACQUIRED, message);
        play(bj_questHintSound);
        return;
    }
    if (messageType === bj_QUESTMESSAGE_UNITAVAILABLE) {
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_UNITAVAILABLE, " ");
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_UNITAVAILABLE, message);
        play(bj_questHintSound);
        return;
    }
    if (messageType === bj_QUESTMESSAGE_ITEMACQUIRED) {
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_ITEMACQUIRED, " ");
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_ITEMACQUIRED, message);
        play(bj_questItemAcquiredSound);
        return;
    }
    if (messageType === bj_QUESTMESSAGE_WARNING) {
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_WARNING, " ");
        jass.DisplayTimedTextToPlayer(lp, 0, 0, bj_TEXT_DELAY_WARNING, message);
        play(bj_questWarningSound);
    }
}
