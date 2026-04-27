/** @noSelfInFile */
/**
 * 伤害显示系统 - 核心功能
 *
 * 功能：
 * 1. 显示伤害数字（图片形式）
 * 2. 数字逐位显示，向上飘动
 * 3. 根据伤害类型显示不同颜色
 *
 * 与JASS原版差异：
 * - 使用数组存储数据，不依赖YDLocal
 * - 使用中心计时器统一更新
 */

const jass = require("jass.common") as any;
const { ceil } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  ceil: (value: number) => number;
};

const {
  MIN_DAMAGE_THRESHOLD,
  DIGIT_IMAGE_PATH_TEMPLATE,
  DIGIT_BASE_SIZE,
  DIGIT_SPACING,
  INITIAL_OFFSET_BASE,
  DISPLAY_DURATION_TICKS,
  UPDATE_INTERVAL,
  RISE_SPEED,
  BASE_HEIGHT,
  DAMAGE_TYPE_COLORS,
  DEFAULT_COLOR,
} = require("系统.04．伤害系统.04．伤害显示.00．常量定义") as typeof import("./00．常量定义");

const { getObjectProperty } = require("lib.扩展函数.YDWE函数.index") as {
  getObjectProperty: (objectType: number, objectId: string | number, property: string) => string;
};

const 伤害函数 = require("lib.扩展函数.封装函数.06．伤害函数.index") as {
  isFireDamage: () => boolean;
  isWaterDamage: () => boolean;
  isThunderDamage: () => boolean;
  isMetalDamage: () => boolean;
  isLightDamage: () => boolean;
  isDarkDamage: () => boolean;
  isWoodDamage: () => boolean;
  isPhysicalDamage: () => boolean;
  isMagicDamage: () => boolean;
  isEnhancedDamage: () => boolean;
};

// ==========================================================================================
// 类型定义
// ==========================================================================================

/** 伤害数字显示数据 */
export interface DamageDigitData {
  image: any;
  x: number;
  y: number;
  tick: number;
}

// ==========================================================================================
// 数据存储
// ==========================================================================================

/** 活跃的伤害数字 */
const activeDigits: DamageDigitData[] = [];

/** 数字图片路径缓存（0-9） */
const digitImagePaths: string[] = [];

// ==========================================================================================
// 工具函数
// ==========================================================================================

/** 初始化数字图片路径 */
function initDigitImagePaths(this: void): void {
  if (digitImagePaths.length > 0) return;
  for (let i = 0; i <= 9; i++) {
    digitImagePaths[i] = DIGIT_IMAGE_PATH_TEMPLATE.replace("{digit}", String(i));
  }
}

/** 获取数字图片路径 */
function getDigitImagePath(this: void, digit: number): string {
  initDigitImagePaths();
  return digitImagePaths[digit] || digitImagePaths[0];
}

/** 获取单位模型缩放 */
function getUnitModelScale(this: void, unit: any): number {
  if (!unit) return 1.0;
  const unitType = jass.GetUnitTypeId(unit);
  if (!unitType) return 1.0;
  const scaleStr = getObjectProperty(2, unitType, "modelScale");
  const scale = parseFloat(scaleStr);
  return isNaN(scale) ? 1.0 : scale;
}

/** 计算数字位数 */
function getDigitCount(this: void, value: number): number {
  if (value < 10) return 1;
  if (value < 100) return 2;
  if (value < 1000) return 3;
  if (value < 10000) return 4;
  if (value < 100000) return 5;
  if (value < 1000000) return 6;
  if (value < 10000000) return 7;
  if (value < 100000000) return 8;
  if (value < 1000000000) return 9;
  return 10;
}

