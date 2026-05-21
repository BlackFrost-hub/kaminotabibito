/** @noSelfInFile */
const jass = require("jass.common");
const CreateTimer = jass.CreateTimer;
const DestroyTimer = jass.DestroyTimer;
const TimerStart = jass.TimerStart;
const GetExpiredTimer = jass.GetExpiredTimer;
const GetHandleId = jass.GetHandleId;
const GetRandomInt = jass.GetRandomInt;
const GetUnitName = jass.GetUnitName;
const GetOwningPlayer = jass.GetOwningPlayer;
const GetPlayerName = jass.GetPlayerName;
const { 注册宝箱准备开启回调 } = require("系统.06．经济系统.00．宝箱系统.04．准备开启回调");
const { 注册宝箱开启完成回调 } = require("系统.06．经济系统.00．宝箱系统.06．开启完成回调");
const { 广播宝箱主人提示, 广播单位类型提示 } = require("系统.06．经济系统.00．宝箱系统.07．主人广播");
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index");
const 准备开启持续毫秒 = 4800;
const 开启完成持续毫秒 = 4800;
const 宝箱台词配置 = new Map([
    ["LTbs", {
            准备开启: [
                "小老鼠，{开启者}，也太目中无人了吧？",
                "嘿，贪婪的家伙{开启者}，休想从我这儿轻松得手！",
            ],
            开启完成: [
                "{玩家名}，还真被你得手了，可恶！（莫斯特永久提高3%基础攻击力）",
                "我的珍藏！{玩家名}，你成功惹怒了我！（莫斯特永久提高3%基础攻击力）",
            ],
            冷却秒数: 5,
        }],
]);
const 冷却表 = new Map();
const 计时器键表 = new Map();
function 构造冷却键(阶段名, 开启者, 主人单位, 宝箱配置) {
    const openerId = 开启者 ? GetHandleId(开启者) : 0;
    const ownerId = 主人单位 ? GetHandleId(主人单位) : 0;
    const chestType = 宝箱配置?.destructableType ?? "";
    return `${阶段名}:${chestType}:${openerId}:${ownerId}`;
}
function 取随机台词(列表) {
    if (列表.length === 0)
        return undefined;
    if (列表.length === 1)
        return 列表[0];
    const index = GetRandomInt(1, 列表.length) - 1;
    return 列表[index];
}
function 替换台词变量(模板, 开启者) {
    let 文本 = 模板;
    const 开启者名字 = 开启者 ? GetUnitName(开启者) : "有人";
    const 玩家名字 = 开启者 ? GetPlayerName(GetOwningPlayer(开启者)) : "有人";
    文本 = 文本.replace("{开启者}", `（${开启者名字}）`);
    文本 = 文本.replace("{玩家名}", 玩家名字);
    return 文本;
}
function 冷却结束回调() {
    const timer = GetExpiredTimer();
    const timerId = GetHandleId(timer);
    const key = 计时器键表.get(timerId);
    if (key != null) {
        冷却表.delete(key);
        计时器键表.delete(timerId);
    }
    DestroyTimer(timer);
}
function 尝试广播主人台词(阶段名, 开启者, 宝箱配置, 主人单位) {
    const chestType = 宝箱配置?.destructableType;
    if (!chestType)
        return;
    const 配置 = 宝箱台词配置.get(chestType);
    if (!配置)
        return;
    const key = 构造冷却键(阶段名, 开启者, 主人单位, 宝箱配置);
    if (冷却表.has(key))
        return;
    const 候选 = 阶段名 === "prepare" ? 配置.准备开启 : 配置.开启完成;
    const 模板 = 取随机台词(候选);
    if (!模板)
        return;
    const 文本 = 替换台词变量(模板, 开启者);
    if (阶段名 === "complete") {
        if (主人单位) {
            广播宝箱主人提示(主人单位, 文本, 开启完成持续毫秒);
        }
        else if (宝箱配置?.主人配置?.单位类型) {
            广播单位类型提示(stringToFourCC(宝箱配置.主人配置.单位类型), 文本, 开启完成持续毫秒);
        }
        else {
            return;
        }
    }
    else if (主人单位) {
        广播宝箱主人提示(主人单位, 文本, 准备开启持续毫秒);
    }
    else if (宝箱配置?.主人配置?.单位类型) {
        广播单位类型提示(stringToFourCC(宝箱配置.主人配置.单位类型), 文本, 准备开启持续毫秒);
    }
    else {
        return;
    }
    冷却表.set(key, true);
    const timer = CreateTimer();
    const timerId = GetHandleId(timer);
    计时器键表.set(timerId, key);
    TimerStart(timer, 配置.冷却秒数, false, 冷却结束回调);
}
function onChestPrepare(unit, _target, _progressBar, _openTime, chestConfig, ownerUnit) {
    尝试广播主人台词("prepare", unit, chestConfig, ownerUnit);
}
function onChestComplete(unit, _target, _progressBar, _openTime, chestConfig, ownerUnit) {
    尝试广播主人台词("complete", unit, chestConfig, ownerUnit);
}
注册宝箱准备开启回调(onChestPrepare);
注册宝箱开启完成回调(onChestComplete);
export {};
