--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____8BBE_7F6E_63D0_793A_7279_6548_9876_70B9_989C_8272, CosBJ, SinBJ, AddSpecialEffect, DestroyEffect, GetOwningPlayer, GetPlayerId, EXSetEffectSpeed, EXSetEffectSize, EXEffectMatRotateZ, EXEffectMatScale, DzSetEffectVertexColor, DzSetEffectVertexAlpha, MODEL_SQUARE1X, MODEL_SQUARE2X, MODEL_SQUARE3X, MODEL_SQUARE4X, MODEL_SQUARE5X, MODEL_SQUARE6X, MODEL_RING, _____63D0_793A_5708_53CB_65B9_8272, _____63D0_793A_5708_654C_65B9_8272
function _____8BBE_7F6E_63D0_793A_7279_6548_9876_70B9_989C_8272(e, color)
    if not e then
        return
    end
    if type(DzSetEffectVertexColor) == "function" then
        DzSetEffectVertexColor(e, color)
    end
end
____exports["按所属单位设置提示圈颜色"] = function(e, _____6765_6E90_5355_4F4D)
    if not e or not _____6765_6E90_5355_4F4D then
        return
    end
    local _____6240_5C5E_73A9_5BB6 = GetOwningPlayer(_____6765_6E90_5355_4F4D)
    if not _____6240_5C5E_73A9_5BB6 then
        return
    end
    local _____73A9_5BB6ID = GetPlayerId(_____6240_5C5E_73A9_5BB6)
    if _____73A9_5BB6ID >= 0 and _____73A9_5BB6ID <= 5 then
        _____8BBE_7F6E_63D0_793A_7279_6548_9876_70B9_989C_8272(e, _____63D0_793A_5708_53CB_65B9_8272)
        return
    end
    _____8BBE_7F6E_63D0_793A_7279_6548_9876_70B9_989C_8272(e, _____63D0_793A_5708_654C_65B9_8272)
end
--- 创建一个需要手动销毁的矩形提示圈特效句柄
____exports["创建矩形提示圈特效"] = function(x, y, width, long, fac, speed)
    if width > 1500 then
        width = 1500
    end
    if long > 7500 then
        long = 7500
    end
    local sw = width / 1000
    local dis = long / 2
    x = x + CosBJ(fac) * dis
    y = y + SinBJ(fac) * dis
    local model
    local sl
    local ratio = long / width
    if ratio <= 1 then
        model = MODEL_SQUARE1X
        sl = long / 1000
    elseif ratio <= 2 then
        model = MODEL_SQUARE2X
        sl = long / 2000
    elseif ratio <= 3 then
        model = MODEL_SQUARE3X
        sl = long / 3000
    elseif ratio <= 4 then
        model = MODEL_SQUARE4X
        sl = long / 4000
    elseif ratio <= 5 then
        model = MODEL_SQUARE5X
        sl = long / 5000
    else
        model = MODEL_SQUARE6X
        sl = long / 6000
    end
    local e = AddSpecialEffect(model, x, y)
    if not e then
        return
    end
    local s = speed or 1
    EXEffectMatRotateZ(e, fac + 270)
    EXEffectMatScale(e, sl, sw, 1)
    EXSetEffectSpeed(e, s)
    return e
end
--- 更新扇形提示圈朝向与尺寸。
-- `size = 1.0` 时，对应模型原始扇形尺寸：内侧约 32 半径，外侧约 512 半径。
____exports["设置扇形提示圈朝向与尺寸"] = function(e, fac, size)
    EXEffectMatRotateZ(e, fac)
    EXSetEffectSize(e, size)
end
--- 创建一个需要手动销毁的薄圆形提示圈特效句柄
____exports["创建薄圆形提示圈特效"] = function(x, y, r, speed, _____6765_6E90_5355_4F4D)
    local e = AddSpecialEffect(MODEL_RING, x, y)
    if not e then
        return
    end
    ____exports["设置提示圈半径"](e, r)
    EXSetEffectSpeed(e, speed or 1)
    ____exports["按所属单位设置提示圈颜色"](e, _____6765_6E90_5355_4F4D)
    return e
