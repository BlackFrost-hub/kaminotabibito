/** @noSelfInFile */
const jass = require("jass.common");
const japi = require("jass.japi");
const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器");
const selectionCenterSystem = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心");
const 获取玩家唯一选中单位 = selectionCenterSystem.getSoleSelectedUnitForPlayer;
const 功能开关模块 = require("系统.00．核心系统.02．功能开关.01．QWERD显示开关");
const heroBridge = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接");
const { calcTotalManaCost, getAbilityManaCost } = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还");
const commandBarAbility = require("系统.03．技能系统.01．技能冷却.04．命令卡技能槽位");
const DzGetGameUI = japi.DzGetGameUI;
const DzCreateFrameByTagName = japi.DzCreateFrameByTagName;
const DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton;
const DzFrameSetPoint = japi.DzFrameSetPoint;
const DzFrameSetSize = japi.DzFrameSetSize;
const DzFrameSetFont = japi.DzFrameSetFont;
const DzFrameSetText = japi.DzFrameSetText;
const DzFrameSetTextColor = japi.DzFrameSetTextColor;
const DzFrameSetTexture = japi.DzFrameSetTexture;
const DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment;
const DzFrameShow = japi.DzFrameShow;
const REFRESH_MS = 300;
const FONT_FILE = "UI\\uizt.ttf";
const FONT_SIZE = 0.01275;
const TEXT_W = 0.025;
const TEXT_H = 0.010;
const ICON_W = 0.0090;
const ICON_H = 0.0090;
const ICON_TEXTURE = "UI\\Widgets\\ToolTips\\Human\\ToolTipManaIcon.blp";
const ICON_OFFSET_X = 0.0010;
const ICON_OFFSET_Y = -0.0012;
const TEXT_OFFSET_X = 0.0090;
const TEXT_OFFSET_Y = -0.0013;
const SHADOW_OFFSET_X = 0.0006;
const SHADOW_OFFSET_Y = -0.0006;
const 固定槽位表 = {
    Q: { x: 0, y: 2 },
    W: { x: 1, y: 2 },
    E: { x: 2, y: 2 },
    R: { x: 3, y: 2 },
};
let initialized = false;
let 显示缓存 = null;
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
function 安全设置贴图(frame, texture) {
    if (!isValidHandle(frame))
        return;
    DzFrameSetTexture(frame, texture, 0);
}
function 安全设置锚点(frame, relativeFrame, x, y) {
    if (!isValidHandle(frame) || !isValidHandle(relativeFrame))
        return;
    DzFrameSetPoint(frame, 0, relativeFrame, 0, x, y);
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
function createBackdrop(name) {
    const gameUI = DzGetGameUI();
    if (!isValidHandle(gameUI))
        return 0;
    const frame = DzCreateFrameByTagName("BACKDROP", name, gameUI, "template", 0);
    if (!isValidHandle(frame))
        return 0;
    DzFrameSetSize(frame, ICON_W, ICON_H);
    DzFrameSetTexture(frame, ICON_TEXTURE, 0);
    DzFrameShow(frame, false);
    return frame;
}
function createText(name, r, g, b, a) {
    const gameUI = DzGetGameUI();
    if (!isValidHandle(gameUI))
        return 0;
    const frame = DzCreateFrameByTagName("TEXT", name, gameUI, "template", 0);
    if (!isValidHandle(frame))
        return 0;
    DzFrameSetSize(frame, TEXT_W, TEXT_H);
    DzFrameSetText(frame, "");
    DzFrameSetFont(frame, FONT_FILE, FONT_SIZE, 0);
    DzFrameSetTextAlignment(frame, 0);
    DzFrameSetTextColor(frame, r, g, b, a);
    DzFrameShow(frame, false);
    return frame;
}
function 确保显示缓存() {
    if (显示缓存 != null)
        return 显示缓存;
    显示缓存 = {
        Q: { icon: 0, text: 0, shadow: 0 },
        W: { icon: 0, text: 0, shadow: 0 },
        E: { icon: 0, text: 0, shadow: 0 },
        R: { icon: 0, text: 0, shadow: 0 },
        D: { icon: 0, text: 0, shadow: 0 },
    };
    return 显示缓存;
}
function formatManaCost(value) {
    if (!(value > 0.05))
        return "";
    const tenth = jass.R2I(value * 10 + 0.5);
    const sec = jass.R2I(tenth / 10);
    const decimal = tenth - sec * 10;
    if (decimal === 0)
        return jass.I2S(sec);
    return jass.I2S(sec) + "." + jass.I2S(decimal);
}
function calcDisplayManaCost(unit, abilityId, level) {
    const totalCost = calcTotalManaCost(unit, abilityId, level);
    if (totalCost > 0)
        return totalCost;
    const fixedCost = getAbilityManaCost(unit, abilityId, level);
    if (fixedCost > 0)
        return fixedCost;
    return -1;
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
function 隐藏单元(ui) {
    安全显示框体(ui.icon, false);
    安全设置文本(ui.text, "");
    安全显示框体(ui.text, false);
    安全设置文本(ui.shadow, "");
    安全显示框体(ui.shadow, false);
}
function toManaText(text) {
    if (text === "")
        return "";
    return `|cffffd24a${text}|r`;
}
function toShadowText(text) {
    if (text === "")
        return "";
    return `|cff101010${text}|r`;
}
function 确保按钮显示单元(hotkey, ui) {
    if (!isValidHandle(ui.icon))
        ui.icon = createBackdrop(`SkillMana${hotkey}Icon`);
    if (!isValidHandle(ui.text))
        ui.text = createText(`SkillMana${hotkey}Text`, 255, 210, 74, 255);
    if (!isValidHandle(ui.shadow))
        ui.shadow = createText(`SkillMana${hotkey}Shadow`, 16, 16, 16, 255);
    return isValidHandle(ui.icon) && isValidHandle(ui.text) && isValidHandle(ui.shadow);
}
function 刷新单个技能(whichHero, hotkey, ui) {
    const buttonFrame = 获取按钮框(whichHero, hotkey);
    if (!isValidHandle(buttonFrame)) {
        隐藏单元(ui);
        return;
    }
    if (!确保按钮显示单元(hotkey, ui))
        return;
    const abilityId = 获取技能Id(whichHero, hotkey);
    if (abilityId === 0) {
        隐藏单元(ui);
        return;
    }
    const level = jass.GetUnitAbilityLevel(whichHero, abilityId);
    if (level <= 0) {
        隐藏单元(ui);
        return;
    }
    const manaCost = calcDisplayManaCost(whichHero, abilityId, level);
    if (!(manaCost > 0)) {
        隐藏单元(ui);
        return;
    }
    const text = formatManaCost(manaCost);
    if (text === "") {
        隐藏单元(ui);
        return;
    }
    安全设置锚点(ui.icon, buttonFrame, ICON_OFFSET_X, ICON_OFFSET_Y);
    安全设置锚点(ui.shadow, buttonFrame, TEXT_OFFSET_X + SHADOW_OFFSET_X, TEXT_OFFSET_Y + SHADOW_OFFSET_Y);
    安全设置锚点(ui.text, buttonFrame, TEXT_OFFSET_X, TEXT_OFFSET_Y);
    安全设置贴图(ui.icon, ICON_TEXTURE);
    安全显示框体(ui.icon, true);
    安全设置文本(ui.shadow, toShadowText(text));
    安全显示框体(ui.shadow, true);
    安全设置文本(ui.text, toManaText(text));
    安全显示框体(ui.text, true);
}
function hideAll() {
    if (显示缓存 == null)
        return;
    隐藏单元(显示缓存.Q);
    隐藏单元(显示缓存.W);
    隐藏单元(显示缓存.E);
    隐藏单元(显示缓存.R);
    隐藏单元(显示缓存.D);
}
function onTick() {
    const currentUi = 确保显示缓存();
    if (currentUi == null)
        return;
    if (功能开关模块.本地玩家是否开启魔法消耗显示() !== true) {
        hideAll();
        return;
    }
    const hero = getLocalHero();
    if (!isValidHandle(hero)) {
        hideAll();
        return;
    }
    刷新单个技能(hero, "Q", currentUi.Q);
    刷新单个技能(hero, "W", currentUi.W);
    刷新单个技能(hero, "E", currentUi.E);
    刷新单个技能(hero, "R", currentUi.R);
    刷新单个技能(hero, "D", currentUi.D);
}
export function 初始化QWERD魔法消耗显示() {
    if (initialized)
        return;
    initialized = true;
    addPeriodicCallback(REFRESH_MS, onTick);
}
