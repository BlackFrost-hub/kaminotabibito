// TS\系统\音效\Sound3DII.ts
/**
 * 3D音效系统 - 纯原生函数实现
 * 对应 JASS 的 Sound3DII 库，不使用任何 BJ 函数
 * 
 * 功能：
 * - 在单位位置播放3D音效
 * - 在坐标处播放3D音效
 * - 在点位置播放3D音效
 * - 播放MP3音效（可指定玩家）
 * - 音效参数控制（音量、距离、方向、速度等）
 * - 音效池管理（同一音效路径最多4个同时播放）
 */

const jass = require("jass.common") as any;
const hash = (jass as any).InitHashtable();

// 哈希表键值常量（childKey 勿与“是否可用”槽位重叠）
const KEY_COUNT = 1000;           // 音效计数
const KEY_INDEX = 1001;           // 当前索引
const KEY_TIMER = 1002;           // 计时器
const KEY_SOUND = 1003;           // 音效句柄
const KEY_PATH = 1004;            // 音效路径
const KEY_ENABLED = 1005;         // 是否可用
const KEY_ENABLED_SLOT_BASE = 2000; // 槽位是否可用：pathHash + (KEY_ENABLED_SLOT_BASE + index)

const POOL_MAX = 4; // 同一 path 最多同时播放数，与注释一致

const DEBUG_SOUND = false;

// 最后播放的音效（自定义替代 bj_lastPlayedSound）
export let lastPlayedSound: any = null;

// 默认音效模型（在 initSound3DII 中初始化，确保本模块 require 后先调用 init）
let defaultSoundModel: SoundModel;

/**
 * 声音衰减距离
 */
export class SoundDistances {
  minDis: number = 2500;
  maxDis: number = 2500;

  set(mindis: number, maxdis: number): void {
    this.minDis = mindis;
    this.maxDis = maxdis;
  }
}

/**
 * 声音投射角
 */
export class SoundConeOrientation {
  x: number = 0;
  y: number = 0;
  z: number = 0;

