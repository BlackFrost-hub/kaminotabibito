--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.KK扩展API.index")
local DzUnbindEffect = ____require_result_0.DzUnbindEffect
local DzSetEffectScale = ____require_result_0.DzSetEffectScale
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.index")
local createUnitEffect = ____require_result_1.createUnitEffect
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.index")
local withTimer = ____require_result_2.withTimer
local testEffect = nil
local function testDzUnbindEffect(self)
    local testUnit = g.gg_unit_Hamg_0002
    if not testUnit then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            5,
            "|cffff0000[DzUnbindEffect测试]|r 找不到单位 gg_unit_Hamg_0002"
        )
        return
    end
    local modelPath = "resource\\models\\qipao.mdx"
    testEffect = createUnitEffect(nil, testUnit, "overhead", modelPath)
    if not testEffect then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            5,
            "|cffff0000[DzUnbindEffect测试]|r 特效创建失败"
        )
        return
    end
    jass.DisplayTimedTextToPlayer(
        jass.Player(0),
        0,
        0,
        5,
        "|cff00ff00[DzUnbindEffect测试]|r 特效已绑定到单位，3秒后解除绑定并删除"
    )
    withTimer(
        nil,
        3,
        function()
            local unbindResult = DzUnbindEffect(nil, testEffect)
            jass.DisplayTimedTextToPlayer(
                jass.Player(0),
                0,
                0,
                5,
                "|cff00ff00[DzUnbindEffect测试]|r DzUnbindEffect 返回: " .. tostring(unbindResult)
            )
            local scaleResult = DzSetEffectScale(nil, testEffect, 0)
            jass.DisplayTimedTextToPlayer(
                jass.Player(0),
                0,
                0,
                5,
                "|cff00ff00[DzUnbindEffect测试]|r DzSetEffectScale(0) 返回: " .. tostring(scaleResult)
            )
            jass.DestroyEffect(testEffect)
            jass.DisplayTimedTextToPlayer(
                jass.Player(0),
                0,
                0,
                5,
                "|cff00ff00[DzUnbindEffect测试]|r 特效已删除"
            )
        end
    )
end
local function init(self)
    testDzUnbindEffect(nil)
end
init(nil)
return ____exports
