/** @noSelfInFile */
/**
 * 提示特效系统
 *
 * 快速创建技能预警提示圈：矩形、扇形、圆形
 * 模型路径：resource\models\Tip\
 *
 * 动画速度说明（所有特效通用）：
 * - 默认 1倍速 = 1秒延迟（动画播放1秒）
 * - 0.5倍 = 2秒延迟（动画播放2秒，更慢）
 * - 2倍 = 0.5秒延迟（动画播放0.5秒，更快）
 * - 支持传入 speed 参数自定义动画速率
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

// ==========================================================================================
// JASS 函数别名
// ==========================================================================================

const { RMaxBJ, RMinBJ, CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  RMaxBJ: (this: void, a: number, b: number) => number;
  RMinBJ: (this: void, a: number, b: number) => number;
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};

const AddSpecialEffect = jass.AddSpecialEffect as (path: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (e: any) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (u: any) => any;
const GetPlayerId = jass.GetPlayerId as (p: any) => number;
const Player = jass.Player as (playerId: number) => any;

const EXSetEffectSpeed = japi.EXSetEffectSpeed as (e: any, speed: number) => void;
const EXSetEffectSize = japi.EXSetEffectSize as (e: any, size: number) => void;
const EXEffectMatRotateZ = japi.EXEffectMatRotateZ as (e: any, angle: number) => void;
const EXEffectMatScale = japi.EXEffectMatScale as (e: any, x: number, y: number, z: number) => void;
const DzSetEffectVertexColor = japi.DzSetEffectVertexColor as ((e: any, color: number) => void) | undefined;
const DzSetEffectVertexAlpha = japi.DzSetEffectVertexAlpha as ((e: any, alpha: number) => void) | undefined;
const DzSetEffectAnimation = japi.DzSetEffectAnimation as ((e: any, anim: number, defaultTime: number) => void) | undefined;
const DzPlayEffectAnimation = japi.DzPlayEffectAnimation as ((e: any, anim: string, link: string) => void) | undefined;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const SetUnitScale = jass.SetUnitScale as (u: any, x: number, y: number, z: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (u: any, speed: number) => void;
const SetUnitVertexColor = jass.SetUnitVertexColor as (u: any, r: number, g: number, b: number, a: number) => void;
const RemoveUnit = jass.RemoveUnit as (u: any) => void;

// ==========================================================================================
// 模型路径
// ==========================================================================================

const MODEL_DIR = "resource\\models\\Tip\\skillTip\\";
const MODEL_SQUARE1X = MODEL_DIR + "UnifiedTip_Rect1x.mdx";
const MODEL_SQUARE1_5X = MODEL_DIR + "UnifiedTip_Rect1_5x.mdx";
const MODEL_SQUARE2X = MODEL_DIR + "UnifiedTip_Rect2x.mdx";
const MODEL_SQUARE2_5X = MODEL_DIR + "UnifiedTip_Rect2_5x.mdx";
const MODEL_SQUARE3X = MODEL_DIR + "UnifiedTip_Rect3x.mdx";
const MODEL_SQUARE3_5X = MODEL_DIR + "UnifiedTip_Rect3_5x.mdx";
const MODEL_SQUARE4X = MODEL_DIR + "UnifiedTip_Rect4x.mdx";
const MODEL_SQUARE5X = MODEL_DIR + "UnifiedTip_Rect5x.mdx";
const MODEL_SQUARE6X = MODEL_DIR + "UnifiedTip_Rect6x.mdx";
const MODEL_SQUARE12X = MODEL_DIR + "UnifiedTip_Rect12x.mdx";
const MODEL_LINE1X = MODEL_DIR + "UnifiedTip_Line1x.mdx";
const MODEL_LINE1_5X = MODEL_DIR + "UnifiedTip_Line1_5x.mdx";
const MODEL_LINE2X = MODEL_DIR + "UnifiedTip_Line2x.mdx";
const MODEL_LINE2_5X = MODEL_DIR + "UnifiedTip_Line2_5x.mdx";
const MODEL_LINE3X = MODEL_DIR + "UnifiedTip_Line3x.mdx";
const MODEL_LINE3_5X = MODEL_DIR + "UnifiedTip_Line3_5x.mdx";
const MODEL_LINE4X = MODEL_DIR + "UnifiedTip_Line4x.mdx";
const MODEL_LINE5X = MODEL_DIR + "UnifiedTip_Line5x.mdx";
const MODEL_LINE6X = MODEL_DIR + "UnifiedTip_Line6x.mdx";
const MODEL_SECTOR = MODEL_DIR + "SimpleSectorTip.mdx";
const MODEL_RING = MODEL_DIR + "UnifiedTip_Ring.mdx";
const MODEL_RING_THICK = MODEL_DIR + "UnifiedTip_RingThick.mdx";
const MODEL_RING_A = MODEL_DIR + "UnifiedTip_Ring_A.mdx";
const MODEL_RING_B = MODEL_DIR + "UnifiedTip_Ring_B.mdx";
const MODEL_RING_C = MODEL_DIR + "UnifiedTip_Ring_C.mdx";
// 所有资源保持中性白色，仅在运行时按来源单位染色。
// 若后续确定改用淡金色，只需将此常量改为 0xFFFFE6A0。
const 提示圈友方色 = 0xFFFFFFFF;
const 提示圈敌方色 = 0xFFFF2020;

// ==========================================================================================
// 提示特效销毁
// ==========================================================================================

const 提示特效销毁检查间隔毫秒 = 10;
const 特效步进缩放检查间隔毫秒 = 20;
const 待销毁提示特效列表: any[] = [];
const 待销毁提示特效到期毫秒列表: number[] = [];
let 提示特效销毁检查回调ID = 0;

interface 特效步进缩放上下文 {
  特效: any;
  当前次数: number;
  最大次数: number;
  基础尺寸: number;
  每次增量: number;
  周期秒: number;
  下次触发时间: number;
}

const 特效步进缩放上下文列表: 特效步进缩放上下文[] = [];
let 特效步进缩放检查回调ID = 0;

function 停止提示特效销毁检查(): void {
  if (提示特效销毁检查回调ID <= 0) return;
  removePeriodicCallback(提示特效销毁检查回调ID);
  提示特效销毁检查回调ID = 0;
}

function on提示特效销毁检查(this: void): void {
  const now = getServerTime();
  let writeIndex = 0;
  for (let i = 0; i < 待销毁提示特效列表.length; i++) {
    const e = 待销毁提示特效列表[i];
    if (now >= 待销毁提示特效到期毫秒列表[i]) {
      if (e) {
        立即隐藏并销毁提示特效(e);
      }
    } else {
      待销毁提示特效列表[writeIndex] = e;
      待销毁提示特效到期毫秒列表[writeIndex] = 待销毁提示特效到期毫秒列表[i];
      writeIndex += 1;
    }
  }

  for (let i = 待销毁提示特效列表.length - 1; i >= writeIndex; i--) {
    待销毁提示特效列表.pop();
    待销毁提示特效到期毫秒列表.pop();
  }

  if (待销毁提示特效列表.length <= 0) {
    停止提示特效销毁检查();
  }
}

function 确保提示特效销毁检查(): void {
  if (提示特效销毁检查回调ID > 0) return;
  提示特效销毁检查回调ID = addPeriodicCallback(提示特效销毁检查间隔毫秒, on提示特效销毁检查);
}

function 停止特效步进缩放检查(): void {
  if (特效步进缩放检查回调ID <= 0) return;
  removePeriodicCallback(特效步进缩放检查回调ID);
  特效步进缩放检查回调ID = 0;
}

function on特效步进缩放检查(this: void): void {
  const now = getServerTime();
  for (let i = 特效步进缩放上下文列表.length - 1; i >= 0; i--) {
    const 上下文 = 特效步进缩放上下文列表[i];
    if (!上下文.特效) {
      特效步进缩放上下文列表.splice(i, 1);
      continue;
    }
    if (now < 上下文.下次触发时间) continue;

    上下文.当前次数 += 1;
    if (上下文.当前次数 >= 上下文.最大次数) {
      特效步进缩放上下文列表.splice(i, 1);
      continue;
    }

    EXSetEffectSize(上下文.特效, 上下文.基础尺寸 + 上下文.当前次数 * 上下文.每次增量);
    上下文.下次触发时间 = now + 上下文.周期秒 * 1000;
  }

  if (特效步进缩放上下文列表.length <= 0) {
    停止特效步进缩放检查();
  }
}

function 确保特效步进缩放检查(): void {
  if (特效步进缩放检查回调ID > 0) return;
  特效步进缩放检查回调ID = addPeriodicCallback(特效步进缩放检查间隔毫秒, on特效步进缩放检查);
}

function 安全销毁特效(duration: number, effect: any): void {
  if (!effect) return;

  if (duration <= 0) {
    立即隐藏并销毁提示特效(effect);
    return;
  }

  待销毁提示特效列表.push(effect);
  待销毁提示特效到期毫秒列表.push(getServerTime() + duration * 1000);
  确保提示特效销毁检查();
}

function 设置提示特效顶点颜色(e: any, color: number): void {
  if (!e) return;
  if (typeof DzSetEffectVertexColor === "function") {
    DzSetEffectVertexColor(e, color);
  }
}

export function 按所属单位设置提示圈颜色(e: any, 来源单位: any, 无来源默认颜色: number = 提示圈敌方色): void {
  if (!e) return;
  if (!来源单位) {
    设置提示特效顶点颜色(e, 无来源默认颜色);
    return;
  }

  const 所属玩家 = GetOwningPlayer(来源单位);
  if (!所属玩家) {
    设置提示特效顶点颜色(e, 无来源默认颜色);
    return;
  }

  const 玩家ID = GetPlayerId(所属玩家);
  if (玩家ID >= 0 && 玩家ID <= 5) {
    设置提示特效顶点颜色(e, 提示圈友方色);
    return;
  }

  设置提示特效顶点颜色(e, 提示圈敌方色);
}

/**
 * 让一个已创建的特效按固定周期逐步放大。
 */
