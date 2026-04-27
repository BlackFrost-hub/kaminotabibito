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
    if where == nil or where == 0 then
        return nil
    end
    local x = jass:GetLocationX(where)
    local y = jass:GetLocationY(where)
    ____exports.bj_lastCreatedImage = jass:CreateImage(
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
    if whichImage == nil or whichImage == 0 then
        return
    end
    jass:ShowImage(whichImage, flag)
end
function ____exports.SetImagePositionBJ(self, whichImage, where, zOffset)
    if whichImage == nil or whichImage == 0 then
        return
    end
    if where == nil or where == 0 then
        return
    end
    local x = jass:GetLocationX(where)
    local y = jass:GetLocationY(where)
    jass:SetImagePosition(whichImage, x, y, zOffset)
end
function ____exports.SetImageColorBJ(self, whichImage, red, green, blue, alpha)
    if whichImage == nil or whichImage == 0 then
        return
    end
    jass:SetImageColor(
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