end
--- 按半径更新提示圈尺寸
____exports["设置提示圈半径"] = function(e, r)
    EXSetEffectSize(e, r / 178)
end
--- 立即隐藏并销毁提示特效，避免模型自身尾动画继续可见
____exports["立即隐藏并销毁提示特效"] = function(e)
    if not e then
        return
    end
    if type(DzSetEffectVertexAlpha) == "function" then
        DzSetEffectVertexAlpha(e, 0)
    end
    EXSetEffectSize(e, 0.01)
    DestroyEffect(e)
end
--- 提示特效系统
-- 
-- 快速创建技能预警提示圈：矩形、扇形、圆形
-- 模型路径：resource\models\Tip\
-- 
-- 动画速度说明（所有特效通用）：
-- - 默认 1倍速 = 1秒延迟（动画播放1秒）
-- - 0.5倍 = 2秒延迟（动画播放2秒，更慢）
-- - 2倍 = 0.5秒延迟（动画播放0.5秒，更快）
-- - 支持传入 speed 参数自定义动画速率
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("lib.扩展函数.BJ函数.12．数学函数")
local RMaxBJ = ____require_result_1.RMaxBJ
local RMinBJ = ____require_result_1.RMinBJ
CosBJ = ____require_result_1.CosBJ
SinBJ = ____require_result_1.SinBJ
AddSpecialEffect = jass.AddSpecialEffect
DestroyEffect = jass.DestroyEffect
GetOwningPlayer = jass.GetOwningPlayer
GetPlayerId = jass.GetPlayerId
local Player = jass.Player
EXSetEffectSpeed = japi.EXSetEffectSpeed
EXSetEffectSize = japi.EXSetEffectSize
EXEffectMatRotateZ = japi.EXEffectMatRotateZ
EXEffectMatScale = japi.EXEffectMatScale
DzSetEffectVertexColor = japi.DzSetEffectVertexColor
DzSetEffectVertexAlpha = japi.DzSetEffectVertexAlpha
local DzSetEffectAnimation = japi.DzSetEffectAnimation
local DzPlayEffectAnimation = japi.DzPlayEffectAnimation
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitScale = jass.SetUnitScale
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitVertexColor = jass.SetUnitVertexColor
local RemoveUnit = jass.RemoveUnit
local MODEL_DIR = "resource\\models\\Tip\\skillTip\\"
MODEL_SQUARE1X = MODEL_DIR .. "Abiltip_Square1x.mdx"
MODEL_SQUARE2X = MODEL_DIR .. "Abiltip_Square2x.mdx"
MODEL_SQUARE3X = MODEL_DIR .. "Abiltip_Square3x.mdx"
MODEL_SQUARE4X = MODEL_DIR .. "Abiltip_Square4x.mdx"
MODEL_SQUARE5X = MODEL_DIR .. "Abiltip_Square5x.mdx"
MODEL_SQUARE6X = MODEL_DIR .. "Abiltip_Square6x.mdx"
local MODEL_SECTOR = MODEL_DIR .. "AbilTipSX.mdx"
MODEL_RING = MODEL_DIR .. "mr.war3_ring.mdx"
local MODEL_RING_THICK = MODEL_DIR .. "Abiltip_ring.mdx"
local MODEL_RING_A = MODEL_DIR .. "Tip_ring_A.mdx"
local MODEL_RING_B = MODEL_DIR .. "Tip_ring_B.mdx"
local MODEL_RING_C = MODEL_DIR .. "Tip_ring_C.mdx"
_____63D0_793A_5708_53CB_65B9_8272 = 4282449728
_____63D0_793A_5708_654C_65B9_8272 = 4294909984
local _____63D0_793A_7279_6548_9500_6BC1_68C0_67E5_95F4_9694_6BEB_79D2 = 10
local _____5F85_9500_6BC1_63D0_793A_7279_6548_5217_8868 = {}
local _____5F85_9500_6BC1_63D0_793A_7279_6548_5230_671F_6BEB_79D2_5217_8868 = {}
local _____63D0_793A_7279_6548_9500_6BC1_68C0_67E5_56DE_8C03ID = 0
local function _____505C_6B62_63D0_793A_7279_6548_9500_6BC1_68C0_67E5()
    if _____63D0_793A_7279_6548_9500_6BC1_68C0_67E5_56DE_8C03ID <= 0 then
        return
    end
    removePeriodicCallback(_____63D0_793A_7279_6548_9500_6BC1_68C0_67E5_56DE_8C03ID)
    _____63D0_793A_7279_6548_9500_6BC1_68C0_67E5_56DE_8C03ID = 0
