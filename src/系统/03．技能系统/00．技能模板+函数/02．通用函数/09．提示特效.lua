local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____505C_6B62_7279_6548_6B65_8FDB_7F29_653E_68C0_67E5, _____8BBE_7F6E_63D0_793A_7279_6548_9876_70B9_989C_8272, removePeriodicCallback, CosBJ, SinBJ, AddSpecialEffect, DestroyEffect, GetOwningPlayer, GetPlayerId, EXSetEffectSpeed, EXSetEffectSize, EXEffectMatRotateZ, EXEffectMatScale, DzSetEffectVertexColor, DzSetEffectVertexAlpha, MODEL_SQUARE1X, MODEL_SQUARE1_5X, MODEL_SQUARE2X, MODEL_SQUARE2_5X, MODEL_SQUARE3X, MODEL_SQUARE3_5X, MODEL_SQUARE4X, MODEL_SQUARE5X, MODEL_SQUARE6X, MODEL_SQUARE12X, MODEL_LINE1X, MODEL_LINE1_5X, MODEL_LINE2X, MODEL_LINE2_5X, MODEL_LINE3X, MODEL_LINE3_5X, MODEL_LINE4X, MODEL_LINE5X, MODEL_LINE6X, MODEL_RING, _____63D0_793A_5708_53CB_65B9_8272, _____63D0_793A_5708_654C_65B9_8272, _____7279_6548_6B65_8FDB_7F29_653E_4E0A_4E0B_6587_5217_8868, _____7279_6548_6B65_8FDB_7F29_653E_68C0_67E5_56DE_8C03ID
function _____505C_6B62_7279_6548_6B65_8FDB_7F29_653E_68C0_67E5()
    if _____7279_6548_6B65_8FDB_7F29_653E_68C0_67E5_56DE_8C03ID <= 0 then
        return
    end
    removePeriodicCallback(_____7279_6548_6B65_8FDB_7F29_653E_68C0_67E5_56DE_8C03ID)
    _____7279_6548_6B65_8FDB_7F29_653E_68C0_67E5_56DE_8C03ID = 0
end
function _____8BBE_7F6E_63D0_793A_7279_6548_9876_70B9_989C_8272(e, color)
    if not e then
        return
    end
    if type(DzSetEffectVertexColor) == "function" then
        DzSetEffectVertexColor(e, color)
    end
end
____exports["按所属单位设置提示圈颜色"] = function(e, _____6765_6E90_5355_4F4D, _____65E0_6765_6E90_9ED8_8BA4_989C_8272)
    if _____65E0_6765_6E90_9ED8_8BA4_989C_8272 == nil then
        _____65E0_6765_6E90_9ED8_8BA4_989C_8272 = _____63D0_793A_5708_654C_65B9_8272
    end
    if not e then
        return
    end
    if not _____6765_6E90_5355_4F4D then
        _____8BBE_7F6E_63D0_793A_7279_6548_9876_70B9_989C_8272(e, _____65E0_6765_6E90_9ED8_8BA4_989C_8272)
        return
    end
    local _____6240_5C5E_73A9_5BB6 = GetOwningPlayer(_____6765_6E90_5355_4F4D)
    if not _____6240_5C5E_73A9_5BB6 then
        _____8BBE_7F6E_63D0_793A_7279_6548_9876_70B9_989C_8272(e, _____65E0_6765_6E90_9ED8_8BA4_989C_8272)
        return
    end
    local _____73A9_5BB6ID = GetPlayerId(_____6240_5C5E_73A9_5BB6)
    if _____73A9_5BB6ID >= 0 and _____73A9_5BB6ID <= 5 then
        _____8BBE_7F6E_63D0_793A_7279_6548_9876_70B9_989C_8272(e, _____63D0_793A_5708_53CB_65B9_8272)
        return
    end
    _____8BBE_7F6E_63D0_793A_7279_6548_9876_70B9_989C_8272(e, _____63D0_793A_5708_654C_65B9_8272)
