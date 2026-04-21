/**
 * 声音模型定义
 * 包含声音参数的类型定义
 */

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
    const jass = require("jass.common") as any;
    jass.SetSoundDistances(sound, this.sd.minDis, this.sd.maxDis);
    jass.SetSoundDistanceCutoff(sound, cutoff);
    jass.SetSoundPosition(sound, x, y, z);
    jass.SetSoundChannel(sound, this.channel);
    jass.SetSoundVolume(sound, this.volume);
    jass.SetSoundPitch(sound, this.pitch);
    jass.SetSoundConeOrientation(sound, this.sco.x, this.sco.y, this.sco.z);
    jass.SetSoundConeAngles(sound, this.ca.inside, this.ca.outside, this.ca.volume);
    jass.SetSoundVelocity(sound, this.sv.x, this.sv.y, this.sv.z);
  }
}

/**
 * 获取声音类型字符串
 */
export function getSoundTypeByID(id: number): string {
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