export function 启动特效步进缩放(
  特效: any,
  基础尺寸: number,
  最大次数: number,
  周期秒: number,
  每次增量: number = 1
): void {
  if (!特效 || 最大次数 <= 0 || 周期秒 <= 0) return;

  移除特效步进缩放(特效);
  特效步进缩放上下文列表.push({
    特效,
    当前次数: 0,
    最大次数,
    基础尺寸,
    每次增量,
    周期秒,
    下次触发时间: getServerTime() + 周期秒 * 1000,
  });
  确保特效步进缩放检查();
}

export function 移除特效步进缩放(特效: any): void {
  if (!特效) return;
  for (let i = 特效步进缩放上下文列表.length - 1; i >= 0; i--) {
    if (特效步进缩放上下文列表[i].特效 === 特效) {
      特效步进缩放上下文列表.splice(i, 1);
    }
  }

  if (特效步进缩放上下文列表.length <= 0) {
    停止特效步进缩放检查();
  }
}

// ==========================================================================================
// 矩形提示圈
// ==========================================================================================

/**
 * 精确无变形比例：1:1、1:1.5、1:2、1:2.5、1:3、1:3.5、1:4、1:5、1:6、1:12。
 * 其他比例会选用最接近的预制模型，仍可能出现轻微的非等比拉伸。
 * 如宽度为 300、比例为 1:1.5，则长度应为 450。
 * 【重要】坐标必须传矩形路径起点，严禁传矩形中点；函数内部会沿朝向自动前移半个长度到模型中点。
 * @param 路径起点X 矩形路径起点 X 坐标
 * @param 路径起点Y 矩形路径起点 Y 坐标
 * @param width 宽度（最大1500）
 * @param long 长度（最大7500）
 * @param fac 朝向角度
 * @param time 持续时间（<=0 表示1秒）
 * @param speed 动画速率（可选，默认 1/time）
 * 1:6 与 1:12 之间按更接近的预制模型缩放；超过 1:12 时固定使用 12X 模型。
 */
