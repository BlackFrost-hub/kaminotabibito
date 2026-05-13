local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
--- 形状区域 - 扇形区域
-- 
-- 说明：
-- 1. 先用圆形范围粗筛，再按“与中心方向的最小夹角”做扇形判定。
-- 2. 正确处理跨 0° / 360° 的扇形，不走 `a1~a2` 直接区间比较。
-- 3. 默认边界算命中。
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_0.getUnitsInRange
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local CreateGroup = jass.CreateGroup
local GroupAddUnit = jass.GroupAddUnit
local ____jglobals_bj_RADTODEG_1 = jglobals.bj_RADTODEG
if ____jglobals_bj_RADTODEG_1 == nil then
    ____jglobals_bj_RADTODEG_1 = 57.29577951308232
end
local bj_RADTODEG = ____jglobals_bj_RADTODEG_1
local function _____6807_51C6_5316_89D2_5EA6(_____89D2_5EA6)
    local _____7ED3_679C = _____89D2_5EA6
    while _____7ED3_679C < 0 do
        _____7ED3_679C = _____7ED3_679C + 360
    end
    while _____7ED3_679C >= 360 do
        _____7ED3_679C = _____7ED3_679C - 360
    end
    return _____7ED3_679C
end
local function _____7EDD_5BF9_503C(_____503C)
    return _____503C < 0 and -_____503C or _____503C
end
local function _____53D6_6700_5C0F_5939_89D2(_____89D2_5EA6A, _____89D2_5EA6B)
    local _____5DEE_503C = _____6807_51C6_5316_89D2_5EA6(_____89D2_5EA6A - _____89D2_5EA6B)
    if _____5DEE_503C > 180 then
        _____5DEE_503C = 360 - _____5DEE_503C
    end
    return _____7EDD_5BF9_503C(_____5DEE_503C)
end
local function _____53D6_5750_6807_671D_5411_89D2(_____6E90X, _____6E90Y, _____76EE_6807X, _____76EE_6807Y)
    return jass:Atan2(_____76EE_6807Y - _____6E90Y, _____76EE_6807X - _____6E90X) * bj_RADTODEG
end
____exports["单位是否在扇形区域"] = function(_____5355_4F4D, X, Y, _____534A_5F84, _____65B9_5411_89D2, _____6247_5F62_89D2_5EA6, _____5305_542B_8FB9_754C)
    if _____5305_542B_8FB9_754C == nil then
        _____5305_542B_8FB9_754C = true
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    if _____534A_5F84 <= 0 or _____6247_5F62_89D2_5EA6 <= 0 then
        return false
    end
    local _____5355_4F4DX = GetUnitX(_____5355_4F4D)
    local _____5355_4F4DY = GetUnitY(_____5355_4F4D)
    local dx = _____5355_4F4DX - X
    local dy = _____5355_4F4DY - Y
    local _____8DDD_79BB_5E73_65B9 = dx * dx + dy * dy
    local _____534A_5F84_5E73_65B9 = _____534A_5F84 * _____534A_5F84
    if _____8DDD_79BB_5E73_65B9 > _____534A_5F84_5E73_65B9 then
        return false
    end
    if _____8DDD_79BB_5E73_65B9 <= 0.0001 then
        return true
    end
    if _____6247_5F62_89D2_5EA6 >= 360 then
        return true
    end
    local _____4E2D_5FC3_65B9_5411 = _____6807_51C6_5316_89D2_5EA6(_____65B9_5411_89D2)
    local _____5355_4F4D_65B9_5411 = _____6807_51C6_5316_89D2_5EA6(_____53D6_5750_6807_671D_5411_89D2(X, Y, _____5355_4F4DX, _____5355_4F4DY))
    local _____534A_89D2 = _____6247_5F62_89D2_5EA6 / 2
    local _____5939_89D2 = _____53D6_6700_5C0F_5939_89D2(_____5355_4F4D_65B9_5411, _____4E2D_5FC3_65B9_5411)
    if _____5305_542B_8FB9_754C then
        return _____5939_89D2 <= _____534A_89D2
    end
    return _____5939_89D2 < _____534A_89D2
end
____exports["获取扇形区域单位"] = function(_____53C2_6570)
    if _____53C2_6570["半径"] <= 0 or _____53C2_6570["扇形角度"] <= 0 then
        return {}
    end
    local _____5019_9009_5355_4F4D = getUnitsInRange(_____53C2_6570.X, _____53C2_6570.Y, _____53C2_6570["半径"])
    local _____7ED3_679C = {}
    for ____, _____5355_4F4D in ipairs(_____5019_9009_5355_4F4D) do
        do
            local ____exports__5355_4F4D_662F_5426_5728_6247_5F62_533A_57DF_4 = ____exports["单位是否在扇形区域"]
            local ____array_3 = __TS__SparseArrayNew(
                _____5355_4F4D,
                _____53C2_6570.X,
                _____53C2_6570.Y,
                _____53C2_6570["半径"],
                _____53C2_6570["方向角"],
                _____53C2_6570["扇形角度"]
            )
            local ____53C2_6570__5305_542B_8FB9_754C_2 = _____53C2_6570["包含边界"]
            if ____53C2_6570__5305_542B_8FB9_754C_2 == nil then
                ____53C2_6570__5305_542B_8FB9_754C_2 = true
            end
            __TS__SparseArrayPush(____array_3, ____53C2_6570__5305_542B_8FB9_754C_2)
            if not ____exports__5355_4F4D_662F_5426_5728_6247_5F62_533A_57DF_4(__TS__SparseArraySpread(____array_3)) then
                goto __continue18
            end
            if _____53C2_6570["单位筛选"] ~= nil and not _____53C2_6570["单位筛选"](_____5355_4F4D) then
                goto __continue18
            end
            _____7ED3_679C[#_____7ED3_679C + 1] = _____5355_4F4D
        end
        ::__continue18::
    end
    return _____7ED3_679C
end
____exports["创建扇形单位组"] = function(_____53C2_6570)
    local _____5355_4F4D_7EC4 = CreateGroup()
    local _____5355_4F4D_5217_8868 = ____exports["获取扇形区域单位"](_____53C2_6570)
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        GroupAddUnit(_____5355_4F4D_7EC4, _____5355_4F4D)
    end
    return _____5355_4F4D_7EC4
end
return ____exports
