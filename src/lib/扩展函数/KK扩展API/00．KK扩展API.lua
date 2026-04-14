--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local japi = require("jass.japi")
--- 创建装饰物
function ____exports.DzDoodadCreate(self, id, varId, x, y, z, rotate, scale)
    if type(japi.DzDoodadCreate) ~= "function" then
        return 0
    end
    return japi.DzDoodadCreate(
        id,
        varId,
        x,
        y,
        z,
        rotate,
        scale
    ) or 0
end
--- 获取装饰物类型ID
function ____exports.DzDoodadGetTypeId(self, doodad)
    if type(japi.DzDoodadGetTypeId) ~= "function" then
        return 0
    end
    return japi.DzDoodadGetTypeId(doodad) or 0
end
--- 设置装饰物模型
function ____exports.DzDoodadSetModel(self, doodad, modelFile)
    if type(japi.DzDoodadSetModel) ~= "function" then
        return
    end
    japi.DzDoodadSetModel(doodad, modelFile)
end
--- 设置装饰物队伍颜色
function ____exports.DzDoodadSetTeamColor(self, doodad, color)
    if type(japi.DzDoodadSetTeamColor) ~= "function" then
        return
    end
    japi.DzDoodadSetTeamColor(doodad, color)
end
--- 设置装饰物颜色
function ____exports.DzDoodadSetColor(self, doodad, color)
    if type(japi.DzDoodadSetColor) ~= "function" then
        return
    end
    japi.DzDoodadSetColor(doodad, color)
end
--- 获取装饰物X坐标
function ____exports.DzDoodadGetX(self, doodad)
    if type(japi.DzDoodadGetX) ~= "function" then
        return 0
    end
    return japi.DzDoodadGetX(doodad) or 0
end
--- 获取装饰物Y坐标
function ____exports.DzDoodadGetY(self, doodad)
    if type(japi.DzDoodadGetY) ~= "function" then
        return 0
    end
    return japi.DzDoodadGetY(doodad) or 0
end
--- 获取装饰物Z坐标
function ____exports.DzDoodadGetZ(self, doodad)
    if type(japi.DzDoodadGetZ) ~= "function" then
        return 0
    end
    return japi.DzDoodadGetZ(doodad) or 0
end
--- 设置装饰物位置
function ____exports.DzDoodadSetPosition(self, doodad, x, y, z)
    if type(japi.DzDoodadSetPosition) ~= "function" then
        return
    end
    japi.DzDoodadSetPosition(doodad, x, y, z)
end
--- 设置装饰物方向矩阵旋转
function ____exports.DzDoodadSetOrientMatrixRotate(self, doodad, angle, axisX, axisY, axisZ)
    if type(japi.DzDoodadSetOrientMatrixRotate) ~= "function" then
        return
    end
    japi.DzDoodadSetOrientMatrixRotate(
        doodad,
        angle,
        axisX,
        axisY,
        axisZ
    )
end
--- 设置装饰物方向矩阵缩放
function ____exports.DzDoodadSetOrientMatrixScale(self, doodad, x, y, z)
    if type(japi.DzDoodadSetOrientMatrixScale) ~= "function" then
        return
    end
    japi.DzDoodadSetOrientMatrixScale(doodad, x, y, z)
end
--- 设置装饰物方向矩阵重置大小
function ____exports.DzDoodadSetOrientMatrixResize(self, doodad)
    if type(japi.DzDoodadSetOrientMatrixResize) ~= "function" then
        return
    end
    japi.DzDoodadSetOrientMatrixResize(doodad)
end
--- 设置装饰物可见性
function ____exports.DzDoodadSetVisible(self, doodad, enable)
    if type(japi.DzDoodadSetVisible) ~= "function" then
        return
    end
    japi.DzDoodadSetVisible(doodad, enable)
end
--- 设置装饰物动画
function ____exports.DzDoodadSetAnimation(self, doodad, animName, animRandom)
    if type(japi.DzDoodadSetAnimation) ~= "function" then
        return
    end
    japi.DzDoodadSetAnimation(doodad, animName, animRandom)
end
--- 设置装饰物时间缩放
function ____exports.DzDoodadSetTimeScale(self, doodad, scale)
    if type(japi.DzDoodadSetTimeScale) ~= "function" then
        return
    end
    japi.DzDoodadSetTimeScale(doodad, scale)
end
--- 获取装饰物时间缩放
function ____exports.DzDoodadGetTimeScale(self, doodad)
    if type(japi.DzDoodadGetTimeScale) ~= "function" then
        return 0
    end
    return japi.DzDoodadGetTimeScale(doodad) or 0
end
--- 获取装饰物当前动画索引
function ____exports.DzDoodadGetCurrentAnimationIndex(self, doodad)
    if type(japi.DzDoodadGetCurrentAnimationIndex) ~= "function" then
        return 0
    end
    return japi.DzDoodadGetCurrentAnimationIndex(doodad) or 0
end
--- 获取装饰物动画数量
function ____exports.DzDoodadGetAnimationCount(self, doodad)
    if type(japi.DzDoodadGetAnimationCount) ~= "function" then
        return 0
    end
    return japi.DzDoodadGetAnimationCount(doodad) or 0
end
--- 获取装饰物动画名称
function ____exports.DzDoodadGetAnimationName(self, doodad, index)
    if type(japi.DzDoodadGetAnimationName) ~= "function" then
        return ""
    end
    return japi.DzDoodadGetAnimationName(doodad, index) or ""
end
--- 获取装饰物动画时间
function ____exports.DzDoodadGetAnimationTime(self, doodad, index)
    if type(japi.DzDoodadGetAnimationTime) ~= "function" then
        return 0
    end
    return japi.DzDoodadGetAnimationTime(doodad, index) or 0
end
--- 绑定特效到单位/物体挂点
function ____exports.DzBindEffect(self, parent, attachPoint, whichEffect)
    if type(japi.DzBindEffect) == "function" then
        japi.DzBindEffect(parent, attachPoint, whichEffect)
        return true
    end
    if type(_G.DzBindEffect) == "function" then
        _G.DzBindEffect(parent, attachPoint, whichEffect)
        return true
    end
    return false
end
--- 解除特效绑定
function ____exports.DzUnbindEffect(self, whichEffect)
    if type(japi.DzUnbindEffect) == "function" then
        japi.DzUnbindEffect(whichEffect)
        return true
    end
    if type(_G.DzUnbindEffect) == "function" then
        _G.DzUnbindEffect(whichEffect)
        return true
    end
    return false
end
--- 设置特效缩放比例
-- 
-- @param whichEffect 特效句柄
-- @param scale 缩放比例
function ____exports.DzSetEffectScale(self, whichEffect, scale)
    if type(japi.DzSetEffectScale) == "function" then
        japi.DzSetEffectScale(whichEffect, scale)
        return true
    end
    if type(_G.DzSetEffectScale) == "function" then
        _G:DzSetEffectScale(whichEffect, scale)
        return true
    end
    return false
end
return ____exports