export function 创建矩形提示圈(
  路径起点X: number, 路径起点Y: number, width: number, long: number, fac: number, time: number, speed?: number, 来源单位?: any
): void {
  const e = 创建矩形提示圈特效(路径起点X, 路径起点Y, width, long, fac, speed);
  if (!e) return;

  按所属单位设置提示圈颜色(e, 来源单位);
  const duration = time <= 0 ? 1 : time + 0.05;
  安全销毁特效(duration, e);
}

/**
 * 创建一个需要手动销毁的矩形提示圈特效句柄。
 * 【重要】坐标必须传矩形路径起点，严禁传矩形中点；函数内部会沿朝向自动前移半个长度到模型中点。
 */
export function 创建矩形提示圈特效(
  路径起点X: number, 路径起点Y: number, width: number, long: number, fac: number, speed?: number
): any {
  if (width > 1500) width = 1500;
  if (long > 7500) long = 7500;

  const sw = width / 1000;
  const dis = long / 2;
  const 模型中点X = 路径起点X + CosBJ(fac) * dis;
  const 模型中点Y = 路径起点Y + SinBJ(fac) * dis;

  let model: string;
  let sl: number;
  const ratio = long / width;

  if (ratio <= 1.25) {
    model = MODEL_SQUARE1X;
    sl = long / 1000;
  } else if (ratio <= 1.75) {
    model = MODEL_SQUARE1_5X;
    sl = long / 1500;
  } else if (ratio <= 2.25) {
    model = MODEL_SQUARE2X;
    sl = long / 2000;
  } else if (ratio <= 2.75) {
    model = MODEL_SQUARE2_5X;
    sl = long / 2500;
  } else if (ratio <= 3.25) {
    model = MODEL_SQUARE3X;
    sl = long / 3000;
  } else if (ratio <= 3.75) {
    model = MODEL_SQUARE3_5X;
    sl = long / 3500;
  } else if (ratio <= 4.5) {
    model = MODEL_SQUARE4X;
    sl = long / 4000;
  } else if (ratio <= 5.5) {
    model = MODEL_SQUARE5X;
    sl = long / 5000;
  } else if (ratio <= 9) {
    model = MODEL_SQUARE6X;
    sl = long / 6000;
  } else {
    model = MODEL_SQUARE12X;
    sl = long / 12000;
  }

  const e = AddSpecialEffect(model, 模型中点X, 模型中点Y);
  if (!e) return;

  const s = speed ?? 1.0;

  EXEffectMatRotateZ(e, fac + 270);
  EXEffectMatScale(e, sl, sw, 1.0);
  EXSetEffectSpeed(e, s);
  return e;
}

