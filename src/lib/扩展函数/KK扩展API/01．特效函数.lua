--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local japi = require("jass.japi")
--- 绑定特效到单位/物体挂点
function ____exports.DzBindEffect(self, parent, attachPoint, whichEffect)
    japi.DzBindEffect(parent, attachPoint, whichEffect)
    return true
end
--- 解除特效绑定
function ____exports.DzUnbindEffect(self, whichEffect)
    japi.DzUnbindEffect(whichEffect)
    return true
end
--- 设置特效缩放比例
-- 
-- @param whichEffect 特效句柄
-- @param scale 缩放比例
function ____exports.DzSetEffectScale(self, whichEffect, scale)
    japi.DzSetEffectScale(whichEffect, scale)
    return true
end
return ____exports
