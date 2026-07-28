local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local _____5267_60C5_8FD0_884C_65F6_5355_4F4D_8868 = {}
____exports["注册剧情运行时单位"] = function(_____8BED_4E49_540D, unit)
    if _____8BED_4E49_540D == "" or unit == nil or unit == 0 then
        return
    end
    _____5267_60C5_8FD0_884C_65F6_5355_4F4D_8868[_____8BED_4E49_540D] = unit
end
____exports["读取剧情运行时单位"] = function(_____8BED_4E49_540D)
    if _____8BED_4E49_540D == "" then
        return nil
    end
    local ____5267_60C5_8FD0_884C_65F6_5355_4F4D_8868______8BED_4E49_540D_0 = _____5267_60C5_8FD0_884C_65F6_5355_4F4D_8868[_____8BED_4E49_540D]
    if ____5267_60C5_8FD0_884C_65F6_5355_4F4D_8868______8BED_4E49_540D_0 == nil then
        ____5267_60C5_8FD0_884C_65F6_5355_4F4D_8868______8BED_4E49_540D_0 = nil
    end
    return ____5267_60C5_8FD0_884C_65F6_5355_4F4D_8868______8BED_4E49_540D_0
end
____exports["清理剧情运行时单位"] = function(_____8BED_4E49_540D)
    if _____8BED_4E49_540D == "" then
        return
    end
    _____5267_60C5_8FD0_884C_65F6_5355_4F4D_8868[_____8BED_4E49_540D] = nil
    __TS__Delete(_____5267_60C5_8FD0_884C_65F6_5355_4F4D_8868, _____8BED_4E49_540D)
end
return ____exports
