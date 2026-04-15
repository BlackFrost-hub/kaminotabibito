--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.12．数学函数")
local PercentTo255 = ____require_result_0.PercentTo255
local ____jglobals_bj_lastCreatedImage_1 = jglobals.bj_lastCreatedImage
if ____jglobals_bj_lastCreatedImage_1 == nil then
    ____jglobals_bj_lastCreatedImage_1 = nil
end
____exports.bj_lastCreatedImage = ____jglobals_bj_lastCreatedImage_1
function ____exports.CreateImageBJ(self, file, size, where, zOffset, imageType)
    if type(jass.CreateImage) ~= "function" then
        return nil
    end
    if where == nil or where == 0 then
        return nil
    end
    local ____temp_2
    if type(jass.GetLocationX) == "function" then
        ____temp_2 = jass.GetLocationX(where)
    else
        ____temp_2 = 0
    end
    local x = ____temp_2
    local ____temp_3
    if type(jass.GetLocationY) == "function" then
        ____temp_3 = jass.GetLocationY(where)
    else
        ____temp_3 = 0
    end
    local y = ____temp_3
    ____exports.bj_lastCreatedImage = jass.CreateImage(
        file,
        size,
        size,
        size,
        x,
        y,
        zOffset,
        0,
        0,
        0,
        imageType
    )
    return ____exports.bj_lastCreatedImage
end
function ____exports.ShowImageBJ(self, flag, whichImage)
    if type(jass.ShowImage) ~= "function" then
        return
    end
    if whichImage == nil or whichImage == 0 then
        return
    end
    jass.ShowImage(whichImage, flag)
end
function ____exports.SetImagePositionBJ(self, whichImage, where, zOffset)
    if type(jass.SetImagePosition) ~= "function" then
        return
    end
    if whichImage == nil or whichImage == 0 then
        return
    end
    if where == nil or where == 0 then
        return
    end
    local ____temp_4
    if type(jass.GetLocationX) == "function" then
        ____temp_4 = jass.GetLocationX(where)
    else
        ____temp_4 = 0
    end
    local x = ____temp_4
    local ____temp_5
    if type(jass.GetLocationY) == "function" then
        ____temp_5 = jass.GetLocationY(where)
    else
        ____temp_5 = 0
    end
    local y = ____temp_5
    jass.SetImagePosition(whichImage, x, y, zOffset)
end
function ____exports.SetImageColorBJ(self, whichImage, red, green, blue, alpha)
    if type(jass.SetImageColor) ~= "function" then
        return
    end
    if whichImage == nil or whichImage == 0 then
        return
    end
    jass.SetImageColor(
        whichImage,
        PercentTo255(nil, red),
        PercentTo255(nil, green),
        PercentTo255(nil, blue),
        PercentTo255(nil, 100 - alpha)
    )
end
function ____exports.GetLastCreatedImage(self)
    return ____exports.bj_lastCreatedImage
end
return ____exports
