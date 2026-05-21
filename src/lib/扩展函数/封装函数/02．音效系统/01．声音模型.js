/**
 * 声音模型定义
 * 包含声音参数的类型定义
 */
/**
 * 声音衰减距离
 */
export class SoundDistances {
    minDis = 2500;
    maxDis = 2500;
    set(mindis, maxdis) {
        this.minDis = mindis;
        this.maxDis = maxdis;
    }
}
/**
 * 声音投射角
 */
export class SoundConeOrientation {
    x = 0;
    y = 0;
    z = 0;
    set(x, y, z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
}
/**
 * 声音速度
 */
export class SoundVelocity {
    x = 0;
    y = 0;
    z = 0;
    set(x, y, z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
}
/**
 * 声音锥形角度
 */
export class ConeAngles {
    inside = 0;
    outside = 0;
    volume = 127;
    set(inside, outside, volume) {
        this.inside = inside;
        this.outside = outside;
        this.volume = volume;
    }
}
/**
 * 声音模型 - 包含所有音效参数
 */
export class SoundModel {
    ca = new ConeAngles();
    channel = 0;
    pitch = 1.0;
    sv = new SoundVelocity();
    sco = new SoundConeOrientation();
    sd = new SoundDistances();
    volume = 127;
    soundType = "DefaultEAXON";
    fadeInRate = 10;
    fadeOutRate = 10;
    static create() {
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
    applyToSound(sound, x, y, z, cutoff) {
        const jass = require("jass.common");
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
export function getSoundTypeByID(id) {
    const types = {
        1: "CombatSoundsEAX",
        2: "KotoDrumsEAX",
        3: "SpellsEAX",
        4: "MissilesEAX",
        5: "HeroAcksEAX",
        6: "DoodadsEAX"
    };
    return types[id] || "DefaultEAXON";
}
