--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_97F3_6548_6C60 = require("lib.扩展函数.封装函数.02．音效系统.02．音效池")
local getDefaultSoundModel = ____02_FF0E_97F3_6548_6C60.getDefaultSoundModel
local ____03_FF0E3D_97F3_6548_64AD_653E = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local lastPlayedSound = ____03_FF0E3D_97F3_6548_64AD_653E.lastPlayedSound
--- UI音效
-- 按钮点击、键盘等UI音效
local jass = require("jass.common")
____exports.DEFAULT_UI_CLICK_SOUND = "Sound\\Interface\\BigButtonClick.wav"
--- 每 path 一个常驻句柄
local soundReuseByPath = {}
--- 该 path 是否已成功 StartSound 过
local soundReuseHadStartedByPath = {}
local function getOrCreateReuseSound(self, path)
    local cache = soundReuseByPath
    local hit = cache[path]
    if hit then
        return hit
    end
    local m = getDefaultSoundModel()
    local s = jass.CreateSound(
        path,
        false,
        false,
        false,
        m.fadeInRate,
        m.fadeOutRate,
        m.soundType
    )
    if s then
        cache[path] = s
    end
    return s
end
--- 地图加载时预创建默认 UI 点击句柄
function ____exports.prewarmUiClickSound(self, path)
    if path == nil then
        path = ____exports.DEFAULT_UI_CLICK_SOUND
    end
    getOrCreateReuseSound(nil, path)
end
--- 同一路径重复播放（UI 点击、1 秒内多连同一 wav）
function ____exports.Sound3DII_Mp3PlayReuse(self, path, player, model)
    if model == nil then
        model = getDefaultSoundModel()
    end
    local ____temp_0
    if player == 0 then
        ____temp_0 = nil
    else
        ____temp_0 = player
    end
    local p = ____temp_0
    local s = getOrCreateReuseSound(nil, path)
    if not s then
        return
    end
    jass.SetSoundChannel(s, model.channel)
    jass.SetSoundVolume(s, model.volume)
    jass.SetSoundPitch(s, model.pitch)
    local shouldPlay = not p or jass.GetLocalPlayer() == p
    if shouldPlay then
        local started = soundReuseHadStartedByPath
        if started[path] then
            jass.StopSound(s, false, false)
        else
            started[path] = true
        end
        jass.StartSound(s)
    end
    lastPlayedSound = s
end
--- UI 键盘/点击的统一音效入口
function ____exports.SoundUI_ClickPlay(self, soundPath, whichPlayer)
    if soundPath == nil then
        soundPath = ____exports.DEFAULT_UI_CLICK_SOUND
    end
    local ____temp_1
    if whichPlayer == 0 then
        ____temp_1 = nil
    else
        ____temp_1 = whichPlayer
    end
    local p = ____temp_1
    ____exports.Sound3DII_Mp3PlayReuse(nil, soundPath, p)
end
return ____exports
