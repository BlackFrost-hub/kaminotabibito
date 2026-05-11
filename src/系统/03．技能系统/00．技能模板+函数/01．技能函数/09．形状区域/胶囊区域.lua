local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
--- 形状区域 - 胶囊形 / 线段宽度区域
-- 
-- 说明：
-- 1. 形状等价于“中间一段线 + 两端半圆”。
-- 2. 适合检测“沿路径扫过、但到结算时只看是否仍停留在路径宽度内”的目标。
-- 3. 先以线段中点粗筛，再做投影精判。
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_0.getUnitsInRange
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local CreateGroup = jass.CreateGroup
local GroupAddUnit = jass.GroupAddUnit
local function _____8BA1_7B97_5E73_65B9_6839(_____503C)
    return jass.SquareRoot(_____503C)
end
local function _____8BA1_7B97_5750_6807_8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return _____8BA1_7B97_5E73_65B9_6839(dx * dx + dy * dy)
end
local function _____5355_4F4D_662F_5426_5728_7EBF_6BB5_5BBD_5EA6_533A_57DF_5185_90E8(_____5355_4F4D, _____8D77_70B9X, _____8D77_70B9Y, _____7EC8_70B9X, _____7EC8_70B9Y, _____534A_5BBD, _____5305_542B_8FB9_754C)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    if _____534A_5BBD <= 0 then
        return false
    end
    local _____7EBF_6BB5X = _____7EC8_70B9X - _____8D77_70B9X
    local _____7EBF_6BB5Y = _____7EC8_70B9Y - _____8D77_70B9Y
    local _____7EBF_6BB5_957F_5EA6_5E73_65B9 = _____7EBF_6BB5X * _____7EBF_6BB5X + _____7EBF_6BB5Y * _____7EBF_6BB5Y
    if _____7EBF_6BB5_957F_5EA6_5E73_65B9 <= 0.0001 then
        local dx = GetUnitX(_____5355_4F4D) - _____8D77_70B9X
        local dy = GetUnitY(_____5355_4F4D) - _____8D77_70B9Y
        local _____8DDD_79BB_5E73_65B9 = dx * dx + dy * dy
        local _____534A_5BBD_5E73_65B9 = _____534A_5BBD * _____534A_5BBD
        local _____5305_542B_8FB9_754C_1
        if _____5305_542B_8FB9_754C then
            _____5305_542B_8FB9_754C_1 = _____8DDD_79BB_5E73_65B9 <= _____534A_5BBD_5E73_65B9
        else
            _____5305_542B_8FB9_754C_1 = _____8DDD_79BB_5E73_65B9 < _____534A_5BBD_5E73_65B9
        end
        return _____5305_542B_8FB9_754C_1
    end
    local _____70B9X = GetUnitX(_____5355_4F4D)
    local _____70B9Y = GetUnitY(_____5355_4F4D)
    local _____5230_8D77_70B9X = _____70B9X - _____8D77_70B9X
    local _____5230_8D77_70B9Y = _____70B9Y - _____8D77_70B9Y
    local _____6295_5F71_6BD4_4F8B = (_____5230_8D77_70B9X * _____7EBF_6BB5X + _____5230_8D77_70B9Y * _____7EBF_6BB5Y) / _____7EBF_6BB5_957F_5EA6_5E73_65B9
    if _____6295_5F71_6BD4_4F8B < 0 then
        _____6295_5F71_6BD4_4F8B = 0
    elseif _____6295_5F71_6BD4_4F8B > 1 then
        _____6295_5F71_6BD4_4F8B = 1
    end
    local _____6700_8FD1_70B9X = _____8D77_70B9X + _____7EBF_6BB5X * _____6295_5F71_6BD4_4F8B
    local _____6700_8FD1_70B9Y = _____8D77_70B9Y + _____7EBF_6BB5Y * _____6295_5F71_6BD4_4F8B
    local dx = _____70B9X - _____6700_8FD1_70B9X
    local dy = _____70B9Y - _____6700_8FD1_70B9Y
    local _____8DDD_79BB_5E73_65B9 = dx * dx + dy * dy
    local _____534A_5BBD_5E73_65B9 = _____534A_5BBD * _____534A_5BBD
    if _____5305_542B_8FB9_754C then
        return _____8DDD_79BB_5E73_65B9 <= _____534A_5BBD_5E73_65B9
    end
    return _____8DDD_79BB_5E73_65B9 < _____534A_5BBD_5E73_65B9
