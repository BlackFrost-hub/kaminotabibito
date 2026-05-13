--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 漂浮文字 - 销毁与修改
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.05．泄露审计.index")
local LeakWatcher = ____require_result_0.LeakWatcher
local leakDestroyTextTag = LeakWatcher and type(LeakWatcher.destroyTextTag) == "function" and LeakWatcher.destroyTextTag or nil
--- 销毁漂浮文字
function ____exports.DestroyFloatText(textTag)
    if not textTag then
        return
    end
    jass.SetTextTagPermanent(textTag, false)
    jass.SetTextTagVisibility(textTag, false)
    jass.SetTextTagFadepoint(textTag, 0)
    jass.SetTextTagLifespan(textTag, 0.01)
    if leakDestroyTextTag ~= nil then
        leakDestroyTextTag(textTag)
    else
        jass.DestroyTextTag(textTag)
    end
end
--- 设置漂浮文字文字内容
function ____exports.SetFloatTextText(textTag, text)
    if textTag then
        jass.SetTextTagText(textTag, text, 0)
    end
end
--- 设置漂浮文字颜色
function ____exports.SetFloatTextColor(textTag, red, green, blue, alpha)
    if textTag then
        jass.SetTextTagColor(
            textTag,
            red,
            green,
            blue,
            alpha
        )
    end
end
--- 设置漂浮文字位置（固定坐标）
function ____exports.SetFloatTextPosition(textTag, x, y, height)
    if textTag then
        jass.SetTextTagPos(textTag, x, y, height)
    end
end
--- 设置漂浮文字速度
function ____exports.SetFloatTextVelocity(textTag, speedX, speedY)
    if textTag then
        jass.SetTextTagVelocity(textTag, speedX, speedY)
    end
end
return ____exports
