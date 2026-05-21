/** @noSelfInFile */
// 统一处理物品技能事件。
const jass = require("jass.common");
const 玩家单位事件中心 = require("系统.00．核心系统.01．事件中心.01．玩家单位事件");
const 技能事件中心 = require("系统.00．核心系统.01．事件中心.08．技能事件中心");
export const 物品技能事件玩家范围 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
const CreateTrigger = jass.CreateTrigger;
const TriggerAddAction = jass.TriggerAddAction;
const GetTriggerUnit = jass.GetTriggerUnit;
const GetManipulatedItem = jass.GetManipulatedItem;
const GetSpellTargetX = jass.GetSpellTargetX;
const GetSpellTargetY = jass.GetSpellTargetY;
const GetSpellTargetUnit = jass.GetSpellTargetUnit;
const GetSpellTargetDestructable = jass.GetSpellTargetDestructable;
const GetHandleId = jass.GetHandleId;
const Location = jass.Location;
const RemoveLocation = jass.RemoveLocation;
const EVENT_PLAYER_UNIT_USE_ITEM = jass.EVENT_PLAYER_UNIT_USE_ITEM;
const 监听列表 = [];
const 施法者技能上下文表 = {};
let 已初始化 = false;
let 使用物品触发器 = null;
let 最近一次物品技能上下文 = null;
let 最近一次物品技能目标点 = null;
function 已注册监听(回调) {
    for (let i = 0; i < 监听列表.length; i++) {
        if (监听列表[i] === 回调)
            return true;
    }
    return false;
}
function 清理最近目标点() {
    if (最近一次物品技能目标点 == null || 最近一次物品技能目标点 === 0)
        return;
    RemoveLocation(最近一次物品技能目标点);
    最近一次物品技能目标点 = null;
}
function 设置最近物品技能上下文(上下文) {
    清理最近目标点();
    最近一次物品技能上下文 = 上下文;
}
function 清理最近物品技能上下文() {
    清理最近目标点();
    最近一次物品技能上下文 = null;
}
function 获取施法者缓存键(施法单位) {
    if (施法单位 == null || 施法单位 === 0)
        return 0;
    return GetHandleId(施法单位);
}
function 缓存技能生效上下文(施法单位, 技能ID) {
    const 施法者ID = 获取施法者缓存键(施法单位);
    if (施法者ID === 0)
        return;
    施法者技能上下文表[施法者ID] = {
        技能ID,
        目标X: GetSpellTargetX(),
        目标Y: GetSpellTargetY(),
        目标单位: GetSpellTargetUnit(),
        目标可破坏物: GetSpellTargetDestructable(),
    };
}
function 分发物品技能事件监听(上下文) {
    设置最近物品技能上下文(上下文);
    for (let i = 0; i < 监听列表.length; i++) {
        const 回调 = 监听列表[i];
        if (回调 != null)
            回调(上下文);
    }
    清理最近物品技能上下文();
}
function 处理物品技能生效(施法单位, 技能ID) {
    if (施法单位 == null || 施法单位 === 0)
        return;
    if (技能ID == null || 技能ID === 0)
        return;
    缓存技能生效上下文(施法单位, 技能ID);
}
function 处理使用物品事件() {
    const 施法单位 = GetTriggerUnit();
    if (施法单位 == null || 施法单位 === 0)
        return;
    const 物品 = GetManipulatedItem();
    if (物品 == null || 物品 === 0)
        return;
    const 施法者ID = 获取施法者缓存键(施法单位);
    if (施法者ID === 0)
        return;
    const 已缓存上下文 = 施法者技能上下文表[施法者ID];
    delete 施法者技能上下文表[施法者ID];
    if (已缓存上下文 == null)
        return;
    if (已缓存上下文.技能ID == null || 已缓存上下文.技能ID === 0)
        return;
    分发物品技能事件监听({
        施法单位,
        物品,
        技能ID: 已缓存上下文.技能ID,
        目标X: 已缓存上下文.目标X,
        目标Y: 已缓存上下文.目标Y,
        目标单位: 已缓存上下文.目标单位,
        目标可破坏物: 已缓存上下文.目标可破坏物,
    });
}
export function 初始化物品技能事件中心() {
    if (已初始化)
        return;
    已初始化 = true;
    技能事件中心.registerSpellEffectListener(处理物品技能生效);
    使用物品触发器 = CreateTrigger();
    玩家单位事件中心.registerPlayerUnitEventForPlayerIds(使用物品触发器, 物品技能事件玩家范围, EVENT_PLAYER_UNIT_USE_ITEM);
    TriggerAddAction(使用物品触发器, 处理使用物品事件);
}
export function 注册物品技能事件监听(回调) {
    if (回调 == null)
        return;
    初始化物品技能事件中心();
    if (!已注册监听(回调))
        监听列表.push(回调);
}
export function 取消注册物品技能事件监听(回调) {
    const 索引 = 监听列表.indexOf(回调);
    if (索引 >= 0)
        监听列表.splice(索引, 1);
}
export function 获取最近一次物品技能ID() {
    return 最近一次物品技能上下文 == null ? 0 : 最近一次物品技能上下文.技能ID;
}
export function 获取最近一次物品技能目标X() {
    return 最近一次物品技能上下文 == null ? 0 : 最近一次物品技能上下文.目标X;
}
export function 获取最近一次物品技能目标Y() {
    return 最近一次物品技能上下文 == null ? 0 : 最近一次物品技能上下文.目标Y;
}
export function 获取最近一次物品技能目标单位() {
    return 最近一次物品技能上下文 == null ? null : 最近一次物品技能上下文.目标单位;
}
export function 获取最近一次物品技能目标点() {
    if (最近一次物品技能上下文 == null)
        return null;
    清理最近目标点();
    最近一次物品技能目标点 = Location(最近一次物品技能上下文.目标X, 最近一次物品技能上下文.目标Y);
    return 最近一次物品技能目标点;
}