end
____exports["单位是否在胶囊区域"] = function(_____5355_4F4D, _____8D77_70B9X, _____8D77_70B9Y, _____7EC8_70B9X, _____7EC8_70B9Y, _____5BBD_5EA6, _____5305_542B_8FB9_754C)
    if _____5305_542B_8FB9_754C == nil then
        _____5305_542B_8FB9_754C = true
    end
    return _____5355_4F4D_662F_5426_5728_7EBF_6BB5_5BBD_5EA6_533A_57DF_5185_90E8(
        _____5355_4F4D,
        _____8D77_70B9X,
        _____8D77_70B9Y,
        _____7EC8_70B9X,
        _____7EC8_70B9Y,
        _____5BBD_5EA6 / 2,
        _____5305_542B_8FB9_754C
    )
end
____exports["获取胶囊区域单位"] = function(_____53C2_6570)
    if _____53C2_6570["宽度"] <= 0 then
        return {}
    end
    local _____4E2D_5FC3X = (_____53C2_6570["起点X"] + _____53C2_6570["终点X"]) / 2
    local _____4E2D_5FC3Y = (_____53C2_6570["起点Y"] + _____53C2_6570["终点Y"]) / 2
    local _____7EBF_6BB5_957F_5EA6 = _____8BA1_7B97_5750_6807_8DDD_79BB(_____53C2_6570["起点X"], _____53C2_6570["起点Y"], _____53C2_6570["终点X"], _____53C2_6570["终点Y"])
    local _____7C97_7B5B_534A_5F84 = _____7EBF_6BB5_957F_5EA6 / 2 + _____53C2_6570["宽度"] / 2
    local _____5019_9009_5355_4F4D = getUnitsInRange(_____4E2D_5FC3X, _____4E2D_5FC3Y, _____7C97_7B5B_534A_5F84)
    local _____7ED3_679C = {}
    for ____, _____5355_4F4D in ipairs(_____5019_9009_5355_4F4D) do
        do
            local ____exports__5355_4F4D_662F_5426_5728_80F6_56CA_533A_57DF_4 = ____exports["单位是否在胶囊区域"]
            local ____array_3 = __TS__SparseArrayNew(
                _____5355_4F4D,
                _____53C2_6570["起点X"],
                _____53C2_6570["起点Y"],
                _____53C2_6570["终点X"],
                _____53C2_6570["终点Y"],
                _____53C2_6570["宽度"]
            )
            local ____53C2_6570__5305_542B_8FB9_754C_2 = _____53C2_6570["包含边界"]
            if ____53C2_6570__5305_542B_8FB9_754C_2 == nil then
                ____53C2_6570__5305_542B_8FB9_754C_2 = true
            end
            __TS__SparseArrayPush(____array_3, ____53C2_6570__5305_542B_8FB9_754C_2)
            if not ____exports__5355_4F4D_662F_5426_5728_80F6_56CA_533A_57DF_4(__TS__SparseArraySpread(____array_3)) then
                goto __continue14
            end
            if _____53C2_6570["单位筛选"] ~= nil and not _____53C2_6570["单位筛选"](_____5355_4F4D) then
                goto __continue14
            end
            _____7ED3_679C[#_____7ED3_679C + 1] = _____5355_4F4D
        end
        ::__continue14::
    end
    return _____7ED3_679C
end
____exports["创建胶囊单位组"] = function(_____53C2_6570)
    local _____5355_4F4D_7EC4 = CreateGroup()
    local _____5355_4F4D_5217_8868 = ____exports["获取胶囊区域单位"](_____53C2_6570)
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        GroupAddUnit(_____5355_4F4D_7EC4, _____5355_4F4D)
    end
    return _____5355_4F4D_7EC4
end
return ____exports
