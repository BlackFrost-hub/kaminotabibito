--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 铃仙 - 表现工具
-- 
-- 音效走 Sound3DII 单句柄复用；地图预载全局音效（gg_snd_LX_*）走 StartSound；
-- 动作走 SetUnitAnimationByIndex + SetUnitTimeScale。
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.02．音效系统.index")
local Sound3DII_CooPlayReuse = ____require_result_0.Sound3DII_CooPlayReuse
--- 播放坐标 3D 音效（单句柄复用，不扩池）
____exports["播放铃仙坐标音效"] = function(path, x, y, cutoff)
    if path == "" then
        return
    end
    Sound3DII_CooPlayReuse(
        path,
        x,
        y,
        0,
        cutoff
    )
end
--- 播放单位坐标 3D 音效
____exports["播放铃仙单位音效"] = function(unit, path, cutoff)
    if unit == nil or unit == 0 or path == "" then
        return
    end
    Sound3DII_CooPlayReuse(
        path,
        jass.GetUnitX(unit),
        jass.GetUnitY(unit),
        0,
        cutoff
    )
end
--- 播放地图预载全局音效（如 gg_snd_LX_Q2 等）；键不存在则静默跳过
____exports["播放铃仙全局音效"] = function(soundKey)
    if soundKey == "" then
        return
    end
    local sound = jglobals[soundKey]
    if sound == nil or sound == 0 then
        return
    end
    jass.StartSound(sound)
end
--- 按序号播放动作并设置时间缩放（timeScale <= 0 表示不修改时间缩放）
____exports["播放铃仙配置动作"] = function(unit, animationIndex, timeScale)
    if unit == nil or unit == 0 then
        return
    end
    if animationIndex >= 0 then
        jass.SetUnitAnimationByIndex(unit, animationIndex)
    end
    if timeScale > 0 then
        jass.SetUnitTimeScale(unit, timeScale)
    end
end
return ____exports