/** 获取伤害类型对应的颜色 */
function getDamageTypeColor(this: void): { red: number; green: number; blue: number } {
  // 使用封装好的判断函数，优先级从高到低
  if (伤害函数.isFireDamage()) return DAMAGE_TYPE_COLORS.FIRE;
  if (伤害函数.isWaterDamage()) return DAMAGE_TYPE_COLORS.COLD;
  if (伤害函数.isThunderDamage()) return DAMAGE_TYPE_COLORS.LIGHTNING;
  if (伤害函数.isMetalDamage()) return DAMAGE_TYPE_COLORS.POISON;
  if (伤害函数.isLightDamage()) return DAMAGE_TYPE_COLORS.DIVINE;
  if (伤害函数.isDarkDamage()) return DAMAGE_TYPE_COLORS.SHADOW;
  if (伤害函数.isWoodDamage()) return DAMAGE_TYPE_COLORS.PLANT;
  if (伤害函数.isPhysicalDamage()) return DAMAGE_TYPE_COLORS.NORMAL;
  if (伤害函数.isMagicDamage()) return DAMAGE_TYPE_COLORS.MAGIC;
  if (伤害函数.isEnhancedDamage()) return DAMAGE_TYPE_COLORS.ENHANCED;

  return DEFAULT_COLOR;
}

// ==========================================================================================
// 数字图片创建
// ==========================================================================================

/**
 * 创建单个数字图片
 */
function createDigitImage(
  this: void,
  digit: number,
  x: number,
  y: number,
  modelScale: number,
  color: { red: number; green: number; blue: number },
  unitFlyHeight: number
): any {
  const imagePath = getDigitImagePath(digit);
  const size = DIGIT_BASE_SIZE * modelScale;

  const image = jass.CreateImage(imagePath, size, size, size, x, y, 5.0, 0, 0, 0, 2);
  if (!image) return null;

  jass.SetImageColor(image, color.red, color.green, color.blue, 255);

  const height = (BASE_HEIGHT + unitFlyHeight) * modelScale;
  jass.SetImageConstantHeight(image, true, height);

  jass.SetImageRenderAlways(image, true);
  jass.SetImageType(image, 5);

  return image;
}

// ==========================================================================================
// 公开接口
// ==========================================================================================

/**
 * 显示伤害数字
 * @param target 目标单位
 * @param damage 伤害值
 */
export function showDamageNumber(this: void, target: any, damage: number): void {
  if (!target || damage < MIN_DAMAGE_THRESHOLD) return;

  const damageInt = jass.R2I(damage);
  const damageStr = String(damageInt);
  const digitCount = getDigitCount(damageInt);

  const x = jass.GetUnitX(target);
  const y = jass.GetUnitY(target);
  const flyHeight = jass.GetUnitFlyHeight(target);
  const modelScale = getUnitModelScale(target);

  const color = getDamageTypeColor();

  let offsetX = -INITIAL_OFFSET_BASE * digitCount;

  for (let i = 0; i < digitCount; i++) {
    const digit = parseInt(damageStr[i], 10);
    offsetX += DIGIT_SPACING;

    const image = createDigitImage(digit, x + offsetX, y, modelScale, color, flyHeight);
    if (image) {
      activeDigits.push({
        image,
        x: x + offsetX,
        y,
        tick: 0,
      });
    }
  }

  ensureRegisteredToCenterTimer();
}

/**
 * 更新所有伤害数字（由中心计时器调用）
 */
export function updateAllDamageDigits(this: void): void {
  for (let i = activeDigits.length - 1; i >= 0; i--) {
    const data = activeDigits[i];

    data.tick += 1;

    if (data.tick >= DISPLAY_DURATION_TICKS) {
      jass.DestroyImage(data.image);
      activeDigits.splice(i, 1);
      continue;
    }

    const newHeight = RISE_SPEED * data.tick;
    jass.SetImagePosition(data.image, data.x, data.y, newHeight);
  }
}

/**
 * 检查是否有活跃的伤害数字
 */
export function hasActiveDigits(this: void): boolean {
  return activeDigits.length > 0;
}

// ==========================================================================================
// 中心计时器集成
// ==========================================================================================

let _registeredToCenterTimer = false;
let _tickCounter = 0;
const CENTER_TIMER_TICKS = ceil(UPDATE_INTERVAL / 0.01);

function ensureRegisteredToCenterTimer(this: void): void {
  if (_registeredToCenterTimer) return;
  _registeredToCenterTimer = true;

const { onTick10ms } = globalThis as unknown as {
    onTick10ms: (callback: () => void) => void;
  };

  onTick10ms(() => {
    if (!hasActiveDigits()) return;

    _tickCounter = _tickCounter + 1;
    if (_tickCounter >= CENTER_TIMER_TICKS) {
      _tickCounter = 0;
      updateAllDamageDigits();
    }
  });
}
