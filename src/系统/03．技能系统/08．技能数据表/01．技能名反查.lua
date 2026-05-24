local ____lualib = require("lualib_bundle")
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local ____exports = {}
local ____00_FF0E_6280_80FD_6570_636E_8868 = require("系统.03．技能系统.08．技能数据表.00．技能数据表")
local _____6280_80FD_6570_636E_8868 = ____00_FF0E_6280_80FD_6570_636E_8868["技能数据表"]
local function normalizeSkillName(name)
    local result = ""
    do
        local i = 0
        while i < #name do
            do
                local ch = __TS__StringCharAt(name, i)
                if ch == "\r" or ch == "\n" then
                    goto __continue4
                end
                if ch == "|" then
                    local next = __TS__StringCharAt(name, i + 1)
                    if next == "r" or next == "R" then
                        i = i + 1
                        goto __continue4
                    end
                    if next == "c" or next == "C" then
                        i = i + 9
                        goto __continue4
                    end
                end
                result = result .. ch
            end
            ::__continue4::
            i = i + 1
        end
    end
    return __TS__StringTrim(result)
end
____exports["创建技能名反查器"] = function(_____6570_636E_8868, _____5B57_6BB5_5217_8868)
    if _____5B57_6BB5_5217_8868 == nil then
        _____5B57_6BB5_5217_8868 = {"Name", "Untip", "Researchtip"}
    end
    return function(name)
        local normalized = normalizeSkillName(name)
        for ____, ____value in ipairs(__TS__ObjectEntries(_____6570_636E_8868)) do
            local abilityId = ____value[1]
            local data = ____value[2]
            if normalizeSkillName(abilityId) == normalized then
                return abilityId
            end
            local ____normalizeSkillName_1 = normalizeSkillName
            local ____data_ability_0 = data.ability
            if ____data_ability_0 == nil then
                ____data_ability_0 = ""
            end
            if ____normalizeSkillName_1(tostring(____data_ability_0)) == normalized then
                return abilityId
            end
            do
                local i = 0
                while i < #_____5B57_6BB5_5217_8868 do
                    local fieldName = _____5B57_6BB5_5217_8868[i + 1]
                    local fieldValue = data[fieldName]
                    if type(fieldValue) == "string" and normalizeSkillName(fieldValue) == normalized then
                        return abilityId
                    end
                    i = i + 1
                end
            end
        end
        return nil
    end
end
____exports["技能名反查器"] = ____exports["创建技能名反查器"](_____6280_80FD_6570_636E_8868)
____exports["按名字反查技能ID"] = function(name)
    return ____exports["技能名反查器"](name)
end
return ____exports
