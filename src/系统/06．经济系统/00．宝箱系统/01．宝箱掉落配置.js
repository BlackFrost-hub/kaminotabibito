/** @noSelfInFile */
/**
 * 宝箱掉落配置 - 掉落执行器
 */
const jass = require("jass.common");
const { getChestConfigByString } = require("系统.06．经济系统.00．宝箱系统.00．常量定义");
const { items } = require("系统.02．物品系统.01．装备数据");
const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查");
const { 按物品池名随机装备ID } = require("系统.02．物品系统.14．按等级随机装备");
const { 广播提示玩家槽数 } = require("系统.09．表现系统.06．广播提示消息.00．常量定义");
const { 发送头像提示给玩家 } = require("系统.09．表现系统.06．广播提示消息.index");
const { SFB_setBuff } = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统");
const { 装备等级显示文本, 装备名字颜色文本 } = require("系统.00．核心系统.01．颜色常量");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { setLastCreatedItem } = require("系统.02．物品系统.09．装备排泄");
const GetRandomInt = jass.GetRandomInt;
const GetRandomReal = jass.GetRandomReal;
const CreateItem = jass.CreateItem;
const GetWidgetLife = jass.GetWidgetLife;
const SetWidgetLife = jass.SetWidgetLife;
const GetOwningPlayer = jass.GetOwningPlayer;
const GetPlayerName = jass.GetPlayerName;
const Player = jass.Player;
const 喇叭路径 = "UI\\xiaoxi\\UInotice.tga";
const 装备系统消息持续毫秒 = 6500;
function stringToFourCC(s) {
    if (s == null || s.length < 4)
        return 0;
    const a = s.length > 0 ? s.charCodeAt(0) : 0;
    const b = s.length > 1 ? s.charCodeAt(1) : 0;
    const c = s.length > 2 ? s.charCodeAt(2) : 0;
    const d = s.length > 3 ? s.charCodeAt(3) : 0;
    return a * 16777216 + b * 65536 + c * 256 + d;
}
const itemAliasMap = new Map();
const DROP_OFFSETS = [
    { dx: 0, dy: 0 },
    { dx: 18, dy: 0 },
    { dx: -18, dy: 0 },
    { dx: 0, dy: 18 },
    { dx: 0, dy: -18 },
    { dx: 12, dy: 12 },
    { dx: -12, dy: 12 },
    { dx: 12, dy: -12 },
    { dx: -12, dy: -12 },
];
function 标准化物品别名(name) {
    let result = "";
    for (let i = 0; i < name.length; i++) {
        const ch = name.charAt(i);
        if (ch === "|") {
            const next = name.charAt(i + 1);
            if (next === "r" || next === "R") {
                i = i + 1;
                continue;
            }
            if (next === "c" || next === "C") {
                i = i + 9;
                continue;
            }
        }
        result += ch;
    }
    return result.trim();
}
function 注册物品别名(alias, itemId) {
    const normalized = 标准化物品别名(alias);
    if (!normalized)
        return;
    if (!itemAliasMap.has(normalized)) {
        itemAliasMap.set(normalized, itemId);
    }
}
for (const [itemId, data] of Object.entries(items)) {
    itemAliasMap.set(itemId, itemId);
    if (data?.name) {
        注册物品别名(data.name, itemId);
    }
}
function 按名字查找物品ID(name) {
    const normalized = 标准化物品别名(name);
    for (const [itemId, data] of Object.entries(items)) {
        if (标准化物品别名(data?.name ?? "") === normalized) {
            return itemId;
        }
    }
    return undefined;
}
function 解析掉落物品ID(token) {
    const trimmed = token.trim();
    if (!trimmed)
        return trimmed;
    if (trimmed.length === 4 && items[trimmed] != null) {
        return trimmed;
    }
    return resolveItemIdByName(trimmed) ?? itemAliasMap.get(标准化物品别名(trimmed)) ?? 按名字查找物品ID(trimmed) ?? trimmed;
}
function randomReal01() {
    return GetRandomReal(0.0, 1.0) || 0.0;
}
function randomInt(min, max) {
    return GetRandomInt(min, max) || min;
}
function 解析物品池(poolStr) {
    const entries = [];
    const parts = poolStr.split(";");
    for (const part of parts) {
        const trimmed = part.trim();
        if (!trimmed)
            continue;
        if (trimmed.includes(":")) {
            const splitParts = trimmed.split(":");
            const id = 解析掉落物品ID(splitParts[0] ?? "");
            const parsedWeight = parseFloat(splitParts[1] ?? "");
            const weight = parsedWeight > 0 ? parsedWeight : 1;
            debugLogForce("宝箱掉落配置", "解析池条目", "raw=", trimmed, "id=", id, "weight=", weight);
            entries.push({ id, weight });
        }
        else {
            const id = 解析掉落物品ID(trimmed);
            debugLogForce("宝箱掉落配置", "解析池条目", "raw=", trimmed, "id=", id, "weight=", 1);
            entries.push({ id, weight: 1 });
        }
    }
    return entries;
}
function 按权重抽取可重复(pool, picks) {
    const result = [];
    let totalWeight = 0;
    for (const entry of pool) {
        totalWeight = totalWeight + entry.weight;
    }
    if (totalWeight <= 0)
        return result;
    for (let i = 0; i < picks; i++) {
        let r = randomReal01() * totalWeight;
        for (const entry of pool) {
            r = r - entry.weight;
            if (r <= 0) {
                result.push(entry.id);
                break;
            }
        }
    }
    return result;
}
function 按均匀抽取不重复(pool, picks) {
    const shuffled = [...pool];
    for (let i = shuffled.length - 1; i >= 1; i--) {
        const j = randomInt(1, i + 1) - 1;
        const t = shuffled[i];
        shuffled[i] = shuffled[j];
        shuffled[j] = t;
    }
    const count = picks < shuffled.length ? picks : shuffled.length;
    return shuffled.slice(0, count).map(entry => entry.id);
}
function 按分数筛选物品(min, max) {
    const result = [];
    const entries = Object.entries(items).sort(([a], [b]) => (a < b ? -1 : a > b ? 1 : 0));
    for (const [itemId, data] of entries) {
        const score = data?.score;
        if (score == null)
            continue;
        if (score < min || score > max)
            continue;
        result.push(itemId);
    }
    return result;
}
function 解析必掉物品(alwaysStr) {
    if (!alwaysStr)
        return [];
    const result = alwaysStr
        .split(";")
        .map(s => 解析掉落物品ID(s))
        .filter(itemId => items[itemId] != null);
    debugLogForce("宝箱掉落配置", "解析必掉", "raw=", alwaysStr, "result=", result.join(","));
    return result;
}
function 按掉落模式执行(dropMode, picks) {
    const result = [];
    if ("always" in dropMode && dropMode.always) {
        result.push(...解析必掉物品(dropMode.always));
    }
    switch (dropMode.type) {
        case "pool": {
            const pool = 解析物品池(dropMode.items);
            if (pool.length > 0 && picks > 0) {
                const hasWeight = pool.some(entry => entry.weight !== 1);
                const drawn = hasWeight ? 按权重抽取可重复(pool, picks) : 按均匀抽取不重复(pool, picks);
                result.push(...drawn);
            }
            break;
        }
        case "mixed": {
            let pool = 解析物品池(dropMode.items);
            if (pool.length > 0) {
                pool = pool.filter(entry => {
                    const score = items[entry.id]?.score;
                    return score != null && score >= dropMode.range.min && score <= dropMode.range.max;
                });
            }
            if (pool.length > 0 && picks > 0) {
                result.push(...按权重抽取可重复(pool, picks));
            }
            break;
        }
        case "score": {
            const itemIds = 按分数筛选物品(dropMode.range.min, dropMode.range.max);
            if (itemIds.length > 0 && picks > 0) {
                const pool = itemIds.map(id => ({ id, weight: 1 }));
                result.push(...按均匀抽取不重复(pool, picks));
            }
            break;
        }
    }
    return result;
}
function 按权重抽取等级池(候选等级池) {
    let 总权重 = 0;
    for (const 候选 of 候选等级池) {
        总权重 = 总权重 + 候选.权重;
    }
    if (总权重 <= 0)
        return undefined;
    let r = randomReal01() * 总权重;
    for (const 候选 of 候选等级池) {
        r = r - 候选.权重;
        if (r <= 0) {
            return 候选;
        }
    }
    return 候选等级池[候选等级池.length - 1];
}
function 广播宝箱装备消息(动作, 上下文) {
    debugLogForce("宝箱掉落配置", "广播检查", "ownerUnit=", 上下文.宝箱主人 != null, "itemId=", 上下文.最近装备物品ID ?? "", "levelText=", 上下文.最近装备等级文本 ?? "", "chestType=", 上下文.宝箱配置?.destructableType ?? "");
    if (!上下文.开启者 || !上下文.最近装备物品ID || !上下文.最近装备等级文本) {
        debugLogForce("宝箱掉落配置", "跳过装备系统消息", "reason=", "missing_context");
        return;
    }
    const 装备名 = items[上下文.最近装备物品ID]?.name ?? 上下文.最近装备物品ID;
    const 玩家名 = GetPlayerName(GetOwningPlayer(上下文.开启者));
    const 等级Key = String(上下文.最近装备等级文本 || "").trim();
    const 等级文本 = 装备等级显示文本(undefined, 等级Key, 等级Key);
    const 装备文本 = 装备名字颜色文本(undefined, 装备名, 等级Key);
    const 文本 = `${玩家名}${动作.文本前缀}${等级文本}装备『${装备文本}』`;
    debugLogForce("宝箱掉落配置", "发送装备系统消息", "text=", 文本, "icon=", 喇叭路径);
    for (let 玩家ID = 0; 玩家ID < 广播提示玩家槽数; 玩家ID++) {
        发送头像提示给玩家(Player(玩家ID), 喇叭路径, 文本, 装备系统消息持续毫秒);
    }
}
function 执行高级掉落动作(动作, 结果, 上下文) {
    switch (动作.type) {
        case "创建物品": {
            const itemId = 解析掉落物品ID(动作.物品);
            if (items[itemId] != null) {
                结果.push(itemId);
            }
            return;
        }
        case "创建物品二选一": {
            const roll = randomInt(1, 2);
            const itemId = 解析掉落物品ID(roll === 1 ? 动作.物品1 : 动作.物品2);
            if (items[itemId] != null) {
                结果.push(itemId);
            }
            return;
        }
        case "按装备等级随机创建": {
            const 候选等级池 = 按权重抽取等级池(动作.候选等级池);
            if (!候选等级池)
                return;
            const itemId = 按物品池名随机装备ID(候选等级池.池名);
            debugLogForce("宝箱掉落配置", "按等级池随机装备", "pool=", 候选等级池.池名, "itemId=", itemId);
            if (!itemId || items[itemId] == null)
                return;
            结果.push(itemId);
            上下文.最近装备物品ID = itemId;
            上下文.最近装备等级文本 = 候选等级池.广播等级文本;
            return;
        }
        case "对开启者施加效果": {
            if (!上下文.开启者)
                return;
            debugLogForce("宝箱掉落配置", "命中负面效果段", "lifeKeep=", 动作.保留当前生命比例 ?? "nil", "buffId=", 动作.BuffID ?? "nil", "buffTime=", 动作.Buff持续时间 ?? "nil");
            if (动作.保留当前生命比例 != null) {
                const 当前生命 = GetWidgetLife(上下文.开启者);
                SetWidgetLife(上下文.开启者, 当前生命 * 动作.保留当前生命比例);
            }
            if (动作.BuffID != null && 动作.Buff持续时间 != null) {
                SFB_setBuff(上下文.开启者, 上下文.开启者, 动作.BuffID, 动作.Buff持续时间);
            }
            return;
        }
        case "发送广播提示": {
            广播宝箱装备消息(动作, 上下文);
            return;
        }
    }
}
function 执行高级掉落(config, 上下文) {
    const 高级掉落 = config.高级掉落;
    if (!高级掉落)
        return [];
    const roll = 上下文.指定主随机 != null ? 上下文.指定主随机 : randomInt(1, 100);
    debugLogForce("宝箱掉落配置", "高级掉落主随机", "type=", config.destructableType, "roll=", roll, "preRolled=", 上下文.指定主随机 != null);
    for (const 掉落段 of 高级掉落.随机段) {
        if (roll < 掉落段.最小值 || roll > 掉落段.最大值)
            continue;
        debugLogForce("宝箱掉落配置", "命中高级掉落段", "min=", 掉落段.最小值, "max=", 掉落段.最大值, "actionCount=", 掉落段.动作.length);
        const result = [];
        for (const 动作 of 掉落段.动作) {
            执行高级掉落动作(动作, result, 上下文);
        }
        return result;
    }
    return [];
}
export function 执行宝箱掉落(config, opener, ownerUnit, 指定主随机) {
    debugLogForce("宝箱掉落配置", "executeChestDrop", "type=", config.destructableType, "name=", config.name, "mode=", config.dropMode.type, "picks=", config.picks);
    if (config.高级掉落) {
        return 执行高级掉落(config, {
            开启者: opener,
            宝箱主人: ownerUnit,
            宝箱配置: config,
            x: 0,
            y: 0,
            指定主随机,
        });
    }
    return 按掉落模式执行(config.dropMode, config.picks);
}
export function 按可破坏物掉落(destructableType, opener, ownerUnit, 指定主随机) {
    const config = getChestConfigByString(destructableType);
    if (!config) {
        debugLogForce("宝箱掉落配置", "未找到宝箱配置", "type=", destructableType);
        return [];
    }
    debugLogForce("宝箱掉落配置", "命中宝箱配置", "type=", destructableType, "name=", config.name);
    return 执行宝箱掉落(config, opener, ownerUnit, 指定主随机);
}
export function 按宝箱配置掉落(config, opener, ownerUnit, 指定主随机) {
    debugLogForce("宝箱掉落配置", "直接使用宝箱配置", "type=", config.destructableType, "name=", config.name);
    return 执行宝箱掉落(config, opener, ownerUnit, 指定主随机);
}
export function 创建掉落物品(itemId, x, y) {
    if (!items[itemId]) {
        debugLogForce("宝箱掉落配置", "未解析到物品ID", itemId, "x=", x, "y=", y);
    }
    const item = CreateItem(stringToFourCC(itemId), x, y);
    debugLogForce("宝箱掉落配置", "创建掉落物品", "itemId=", itemId, "x=", x, "y=", y, "created=", item != null);
    if (item) {
        setLastCreatedItem(item);
    }
    return item;
}
function 获取掉落偏移(index) {
    return DROP_OFFSETS[index % DROP_OFFSETS.length] ?? DROP_OFFSETS[0];
}
export function 宝箱位置掉落(destructableType, x, y, opener, ownerUnit, 指定主随机) {
    const itemIds = 按可破坏物掉落(destructableType, opener, ownerUnit, 指定主随机);
    debugLogForce("宝箱掉落配置", "宝箱掉落结果", "type=", destructableType, "x=", x, "y=", y, "itemIds=", itemIds.join(","));
    const createdItems = [];
    for (let i = 0; i < itemIds.length; i++) {
        const offset = 获取掉落偏移(i);
        const item = 创建掉落物品(itemIds[i], x + offset.dx, y + offset.dy);
        if (item)
            createdItems.push(item);
    }
    debugLogForce("宝箱掉落配置", "宝箱掉落完成", "type=", destructableType, "count=", createdItems.length);
    return createdItems;
}
export function 宝箱配置掉落(config, x, y, opener, ownerUnit, 指定主随机) {
    const itemIds = 按宝箱配置掉落(config, opener, ownerUnit, 指定主随机);
    debugLogForce("宝箱掉落配置", "宝箱掉落结果", "type=", config.destructableType, "x=", x, "y=", y, "itemIds=", itemIds.join(","));
    const createdItems = [];
    for (let i = 0; i < itemIds.length; i++) {
        const offset = 获取掉落偏移(i);
        const item = 创建掉落物品(itemIds[i], x + offset.dx, y + offset.dy);
        if (item)
            createdItems.push(item);
    }
    debugLogForce("宝箱掉落配置", "宝箱掉落完成", "type=", config.destructableType, "count=", createdItems.length);
    return createdItems;
}
export { 执行宝箱掉落 as executeChestDrop, 按可破坏物掉落 as dropItemsByDestructable, 按宝箱配置掉落 as dropItemsByChestConfig, 创建掉落物品 as createDropItem, 宝箱位置掉落 as dropItemsFromChest, 宝箱配置掉落 as dropItemsFromChestConfig, };
