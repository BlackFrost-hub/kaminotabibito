/** @noSelfInFile */
/**
 * 护盾条表现
 *
 * 说明：
 * 1. 复用进度条单位 e011 显示护盾条
 * 2. 第一版只显示总护盾值
 * 3. 护盾条颜色：对齐伤害数字模型的伤害属性色
 * 4. 护盾耗尽或单位死亡时删除
 */
import { 获取单位总护盾值, 取句柄ID } from "./02．护盾实例";
const jass = require("jass.common");
const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器");
// ==========================================================================================
// JASS 函数别名
// ==========================================================================================
const GetHandleId = jass.GetHandleId;
const Player = jass.Player;
const CreateUnit = jass.CreateUnit;
const RemoveUnit = jass.RemoveUnit;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitFlyHeight = jass.GetUnitFlyHeight;
const GetUnitTypeId = jass.GetUnitTypeId;
const GetUnitState = jass.GetUnitState;
const IsUnitType = jass.IsUnitType;
const SetUnitX = jass.SetUnitX;
const SetUnitY = jass.SetUnitY;
const SetUnitFlyHeight = jass.SetUnitFlyHeight;
const SetUnitScale = jass.SetUnitScale;
const SetUnitTimeScale = jass.SetUnitTimeScale;
const SetUnitVertexColor = jass.SetUnitVertexColor;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex;
const R2I = jass.R2I;
// ==========================================================================================
// 常量
// ==========================================================================================
const SHIELD_BAR_UNIT_ID = 1935827314; // 'sbar'
const SHIELD_BAR_OWNER_PLAYER_ID = 4;
const DEFAULT_HEIGHT_OFFSET = 100.0; // 比施法进度条低一些
const UNIT_ALIVE_LIFE = 0.405;
// 颜色定义（与物体编辑器 sbar 单位颜色一致）
const COLOR_DEFAULT = { r: 100, g: 200, b: 255, a: 255 }; // 蓝白色（默认，匹配物编 red=100,green=200,blue=255）
const COLOR_PHYSICAL = { r: 180, g: 100, b: 30, a: 255 }; // 棕色（物理伤害）
const COLOR_MAGICAL = { r: 30, g: 30, b: 180, a: 255 }; // 深蓝色（魔法伤害）
const COLOR_GENERAL = { r: 200, g: 200, b: 200, a: 255 }; // 灰白色（其他/通用伤害）
const COLOR_ENHANCED = { r: 255, g: 140, b: 0, a: 255 };
const COLOR_FIRE = { r: 255, g: 66, b: 66, a: 255 };
const COLOR_WATER = { r: 80, g: 190, b: 255, a: 255 };
const COLOR_THUNDER = { r: 170, g: 220, b: 255, a: 255 };
const COLOR_METAL = { r: 255, g: 210, b: 80, a: 255 };
const COLOR_WOOD = { r: 120, g: 255, b: 120, a: 255 };
const COLOR_LIGHT = { r: 255, g: 255, b: 170, a: 255 };
const COLOR_DARK = { r: 180, g: 130, b: 255, a: 255 };
const 护盾条映射 = new Map(); // 单位ID -> 护盾条数据
let 已注册计时器 = false;
// ==========================================================================================
// 工具函数
// ==========================================================================================
function 单位存活(u) {
    if (u == null || u === 0)
        return false;
    if (GetUnitTypeId(u) === 0)
        return false;
    if (IsUnitType(u, jass.UNIT_TYPE_DEAD))
        return false;
    return GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}
