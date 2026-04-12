--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_6838_5FC3_7EDF_8BA1 = require("lib.扩展函数.封装函数.05．泄露审计.01．核心统计")
local track = ____01_FF0E_6838_5FC3_7EDF_8BA1.track
local untrack = ____01_FF0E_6838_5FC3_7EDF_8BA1.untrack
--- 泄露审计 - 音效
local jass = require("jass.common")
--- 创建音效：建议搭配 killSoundWhenDone 或 stopSoundAndKill 使用
function ____exports.createSound(self, tag, fileName, looping, is3D, stopwhenoutofrange, fadeInRate, fadeOutRate, eaxSetting)
    if type(jass.CreateSound) ~= "function" then
        return nil
    end
    local s = jass.CreateSound(
        fileName,
        looping,
        is3D,
        stopwhenoutofrange,
        fadeInRate,
        fadeOutRate,
        eaxSetting
    )
    track(nil, "sound", s, tag)
    return s
end
--- 标记音效播放完成后销毁，并在本审计中释放引用
function ____exports.killSoundWhenDone(self, s)
    if not s then
        return
    end
    if type(jass.KillSoundWhenDone) == "function" then
        jass.KillSoundWhenDone(s)
    end
    untrack(nil, "sound", s)
end
--- 仅取消 sound 的审计计数（句柄已由 KillSoundWhenDone/DestroySound 等处理时使用）。
-- 用于 `音效函数` 中「createSound + 非 killSoundWhenDone 分支」避免漏 untrack。
function ____exports.releaseSound(self, s)
    untrack(nil, "sound", s)
end
--- 立刻停止并销毁（更激进，适合需要马上释放时）
function ____exports.stopSoundAndKill(self, s, killWhenDone, fadeOut)
    if killWhenDone == nil then
        killWhenDone = true
    end
    if fadeOut == nil then
        fadeOut = false
    end
    if not s then
        return
    end
    if type(jass.StopSound) == "function" then
        jass.StopSound(s, killWhenDone, fadeOut)
    elseif type(jass.KillSoundWhenDone) == "function" then
        jass.KillSoundWhenDone(s)
    end
    untrack(nil, "sound", s)
end
return ____exports