/**
 * 创建带中轴延伸箭头的方向直线提示。
 * 预制比例与矩形一致，精确命中时只进行等比缩放。
 * 【重要】坐标必须传直线路径起点，严禁传模型中点；函数内部会沿朝向自动前移半个长度到模型中点。
 */
export function 创建方向直线提示圈(
  路径起点X: number, 路径起点Y: number, width: number, long: number, fac: number, time: number, speed?: number, 来源单位?: any
): void {
  const e = 创建方向直线提示圈特效(路径起点X, 路径起点Y, width, long, fac, speed);
  if (!e) return;
  按所属单位设置提示圈颜色(e, 来源单位);
  安全销毁特效(time <= 0 ? 1 : time + 0.05, e);
}

/**
 * 创建一个需要手动销毁的方向直线提示圈特效句柄。
 * 【重要】坐标必须传直线路径起点，严禁传模型中点；函数内部会沿朝向自动前移半个长度到模型中点。
 */
export function 创建方向直线提示圈特效(
  路径起点X: number, 路径起点Y: number, width: number, long: number, fac: number, speed?: number
): any {
  if (width <= 0 || long <= 0) return null;
  if (width > 1500) width = 1500;
  if (long > 7500) long = 7500;

  let model: string;
  let modelLong: number;
  const ratio = long / width;
  if (ratio <= 1.25) {
    model = MODEL_LINE1X;
    modelLong = 1000;
  } else if (ratio <= 1.75) {
    model = MODEL_LINE1_5X;
    modelLong = 1500;
  } else if (ratio <= 2.25) {
    model = MODEL_LINE2X;
    modelLong = 2000;
  } else if (ratio <= 2.75) {
    model = MODEL_LINE2_5X;
    modelLong = 2500;
  } else if (ratio <= 3.25) {
    model = MODEL_LINE3X;
    modelLong = 3000;
  } else if (ratio <= 3.75) {
    model = MODEL_LINE3_5X;
    modelLong = 3500;
  } else if (ratio <= 4.5) {
    model = MODEL_LINE4X;
    modelLong = 4000;
  } else if (ratio <= 5.5) {
    model = MODEL_LINE5X;
    modelLong = 5000;
  } else {
    model = MODEL_LINE6X;
    modelLong = 6000;
  }

  const dis = long / 2;
  const 模型中点X = 路径起点X + CosBJ(fac) * dis;
  const 模型中点Y = 路径起点Y + SinBJ(fac) * dis;
  const e = AddSpecialEffect(model, 模型中点X, 模型中点Y);
  if (!e) return null;

  EXEffectMatRotateZ(e, fac + 270);
  EXEffectMatScale(e, long / modelLong, width / 1000, 1);
  EXSetEffectSpeed(e, speed ?? 1.0);
  return e;
}

