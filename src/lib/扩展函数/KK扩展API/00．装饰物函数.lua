--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- KK扩展API - 装饰物相关函数
-- 
-- 注意：这些函数只有KK平台才有，其他平台（如YDWE、WE）不支持
local japi = require("jass.japi")
--- 创建装饰物
function ____exports.DzDoodadCreate(self, id, varId, x, y, z, rotate, scale)
    return japi:DzDoodadCreate(
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
    return japi:DzDoodadGetTypeId(doodad) or 0
end
--- 设置装饰物模型
function ____exports.DzDoodadSetModel(self, doodad, modelFile)
    japi:DzDoodadSetModel(doodad, modelFile)
end
--- 设置装饰物队伍颜色
function ____exports.DzDoodadSetTeamColor(self, doodad, color)
    japi:DzDoodadSetTeamColor(doodad, color)
end
--- 设置装饰物颜色
function ____exports.DzDoodadSetColor(self, doodad, color)
    japi:DzDoodadSetColor(doodad, color)
end
--- 获取装饰物X坐标
function ____exports.DzDoodadGetX(self, doodad)
    return japi:DzDoodadGetX(doodad) or 0
end
--- 获取装饰物Y坐标
function ____exports.DzDoodadGetY(self, doodad)
    return japi:DzDoodadGetY(doodad) or 0
end
--- 获取装饰物Z坐标
function ____exports.DzDoodadGetZ(self, doodad)
    return japi:DzDoodadGetZ(doodad) or 0
end
--- 设置装饰物位置
function ____exports.DzDoodadSetPosition(self, doodad, x, y, z)
    japi:DzDoodadSetPosition(doodad, x, y, z)
end
--- 设置装饰物方向矩阵旋转
function ____exports.DzDoodadSetOrientMatrixRotate(self, doodad, angle, axisX, axisY, axisZ)
    japi:DzDoodadSetOrientMatrixRotate(
        doodad,
        angle,
        axisX,
        axisY,
        axisZ
    )
end
--- 设置装饰物方向矩阵缩放
function ____exports.DzDoodadSetOrientMatrixScale(self, doodad, x, y, z)
    japi:DzDoodadSetOrientMatrixScale(doodad, x, y, z)
end
--- 设置装饰物方向矩阵重置大小
function ____exports.DzDoodadSetOrientMatrixResize(self, doodad)
    japi:DzDoodadSetOrientMatrixResize(doodad)
end
--- 设置装饰物可见性
function ____exports.DzDoodadSetVisible(self, doodad, enable)
    japi:DzDoodadSetVisible(doodad, enable)
end
--- 设置装饰物动画
function ____exports.DzDoodadSetAnimation(self, doodad, animName, animRandom)
    japi:DzDoodadSetAnimation(doodad, animName, animRandom)
end
--- 设置装饰物时间缩放
function ____exports.DzDoodadSetTimeScale(self, doodad, scale)
    japi:DzDoodadSetTimeScale(doodad, scale)
end
--- 获取装饰物时间缩放
function ____exports.DzDoodadGetTimeScale(self, doodad)
    return japi:DzDoodadGetTimeScale(doodad) or 0
end
--- 获取装饰物当前动画索引
function ____exports.DzDoodadGetCurrentAnimationIndex(self, doodad)
    return japi:DzDoodadGetCurrentAnimationIndex(doodad) or 0
end
--- 获取装饰物动画数量
function ____exports.DzDoodadGetAnimationCount(self, doodad)
    return japi:DzDoodadGetAnimationCount(doodad) or 0
end
--- 获取装饰物动画名称
function ____exports.DzDoodadGetAnimationName(self, doodad, index)
    return japi:DzDoodadGetAnimationName(doodad, index) or ""
end
--- 获取装饰物动画时间
function ____exports.DzDoodadGetAnimationTime(self, doodad, index)
    return japi:DzDoodadGetAnimationTime(doodad, index) or 0
end
return ____exports
