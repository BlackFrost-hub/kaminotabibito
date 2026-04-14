--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_58F0_97F3_6A21_578B = require("lib.扩展函数.封装函数.02．音效系统.01．声音模型")
local getSoundTypeByID = ____01_FF0E_58F0_97F3_6A21_578B.getSoundTypeByID
local ____02_FF0E_97F3_6548_6C60 = require("lib.扩展函数.封装函数.02．音效系统.02．音效池")
local getDefaultSoundModel = ____02_FF0E_97F3_6548_6C60.getDefaultSoundModel
--- 设置声音效果类型
-- 
-- @param id 1=战斗,2=战鼓,3=魔法,4=投射物,5=英雄语音,6=装饰物
function ____exports.Sound3DII_SetSoundTypeByID(self, id)
    getDefaultSoundModel(nil).soundType = getSoundTypeByID(nil, id)
end
--- 设置声音通道 (0-14)
function ____exports.Sound3DII_SetChannel(self, channel)
    if channel > 14 then
        channel = 0
    end
    getDefaultSoundModel(nil).channel = channel
end
--- 设置音量 (0-127)
function ____exports.Sound3DII_SetVolume(self, volume)
    if volume > 127 then
        volume = 127
    end
    if volume < 0 then
        volume = 0
    end
    getDefaultSoundModel(nil).volume = volume
end
--- 设置声音衰减距离
function ____exports.Sound3DII_SetDistances(self, min, max)
    getDefaultSoundModel(nil).sd:set(min, max)
end
--- 设置声音方向
function ____exports.Sound3DII_SetConeOrientation(self, x, y, z)
    getDefaultSoundModel(nil).sco:set(x, y, z)
end
--- 设置声音速度
function ____exports.Sound3DII_SetVelocity(self, x, y, z)
    getDefaultSoundModel(nil).sv:set(x, y, z)
end
--- 设置声音锥形角度
function ____exports.Sound3DII_SetConeAngle(self, inside, outside, volume)
    getDefaultSoundModel(nil).ca:set(inside, outside, volume)
end
--- 设置淡入速率
function ____exports.Sound3DII_SetFadeInRate(self, rate)
    getDefaultSoundModel(nil).fadeInRate = rate
end
--- 设置淡出速率
function ____exports.Sound3DII_SetFadeOutRate(self, rate)
    getDefaultSoundModel(nil).fadeOutRate = rate
end
--- 获取最后播放的音效
function ____exports.Sound3DII_GetLastPlayedSound(self)
    local ____require_result_0 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
    local lastPlayedSound = ____require_result_0.lastPlayedSound
    return lastPlayedSound
end
return ____exports