function 裁剪到字节(value) {
    if (value <= 0)
        return 0;
    if (value >= 255)
        return 255;
    return R2I(value);
}
function 实数转整数(value) {
    return R2I(value);
}
function 获取有序护盾条单位ID列表() {
    const result = [];
    for (const 单位ID of 护盾条映射.keys()) {
        result.push(单位ID);
    }
    result.sort((a, b) => a - b);
    return result;
}
// ==========================================================================================
// 护盾条管理
// ==========================================================================================
function 设置护盾条位置(数据) {
    if (!单位存活(数据.护盾条单位) || !单位存活(数据.跟随单位))
        return;
    SetUnitX(数据.护盾条单位, GetUnitX(数据.跟随单位));
    SetUnitY(数据.护盾条单位, GetUnitY(数据.跟随单位));
    SetUnitFlyHeight(数据.护盾条单位, GetUnitFlyHeight(数据.跟随单位) + 数据.高度偏移, 0);
}
function 设置护盾条颜色(数据, 颜色) {
    if (!单位存活(数据.护盾条单位))
        return;
    SetUnitVertexColor(数据.护盾条单位, 裁剪到字节(颜色.r), 裁剪到字节(颜色.g), 裁剪到字节(颜色.b), 裁剪到字节(颜色.a));
    数据.当前颜色 = 颜色;
}
function 设置护盾条比例(数据, 比例) {
    if (!单位存活(数据.护盾条单位))
        return;
    // 通过动画帧控制显示比例
    // S_Shiled.mdl 有 100 帧对应 0%-100%
    let 帧索引 = 实数转整数(比例 * 99);
    if (帧索引 < 0)
        帧索引 = 0;
    if (帧索引 > 99)
        帧索引 = 99;
    if (typeof SetUnitAnimationByIndex === "function") {
        SetUnitAnimationByIndex(数据.护盾条单位, 帧索引);
    }
}
function 立即移除护盾条单位(护盾条单位) {
    if (护盾条单位 == null || 护盾条单位 === 0)
        return;
    if (GetUnitTypeId(护盾条单位) === 0)
        return;
    RemoveUnit(护盾条单位);
}
function 移除护盾条(单位ID) {
    const 数据 = 护盾条映射.get(单位ID);
    if (数据 == null)
        return;
    立即移除护盾条单位(数据.护盾条单位);
    护盾条映射.delete(单位ID);
}
function 更新所有护盾条位置() {
    const 单位ID列表 = 获取有序护盾条单位ID列表();
    for (let i = 0; i < 单位ID列表.length; i++) {
        const 单位ID = 单位ID列表[i];
        const 数据 = 护盾条映射.get(单位ID);
        if (数据 == null) {
            continue;
        }
        // 检查单位是否存活
        if (!单位存活(数据.跟随单位) || !单位存活(数据.护盾条单位)) {
            移除护盾条(单位ID);
            continue;
        }
        // 更新位置
        设置护盾条位置(数据);
        // 更新比例：当前总护盾 / 初始总护盾
        const 当前总护盾 = 获取单位总护盾值(单位ID);
        if (当前总护盾 <= 0) {
            移除护盾条(单位ID);
            continue;
        }
        // 动态修正初始总护盾（防止创建时漏读后续护盾）
        if (当前总护盾 > 数据.初始总护盾) {
            数据.初始总护盾 = 当前总护盾;
        }
        const 比例 = 数据.初始总护盾 > 0 ? 当前总护盾 / 数据.初始总护盾 : 1;
        设置护盾条比例(数据, 比例);
        // 颜色恢复倒计时
        if (数据.颜色恢复倒计时 > 0) {
            数据.颜色恢复倒计时 -= 0.02;
            if (数据.颜色恢复倒计时 <= 0) {
                设置护盾条颜色(数据, COLOR_DEFAULT);
            }
        }
        // 颜色恢复倒计时
        if (数据.颜色恢复倒计时 > 0) {
            数据.颜色恢复倒计时 -= 0.02;
            if (数据.颜色恢复倒计时 <= 0) {
                设置护盾条颜色(数据, COLOR_DEFAULT);
            }
        }
    }
    if (护盾条映射.size === 0 && 已注册计时器) {
        已注册计时器 = false;
        offTick10ms(更新所有护盾条位置);
    }
}
function 确保注册计时器() {
    if (已注册计时器)
        return;
    已注册计时器 = true;
    onTick10ms(更新所有护盾条位置);
}
// ==========================================================================================
// 对外 API
// ==========================================================================================
/**
 * 创建或更新护盾条
 */
