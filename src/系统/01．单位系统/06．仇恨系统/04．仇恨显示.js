/** @noSelfInFile */
/**
 * 04．仇恨显示
 *
 * 给有仇恨表的敌人显示头顶跟随文字：
 * - 目标：XX
 * - 仇恨值：XXX
 */
const jass = require("jass.common");
const { CreateFloatTextOnUnit, DestroyFloatText, } = require("lib.扩展函数.封装函数.03．漂浮文字.index");
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心");
const 功能开关 = require("系统.00．核心系统.02．功能开关.01．QWERD显示开关");
const GetHandleId = jass.GetHandleId;
const GetUnitName = jass.GetUnitName;
const SetTextTagText = jass.SetTextTagText;
const SetTextTagPosUnit = jass.SetTextTagPosUnit;
const SetTextTagVisibility = jass.SetTextTagVisibility;
const IsUnitType = jass.IsUnitType;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD;
const R2I = jass.R2I;
const 仇恨显示表 = {};
const 文字高度 = 50;
const 文字尺寸高度 = 9 * 0.0023;
const 跟随刷新毫秒 = 40;
let 跟随回调ID = 0;
let 已注册死亡清理 = false;
function 取单位ID(u) {
    if (u == null || u === 0)
        return 0;
    return GetHandleId(u) || 0;
}
function 获取有序仇恨显示敌人ID列表() {
    const result = [];
    for (const key in 仇恨显示表) {
        const id = parseInt(key, 10);
        if (!isNaN(id)) {
            result.push(id);
        }
    }
    result.sort();
    return result;
}
function 格式化仇恨值(仇恨值) {
    const 十倍整数 = R2I(仇恨值 * 10 + 0.5);
    const 整数部分 = R2I(十倍整数 / 10);
    const 小数部分 = 十倍整数 - 整数部分 * 10;
    return `${整数部分}.${小数部分}`;
}
function 构建仇恨文本(目标单位, 仇恨值) {
    return `目标：${GetUnitName(目标单位)}|n仇恨值：${格式化仇恨值(仇恨值)}`;
}
function 本地玩家是否显示仇恨文字() {
    return 功能开关.本地玩家是否开启仇恨文字();
}
function 应用本机仇恨文字可见性(textTag) {
    if (textTag == null || textTag === 0)
        return;
    // 只改本机表现层可见性；TextTag 的创建、更新、移动、销毁仍保持全端对称。
    SetTextTagVisibility(textTag, 本地玩家是否显示仇恨文字());
}
function 获取或创建仇恨文字(敌人ID, 敌人) {
    const 现有 = 仇恨显示表[敌人ID];
    if (现有 != null && 现有.textTag != null) {
        现有.跟随单位 = 敌人;
        return 现有.textTag;
    }
    const 新文字 = CreateFloatTextOnUnit(敌人, "", {
        size: 9,
        red: 255,
        green: 150,
        blue: 60,
        alpha: 0,
        duration: 0,
        permanent: true,
        speedX: 0,
        speedY: 0,
        height: 文字高度,
    });
    if (新文字 == null)
        return null;
    应用本机仇恨文字可见性(新文字);
    仇恨显示表[敌人ID] = { textTag: 新文字, 跟随单位: 敌人 };
    return 新文字;
}
function on仇恨显示单位死亡(dyingUnit, _killingUnit) {
    const 敌人ID = 取单位ID(dyingUnit);
    if (敌人ID === 0)
        return;
    清除仇恨显示ById(敌人ID);
}
function on仇恨显示Tick() {
    const 敌人ID列表 = 获取有序仇恨显示敌人ID列表();
    let 仍有显示 = false;
    for (let i = 0; i < 敌人ID列表.length; i++) {
        const 敌人ID = 敌人ID列表[i];
        const 数据 = 仇恨显示表[敌人ID];
        if (数据 == null || 数据.textTag == null || 数据.跟随单位 == null || 数据.跟随单位 === 0) {
            清除仇恨显示ById(敌人ID);
            continue;
        }
        if (IsUnitType(数据.跟随单位, UNIT_TYPE_DEAD)) {
            清除仇恨显示ById(敌人ID);
            continue;
        }
        SetTextTagPosUnit(数据.textTag, 数据.跟随单位, 文字高度);
        应用本机仇恨文字可见性(数据.textTag);
        仍有显示 = true;
    }
    if (!仍有显示 && 跟随回调ID !== 0) {
        const { removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器");
        removePeriodicCallback(跟随回调ID);
        跟随回调ID = 0;
    }
}
function 确保仇恨显示Tick已启动() {
    if (!已注册死亡清理) {
        已注册死亡清理 = true;
        registerDeathListener(on仇恨显示单位死亡);
    }
    if (跟随回调ID !== 0)
        return;
    const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器");
    跟随回调ID = addPeriodicCallback(跟随刷新毫秒, on仇恨显示Tick);
}
export function 更新仇恨显示(敌人, 目标单位, 仇恨值) {
    const 敌人ID = 取单位ID(敌人);
    if (敌人ID === 0)
        return;
    if (敌人 == null || 敌人 === 0 || 目标单位 == null || 目标单位 === 0)
        return;
    if (IsUnitType(敌人, UNIT_TYPE_DEAD) || IsUnitType(目标单位, UNIT_TYPE_DEAD)) {
        清除仇恨显示ById(敌人ID);
        return;
    }
    const 文字 = 获取或创建仇恨文字(敌人ID, 敌人);
    if (文字 == null)
        return;
    SetTextTagText(文字, 构建仇恨文本(目标单位, 仇恨值), 文字尺寸高度);
    SetTextTagPosUnit(文字, 敌人, 文字高度);
    应用本机仇恨文字可见性(文字);
    确保仇恨显示Tick已启动();
}
export function 清除仇恨显示ById(敌人ID) {
    if (敌人ID === 0)
        return;
    const 数据 = 仇恨显示表[敌人ID];
    if (数据 == null)
        return;
    if (数据.textTag != null) {
        DestroyFloatText(数据.textTag);
    }
    delete 仇恨显示表[敌人ID];
}
export function 清除所有仇恨显示() {
    const 敌人ID列表 = 获取有序仇恨显示敌人ID列表();
    for (let i = 0; i < 敌人ID列表.length; i++) {
        清除仇恨显示ById(敌人ID列表[i]);
    }
    if (跟随回调ID !== 0) {
        const { removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器");
        removePeriodicCallback(跟随回调ID);
        跟随回调ID = 0;
    }
}