end
____exports["移除特效步进缩放"] = function(_____7279_6548)
    if not _____7279_6548 then
        return
    end
    do
        local i = #_____7279_6548_6B65_8FDB_7F29_653E_4E0A_4E0B_6587_5217_8868 - 1
        while i >= 0 do
            if _____7279_6548_6B65_8FDB_7F29_653E_4E0A_4E0B_6587_5217_8868[i + 1]["特效"] == _____7279_6548 then
                __TS__ArraySplice(_____7279_6548_6B65_8FDB_7F29_653E_4E0A_4E0B_6587_5217_8868, i, 1)
            end
            i = i - 1
        end
    end
    if #_____7279_6548_6B65_8FDB_7F29_653E_4E0A_4E0B_6587_5217_8868 <= 0 then
        _____505C_6B62_7279_6548_6B65_8FDB_7F29_653E_68C0_67E5()
    end
end
--- 创建一个需要手动销毁的矩形提示圈特效句柄。
-- 【重要】坐标必须传矩形路径起点，严禁传矩形中点；函数内部会沿朝向自动前移半个长度到模型中点。
____exports["创建矩形提示圈特效"] = function(_____8DEF_5F84_8D77_70B9X, _____8DEF_5F84_8D77_70B9Y, width, long, fac, speed)
    if width > 1500 then
        width = 1500
    end
    if long > 7500 then
        long = 7500
    end
    local sw = width / 1000
    local dis = long / 2
    local _____6A21_578B_4E2D_70B9X = _____8DEF_5F84_8D77_70B9X + CosBJ(fac) * dis
    local _____6A21_578B_4E2D_70B9Y = _____8DEF_5F84_8D77_70B9Y + SinBJ(fac) * dis
    local model
    local sl
    local ratio = long / width
    if ratio <= 1.25 then
        model = MODEL_SQUARE1X
        sl = long / 1000
    elseif ratio <= 1.75 then
        model = MODEL_SQUARE1_5X
        sl = long / 1500
    elseif ratio <= 2.25 then
        model = MODEL_SQUARE2X
        sl = long / 2000
    elseif ratio <= 2.75 then
        model = MODEL_SQUARE2_5X
        sl = long / 2500
    elseif ratio <= 3.25 then
        model = MODEL_SQUARE3X
        sl = long / 3000
    elseif ratio <= 3.75 then
        model = MODEL_SQUARE3_5X
        sl = long / 3500
    elseif ratio <= 4.5 then
        model = MODEL_SQUARE4X
        sl = long / 4000
    elseif ratio <= 5.5 then
        model = MODEL_SQUARE5X
        sl = long / 5000
    elseif ratio <= 9 then
        model = MODEL_SQUARE6X
        sl = long / 6000
    else
        model = MODEL_SQUARE12X
        sl = long / 12000
    end
    local e = AddSpecialEffect(model, _____6A21_578B_4E2D_70B9X, _____6A21_578B_4E2D_70B9Y)
    if not e then
        return
    end
    local s = speed or 1
    EXEffectMatRotateZ(e, fac + 270)
    EXEffectMatScale(e, sl, sw, 1)
    EXSetEffectSpeed(e, s)
    return e