  set(x: number, y: number, z: number): void {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

/**
 * 声音速度
 */
export class SoundVelocity {
  x: number = 0;
  y: number = 0;
  z: number = 0;

  set(x: number, y: number, z: number): void {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

/**
 * 声音锥形角度
 */
export class ConeAngles {
  inside: number = 0;
  outside: number = 0;
  volume: number = 127;

  set(inside: number, outside: number, volume: number): void {
    this.inside = inside;
    this.outside = outside;
    this.volume = volume;
  }
}

/**
 * 声音模型 - 包含所有音效参数
 */
export class SoundModel {
  ca: ConeAngles = new ConeAngles();
  channel: number = 0;
  pitch: number = 1.0;
  sv: SoundVelocity = new SoundVelocity();
  sco: SoundConeOrientation = new SoundConeOrientation();
  sd: SoundDistances = new SoundDistances();
  volume: number = 127;
  soundType: string = "DefaultEAXON";
  fadeInRate: number = 10;
  fadeOutRate: number = 10;

  static create(): SoundModel {
    const model = new SoundModel();
    model.ca.set(0, 0, 127);
    model.sv.set(0, 0, 0);
    model.sco.set(0, 0, 0);
    model.sd.set(2500, 2500);
    return model;
  }

  /**
   * 应用声音参数到指定的音效对象
   */
  applyToSound(sound: any, x: number, y: number, z: number, cutoff: number): void {
    const j = jass as any;
    if (typeof j.SetSoundDistances === "function") (jass as any).SetSoundDistances(sound, this.sd.minDis, this.sd.maxDis);
    if (typeof j.SetSoundDistanceCutoff === "function") (jass as any).SetSoundDistanceCutoff(sound, cutoff);
    if (typeof j.SetSoundPosition === "function") (jass as any).SetSoundPosition(sound, x, y, z);
    if (typeof j.SetSoundChannel === "function") (jass as any).SetSoundChannel(sound, this.channel);
    if (typeof j.SetSoundVolume === "function") (jass as any).SetSoundVolume(sound, this.volume);
    if (typeof j.SetSoundPitch === "function") (jass as any).SetSoundPitch(sound, this.pitch);
    if (typeof j.SetSoundConeOrientation === "function") (jass as any).SetSoundConeOrientation(sound, this.sco.x, this.sco.y, this.sco.z);
    if (typeof j.SetSoundConeAngles === "function") (jass as any).SetSoundConeAngles(sound, this.ca.inside, this.ca.outside, this.ca.volume);
    if (typeof j.SetSoundVelocity === "function") (jass as any).SetSoundVelocity(sound, this.sv.x, this.sv.y, this.sv.z);
  }
}

/**
 * 获取声音类型字符串
 */
function getSoundTypeByID(id: number): string {
  const types: Record<number, string> = {
    1: "CombatSoundsEAX",
    2: "KotoDrumsEAX",
    3: "SpellsEAX",
    4: "MissilesEAX",
    5: "HeroAcksEAX",
    6: "DoodadsEAX"
  };
  return types[id] || "DefaultEAXON";
}

// ==================== 音效池管理 ====================

/**
 * 创建新音效（内部使用）
 */
function createSoundInternal(
  path: string,
  cutoff: number,
  index: number,
  x: number,
  y: number,
  z: number,
  is3d: boolean,
  model: SoundModel = defaultSoundModel
): any {
  const timer = (jass as any).CreateTimer();
  const sound = (jass as any).CreateSound(
    path,
    false,
    is3d,
    false,
    model.fadeInRate,
    model.fadeOutRate,
    model.soundType
  );

  if (!sound) return null;

  model.applyToSound(sound, x, y, z, cutoff);

  const pathHash = (jass as any).StringHash(path);
  (jass as any).SaveSoundHandle(hash, pathHash, index, sound);
  (jass as any).SaveTimerHandle(hash, (jass as any).GetHandleId(sound), KEY_TIMER, timer);
  (jass as any).SaveSoundHandle(hash, (jass as any).GetHandleId(timer), KEY_SOUND, sound);
  (jass as any).SaveBoolean(hash, pathHash, index + KEY_ENABLED_SLOT_BASE, false);
  (jass as any).SaveInteger(hash, (jass as any).GetHandleId(sound), KEY_INDEX, index);
  (jass as any).SaveStr(hash, (jass as any).GetHandleId(sound), KEY_PATH, path);

  let duration = (jass as any).GetSoundFileDuration(path) * 0.001;
  if (duration <= 0 || duration > 3600) duration = 1; // 1.27 部分 wav 返回 0，导致槽位永不释放
  (jass as any).TimerStart(timer, duration, false, () => {
    const expiredTimer = (jass as any).GetExpiredTimer();
    const s = (jass as any).LoadSoundHandle(hash, (jass as any).GetHandleId(expiredTimer), KEY_SOUND);
    if (s) {
      const idx = (jass as any).LoadInteger(hash, (jass as any).GetHandleId(s), KEY_INDEX);
      const p = (jass as any).LoadStr(hash, (jass as any).GetHandleId(s), KEY_PATH);
      const ph = (jass as any).StringHash(p);
      (jass as any).SaveBoolean(hash, ph, idx + KEY_ENABLED_SLOT_BASE, true);
    }
    (jass as any).DestroyTimer(expiredTimer);
  });

  return sound;
}

/**
 * 获取已存在的音效（内部使用）
 */
function getSoundInternal(
  path: string,
  cutoff: number,
  index: number,
  x: number,
  y: number,
  z: number,
  model: SoundModel = defaultSoundModel
): any {
  const pathHash = (jass as any).StringHash(path);
  const sound = (jass as any).LoadSoundHandle(hash, pathHash, index);

  if (!sound) return null;

  const timer = (jass as any).LoadTimerHandle(hash, (jass as any).GetHandleId(sound), KEY_TIMER);

  model.applyToSound(sound, x, y, z, cutoff);

  if (timer) {
    (jass as any).DestroyTimer(timer);
    const newTimer = (jass as any).CreateTimer();
    (jass as any).SaveTimerHandle(hash, (jass as any).GetHandleId(sound), KEY_TIMER, newTimer);
    (jass as any).SaveSoundHandle(hash, (jass as any).GetHandleId(newTimer), KEY_SOUND, sound);

    let duration = (jass as any).GetSoundFileDuration(path) * 0.001;
    if (duration <= 0 || duration > 3600) duration = 1;
    (jass as any).TimerStart(newTimer, duration, false, () => {
      const expiredTimer = (jass as any).GetExpiredTimer();
      const s = (jass as any).LoadSoundHandle(hash, (jass as any).GetHandleId(expiredTimer), KEY_SOUND);
      if (s) {
        const idx = (jass as any).LoadInteger(hash, (jass as any).GetHandleId(s), KEY_INDEX);
        const p = (jass as any).LoadStr(hash, (jass as any).GetHandleId(s), KEY_PATH);
        const ph = (jass as any).StringHash(p);
        (jass as any).SaveBoolean(hash, ph, idx + KEY_ENABLED_SLOT_BASE, true);
      }
      (jass as any).DestroyTimer(expiredTimer);
    });
  }

  // 标记为不可用
  (jass as any).SaveBoolean(hash, pathHash, index + KEY_ENABLED_SLOT_BASE, false);

  return sound;
}

// ==================== 公开 API ====================

/**
 * 在坐标处播放3D音效
 * @param path 音效路径
 * @param x X坐标
 * @param y Y坐标
 * @param z Z坐标
 * @param cutoff 裁断距离
 * @param model 声音模型（可选）
 * @returns 播放的音效句柄
 */
export function Sound3DII_CooPlay(
  path: string,
  x: number,
  y: number,
  z: number,
  cutoff: number,
  model: SoundModel = defaultSoundModel
): any {
  const pathHash = (jass as any).StringHash(path);
  let count = (jass as any).LoadInteger(hash, pathHash, KEY_COUNT) || 0;
  let index = (jass as any).LoadInteger(hash, pathHash, KEY_INDEX) || 0;
  if (count > POOL_MAX) count = POOL_MAX;
  const slot = index % POOL_MAX;

  let sound: any;
  if (slot >= count) {
    sound = createSoundInternal(path, cutoff, slot, x, y, z, true, model);
    if (sound) {
      (jass as any).SaveInteger(hash, pathHash, KEY_COUNT, count + 1 > POOL_MAX ? POOL_MAX : count + 1);
      (jass as any).SaveInteger(hash, pathHash, KEY_INDEX, index + 1);
    }
  } else {
    sound = getSoundInternal(path, cutoff, slot, x, y, z, model);
    if (sound) (jass as any).SaveInteger(hash, pathHash, KEY_INDEX, index + 1);
  }

  if (sound) {
    (jass as any).StartSound(sound);
    lastPlayedSound = sound;
  }
  return sound;
}

/**
 * 在单位位置播放3D音效
 * @param path 音效路径
 * @param unit 目标单位
 * @param cutoff 裁断距离
 * @param model 声音模型（可选）
 */
export function Sound3DII_UnitPlay(
  path: string,
  unit: any,
  cutoff: number,
  model?: SoundModel
): any {
  const x = (jass as any).GetUnitX(unit);
  const y = (jass as any).GetUnitY(unit);
  const z = (jass as any).GetUnitFlyHeight(unit);
  return Sound3DII_CooPlay(path, x, y, z, cutoff, model);
}

/**
 * 在点位置播放3D音效
 * @param path 音效路径
 * @param loc 位置
 * @param cutoff 裁断距离
 * @param model 声音模型（可选）
 */
export function Sound3DII_LocPlay(
  path: string,
  loc: any,
  cutoff: number,
  model?: SoundModel
): any {
  const x = (jass as any).GetLocationX(loc);
  const y = (jass as any).GetLocationY(loc);
  const z = (jass as any).GetLocationZ(loc);
  return Sound3DII_CooPlay(path, x, y, z, cutoff, model);
}

/**
 * 无 KillSoundWhenDone 时的兜底：定时 DestroySound，避免 CreateSound 句柄堆积（极少见环境）。
 */
function scheduleDestroySoundIfNeeded(sound: any): void {
  if (!sound) return;
  if (typeof (jass as any).DestroySound !== "function" || typeof (jass as any).TimerStart !== "function") return;
  const Leak = require("系统.00．核心系统.泄露审计") as { LeakWatcher?: any };
  const LW = Leak && Leak.LeakWatcher ? Leak.LeakWatcher : undefined;
  const t =
    LW && typeof LW.createTimer === "function"
      ? LW.createTimer("sound_ui_fallback_destroy")
      : typeof (jass as any).CreateTimer === "function"
        ? (jass as any).CreateTimer()
        : null;
  if (!t) return;
  (jass as any).TimerStart(t, 0.55, false, () => {
    const expired = (jass as any).GetExpiredTimer();
    (jass as any).DestroySound(sound);
    if (LW && typeof LW.destroyTimer === "function") {
      LW.destroyTimer(expired);
    } else if (typeof (jass as any).DestroyTimer === "function") {
      (jass as any).DestroyTimer(expired);
    }
  });
}

/**
 * 播放MP3音效（可指定玩家）
 * @param path 音效路径
 * @param player 指定玩家（为null时所有玩家都能听到）
 * @param model 声音模型（可选）
 */
export function Sound3DII_Mp3Play(
  path: string,
  player: any = null,
  model: SoundModel = defaultSoundModel
): any {
  // 1.27 下 UI 音效频繁播放容易触发“池/通道限制”。这里改为：每次新建 sound，并 KillSoundWhenDone（或兜底 DestroySound），
  // 不依赖 GetSoundFileDuration/计时器/池复用，确保持续多次触发也能响。
  if (typeof (jass as any).CreateSound === "function" && typeof (jass as any).StartSound === "function") {
    const Leak = require("系统.00．核心系统.泄露审计") as { LeakWatcher?: any };
    const LW = Leak && Leak.LeakWatcher ? Leak.LeakWatcher : undefined;
    let trackedByLeak = false;
    let s: any = null;
    if (LW && typeof LW.createSound === "function") {
      s = LW.createSound(
        "sound_mp3",
        path,
        false,
        false,
        false,
        model.fadeInRate,
        model.fadeOutRate,
        model.soundType
      );
      if (s) trackedByLeak = true;
    } else {
      s = (jass as any).CreateSound(
        path,
        false,
        false,
        false,
        model.fadeInRate,
        model.fadeOutRate,
        model.soundType
      );
    }
    if (s) {
      // 应用部分参数（非 3D）
      if (typeof (jass as any).SetSoundChannel === "function") (jass as any).SetSoundChannel(s, model.channel);
      if (typeof (jass as any).SetSoundVolume === "function") (jass as any).SetSoundVolume(s, model.volume);
      if (typeof (jass as any).SetSoundPitch === "function") (jass as any).SetSoundPitch(s, model.pitch);

      const shouldPlay =
        !player ||
        (typeof (jass as any).GetLocalPlayer === "function" && (jass as any).GetLocalPlayer() === player);
      if (shouldPlay) (jass as any).StartSound(s);

      // 无论是否本地播放，都标记为“播完销毁”，避免句柄堆积
      // 经 LeakWatcher.createSound 的必须在审计里 untrack；仅走 killSoundWhenDone 一条链最稳
      if (LW && typeof LW.killSoundWhenDone === "function") {
        LW.killSoundWhenDone(s);
      } else if (typeof (jass as any).KillSoundWhenDone === "function") {
        (jass as any).KillSoundWhenDone(s);
        if (trackedByLeak && LW && typeof LW.releaseSound === "function") {
          LW.releaseSound(s);
        }
      } else {
        scheduleDestroySoundIfNeeded(s);
        if (trackedByLeak && LW && typeof LW.releaseSound === "function") {
          LW.releaseSound(s);
        }
      }

      lastPlayedSound = s;
      if (DEBUG_SOUND && (globalThis as any).print) (globalThis as any).print("[Sound3DII_Mp3Play] new sound, localPlay=", shouldPlay);
      return s;
    }
  }

  const pathHash = (jass as any).StringHash(path);
  let count = (jass as any).LoadInteger(hash, pathHash, KEY_COUNT) || 0;
  if (count > POOL_MAX) count = POOL_MAX;

  let availableIndex = -1;
  for (let i = 0; i < count; i++) {
    if ((jass as any).LoadBoolean(hash, pathHash, i + KEY_ENABLED_SLOT_BASE)) {
      availableIndex = i;
      break;
    }
  }

  let sound: any;
  if (availableIndex === -1) {
    if (count >= POOL_MAX) return null;
    sound = createSoundInternal(path, 4000, count, 0, 0, 0, false, model);
    if (sound) (jass as any).SaveInteger(hash, pathHash, KEY_COUNT, count + 1);
  } else {
    sound = getSoundInternal(path, 4000, availableIndex, 0, 0, 0, model);
  }

  if (sound) {
    if (player) {
      if ((jass as any).GetLocalPlayer() === player) (jass as any).StartSound(sound);
    } else {
      (jass as any).StartSound(sound);
    }
    lastPlayedSound = sound;
  }
  
  return sound;
}

// ==================== UI 音效统一封装 ====================
// 默认按钮点击音效：与魔兽原生 UI 保持一致
export const DEFAULT_UI_CLICK_SOUND = "Sound\\Interface\\BigButtonClick.wav";

/** 每 path 一个常驻句柄（不经 LeakWatcher）；高频重复同一 wav 用此路径，不每遍 CreateSound（dbg 不会每遍 +snd） */
const soundReuseByPath: Record<string, any> = {};
/** 该 path 是否已成功 StartSound 过；首击前勿 StopSound，否则 1.27 下易出现首击无声 */
const soundReuseHadStartedByPath: Record<string, boolean> = {};

function getOrCreateReuseSound(path: string): any {
  const cache = soundReuseByPath as any;
  const hit = cache[path];
  if (hit) return hit;
  if (typeof (jass as any).CreateSound !== "function") return null;
  const m = defaultSoundModel;
  const s = (jass as any).CreateSound(
    path,
    false,
    false,
    false,
    m.fadeInRate,
    m.fadeOutRate,
    m.soundType
  );
  if (s) cache[path] = s;
  return s;
}

/**
 * 地图加载时预创建默认 UI 点击句柄，首击即可 StartSound（仍走「无 Stop」首击分支）。
 * 不播放、不占通道；仅 CreateSound。
 */
export function prewarmUiClickSound(path: string = DEFAULT_UI_CLICK_SOUND): void {
  getOrCreateReuseSound(path);
}

/**
 * 同一路径重复播放（UI 点击、1 秒内多连同一 wav）：**单句柄** + Stop+Start，不每遍 CreateSound + KillSoundWhenDone。
 * dbg 常驻 +1/path（非每遍 +1）；与 `Sound3DII_Mp3Play` 按次创建二选一。
 */
export function Sound3DII_Mp3PlayReuse(
  path: string,
  player: any = null,
  model: SoundModel = defaultSoundModel
): void {
  const p = player === 0 ? null : player;
  const s = getOrCreateReuseSound(path);
  if (!s) return;
  if (typeof (jass as any).SetSoundChannel === "function") (jass as any).SetSoundChannel(s, model.channel);
  if (typeof (jass as any).SetSoundVolume === "function") (jass as any).SetSoundVolume(s, model.volume);
  if (typeof (jass as any).SetSoundPitch === "function") (jass as any).SetSoundPitch(s, model.pitch);
  const shouldPlay =
    !p ||
    (typeof (jass as any).GetLocalPlayer === "function" && (jass as any).GetLocalPlayer() === p);
  if (shouldPlay) {
    const started = soundReuseHadStartedByPath as any;
    if (started[path]) {
      if (typeof (jass as any).StopSound === "function") {
        (jass as any).StopSound(s, false, false);
      }
    } else {
      started[path] = true;
    }
    (jass as any).StartSound(s);
  }
  lastPlayedSound = s;
}

/**
 * UI 键盘/点击的统一音效入口。
 * - 默认对所有玩家都能听到（whichPlayer 传 null）。
 * - 内部走 `Sound3DII_Mp3PlayReuse`（常驻 +1/path）。
 */
export function SoundUI_ClickPlay(soundPath: string = DEFAULT_UI_CLICK_SOUND, whichPlayer: any = null): void {
  const p = whichPlayer === 0 ? null : whichPlayer;
  Sound3DII_Mp3PlayReuse(soundPath, p);
}

// ==================== 参数设置函数 ====================

/**
 * 设置声音效果类型
 * @param id 1=战斗,2=战鼓,3=魔法,4=投射物,5=英雄语音,6=装饰物
 */
export function Sound3DII_SetSoundTypeByID(id: number): void {
  defaultSoundModel.soundType = getSoundTypeByID(id);
}

/**
 * 设置声音通道 (0-14)
 */
export function Sound3DII_SetChannel(channel: number): void {
  if (channel > 14) channel = 0;
  defaultSoundModel.channel = channel;
}

/**
 * 设置音量 (0-127)
 */
export function Sound3DII_SetVolume(volume: number): void {
  if (volume > 127) volume = 127;
  if (volume < 0) volume = 0;
  defaultSoundModel.volume = volume;
}

/**
 * 设置声音衰减距离
 */
export function Sound3DII_SetDistances(min: number, max: number): void {
  defaultSoundModel.sd.set(min, max);
}

/**
 * 设置声音方向
 */
export function Sound3DII_SetConeOrientation(x: number, y: number, z: number): void {
  defaultSoundModel.sco.set(x, y, z);
}

/**
 * 设置声音速度
 */
export function Sound3DII_SetVelocity(x: number, y: number, z: number): void {
  defaultSoundModel.sv.set(x, y, z);
}

/**
 * 设置声音锥形角度
 */
export function Sound3DII_SetConeAngle(inside: number, outside: number, volume: number): void {
  defaultSoundModel.ca.set(inside, outside, volume);
}

/**
 * 设置淡入速率
 */
export function Sound3DII_SetFadeInRate(rate: number): void {
  defaultSoundModel.fadeInRate = rate;
}

/**
 * 设置淡出速率
 */
export function Sound3DII_SetFadeOutRate(rate: number): void {
  defaultSoundModel.fadeOutRate = rate;
}

/**
 * 获取最后播放的音效
 */
export function Sound3DII_GetLastPlayedSound(): any {
  return lastPlayedSound;
}

// ==================== 初始化 ====================

/**
 * 初始化音效系统
 */
export function initSound3DII(): void {
  defaultSoundModel = SoundModel.create();
  prewarmUiClickSound(DEFAULT_UI_CLICK_SOUND);
}

// 自动初始化
initSound3DII();