// ==========================================================================================
// 扇形提示圈
// ==========================================================================================

/**
 * 白色扇形提示圈
 * `size = 1.0` 时，对应模型原始扇形尺寸：内侧约 32 半径，外侧约 512 半径。
 */
export function 创建白色扇形提示圈(
  x: number, y: number, fac: number, size: number, time: number, speed?: number, 来源单位?: any
): void {
  x += CosBJ(fac) * 10;
  y += SinBJ(fac) * 10;

  const e = AddSpecialEffect(MODEL_SECTOR, x, y);
  if (!e) return;

  按所属单位设置提示圈颜色(e, 来源单位, 提示圈友方色);
  EXEffectMatRotateZ(e, fac);
  EXSetEffectSize(e, size);
  EXSetEffectSpeed(e, speed ?? 1.0);

  const duration = time <= 0 ? 0.5 : time + 0.05;
  安全销毁特效(duration, e);
}

/**
 * 红色扇形提示圈
 * `size = 1.0` 时，对应模型原始扇形尺寸：内侧约 32 半径，外侧约 512 半径。
 */
export function 创建红色扇形提示圈(
  x: number, y: number, fac: number, size: number, time: number, speed?: number, 来源单位?: any
): void {
  x += CosBJ(fac) * 10;
  y += SinBJ(fac) * 10;

  const e = AddSpecialEffect(MODEL_SECTOR, x, y);
  if (!e) return;

  按所属单位设置提示圈颜色(e, 来源单位);
  EXEffectMatRotateZ(e, fac);
  EXSetEffectSize(e, size);
  EXSetEffectSpeed(e, speed ?? 1.0);

  const duration = time <= 0 ? 0.5 : time + 0.05;
  安全销毁特效(duration, e);
}

/**
 * 创建一个需要手动销毁的红色扇形提示圈特效句柄。
 * `size = 1.0` 时，对应模型原始扇形尺寸：内侧约 32 半径，外侧约 512 半径。
 */
export function 创建红色扇形提示圈特效(
  x: number, y: number, fac: number, size: number, speed?: number, 来源单位?: any
): any {
  x += CosBJ(fac) * 10;
  y += SinBJ(fac) * 10;

  const e = AddSpecialEffect(MODEL_SECTOR, x, y);
  if (!e) return;

  按所属单位设置提示圈颜色(e, 来源单位);
  设置扇形提示圈朝向与尺寸(e, fac, size);
  EXSetEffectSpeed(e, speed ?? 1.0);
  return e;
}

/**
 * 更新扇形提示圈朝向与尺寸。
 * `size = 1.0` 时，对应模型原始扇形尺寸：内侧约 32 半径，外侧约 512 半径。
 */
export function 设置扇形提示圈朝向与尺寸(e: any, fac: number, size: number): void {
  EXEffectMatRotateZ(e, fac);
  EXSetEffectSize(e, size);
}

// ==========================================================================================
// 圆形提示圈
// ==========================================================================================

/**
 * 快速创建薄红色圆形提示圈
 * @param x X坐标
 * @param y Y坐标
 * @param r 半径
 * @param time 持续时间（<=0 表示1秒）
 * @param speed 动画速率（可选，默认 1/time）
 */
export function 创建薄圆形提示圈(
  x: number, y: number, r: number, time: number, speed?: number, 来源单位?: any
): void {
  const e = 创建薄圆形提示圈特效(x, y, r, speed, 来源单位);
  if (!e) return;
  const duration = time <= 0 ? 0.5 : time + 0.05;
  安全销毁特效(duration, e);
}

/**
 * 创建一个需要手动销毁的薄圆形提示圈特效句柄
 */
export function 创建薄圆形提示圈特效(
  x: number, y: number, r: number, speed?: number, 来源单位?: any
): any {
  const e = AddSpecialEffect(MODEL_RING, x, y);
  if (!e) return;

  设置提示圈半径(e, r);
  EXSetEffectSpeed(e, speed ?? 1.0);
  按所属单位设置提示圈颜色(e, 来源单位);
  return e;
}

/**
 * 按半径更新提示圈尺寸
 */
export function 设置提示圈半径(e: any, r: number): void {
  EXSetEffectSize(e, r / 178);
}

/**
 * 安全重播提示圈动画。
 * 优先按动画序号重播；仅当平台提供按名称播放接口且显式传入动画名时才按名称播放。
 */