end
local function ____on_63D0_793A_7279_6548_9500_6BC1_68C0_67E5()
    local now = getServerTime()
    local writeIndex = 0
    do
        local i = 0
        while i < #_____5F85_9500_6BC1_63D0_793A_7279_6548_5217_8868 do
            local e = _____5F85_9500_6BC1_63D0_793A_7279_6548_5217_8868[i + 1]
            if now >= _____5F85_9500_6BC1_63D0_793A_7279_6548_5230_671F_6BEB_79D2_5217_8868[i + 1] then
                if e then
                    ____exports["立即隐藏并销毁提示特效"](e)
                end
            else
                _____5F85_9500_6BC1_63D0_793A_7279_6548_5217_8868[writeIndex + 1] = e
                _____5F85_9500_6BC1_63D0_793A_7279_6548_5230_671F_6BEB_79D2_5217_8868[writeIndex + 1] = _____5F85_9500_6BC1_63D0_793A_7279_6548_5230_671F_6BEB_79D2_5217_8868[i + 1]
                writeIndex = writeIndex + 1
            end
            i = i + 1
        end
    end
    do
        local i = #_____5F85_9500_6BC1_63D0_793A_7279_6548_5217_8868 - 1
        while i >= writeIndex do
            table.remove(_____5F85_9500_6BC1_63D0_793A_7279_6548_5217_8868)
            table.remove(_____5F85_9500_6BC1_63D0_793A_7279_6548_5230_671F_6BEB_79D2_5217_8868)
            i = i - 1
        end
    end
    if #_____5F85_9500_6BC1_63D0_793A_7279_6548_5217_8868 <= 0 then
        _____505C_6B62_63D0_793A_7279_6548_9500_6BC1_68C0_67E5()
    end
end
local function _____786E_4FDD_63D0_793A_7279_6548_9500_6BC1_68C0_67E5()
    if _____63D0_793A_7279_6548_9500_6BC1_68C0_67E5_56DE_8C03ID > 0 then
        return
    end
    _____63D0_793A_7279_6548_9500_6BC1_68C0_67E5_56DE_8C03ID = addPeriodicCallback(_____63D0_793A_7279_6548_9500_6BC1_68C0_67E5_95F4_9694_6BEB_79D2, ____on_63D0_793A_7279_6548_9500_6BC1_68C0_67E5)
