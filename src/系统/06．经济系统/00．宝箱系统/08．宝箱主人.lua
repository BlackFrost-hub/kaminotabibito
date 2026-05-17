--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetDestructableX = jass.GetDestructableX
local GetDestructableY = jass.GetDestructableY
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_0.getUnitsInRange
local function stringToFourCC(s)
    local a = #s > 0 and (string.byte(s, 1) or 0 / 0) or 0
    local b = #s > 1 and (string.byte(s, 2) or 0 / 0) or 0
    local c = #s > 2 and (string.byte(s, 3) or 0 / 0) or 0
    local d = #s > 3 and (string.byte(s, 4) or 0 / 0) or 0
    return a * 16777216 + b * 65536 + c * 256 + d
end
local function _____53D6_641C_7D22_534A_5F84(_____914D_7F6E, _____9636_6BB5)
    local _____4E3B_4EBA_914D_7F6E = _____914D_7F6E["主人配置"]
    if not _____4E3B_4EBA_914D_7F6E then
        return 0
    end
    return _____9636_6BB5 == "准备开启" and _____4E3B_4EBA_914D_7F6E["准备开启搜索半径"] or _____4E3B_4EBA_914D_7F6E["开启完成搜索半径"]
end
____exports["查找宝箱主人"] = function(_____914D_7F6E, _____53C2_8003_5B9D_7BB1, _____9636_6BB5)
    if not (_____914D_7F6E and _____914D_7F6E["主人配置"]) or not _____53C2_8003_5B9D_7BB1 then
        return nil
    end
    local _____641C_7D22_534A_5F84 = _____53D6_641C_7D22_534A_5F84(_____914D_7F6E, _____9636_6BB5)
    if _____641C_7D22_534A_5F84 <= 0 then
        return nil
    end
    local _____76EE_6807_5355_4F4D_7C7B_578B = stringToFourCC(_____914D_7F6E["主人配置"]["单位类型"])
    local _____53C2_8003x = GetDestructableX(_____53C2_8003_5B9D_7BB1)
    local _____53C2_8003y = GetDestructableY(_____53C2_8003_5B9D_7BB1)
    local _____6700_8FD1_5355_4F4D
    local _____6700_8FD1_8DDD_79BB_5E73_65B9 = 0
    local _____5355_4F4D_5217_8868 = getUnitsInRange(_____53C2_8003x, _____53C2_8003y, _____641C_7D22_534A_5F84)
    do
        local i = 0
        while i < #_____5355_4F4D_5217_8868 do
            do
                local _____679A_4E3E_5355_4F4D = _____5355_4F4D_5217_8868[i + 1]
                if GetUnitTypeId(_____679A_4E3E_5355_4F4D) ~= _____76EE_6807_5355_4F4D_7C7B_578B then
                    goto __continue9
                end
                local dx = GetUnitX(_____679A_4E3E_5355_4F4D) - _____53C2_8003x
                local dy = GetUnitY(_____679A_4E3E_5355_4F4D) - _____53C2_8003y
                local _____8DDD_79BB_5E73_65B9 = dx * dx + dy * dy
                if not _____6700_8FD1_5355_4F4D or _____8DDD_79BB_5E73_65B9 < _____6700_8FD1_8DDD_79BB_5E73_65B9 then
                    _____6700_8FD1_5355_4F4D = _____679A_4E3E_5355_4F4D
                    _____6700_8FD1_8DDD_79BB_5E73_65B9 = _____8DDD_79BB_5E73_65B9
                end
            end
            ::__continue9::
            i = i + 1
        end
    end
    return _____6700_8FD1_5355_4F4D
end
____exports.resolveChestOwner = ____exports["查找宝箱主人"]
return ____exports
