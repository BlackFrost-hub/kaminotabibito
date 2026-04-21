--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local japi = require("jass.japi")
--- 绑定特效到单位/物体挂点
function ____exports.DzBindEffect(self, parent, attachPoint, whichEffect)
    if type(japi.DzBindEffect) ~= "function" then
        return false
    end
    japi.DzBindEffect(parent, attachPoint, whichEffect)
    return true
end
--- 解除特效绑定
function ____exports.DzUnbindEffect(self, whichEffect)
    if type(japi.DzUnbindEffect) ~= "function" then
        return false
    end
    japi.DzUnbindEffect(whichEffect)
    return true
end
--- 设置特效缩放比例
-- 
-- @param whichEffect 特效句柄
-- @param scale 缩放比例
function ____exports.DzSetEffectScale(self, whichEffect, scale)
    if type(japi.DzSetEffectScale) ~= "function" then
        return false
    end
    japi.DzSetEffectScale(whichEffect, scale)
    return true
end
return ____exports