export function 创建护盾条(单位) {
    const 单位ID = 取句柄ID(单位);
    if (单位ID === 0)
        return;
    // 已有护盾条则更新初始总护盾值
    const 已有 = 护盾条映射.get(单位ID);
    if (已有 != null) {
        已有.初始总护盾 = 获取单位总护盾值(单位ID);
        return;
    }
    // 创建新的护盾条单位
    const x = GetUnitX(单位);
    const y = GetUnitY(单位);
    const owner = Player(SHIELD_BAR_OWNER_PLAYER_ID);
    const 护盾条单位 = CreateUnit(owner, SHIELD_BAR_UNIT_ID, x, y, 0);
    if (!单位存活(护盾条单位))
        return;
    SetUnitScale(护盾条单位, 1, 1, 1);
    if (typeof SetUnitAnimationByIndex === "function") {
        SetUnitAnimationByIndex(护盾条单位, 0);
    }
    SetUnitVertexColor(护盾条单位, 裁剪到字节(COLOR_DEFAULT.r), 裁剪到字节(COLOR_DEFAULT.g), 裁剪到字节(COLOR_DEFAULT.b), 裁剪到字节(COLOR_DEFAULT.a));
    const 初始总护盾 = 获取单位总护盾值(单位ID);
    const 数据 = {
        护盾条单位,
        跟随单位: 单位,
        跟随单位ID: 单位ID,
        高度偏移: DEFAULT_HEIGHT_OFFSET,
        当前颜色: COLOR_DEFAULT,
        颜色恢复倒计时: 0,
        初始总护盾,
    };
    护盾条映射.set(单位ID, 数据);
    设置护盾条位置(数据);
    确保注册计时器();
}
/**
 * 删除护盾条
 */
export function 删除护盾条(单位) {
    const 单位ID = 取句柄ID(单位);
    if (单位ID === 0)
        return;
    移除护盾条(单位ID);
}
/**
 * 护盾条闪色（受击反馈）
 * @param 伤害类型 0=其他/通用, 1=物理, 2=魔法, 3=强化, 4=火, 5=水/冰, 6=雷, 7=金/毒, 8=木/风, 9=光, 10=暗
 */
export function 护盾条闪色(单位, 伤害类型) {
    const 单位ID = 取句柄ID(单位);
    const 数据 = 护盾条映射.get(单位ID);
    if (数据 == null)
        return;
    let 颜色;
    if (伤害类型 === 1) {
        颜色 = COLOR_PHYSICAL;
    }
    else if (伤害类型 === 2) {
        颜色 = COLOR_MAGICAL;
    }
    else if (伤害类型 === 3) {
        颜色 = COLOR_ENHANCED;
    }
    else if (伤害类型 === 4) {
        颜色 = COLOR_FIRE;
    }
    else if (伤害类型 === 5) {
        颜色 = COLOR_WATER;
    }
    else if (伤害类型 === 6) {
        颜色 = COLOR_THUNDER;
    }
    else if (伤害类型 === 7) {
        颜色 = COLOR_METAL;
    }
    else if (伤害类型 === 8) {
        颜色 = COLOR_WOOD;
    }
    else if (伤害类型 === 9) {
        颜色 = COLOR_LIGHT;
    }
    else if (伤害类型 === 10) {
        颜色 = COLOR_DARK;
    }
    else {
        颜色 = COLOR_GENERAL;
    }
    设置护盾条颜色(数据, 颜色);
    数据.颜色恢复倒计时 = 0.3; // 0.3秒后恢复默认颜色
}
/**
 * 检查单位是否有护盾条
 */
export function 是否有护盾条(单位) {
    const 单位ID = 取句柄ID(单位);
    return 护盾条映射.has(单位ID);
}
/**
 * 清除所有护盾条
 */
export function 清除所有护盾条() {
    const 单位ID列表 = 获取有序护盾条单位ID列表();
    for (let i = 0; i < 单位ID列表.length; i++) {
        移除护盾条(单位ID列表[i]);
    }
    护盾条映射.clear();
    if (已注册计时器) {
        已注册计时器 = false;
        offTick10ms(更新所有护盾条位置);
    }
}
/** 供伤害系统调用的闪色入口 */
function 护盾条闪色入口(单位, 伤害类型) {
    护盾条闪色(单位, 伤害类型);
}
const g = globalThis;
if (typeof g._shieldBarFlashColor !== "function") {
    g._shieldBarFlashColor = 护盾条闪色入口;
}
