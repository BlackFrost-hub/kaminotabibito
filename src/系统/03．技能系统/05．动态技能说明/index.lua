--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local preregistration = require("系统.03．技能系统.05．动态技能说明.03．英雄技能预注册")
local hoverHijack = require("系统.03．技能系统.05．动态技能说明.04．悬浮劫持")
local heroSkillRecord = require("系统.03．技能系统.05．动态技能说明.05．英雄技能记录")
local skillButtonHover = require("系统.03．技能系统.05．动态技能说明.06．技能按钮悬浮")
local _initialized = false
do
    local ____export = require("系统.03．技能系统.05．动态技能说明.01．核心功能")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.05．动态技能说明.05．英雄技能记录")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
function ____exports.init(self)
    if _initialized then
        return
    end
    _initialized = true
    preregistration.initHeroSkillPreregistration()
    skillButtonHover.initSkillButtonHover()
end
function ____exports.onPlayerHeroRegistered(whichPlayer, whichHero)
    if not whichPlayer or whichPlayer == 0 or not whichHero or whichHero == 0 then
        return
    end
    heroSkillRecord.registerHeroSkillRecordHero(whichHero)
    preregistration.onHeroRegisteredPreregistration(whichPlayer, whichHero)
    if type(hoverHijack.onPlayerHeroRegistered) == "function" then
        hoverHijack.onPlayerHeroRegistered(whichPlayer, whichHero)
    end
    if type(skillButtonHover.onPlayerHeroRegistered) == "function" then
        skillButtonHover.onPlayerHeroRegistered(whichPlayer, whichHero)
    end
end
return ____exports
