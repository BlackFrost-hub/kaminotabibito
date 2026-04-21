local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
--- 声音衰减距离
____exports.SoundDistances = __TS__Class()
local SoundDistances = ____exports.SoundDistances
SoundDistances.name = "SoundDistances"
function SoundDistances.prototype.____constructor(self)
    self.minDis = 2500
    self.maxDis = 2500
end
function SoundDistances.prototype.set(self, mindis, maxdis)
    self.minDis = mindis
    self.maxDis = maxdis
end
--- 声音投射角
____exports.SoundConeOrientation = __TS__Class()
local SoundConeOrientation = ____exports.SoundConeOrientation
SoundConeOrientation.name = "SoundConeOrientation"
function SoundConeOrientation.prototype.____constructor(self)
    self.x = 0
    self.y = 0
    self.z = 0
end
function SoundConeOrientation.prototype.set(self, x, y, z)
    self.x = x
    self.y = y
    self.z = z
end
--- 声音速度
____exports.SoundVelocity = __TS__Class()
local SoundVelocity = ____exports.SoundVelocity
SoundVelocity.name = "SoundVelocity"
function SoundVelocity.prototype.____constructor(self)
    self.x = 0
    self.y = 0
    self.z = 0
end
function SoundVelocity.prototype.set(self, x, y, z)
    self.x = x
    self.y = y
    self.z = z
end
--- 声音锥形角度
____exports.ConeAngles = __TS__Class()
local ConeAngles = ____exports.ConeAngles
ConeAngles.name = "ConeAngles"
function ConeAngles.prototype.____constructor(self)
    self.inside = 0
    self.outside = 0
    self.volume = 127
end
function ConeAngles.prototype.set(self, inside, outside, volume)
    self.inside = inside
    self.outside = outside
    self.volume = volume
end
--- 声音模型 - 包含所有音效参数
____exports.SoundModel = __TS__Class()
local SoundModel = ____exports.SoundModel
SoundModel.name = "SoundModel"
function SoundModel.prototype.____constructor(self)
    self.ca = __TS__New(____exports.ConeAngles)
    self.channel = 0
    self.pitch = 1
    self.sv = __TS__New(____exports.SoundVelocity)
    self.sco = __TS__New(____exports.SoundConeOrientation)
    self.sd = __TS__New(____exports.SoundDistances)
    self.volume = 127
    self.soundType = "DefaultEAXON"
    self.fadeInRate = 10
    self.fadeOutRate = 10
end
function SoundModel.create(self)
    local model = __TS__New(____exports.SoundModel)
    model.ca:set(0, 0, 127)
    model.sv:set(0, 0, 0)
    model.sco:set(0, 0, 0)
    model.sd:set(2500, 2500)
    return model
end
function SoundModel.prototype.applyToSound(self, sound, x, y, z, cutoff)
    local jass = require("jass.common")
    jass.SetSoundDistances(sound, self.sd.minDis, self.sd.maxDis)
    jass.SetSoundDistanceCutoff(sound, cutoff)
    jass.SetSoundPosition(sound, x, y, z)
    jass.SetSoundChannel(sound, self.channel)
    jass.SetSoundVolume(sound, self.volume)
    jass.SetSoundPitch(sound, self.pitch)
    jass.SetSoundConeOrientation(sound, self.sco.x, self.sco.y, self.sco.z)
    jass.SetSoundConeAngles(sound, self.ca.inside, self.ca.outside, self.ca.volume)
    jass.SetSoundVelocity(sound, self.sv.x, self.sv.y, self.sv.z)
end
--- 获取声音类型字符串
function ____exports.getSoundTypeByID(self, id)
    local types = {
        [1] = "CombatSoundsEAX",
        [2] = "KotoDrumsEAX",
        [3] = "SpellsEAX",
        [4] = "MissilesEAX",
        [5] = "HeroAcksEAX",
        [6] = "DoodadsEAX"
    }
    return types[id] or "DefaultEAXON"
end
return ____exports
