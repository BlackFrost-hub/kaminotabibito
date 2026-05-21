/** @noSelfInFile */
/**
 * 进度条特效模块（施法进度条）
 *
 * 说明：
 * 1. 不使用 `特效绑定系统.ts`
 * 2. 不使用 `AddSpecialEffectTarget` / `AddSpecialEffectTargetUnitBJ`
 * 3. 当前实现改为直接创建物编单位 `e011`（父 id: `ewsp`）
 * 4. 进度条颜色、动画速度、动画序号都通过单位接口控制
 * 5. 销毁时直接 `RemoveUnit`，不是延迟特效回收
 */
const jass = require("jass.common");
const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index");
const 调试模块名 = "进度条特效";
const PROGRESSBAR_UNIT_ID = 1697657137; // 'e011'
const PROGRESSBAR_OWNER_PLAYER_ID = 4;
const DEFAULT_HEIGHT_OFFSET = 275.0;
const DEFAULT_SCALE = 1.0;
const DEFAULT_ANIM_INDEX = 0;
const DEFAULT_COLOR_RGBA = { r: 255, g: 255, b: 0, a: 255 };
const UNIT_ALIVE_LIFE = 0.405;
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
const 进度条映射 = new Map();
const 单位进度条映射 = new Map();
let 已注册计时器 = false;
function 取句柄ID(h) {
    if (h == null || h === 0)
        return 0;
    return GetHandleId(h);
}
function 获取有序进度条单位ID列表() {
    const ids = [];
    for (const id of 进度条映射.keys()) {
        ids.push(id);
    }
    ids.sort((a, b) => a - b);
    return ids;
}
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
    return jass.R2I(value);
}
function 设置进度条位置(进度条单位, 跟随单位, 高度偏移) {
    if (!单位存活(进度条单位) || !单位存活(跟随单位))
        return;
    SetUnitX(进度条单位, GetUnitX(跟随单位));
    SetUnitY(进度条单位, GetUnitY(跟随单位));
    SetUnitFlyHeight(进度条单位, GetUnitFlyHeight(跟随单位) + 高度偏移, 0);
}
function 立即移除进度条单位(进度条单位) {
    if (进度条单位 == null || 进度条单位 === 0)
        return;
    if (GetUnitTypeId(进度条单位) === 0)
        return;
    RemoveUnit(进度条单位);
}
function 更新所有进度条位置() {
    const 进度条单位ID列表 = 获取有序进度条单位ID列表();
    for (let i = 0; i < 进度条单位ID列表.length; i++) {
        const 数据 = 进度条映射.get(进度条单位ID列表[i]);
        if (数据 == null)
            continue;
        const 进度条单位 = 数据.进度条单位;
        if (!单位存活(数据.跟随单位) || !单位存活(进度条单位)) {
            移除进度条特效(进度条单位);
            continue;
        }
        设置进度条位置(进度条单位, 数据.跟随单位, 数据.高度偏移);
    }
    if (进度条映射.size === 0 && 已注册计时器) {
        已注册计时器 = false;
        offTick10ms(更新所有进度条位置);
    }
}
function 确保注册计时器() {
    if (已注册计时器)
        return;
    已注册计时器 = true;
    onTick10ms(更新所有进度条位置);
}
function 移除进度条特效(进度条单位) {
    if (进度条单位 == null || 进度条单位 === 0)
        return;
    const 进度条单位ID = 取句柄ID(进度条单位);
    const 数据 = 进度条映射.get(进度条单位ID);
    if (数据 != null) {
        单位进度条映射.delete(数据.跟随单位ID);
    }
    进度条映射.delete(进度条单位ID);
    立即移除进度条单位(进度条单位);
}
export function 创建进度条特效(单位, 选项) {
    if (!单位存活(单位))
        return null;
    const 单位ID = 取句柄ID(单位);
    if (单位ID === 0)
        return null;
    const 已有进度条 = 单位进度条映射.get(单位ID);
    if (已有进度条 != null) {
        移除进度条特效(已有进度条);
    }
    const 高度偏移 = 选项?.高度偏移 ?? DEFAULT_HEIGHT_OFFSET;
    const 缩放 = 选项?.缩放 ?? DEFAULT_SCALE;
    const 动画序号 = 选项?.动画序号 ?? DEFAULT_ANIM_INDEX;
    const 动画速度 = 选项?.动画速度;
    const 颜色 = 选项?.颜色 ?? DEFAULT_COLOR_RGBA;
    const x = GetUnitX(单位);
    const y = GetUnitY(单位);
    const owner = Player(PROGRESSBAR_OWNER_PLAYER_ID);
    const 进度条单位 = CreateUnit(owner, PROGRESSBAR_UNIT_ID, x, y, 0);
    if (!单位存活(进度条单位))
        return null;
    SetUnitScale(进度条单位, 缩放, 缩放, 缩放);
    if (typeof SetUnitAnimationByIndex === "function") {
        SetUnitAnimationByIndex(进度条单位, 动画序号);
    }
    if (动画速度 != null && 动画速度 > 0) {
        SetUnitTimeScale(进度条单位, 动画速度);
    }
    SetUnitVertexColor(进度条单位, 裁剪到字节(颜色.r), 裁剪到字节(颜色.g), 裁剪到字节(颜色.b), 裁剪到字节(颜色.a));
    设置进度条位置(进度条单位, 单位, 高度偏移);
    const 数据 = {
        进度条单位,
        跟随单位: 单位,
        跟随单位ID: 单位ID,
        高度偏移,
    };
    进度条映射.set(取句柄ID(进度条单位), 数据);
    单位进度条映射.set(单位ID, 进度条单位);
    确保注册计时器();
    debugLogForce(调试模块名, "创建进度条单位成功", "unitId=", 单位ID, "animSpeed=", 动画速度 ?? "default");
    return 进度条单位;
}
export function 销毁进度条特效(进度条单位) {
    移除进度条特效(进度条单位);
}
export function 销毁单位进度条特效(单位) {
    if (单位 == null || 单位 === 0)
        return;
    const 单位ID = 取句柄ID(单位);
    if (单位ID === 0)
        return;
    const 进度条单位 = 单位进度条映射.get(单位ID);
    if (进度条单位 != null) {
        移除进度条特效(进度条单位);
    }
    if (进度条映射.size === 0 && 已注册计时器) {
        已注册计时器 = false;
        offTick10ms(更新所有进度条位置);
    }
}
export function 是否存在进度条特效(单位) {
    if (单位 == null || 单位 === 0)
        return false;
    return 单位进度条映射.has(取句柄ID(单位));
}
export function 获取单位进度条特效(单位) {
    if (单位 == null || 单位 === 0)
        return undefined;
    return 单位进度条映射.get(取句柄ID(单位));
}
export function 清除所有进度条特效() {
    const 进度条单位ID列表 = 获取有序进度条单位ID列表();
    for (let i = 0; i < 进度条单位ID列表.length; i++) {
        const 数据 = 进度条映射.get(进度条单位ID列表[i]);
        if (数据 != null) {
            立即移除进度条单位(数据.进度条单位);
        }
    }
    进度条映射.clear();
    单位进度条映射.clear();
    if (已注册计时器) {
        已注册计时器 = false;
        offTick10ms(更新所有进度条位置);
    }
}
const g = globalThis;
if (typeof g.创建进度条特效 !== "function") {
    g.创建进度条特效 = 创建进度条特效;
}
if (typeof g.销毁单位进度条特效 !== "function") {
    g.销毁单位进度条特效 = 销毁单位进度条特效;
}