export function 重播提示圈动画(e: any, 动画序号?: number, 动画名?: string): void {
  if (!e) return;

  if (typeof DzSetEffectAnimation === "function") {
    DzSetEffectAnimation(e, 动画序号 ?? 0, 0);
  }

  if (typeof DzPlayEffectAnimation === "function" && 动画名 != null && 动画名 !== "") {
    DzPlayEffectAnimation(e, 动画名, "");
  }
}

/**
 * 立即隐藏并销毁提示特效，避免模型自身尾动画继续可见
 */
export function 立即隐藏并销毁提示特效(e: any): void {
  if (!e) return;

  if (typeof DzSetEffectVertexAlpha === "function") {
    DzSetEffectVertexAlpha(e, 0);
  }
  EXSetEffectSize(e, 0.01);
  DestroyEffect(e);
}

/**
 * 兼容旧接口名，内部统一走通用销毁逻辑
 */
export function 立即销毁提示圈特效(e: any): void {
  立即隐藏并销毁提示特效(e);
}

/**
 * 快速创建厚红色圆形提示圈
 * @param x X坐标
 * @param y Y坐标
 * @param r 半径
 * @param time 持续时间（<=0 表示1秒）
 * @param speed 动画速率（可选，默认 1/time）
 */
export function 创建厚圆形提示圈(
  x: number, y: number, r: number, time: number, speed?: number, 来源单位?: any
): void {
  const e = AddSpecialEffect(MODEL_RING_THICK, x, y);
  if (!e) return;

  const size = r / 200;
  const s = speed ?? (time <= 0 ? 1 : 1 / time);
  const duration = time <= 0 ? 0.5 : time + 0.05;

  EXSetEffectSize(e, size);
  EXSetEffectSpeed(e, s);
  按所属单位设置提示圈颜色(e, 来源单位);
  安全销毁特效(duration, e);
}

/**
 * 快速创建白色圆形提示圈
 * 无来源时表示白色安全区域；传入来源单位时按阵营着色。
 */
export function 创建白色圆形提示圈(
  x: number, y: number, r: number, time: number, speed?: number, 来源单位?: any
): void {
  const e = AddSpecialEffect(MODEL_RING_A, x, y);
  if (!e) return;

  const size = r / 200;
  const duration = time <= 0 ? 0.5 : time + 0.05;

  DzSetEffectAnimation?.(e, 0, 0);
  EXSetEffectSize(e, size);
  EXSetEffectSpeed(e, speed ?? 1.0);
  按所属单位设置提示圈颜色(e, 来源单位, 提示圈友方色);
  安全销毁特效(duration, e);
}

/**
 * 快速创建渐变圆形提示圈（白→红）
 */
export function 创建渐变圆形提示圈(
  x: number, y: number, r: number, time: number, speed?: number, 来源单位?: any
): any {
  const e = AddSpecialEffect(MODEL_RING_B, x, y);
  if (!e) return;

  const size = r / 200;

  DzSetEffectAnimation?.(e, 1, 0);
  EXSetEffectSize(e, size);
  EXSetEffectSpeed(e, speed ?? 1.0);
  按所属单位设置提示圈颜色(e, 来源单位);

  let duration = time <= 0 ? 0.1 : time + 0.05;
  if (duration < 0.1) duration = 0.1;
  安全销毁特效(duration, e);

  return e;
}

/**
 * 快速创建双环圆形提示圈（内圈+外圈）
 * 适用于"内圈无伤害外圈有伤害"或"外圈有伤害内圈无伤害"的模式
 * 内圈:外圈 半径比例 ≈ 1:2
 *
 * @param x X坐标
 * @param y Y坐标
 * @param r 外圈半径（内圈自动按1:2比例缩小）
 * @param time 持续时间（<=0 表示1秒）
 * @param speed 动画速率（可选，默认 1）
 */
export function 创建双环提示圈(
  x: number, y: number, r: number, time: number, speed?: number, 来源单位?: any
): any {
  const e = AddSpecialEffect(MODEL_RING_C, x, y);
  if (!e) return;

  const size = r / 200;

  EXSetEffectSize(e, size);
  EXSetEffectSpeed(e, speed ?? 1.0);
  按所属单位设置提示圈颜色(e, 来源单位);

  const duration = time <= 0 ? 1 : time + 0.05;
  安全销毁特效(duration, e);

  return e;
}

export {};