end
local function _____5B89_5168_9500_6BC1_7279_6548(duration, effect)
    if not effect then
        return
    end
    if duration <= 0 then
        ____exports["立即隐藏并销毁提示特效"](effect)
        return
    end
    _____5F85_9500_6BC1_63D0_793A_7279_6548_5217_8868[#_____5F85_9500_6BC1_63D0_793A_7279_6548_5217_8868 + 1] = effect
    _____5F85_9500_6BC1_63D0_793A_7279_6548_5230_671F_6BEB_79D2_5217_8868[#_____5F85_9500_6BC1_63D0_793A_7279_6548_5230_671F_6BEB_79D2_5217_8868 + 1] = getServerTime() + duration * 1000
    _____786E_4FDD_63D0_793A_7279_6548_9500_6BC1_68C0_67E5()
end
--- /严格且仅支持宽长比 1:1, 1:2, 1:3, 1:4, 1:5, 1:6不支持1:7及以上，否则会出现视觉错误（菱形），因为模型是固定的。
-- 如宽sw=300, 那么长sl=1800
-- 
-- @param x X坐标
-- @param y Y坐标
-- @param width 宽度（最大1500）
-- @param long 长度（最大7500）
-- @param fac 朝向角度
-- @param time 持续时间（<=0 表示1秒）
-- @param speed 动画速率（可选，默认 1/time）
-- 严格且仅支持宽长比 1:1~1:6，否则会出现菱形视觉错误
____exports["创建矩形提示圈"] = function(x, y, width, long, fac, time, speed)
    local e = ____exports["创建矩形提示圈特效"](
        x,
        y,
        width,
        long,
        fac,
        speed
    )
    if not e then
        return
    end
    local duration = time <= 0 and 1 or time + 0.05
    _____5B89_5168_9500_6BC1_7279_6548(duration, e)
end
--- 白色扇形提示圈
-- `size = 1.0` 时，对应模型原始扇形尺寸：内侧约 32 半径，外侧约 512 半径。
____exports["创建白色扇形提示圈"] = function(x, y, fac, size, time, speed)
    x = x + CosBJ(fac) * 10
    y = y + SinBJ(fac) * 10
    local e = AddSpecialEffect(MODEL_SECTOR, x, y)
    if not e then
        return
    end
    _____8BBE_7F6E_63D0_793A_7279_6548_9876_70B9_989C_8272(e, 4294967295)
    EXEffectMatRotateZ(e, fac)
    EXSetEffectSize(e, size)
    EXSetEffectSpeed(e, speed or 1)
    local duration = time <= 0 and 0.5 or time + 0.05
    _____5B89_5168_9500_6BC1_7279_6548(duration, e)
end
--- 红色扇形提示圈
-- `size = 1.0` 时，对应模型原始扇形尺寸：内侧约 32 半径，外侧约 512 半径。
____exports["创建红色扇形提示圈"] = function(x, y, fac, size, time, speed)
    x = x + CosBJ(fac) * 10
    y = y + SinBJ(fac) * 10
    local e = AddSpecialEffect(MODEL_SECTOR, x, y)
    if not e then
        return
    end
    _____8BBE_7F6E_63D0_793A_7279_6548_9876_70B9_989C_8272(e, _____63D0_793A_5708_654C_65B9_8272)
    EXEffectMatRotateZ(e, fac)
    EXSetEffectSize(e, size)
    EXSetEffectSpeed(e, speed or 1)
    local duration = time <= 0 and 0.5 or time + 0.05
    _____5B89_5168_9500_6BC1_7279_6548(duration, e)
end
--- 创建一个需要手动销毁的红色扇形提示圈特效句柄。
-- `size = 1.0` 时，对应模型原始扇形尺寸：内侧约 32 半径，外侧约 512 半径。
____exports["创建红色扇形提示圈特效"] = function(x, y, fac, size, speed)
    x = x + CosBJ(fac) * 10
    y = y + SinBJ(fac) * 10
    local e = AddSpecialEffect(MODEL_SECTOR, x, y)
    if not e then
        return
    end
    _____8BBE_7F6E_63D0_793A_7279_6548_9876_70B9_989C_8272(e, _____63D0_793A_5708_654C_65B9_8272)
    ____exports["设置扇形提示圈朝向与尺寸"](e, fac, size)
    EXSetEffectSpeed(e, speed or 1)
    return e
end
--- 快速创建薄红色圆形提示圈
-- 
-- @param x X坐标
-- @param y Y坐标
-- @param r 半径
-- @param time 持续时间（<=0 表示1秒）
-- @param speed 动画速率（可选，默认 1/time）
____exports["创建薄圆形提示圈"] = function(x, y, r, time, speed)
    local e = ____exports["创建薄圆形提示圈特效"](x, y, r, speed)
    if not e then
        return
    end
    local duration = time <= 0 and 0.5 or time + 0.05
    _____5B89_5168_9500_6BC1_7279_6548(duration, e)
end
--- 安全重播提示圈动画。
-- 优先按动画序号重播；仅当平台提供按名称播放接口且显式传入动画名时才按名称播放。
____exports["重播提示圈动画"] = function(e, _____52A8_753B_5E8F_53F7, _____52A8_753B_540D)
    if not e then
        return
    end
    if type(DzSetEffectAnimation) == "function" then
        DzSetEffectAnimation(e, _____52A8_753B_5E8F_53F7 or 0, 0)
    end
    if type(DzPlayEffectAnimation) == "function" and _____52A8_753B_540D ~= nil and _____52A8_753B_540D ~= "" then
        DzPlayEffectAnimation(e, _____52A8_753B_540D, "")
    end
end
--- 兼容旧接口名，内部统一走通用销毁逻辑
____exports["立即销毁提示圈特效"] = function(e)
    ____exports["立即隐藏并销毁提示特效"](e)
end
--- 快速创建厚红色圆形提示圈
-- 
-- @param x X坐标
-- @param y Y坐标
-- @param r 半径
-- @param time 持续时间（<=0 表示1秒）
-- @param speed 动画速率（可选，默认 1/time）
____exports["创建厚圆形提示圈"] = function(x, y, r, time, speed)
    local e = AddSpecialEffect(MODEL_RING_THICK, x, y)
    if not e then
        return
    end
    local size = r / 200
    local s = speed or (time <= 0 and 1 or 1 / time)
    local duration = time <= 0 and 0.5 or time + 0.05
    EXSetEffectSize(e, size)
    EXSetEffectSpeed(e, s)
    _____5B89_5168_9500_6BC1_7279_6548(duration, e)
end
--- 快速创建白色圆形提示圈
-- 固定表示安全区域，不参与按所属单位着色。
____exports["创建白色圆形提示圈"] = function(x, y, r, time, speed)
    local e = AddSpecialEffect(MODEL_RING_A, x, y)
    if not e then
        return
    end
    local size = r / 200
    local duration = time <= 0 and 0.5 or time + 0.05
    if DzSetEffectAnimation ~= nil then
        DzSetEffectAnimation(e, 0, 0)
    end
    EXSetEffectSize(e, size)
    EXSetEffectSpeed(e, speed or 1)
    _____5B89_5168_9500_6BC1_7279_6548(duration, e)
end
--- 快速创建渐变圆形提示圈（白→红）
____exports["创建渐变圆形提示圈"] = function(x, y, r, time, speed)
    local e = AddSpecialEffect(MODEL_RING_B, x, y)
    if not e then
        return
    end
    local size = r / 200
    if DzSetEffectAnimation ~= nil then
        DzSetEffectAnimation(e, 1, 0)
    end
    EXSetEffectSize(e, size)
    EXSetEffectSpeed(e, speed or 1)
    local duration = time <= 0 and 0.1 or time + 0.05
    if duration < 0.1 then
        duration = 0.1
    end
    _____5B89_5168_9500_6BC1_7279_6548(duration, e)
    return e
end
--- 快速创建双环圆形提示圈（内圈+外圈）
-- 适用于"内圈无伤害外圈有伤害"或"外圈有伤害内圈无伤害"的模式
-- 内圈:外圈 半径比例 ≈ 1:2
-- 
-- @param x X坐标
-- @param y Y坐标
-- @param r 外圈半径（内圈自动按1:2比例缩小）
-- @param time 持续时间（<=0 表示1秒）
-- @param speed 动画速率（可选，默认 1）
____exports["创建双环提示圈"] = function(x, y, r, time, speed)
    local e = AddSpecialEffect(MODEL_RING_C, x, y)
    if not e then
        return
    end
    local size = r / 200
    EXSetEffectSize(e, size)
    EXSetEffectSpeed(e, speed or 1)
    local duration = time <= 0 and 1 or time + 0.05
    _____5B89_5168_9500_6BC1_7279_6548(duration, e)
    return e
end
return ____exports