end
--- 创建一个需要手动销毁的方向直线提示圈特效句柄。
-- 【重要】坐标必须传直线路径起点，严禁传模型中点；函数内部会沿朝向自动前移半个长度到模型中点。
____exports["创建方向直线提示圈特效"] = function(_____8DEF_5F84_8D77_70B9X, _____8DEF_5F84_8D77_70B9Y, width, long, fac, speed)
    if width <= 0 or long <= 0 then
        return nil
    end
    if width > 1500 then
        width = 1500
    end
    if long > 7500 then
        long = 7500
    end
    local model
    local modelLong
    local ratio = long / width
    if ratio <= 1.25 then
        model = MODEL_LINE1X
        modelLong = 1000
    elseif ratio <= 1.75 then
        model = MODEL_LINE1_5X
        modelLong = 1500
    elseif ratio <= 2.25 then
        model = MODEL_LINE2X
        modelLong = 2000
    elseif ratio <= 2.75 then
        model = MODEL_LINE2_5X
        modelLong = 2500
    elseif ratio <= 3.25 then
        model = MODEL_LINE3X
        modelLong = 3000
    elseif ratio <= 3.75 then
        model = MODEL_LINE3_5X
        modelLong = 3500
    elseif ratio <= 4.5 then
        model = MODEL_LINE4X
        modelLong = 4000
    elseif ratio <= 5.5 then
        model = MODEL_LINE5X
        modelLong = 5000
    else
        model = MODEL_LINE6X
        modelLong = 6000
    end
    local dis = long / 2
    local _____6A21_578B_4E2D_70B9X = _____8DEF_5F84_8D77_70B9X + CosBJ(fac) * dis
    local _____6A21_578B_4E2D_70B9Y = _____8DEF_5F84_8D77_70B9Y + SinBJ(fac) * dis
    local e = AddSpecialEffect(model, _____6A21_578B_4E2D_70B9X, _____6A21_578B_4E2D_70B9Y)
    if not e then
        return nil
    end
    EXEffectMatRotateZ(e, fac + 270)
    EXEffectMatScale(e, long / modelLong, width / 1000, 1)
    EXSetEffectSpeed(e, speed or 1)
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
removePeriodicCallback = ____require_result_0.removePeriodicCallback
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
MODEL_SQUARE1X = MODEL_DIR .. "UnifiedTip_Rect1x.mdx"
MODEL_SQUARE1_5X = MODEL_DIR .. "UnifiedTip_Rect1_5x.mdx"
MODEL_SQUARE2X = MODEL_DIR .. "UnifiedTip_Rect2x.mdx"
MODEL_SQUARE2_5X = MODEL_DIR .. "UnifiedTip_Rect2_5x.mdx"
MODEL_SQUARE3X = MODEL_DIR .. "UnifiedTip_Rect3x.mdx"
MODEL_SQUARE3_5X = MODEL_DIR .. "UnifiedTip_Rect3_5x.mdx"
MODEL_SQUARE4X = MODEL_DIR .. "UnifiedTip_Rect4x.mdx"
MODEL_SQUARE5X = MODEL_DIR .. "UnifiedTip_Rect5x.mdx"
MODEL_SQUARE6X = MODEL_DIR .. "UnifiedTip_Rect6x.mdx"
MODEL_SQUARE12X = MODEL_DIR .. "UnifiedTip_Rect12x.mdx"
MODEL_LINE1X = MODEL_DIR .. "UnifiedTip_Line1x.mdx"
MODEL_LINE1_5X = MODEL_DIR .. "UnifiedTip_Line1_5x.mdx"
MODEL_LINE2X = MODEL_DIR .. "UnifiedTip_Line2x.mdx"
MODEL_LINE2_5X = MODEL_DIR .. "UnifiedTip_Line2_5x.mdx"
MODEL_LINE3X = MODEL_DIR .. "UnifiedTip_Line3x.mdx"
MODEL_LINE3_5X = MODEL_DIR .. "UnifiedTip_Line3_5x.mdx"
MODEL_LINE4X = MODEL_DIR .. "UnifiedTip_Line4x.mdx"
MODEL_LINE5X = MODEL_DIR .. "UnifiedTip_Line5x.mdx"
MODEL_LINE6X = MODEL_DIR .. "UnifiedTip_Line6x.mdx"
local MODEL_SECTOR = MODEL_DIR .. "SimpleSectorTip.mdx"
MODEL_RING = MODEL_DIR .. "UnifiedTip_Ring.mdx"
local MODEL_RING_THICK = MODEL_DIR .. "UnifiedTip_RingThick.mdx"
local MODEL_RING_A = MODEL_DIR .. "UnifiedTip_Ring_A.mdx"
local MODEL_RING_B = MODEL_DIR .. "UnifiedTip_Ring_B.mdx"
local MODEL_RING_C = MODEL_DIR .. "UnifiedTip_Ring_C.mdx"
_____63D0_793A_5708_53CB_65B9_8272 = 4294967295
_____63D0_793A_5708_654C_65B9_8272 = 4294909984
local _____63D0_793A_7279_6548_9500_6BC1_68C0_67E5_95F4_9694_6BEB_79D2 = 10
local _____7279_6548_6B65_8FDB_7F29_653E_68C0_67E5_95F4_9694_6BEB_79D2 = 20
local _____5F85_9500_6BC1_63D0_793A_7279_6548_5217_8868 = {}
local _____5F85_9500_6BC1_63D0_793A_7279_6548_5230_671F_6BEB_79D2_5217_8868 = {}
local _____63D0_793A_7279_6548_9500_6BC1_68C0_67E5_56DE_8C03ID = 0
_____7279_6548_6B65_8FDB_7F29_653E_4E0A_4E0B_6587_5217_8868 = {}
_____7279_6548_6B65_8FDB_7F29_653E_68C0_67E5_56DE_8C03ID = 0
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
local function ____on_7279_6548_6B65_8FDB_7F29_653E_68C0_67E5()
    local now = getServerTime()
    do
        local i = #_____7279_6548_6B65_8FDB_7F29_653E_4E0A_4E0B_6587_5217_8868 - 1
        while i >= 0 do
            do
                local _____4E0A_4E0B_6587 = _____7279_6548_6B65_8FDB_7F29_653E_4E0A_4E0B_6587_5217_8868[i + 1]
                if not _____4E0A_4E0B_6587["特效"] then
                    __TS__ArraySplice(_____7279_6548_6B65_8FDB_7F29_653E_4E0A_4E0B_6587_5217_8868, i, 1)
                    goto __continue19
                end
                if now < _____4E0A_4E0B_6587["下次触发时间"] then
                    goto __continue19
                end
                _____4E0A_4E0B_6587["当前次数"] = _____4E0A_4E0B_6587["当前次数"] + 1
                if _____4E0A_4E0B_6587["当前次数"] >= _____4E0A_4E0B_6587["最大次数"] then
                    __TS__ArraySplice(_____7279_6548_6B65_8FDB_7F29_653E_4E0A_4E0B_6587_5217_8868, i, 1)
                    goto __continue19
                end
                EXSetEffectSize(_____4E0A_4E0B_6587["特效"], _____4E0A_4E0B_6587["基础尺寸"] + _____4E0A_4E0B_6587["当前次数"] * _____4E0A_4E0B_6587["每次增量"])
                _____4E0A_4E0B_6587["下次触发时间"] = now + _____4E0A_4E0B_6587["周期秒"] * 1000
            end
            ::__continue19::
            i = i - 1
        end
    end
    if #_____7279_6548_6B65_8FDB_7F29_653E_4E0A_4E0B_6587_5217_8868 <= 0 then
        _____505C_6B62_7279_6548_6B65_8FDB_7F29_653E_68C0_67E5()
    end
