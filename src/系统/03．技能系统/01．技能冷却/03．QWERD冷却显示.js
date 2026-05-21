/** @noSelfInFile */
const jass = require("jass.common");
const japi = require("jass.japi");
const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器");
const selectionCenterSystem = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心");
const 获取玩家唯一选中单位 = selectionCenterSystem.getSoleSelectedUnitForPlayer;
const 功能开关模块 = require("系统.00．核心系统.02．功能开关.01．QWERD显示开关");
const heroBridge = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接");
const commandBarAbility = require("系统.03．技能系统.01．技能冷却.04．命令卡技能槽位");
const ydweAbility = require("lib.扩展函数.YDWE函数.00．YDWE函数");
const { YDWEGetUnitAbilityState } = ydweAbility;
const fourCCTools = require("lib.扩展函数.封装函数.01．通用工具.index");
const fourCCToStringRaw = fourCCTools.fourCCToString;
const DzGetGameUI = japi.DzGetGameUI;
const DzCreateFrameByTagName = japi.DzCreateFrameByTagName;
const DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton;
const DzFrameSetPoint = japi.DzFrameSetPoint;
const DzFrameSetSize = japi.DzFrameSetSize;
const DzFrameSetFont = japi.DzFrameSetFont;
const DzFrameSetText = japi.DzFrameSetText;
const DzFrameSetTextColor = japi.DzFrameSetTextColor;
const DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment;
const DzFrameShow = japi.DzFrameShow;
const DEBUG_FORCE_PLACEHOLDER = true;
const REFRESH_MS = 100;
const OFFSET_X = 0.010;
const OFFSET_Y = 0.006;
const SHADOW_OFFSET_X = -0.0012;
const SHADOW_OFFSET_Y = -0.0012;
const FONT_FILE = "UI\\uizt.ttf";
const FONT_SIZE = 0.020;
const TEXT_W = 0.042;
const TEXT_H = 0.020;
const 固定槽位表 = {
    Q: { x: 0, y: 2 },
    W: { x: 1, y: 2 },
    E: { x: 2, y: 2 },
    R: { x: 3, y: 2 },
};
let initialized = false;
let 文本框缓存 = null;
function isValidHandle(handle) {
    return handle != null && handle !== 0;
}
function 安全设置文本(frame, text) {
    if (!isValidHandle(frame))
        return;
    DzFrameSetText(frame, text);
}
function 安全显示框体(frame, visible) {
    if (!isValidHandle(frame))
        return;
    DzFrameShow(frame, visible);
}
function 安全设置锚点(frame, relativeFrame, x, y) {
    if (!isValidHandle(frame) || !isValidHandle(relativeFrame))
        return;
    DzFrameSetPoint(frame, 8, relativeFrame, 8, x, y);
}
function 读取玩家唯一选中单位(playerId) {
    if (typeof 获取玩家唯一选中单位 !== "function")
        return null;
    return 获取玩家唯一选中单位(playerId);
}
function getHeroSource(localPlayer) {
    const playerId = jass.GetPlayerId(localPlayer);
    const selectedUnit = 读取玩家唯一选中单位(playerId);
    if (!isValidHandle(selectedUnit))
        return null;
    if (jass.IsUnitType(selectedUnit, jass.UNIT_TYPE_HERO) !== true)
        return null;
    const owner = jass.GetOwningPlayer(selectedUnit);
    if (!isValidHandle(owner))
        return null;
    const registeredHero = heroBridge.getRegisteredPlayerHero(owner);
    if (!isValidHandle(registeredHero))
        return null;
    if (registeredHero !== selectedUnit)
        return null;
    return selectedUnit;
}
function getLocalHero() {
    const localPlayer = jass.GetLocalPlayer();
    if (!isValidHandle(localPlayer))
        return null;
    return getHeroSource(localPlayer);
}
function createTextFrame(name, r, g, b, a) {
    const gameUI = DzGetGameUI();
    if (!isValidHandle(gameUI))
        return 0;
    const frame = DzCreateFrameByTagName("TEXT", name, gameUI, "template", 0);
    if (!isValidHandle(frame))
        return 0;
    DzFrameSetSize(frame, TEXT_W, TEXT_H);
    DzFrameSetText(frame, "");
    DzFrameSetFont(frame, FONT_FILE, FONT_SIZE, 0);
    DzFrameSetTextAlignment(frame, -1);
    DzFrameSetTextAlignment(frame, 8);
    DzFrameSetTextColor(frame, r, g, b, a);
    DzFrameShow(frame, false);
    return frame;
}
function 确保文本框缓存() {
    if (文本框缓存 != null)
        return 文本框缓存;
    文本框缓存 = {
        主文本: { Q: 0, W: 0, E: 0, R: 0, D: 0 },
        阴影文本: { Q: 0, W: 0, E: 0, R: 0, D: 0 },
    };
    return 文本框缓存;
}
function fourCCText(abilityId) {
    if (abilityId === 0)
        return "0";
    return fourCCToStringRaw(abilityId);
}
function getCooldown(whichHero, abilityId) {
    if (!isValidHandle(whichHero) || abilityId === 0)
        return 0;
    return YDWEGetUnitAbilityState(whichHero, abilityId, ydweAbility.ABILITY_STATE_COOLDOWN) || 0;
}
function formatCooldown(cooldown) {
    if (!(cooldown > 0.05))
        return "";
    const tenth = jass.R2I(cooldown * 10 + 0.5);
    const sec = jass.R2I(tenth / 10);
    const decimal = tenth - sec * 10;
    return jass.I2S(sec) + "." + jass.I2S(decimal);
}
function toWhiteText(text) {
    if (text === "")
        return "";
    return `|cfffff2d8${text}|r`;
}
function toShadowText(text) {
    if (text === "")
        return "";
    return `|cff101010${text}|r`;
}
function 构建显示文本(hotkey, abilityId, cooldown) {
    const cdText = formatCooldown(cooldown);
    if (cdText !== "")
        return cdText;
    if (DEBUG_FORCE_PLACEHOLDER && abilityId !== 0)
        return hotkey;
    return "";
}
function 解析槽位(whichHero, hotkey) {
    if (hotkey === "D") {
        const dSlot = commandBarAbility.获取D技能槽位(whichHero);
        return { x: dSlot[0], y: dSlot[1] };
    }
    return 固定槽位表[hotkey];
}
function 获取按钮框(whichHero, hotkey) {
    const slot = 解析槽位(whichHero, hotkey);
    return DzFrameGetCommandBarButton(slot.y, slot.x);
}
function 获取技能Id(whichHero, hotkey) {
    const slot = 解析槽位(whichHero, hotkey);
    return commandBarAbility.读取命令卡按钮能力Id(slot.x, slot.y);
}
function 刷新单个技能(whichHero, hotkey, textFrame, shadowFrame) {
    const buttonFrame = 获取按钮框(whichHero, hotkey);
    if (!isValidHandle(buttonFrame)) {
        安全设置文本(textFrame, "");
        安全显示框体(textFrame, false);
        安全设置文本(shadowFrame, "");
        安全显示框体(shadowFrame, false);
        return;
    }
    let currentTextFrame = textFrame;
    let currentShadowFrame = shadowFrame;
    if (!isValidHandle(currentTextFrame)) {
        currentTextFrame = createTextFrame(`SkillCooldown${hotkey}Text2`, 255, 242, 216, 255);
        if (!isValidHandle(currentTextFrame))
            return;
        if (文本框缓存 != null)
            文本框缓存.主文本[hotkey] = currentTextFrame;
    }
    if (!isValidHandle(currentShadowFrame)) {
        currentShadowFrame = createTextFrame(`SkillCooldown${hotkey}Shadow2`, 16, 16, 16, 255);
        if (!isValidHandle(currentShadowFrame))
            return;
        if (文本框缓存 != null)
            文本框缓存.阴影文本[hotkey] = currentShadowFrame;
    }
    安全设置锚点(currentShadowFrame, buttonFrame, OFFSET_X + SHADOW_OFFSET_X, OFFSET_Y + SHADOW_OFFSET_Y);
    安全设置锚点(currentTextFrame, buttonFrame, OFFSET_X, OFFSET_Y);
    const abilityId = 获取技能Id(whichHero, hotkey);
    if (abilityId === 0) {
        安全设置文本(currentTextFrame, "");
        安全显示框体(currentTextFrame, false);
        安全设置文本(currentShadowFrame, "");
        安全显示框体(currentShadowFrame, false);
        return;
    }
    const cooldown = getCooldown(whichHero, abilityId);
    const text = 构建显示文本(hotkey, abilityId, cooldown);
    安全设置文本(currentShadowFrame, toShadowText(text));
    安全显示框体(currentShadowFrame, text !== "");
    安全设置文本(currentTextFrame, toWhiteText(text));
    安全显示框体(currentTextFrame, text !== "");
}
function hideAll() {
    if (文本框缓存 == null)
        return;
    安全设置文本(文本框缓存.主文本.Q, "");
    安全显示框体(文本框缓存.主文本.Q, false);
    安全设置文本(文本框缓存.主文本.W, "");
    安全显示框体(文本框缓存.主文本.W, false);
    安全设置文本(文本框缓存.主文本.E, "");
    安全显示框体(文本框缓存.主文本.E, false);
    安全设置文本(文本框缓存.主文本.R, "");
    安全显示框体(文本框缓存.主文本.R, false);
    安全设置文本(文本框缓存.主文本.D, "");
    安全显示框体(文本框缓存.主文本.D, false);
    安全设置文本(文本框缓存.阴影文本.Q, "");
    安全显示框体(文本框缓存.阴影文本.Q, false);
    安全设置文本(文本框缓存.阴影文本.W, "");
    安全显示框体(文本框缓存.阴影文本.W, false);
    安全设置文本(文本框缓存.阴影文本.E, "");
    安全显示框体(文本框缓存.阴影文本.E, false);
    安全设置文本(文本框缓存.阴影文本.R, "");
    安全显示框体(文本框缓存.阴影文本.R, false);
    安全设置文本(文本框缓存.阴影文本.D, "");
    安全显示框体(文本框缓存.阴影文本.D, false);
}
function onTick() {
    const currentFrames = 确保文本框缓存();
    if (currentFrames == null)
        return;
    if (功能开关模块.本地玩家是否开启冷却显示() !== true) {
        hideAll();
        return;
    }
    const hero = getLocalHero();
    if (!isValidHandle(hero)) {
        hideAll();
        return;
    }
    刷新单个技能(hero, "Q", currentFrames.主文本.Q, currentFrames.阴影文本.Q);
    刷新单个技能(hero, "W", currentFrames.主文本.W, currentFrames.阴影文本.W);
    刷新单个技能(hero, "E", currentFrames.主文本.E, currentFrames.阴影文本.E);
    刷新单个技能(hero, "R", currentFrames.主文本.R, currentFrames.阴影文本.R);
    刷新单个技能(hero, "D", currentFrames.主文本.D, currentFrames.阴影文本.D);
}
export function 获取QWERD冷却调试快照() {
    const hero = getLocalHero();
    if (!isValidHandle(hero))
        return `NO_HERO`;
    const qId = 获取技能Id(hero, "Q");
    const wId = 获取技能Id(hero, "W");
    const eId = 获取技能Id(hero, "E");
    const rId = 获取技能Id(hero, "R");
    const dId = 获取技能Id(hero, "D");
    const qCd = getCooldown(hero, qId);
    const wCd = getCooldown(hero, wId);
    const eCd = getCooldown(hero, eId);
    const rCd = getCooldown(hero, rId);
    const dCd = getCooldown(hero, dId);
    return [
        `hero=${hero}`,
        `Q=${fourCCText(qId)}/${构建显示文本("Q", qId, qCd)}`,
        `W=${fourCCText(wId)}/${构建显示文本("W", wId, wCd)}`,
        `E=${fourCCText(eId)}/${构建显示文本("E", eId, eCd)}`,
        `R=${fourCCText(rId)}/${构建显示文本("R", rId, rCd)}`,
        `D=${fourCCText(dId)}/${构建显示文本("D", dId, dCd)}`,
    ].join(" ");
}
export function 初始化QWERD冷却显示() {
    if (initialized)
        return;
    initialized = true;
    addPeriodicCallback(REFRESH_MS, onTick);
}
