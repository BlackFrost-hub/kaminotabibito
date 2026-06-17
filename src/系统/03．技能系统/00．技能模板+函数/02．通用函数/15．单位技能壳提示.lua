--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local japi = require("jass.japi")
local DzSetUnitAbilityTip = japi.DzSetUnitAbilityTip
local DzSetUnitAbilityUpdate = japi.DzSetUnitAbilityUpdate
local function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
____exports["设置单位技能壳普通提示"] = function(_____5355_4F4D, _____914D_7F6E_5217_8868)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    if type(DzSetUnitAbilityTip) ~= "function" then
        return
    end
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            do
                local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
                if _____914D_7F6E["技能ID"] == nil or #_____914D_7F6E["技能ID"] < 4 or _____914D_7F6E["提示"] == "" then
                    goto __continue7
                end
                local _____6280_80FDID = stringToFourCC(_____914D_7F6E["技能ID"])
                DzSetUnitAbilityTip(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["提示"])
                if type(DzSetUnitAbilityUpdate) == "function" then
                    DzSetUnitAbilityUpdate(_____5355_4F4D, _____6280_80FDID)
                end
            end
            ::__continue7::
            i = i + 1
        end
    end
end
return ____exports
