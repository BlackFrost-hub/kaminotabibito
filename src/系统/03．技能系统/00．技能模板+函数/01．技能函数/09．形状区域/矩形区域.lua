local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
--- 形状区域 - 矩形 / 条形区域
-- 
-- 说明：
-- 1. 支持“中心点 + 朝向 + 长宽”的普通矩形判定。
-- 2. 支持“起点 -> 终点 + 宽度”的条形区域判定，适合路径落地统一结算。
-- 3. 先做圆形粗筛，再做局部坐标精判。
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_0.getUnitsInRange
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.11．技能属性修正.index")
local _____6309_82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63_4E0A_4E0B_6587_4FEE_6B63_8DDD_79BB = ____require_result_1["按英雄技能距离修正上下文修正距离"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local CreateGroup = jass.CreateGroup
local GroupAddUnit = jass.GroupAddUnit
local function _____7EDD_5BF9_503C(_____503C)
    return _____503C < 0 and -_____503C or _____503C
end
local function _____8BA1_7B97_5E73_65B9_6839(_____503C)
    return jass:SquareRoot(_____503C)
end
local function _____8BA1_7B97_5750_6807_8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return _____8BA1_7B97_5E73_65B9_6839(dx * dx + dy * dy)
end
local function _____8BA1_7B97_77E9_5F62_7C97_7B5B_534A_5F84(_____957F_5EA6, _____5BBD_5EA6)
    local _____534A_957F = _____957F_5EA6 / 2
    local _____534A_5BBD = _____5BBD_5EA6 / 2
    return _____8BA1_7B97_5E73_65B9_6839(_____534A_957F * _____534A_957F + _____534A_5BBD * _____534A_5BBD)
end
local function _____8BA1_7B97_65B9_5411_5355_4F4D_5411_91CF(_____65B9_5411_89D2)
    return {
        X = jass:Cos(_____65B9_5411_89D2 * jass.bj_DEGTORAD),
        Y = jass:Sin(_____65B9_5411_89D2 * jass.bj_DEGTORAD)
    }
end
local function _____5355_4F4D_662F_5426_5728_5DF2_5F52_4E00_77E9_5F62_533A_57DF(_____5355_4F4D, _____4E2D_5FC3X, _____4E2D_5FC3Y, _____534A_957F, _____534A_5BBD, _____65B9_5411X, _____65B9_5411Y, _____5305_542B_8FB9_754C)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    if _____534A_957F <= 0 or _____534A_5BBD <= 0 then
        return false
    end
    local _____5355_4F4DX = GetUnitX(_____5355_4F4D)
    local _____5355_4F4DY = GetUnitY(_____5355_4F4D)
    local dx = _____5355_4F4DX - _____4E2D_5FC3X
    local dy = _____5355_4F4DY - _____4E2D_5FC3Y
    local _____524D_5411_6295_5F71 = dx * _____65B9_5411X + dy * _____65B9_5411Y
    local _____4FA7_5411_6295_5F71 = dx * -_____65B9_5411Y + dy * _____65B9_5411X
    local _____7EDD_5BF9_524D_5411 = _____7EDD_5BF9_503C(_____524D_5411_6295_5F71)
    local _____7EDD_5BF9_4FA7_5411 = _____7EDD_5BF9_503C(_____4FA7_5411_6295_5F71)
    if _____5305_542B_8FB9_754C then
        return _____7EDD_5BF9_524D_5411 <= _____534A_957F and _____7EDD_5BF9_4FA7_5411 <= _____534A_5BBD
    end
    return _____7EDD_5BF9_524D_5411 < _____534A_957F and _____7EDD_5BF9_4FA7_5411 < _____534A_5BBD
end
____exports["单位是否在矩形区域"] = function(_____5355_4F4D, X, Y, _____957F_5EA6, _____5BBD_5EA6, _____65B9_5411_89D2, _____5305_542B_8FB9_754C)
    if _____5305_542B_8FB9_754C == nil then
        _____5305_542B_8FB9_754C = true
    end
    if _____957F_5EA6 <= 0 or _____5BBD_5EA6 <= 0 then
        return false
    end
    local _____534A_957F = _____957F_5EA6 / 2
    local _____534A_5BBD = _____5BBD_5EA6 / 2
    local _____65B9_5411 = _____8BA1_7B97_65B9_5411_5355_4F4D_5411_91CF(_____65B9_5411_89D2)
    return _____5355_4F4D_662F_5426_5728_5DF2_5F52_4E00_77E9_5F62_533A_57DF(
        _____5355_4F4D,
        X,
        Y,
        _____534A_957F,
        _____534A_5BBD,
        _____65B9_5411.X,
        _____65B9_5411.Y,
        _____5305_542B_8FB9_754C
    )
end
____exports["获取矩形区域单位"] = function(_____53C2_6570)
    if _____53C2_6570["长度"] <= 0 or _____53C2_6570["宽度"] <= 0 then
        return {}
    end
    local _____957F_5EA6 = _____6309_82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63_4E0A_4E0B_6587_4FEE_6B63_8DDD_79BB(_____53C2_6570["长度"], _____53C2_6570["英雄技能距离修正"], "矩形长度")
    local _____7C97_7B5B_534A_5F84 = _____8BA1_7B97_77E9_5F62_7C97_7B5B_534A_5F84(_____957F_5EA6, _____53C2_6570["宽度"])
    local _____5019_9009_5355_4F4D = getUnitsInRange(_____53C2_6570.X, _____53C2_6570.Y, _____7C97_7B5B_534A_5F84)
    local _____7ED3_679C = {}
    for ____, _____5355_4F4D in ipairs(_____5019_9009_5355_4F4D) do
        do
            local ____exports__5355_4F4D_662F_5426_5728_77E9_5F62_533A_57DF_4 = ____exports["单位是否在矩形区域"]
            local ____array_3 = __TS__SparseArrayNew(
                _____5355_4F4D,
                _____53C2_6570.X,
                _____53C2_6570.Y,
                _____957F_5EA6,
                _____53C2_6570["宽度"],
                _____53C2_6570["方向角"]
            )
            local ____53C2_6570__5305_542B_8FB9_754C_2 = _____53C2_6570["包含边界"]
            if ____53C2_6570__5305_542B_8FB9_754C_2 == nil then
                ____53C2_6570__5305_542B_8FB9_754C_2 = true
            end
            __TS__SparseArrayPush(____array_3, ____53C2_6570__5305_542B_8FB9_754C_2)
            if not ____exports__5355_4F4D_662F_5426_5728_77E9_5F62_533A_57DF_4(__TS__SparseArraySpread(____array_3)) then
                goto __continue15
            end
            if _____53C2_6570["单位筛选"] ~= nil and not _____53C2_6570["单位筛选"](_____5355_4F4D) then
                goto __continue15
            end
            _____7ED3_679C[#_____7ED3_679C + 1] = _____5355_4F4D
        end
        ::__continue15::
    end
    return _____7ED3_679C
end
____exports["创建矩形单位组"] = function(_____53C2_6570)
    local _____5355_4F4D_7EC4 = CreateGroup()
    local _____5355_4F4D_5217_8868 = ____exports["获取矩形区域单位"](_____53C2_6570)
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        GroupAddUnit(_____5355_4F4D_7EC4, _____5355_4F4D)
    end
    return _____5355_4F4D_7EC4
end
____exports["单位是否在条形区域"] = function(_____5355_4F4D, _____8D77_70B9X, _____8D77_70B9Y, _____7EC8_70B9X, _____7EC8_70B9Y, _____5BBD_5EA6, _____5305_542B_8FB9_754C)
    if _____5305_542B_8FB9_754C == nil then
        _____5305_542B_8FB9_754C = true
    end
    if _____5BBD_5EA6 <= 0 then
        return false
    end
    local _____957F_5EA6 = _____8BA1_7B97_5750_6807_8DDD_79BB(_____8D77_70B9X, _____8D77_70B9Y, _____7EC8_70B9X, _____7EC8_70B9Y)
    if _____957F_5EA6 <= 0 then
        return false
    end
    local _____4E2D_5FC3X = (_____8D77_70B9X + _____7EC8_70B9X) / 2
    local _____4E2D_5FC3Y = (_____8D77_70B9Y + _____7EC8_70B9Y) / 2
    local _____65B9_5411X = (_____7EC8_70B9X - _____8D77_70B9X) / _____957F_5EA6
    local _____65B9_5411Y = (_____7EC8_70B9Y - _____8D77_70B9Y) / _____957F_5EA6
    return _____5355_4F4D_662F_5426_5728_5DF2_5F52_4E00_77E9_5F62_533A_57DF(
        _____5355_4F4D,
        _____4E2D_5FC3X,
        _____4E2D_5FC3Y,
        _____957F_5EA6 / 2,
        _____5BBD_5EA6 / 2,
        _____65B9_5411X,
        _____65B9_5411Y,
        _____5305_542B_8FB9_754C
    )
end
____exports["获取条形区域单位"] = function(_____53C2_6570)
    if _____53C2_6570["宽度"] <= 0 then
        return {}
    end
    local _____539F_957F_5EA6 = _____8BA1_7B97_5750_6807_8DDD_79BB(_____53C2_6570["起点X"], _____53C2_6570["起点Y"], _____53C2_6570["终点X"], _____53C2_6570["终点Y"])
    local _____957F_5EA6 = _____6309_82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63_4E0A_4E0B_6587_4FEE_6B63_8DDD_79BB(_____539F_957F_5EA6, _____53C2_6570["英雄技能距离修正"], "直线长度")
    if _____957F_5EA6 <= 0 then
        return {}
    end
    local _____65B9_5411X = _____539F_957F_5EA6 > 0 and (_____53C2_6570["终点X"] - _____53C2_6570["起点X"]) / _____539F_957F_5EA6 or 0
    local _____65B9_5411Y = _____539F_957F_5EA6 > 0 and (_____53C2_6570["终点Y"] - _____53C2_6570["起点Y"]) / _____539F_957F_5EA6 or 0
    local _____7EC8_70B9X = _____53C2_6570["起点X"] + _____65B9_5411X * _____957F_5EA6
    local _____7EC8_70B9Y = _____53C2_6570["起点Y"] + _____65B9_5411Y * _____957F_5EA6
    local _____4E2D_5FC3X = (_____53C2_6570["起点X"] + _____7EC8_70B9X) / 2
    local _____4E2D_5FC3Y = (_____53C2_6570["起点Y"] + _____7EC8_70B9Y) / 2
    local _____7C97_7B5B_534A_5F84 = _____8BA1_7B97_77E9_5F62_7C97_7B5B_534A_5F84(_____957F_5EA6, _____53C2_6570["宽度"])
    local _____5019_9009_5355_4F4D = getUnitsInRange(_____4E2D_5FC3X, _____4E2D_5FC3Y, _____7C97_7B5B_534A_5F84)
    local _____7ED3_679C = {}
    for ____, _____5355_4F4D in ipairs(_____5019_9009_5355_4F4D) do
        do
            local ____exports__5355_4F4D_662F_5426_5728_6761_5F62_533A_57DF_7 = ____exports["单位是否在条形区域"]
            local ____array_6 = __TS__SparseArrayNew(
                _____5355_4F4D,
                _____53C2_6570["起点X"],
                _____53C2_6570["起点Y"],
                _____7EC8_70B9X,
                _____7EC8_70B9Y,
                _____53C2_6570["宽度"]
            )
            local ____53C2_6570__5305_542B_8FB9_754C_5 = _____53C2_6570["包含边界"]
            if ____53C2_6570__5305_542B_8FB9_754C_5 == nil then
                ____53C2_6570__5305_542B_8FB9_754C_5 = true
            end
            __TS__SparseArrayPush(____array_6, ____53C2_6570__5305_542B_8FB9_754C_5)
            if not ____exports__5355_4F4D_662F_5426_5728_6761_5F62_533A_57DF_7(__TS__SparseArraySpread(____array_6)) then
                goto __continue28
            end
            if _____53C2_6570["单位筛选"] ~= nil and not _____53C2_6570["单位筛选"](_____5355_4F4D) then
                goto __continue28
            end
            _____7ED3_679C[#_____7ED3_679C + 1] = _____5355_4F4D
        end
        ::__continue28::
    end
    return _____7ED3_679C
end
____exports["创建条形单位组"] = function(_____53C2_6570)
    local _____5355_4F4D_7EC4 = CreateGroup()
    local _____5355_4F4D_5217_8868 = ____exports["获取条形区域单位"](_____53C2_6570)
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        GroupAddUnit(_____5355_4F4D_7EC4, _____5355_4F4D)
    end
    return _____5355_4F4D_7EC4
end
return ____exports