end
local function _____786E_4FDD_7279_6548_6B65_8FDB_7F29_653E_68C0_67E5()
    if _____7279_6548_6B65_8FDB_7F29_653E_68C0_67E5_56DE_8C03ID > 0 then
        return
    end
    _____7279_6548_6B65_8FDB_7F29_653E_68C0_67E5_56DE_8C03ID = addPeriodicCallback(_____7279_6548_6B65_8FDB_7F29_653E_68C0_67E5_95F4_9694_6BEB_79D2, ____on_7279_6548_6B65_8FDB_7F29_653E_68C0_67E5)
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
--- 让一个已创建的特效按固定周期逐步放大。
____exports["启动特效步进缩放"] = function(_____7279_6548, _____57FA_7840_5C3A_5BF8, _____6700_5927_6B21_6570, _____5468_671F_79D2, _____6BCF_6B21_589E_91CF)
    if _____6BCF_6B21_589E_91CF == nil then
        _____6BCF_6B21_589E_91CF = 1
    end
    if not _____7279_6548 or _____6700_5927_6B21_6570 <= 0 or _____5468_671F_79D2 <= 0 then
        return
    end
    ____exports["移除特效步进缩放"](_____7279_6548)
    _____7279_6548_6B65_8FDB_7F29_653E_4E0A_4E0B_6587_5217_8868[#_____7279_6548_6B65_8FDB_7F29_653E_4E0A_4E0B_6587_5217_8868 + 1] = {
        ["特效"] = _____7279_6548,
        ["当前次数"] = 0,
        ["最大次数"] = _____6700_5927_6B21_6570,
        ["基础尺寸"] = _____57FA_7840_5C3A_5BF8,
        ["每次增量"] = _____6BCF_6B21_589E_91CF,
        ["周期秒"] = _____5468_671F_79D2,
        ["下次触发时间"] = getServerTime() + _____5468_671F_79D2 * 1000
    }
    _____786E_4FDD_7279_6548_6B65_8FDB_7F29_653E_68C0_67E5()
