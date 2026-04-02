--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local japi = require("jass.japi")
--- 初始化原生UI
-- 隐藏顶部菜单按钮图标
function ____exports.initNativeUI(self)
    local ydul_A = 0
    local JN = {}
    while ydul_A <= 0 do
        JN[ydul_A + 1] = japi.DzCreateFrameByTagName(
            "BACKDROP",
            "name",
            japi.DzGetGameUI(),
            "template",
            0
        )
        japi.DzFrameSetSize(JN[ydul_A + 1], 1 / 2400, 1 / 1800)
        japi.DzFrameSetPoint(
            JN[ydul_A + 1],
            0,
            japi.DzGetGameUI(),
            0,
            205.5 / 2400,
            -19.3 / 1800
        )
        JN[ydul_A + 4 + 1] = japi.DzFrameGetUpperButtonBarButton(ydul_A)
        japi.DzFrameClearAllPoints(JN[ydul_A + 4 + 1])
        japi.DzFrameSetSize(JN[ydul_A + 4 + 1], 1 / 2400, 1 / 1800)
        japi.DzFrameSetPoint(
            JN[ydul_A + 4 + 1],
            4,
            JN[ydul_A + 1],
            4,
            0,
            0
        )
        japi.DzFrameShow(JN[ydul_A + 4 + 1], true)
        ydul_A = ydul_A + 1
    end
    japi.DzFrameSetTexture(JN[1], "UI\\toumingtietu.tga", 0)
end
return ____exports