end
--- 精确无变形比例：1:1、1:1.5、1:2、1:2.5、1:3、1:3.5、1:4、1:5、1:6、1:12。
-- 其他比例会选用最接近的预制模型，仍可能出现轻微的非等比拉伸。
-- 如宽度为 300、比例为 1:1.5，则长度应为 450。
-- 【重要】坐标必须传矩形路径起点，严禁传矩形中点；函数内部会沿朝向自动前移半个长度到模型中点。
-- 
-- @param 路径起点X 矩形路径起点 X 坐标
-- @param 路径起点Y 矩形路径起点 Y 坐标
-- @param width 宽度（最大1500）
-- @param long 长度（最大7500）
-- @param fac 朝向角度
-- @param time 持续时间（<=0 表示1秒）
-- @param speed 动画速率（可选，默认 1/time）
-- 1:6 与 1:12 之间按更接近的预制模型缩放；超过 1:12 时固定使用 12X 模型。
____exports["创建矩形提示圈"] = function(_____8DEF_5F84_8D77_70B9X, _____8DEF_5F84_8D77_70B9Y, width, long, fac, time, speed, _____6765_6E90_5355_4F4D)
    local e = ____exports["创建矩形提示圈特效"](
        _____8DEF_5F84_8D77_70B9X,
        _____8DEF_5F84_8D77_70B9Y,
        width,
        long,
        fac,
        speed
    )
    if not e then
        return
    end
    ____exports["按所属单位设置提示圈颜色"](e, _____6765_6E90_5355_4F4D)
    local duration = time <= 0 and 1 or time + 0.05
    _____5B89_5168_9500_6BC1_7279_6548(duration, e)
end
--- 创建带中轴延伸箭头的方向直线提示。
-- 预制比例与矩形一致，精确命中时只进行等比缩放。
-- 【重要】坐标必须传直线路径起点，严禁传模型中点；函数内部会沿朝向自动前移半个长度到模型中点。
____exports["创建方向直线提示圈"] = function(_____8DEF_5F84_8D77_70B9X, _____8DEF_5F84_8D77_70B9Y, width, long, fac, time, speed, _____6765_6E90_5355_4F4D)
    local e = ____exports["创建方向直线提示圈特效"](
        _____8DEF_5F84_8D77_70B9X,
        _____8DEF_5F84_8D77_70B9Y,
        width,
        long,
        fac,
        speed
    )
    if not e then
        return
    end
    ____exports["按所属单位设置提示圈颜色"](e, _____6765_6E90_5355_4F4D)
    _____5B89_5168_9500_6BC1_7279_6548(time <= 0 and 1 or time + 0.05, e)
end
--- 创建白色方向直线提示圈，用于明确标识安全通道。
-- 坐标仍传直线路径起点，长度和朝向必须与实际路径一致。
____exports["创建白色方向直线提示圈"] = function(_____8DEF_5F84_8D77_70B9X, _____8DEF_5F84_8D77_70B9Y, width, long, fac, time, speed)
    local e = ____exports["创建方向直线提示圈特效"](
        _____8DEF_5F84_8D77_70B9X,
        _____8DEF_5F84_8D77_70B9Y,
        width,
        long,
        fac,
        speed
    )
    if not e then
        return
    end
    ____exports["按所属单位设置提示圈颜色"](e, nil, _____63D0_793A_5708_53CB_65B9_8272)
    _____5B89_5168_9500_6BC1_7279_6548(time <= 0 and 1 or time + 0.05, e)
end
--- 白色扇形提示圈
-- `size = 1.0` 时，对应模型原始扇形尺寸：内侧约 32 半径，外侧约 512 半径。
____exports["创建白色扇形提示圈"] = function(x, y, fac, size, time, speed, _____6765_6E90_5355_4F4D)
    x = x + CosBJ(fac) * 10
    y = y + SinBJ(fac) * 10
    local e = AddSpecialEffect(MODEL_SECTOR, x, y)
    if not e then
        return
    end
    ____exports["按所属单位设置提示圈颜色"](e, _____6765_6E90_5355_4F4D, _____63D0_793A_5708_53CB_65B9_8272)
    EXEffectMatRotateZ(e, fac)
    EXSetEffectSize(e, size)
    EXSetEffectSpeed(e, speed or 1)
    local duration = time <= 0 and 0.5 or time + 0.05
    _____5B89_5168_9500_6BC1_7279_6548(duration, e)
end
--- 红色扇形提示圈
-- `size = 1.0` 时，对应模型原始扇形尺寸：内侧约 32 半径，外侧约 512 半径。
____exports["创建红色扇形提示圈"] = function(x, y, fac, size, time, speed, _____6765_6E90_5355_4F4D)
    x = x + CosBJ(fac) * 10
    y = y + SinBJ(fac) * 10
    local e = AddSpecialEffect(MODEL_SECTOR, x, y)
    if not e then
        return
    end
    ____exports["按所属单位设置提示圈颜色"](e, _____6765_6E90_5355_4F4D)
    EXEffectMatRotateZ(e, fac)
    EXSetEffectSize(e, size)
    EXSetEffectSpeed(e, speed or 1)
    local duration = time <= 0 and 0.5 or time + 0.05
    _____5B89_5168_9500_6BC1_7279_6548(duration, e)
end
--- 创建一个需要手动销毁的红色扇形提示圈特效句柄。
-- `size = 1.0` 时，对应模型原始扇形尺寸：内侧约 32 半径，外侧约 512 半径。
____exports["创建红色扇形提示圈特效"] = function(x, y, fac, size, speed, _____6765_6E90_5355_4F4D)
    x = x + CosBJ(fac) * 10
    y = y + SinBJ(fac) * 10
    local e = AddSpecialEffect(MODEL_SECTOR, x, y)
    if not e then
        return
    end
    ____exports["按所属单位设置提示圈颜色"](e, _____6765_6E90_5355_4F4D)
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
____exports["创建薄圆形提示圈"] = function(x, y, r, time, speed, _____6765_6E90_5355_4F4D)
    local e = ____exports["创建薄圆形提示圈特效"](
        x,
        y,
        r,
        speed,
        _____6765_6E90_5355_4F4D
    )
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
____exports["创建厚圆形提示圈"] = function(x, y, r, time, speed, _____6765_6E90_5355_4F4D)
    local e = AddSpecialEffect(MODEL_RING_THICK, x, y)
    if not e then
        return
    end
    local size = r / 200
    local s = speed or (time <= 0 and 1 or 1 / time)
    local duration = time <= 0 and 0.5 or time + 0.05
    EXSetEffectSize(e, size)
    EXSetEffectSpeed(e, s)
    ____exports["按所属单位设置提示圈颜色"](e, _____6765_6E90_5355_4F4D)
    _____5B89_5168_9500_6BC1_7279_6548(duration, e)
end
--- 快速创建白色圆形提示圈
-- 无来源时表示白色安全区域；传入来源单位时按阵营着色。
____exports["创建白色圆形提示圈"] = function(x, y, r, time, speed, _____6765_6E90_5355_4F4D)
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
    ____exports["按所属单位设置提示圈颜色"](e, _____6765_6E90_5355_4F4D, _____63D0_793A_5708_53CB_65B9_8272)
    _____5B89_5168_9500_6BC1_7279_6548(duration, e)
end
--- 快速创建渐变圆形提示圈（白→红）
____exports["创建渐变圆形提示圈"] = function(x, y, r, time, speed, _____6765_6E90_5355_4F4D)
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
    ____exports["按所属单位设置提示圈颜色"](e, _____6765_6E90_5355_4F4D)
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
____exports["创建双环提示圈"] = function(x, y, r, time, speed, _____6765_6E90_5355_4F4D)
    local e = AddSpecialEffect(MODEL_RING_C, x, y)
    if not e then
        return
    end
    local size = r / 200
    EXSetEffectSize(e, size)
    EXSetEffectSpeed(e, speed or 1)
    ____exports["按所属单位设置提示圈颜色"](e, _____6765_6E90_5355_4F4D)
    local duration = time <= 0 and 1 or time + 0.05
    _____5B89_5168_9500_6BC1_7279_6548(duration, e)
    return e
end
return ____exports
